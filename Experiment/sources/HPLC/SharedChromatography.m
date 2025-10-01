(* ::Package:: *)

(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Source Code*)

(* ::Subsection:: *)
(*resolveChromatographyStandardsAndBlanks*)

(* ::Subsubsection::Closed:: *)
(*Options*)

DefineOptions[
  resolveChromatographyStandardsAndBlanks,
  Options:>{
    CacheOption,
    OutputOption
  }
];

Error::InjectionTableForeignSamples="InjectionTable contains sample analytes that do not correspond to input samples. The order and repetition from the input sample list must accord to the InjectionTable Sample order.";
Error::InjectionTableForeignBlanks="InjectionTable contains blank entries that do not correspond to the `1` option(s). Considering letting these option(s) set automatically.";
Error::InjectionTableForeignStandards="InjectionTable contains standard entries that do not correspond to the `1` option(s). Considering letting these option(s) set automatically.";
Error::StandardOptionsButNoFrequency="StandardFrequency cannot be None, if other Standard options `1` are set.";
Error::StandardFrequencyNoStandards="StandardFrequency cannot be set, if Standard is Null.";
Error::StandardsButNoFrequency="StandardFrequency cannot be None, if Standard is set.";
Error::BlankOptionsButNoFrequency="BlankFrequency cannot be None, if other Blank options `1` are set.";
Error::BlankFrequencyNoBlanks="BlankFrequency cannot be set, if Blank is Null.";
Error::BlanksButNoFrequency="BlankFrequency cannot be None, if Blank is set.";
Error::InjectionTableStandardFrequencyConflict="The specified InjectionTable and StandardFrequency do not match. Consider specifying only one and not the other.";
Error::InjectionTableStandardConflict="The specified InjectionTable and Standard do not match. Consider specifying only one and not the other.";
Error::InjectionTableBlankFrequencyConflict="The specified InjectionTable and BlankFrequency do not match. Consider specifying only one and not the other.";
Error::InjectionTableBlankConflict="The specified InjectionTable and Blank do not match. Consider specifying only one and not the other.";
Error::GradientShortcutConflict="When `1` option is specified, its corresponding `2` options cannot be used in combination with `3` A/B/C/D options.";
Warning::GradientShortcutAmbiguity="Gradient shortcut options are specified in both `1` and `2` A/B/C/D options but they conflict with each other. The experiment will commence as directed with the latter value(s). Please verify the resolved gradients in the submitted protocol are desired.";
Warning::GradientAmbiguity="Full gradients were defined for the options: `1` which conflict with the specified, adjacent GradientA/B/C/D and FlowRate options. Consider only defining `1` and not the corresponding GradientA/B/C/D and FlowRate options.";
Error::GradientOutOfOrder="The gradient table(s) in `1` are not in ascending time order. Please reorder the entries accordingly.";
Warning::GradientNotReequilibrated="The gradients occurring before the sample injections, do not reequilibrate the gradient. This may lead to the analyte prematurely eluting. Consider setting ColumnRefreshFrequency -> 1.";
Error::InvalidGradientComposition="The specified gradient buffer compositions for analyte(s) at index `1` do not sum to 100% at all timepoints.";
(* This message is thrown in ExperimentHPLC for ExperimentLCMS only. Currently, no binary HPLC instruments are supported in stand-alone HPLC protocol *)
Error::NonBinaryHPLC="The selected instrument can only have nonbinary gradients. The following gradient options have nonbinary profiles (e.g. both A and C percents are non-zero, or B and D): `1`. Please modify the gradient options such that only one buffer is non-zero at any time point.";

(* ::Subsubsection::Closed:: *)
(*Source Code*)

(*This is a shared function used by ExperimentSFC (soon HPLC, FPLC, GCMS, LCMS, and others likely) to resolved the standard, blank, and their frequency related options*)
(*It assumes that the options InjectionTable, Standard, Blank, StandardFrequency, and BlankFrequency are passed*)

resolveChromatographyStandardsAndBlanks[
  mySamples:ListableP[ObjectP[Object[Sample]]],
  experimentOptions:_Association,
  (*specify whether standards should exist*)
  standardExistsQ:BooleanP,
  (*specify the default standard, should they exist*)
  defaultStandard:ObjectP[Model[Sample]],
  (*specify whether blanks should exist*)
  blankExistsQ:BooleanP,
  (*specify the default blnak, should they exist*)
  defaultBlank:(ObjectP[Model[Sample]]|GCBlankTypeP),
  myOptions:OptionsPattern[]
]:=Module[
  {safeOps,outputSpecification,cache,output,gatherTestsQ, messagesQ,testOrNull,injectionTableLookup,
    standardFrequencyLookup, standardLookup, blankFrequencyLookup, blankLookup, templateLookup,
    injectionTableSpecifiedQ,templateSpecifiedQ,resolvedStandardFrequency,resolvedStandard,standardFrequencyConflictQ,
    standardTableConflictQ,resolvedBlankFrequency,resolvedBlank,blankFrequencyConflictQ,blankTableConflictQ,
    foreignSamplesOptions,foreignSamplesTest,injectionTableSampleConflictQ,collapsedResolvedBlank, collapsedResolvedStandard,
    injectionTableDereferenced, standardDereferenced, blankDereferenced,resolvedOptions, invalidOptions, resultRule, testsRule,
    standardFrequencyConflictTest, standardTableConflictTest, standardFrequencyConflictOptions, standardTableConflictOptions,
    blankFrequencyConflictTest, blankTableConflictTest, blankFrequencyConflictOptions,blankTableConflictOptions,
    standardFrequencyNoStandardsQ, noStandardsButFrequencyQ, standardFrequencyNoStandardsOptions, standardFrequencyNoStandardsTest,
    noStandardsButFrequencyOptions, noStandardsButFrequencyTest, blankFrequencyNoBlanksQ, noBlanksButFrequencyQ,
    blankFrequencyNoBlanksOptions, blankFrequencyNoBlanksTest, noBlanksButFrequencyOptions, noBlanksButFrequencyTest,
    invalidTests
  },

  (* get the safe options *)
  safeOps = SafeOptions[resolveChromatographyStandardsAndBlanks, ToList[myOptions]];

  (* get the output specification/output and cache options *)
  {outputSpecification, cache} = Lookup[safeOps, {Output, Cache}];
  output = ToList[outputSpecification];

  (* figure out if we are gathering tests or not *)
  gatherTestsQ = MemberQ[output, Tests];
  messagesQ = Not[gatherTestsQ];

  (*helper function for making the ValidQ tests*)
  testOrNull[testDescription_String,passQ:BooleanP]:=If[gatherTestsQ,
    Test[testDescription,True,Evaluate[passQ]],
    Null
  ];

  (*look up the pertinent options*)
  {
    injectionTableLookup,
    standardFrequencyLookup,
    standardLookup,
    blankFrequencyLookup,
    blankLookup,
    templateLookup
  }=Lookup[experimentOptions,{InjectionTable,StandardFrequency,Standard,BlankFrequency,Blank,Template}];

  (*is the injection specified (meaning that it has tuples within it)?*)
  injectionTableSpecifiedQ=MatchQ[injectionTableLookup,Except[Automatic]];

  (*dereference the injection table, standard, blank samples into objects *)
  injectionTableDereferenced=If[injectionTableSpecifiedQ,
    MapThread[
      Function[{type,sample},
        {
          type,
          If[MatchQ[sample, ObjectP[]], Download[sample, Object],sample]
        }
      ],
      (* Note that InjectionTable options are in different format for HPLC/LCMS vs FPLC/SFC/GC/... because HPLC now allows ColumnPosition for column selector. However, for all the option defintions, {1,2} are sample type and sample ID *)
      Transpose@(injectionTableLookup[[All,{1,2}]])
    ]
  ];
  standardDereferenced=ToList[standardLookup/.{x:ObjectP[]:>Download[x,Object]}];
  blankDereferenced=ToList[blankLookup/.{x:ObjectP[]:>Download[x,Object]}];

  (* check whether we have conflicts between standardFrequency and standards*)
  {noStandardsButFrequencyQ,standardFrequencyNoStandardsQ}=Switch[{standardLookup,standardFrequencyLookup},
    (*if there are standards, StandardFrequency can only be null if there's an injection table*)
    {ListableP[ObjectP[]],Null},{!injectionTableSpecifiedQ,False},
    {ListableP[ObjectP[]],None|Infinity},{True,False},
    {Null,Except[None|Null|Infinity|Automatic]},{False,True},
    _,{False,False}
  ];

  (*do our error checking and test*)
  {standardFrequencyNoStandardsOptions,standardFrequencyNoStandardsTest} = If[standardFrequencyNoStandardsQ,
    (
      If[messagesQ,
        Message[Error::StandardFrequencyNoStandards]
      ];
      {{StandardFrequency,Standard},testOrNull["StandardFrequency is set negatively when the Standard option is Null:",False]}
    ),
    {{},testOrNull["StandardFrequency is set negatively when the Standard option is Null:",True]}
  ];

  {noStandardsButFrequencyOptions,noStandardsButFrequencyTest} = If[noStandardsButFrequencyQ,
    (
      If[messagesQ,
        Message[Error::StandardsButNoFrequency]
      ];
      {{StandardFrequency,Standard},testOrNull["StandardFrequency is set positively when the Standard option is not Null:",False]}
    ),
    {{},testOrNull["StandardFrequency is set positively when the Standard option is not Null:",True]}
  ];

  (* check whether we have conflicts between blankFrequency and blanks*)
  {noBlanksButFrequencyQ,blankFrequencyNoBlanksQ}=Switch[{blankLookup,blankFrequencyLookup},
    (*if there are blanks, BlankFrequency can only be null if there's an injection table*)
    {ListableP[ObjectP[]],Null},{!injectionTableSpecifiedQ,False},
    {ListableP[ObjectP[]],None|Infinity},{True,False},
    {Null,Except[Null|None|Infinity|Automatic]},{False,True},
    _,{False,False}
  ];

  (*do our error checking and test*)
  {blankFrequencyNoBlanksOptions,blankFrequencyNoBlanksTest} = If[blankFrequencyNoBlanksQ,
    (
      If[messagesQ,
        Message[Error::BlankFrequencyNoBlanks]
      ];
      {{BlankFrequency,Blank},testOrNull["BlankFrequency is set negatively when the Blank option is Null:",False]}
    ),
    {{},testOrNull["BlankFrequency is set negatively when the Blank option is Null:",True]}
  ];

  {noBlanksButFrequencyOptions,noBlanksButFrequencyTest} = If[noBlanksButFrequencyQ,
    (
      If[messagesQ,
        Message[Error::BlanksButNoFrequency]
      ];
      {{BlankFrequency,Blank},testOrNull["BlankFrequency is set positively when the Blank option is not Null:",False]}
    ),
    {{},testOrNull["BlankFrequency is set positively when the Blank option is not Null:",True]}
  ];

  (*check whether the template option was specified, in which case, we don't throw the error for conflicts with Standard/BlankFrequency and the InjectionTable*)
  templateSpecifiedQ=MatchQ[templateLookup,Except[Null|Automatic]];

  (*now we must resolve the standard frequency and standard together*)
  {resolvedStandardFrequency,resolvedStandard,standardFrequencyConflictQ,standardTableConflictQ}=Switch[
    (*switch based on the frequency, standard, and the injection table tuples*)
    {standardFrequencyLookup,standardLookup,injectionTableSpecifiedQ},
    (*check if everything was specified*)
    {Except[Automatic|Null],Except[ListableP[Automatic]],True},
    {
      standardFrequencyLookup,
      Module[{specifiedStandard,injectionTableStandards,injectionTableStandardsCongruentLength},
        specifiedStandard=ToList[standardLookup];
        (*get all of the injection table blanks*)
        injectionTableStandards=Cases[injectionTableDereferenced,{Standard, ___}][[All,2]];
        (*make these the same lengths*)
        injectionTableStandardsCongruentLength=Switch[Length[injectionTableStandards],
          (*if the same length, then keep it*)
          Length[specifiedStandard],injectionTableStandards,
          (*if shorter, pad with automatics*)
          LessP[Length[specifiedStandard]],PadRight[injectionTableStandards,Length[specifiedStandard],Automatic],
          (*otherwise, take the first subset*)
          _,Take[injectionTableStandards,Length[specifiedStandard]]
        ];

        (*map through and fill any automatics; return our resolved standards*)
        MapThread[Function[{standard,injectionTableStandard},
          Switch[{standard,injectionTableStandard},
            (*if blank is specified, take it*)
            {ObjectP[],_},standard,
            (*otherwise, if the injection table one is, then take that*)
            {_,ObjectP[]},injectionTableStandard,
            (*if both are automatic, take the default*)
            _,defaultStandard
          ]
        ],{specifiedStandard,injectionTableStandardsCongruentLength}]
      ],
      (*unless it's a template, we throw an error*)
      !templateSpecifiedQ,
      (*make sure that the specified standards are part of the injection table and vice versa; otherwise, should be Null*)
      !Or[
        And[
          Length[Complement[Cases[injectionTableDereferenced,{Standard, ___}][[All,2]],standardDereferenced]] == 0,
          Length[Complement[standardDereferenced,Cases[injectionTableDereferenced,{Standard, ___}][[All,2]]]] == 0
        ],
        NullQ[standardLookup]&&(Count[injectionTableLookup,{Standard, ___}]==0)
      ]
    },
    (*then check whether the injection table was specified and that the standard frequency was specified as something else. if so we return an error, but of course we have to resolve standard too*)
    {Except[Automatic|Null],_,True},
    {
      standardFrequencyLookup,
      (*grab from the injection table in this case*)
      If[standardExistsQ,Cases[injectionTableLookup,{Standard, ___}][[All,2]],{Null}],
      (*unless it's a template, we throw an error*)
      !templateSpecifiedQ,
      False
    },
    (*check whether the standard and the injection table standards are compatible*)
    {_,Except[ListableP[Automatic]],True},
    {
      (*if there is an injection table we default to Null*)
      Null,
      Module[{specifiedStandard,injectionTableStandards,injectionTableStandardsCongruentLength},
        specifiedStandard=ToList[standardLookup];
        (*get all of the injection table blanks*)
        injectionTableStandards=Cases[injectionTableDereferenced,{Standard, ___}][[All,2]];
        (*make these the same lengths*)
        injectionTableStandardsCongruentLength=Switch[Length[injectionTableStandards],
          (*if the same length, then keep it*)
          Length[specifiedStandard],injectionTableStandards,
          (*if shorter, pad with automatics*)
          LessP[Length[specifiedStandard]],PadRight[injectionTableStandards,Length[specifiedStandard],Automatic],
          (*otherwise, take the first subset*)
          _,Take[injectionTableStandards,Length[specifiedStandard]]
        ];

        (*map through and fill any automatics; return our resolved standards*)
        MapThread[Function[{standard,injectionTableStandard},
          Switch[{standard,injectionTableStandard},
            (*if blank is specified, take it*)
            {ObjectP[],_},standard,
            (*otherwise, if the injection table one is, then take that*)
            {_,ObjectP[]},injectionTableStandard,
            (*if both are automatic, take the default*)
            _,defaultStandard
          ]
        ],{specifiedStandard,injectionTableStandardsCongruentLength}]
      ],
      False,
      (*make sure that the specified standards are part of the injection table and vice versa; otherwise, should be Null*)
      !Or[
        And[
          Length[Complement[Cases[injectionTableDereferenced,{Standard, ___}][[All,2]],standardDereferenced]] == 0,
          Length[Complement[standardDereferenced,Cases[injectionTableDereferenced,{Standard, ___}][[All,2]]]] == 0
        ],
        NullQ[standardLookup]&&(Count[injectionTableLookup,{Standard, ___}]==0)
      ]
    },
    (*if the injection table is only specified, then draw from there*)
    {_,_,True},
    {
      Null,
      (*if we have standards in the injection table, then we need to resolve the automatics*)
      Module[{injectionTableStandards,standardToUse},

        (*get the injection table standards*)
        injectionTableStandards=Cases[injectionTableLookup,{Standard, ___}][[All,2]];

        (*get the first sensible one otherwise we default to the standard standard*)
        standardToUse=FirstOrDefault[Cases[injectionTableStandards,ObjectP[]],defaultStandard];

        (*map through and resolve any automatics in our injection table*)
        Map[If[MatchQ[#,Automatic],standardToUse,#]&,injectionTableStandards]
      ],
      False,
      False
    },
    _,
    (*otherwise, we resolve in tandem*)
    {
      If[MatchQ[standardFrequencyLookup,Except[Automatic]],
        standardFrequencyLookup,
        If[standardExistsQ,FirstAndLast,Null]
      ],
      If[MatchQ[standardLookup,Except[ListableP[Automatic]]],
        (*we fill any automatics with the default*)
        Map[If[MatchQ[#,Automatic],defaultStandard,#]&,ToList@standardLookup],
        If[standardExistsQ,defaultStandard,Null]
      ],
      False,
      False
    }
  ];

  (*now we must resolve the blank frequency and blank together*)
  {resolvedBlankFrequency,resolvedBlank,blankFrequencyConflictQ,blankTableConflictQ}=Switch[
    (*switch based on the frequency, blank, and the injection table tuples*)
    {blankFrequencyLookup,blankLookup,injectionTableSpecifiedQ},
    {Except[Automatic|Null],Except[ListableP[Automatic]],True},
    {
      blankFrequencyLookup,
      (*we have to check if this list is partially specified, in which case we fill in from the injection table if possible*)
      Module[{specifiedBlank,injectionTableBlanks,injectionTableBlanksCongruentLength},
        specifiedBlank=ToList[blankLookup];
        (*get all of the injection table blanks*)
        injectionTableBlanks=Cases[injectionTableDereferenced,{Blank, ___}][[All,2]];
        (*make these the same lengths*)
        injectionTableBlanksCongruentLength=Switch[Length[injectionTableBlanks],
          (*if the same length, then keep it*)
          Length[specifiedBlank],injectionTableBlanks,
          (*if shorter, pad with automatics*)
          LessP[Length[specifiedBlank]],PadRight[injectionTableBlanks,Length[specifiedBlank],Automatic],
          (*otherwise, take the first subset*)
          _,Take[injectionTableBlanks,Length[specifiedBlank]]
        ];

        (*map through and fill any automatics; return our resolved blanks*)
        MapThread[Function[{blank,injectionTableBlank},
          Switch[{blank,injectionTableBlank},
            (*if blank is specified, take it*)
            {ObjectP[],_},blank,
            (*otherwise, if the injection table one is, then take that*)
            {_,ObjectP[]},injectionTableBlank,
            (*if both are automatic, take the default*)
            _,defaultBlank
          ]
        ],{specifiedBlank,injectionTableBlanksCongruentLength}]
      ],
      (*unless it's a template, we throw an error*)
      !templateSpecifiedQ,
      (*make sure that the specified blanks are part of the injection table and vice versa; otherwise, should be Null*)
      !Or[
        And[
          Length[Complement[Cases[injectionTableDereferenced,{Blank, ___}][[All,2]],blankDereferenced]] == 0,
          Length[Complement[blankDereferenced,Cases[injectionTableDereferenced,{Blank, ___}][[All,2]]]] == 0
        ],
        NullQ[blankLookup]&&(Count[injectionTableLookup,{Blank, ___}]==0)
      ]

    },
    (*then check whether the injection table was specified and that the blank frequency was specified as something else. if so we return an error, but of course we have to resolve blank too*)
    {Except[Automatic|Null],_,True},
    {
      blankFrequencyLookup,
      If[blankExistsQ,Cases[injectionTableLookup,{Blank, ___}][[All,2]],{Null}],
      (*unless it's a template, we throw an error*)
      !templateSpecifiedQ,
      False
    },
    (*check whether the blank and the injection table blanks are compatible*)
    {_,Except[ListableP[Automatic]],True},
    {
      Null,
      Module[{specifiedBlank,injectionTableBlanks,injectionTableBlanksCongruentLength},
        specifiedBlank=ToList[blankLookup];
        (*get all of the injection table blanks*)
        injectionTableBlanks=Cases[injectionTableDereferenced,{Blank, ___}][[All,2]];
        (*make these the same lengths*)
        injectionTableBlanksCongruentLength=Switch[Length[injectionTableBlanks],
          (*if the same length, then keep it*)
          Length[specifiedBlank],injectionTableBlanks,
          (*if shorter, pad with automatics*)
          LessP[Length[specifiedBlank]],PadRight[injectionTableBlanks,Length[specifiedBlank],Automatic],
          (*otherwise, take the first subset*)
          _,Take[injectionTableBlanks,Length[specifiedBlank]]
        ];

        (*map through and fill any automatics; return our resolved blanks*)
        MapThread[Function[{blank,injectionTableBlank},
          Switch[{blank,injectionTableBlank},
            (*if blank is specified, take it*)
            {ObjectP[],_},blank,
            (*otherwise, if the injection table one is, then take that*)
            {_,ObjectP[]},injectionTableBlank,
            (*if both are automatic, take the default*)
            _,defaultBlank
          ]
        ],{specifiedBlank,injectionTableBlanksCongruentLength}]
      ],
      False,
      (*make sure that the specified blanks are part of the injection table or both are free of Blanks, we must change any blanks specified as NoInjection to Null samples*)
      !Or[
        And[
          Length[Complement[Cases[injectionTableDereferenced,{Blank, ___}][[All,2]],blankDereferenced/. {NoInjection -> Null}]] == 0,
          Length[Complement[blankDereferenced/. {NoInjection -> Null},Cases[injectionTableDereferenced,{Blank, ___}][[All,2]]]] == 0
        ],
        NullQ[blankLookup]&&(Count[injectionTableLookup,{Blank, ___}]==0)
      ]
    },
    (*if the injection table is only specified, then draw from there*)
    {_,_,True},
    {
      Null,
      (*if the blank frequency is an integer, we should only take the subset that's replicated*)
      (*if we have blanks in the injection table, then we need to resolve the automatics*)
      Module[{injectionTableBlanks,blankToUse},

        (*get the injection table blanks*)
        injectionTableBlanks=Cases[injectionTableLookup,{Blank, ___}][[All,2]];

        (*get the first sensible one otherwise we default to the blank default*)
        blankToUse=FirstOrDefault[Cases[injectionTableBlanks,ObjectP[]],defaultBlank];

        (*map through and resolve any automatics*)
        Map[If[MatchQ[#,Automatic],blankToUse,#]&,injectionTableBlanks]
      ],
      False,
      False
    },
    _,
    (*otherwise, we resolve in tandem*)
    {
      If[MatchQ[blankFrequencyLookup,Except[Automatic]],
        blankFrequencyLookup,
        If[blankExistsQ,FirstAndLast,Null]
      ],
      If[MatchQ[blankLookup,Except[ListableP[Automatic]]],
        (*we fill any automatics with the default*)
        Map[If[MatchQ[#,Automatic],defaultBlank,#]&,ToList@blankLookup],
        If[blankExistsQ,defaultBlank,Null]
      ],
      False,
      False
    }
  ];

  (*now do all of our error checking*)

  (*we need to make sure that if the injection table is specified that the samples and the input are compatible*)
  injectionTableSampleConflictQ=If[injectionTableSpecifiedQ,
    (*check first if they're the same length. that's already bad*)
    If[Length[ToList[mySamples]]==Count[injectionTableLookup,{Sample,___}],
      Not[
        And@@MapThread[
          Function[{injectionTableSample,inputSample},
            MatchQ[injectionTableSample,Automatic|ObjectP[Download[inputSample,Object]]]
          ],
          {
            Cases[injectionTableLookup,{Sample,___}]/.{Sample,x_,___}:>x,
            Download[ToList[mySamples],Object,Cache->cache]
          }
        ]
      ],
      True
    ],
    (**)
    False
  ];

  (*do all of our error accounting and test building*)
  {foreignSamplesOptions,foreignSamplesTest} = If[injectionTableSampleConflictQ,
    (
      If[messagesQ,
        Message[Error::InjectionTableForeignSamples]
      ];
      {{InjectionTable},testOrNull["If specified, the input samples match the order and repetition within InjectionTable:",False]}
    ),
    {{},testOrNull["If specified, the input samples match the order and repetition within InjectionTable:",True]}
  ];

  standardFrequencyConflictTest=If[standardFrequencyConflictQ,
    testOrNull["If both StandardFrequency and the InjectionTable are specified, it's from a Template or StandardFrequency is Null:",False],
    testOrNull["If both StandardFrequency and the InjectionTable are specified, it's from a Template or StandardFrequency is Null:",True]
  ];

  (*do our error checking*)
  standardTableConflictTest = If[standardTableConflictQ,
    testOrNull["If both Standard and the InjectionTable are specified, all Standard samples are represented within the InjectionTable and vice versa:",False],
    testOrNull["If both Standard and the InjectionTable are specified, all Standard samples are represented within the InjectionTable and vice versa:",True]
  ];

  (* If Name is invalid, throw error *)
  standardFrequencyConflictOptions=If[standardFrequencyConflictQ,
    If[messagesQ,Message[Error::InjectionTableStandardFrequencyConflict]];
    {StandardFrequency,InjectionTable},
    {}
  ];

  (* If Name is invalid, throw error *)
  standardTableConflictOptions=If[standardTableConflictQ,
    If[messagesQ,Message[Error::InjectionTableStandardConflict]];
    {Standard,InjectionTable},
    {}
  ];

  blankFrequencyConflictTest=If[blankFrequencyConflictQ,
    testOrNull["If both BlankFrequency and the InjectionTable are specified, it's from a Template or BlankFrequency is Null:",False],
    testOrNull["If both BlankFrequency and the InjectionTable are specified, it's from a Template or BlankFrequency is Null:",True]
  ];

  (*do our error checking*)
  blankTableConflictTest = If[blankTableConflictQ,
    testOrNull["If both Blank and the InjectionTable are specified, all Blank samples are represented within the InjectionTable and vice versa:",False],
    testOrNull["If both Blank and the InjectionTable are specified, all Blank samples are represented within the InjectionTable and vice versa:",True]
  ];

  (* If Name is invalid, throw error *)
  blankFrequencyConflictOptions=If[messagesQ&&blankFrequencyConflictQ,
    Message[Error::InjectionTableBlankFrequencyConflict];
    {BlankFrequency,InjectionTable},
    {}
  ];

  (* If Name is invalid, throw error *)
  blankTableConflictOptions=If[messagesQ&&blankTableConflictQ,
    Message[Error::InjectionTableBlankConflict];
    {Blank,InjectionTable},
    {}
  ];

  (*we may need to collapse the standard and blank if it's the a object list*)
  collapsedResolvedBlank=If[MatchQ[resolvedBlank,{ObjectP[]}],First[resolvedBlank],resolvedBlank];
  collapsedResolvedStandard=If[MatchQ[resolvedStandard,{ObjectP[]}],First[resolvedStandard],resolvedStandard];

  (*make our full association for resolution*)
  resolvedOptions=Association[
    Standard->collapsedResolvedStandard,
    StandardFrequency->resolvedStandardFrequency,
    Blank->collapsedResolvedBlank,
    BlankFrequency->resolvedBlankFrequency
  ];

  invalidOptions=DeleteDuplicates[Flatten[{
    standardFrequencyConflictOptions,
    standardTableConflictOptions,
    blankFrequencyConflictOptions,
    blankTableConflictOptions,
    foreignSamplesOptions,
    standardFrequencyNoStandardsOptions,
    noStandardsButFrequencyOptions,
    blankFrequencyNoBlanksOptions,
    noBlanksButFrequencyOptions
  }]];

  invalidTests={
    standardFrequencyNoStandardsTest,
    noStandardsButFrequencyTest,
    blankFrequencyNoBlanksTest,
    noBlanksButFrequencyTest,
    standardFrequencyConflictTest,
    standardTableConflictTest,
    blankFrequencyConflictTest,
    blankTableConflictTest,
    foreignSamplesTest
  };

  (* make the result and tests rules *)
  resultRule = Result -> {resolvedOptions,invalidOptions};
  testsRule = Tests -> Cases[Flatten[invalidTests], _EmeraldTest];

  outputSpecification/.{resultRule,testsRule}

];


(* ::Subsection:: *)
(*resolveInjectionTable*)

(* ::Subsubsection::Closed:: *)
(*Options*)

DefineOptions[
  resolveInjectionTable,
  Options:>{
    CacheOption,
    OutputOption
  }
];

(* ::Subsubsection::Closed:: *)
(*Source Code*)

resolveInjectionTable::MissingFields="resolveInjectionTable requires the fields `1` to be passed in the options.";

Error::InjectionVolumeConflict="The supplied injection volume option conflicts what what's in the InjectionTable. Consider leaving `1` unset.";
Error::InjectionTypeConflict="The supplied injection type option conflicts what what's in the InjectionTable. Consider leaving `1` unset.";


resolveInjectionTable[mySamples_,partiallyResolvedOptions:_Association,experimentFunction_, gradientMethodType:TypeP[{Object[Method,Gradient],Object[Method,SupercriticalFluidGradient],Object[Method,GasChromatography]}],myOptions:OptionsPattern[]]:= Module[
  {
    resolvedInjectionTable, resolvedColumn, resolvedColumnPosition, resolvedInjectionVolumes, resolvedGradients, resolvedStandard, resolvedStandardColumn, resolvedStandardColumnPosition, resolvedStandardFrequency, resolvedStandardInjectionVolumes,
    resolvedStandardGradients, resolvedBlank, resolvedBlankColumnPosition, resolvedBlankColumn, resolvedBlankFrequency, resolvedBlankInjectionVolumes, requiredFields, columnSelectorQ, columnsQ, guardColumnOnlyQ,
    resolvedBlankGradients, resolvedColumnRefreshFrequency, resolvedColumnPrimeGradients, resolvedColumnFlushGradients, roundedInjectionTable,
    resolvedColumnPrimeGradientsLookup, resolvedColumnFlushGradientsLookup, resolvedColumnSelector, resolvedColumnSelectorPosition, injectionTableSpecifiedQ, allTupledGradients,
    hashDictionary, injectionTableSampleConflictQ, standardExistsQ, blankExistsQ, columnPrimeQ, columnFlushQ, sampleInjectionVolumeConflictQ,
    standardTableConflictQ, blankTableConflictQ, sampleInjectionTypeConflictQ, standardInjectionTypeConflictQ, blankInjectionTypeConflictQ,
    standardInjectionVolumeConflictQ, blankInjectionVolumeConflictQ, safeOps, outputSpecification, cache, output, gatherTestsQ, messagesQ,
    injectionVolumeConflictOptions, injectionVolumeConflictTest, invalidOptions, invalidTests, injectionTableResult, resultRule, testsRule,
    injectionTypeConflictOptions, resolvedInjectionTableWithInjectionType, roundedInjectionTableWithInjectionType,
    overwriteGradients, overwriteStandardGradients, overwriteBlankGradients, overwriteColumnPrimeGradients, overwriteColumnFlushGradients,
    overwritingQ, overwriteColumnPrimeGradientInitial, overwriteColumnFlushGradientInitial, resolvedInjectionType, resolvedStandardInjectionType,
    resolvedBlankInjectionType, injectionTypeQ, experimentHPLCQ, resolvedColumnTemperatures, resolvedStandardColumnTemperatures, resolvedBlankColumnTemperatures,
    resolvedPrimeColumnTemperatures, resolvedFlushColumnTemperatures
  },

  (* get the safe options *)
  safeOps = SafeOptions[resolveInjectionTable, ToList[myOptions]];

  (* get the output specification/output and cache options *)
  {outputSpecification, cache} = Lookup[safeOps, {Output, Cache}];
  output = ToList[outputSpecification];

  (* figure out if we are gathering tests or not *)
  gatherTestsQ = MemberQ[output, Tests];
  messagesQ = Not[gatherTestsQ];

  (*define the fields to pull out from the partially resolve options*)
  requiredFields = {
    Column,
    InjectionVolume,
    Gradient,
    Standard,
    StandardColumn,
    StandardFrequency,
    StandardInjectionVolume,
    StandardGradient,
    Blank,
    BlankColumn,
    BlankFrequency,
    BlankInjectionVolume,
    BlankGradient,
    ColumnRefreshFrequency,
    ColumnPrimeGradient,
    ColumnFlushGradient,
    InjectionTable
  };

  (*Check that we have all the needed fields in order to resolve the injection table*)
  (*this error message should only be thrown for developers*)
  If[!SubsetQ[Keys[partiallyResolvedOptions], requiredFields],
    Message[resolveInjectionTable::MissingFields, ToString[Complement[requiredFields,Keys[partiallyResolvedOptions]]]];
    Return[$Failed]
  ];

  (*pull the relevant information*)
  {
    resolvedColumn,
    resolvedInjectionVolumes,
    resolvedGradients,
    resolvedStandard,
    resolvedStandardColumn,
    resolvedStandardFrequency,
    resolvedStandardInjectionVolumes,
    resolvedStandardGradients,
    resolvedBlank,
    resolvedBlankColumn,
    resolvedBlankFrequency,
    resolvedBlankInjectionVolumes,
    resolvedBlankGradients,
    resolvedColumnRefreshFrequency,
    resolvedColumnPrimeGradientsLookup,
    resolvedColumnFlushGradientsLookup,
    roundedInjectionTable
  } = Lookup[partiallyResolvedOptions,
    requiredFields
  ];

  (*Pull out options that are relevant for HPLC *)
  experimentHPLCQ= MatchQ[experimentFunction, ExperimentHPLC];

  {
    resolvedColumnPosition,
    resolvedStandardColumnPosition,
    resolvedBlankColumnPosition,
    resolvedColumnTemperatures,
    resolvedStandardColumnTemperatures,
    resolvedBlankColumnTemperatures,
    resolvedPrimeColumnTemperatures,
    resolvedFlushColumnTemperatures
  }=If[experimentHPLCQ,
    Lookup[partiallyResolvedOptions,
      {ColumnPosition, StandardColumnPosition, BlankColumnPosition, ColumnTemperature,
        StandardColumnTemperature, BlankColumnTemperature, ColumnPrimeTemperature, ColumnFlushTemperature}
    ],
    {
      ConstantArray[None, Length[resolvedInjectionVolumes]],
      ConstantArray[None, Length[resolvedBlankInjectionVolumes]],
      ConstantArray[None, Length[resolvedStandardInjectionVolumes]],
      ConstantArray[None, Length[resolvedInjectionVolumes]],
      ConstantArray[None, Length[resolvedStandard]],
      ConstantArray[None, Length[resolvedBlank]],
      None,
      None
    }
  ];

  (* pull out the injection type options.  these are only for FPLC; they won't be here for HPLC/etc (in which case they'll be None) *)
  injectionTypeQ = MemberQ[Keys[partiallyResolvedOptions], InjectionType];
  {
    resolvedInjectionType,
    resolvedStandardInjectionType,
    resolvedBlankInjectionType
  } = If[injectionTypeQ,
    Lookup[
      partiallyResolvedOptions,
      {
        InjectionType,
        StandardInjectionType,
        BlankInjectionType
      }
    ],
    {
      ConstantArray[None, Length[resolvedInjectionVolumes]],
      ConstantArray[None, Length[resolvedStandardInjectionVolumes]],
      ConstantArray[None, Length[resolvedBlankInjectionVolumes]]
    }
  ];

  (*though this shouldn't ever be Null*)
  injectionTableSpecifiedQ = MatchQ[roundedInjectionTable, Except[Automatic | Null]];

  (* expand the InjectionTable to have the InjectionType if it doesn't already have it; this makes the index matching match *)
  roundedInjectionTableWithInjectionType = Which[
    (* HPLC *)
    injectionTableSpecifiedQ && Not[injectionTypeQ] && experimentHPLCQ,
    Map[
      (* Sample Type, Sample, InjectionType (FPLC only, set to None), InjectionVolume, ColumnPosition (HPLC only, Column for others), Column Temperature (HPLC only), Gradient *)
      {#[[1]], #[[2]], None, #[[3]], #[[4]], #[[5]], #[[6]]}&,
      roundedInjectionTable
    ],
    (* GC/SFC/IC *)
    injectionTableSpecifiedQ && Not[injectionTypeQ],
    (* Sample Type, Sample, InjectionType (FPLC only, set to None), InjectionVolume, Column, Column Temperature (HPLC only), Gradient *)
    Map[
      {#[[1]], #[[2]], None, #[[3]], #[[4]], None, #[[5]]}&,
      roundedInjectionTable
    ],
    (* FPLC *)
    injectionTableSpecifiedQ,
    Map[
      (* Sample Type, Sample, InjectionType, InjectionVolume, Column (not for FPLC, but was given a fake column from ExperimentFPLC), Column Temperature (HPLC only), Gradient *)
      {#[[1]], #[[2]], #[[3]], #[[4]], #[[5]], None, #[[6]]}&,
      roundedInjectionTable
    ],
    True,
    roundedInjectionTable
  ];

  (*for the column selector, if the key exists, then we take; otherwise, we wrap a list*)
  columnSelectorQ = MemberQ[Keys[partiallyResolvedOptions], ColumnSelector];

  (*we may have to wrap with a list if there is no column selector in the experiment function*)
  {
    resolvedColumnSelector,
    resolvedColumnSelectorPosition,
    resolvedColumnPrimeGradients,
    resolvedColumnFlushGradients
  } = If[columnSelectorQ && !NullQ[Lookup[partiallyResolvedOptions, ColumnSelector]],
    (*in the case of HPLC, the column selector has a tuple entry of seven entries (column position, guard, guard orientation, primary, column orientation, secondary, and tertiary); we just care about the column position*)
    Switch[Length[First@Lookup[partiallyResolvedOptions, ColumnSelector]],
      7, {Lookup[partiallyResolvedOptions, ColumnSelector], Lookup[partiallyResolvedOptions, ColumnSelector][[All, 1]],resolvedColumnPrimeGradientsLookup, resolvedColumnFlushGradientsLookup},
      _, {Lookup[partiallyResolvedOptions, ColumnSelector], Null,resolvedColumnPrimeGradientsLookup, resolvedColumnFlushGradientsLookup}
    ],
    (*otherwise, it's the same as the first column but just wrapped in a list*)
    {List[First@ToList[resolvedColumn]], Null, List[resolvedColumnPrimeGradientsLookup], List[resolvedColumnFlushGradientsLookup]}
  ];

  (*we also need to see if we need to overwrite the gradient methods in the injection table. this
   happens if a user specifies a gradient object, but then changes the flow rate or something*)
  overwritingQ = SubsetQ[Keys[partiallyResolvedOptions], {GradientOverwrite, BlankGradientOverwrite, StandardGradientOverwrite, ColumnFlushGradientOverwrite, ColumnPrimeOverwrite}];

  {
    overwriteGradients,
    overwriteBlankGradients,
    overwriteStandardGradients,
    overwriteColumnPrimeGradientInitial,
    overwriteColumnFlushGradientInitial
  } = If[overwritingQ,
    Lookup[partiallyResolvedOptions, {
      GradientOverwrite,
      BlankGradientOverwrite,
      StandardGradientOverwrite,
      ColumnFlushGradientOverwrite,
      ColumnPrimeOverwrite
    },False],
    Map[
      Function[{listOrNot},
        If[!NullQ[listOrNot],
          ConstantArray[False, Length[listOrNot]]
        ]
      ],
      {resolvedGradients, resolvedBlankGradients, resolvedStandardGradients, resolvedColumnPrimeGradients, resolvedColumnFlushGradients}
    ]
  ];

  {overwriteColumnPrimeGradients, overwriteColumnFlushGradients} = Map[ToList, {overwriteColumnPrimeGradientInitial, overwriteColumnFlushGradientInitial}];

  (*first find all of the gradients that are tupled (e.g. not Null or a method Object)*)
  allTupledGradients = Cases[Join @@ Cases[{resolvedGradients, resolvedStandardGradients, resolvedBlankGradients, resolvedColumnPrimeGradients, resolvedColumnFlushGradients}, Except[Null]], Except[ObjectP[]]];

  (*create a hash dictionary for each one that points to a temporary gradient method*)
  hashDictionary = Association[(# -> CreateID[gradientMethodType])& /@ DeleteDuplicates[(Hash /@ allTupledGradients)]];

  columnsQ = !MatchQ[resolvedColumnSelector, Null | {} | {Null}];
  columnPrimeQ = !NullQ[resolvedColumnPrimeGradients];
  columnFlushQ = !NullQ[resolvedColumnFlushGradients];
  standardExistsQ = !MatchQ[resolvedStandard, Null | {} | {Null}];
  blankExistsQ = !MatchQ[resolvedBlank, Null | {} | {Null}];

  (*we need to make sure that if the injection table is specified that the samples/standards/blanks and the input/options are compatible*)
  injectionTableSampleConflictQ = If[injectionTableSpecifiedQ,
    !MatchQ[Download[Cases[roundedInjectionTableWithInjectionType, {Sample, ___}] /. {Sample, x_, ___} :> x, Object], Download[mySamples, Object]],
    False
  ];

  standardTableConflictQ = If[injectionTableSpecifiedQ && standardExistsQ,
    !And[
      Length[Complement[Download[Cases[roundedInjectionTableWithInjectionType, {Standard, Except[Automatic], ___}] /. {Standard, x_, ___} :> x, Object], Download[ToList[resolvedStandard], Object]]] == 0,
      Length[Complement[Download[ToList[resolvedStandard], Object], Download[Cases[roundedInjectionTableWithInjectionType, {Standard, Except[Automatic], ___}] /. {Standard, x_, ___} :> x, Object]]] == 0
    ],
    False
  ];

  blankTableConflictQ = If[injectionTableSpecifiedQ && blankExistsQ,
    !And[
      Length[Complement[Download[Cases[roundedInjectionTableWithInjectionType, {Blank, Except[Automatic], ___}] /. {Blank, x_, ___} :> x, Object], Download[ToList[resolvedBlank], Object]]] == 0,
      Length[Complement[Download[ToList[resolvedBlank], Object], Download[Cases[roundedInjectionTableWithInjectionType, {Blank, Except[Automatic], ___}] /. {Blank, x_, ___} :> x, Object]]] == 0
    ],
    False
  ];

  (*there are two big paths here, the first is if the injection table is specified*)
  (*second is if the injection table is not specified and we need to build it from scratch*)
  resolvedInjectionTableWithInjectionType = If[injectionTableSpecifiedQ,
    (*even though the injection table is specified, not all of the entries within may be (e.g. the sample, injection volume, column or gradient). We need to resolve all of these*)
    Module[
      {samplePositions, standardPositions, blankPositions, columnPrimePositions, columnFlushPositions, resolvedSampleTuples, resolvedStandardTuples, resolvedBlankTuples,
      columnPrimeAutomaticPositions, resolvedTablePrimeColumnsPositions, columnFlushAutomaticPositions, resolvedTableFlushColumnsPositions, resolvedColumnPrimeTuples, resolvedColumnFlushTuples,
      columnLength, resolvedTablePrimeColumns, resolvedTableFlushColumns, semiResolvedColumnPrimeTuples, semiResolvedColumnFlushTuples, resolvedInnerInjectionTable, sampleInjectionTableTuples,
      sampleLength, injectionTableSampleLength, columnPrimeDictionary, columnFlushDictionary, columnPrimeAutomaticGradientPositions, columnFlushAutomaticGradientPositions,
      columnPrimeGradientResolution, columnFlushGradientResolution, resolvedColumnPrimeTableGradients, resolvedColumnFlushTableGradients,
      moreStandardsQ, moreBlanksQ, moreStandardPositionsQ, moreBlankPositionsQ, adjustedResolvedBlank, adjustedResolvedBlankInjectionVolumes,
      adjustedResolvedBlankColumn, adjustedResolvedBlankGradients, adjustedOverwriteBlankGradients, adjustedResolvedBlankColumnPositions, adjustedResolvedBlankColumnTemperatures,
      adjustedResolvedStandard, adjustedResolvedStandardInjectionVolumes, adjustedResolvedStandardColumn, adjustedResolvedStandardGradients, adjustedResolvedStandardColumnPositions, adjustedResolvedStandardColumnTemperatures,
      adjustedOverwriteStandardGradients, adjustedResolvedStandardInjectionTypes, adjustedResolvedBlankInjectionTypes, columnPrimeTemperatureMap, columnFlushTemperatureMap, resolvedTableColumnPrimeTemperatures, resolvedTableColumnFlushTemperatures},

      (*first separate the injection table by the positions according to its type*)
      {
        samplePositions,
        standardPositions,
        blankPositions,
        columnPrimePositions,
        columnFlushPositions
      } = Map[
        Sequence @@@ Position[roundedInjectionTableWithInjectionType, {#, ___}]&,
        {Sample, Standard, Blank, ColumnPrime, ColumnFlush}
      ];

      (*we check if there's any imbalance and make sure that we don't train wreck and adjust accordingly*)
      moreStandardsQ = Length[resolvedStandard] > Length[standardPositions];
      moreBlanksQ = Length[resolvedBlank] > Length[blankPositions];
      moreStandardPositionsQ = Length[standardPositions] > Length[resolvedStandard];
      moreBlankPositionsQ = Length[blankPositions] > Length[resolvedBlank];

      (*we readjust the length if there's an imbalance*)
      {
        adjustedResolvedStandard,
        adjustedResolvedStandardInjectionTypes,
        adjustedResolvedStandardInjectionVolumes,
        adjustedResolvedStandardColumn,
        adjustedResolvedStandardGradients,
        adjustedResolvedStandardColumnPositions,
        adjustedResolvedStandardColumnTemperatures,
        adjustedOverwriteStandardGradients
      } = Map[
        Which[
          moreStandardsQ, Take[#, Length[standardPositions]],
          moreStandardPositionsQ, PadRight[#, Length[standardPositions], Last@#],
          True, #
        ]&,
        {
          resolvedStandard,
          resolvedStandardInjectionType,
          resolvedStandardInjectionVolumes,
          resolvedStandardColumn,
          resolvedStandardGradients,
          resolvedStandardColumnPosition,
          resolvedStandardColumnTemperatures,
          overwriteStandardGradients
        }
      ];

      {
        adjustedResolvedBlank,
        adjustedResolvedBlankInjectionTypes,
        adjustedResolvedBlankInjectionVolumes,
        adjustedResolvedBlankColumn,
        adjustedResolvedBlankGradients,
        adjustedResolvedBlankColumnPositions,
        adjustedResolvedBlankColumnTemperatures,
        adjustedOverwriteBlankGradients
      } = Map[
        Which[
          moreBlanksQ, Take[#, Length[blankPositions]],
          moreBlankPositionsQ, PadRight[#, Length[blankPositions], Last@#],
          True, #
        ]&,
        {
          resolvedBlank,
          resolvedBlankInjectionType,
          resolvedBlankInjectionVolumes,
          resolvedBlankColumn,
          resolvedBlankGradients,
          resolvedBlankColumnPosition,
          resolvedBlankColumnTemperatures,
          overwriteBlankGradients
        }
      ];


      (*get the respective lengths*)
      sampleLength = Length[mySamples];
      injectionTableSampleLength = Length[samplePositions];

      (*now we can resolve the standard, blank, and standard tuples because of the 1:1 index matching*)
      {resolvedSampleTuples, resolvedStandardTuples, resolvedBlankTuples} = Map[
        Function[{entry},
          Module[
            {tableTuples, samples, injectionTypes, injectionVolumes, columns, columnPositions, columnTemperatures, gradients, overwriteBoolList,
            processedSamples, processedInjectionVolumes, processedColumns, processedColumnPositions, processedColumnTemperatures, processedGradients, processedOverwriteBoolList,
            processedInjectionTypes},

            (*split the entry*)
            {tableTuples, samples, injectionTypes, injectionVolumes, columns, columnPositions, columnTemperatures, gradients, overwriteBoolList} = entry;

            (*if there is misalignment with the input samples and the injection table (i.e. if injectionTableSampleConflictQ is true), then the consequent mapthread become difficult.*)
            (*therefore, we must pad/truncate if need be *)
            sampleInjectionTableTuples = If[!injectionTableSampleConflictQ,
              roundedInjectionTableWithInjectionType[[samplePositions]],
              (*otherwise, will pad or subtract based on the length*)
              Which[
                (*if the same length, then it's easy*)
                sampleLength == injectionTableSampleLength, roundedInjectionTableWithInjectionType[[samplePositions]],
                (*if sample is longer, then we'll pad with the automatic tuple*)
                sampleLength > injectionTableSampleLength, PadRight[roundedInjectionTableWithInjectionType[[samplePositions]], sampleLength, {{Sample, Automatic, Automatic, Automatic, Automatic, Automatic, Automatic}}],
                (*otherwise, the injection sample length must be larger, so just take the subset*)
                True, roundedInjectionTableWithInjectionType[[samplePositions]][[1 ;; sampleLength]]
              ]
            ];

            (*first check if there is something here (e.g. no standards), in which case return an empty list*)
            If[MatchQ[{tableTuples, samples, injectionTypes, injectionVolumes, columns, gradients, overwriteBoolList}, {(Null | {})..}],
              {},
              (*otherwise map thread and fill these tuples*)
              (* Edge case to consider: tableTuples is not the same length with the other values. This happens when there is conflict between the provided injection table and the provided Blank/Standard/Sample. An error was thrown earlier. Here we can process the values to be the same length with the first resolved entry *)
              {processedSamples, processedInjectionTypes, processedInjectionVolumes, processedColumns, processedColumnPositions, processedColumnTemperatures, processedGradients, processedOverwriteBoolList} = Map[
                If[SameLengthQ[#, tableTuples],
                  #,
                  PadRight[#, Length[tableTuples], FirstOrDefault[tableTuples]]
                ]&,
                {samples, injectionTypes, injectionVolumes, columns, columnPositions, columnTemperatures, gradients, overwriteBoolList}
              ];


              MapThread[
                Function[{tableTuple, sample, injectionType, injectionVolume, column, columnPosition, columnTemp, gradient, overwriteQ},
                  Module[{setSample, setInjectionType, setInjectionVolume, setColumn, gradientConverted, setGradient, setColumnTemperature, setColumnPosition},
                    (*check out much of the tupled is filled out*)
                    (*Type, Sample, InjectionType, InjectionVolume, Column, Gradient*)
                    setSample = If[MatchQ[tableTuple[[2]], Automatic],
                      sample,
                      tableTuple[[2]]
                    ];

                    setInjectionType = If[MatchQ[tableTuple[[3]], Automatic],
                      injectionType,
                      tableTuple[[3]]
                    ];

                    setInjectionVolume = If[MatchQ[tableTuple[[4]], Automatic],
                      injectionVolume,
                      tableTuple[[4]]
                    ];

                    (*Need to adjust for column being column Position in HPLC *)
                    setColumnPosition = If[experimentHPLCQ,
                      If[MatchQ[tableTuple[[5]],Automatic],
                        PositionA,
                        tableTuple[[5]]
                      ],
                      Null
                    ];

                    setColumn = If[MatchQ[tableTuple[[5]], Automatic],
                      column,
                      tableTuple[[5]]
                    ];

                    (* resolve the column temperature inside the injectionTable for HPLC*)
                    setColumnTemperature = If[experimentHPLCQ,
                      If[MatchQ[tableTuple[[6]], Automatic],
                        columnTemp,
                        tableTuple[[6]]
                      ],
                      Null
                    ];

                    (*convert the gradient if it's in tupled form*)
                    gradientConverted = If[MatchQ[gradient, Except[ObjectP[Object[Method]]]],
                      Hash[gradient] /. hashDictionary,
                      gradient
                    ];

                    setGradient = Which[
                      overwriteQ, CreateID[gradientMethodType],
                      MatchQ[tableTuple[[7]], Automatic], gradientConverted,
                      True, tableTuple[[7]]
                    ];

                    (*return the resolved tuple*)
                    If[experimentHPLCQ,
                      {First@tableTuple, setSample, setInjectionType, setInjectionVolume, setColumnPosition, setColumnTemperature, setGradient},
                      {First@tableTuple, setSample, setInjectionType, setInjectionVolume, setColumn, setColumnTemperature, setGradient}
                    ]
                  ]],
                {tableTuples, processedSamples, processedInjectionTypes, processedInjectionVolumes, processedColumns, processedColumnPositions, processedColumnTemperatures, processedGradients, processedOverwriteBoolList}
              ]
            ]
          ]],
        {
          {sampleInjectionTableTuples, mySamples, resolvedInjectionType, resolvedInjectionVolumes, resolvedColumn, resolvedColumnPosition, resolvedColumnTemperatures, resolvedGradients, overwriteGradients},
          {roundedInjectionTableWithInjectionType[[standardPositions]], adjustedResolvedStandard, adjustedResolvedStandardInjectionTypes, adjustedResolvedStandardInjectionVolumes, adjustedResolvedStandardColumn, adjustedResolvedStandardColumnPositions, adjustedResolvedStandardColumnTemperatures, adjustedResolvedStandardGradients, adjustedOverwriteStandardGradients},
          {roundedInjectionTableWithInjectionType[[blankPositions]], adjustedResolvedBlank, adjustedResolvedBlankInjectionTypes, adjustedResolvedBlankInjectionVolumes, adjustedResolvedBlankColumn, adjustedResolvedBlankColumnPositions, adjustedResolvedBlankColumnTemperatures, adjustedResolvedBlankGradients, adjustedOverwriteBlankGradients}
        }
      ];

      (*for the columns it's a bit more trickier because we have to consider the index matching to each column*)

      (*we should go ahead and resolve all of the automatics. we'll simply loop through*)

      (*get the automatic positions*)
      columnPrimeAutomaticPositions = Sequence @@@ Position[roundedInjectionTableWithInjectionType[[columnPrimePositions]][[All, 5]], Automatic];
      columnFlushAutomaticPositions = Sequence @@@ Position[roundedInjectionTableWithInjectionType[[columnFlushPositions]][[All, 5]], Automatic];

      (*get the length of the resolved columns*)
      columnLength = Length[resolvedColumnSelector];

      (*repeat out the columns and take something that's the equal size of the automatic positions*)
      (*Also repeat out columnPositions similar to columns for later replacement*)
      resolvedTablePrimeColumns = PadRight[resolvedColumnSelector, Length[columnPrimeAutomaticPositions], resolvedColumnSelector];
      resolvedTablePrimeColumnsPositions = PadRight[resolvedColumnPosition, Length[columnPrimeAutomaticPositions], resolvedColumnPosition];
      resolvedTableFlushColumns = PadRight[resolvedColumnSelector, Length[columnFlushAutomaticPositions], resolvedColumnSelector];
      resolvedTableFlushColumnsPositions = PadRight[resolvedColumnPosition, Length[columnFlushAutomaticPositions], resolvedColumnPosition];

      (*create the resolved sub tables with the columns or columnPositions*)
      (*there is also a chance we have automatics in the injection volume or sample position, so we'll Null those*)
      semiResolvedColumnPrimeTuples = roundedInjectionTableWithInjectionType[[columnPrimePositions]];
      semiResolvedColumnPrimeTuples[[columnPrimeAutomaticPositions, 5]] = If[experimentHPLCQ, resolvedTablePrimeColumnsPositions, resolvedTablePrimeColumns];
      semiResolvedColumnFlushTuples = roundedInjectionTableWithInjectionType[[columnFlushPositions]];
      semiResolvedColumnFlushTuples[[columnFlushAutomaticPositions, 5]] = If[experimentHPLCQ, resolvedTableFlushColumnsPositions, resolvedTableFlushColumns];

      (* resolve the column temperatures for the columnPrime and columnFlush*)
      (* consider the column prime temperature provided from the resolved options *)
      (* For HPLC, ColumnPrimeTemperature and ColumnFlushTemperature are index matching to ColumnSelector. Build a map *)
      columnPrimeTemperatureMap=If[columnsQ&&MatchQ[Length[resolvedPrimeColumnTemperatures],columnLength],
        MapThread[
          (#1->#2)&,
          {resolvedColumnSelector[[All,1]],resolvedPrimeColumnTemperatures}
        ],
        {}
      ];
      columnFlushTemperatureMap=If[columnsQ&&MatchQ[Length[resolvedFlushColumnTemperatures],columnLength],
        MapThread[
          (#1->#2)&,
          {resolvedColumnSelector[[All,1]],resolvedFlushColumnTemperatures}
        ],
        {}
      ];
      (* Convert the injection table's prime/flush temperature to the resolved value *)
      resolvedTableColumnPrimeTemperatures=Map[
        Which[
          MatchQ[#[[6]],Except[Automatic]],
          #[[6]],
          KeyExistsQ[columnPrimeTemperatureMap,#[[5]]],
          Lookup[columnPrimeTemperatureMap,#[[5]]],
          True,
          Ambient
        ]&,
        semiResolvedColumnPrimeTuples
      ];
      resolvedTableColumnFlushTemperatures=Map[
        Which[
          MatchQ[#[[6]],Except[Automatic]],
          #[[6]],
          KeyExistsQ[columnPrimeTemperatureMap,#[[5]]],
          Lookup[columnPrimeTemperatureMap,#[[5]]],
          True,
          Ambient
        ]&,
        semiResolvedColumnFlushTuples
      ];

      (*we'll now resolve the gradients*)

      (*for the gradients, we always want to associate the method to the appropriate column. accordingly, we need a dictionary*)
      columnPrimeDictionary = Which[
        experimentHPLCQ && NullQ[resolvedColumnSelectorPosition],
        {},
        experimentHPLCQ,
        Quiet[MapThread[
          Function[{selectedColumnPosition, primeGradient, overwriteQ},
            selectedColumnPosition-> If[!overwriteQ, primeGradient, CreateID[gradientMethodType]]
          ], {resolvedColumnSelectorPosition, ToList@resolvedColumnPrimeGradients, overwriteColumnPrimeGradients}], {Download::MissingField}],
        True,
        Quiet[MapThread[
          Function[{selectedColumn, primeGradient, overwriteQ},
            Download[selectedColumn, Object] -> If[!overwriteQ, primeGradient, CreateID[gradientMethodType]]
          ], {resolvedColumnSelector, ToList@resolvedColumnPrimeGradients, overwriteColumnPrimeGradients}], {Download::MissingField}]
      ];

      columnFlushDictionary = Which[
        experimentHPLCQ && NullQ[resolvedColumnSelectorPosition],
        {},
        experimentHPLCQ,
        Quiet[MapThread[
          Function[{selectedColumnPosition, flushGradient, overwriteQ},
            selectedColumnPosition -> If[!overwriteQ, flushGradient, CreateID[gradientMethodType]]
          ], {resolvedColumnSelectorPosition, ToList@resolvedColumnFlushGradients, overwriteColumnFlushGradients}], {Download::MissingField}],
        True,
        Quiet[MapThread[
          Function[{selectedColumn, flushGradient, overwriteQ},
            Download[selectedColumn, Object] -> If[!overwriteQ, flushGradient, CreateID[gradientMethodType]]
          ], {resolvedColumnSelector, ToList@resolvedColumnFlushGradients, overwriteColumnFlushGradients}], {Download::MissingField}]
      ];

      (*find all of the automatic gradient positions for each*)
      columnPrimeAutomaticGradientPositions = Sequence @@@ Position[roundedInjectionTableWithInjectionType[[columnPrimePositions]][[All, 7]], Automatic];
      columnFlushAutomaticGradientPositions = Sequence @@@ Position[roundedInjectionTableWithInjectionType[[columnFlushPositions]][[All, 7]], Automatic];

      (*find the gradient for all these based on the column and dictionary*)
      columnPrimeGradientResolution = If[experimentHPLCQ,
        semiResolvedColumnPrimeTuples[[columnPrimeAutomaticGradientPositions, 5]] /. columnPrimeDictionary,
        Download[semiResolvedColumnPrimeTuples[[columnPrimeAutomaticGradientPositions, 5]], Object] /. columnPrimeDictionary
      ];
      columnFlushGradientResolution = If[experimentHPLCQ,
        semiResolvedColumnFlushTuples[[columnFlushAutomaticGradientPositions, 5]] /. columnFlushDictionary,
        Download[semiResolvedColumnFlushTuples[[columnFlushAutomaticGradientPositions, 5]], Object] /. columnFlushDictionary
      ];

      (*fill these in into our semi-resolved tuples*)
      semiResolvedColumnPrimeTuples[[columnPrimeAutomaticGradientPositions, 7]] = columnPrimeGradientResolution;
      semiResolvedColumnFlushTuples[[columnFlushAutomaticGradientPositions, 7]] = columnFlushGradientResolution;

      (*finally, we loop through and convert to a gradient object*)
      {resolvedColumnPrimeTableGradients, resolvedColumnFlushTableGradients} = Map[Function[{gradients},
        (*map through each and convert to an object *)
        Map[Function[{gradient},
          If[MatchQ[gradient, Except[ObjectP[Object[Method]]]],
            Hash[gradient] /. hashDictionary,
            gradient
          ]]
          , gradients]]
        , {
          semiResolvedColumnPrimeTuples[[All, 7]],
          semiResolvedColumnFlushTuples[[All, 7]]
        }
      ];

      (*make our final resolution*)
      (*we also null out the Sample and injection type and Injection volume columns, in case any automatics are left*)
      resolvedColumnPrimeTuples = semiResolvedColumnPrimeTuples;
      resolvedColumnPrimeTuples[[All, 2]] = ConstantArray[Null, Length[resolvedColumnPrimeTableGradients]];
      resolvedColumnPrimeTuples[[All, 3]] = ConstantArray[Null, Length[resolvedColumnPrimeTableGradients]];
      resolvedColumnPrimeTuples[[All, 4]] = ConstantArray[Null, Length[resolvedColumnPrimeTableGradients]];
      resolvedColumnPrimeTuples[[All, 6]] = resolvedTableColumnPrimeTemperatures;
      resolvedColumnPrimeTuples[[All, 7]] = resolvedColumnPrimeTableGradients;
      resolvedColumnFlushTuples = semiResolvedColumnFlushTuples;
      resolvedColumnFlushTuples[[All, 2]] = ConstantArray[Null, Length[resolvedColumnFlushTableGradients]];
      resolvedColumnFlushTuples[[All, 3]] = ConstantArray[Null, Length[resolvedColumnFlushTableGradients]];
      resolvedColumnFlushTuples[[All, 4]] = ConstantArray[Null, Length[resolvedColumnFlushTableGradients]];
      resolvedColumnFlushTuples[[All, 6]] = resolvedTableColumnFlushTemperatures;
      resolvedColumnFlushTuples[[All, 7]] = resolvedColumnFlushTableGradients;

      (*returned the resolved injection table*)
      resolvedInnerInjectionTable = roundedInjectionTableWithInjectionType;

      (*again, we must be mindful of injectiontable sample clashing*)
      resolvedInnerInjectionTable[[samplePositions]] = If[!injectionTableSampleConflictQ,
        resolvedSampleTuples,
        (*otherwise, we do it by the lengths*)
        If[sampleLength > injectionTableSampleLength,
          resolvedSampleTuples[[1 ;; injectionTableSampleLength]],
          PadRight[resolvedSampleTuples,injectionTableSampleLength,resolvedSampleTuples]
        ]
      ];

      resolvedInnerInjectionTable[[blankPositions]] = resolvedBlankTuples;
      resolvedInnerInjectionTable[[standardPositions]] = resolvedStandardTuples;
      resolvedInnerInjectionTable[[columnPrimePositions]] = resolvedColumnPrimeTuples;
      resolvedInnerInjectionTable[[columnFlushPositions]] = resolvedColumnFlushTuples;

      resolvedInnerInjectionTable

    ],
    (*otherwise, we build it from the other options*)
    Module[
      {hashedGradients, standardPositions, blankPositions, columnRefreshPositions, gatheredInserts, gatheredInsertsFormatted,
      sortedInsertionTuples, gradientsConverted, standardGradientsConverted, blankGradientsConverted, resolvedColumnExpanded, resolvedColumnPositionExpanded,
      columnPrimeGradientsConverted, columnFlushGradientsConverted, samplesAsTuples, standardsAsTuples, protoInjectionList,
      blanksAsTuples, columnPrimeAsTuples, columnPrimeAsTuplesReplaceRules, columnFlushAsTuples, replacedInjectionList, reformedInjection, prependColumnPrimeAsTuples, appendColumnFlushAsTuples},
      (*in this thread of the conditional we are building the injection table from scratch*)

      (*first we need all of the positional for the standards, blanks, and column refreshes *)

      (*for the gradient changes we can use the hashing dictionary to simplify things*)
      hashedGradients = resolvedGradients /. hashDictionary;

      (* Based on StandardFrequency option, determine the positions where standards will run *)
      standardPositions = If[!standardExistsQ,
        {},
        DeleteDuplicates@Switch[resolvedStandardFrequency,
          None | Null, {},
          First, {1},
          Last, {Length[mySamples] + 1},
          FirstAndLast, {1, Length[mySamples] + 1},
          GradientChange,
          Join[{1}, 1 + Most[Accumulate[Length /@ Split[hashedGradients]]], {Length[mySamples] + 1}],
          GreaterP[0, 1],
          Range[1, Length[mySamples], resolvedStandardFrequency]
        ]
      ];

      (* Based on BlankFrequency option, determine the positions where blanks will run *)
      blankPositions = If[!blankExistsQ,
        {},
        DeleteDuplicates@Switch[resolvedBlankFrequency,
          None | Null, {},
          First, {1},
          Last, {Length[mySamples] + 1},
          FirstAndLast, {1, Length[mySamples] + 1},
          GradientChange,
          Join[{1}, 1 + Most[Accumulate[Length /@ Split[hashedGradients]]], {Length[mySamples] + 1}],
          GreaterP[0, 1],
          Range[1, Length[mySamples], resolvedBlankFrequency]
        ]
      ];

      (* Based on ColumnRefreshFrequency option, determine the positions where primes/flushes will run. Here we don't care about the initial ColumnPrime and terminal ColumnFlush. So we ignore the FirstAndLast *)
      columnRefreshPositions = If[experimentHPLCQ&&columnSelectorQ,
        Map[
          DeleteDuplicates[
            Switch[#,
              GradientChange,
              1 + Most[Accumulate[Length /@ Split[hashedGradients]]],
              GreaterP[0, 1],
              Range[1, Length[mySamples], #],
              (*else nichts*)
              _,{}
            ]
          ]&,
          ToList[resolvedColumnRefreshFrequency]
        ],
        (* For non HPLC, the ColumnRefreshFrequency is a single option *)
        Switch[resolvedColumnRefreshFrequency,
          GradientChange,
          1 + Most[Accumulate[Length /@ Split[hashedGradients]]],
          GreaterP[0, 1],
          Range[1, Length[mySamples], resolvedColumnRefreshFrequency],
          (*else nichts*)
          _,{}
        ]
      ];

      (*Now we will figure out how to position these among the samples*)

      (*First create a gathered list of tuples. First entry in the tuple is the position, second entry is the placeholder information (BlankDummy, StandardDummy). We will rule replace these out eventually.*)
      gatheredInserts = GatherBy[
        Join[
          If[experimentHPLCQ&&columnSelectorQ,
            (* In HPLC, ColumnRefreshFrequency is index matching to ColumnSelector  *)
            Join@@MapThread[
              Function[
                {refreshPos,columnPos},
                {#, ColumnPrimeDummy, columnPos}&/@refreshPos
              ],
              {columnRefreshPositions,resolvedColumnSelector[[All,1]]}
            ],
            {#1, ColumnPrimeDummy, Null}& /@ columnRefreshPositions
          ],
          {#1, BlankDummy, Null}& /@ blankPositions,
          {#1, StandardDummy, Null}& /@ standardPositions
        ],
        First
      ];

      (*format it so that it's more understandable and useable*)
      gatheredInsertsFormatted = {#[[1, 1]], #[[All, {2,3}]]}& /@ gatheredInserts;

      (*then sort it*)
      sortedInsertionTuples = Reverse[SortBy[gatheredInsertsFormatted, First]];

      (*convert the gradients if they're in tupled form to methods*)
      {gradientsConverted, standardGradientsConverted, blankGradientsConverted, columnPrimeGradientsConverted, columnFlushGradientsConverted} = MapThread[
        If[!MatchQ[#1, {} | Null],
          MapThread[Function[{gradient, overwriteQ},
            If[MatchQ[gradient, Except[ObjectP[Object[Method]]]],
              Hash[gradient] /. hashDictionary,
              (*check to see if we need to overwrite the method and generate a new one*)
              If[!overwriteQ, gradient, CreateID[gradientMethodType]]
            ]],
            {#1, #2}
          ]
        ]&, {
          {resolvedGradients, resolvedStandardGradients, resolvedBlankGradients, resolvedColumnPrimeGradients, resolvedColumnFlushGradients},
          {overwriteGradients, overwriteStandardGradients, overwriteBlankGradients, overwriteColumnPrimeGradients, overwriteColumnFlushGradients}
        }
      ];

      (*may have to expand the column*)
      resolvedColumnExpanded = If[Length[ToList@resolvedColumn] == 1, ConstantArray[resolvedColumn, Length[mySamples]], resolvedColumn];

      resolvedColumnPositionExpanded = If[Length[ToList@resolvedColumnPosition] == 1, ConstantArray[resolvedColumnPosition, Length[mySamples]], resolvedColumnPosition];

      (*get the samples in to the tupled format for the list*)
      (*Type, Sample, InjectionVolume, Column, Gradient*)
      (*Type, Sample, InjectionVolume, ColumnPosition, ColumnTemperature, gradient  for HPLC*)
      samplesAsTuples = If[experimentHPLCQ,
        MapThread[
          Function[{sample, injectionType, injectionVolume, columnPosition, columnTemperature, gradient},
            {Sample, sample, injectionType, injectionVolume, columnPosition, columnTemperature, gradient}
          ],
          (* HPLC has columnPosition instead of Column, and Temperature in it *)
          {mySamples, resolvedInjectionType, resolvedInjectionVolumes, resolvedColumnPositionExpanded, resolvedColumnTemperatures, gradientsConverted}
          ],
        MapThread[
          Function[{sample, injectionType, injectionVolume, column, gradient},
            {Sample, sample, injectionType, injectionVolume, column, Null, gradient}
          ],
          {mySamples, resolvedInjectionType, resolvedInjectionVolumes, resolvedColumnExpanded, gradientsConverted}
        ]
      ];

      (*do the same for the standards and blanks*)
      standardsAsTuples = If[standardExistsQ,
        If[experimentHPLCQ,
          (* HPLC has columnPosition instead of Column, and Temperature in it *)
          MapThread[
            Function[{sample, injectionType, injectionVolume, columnPosition, columnTemperature, gradient},
              {Standard, sample, injectionType, injectionVolume, columnPosition, columnTemperature, gradient}
            ],
            {ToList@resolvedStandard, resolvedStandardInjectionType, resolvedStandardInjectionVolumes, resolvedStandardColumnPosition, resolvedStandardColumnTemperatures, standardGradientsConverted}
          ],
          MapThread[
            Function[{sample, injectionType, injectionVolume, column, gradient},
              {Standard, sample, injectionType, injectionVolume, column, Null, gradient}
            ],
              {ToList@resolvedStandard, resolvedStandardInjectionType, resolvedStandardInjectionVolumes, resolvedStandardColumn, standardGradientsConverted}
          ]
        ],
        {}
      ];

      blanksAsTuples = If[blankExistsQ,
        If[experimentHPLCQ,
          MapThread[
            Function[{sample, injectionType, injectionVolume, columnPosition, columnTemperature, gradient},
              {Blank, sample, injectionType, injectionVolume, columnPosition, columnTemperature, gradient}
            ],
            {ToList@resolvedBlank, resolvedBlankInjectionType, resolvedBlankInjectionVolumes, resolvedBlankColumnPosition, resolvedBlankColumnTemperatures, blankGradientsConverted}
          ],
          MapThread[
            Function[{sample, injectionType, injectionVolume, column, gradient},
              {Blank, sample, injectionType, injectionVolume, column, Null, gradient}
            ],
              {ToList@resolvedBlank, resolvedBlankInjectionType, resolvedBlankInjectionVolumes, resolvedBlankColumn, blankGradientsConverted}
          ]
        ],
        {}
      ];

      (*for the column prime will need to do a set for each column*)
      columnPrimeAsTuples = If[columnsQ && columnPrimeQ,
        If[experimentHPLCQ,
          MapThread[
            Function[{columnPosition, columnTemperature, gradient},
              {ColumnPrime, Null, Null, Null, columnPosition, columnTemperature, gradient}
            ],
            {resolvedColumnSelector[[All,1]], resolvedPrimeColumnTemperatures, columnPrimeGradientsConverted}
          ],
          MapThread[
            Function[{column, gradient},
              {ColumnPrime, Null, Null, Null, FirstOrDefault[ToList[column]], Null, gradient}
            ],
            {resolvedColumnSelector, columnPrimeGradientsConverted}
          ]
        ],
        If[experimentHPLCQ&&columnSelectorQ,
          ConstantArray[{},Length[resolvedColumnSelector]],
          {}
        ]
      ];

      columnPrimeAsTuplesReplaceRules = If[experimentHPLCQ&&columnSelectorQ,
        MapThread[
          Function[{columnPosition, columnTuples},
            {ColumnPrimeDummy, columnPosition} -> columnTuples
          ],
          {resolvedColumnSelector[[All,1]], columnPrimeAsTuples}
        ],
        {{ColumnPrimeDummy, Null} -> columnPrimeAsTuples}
      ];

      (*for the column prime will need to do a set for each column*)
      columnFlushAsTuples = If[columnsQ && columnFlushQ,
        If[experimentHPLCQ,
          MapThread[
            Function[{columnPosition, columnTemperature, gradient},
              {ColumnFlush, Null, Null, Null, columnPosition, columnTemperature, gradient}
            ],
            {resolvedColumnSelector[[All,1]], resolvedFlushColumnTemperatures, columnFlushGradientsConverted}
          ],
          MapThread[
            Function[{column, gradient},
              {ColumnFlush, Null, Null, Null, FirstOrDefault[ToList[column]], Null, gradient}
            ],
              {resolvedColumnSelector, columnFlushGradientsConverted}
          ]
        ],
        If[experimentHPLCQ&&columnSelectorQ,
          ConstantArray[{},Length[resolvedColumnSelector]],
          {}
        ]
      ];

      (*now insert into the sequence of samples*)
      protoInjectionList = Fold[Insert[#1, #2[[2]], #2[[1]]]&, samplesAsTuples, sortedInsertionTuples];

      (*then rule replace the Dummys with our blanks, standards, and column primes*)
      replacedInjectionList = protoInjectionList /. Join[
        {
          {BlankDummy,Null} -> blanksAsTuples,
          {StandardDummy,Null} -> standardsAsTuples
        },
        columnPrimeAsTuplesReplaceRules
      ];

      (*flatten and reform*)
      reformedInjection = Partition[Flatten[replacedInjectionList], 7];

      (*finally add the initial and final flushes if necessary*)
      prependColumnPrimeAsTuples = If[experimentHPLCQ,
        (* HPLC ColumnRefreshFrequency is index matching to column selector and we should decide for each column *)
        MapThread[
          Switch[#2,
            FirstAndLast|GradientChange|First,#1,
            _,Nothing
          ]&,
          {columnPrimeAsTuples,ToList[resolvedColumnRefreshFrequency]}
        ],
        Switch[resolvedColumnRefreshFrequency,
          FirstAndLast|GradientChange|First,columnPrimeAsTuples,
          _,{}
        ]
      ];
      appendColumnFlushAsTuples = If[experimentHPLCQ,
        (* HPLC ColumnRefreshFrequency is index matching to column selector and we should decide for each column *)
        MapThread[
          Switch[#2,
            FirstAndLast|GradientChange|Last|_Integer,#1,
            _,Nothing
          ]&,
          {columnFlushAsTuples,ToList[resolvedColumnRefreshFrequency]}
        ],
        Switch[resolvedColumnRefreshFrequency,
          FirstAndLast|GradientChange|Last|_Integer,columnFlushAsTuples,
          _,{}
        ]
      ];
      Join[prependColumnPrimeAsTuples, reformedInjection, appendColumnFlushAsTuples]
    ]
  ];

  (*do some error checking*)

  (*check to see if the injection volumes and types were specified in both the table and separately*)
  (*only have to worry about this if the injection table was specified and there are no conflicts between the provided Sample/Standard/Blank and the injection table*)
  sampleInjectionTypeConflictQ = If[injectionTableSpecifiedQ && !injectionTableSampleConflictQ,
    Not[And @@ MapThread[#1 == #2&, {
      resolvedInjectionType,
      (*we readjust the length to not train wreck*)
      PadRight[Cases[resolvedInjectionTableWithInjectionType, {Sample, ___}][[All, 3]], Length[resolvedInjectionType], resolvedInjectionType]
    }]],
    False
  ];
  sampleInjectionVolumeConflictQ = If[injectionTableSpecifiedQ && !injectionTableSampleConflictQ,
    Not[And @@ MapThread[#1 == #2&, {
      resolvedInjectionVolumes,
      (*we readjust the length to not train wreck*)
      PadRight[Cases[resolvedInjectionTableWithInjectionType, {Sample, ___}][[All, 4]], Length[resolvedInjectionVolumes], resolvedInjectionVolumes]
    }]],
    False
  ];
  standardInjectionTypeConflictQ = If[injectionTableSpecifiedQ && standardExistsQ && !standardTableConflictQ,
    Not[And @@ MapThread[#1 == #2&, {
      resolvedStandardInjectionType,
      PadRight[Cases[resolvedInjectionTableWithInjectionType, {Standard, ___}][[All, 3]], Length[resolvedStandardInjectionType], resolvedStandardInjectionType]
    }]],
    False
  ];
  standardInjectionVolumeConflictQ = If[injectionTableSpecifiedQ && standardExistsQ && !standardTableConflictQ,
    Not[And @@ MapThread[#1 == #2&, {
      resolvedStandardInjectionVolumes,
      PadRight[Cases[resolvedInjectionTableWithInjectionType, {Standard, ___}][[All, 4]], Length[resolvedStandardInjectionVolumes], resolvedStandardInjectionVolumes]
    }]],
    False
  ];
  blankInjectionTypeConflictQ = If[injectionTableSpecifiedQ && blankExistsQ && !blankTableConflictQ,
    Not[And @@ MapThread[#1 == #2&, {
      resolvedBlankInjectionType,
      PadRight[Cases[resolvedInjectionTableWithInjectionType, {Blank, ___}][[All, 3]], Length[resolvedBlankInjectionType], resolvedBlankInjectionType]
    }]],
    False
  ];
  blankInjectionVolumeConflictQ = If[injectionTableSpecifiedQ && blankExistsQ && !blankTableConflictQ,
    Not[And @@ MapThread[#1 == #2&, {
      resolvedBlankInjectionVolumes,
      PadRight[Cases[resolvedInjectionTableWithInjectionType, {Blank, ___}][[All, 4]], Length[resolvedBlankInjectionVolumes], resolvedBlankInjectionVolumes]
    }]],
    False
  ];

  (* if there is a mismatch between the Blank options and the injection table, throw an error *)
  injectionTypeConflictOptions = If[messagesQ && Or[sampleInjectionTypeConflictQ, standardInjectionTypeConflictQ, blankInjectionTypeConflictQ],
    (
      Message[Error::InjectionTypeConflict,
        PickList[{InjectionType, StandardInjectionType, BlankInjectionType}, {sampleInjectionTypeConflictQ, standardInjectionTypeConflictQ, blankInjectionTypeConflictQ}]
      ];
      PickList[{InjectionType, StandardInjectionType, BlankInjectionType}, {sampleInjectionTypeConflictQ, standardInjectionTypeConflictQ, blankInjectionTypeConflictQ}]
    ),
    {}
  ];
  injectionVolumeConflictOptions = If[messagesQ && Or[sampleInjectionVolumeConflictQ, standardInjectionVolumeConflictQ, blankInjectionVolumeConflictQ],
    (
      Message[Error::InjectionVolumeConflict,
        PickList[{InjectionVolume, StandardInjectionVolume, BlankInjectionVolume}, {sampleInjectionVolumeConflictQ, standardInjectionVolumeConflictQ, blankInjectionVolumeConflictQ}]
      ];
      PickList[{InjectionVolume, StandardInjectionVolume, BlankInjectionVolume}, {sampleInjectionVolumeConflictQ, standardInjectionVolumeConflictQ, blankInjectionVolumeConflictQ}]
    ),
    {}
  ];
  (* make a test for the blank injection table options *)
  injectionVolumeConflictTest = If[gatherTestsQ,
    Test["If both the injection table is specified as well as the injection volumes, there is no conflict:",
      Or[sampleInjectionVolumeConflictQ, standardInjectionVolumeConflictQ, blankInjectionVolumeConflictQ],
      False
    ],
    Nothing
  ];

  invalidOptions = Flatten[{injectionVolumeConflictOptions, injectionTypeConflictOptions}];
  invalidTests = Flatten[{injectionVolumeConflictTest}];

  (* remove the InjectionType column of the injection table if we didn't have it to start with *)
  resolvedInjectionTable = Which[
    (* injectionTableWithInjectionType to drop off column temperature as well at position 6 *)
    injectionTypeQ,resolvedInjectionTableWithInjectionType[[All, {1, 2, 3, 4, 5, 7}]],
    experimentHPLCQ,
    (* Injection Table with HPLC now includes column Temperature as well, so including that *)
    resolvedInjectionTableWithInjectionType[[All, {1, 2, 4, 5, 6, 7}]],
    True,
    resolvedInjectionTableWithInjectionType[[All, {1, 2, 4, 5, 7}]]
  ];

  (*return the resolved injection table*)
  injectionTableResult = <|InjectionTable -> resolvedInjectionTable|>;

  (* make the result and tests rules *)
  resultRule = Result -> {injectionTableResult, invalidOptions};
  testsRule = Tests -> invalidTests;

  outputSpecification /. {resultRule, testsRule}

];


(* ::Subsection:: *)
(*roundGradientOptions*)

DefineOptions[roundGradientOptions,
  Options :> {
    (* flow rate precision can vary from instrument so we allow it to be an option *)
    {FlowRatePrecision -> 10^-1 Milliliter / Minute, GreaterEqualP[0 Milliliter / Minute], "The minimum precision for the flow rate."},
    {TimePrecision -> 10^-1 Minute, GreaterEqualP[0 Minute], "The minimum precision for the time values."},
    {GradientPrecision -> 10^0 Percent, GreaterEqualP[0 Percent], "The minimum precision for the gradient values."}
  }
];

    (*this is now a shared function so that many functions can use it (e.g. SFC)*)
roundGradientOptions[gradientOptions_,optionsAssociation_,gatherTests_, myOptions : OptionsPattern[]]:=Module[{
  gradientTimeValuePositions,gradientPercentValuePositions,gradientFlowRateValuePositions,gradientTimeValueAssociation,
  gradientPercentValueAssociation,gradientFlowRateValueAssociation,gradientPressureValuePositions, safeOptions,
  gradientTimeRoundedAssociation,gradientTimeRoundedTests,gradientPercentRoundedAssociation,gradientPercentRoundedTests,
  gradientFlowRateRoundedAssociation,gradientFlowRateRoundedTests,roundedGradientOptions,gradientPressureValueAssociation,
  gradientPressureRoundedAssociation,gradientPressureRoundedTests, flowRatePrecisionLookup, timePrecisionLookup, gradientPrecisionLookup
},

  (*get the option values*)
  safeOptions = SafeOptions[roundGradientOptions, ToList[myOptions]];

  (*get the flow rate precision*)
  flowRatePrecisionLookup=Lookup[safeOptions,FlowRatePrecision];
  timePrecisionLookup=Lookup[safeOptions,TimePrecision];
  gradientPrecisionLookup=Lookup[safeOptions,GradientPrecision];

  (* Find all positions in the gradient options where a time exists *)
  gradientTimeValuePositions = Map[
    Position[ToList[#],GreaterEqualP[0*Second],Infinity,Heads->False]&,
    Lookup[optionsAssociation,gradientOptions]
  ];

  (* Find all positions in the gradient options where a percent exists *)
  (*NOTE: using this weird pattern because GreaterEqualP[0*Percent] picks more *)
  gradientPercentValuePositions = Map[
    Position[ToList[#],_Quantity?PercentQ,Infinity,Heads->False]&,
    Lookup[optionsAssociation,gradientOptions]
  ];

  (* Find all positions in the gradient options where a flow rate exists *)
  gradientFlowRateValuePositions = Map[
    Position[ToList[#],GreaterEqualP[0*Milliliter/Minute],Infinity,Heads->False]&,
    Lookup[optionsAssociation,gradientOptions]
  ];

  (* Find all positions in the gradient options where a flow rate exists *)
  gradientPressureValuePositions = Map[
    Position[ToList[#],GreaterEqualP[0*PSI],Infinity,Heads->False]&,
    Lookup[optionsAssociation,gradientOptions]
  ];

  (* Build association with completely flattened time values.
    ex: {{{1 Minute, 30 Percent}, {2 Minute, 50 Percent}},{{1 Minute, 10 Percent},{10 Minute, 90 Percent}}}
    would transform to {1 Minute, 2 Minute, 1 Minute, 10 Minute} with gradientTimeValuePositions being:
    {{1,1,1},{1,2,1},{2,1,1},{2,2,1}} *)
  gradientTimeValueAssociation = Association@MapThread[
    Function[{optionName,indices},
      (optionName -> (Extract[ToList[Lookup[optionsAssociation,optionName]],#]&/@indices))
    ],
    {gradientOptions,gradientTimeValuePositions}
  ];

  (* Build association with completely flattened percent values *)
  gradientPercentValueAssociation = Association@MapThread[
    Function[{optionName,indices},
      (optionName -> (Extract[ToList[Lookup[optionsAssociation,optionName]],#]&/@indices))
    ],
    {gradientOptions,gradientPercentValuePositions}
  ];

  (* Build association with completely flattened flow rate values *)
  gradientFlowRateValueAssociation = Association@MapThread[
    Function[{optionName,indices},
      (optionName -> (Extract[ToList[Lookup[optionsAssociation,optionName]],#]&/@indices))
    ],
    {gradientOptions,gradientFlowRateValuePositions}
  ];

  (* Build association with completely flattened flow rate values *)
  gradientPressureValueAssociation = Association@MapThread[
    Function[{optionName,indices},
      (optionName -> (Extract[ToList[Lookup[optionsAssociation,optionName]],#]&/@indices))
    ],
    {gradientOptions,gradientPressureValuePositions}
  ];

  (* Pass built time association to get rounded values *)
  {gradientTimeRoundedAssociation,gradientTimeRoundedTests} = If[gatherTests,
    RoundOptionPrecision[
      gradientTimeValueAssociation,
      gradientOptions,
      Table[timePrecisionLookup, Length[gradientOptions]],
      Output -> {Result, Tests}
    ],
    {
      RoundOptionPrecision[
        gradientTimeValueAssociation,
        gradientOptions,
        Table[timePrecisionLookup, Length[gradientOptions]]
      ],
      {}
    }
  ];

  (* Pass built percent association to get rounded values *)
  {gradientPercentRoundedAssociation,gradientPercentRoundedTests} = If[gatherTests,
    RoundOptionPrecision[
      gradientPercentValueAssociation,
      gradientOptions,
      Table[gradientPrecisionLookup, Length[gradientOptions]],
      Output -> {Result, Tests}
    ],
    {
      RoundOptionPrecision[
        gradientPercentValueAssociation,
        gradientOptions,
        Table[gradientPrecisionLookup, Length[gradientOptions]]
      ],
      {}
    }
  ];

  (* Pass built flow rate association to get rounded values *)
  {gradientFlowRateRoundedAssociation,gradientFlowRateRoundedTests} = If[gatherTests, RoundOptionPrecision[
    gradientFlowRateValueAssociation,
    gradientOptions,
    Table[flowRatePrecisionLookup, Length[gradientOptions]],
    Output -> {Result, Tests}
  ],
    {
      RoundOptionPrecision[
        gradientFlowRateValueAssociation,
        gradientOptions,
        Table[flowRatePrecisionLookup, Length[gradientOptions]]
      ],
      {}
    }
  ];

  (* Pass built flow rate association to get rounded values *)
  {gradientPressureRoundedAssociation,gradientPressureRoundedTests} = If[gatherTests, RoundOptionPrecision[
    gradientPressureValueAssociation,
    gradientOptions,
    Table[1 PSI, Length[gradientOptions]],
    Output -> {Result, Tests}
  ],
    {
      RoundOptionPrecision[
        gradientPressureValueAssociation,
        gradientOptions,
        Table[1 PSI, Length[gradientOptions]]
      ],
      {}
    }
  ];

  (* Rebuild the gradient options association by replacing the flat rounded values at the
  positions they were originally found in *)
  roundedGradientOptions = Association@MapThread[
    Function[{optionName,timePositions,percentPositions,flowRatePositions,pressurePositions},
      optionName -> If[MatchQ[Lookup[optionsAssociation,optionName],_List],
        ReplacePart[
          Lookup[optionsAssociation,optionName],
          Join[
            MapThread[
              Rule,
              {timePositions,Lookup[gradientTimeRoundedAssociation,optionName]}
            ],
            MapThread[
              Rule,
              {percentPositions,Lookup[gradientPercentRoundedAssociation,optionName]}
            ],
            MapThread[
              Rule,
              {flowRatePositions,Lookup[gradientFlowRateRoundedAssociation,optionName]}
            ],
            MapThread[
              Rule,
              {pressurePositions,Lookup[gradientPressureRoundedAssociation,optionName]}
            ]
          ]
        ],
        ReplacePart[
          ToList[Lookup[optionsAssociation,optionName]],
          Join[
            MapThread[
              Rule,
              {timePositions,Lookup[gradientTimeRoundedAssociation,optionName]}
            ],
            MapThread[
              Rule,
              {percentPositions,Lookup[gradientPercentRoundedAssociation,optionName]}
            ],
            MapThread[
              Rule,
              {flowRatePositions,Lookup[gradientFlowRateRoundedAssociation,optionName]}
            ],
            MapThread[
              Rule,
              {pressurePositions,Lookup[gradientPressureRoundedAssociation,optionName]}
            ]
          ]
        ][[1]]
      ]
    ],
    {gradientOptions,gradientTimeValuePositions,gradientPercentValuePositions,gradientFlowRateValuePositions,gradientPressureValuePositions}
  ];

  (*return the rounded options and the tests*)
  {roundedGradientOptions,Join[gradientTimeRoundedTests,gradientPercentRoundedTests,gradientFlowRateRoundedTests,gradientPressureRoundedTests]}

];


(* Define the gradient pattern *)

(*binaryGradientP*)
binaryGradientP:={{TimeP,PercentP,PercentP,FlowRateP}...};

(*gradientP*)
gradientP:={{TimeP,PercentP,PercentP,PercentP,PercentP,FlowRateP}...};

(*expandedGradientP*)
expandedGradientP:={{TimeP,PercentP,PercentP,PercentP,PercentP,PercentP,PercentP,PercentP,PercentP,FlowRateP}...};

(*resolveGradient*)
(* Helper function to resolve a gradient given various gradient options *)
(* The following function works for multiple experiment functions - PackColumn, FPLC and HPLC *)
(* Some of the overloads have input for the Refractive Index Reference Loading information - True for Closed and False for Open/Null *)

(* 1 - Overload for just four gradients - with or without the refractive index reference loading input *)

(* 1.1 - Overload without refractive index reference loading information - default to False to transfer the main overload *)
resolveGradient[
  myGradientValue:(Automatic|gradientP|Null),
  myGradientAValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),
  myGradientBValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),
  myGradientCValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),
  myGradientDValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),
  myFlowRateValue:({{TimeP,FlowRateP}..}|FlowRateP),
  myGradientStart:(PercentP|Null),
  myGradientEnd:(PercentP|Null),
  myGradientDuration:(TimeP|Null),
  myFlushTime:(TimeP|Null),
  myEquilibrationTime:(TimeP|Null)
]:=Module[{expandedGradient,returnedGradient},

  (*create an expanded gradient if we need*)
  expandedGradient=If[MatchQ[myGradientValue,gradientP],
    (*we have to insert in 4 columns full of 0 percents *)
    Transpose@Nest[Insert[#,Repeat[0 Percent,Length[myGradientValue]], -2] &, Transpose@myGradientValue, 4],
    (*otherwise, we don't have to do anything*)
    myGradientValue
  ];

  (*use the main overload*)
  returnedGradient=resolveGradient[
    expandedGradient,
    myGradientAValue,
    myGradientBValue,
    myGradientCValue,
    myGradientDValue,
    0 Percent,
    0 Percent,
    0 Percent,
    0 Percent,
    myFlowRateValue,
    myGradientStart,
    myGradientEnd,
    myGradientDuration,
    myFlushTime,
    myEquilibrationTime,
    None
  ];

  (*remove the E, F, G, H columns and the reference loading info*)
  returnedGradient[[All,{1,2,3,4,5,-2}]]

];

(* 1.2 - Overload with refractive index reference loading information *)
resolveGradient[
  myGradientValue:(Automatic|gradientP|Null),
  myGradientAValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),
  myGradientBValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),
  myGradientCValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),
  myGradientDValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),
  myFlowRateValue:({{TimeP,FlowRateP}..}|FlowRateP),
  myGradientStart:(PercentP|Null),
  myGradientEnd:(PercentP|Null),
  myGradientDuration:(TimeP|Null),
  myFlushTime:(TimeP|Null),
  myEquilibrationTime:(TimeP|Null),
  myReferenceLoadingClosedQ:(Open|Closed|None|{(Open|Closed|None)..})
]:=Module[{expandedGradient,returnedGradient},

  (*create an expanded gradient if we need*)
  expandedGradient=If[MatchQ[myGradientValue,gradientP],
    (*we have to insert in 4 columns full of 0 percents *)
    Transpose@Nest[Insert[#,Repeat[0 Percent,Length[myGradientValue]], -2] &, Transpose@myGradientValue, 4],
    (*otherwise, we don't have to do anything*)
    myGradientValue
  ];

  (*use the main overload*)
  returnedGradient=resolveGradient[
    expandedGradient,
    myGradientAValue,
    myGradientBValue,
    myGradientCValue,
    myGradientDValue,
    0 Percent,
    0 Percent,
    0 Percent,
    0 Percent,
    myFlowRateValue,
    myGradientStart,
    myGradientEnd,
    myGradientDuration,
    myFlushTime,
    myEquilibrationTime,
    myReferenceLoadingClosedQ
  ];

  (*remove the E, F, G, H columns*)
  returnedGradient[[All,{1,2,3,4,5,-2,-1}]]

];



(* 2 - Overload with eight gradients but without the refractive index reference loading input - default to False and transfer into our main overload*)
resolveGradient[
  myGradientValue:(Automatic|expandedGradientP|Null),
  myGradientAValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),
  myGradientBValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),
  myGradientCValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),
  myGradientDValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),
  myGradientEValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),
  myGradientFValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),
  myGradientGValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),
  myGradientHValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),
  myFlowRateValue:({{TimeP,FlowRateP}..}|FlowRateP),
  myGradientStart:(PercentP|Null),
  myGradientEnd:(PercentP|Null),
  myGradientDuration:(TimeP|Null),
  myFlushTime:(TimeP|Null),
  myEquilibrationTime:(TimeP|Null)
]:=Module[{returnedGradient},

  (*use the main overload*)
  returnedGradient=resolveGradient[
    myGradientValue,
    myGradientAValue,
    myGradientBValue,
    myGradientCValue,
    myGradientDValue,
    myGradientEValue,
    myGradientFValue,
    myGradientGValue,
    myGradientHValue,
    myFlowRateValue,
    myGradientStart,
    myGradientEnd,
    myGradientDuration,
    myFlushTime,
    myEquilibrationTime,
    None
  ];

  (* Remove the reference loading info *)
  returnedGradient[[All,1;;-2]]

];


(* 3 - Main Overload - eight gradients with the refractive index reference loading input *)
resolveGradient[
  myGradientValue:(Automatic|expandedGradientP|Null),
  myGradientAValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),
  myGradientBValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),
  myGradientCValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),
  myGradientDValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),
  myGradientEValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),
  myGradientFValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),
  myGradientGValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),
  myGradientHValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),
  myFlowRateValue:({{TimeP,FlowRateP}..}|FlowRateP),
  myGradientStart:(PercentP|Null),
  myGradientEnd:(PercentP|Null),
  myGradientDuration:(TimeP|Null),
  myFlushTime:(TimeP|Null),
  myEquilibrationTime:(TimeP|Null),
  myReferenceLoadingClosedQ:(Open|Closed|None|{(Open|Closed|None)..})
]:=Module[
  {protoResolvedGradient,gradientWithEquilibrationTime,gradientWithFlushTime, gradientWithReferenceLoading,
    gradientATimepoints, gradientBTimepoints, gradientCTimepoints, gradientDTimepoints, gradientASpecifiedTimes,
    gradientBSpecifiedTimes, gradientCSpecifiedTimes, gradientDSpecifiedTimes,minATime, maxATime, minBTime, maxBTime, minCTime,
    maxCTime, minDTime, maxDTime,specifiedTimes, maxTime, minTime, interpolationTimepointsA, interpolationTimepointsB,
    interpolationTimepointsC, interpolationTimepointsD,interpolatedGradientALookup, interpolatedGradientBLookup, interpolatedGradientCLookup,
    interpolatedGradientDLookup, compositionTuples,protoCompositionTuples, allCompositionTuples, allTimes, allFlowRates, flowRateTimepoints,
    flowRatesSpecificTimes,gradientETimepoints, gradientFTimepoints, gradientGTimepoints, gradientHTimepoints,
    gradientESpecifiedTimes, gradientFSpecifiedTimes, gradientGSpecifiedTimes, gradientHSpecifiedTimes,
    minETime,maxETime, minFTime,maxFTime, minGTime,maxGTime, minHTime,maxHTime, interpolationTimepointsE,
    interpolationTimepointsF, interpolationTimepointsG, interpolationTimepointsH, interpolatedGradientELookup, semiResolvedGradientEnd,
    interpolatedGradientFLookup, interpolatedGradientGLookup, interpolatedGradientHLookup,
    referenceLoadingStatus},

    (* We somewhat resolve the gradient end in case there are issues *)
    semiResolvedGradientEnd=If[NullQ[myGradientEnd],0 Percent,myGradientEnd];

    gradientATimepoints = Switch[myGradientAValue,
      (* If timepoints are specified, use them *)
      {{TimeP,PercentP}...},myGradientAValue,
      (* If a single isocratic percent is specified, build gradient
      as a constant percentage from 0 min to gradient duration *)
      PercentP,
      {
        {0. Minute, myGradientAValue},
        (* If GradientDuration is Null, then default to 0 min (full GradientA will be expanded below to the max time)*)
        If[NullQ[myGradientDuration],
          Nothing,
          {myGradientDuration,myGradientAValue}
        ]
      },
      _,
      (* If Gradient option is specified, inherit GradientA from its value *)
      Switch[myGradientValue,
        (* If gradient tuples are specified, take the first index (time) and second (buffer A %) *)
        expandedGradientP,
        myGradientValue[[All,{1,2}]],
        _,
        (* If start/end/duration is specified, they specify buffer B composition,
          Fill the remaining composition with Buffer A *)
        If[MatchQ[myGradientStart,PercentP],
          {
            {0. Minute,100. Percent - myGradientStart},
            (* If GradientDuration is Null, then default to 0 min
            (full GradientA will be expanded below to the max time)*)
            If[NullQ[myGradientDuration],
              Nothing,
              (* Default to 100 Percent BufferB if GradientEnd is set to Null by mistake *)
              {myGradientDuration,100. Percent - semiResolvedGradientEnd}
            ]
          },
          (* If nothing is specified, BufferA is not used *)
          {}
        ]
      ]
    ];

    gradientBTimepoints = Switch[myGradientBValue,
      (* If timepoints are specified, use them *)
      {{TimeP,PercentP}...},myGradientBValue,
      (* If a single isocratic percent is specified, build gradient
      as a constant percentage from 0 min to gradient duration *)
      PercentP,
      {
        {0. Minute, myGradientBValue},
        (* If GradientDuration is Null, then default to 0 min
        (full GradientB will be expanded below to the max time)*)
        If[NullQ[myGradientDuration],
          Nothing,
          {myGradientDuration,myGradientBValue}
        ]
      },
      _,
      (* If Gradient option is specified, inherit GradientB from its value *)
      Switch[myGradientValue,
        (* If gradient tuples are specified, take the first index (time) and third (buffer B %) *)
        expandedGradientP,
        myGradientValue[[All,{1,3}]],
        _,
        (* If start/end/duration is specified, they specify buffer B composition *)
        If[MatchQ[myGradientStart,PercentP],
          {
            {0. Minute,myGradientStart},
            (* If GradientDuration is Null, then default to 0 min
            (full GradientA will be expanded below to the max time)*)
            If[NullQ[myGradientDuration],
              Nothing,
              (* Default to 100 Percent BufferB if GradientEnd is set to Null by mistake *)
              {myGradientDuration,semiResolvedGradientEnd}
            ]
          },
          (* If nothing is specified, BufferB is not used *)
          {}
        ]
      ]
    ];

    gradientCTimepoints = Switch[myGradientCValue,
      (* If timepoints are specified, use them *)
      {{TimeP,PercentP}...},myGradientCValue,
      (* If a single isocratic percent is specified, build gradient
      as a constant percentage from 0 min to gradient duration *)
      PercentP,
      {
        {0. Minute, myGradientCValue},
        (* If GradientDuration is Null, then default to 0 min
        (full GradientC will be expanded below to the max time)*)
        If[NullQ[myGradientDuration],
          Nothing,
          {myGradientDuration,myGradientCValue}
        ]
      },
      _,
      (* If Gradient option is specified, inherit GradientC from its value *)
      Switch[myGradientValue,
        (* If gradient tuples are specified, take the first index (time) and fourth (buffer C %) *)
        expandedGradientP,
        myGradientValue[[All,{1,4}]],
        _,
        (* If nothing is specified, BufferC is not used *)
        {}
      ]
    ];

    gradientDTimepoints = Switch[myGradientDValue,
      (* If timepoints are specified, use them *)
      {{TimeP,PercentP}...},myGradientDValue,
      (* If a single isocratic percent is specified, build gradient
      as a constant percentage from 0 min to gradient duration *)
      PercentP,
      {
        {0. Minute, myGradientDValue},
        (* If GradientDuration is Null, then default to 0 min
        (full GradientD will be expanded below to the max time)*)
        If[NullQ[myGradientDuration],
          Nothing,
          {myGradientDuration,myGradientDValue}
        ]
      },
      _,
      (* If Gradient option is specified, inherit GradientD from its value *)
      Switch[myGradientValue,
        (* If gradient tuples are specified, take the first index (time) and fifth (buffer D %) *)
        expandedGradientP,
        myGradientValue[[All,{1,5}]],
        _,
        (* If nothing is specified, BufferD is not used *)
        {}
      ]
    ];

    gradientETimepoints = Switch[myGradientEValue,
      (* If timepoints are specified, use them *)
      {{TimeP,PercentP}...},myGradientEValue,
      (* If a single isocratic percent is specified, build gradient
      as a constant percentage from 0 min to gradient duration *)
      PercentP,
      {
        {0. Minute, myGradientEValue},
        (* If GradientDuration is Null, then default to 0 min
        (full GradientD will be expanded below to the max time)*)
        If[NullQ[myGradientDuration],
          Nothing,
          {myGradientDuration,myGradientEValue}
        ]
      },
      _,
      (* If Gradient option is specified, inherit GradientE from its value *)
      Switch[myGradientValue,
        (* If gradient tuples are specified, take the first index (time) and sixth (buffer E %) *)
        expandedGradientP,
        myGradientValue[[All,{1,6}]],
        _,
        (* If nothing is specified, BufferE is not used *)
        {}
      ]
    ];

    gradientFTimepoints = Switch[myGradientFValue,
      (* If timepoints are specified, use them *)
      {{TimeP,PercentP}...},myGradientFValue,
      (* If a single isocratic percent is specified, build gradient
      as a constant percentage from 0 min to gradient duration *)
      PercentP,
      {
        {0. Minute, myGradientFValue},
        (* If GradientDuration is Null, then default to 0 min
        (full GradientD will be expanded below to the max time)*)
        If[NullQ[myGradientDuration],
          Nothing,
          {myGradientDuration,myGradientFValue}
        ]
      },
      _,
      (* If Gradient option is specified, inherit GradientF from its value *)
      Switch[myGradientValue,
        (* If gradient tuples are specified, take the first index (time) and sixth (buffer F %) *)
        expandedGradientP,
        myGradientValue[[All,{1,7}]],
        _,
        (* If nothing is specified, BufferF is not used *)
        {}
      ]
    ];

    gradientGTimepoints = Switch[myGradientGValue,
      (* If timepoints are specified, use them *)
      {{TimeP,PercentP}...},myGradientGValue,
      (* If a single isocratic percent is specified, build gradient
      as a constant percentage from 0 min to gradient duration *)
      PercentP,
      {
        {0. Minute, myGradientGValue},
        (* If GradientDuration is Null, then default to 0 min
        (full GradientG will be expanded below to the max time)*)
        If[NullQ[myGradientDuration],
          Nothing,
          {myGradientDuration,myGradientGValue}
        ]
      },
      _,
      (* If Gradient option is specified, inherit GradientG from its value *)
      Switch[myGradientValue,
        (* If gradient tuples are specified, take the first index (time) and sixth (buffer G %) *)
        expandedGradientP,
        myGradientValue[[All,{1,8}]],
        _,
        (* If nothing is specified, BufferG is not used *)
        {}
      ]
    ];

    gradientHTimepoints = Switch[myGradientHValue,
      (* If timepoints are specified, use them *)
      {{TimeP,PercentP}...},myGradientHValue,
      (* If a single isocratic percent is specified, build gradient
      as a constant percentage from 0 min to gradient duration *)
      PercentP,
      {
        {0. Minute, myGradientHValue},
        (* If GradientDuration is Null, then default to 0 min
        (full GradientG will be expanded below to the max time)*)
        If[NullQ[myGradientDuration],
          Nothing,
          {myGradientDuration,myGradientHValue}
        ]
      },
      _,
      (* If Gradient option is specified, inherit GradientG from its value *)
      Switch[myGradientValue,
        (* If gradient tuples are specified, take the first index (time) and sixth (buffer H %) *)
        expandedGradientP,
        myGradientValue[[All,{1,9}]],
        _,
        (* If nothing is specified, BufferH is not used *)
        {}
      ]
    ];

    flowRateTimepoints = Switch[myFlowRateValue,
      (* If timepoints are specified, use them *)
      {{TimeP,FlowRateP}...},myFlowRateValue,
      (* If a single value then we create the time *)
      FlowRateP,
      {
        {0. Minute, myFlowRateValue},
        (* If GradientDuration is Null, then default to 0 min
        (full flowrate will be expanded below to the max time)*)
        If[NullQ[myGradientDuration],
          Nothing,
          {myGradientDuration,myFlowRateValue}
        ]
      },
      _,
      (* If Gradient option is specified, inherit flow rate from its value *)
      Switch[myGradientValue,
        (* If gradient tuples are specified, take the first index (time) and last index for the flow rate *)
        expandedGradientP,
        myGradientValue[[All,{1,10}]],
        _,
        (* If nothing is specified, flowrate is not used *)
        {}
      ]
    ];

    (* Fetch the times explicitly specified for each option *)
    gradientASpecifiedTimes = DeleteDuplicates[Sort[Convert[gradientATimepoints[[All,1]],Minute]],(#1==#2)&];
    gradientBSpecifiedTimes = DeleteDuplicates[Sort[Convert[gradientBTimepoints[[All,1]],Minute]],(#1==#2)&];
    gradientCSpecifiedTimes = DeleteDuplicates[Sort[Convert[gradientCTimepoints[[All,1]],Minute]],(#1==#2)&];
    gradientDSpecifiedTimes = DeleteDuplicates[Sort[Convert[gradientDTimepoints[[All,1]],Minute]],(#1==#2)&];
    gradientESpecifiedTimes = DeleteDuplicates[Sort[Convert[gradientETimepoints[[All,1]],Minute]],(#1==#2)&];
    gradientFSpecifiedTimes = DeleteDuplicates[Sort[Convert[gradientFTimepoints[[All,1]],Minute]],(#1==#2)&];
    gradientGSpecifiedTimes = DeleteDuplicates[Sort[Convert[gradientGTimepoints[[All,1]],Minute]],(#1==#2)&];
    gradientHSpecifiedTimes = DeleteDuplicates[Sort[Convert[gradientHTimepoints[[All,1]],Minute]],(#1==#2)&];
    flowRatesSpecificTimes = DeleteDuplicates[Sort[Convert[flowRateTimepoints[[All,1]],Minute]],(#1==#2)&];

    (* Extract the min and max times (the domain specified) *)
    {minATime,maxATime} = {Min[gradientASpecifiedTimes],Max[gradientASpecifiedTimes]};
    {minBTime,maxBTime} = {Min[gradientBSpecifiedTimes],Max[gradientBSpecifiedTimes]};
    {minCTime,maxCTime} = {Min[gradientCSpecifiedTimes],Max[gradientCSpecifiedTimes]};
    {minDTime,maxDTime} = {Min[gradientDSpecifiedTimes],Max[gradientDSpecifiedTimes]};
    {minETime,maxETime} = {Min[gradientESpecifiedTimes],Max[gradientESpecifiedTimes]};
    {minFTime,maxFTime} = {Min[gradientFSpecifiedTimes],Max[gradientFSpecifiedTimes]};
    {minGTime,maxGTime} = {Min[gradientGSpecifiedTimes],Max[gradientGSpecifiedTimes]};
    {minHTime,maxHTime} = {Min[gradientHSpecifiedTimes],Max[gradientHSpecifiedTimes]};

    (* Get all specified times (such that we can interpolate values for all times) *)
    specifiedTimes = DeleteDuplicates[
      Sort[
        Convert[
          Join[
            gradientASpecifiedTimes,
            gradientBSpecifiedTimes,
            gradientCSpecifiedTimes,
            gradientDSpecifiedTimes,
            gradientESpecifiedTimes,
            gradientFSpecifiedTimes,
            gradientGSpecifiedTimes,
            gradientHSpecifiedTimes,
            flowRatesSpecificTimes
          ],
          Minute
        ]
      ],
      (* Use == for the case where equivalent numbers like 0 and 0. are compared *)
      (#1 == #2)&
    ];

    (* Fetch final time *)
    maxTime = Max[specifiedTimes];

    (* Fetch initial time *)
    minTime = Min[specifiedTimes];

    (* Find all the specified times within the domain for each buffer gradient
    (these times we will interpolate to find the value of) *)
    interpolationTimepointsA = Cases[specifiedTimes,RangeP[minATime,maxATime]];
    interpolationTimepointsB = Cases[specifiedTimes,RangeP[minBTime,maxBTime]];
    interpolationTimepointsC = Cases[specifiedTimes,RangeP[minCTime,maxCTime]];
    interpolationTimepointsD = Cases[specifiedTimes,RangeP[minDTime,maxDTime]];
    interpolationTimepointsE = Cases[specifiedTimes,RangeP[minETime,maxETime]];
    interpolationTimepointsF = Cases[specifiedTimes,RangeP[minFTime,maxFTime]];
    interpolationTimepointsG = Cases[specifiedTimes,RangeP[minGTime,maxGTime]];
    interpolationTimepointsH = Cases[specifiedTimes,RangeP[minHTime,maxHTime]];

    (* Interpolate points that are not specified for each gradient *)
    (* Remove duplicate time points otherwise, this doesn't work *)
    interpolatedGradientALookup = AssociationThread[interpolationTimepointsA->getInterpolationValuesForTimes[DeleteDuplicatesBy[gradientATimepoints,First[#*1.]&],interpolationTimepointsA]];
    interpolatedGradientBLookup = AssociationThread[interpolationTimepointsB->getInterpolationValuesForTimes[DeleteDuplicatesBy[gradientBTimepoints,First[#*1.]&],interpolationTimepointsB]];
    interpolatedGradientCLookup = AssociationThread[interpolationTimepointsC->getInterpolationValuesForTimes[DeleteDuplicatesBy[gradientCTimepoints,First[#*1.]&],interpolationTimepointsC]];
    interpolatedGradientDLookup = AssociationThread[interpolationTimepointsD->getInterpolationValuesForTimes[DeleteDuplicatesBy[gradientDTimepoints,First[#*1.]&],interpolationTimepointsD]];
    interpolatedGradientELookup = AssociationThread[interpolationTimepointsE->getInterpolationValuesForTimes[DeleteDuplicatesBy[gradientETimepoints,First[#*1.]&],interpolationTimepointsE]];
    interpolatedGradientFLookup = AssociationThread[interpolationTimepointsF->getInterpolationValuesForTimes[DeleteDuplicatesBy[gradientFTimepoints,First[#*1.]&],interpolationTimepointsF]];
    interpolatedGradientGLookup = AssociationThread[interpolationTimepointsG->getInterpolationValuesForTimes[DeleteDuplicatesBy[gradientGTimepoints,First[#*1.]&],interpolationTimepointsG]];
    interpolatedGradientHLookup = AssociationThread[interpolationTimepointsH->getInterpolationValuesForTimes[DeleteDuplicatesBy[gradientHTimepoints,First[#*1.]&],interpolationTimepointsH]];

  (* Build tuples of each buffer composition for each specified time in the form {%A,%B,%C,%D,%E,%F,%G,%H} *)
  compositionTuples = Map[
    Function[time,
      Module[
        {gradientAValue,gradientBValue,gradientCValue,gradientDValue,defaultedCompositionTuple,
          totalComposition,bufferCompositions,gradientEValue, gradientFValue, gradientGValue, gradientHValue},

        (* Fetch value for each gradient at the current time. If the value is not specified,
        it means the timepoint is outside the gradient's specified range *)
        gradientAValue = Lookup[interpolatedGradientALookup,time,Null];
        gradientBValue = Lookup[interpolatedGradientBLookup,time,Null];
        gradientCValue = Lookup[interpolatedGradientCLookup,time,Null];
        gradientDValue = Lookup[interpolatedGradientDLookup,time,Null];
        gradientEValue = Lookup[interpolatedGradientELookup,time,Null];
        gradientFValue = Lookup[interpolatedGradientFLookup,time,Null];
        gradientGValue = Lookup[interpolatedGradientGLookup,time,Null];
        gradientHValue = Lookup[interpolatedGradientHLookup,time,Null];

        (* By default, set the gradient composition outside the specified range to 0 *)
        defaultedCompositionTuple = Replace[{
          gradientAValue,
          gradientBValue,
          gradientCValue,
          gradientDValue,
          gradientEValue,
          gradientFValue,
          gradientGValue,
          gradientHValue
        },Null->0 Percent,{1}];

        (* Calculate the total specified composition (ie: the summed percentages for each gradient) *)
        totalComposition = Total[defaultedCompositionTuple];

        (* Decide how to default the gradient values (if needed) *)
        bufferCompositions = Which[
          (* If the composition at the current timepoint is already 100% then we don't need to fill in any extra composition.
          If it is > 100% then the gradient specified is invalid and an error will be thrown downstream *)
          totalComposition >= 100 Percent, defaultedCompositionTuple,
          (* fill in the composition with the first entry that's available *)
          NullQ[gradientAValue],
            ReplacePart[defaultedCompositionTuple,1->(100 Percent - totalComposition)],
          NullQ[gradientBValue],
            ReplacePart[defaultedCompositionTuple,2->(100 Percent - totalComposition)],
          NullQ[gradientCValue],
            ReplacePart[defaultedCompositionTuple,3->(100 Percent - totalComposition)],
          NullQ[gradientDValue],
            ReplacePart[defaultedCompositionTuple,4->(100 Percent - totalComposition)],
          NullQ[gradientEValue],
            ReplacePart[defaultedCompositionTuple,5->(100 Percent - totalComposition)],
          NullQ[gradientFValue],
            ReplacePart[defaultedCompositionTuple,6->(100 Percent - totalComposition)],
          NullQ[gradientGValue],
            ReplacePart[defaultedCompositionTuple,7->(100 Percent - totalComposition)],
          (* If gradient H is being used, A, B, and C are specified, and D is not, fill in the remaining composition with D  *)
          (Length[gradientHTimepoints]>0)&&NullQ[gradientHValue],
            ReplacePart[defaultedCompositionTuple,8->(100 Percent - totalComposition)],
          (* Everything was specified and it still doesn't add to 100%  (in this case we throw error downstream) *)
          True, defaultedCompositionTuple
        ];

        (* Add time to first index of gradient timepoint *)
        Prepend[bufferCompositions,time]
      ]
    ],
    specifiedTimes
  ];

  (* If the minimum specified time is not 0 min, then extend the composition at the minimum time to 0 min *)
  protoCompositionTuples = If[minTime != 0 Minute,
    Prepend[
      compositionTuples,
      ReplacePart[First[compositionTuples],1 -> 0 Minute]
    ],
    compositionTuples
  ];

  (*if the composition tuples is still insufficient, tack on 10 minutes*)
  allCompositionTuples=If[Length[protoCompositionTuples]>1,
    protoCompositionTuples,
    Append[
      protoCompositionTuples,
      ReplacePart[First[compositionTuples], 1 -> 10 Minute]
    ]
  ];

  (* Fetch all times for FlowRate interpolation *)
  allTimes = allCompositionTuples[[All,1]];

  (* If the flowrate is a constant value, set same flow rate to all timepoints
  Otherwise, like the gradients above, interpolate its value and append the final timepoint *)
  allFlowRates = Which[
    MatchQ[myFlowRateValue,FlowRateP], Table[myFlowRateValue,Length[allTimes]],
    (*if the times are already equilvalent then we don't have to do anything*)
    myFlowRateValue[[All,1]]==allTimes,myFlowRateValue[[All,2]],
    (*otherwise, we'll need to interpolate*)
    True,getInterpolationValuesForTimes[
        DeleteDuplicatesBy[Append[myFlowRateValue,{maxTime,Last[myFlowRateValue[[All,2]]]}], UnitConvert[First[#*1.], Minute] &],
        allTimes
      ]
  ];

  (*form our initial gradient so far*)
  protoResolvedGradient=MapThread[
    Append,
    {allCompositionTuples,allFlowRates}
  ];

  (* Equilibration time *)
  gradientWithEquilibrationTime=If[NullQ[myEquilibrationTime],
    (* If equilibration time is Null, don't change anything *)
    protoResolvedGradient,

    (* If equilibration time was specified, honor it *)
    Module[{times, compositions, timeOne, compositionOne, timeTwo, compositionTwo},
      (* Get all of the timepoints and percent compositions of the gradient *)
      times=protoResolvedGradient[[All,1]];
      compositions=protoResolvedGradient[[All, 2 ;; -1]];

      (* Get the first composition *)
      compositionOne=compositions[[1]];

      (* Add a point at the start and shift the times of the later points accordingly *)
      Prepend[
        MapThread[Prepend[#2, #1] &, {(times + myEquilibrationTime), compositions}],
        Prepend[compositionOne, 0 Minute]
      ]
     ]
  ];

  (* Flush time *)
  gradientWithFlushTime=If[NullQ[myFlushTime],
    (* If flush time is Null, don't change anything *)
    gradientWithEquilibrationTime,

    (* If flush time was specified, honor it *)
    Module[{times, compositions, timeOne, compositionOne, timeTwo, compositionTwo},
      (* Get all of the timepoints and percent compositions of the gradient *)
      times=gradientWithEquilibrationTime[[All,1]];
      compositions=gradientWithEquilibrationTime[[All, 2 ;; -1]];

      (* Get the last timepoint and composition *)
      timeOne=times[[-1]];
      compositionOne=compositions[[-1]];

      (* Get the second to last timepoint and composition. In the weird case that only one time point is specified, use the last timepoint. *)
      timeTwo = If[Length[times] > 1, times[[-2]], times[[-1]]];
      compositionTwo = If[Length[times] > 1, compositions[[-2]], compositions[[-1]]];

      Which[
        (* If the last and second compositions are 100% B and the last and second to last time difference is the same as the equilibration time, don't change anything *)
        Equal[myFlushTime,(timeOne-timeTwo)]&&Equal[compositionOne[[2]],compositionTwo[[2]],100Percent],
        gradientWithEquilibrationTime,

        (* If the last and second compositions are 100% B and the last and second to last time difference is the not same as the equilibration time, adjust the last time point *)
        !Equal[myFlushTime,(timeOne-timeTwo)]&&Equal[compositionOne[[2]],compositionTwo[[2]],100Percent],
        MapIndexed[
          If[!MatchQ[#2, {Length[gradientWithEquilibrationTime]}],
            #1,
            Prepend[#1[[2 ;; -1]], (#1[[1]] + (myFlushTime - timeOne))]
          ] &, gradientWithEquilibrationTime],

        (* If the last point has 100%B, we just need to add another point at the end separated by the flush time *)
        Equal[compositionOne[[2]],100Percent],
          Append[gradientWithEquilibrationTime, {(timeOne + myFlushTime), 0Percent, 100Percent, 0Percent, 0Percent, 0Percent, 0Percent, 0Percent, 0Percent, Last@compositionOne}],

        (* Otherwise, add two points at the end with 100% separated by flush time *)
        True,
          Join[gradientWithEquilibrationTime,
            {{(timeOne + 0.1Minute), 0Percent, 100Percent, 0Percent, 0Percent, 0Percent, 0Percent, 0Percent, 0Percent, Last@compositionOne}},
            {{(timeOne + 0.1Minute + myFlushTime), 0Percent, 100Percent, 0Percent, 0Percent,  0Percent, 0Percent,  0Percent, 0Percent, Last@compositionOne}}
          ]
        ]
      ]
    ];

    (* Add in the myReferenceLoadingClosedQ information *)
    referenceLoadingStatus=If[MatchQ[myReferenceLoadingClosedQ,Open|Closed|None],
      ConstantArray[myReferenceLoadingClosedQ,Length[gradientWithFlushTime]],
      myReferenceLoadingClosedQ
    ];

    gradientWithReferenceLoading=MapThread[
      Append[#1,#2]&,
      {gradientWithFlushTime,referenceLoadingStatus}
    ];

    (*return this adjusted gradient*)
    gradientWithReferenceLoading

];

(* NOTE: This only works if the times are in Minutes *)
interpolationFunctionForGradient=Function[
  gradient,
  Interpolation[gradient,InterpolationOrder->1]
];
interpolatedPointsForTimesInSeconds[times_]:=Function[
  interpolationFunction,
  Map[
    Function[
      time,
      Which[
        time < Quantity[First[First[interpolationFunction["Domain"]]], "Second"], 0. Units@interpolationFunction[Quantity[First[First[interpolationFunction["Domain"]]], "Second"]],
        time > Quantity[Last[First[interpolationFunction["Domain"]]], "Second"], 0. Units@interpolationFunction[Quantity[Last[First[interpolationFunction["Domain"]]], "Second"]],
        True, interpolationFunction[time]
      ]
    ],
    times
  ]
];

(* NOTE: This only works if the times are in Minutes *)
getInterpolationValuesForTimesInSeconds[{}|Null,times_]:=Table[Quantity[0., "Percent"],{Length[times]}];
getInterpolationValuesForTimesInSeconds[{{time:TimeP,composition:(PercentP|FlowRateP)}},times_]:=Table[composition,{Length[times]}];
getInterpolationValuesForTimesInSeconds[gradient_,times_]:=RightComposition[
  interpolationFunctionForGradient,
  interpolatedPointsForTimesInSeconds[times]
][gradient];


(* --------------------------------- *)
(* -- aspiration caps memoization -- *)
(* --------------------------------- *)

(* gets packets for aspiration caps for use in HPLC, FPLC, Pack column and more *)
aspirationCapPackets[] := aspirationCapPackets[] = Module[{capModels},
  capModels = Search[Model[Item, Cap], Notebook == Alternatives[Null, $Notebook]];
  Download[capModels, Packet[Connectors, AspirationTubeLength, Deprecated, Objects, LevelSensorType]]
];


(* -------------------------- *)
(* -- Find Aspiration Caps -- *)
(* -------------------------- *)

(* a helper function to find a valid aspiration cap model for a given container model *)
(* it first checks the AspirationCaps field in Model[Container, Vessel] *)
(* if that is null or only contains deprecated models, it looks at the tubing length and the fittings (thread then dimensions) *)
(* there is a last resort in here such this function will always return something *)

(*Options*)

DefineOptions[
  findAspirationCap,
  Options:>{
    {
      OptionName->LevelSensorType,
      Default->Null,
      Description->"The type of level sensor mounting mechanism with which the caps being found must be compatible.",
      AllowNull->True,
      Widget->Widget[Type->Expression, Pattern:>LevelSensorTypeP,Size->Line],
      Category->"Compatibility"
    },
    CacheOption
  }
];

(* -- overload for singleton -- *)
findAspirationCap[container : ObjectP[Model[Container, Vessel]], options:OptionsPattern[findAspirationCap]] := FirstOrDefault[findAspirationCap[{container}, options]];

(* -- core function -- *)
findAspirationCap[containers : {ObjectP[Model[Container, Vessel]] ..}, options:OptionsPattern[findAspirationCap]] :=
    Module[{safeOptions, cache, capFastCache, levelSensorType, sortedCapPackets, capPackets, containerPackets},

      (*get the option values*)
      safeOptions = SafeOptions[findAspirationCap, ToList[options]];

      (*get cache*)
      cache = Lookup[safeOptions, Cache];

      (* get the level sensor type, defaulting to CapV1 if not set (All aspiration caps pre HexCaps were set to CapV1 - so this defaulting catches any cases where the findAspirationCap call isn't correctly providing LevelSensorType )*)
      levelSensorType = Lookup[safeOptions,LevelSensorType]/.Null->CapV1;

      (* use the memoizing helper to get a list of packets with the information we need for all public or owned (by $Notebook) Model[Item, Cap]*)
      capPackets = Experiment`Private`aspirationCapPackets[];

      (*make fastCache for easy lookups later*)
      capFastCache = Experiment`Private`makeFastAssocFromCache[capPackets];

      (*sort them by tubing length such that we will always pick the shortest tubing first*)
      sortedCapPackets = SortBy[capPackets, AspirationTubeLength];

      (* download information about the container *)
      containerPackets = Download[
        containers,
        Packet[Connectors, InternalDepth, Dimensions, AspirationCaps],
        Cache -> cache
      ];

      (* map over our packets and try to find a cap for each one *)
      Map[
        Function[packet,
          Module[{aspirationCapsFromContainer,aspirationCapsFromContainerPackets, notDeprecatedAspirationCapsPackets, sensorCompatibleAspirationCaps, validAspirationCaps, connectors,
            connectorsPatternFirstPass, connectorsPatternSecondPass, searchPattern, backupSearchPattern, firstPassPackets,
            secondPassPackets, desparationSearhPattern, desparationSearchPackets, allFoundCapPackets, sensorCompatibleCapPackets, selectedCapPacket, defaultCap},

            (*if the aspiration caps field is make sure its valid*)
            aspirationCapsFromContainer = Lookup[packet, AspirationCaps];

            If[
              aspirationCapsFromContainer == {},

              validAspirationCaps = Null,

              (*get the full packets for the objects from fastcache for easy lookups*)
              aspirationCapsFromContainerPackets = Lookup[capFastCache,Download[aspirationCapsFromContainer,Object]];

              (* just check that the thing is not deprecated *)
              notDeprecatedAspirationCapsPackets = PickList[
                aspirationCapsFromContainerPackets,
                Lookup[aspirationCapsFromContainerPackets, Deprecated],
                (False | Null)
              ];

              (* If LevelSensorType option is set, filter out any caps that don't match the given LevelSensorType, else don't filter *)
              sensorCompatibleAspirationCaps = If[
                MatchQ[levelSensorType,LevelSensorTypeP],
                PickList[
                  Lookup[notDeprecatedAspirationCapsPackets,Object],
                  Lookup[notDeprecatedAspirationCapsPackets, LevelSensorType],
                  levelSensorType
                ],
                Lookup[notDeprecatedAspirationCapsPackets,Object]
              ];

              (*if its empty, then get aspirationCapPackets - pick the last here since this field is probably getting appended to so that will be most recent*)
              validAspirationCaps = If[MatchQ[Length[sensorCompatibleAspirationCaps], GreaterP[0]],
                Last[sensorCompatibleAspirationCaps],
                Null
              ];
            ];

            (* if the AspirationCaps field was Null or it was deprecated, we need to find another cap *)
            If[MatchQ[validAspirationCaps, Null],

              (* our first pass search is going to be looking for something that has the exact same thread type and the right aspiration tubing depth*)
              (
                connectors = Lookup[packet, Connectors];
                (* -- First pass: try to find anything with the right depth and the exact threads -- *)

                (* look for anything that has the right thread and is Male/Female compatible *)
                connectorsPatternFirstPass = If[MatchQ[connectors, Except[($Failed | {})]],
                  Map[{"Inlet", #[[2]], #[[3]], _, _, #[[6]] /. {Male -> Female, Female -> Male}} &, connectors],
                  Null
                ];

                (* make a pattern to look for *)
                searchPattern = KeyValuePattern[
                  {
                    Connectors -> {___, Alternatives @@ connectorsPatternFirstPass, ___},
                    AspirationTubeLength -> RangeP[0.9*Lookup[packet, InternalDepth], 1.1*Lookup[packet, InternalDepth]]
                  }
                ];

                (* pull out any packets that match the first pattern *)
                firstPassPackets = Cases[sortedCapPackets, searchPattern];

                (* -- Second pass: try to find anything with the right depth and compatible ID/OD -- *)

                (* anything that is Male/Female compatible where the ID of the cap > OD of the vessel*)
                connectorsPatternSecondPass = If[MatchQ[connectors, Except[($Failed | {})]],
                  Map[{"Inlet", #[[2]], _, GreaterP[#[[5]]], _, #[[6]] /. {Male -> Female, Female -> Male}} &, connectors],
                  Null
                ];

                (* look for anything that has the right top and appropriate tubing length *)
                backupSearchPattern = KeyValuePattern[
                  {
                    Connectors -> {___, Alternatives @@ connectorsPatternSecondPass, ___},
                    AspirationTubeLength -> RangeP[0.9*Lookup[packet, InternalDepth], 1.1*Lookup[packet, InternalDepth]]
                  }
                ];

                (* pull out the compatible AspirationCaps *)
                (*here we also want to quickly sort by the cap size such that we don't return a cap that is way too big*)
                secondPassPackets = Quiet[SortBy[Cases[sortedCapPackets, backupSearchPattern], Lookup[#, Connectors][[4]]&]];

                (* -- Last pass: try to find something that will reach the bottom -- *)

                (*just find something that will reach the bottom*)
                desparationSearhPattern = KeyValuePattern[
                  AspirationTubeLength -> RangeP[0.9*Lookup[packet, InternalDepth], 1.1*Lookup[packet, InternalDepth]]
                ];
                desparationSearchPackets = Cases[sortedCapPackets, desparationSearhPattern];

                (* -- Default: get the largest cap and throw a warning that it might not fit -- *)
                (* since the container may be deeper than any tubing we have, need ot have the largest one last *)
                defaultCap = {
                  Cases[sortedCapPackets, KeyValuePattern[
                  AspirationTubeLength -> GreaterP[0.9*Lookup[packet, InternalDepth]]
                ]],
                  Last[Cases[sortedCapPackets, KeyValuePattern[AspirationTubeLength -> Except[Null]]]]
                };

                (* --  make a list of all our possibilities -- *)
                allFoundCapPackets = Flatten[{firstPassPackets, secondPassPackets, desparationSearchPackets, defaultCap}];

                (*  Filter out for LevelSensorType if given  *)
                sensorCompatibleCapPackets=If[
                  MatchQ[levelSensorType,LevelSensorTypeP],
                  PickList[
                    allFoundCapPackets,
                    Lookup[allFoundCapPackets, LevelSensorType],
                    levelSensorType
                  ],
                  allFoundCapPackets
                ];

                (* Take the first option since it will be the closest match*)
                selectedCapPacket = First[sensorCompatibleCapPackets];

                (* get the cap Object *)
                Lookup[selectedCapPacket, Object]
              ),
              (* if we have valid aspiration caps in the container model,
              just use that *)
              validAspirationCaps
            ]
          ]
        ],
        containerPackets
      ]
    ];