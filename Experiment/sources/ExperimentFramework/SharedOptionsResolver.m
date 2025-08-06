(* ::Package::*)

(* ::Text:: *)
(* \[Copyright] 2011-2023 Emerald Cloud Lab, Inc. *)

(* ::Subsection:: *)
(* resolveSharedOptions *)

(*

Input Quick Reference:

myChildFunction - Name of function whose options need to be resolved
myErrorMessagePrefix - A string that will prefix the returned errors to provide more information on the source of where the error was thrown
mySamplePackets - The SamplePackets for all potential samples to be resolved
myResolverMasterSwitches - A list of Booleans that are True for samples that need to be passed through the child resolver
myOptionMap - A list of rules that converts OptionNames parent->child functions
      NOTE: Only options in the option map will be output by the function. If an option does not have it's name changed in the parent function but should be output by resolveSharedOptions, map that function to itself i.e. {OptionName->OptionName}
myOptions - The options that will be passed to the child resolver as a list of rules i.e. for 2 input samples, {OptionA->{Value1, Value2}, OptionB->Automatic, ...}
myConstantOptions - A list of Options that need to be set for all samples in the childResolver
myMapThreadOptions - MapThreaded options that correspond to myOptions i.e. a list of associations {<|OptionA->Value1, OptionB->Automatic,...|>, <|OptionA->Value2, OptionB->Automatic,...|>}
gatherTestsQ - A Boolean for if Tests should be gathered and returned
myResolutionOptions - The myResolutionOptions passed down from the parentFunction's resolver i.e. Cache or Simulation
AdditionalInputs-> {InputA->{1,2,3}, InputB->{4,5,6}, ...} where the {1,2,3} and {4,5,6} are index matched to mySamplePackets. Used when resolving functions that take more than one input such as ExperimentTransfer

NOTE: only returns resolved options that are in the optionMap. Other options are used as inputs but are not returned

*)

DefineOptions[
  resolveSharedOptions,
  Options:> {
    {
      OptionName -> AdditionalInputs,
      Default -> Null,
      Description -> "Additional inputs that may be needed to run myChildFunction. Specify as a list for each additional input (i.e. {{InputA Sample1, InputA Sample2,...}, {InputB Sample1, InputB Sample2,...},...} ) which should be index matched to mySamplePackets.",
      AllowNull -> True,
      Category -> "General",
      Widget->Widget[
        Type->Expression,
        Pattern :> {_List..},
        Size->Line
      ]
    },
    DebugOption,
    CacheOption,
    SimulationOption
  }
];

Error::AdditionalInputsNotIndexMatching = "The AdditionalInputs option `1` must be index matched to mySamplePackets which has a length of `2`.";
Error::MultipleOptionValueInputs = "The following options, `1`, are specified in both the input options and the constant options. Only one option value can be used for resolution. Please specify the option in either the input options or the constant options for a valid resolution.";

resolveSharedOptions[
  myChildFunction_Symbol,
  myErrorMessagePrefix_String,
  mySamplePackets:{(PacketP[Object[Sample]]|ObjectP[Model[Sample]])...},(*Model[Sample] should also be supported after experiments are supporting model input. No specific info from the packets are used in this helper*)
  myResolverMasterSwitches:{BooleanP..},
  myOptionMap:{_Rule...},
  myOptions:{_Rule...},
  myConstantOptions:{_Rule...},
  myMapThreadOptions:{_Association..},
  gatherTestsQ:BooleanP,
  myResolutionOptions:OptionsPattern[resolveSharedOptions]
] := Module[
  {safeOptions, mySamples, cache, simulation, samplesToResolve, mapThreadOptionsToResolve, resolverErrorsThrownQ, resolvedChildOptions,
    newSimulation, childResolverTests, callChildResolverQ, fullyResolvedOptions, myResolverMasterSwitchPositions, childResolverCalledPositions, debugQ, additionalInputs, additionalInputsNotIndexMatchingQ, doubleInputOptions, additionalInputsToResolve},

  (* Get our safe options. *)
  safeOptions=SafeOptions[resolveSharedOptions, ToList[myResolutionOptions]];

  (* Lookup our cache and simulation. *)
  cache = Lookup[safeOptions, Cache];
  simulation = Lookup[safeOptions, Simulation];

  (*gather additional inputs*)
  debugQ = Lookup[safeOptions, Debug];
  additionalInputs = Lookup[safeOptions, AdditionalInputs];
  (*Get an object format of samples*)
  mySamples = If[MatchQ[#,PacketP[Object[Sample]]],
    Lookup[#,Object],
    #
  ]& /@ mySamplePackets;

  (*check that the additional inputs are index matched to the sample packets*)
  additionalInputsNotIndexMatchingQ = !MatchQ[additionalInputs, Null] && !MatchQ[Length/@additionalInputs, {Length[mySamplePackets]..}];

  If[additionalInputsNotIndexMatchingQ,
    Message[Error::AdditionalInputsNotIndexMatching, additionalInputs, Length[mySamplePackets]];
    Return[$Failed];
  ];

  (* Check that options are not both in myOptions and myConstantOptions. *)
  doubleInputOptions = Map[
    Function[{optionSymbol},
      If[
        KeyExistsQ[myOptions, optionSymbol] && KeyExistsQ[myConstantOptions, optionSymbol],
        optionSymbol,
        Nothing
      ]
    ],
    myOptionMap[[All,1]]
  ];

  If[
    Length[doubleInputOptions]>0,
    Message[Error::MultipleOptionValueInputs, doubleInputOptions];
    Return[$Failed];
  ];

  (*This will indicates if we should send each sample down to the myResolverFunction we do this if (and only if) each of the options specified matches the pattern in myResolverFunction*)
  (*For example some of the LysisSharedOptions can be set to Null but are not allowed to be Null in ExperimentLysis*)
  callChildResolverQ=Module[{childOptionsToPatternLookup},
    childOptionsToPatternLookup=Rule @@@ Lookup[OptionDefinition[myChildFunction], {"OptionSymbol", "Pattern"}];
    MapThread[
      Function[{resolveBool, options},
        And[
          MatchQ[resolveBool,True],
          And@@KeyValueMap[
            Function[{optionSymbol, newOptionSymbol},
              Module[{optionValue},

                If[
                  debugQ && !MatchQ[Lookup[options, optionSymbol], ReleaseHold@Lookup[childOptionsToPatternLookup, newOptionSymbol]],
                  Echo[optionSymbol -> Lookup[options, optionSymbol],"Option input does not match pattern:"];
                ];

                (* Convert from shared option to child function option. *)
                If[KeyExistsQ[options, optionSymbol],
                  optionValue = Lookup[options, optionSymbol];
                  (*checking if options in parent name match pattern of the equivalent option in child function*)
                  MatchQ[optionValue, ReleaseHold@Lookup[childOptionsToPatternLookup, newOptionSymbol]],
                  True
                ]
              ]
            ],
            Association[myOptionMap]
          ]
        ]
      ],
      {myResolverMasterSwitches, myMapThreadOptions}
    ]
  ];

  If[
    debugQ,
    Echo[PickList[mySamples, callChildResolverQ, True], "Samples going into child function:"];
    Echo[PickList[mySamples, callChildResolverQ, False], "Samples NOT going into child function:"];
  ];

  (* Figure out the samples and options that need to be passed down to the child function resolver. *)
  samplesToResolve=PickList[mySamples, callChildResolverQ, True];
  mapThreadOptionsToResolve=PickList[myMapThreadOptions, callChildResolverQ, True];

  (*Gather additionalInputs to resolve. Need to specify Map levelspec in case additionalInputs are lists of lists*)
  additionalInputsToResolve = Map[
    PickList[#, callChildResolverQ, True]&,
    additionalInputs, 1
      ];

  (* Call child resolver function. *)
  {resolverErrorsThrownQ, resolvedChildOptions, newSimulation, childResolverTests}=If[Length[samplesToResolve]==0,
    {False, {}, Null, {}},
    Module[{gatherSimulationQ,helperOutputQ},
      (* A bool to check if the childResolver we are calling can output Simulation or not, b/c some helper resolvers cannot *)
      gatherSimulationQ=MatchQ[Simulation,ReleaseHold@Lookup[FirstCase[OptionDefinition[myChildFunction],KeyValuePattern["OptionSymbol"->Output]],"Pattern"]];
      (* A bool to check whether the childResolver we are calling outputs a list of options when Output->Result (for most helper resolvers) or Output->Options (for most experiment functions) *)
      helperOutputQ=!MatchQ[Options,ReleaseHold@Lookup[FirstCase[OptionDefinition[myChildFunction],KeyValuePattern["OptionSymbol"->Output]],"Pattern"]];
      Which[
        (*If we are gathering tests, and it was specified in the call to run with OptionsResolverOnly->True*)
        MatchQ[gatherTestsQ,True]&&KeyExistsQ[myConstantOptions,OptionsResolverOnly]&&MatchQ[Lookup[myConstantOptions,OptionsResolverOnly],True],
        Module[{errorsThrownQ,options,tests},
          {errorsThrownQ,{options,tests}}=ModifyFunctionMessages[
            myChildFunction,
            If[MatchQ[additionalInputs,Null],
              {samplesToResolve},
              {samplesToResolve,Sequence@@additionalInputsToResolve}
            ],
            myErrorMessagePrefix<>ObjectToString[samplesToResolve]<>": ",
            myOptionMap,
            Join[
              (* For each original option given in the option map, KeyValueMap uses the option map to lookup *)
              Module[
                {optionDefinition},
                optionDefinition=OptionDefinition[myChildFunction];
                KeyValueMap[
                  Function[{optionSymbol,newOptionSymbol},
                    Which[
                      !KeyExistsQ[myOptions,optionSymbol],
                      Nothing,
                      MatchQ[Lookup[FirstCase[optionDefinition,KeyValuePattern["OptionSymbol"->newOptionSymbol]],"IndexMatchingInput"],Null],
                      newOptionSymbol->First[Lookup[mapThreadOptionsToResolve,optionSymbol]],
                      True,
                      newOptionSymbol->Lookup[mapThreadOptionsToResolve,optionSymbol]
                    ]
                  ],
                  Association[myOptionMap]
                ]
              ],
              myConstantOptions,
              {Output->{Options,Tests}}
            ],
            Simulation->simulation,
            Cache->cache
          ];

          {errorsThrownQ,options,Null,tests}
        ],
        (*If we are gathering tests with no particular requirement of OptionsResolverOnly*)
        MatchQ[gatherTestsQ,True],
        Module[{errorsThrownQ,options,newSimulation,tests},
          (* If the childResolver we are calling can output Simulation, output the simulation *)
          If[gatherSimulationQ,
            {errorsThrownQ,{options,newSimulation,tests}}=ModifyFunctionMessages[
              myChildFunction,
              If[MatchQ[additionalInputs,Null],
                {samplesToResolve},
                {samplesToResolve,Sequence@@additionalInputsToResolve}
              ],
              myErrorMessagePrefix<>ObjectToString[samplesToResolve]<>": ",
              myOptionMap,
              Join[
                (* For each original option given in the option map, KeyValueMap uses the option map to lookup *)
                Module[
                  {optionDefinition},
                  optionDefinition=OptionDefinition[myChildFunction];
                  KeyValueMap[
                    Function[{optionSymbol,newOptionSymbol},
                      Which[
                        !KeyExistsQ[myOptions,optionSymbol],
                        Nothing,
                        MatchQ[Lookup[FirstCase[optionDefinition,KeyValuePattern["OptionSymbol"->newOptionSymbol]],"IndexMatchingInput"],Null],
                        newOptionSymbol->First[Lookup[mapThreadOptionsToResolve,optionSymbol]],
                        True,
                        newOptionSymbol->Lookup[mapThreadOptionsToResolve,optionSymbol]
                      ]
                    ],
                    Association[myOptionMap]
                  ]
                ],
                myConstantOptions,
                {Output->{
                  If[!helperOutputQ,Options,Result],
                  Simulation,
                  Tests
                }}
              ],
              Simulation->simulation,
              Cache->cache
            ],
            (* Otherwise do not include Simulation in the output specification *)
            {errorsThrownQ,{options,tests}}=ModifyFunctionMessages[
              myChildFunction,
              If[MatchQ[additionalInputs,Null],
                {samplesToResolve},
                {samplesToResolve,Sequence@@additionalInputsToResolve}
              ],
              myErrorMessagePrefix<>ObjectToString[samplesToResolve]<>": ",
              myOptionMap,
              Join[
                (* For each original option given in the option map, KeyValueMap uses the option map to lookup *)
                Module[
                  {optionDefinition},
                  optionDefinition=OptionDefinition[myChildFunction];
                  KeyValueMap[
                    Function[{optionSymbol,newOptionSymbol},
                      Which[
                        !KeyExistsQ[myOptions,optionSymbol],
                        Nothing,
                        MatchQ[Lookup[FirstCase[optionDefinition,KeyValuePattern["OptionSymbol"->newOptionSymbol]],"IndexMatchingInput"],Null],
                        newOptionSymbol->First[Lookup[mapThreadOptionsToResolve,optionSymbol]],
                        True,
                        newOptionSymbol->Lookup[mapThreadOptionsToResolve,optionSymbol]
                      ]
                    ],
                    Association[myOptionMap]
                  ]
                ],
                myConstantOptions,
                {Output->{
                  If[!helperOutputQ,Options,Result],
                  Tests
                }}
              ],
              Simulation->simulation,
              Cache->cache
            ];
            newSimulation=Null
          ];
          (* Gather and output these results *)
          {errorsThrownQ,options,newSimulation,tests}
        ],
        (*If we are not gathering tests, and it was specified in the call to run with OptionsResolverOnly->True*)
        KeyExistsQ[myConstantOptions,OptionsResolverOnly]&&MatchQ[Lookup[myConstantOptions,OptionsResolverOnly],True],
        Module[{errorsThrownQ,options},
          {errorsThrownQ,{options}}=ModifyFunctionMessages[
            myChildFunction,
            If[MatchQ[additionalInputs,Null],
              {samplesToResolve},
              {samplesToResolve,Sequence@@additionalInputsToResolve}
            ],
            myErrorMessagePrefix<>ObjectToString[samplesToResolve]<>": ",
            myOptionMap,
            Join[
              (* For each original option given in the option map, KeyValueMap uses the option map to lookup *)
              Module[
                {optionDefinition},
                optionDefinition=OptionDefinition[myChildFunction];
                KeyValueMap[
                  Function[{optionSymbol,newOptionSymbol},
                    Which[
                      !KeyExistsQ[myOptions,optionSymbol],
                      Nothing,
                      MatchQ[Lookup[FirstCase[optionDefinition,KeyValuePattern["OptionSymbol"->newOptionSymbol]],"IndexMatchingInput"],Null],
                      newOptionSymbol->First[Lookup[mapThreadOptionsToResolve,optionSymbol]],
                      True,
                      newOptionSymbol->Lookup[mapThreadOptionsToResolve,optionSymbol]
                    ]
                  ],
                  Association[myOptionMap]
                ]
              ],
              myConstantOptions,
              {Output->{Options}}
            ],
            Simulation->simulation,
            Cache->cache
          ];

          {errorsThrownQ,options,Null,{}}
        ],
        (*Otherwise, we are not gathering tests and no OptionsResolverOnly*)
        True,
        Module[{errorsThrownQ,options,newSimulation},
          (* If the childResolver we are calling can output Simulation, output the simulation *)
          If[gatherSimulationQ,
            {errorsThrownQ,{options,newSimulation}}=ModifyFunctionMessages[
              myChildFunction,
              If[MatchQ[additionalInputs,Null],
                {samplesToResolve},
                {samplesToResolve,Sequence@@additionalInputsToResolve}
              ],
              myErrorMessagePrefix<>ObjectToString[samplesToResolve]<>": ",
              myOptionMap,
              Join[
                (* For each original option given in the option map, KeyValueMap uses the option map to lookup *)
                Module[
                  {optionDefinition},
                  optionDefinition=OptionDefinition[myChildFunction];
                  KeyValueMap[
                    Function[{optionSymbol,newOptionSymbol},
                      Which[
                        !KeyExistsQ[myOptions,optionSymbol],
                        Nothing,
                        MatchQ[Lookup[FirstCase[optionDefinition,KeyValuePattern["OptionSymbol"->newOptionSymbol]],"IndexMatchingInput"],Null],
                        newOptionSymbol->First[Lookup[mapThreadOptionsToResolve,optionSymbol]],
                        True,
                        newOptionSymbol->Lookup[mapThreadOptionsToResolve,optionSymbol]
                      ]
                    ],
                    Association[myOptionMap]
                  ]
                ],
                myConstantOptions,
                {Output->{
                  (* If the Child Resolver we are calling has Options as one of the Output patterns, set Output->Options, otherwise the Child Resolver is likely a helper and has HelperOutputOption, set Output->Result *)
                  If[!helperOutputQ,Options,Result],
                  Simulation
                }}
              ],
              Simulation->simulation,
              Cache->cache
            ],
            (* Otherwise do not include Simulation in the output specification *)
            {errorsThrownQ,{options}}=ModifyFunctionMessages[
              myChildFunction,
              If[MatchQ[additionalInputs,Null],
                {samplesToResolve},
                {samplesToResolve,Sequence@@additionalInputsToResolve}
              ],
              myErrorMessagePrefix<>ObjectToString[samplesToResolve]<>": ",
              myOptionMap,
              Join[
                (* For each original option given in the option map, KeyValueMap uses the option map to lookup *)
                Module[
                  {optionDefinition},
                  optionDefinition=OptionDefinition[myChildFunction];
                  KeyValueMap[
                    Function[{optionSymbol,newOptionSymbol},
                      Which[
                        !KeyExistsQ[myOptions,optionSymbol],
                        Nothing,
                        MatchQ[Lookup[FirstCase[optionDefinition,KeyValuePattern["OptionSymbol"->newOptionSymbol]],"IndexMatchingInput"],Null],
                        newOptionSymbol->First[Lookup[mapThreadOptionsToResolve,optionSymbol]],
                        True,
                        newOptionSymbol->Lookup[mapThreadOptionsToResolve,optionSymbol]
                      ]
                    ],
                    Association[myOptionMap]
                  ]
                ],
                myConstantOptions,
                {Output->{
                  If[!helperOutputQ,Options,Result]
                }}
              ],
              Simulation->simulation,
              Cache->cache
            ];
            newSimulation=Null
          ];
          (* Gather and output these results *)
          {errorsThrownQ,options,newSimulation,{}}
        ]
      ]
    ]
  ];

  (* Get the positions of all the resolver master switches that are True and inteded to go through the childResolver. *)
  myResolverMasterSwitchPositions=Flatten[Position[myResolverMasterSwitches,True]];

  (* Get the positions of all the options that made it through to the childResolver. *)
  childResolverCalledPositions=Flatten[Position[callChildResolverQ,True]];

  (* Map over all Symbols/Options which were provided and either output unchanged, or changed options, based on what made it through the childResolver *)
  fullyResolvedOptions=Map[
    Function[optionSymbol,
      (* Module serves to temporarily make two separate lists based on original and new options *)
      Module[{inputOptions, indexMatchedQ, nestedIndexMatchedQ, resolvedOptions},

        (* Check if the option being resolved is index-matched. *)
        indexMatchedQ = If[
          KeyExistsQ[Options[myChildFunction], ToString[Lookup[myOptionMap, optionSymbol]]],
          !MatchQ[Lookup[FirstCase[OptionDefinition[myChildFunction], KeyValuePattern["OptionSymbol" -> Lookup[myOptionMap, optionSymbol]]], "IndexMatchingInput"],Null],
          False
        ];

        (* Check if the option being resolved is index-matched. *)
        nestedIndexMatchedQ = If[
          KeyExistsQ[Options[myChildFunction], ToString[Lookup[myOptionMap, optionSymbol]]],
          MatchQ[Lookup[FirstCase[OptionDefinition[myChildFunction], KeyValuePattern["OptionSymbol" -> Lookup[myOptionMap, optionSymbol]]], "NestedIndexMatching"],True],
          False
        ];

        (* Gather the input options for the option symbol. *)
        inputOptions=Which[
          (* If the option is not index-matched (or has nested index-matching) and in myConstantOptions, then the input is used as-is.*)
          (* NOTE:Mixed masterswitches for nested index-matching not currently supported, so treated as all True for replacement currently. *)
          And[
            KeyExistsQ[myConstantOptions, optionSymbol],
            Or[
              !indexMatchedQ,
              nestedIndexMatchedQ
            ]
          ],
            Lookup[myConstantOptions, optionSymbol],
          (* If the optionSymbol is in myConstantOptions and collapsed to one value, then expands it to be *)
          (* index-matched to mySamplePackets for replacement. *)
          KeyExistsQ[myConstantOptions, optionSymbol] && !MatchQ[Length[ToList[Lookup[myConstantOptions, optionSymbol]]], Length[mySamplePackets]],
            ConstantArray[Lookup[myConstantOptions, optionSymbol], Length[mySamplePackets]],
          (* If otherwise found in myConstantOptions, then used as the inputOptions. *)
          KeyExistsQ[myConstantOptions, optionSymbol],
            ToList[Lookup[myConstantOptions, optionSymbol]],
          (* If the option is not index-matched and in myOptions, then the input is used as-is.*)
          !indexMatchedQ,
            Lookup[myOptions, optionSymbol],
          (* If the option from myOptions is collapsed to one value, then expands it to be *)
          (* index-matched to mySamplePackets for replacement.*)
          !MatchQ[Length[ToList[Lookup[myOptions, optionSymbol]]], Length[mySamplePackets]],
            ConstantArray[Lookup[myOptions, optionSymbol], Length[mySamplePackets]],
          (* If the option from myOptions is index-matched to mySamplePackets and not a constant, then used *)
          (* as the input option directly. *)
          True,
            ToList[Lookup[myOptions, optionSymbol]]
        ];

        (* Gather all the options that made it through the childResolver. *)
        (* If the resolvedChildOption is index-matched to the number of samples that went into the child function *)
        (* then the resolved option is used directly for replacement. Otherwise, it is expanded to be index-matched *)
        (* to the number of samples that went into the child function. *)
        resolvedOptions=Which[
          (* If no options were resolved, then resolvedOptions returned as Null.*)
          MatchQ[Length[myResolverMasterSwitchPositions], 0] || MatchQ[Length[childResolverCalledPositions], 0],
            Null,
          (* If the option is not index-matched (or has nested index-matching), then the resolved option is used as-is (not in a list, single value).*)
          (* NOTE:Mixed masterswitches for nested index-matching not currently supported, so treated as all True for replacement currently. *)
          !indexMatchedQ || nestedIndexMatchedQ,
            Lookup[resolvedChildOptions, optionSymbol],
          (* If the number of resolved option values matches the number of True masterswitch values, then it is *)
          (* index-matched correctly to the samples and used as-is (in a list, index-matched to samples that were resolved. *)
          MatchQ[Length[ToList[Lookup[resolvedChildOptions, optionSymbol]]], Length[myResolverMasterSwitchPositions]],
            ToList[Lookup[resolvedChildOptions, optionSymbol]],
          (* Otherwise, the resolved option value is expanded (if needed) to be replaced. *)
          True,
            Module[{childOptionSymbol, expandedInputs},

              childOptionSymbol = Lookup[myOptionMap, optionSymbol];

              expandedInputs = ExpandIndexMatchedInputs[myChildFunction, {samplesToResolve}, {childOptionSymbol -> Lookup[resolvedChildOptions, optionSymbol]}];

              Lookup[expandedInputs[[2]], childOptionSymbol]

            ]
        ];

        (* Now make the OuputSymbol/OptionName -> (Input Options replaced by any newly resolvedOptions for any that made it through the childResolver). *)
        optionSymbol -> Which[
          (* If no samples had their options resolved, then the input options (with Automatic -> Null) is used as the resolved value. *)
          MatchQ[myResolverMasterSwitchPositions, {}] || MatchQ[Length[childResolverCalledPositions], 0],
            inputOptions /. Automatic->Null,
          (* If the option is not index-matched, then the singular resolved value is used as the resolved option value. *)
          (* We assume that nested-index matching option has been taken care of in the child resolver such that it always return a list of list *)
          !indexMatchedQ,
            resolvedOptions,
          (* Otherwise, input options are replaced by resolved output options if the sample was resolved by the child function. *)
          True,
            ReplacePart[
              inputOptions /. Automatic->Null,
              MapThread[
                #1 -> #2 &,
                {childResolverCalledPositions,resolvedOptions}
              ]
            ]
        ]

      ]
    ],
    myOptionMap[[All,1]] (* Grabs all input Option Names and Maps through them *)
  ];

  {
    fullyResolvedOptions,
    newSimulation,
    childResolverTests
  }
];