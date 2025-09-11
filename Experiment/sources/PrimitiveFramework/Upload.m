(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

(*::Subsection::*)
(*UploadUnitOperation*)

UnitOperationPrimitiveP:=Alternatives@@(
  Blank /@ DeleteDuplicates@Flatten[Lookup[Values[$PrimitiveSetPrimitiveLookup], Primitives][[All, All, 1]]]
);

DefineOptions[
  UploadUnitOperation,
  Options:>{
    IndexMatching[
      {
        OptionName->UnitOperationType,
        Default->Input,
        AllowNull->False,
        Widget->Widget[Type->Enumeration,Pattern:>UnitOperationTypeP],
        Description->"The type of this unit operation. Input Unit Operations contain the direct options specified by the user when calling ExperimentSample/CellPreparation. Optimized Unit Operations are functionally equivalent to the Input Unit Operations, but are rearranged and combined for optimized execution in the laboratory. Calculated Unit Operations are based off of the Optimized Unit Operations and contain the fully calculated set of options for laboratory execution. Output Unit Operations are based on the Calculated Unit Operations and contain additional experimental results (data objects etc). Batched Unit Operations contain the information necessary to process a single batch in a standalone manual protocol (ex. a Transfer protocol).",
        Category->"General"
      },
      {
        OptionName->Preparation,
        Default->Null,
        AllowNull->True,
        Widget->Widget[Type->Enumeration,Pattern:>PreparationMethodP],
        Description->"The method by which this primitive should be executed in the laboratory. Manual primitives are executed by a laboratory operator and Robotic primitives are executed by a liquid handling work cell.",
        Category->"General"
      },
      IndexMatchingInput->"unit operations"
    ],
    FastTrackOption,
    UploadOption,
    OutputOption
  }
];

(* Cache the allowed keys for our unit operation type. *)
allowedKeysForUnitOperationType[myType_]:=allowedKeysForUnitOperationType[myType]=Flatten[{
  Lookup[Lookup[Lookup[Lookup[Lookup[$PrimitiveSetPrimitiveLookup, Hold[ExperimentP]], Primitives], Last[myType]], OptionDefinition], "OptionSymbol"],
  Lookup[LookupTypeDefinition[myType], Fields][[All, 1]],
  PrimitiveMethod,
  PrimitiveMethodIndex
}];

(* Any fields that are not options (the user shouldn't be specifying these). *)
developerKeysForUnitOperationType[myType_]:=developerKeysForUnitOperationType[myType]=Flatten[{
  Complement[
    Lookup[LookupTypeDefinition[myType], Fields][[All, 1]],
    Lookup[Lookup[Lookup[Lookup[Lookup[$PrimitiveSetPrimitiveLookup, Hold[ExperimentP]], Primitives], Last[myType]], OptionDefinition], "OptionSymbol"]
  ],
  PrimitiveMethod,
  PrimitiveMethodIndex
}];

(* Install the listable overload. *)
(* NOTE: If FastTrack->True, we are assuming that our unit operation primitives are already index-matching expanded *)
(* by the primitive framework. *)
UploadUnitOperation[myPrimitives:ListableP[UnitOperationPrimitiveP],myOptions:OptionsPattern[]]:=Module[
  {listedOptions,outputSpecification,output,gatherTests,safeOptions,safeOptionTests,finalPrimitives,listedPrimitives,
    packetsToUpload,fastTrack,validLengths,validLengthTests,expandedSafeOps,invalidOptionKeysTest, invalidOptionValuesTest,
    indexMatchingTest,invalidRequiredOptions,listedPrimitivesWithoutAutomatics,result,finalPrimitivesWithoutName},

  (* Make sure we're working with a list of options *)
  listedPrimitives=ToList[myPrimitives];
  listedOptions=ToList[myOptions];

  (* Determine the requested return value from the function *)
  outputSpecification=If[!MatchQ[Lookup[listedOptions,Output],_Missing],
    Lookup[listedOptions,Output],
    Result
  ];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];
  fastTrack=Lookup[listedOptions, FastTrack, False];

  (* Call SafeOptions to make sure all options match pattern *)
  {safeOptions,safeOptionTests}=If[gatherTests,
    SafeOptions[UploadUnitOperation,listedOptions,Output->{Result,Tests},AutoCorrect->False],
    {SafeOptions[UploadUnitOperation,listedOptions,AutoCorrect->False],Null}
  ];

  (* If the specified options don't match their patterns return $Failed (or the tests up to this point)  *)
  If[MatchQ[safeOptions,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> safeOptionTests,
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (* Expand index-matching options *)
  expandedSafeOps = Last[ExpandIndexMatchedInputs[UploadUnitOperation,{listedPrimitives},safeOptions,Messages->False]];

  (* Call ValidInputLengthsQ to make sure all options are the right length *)
  {validLengths, validLengthTests} = If[gatherTests,
    ValidInputLengthsQ[UploadUnitOperation, {listedPrimitives}, expandedSafeOps, Output -> {Result, Tests}],
    {ValidInputLengthsQ[UploadUnitOperation, {listedPrimitives}, expandedSafeOps], Null}
  ];

  (* If option lengths are invalid return $Failed (or the tests up to this point) *)
  If[!validLengths,
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> Flatten[{safeOptionTests, validLengthTests}],
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null
    }]
  ];

  (* SafeOptions passed. Use SafeOptions to get the output format. *)
  outputSpecification=Lookup[safeOptions,Output];

  (* Remove any Automatics that we see in our primitive. *)
  (* NOTE: This will mean that the Input/Optimized unit operations may be missing some of their keys. This is a workaround *)
  (* because if we allowed for Automatics in all of our field definitions, we'd have to make everything a split field. We *)
  (* will remove this once engineering makes Constellation V4. *)
  listedPrimitivesWithoutAutomatics=Map[
    Function[{primitive},
      Head[primitive]@Module[{allowedKeys},
        (* Get the non-developer keys. *)
        allowedKeys=allowedKeysForUnitOperationType[Object[UnitOperation, Head[primitive]]];

        KeyValueMap[
          Function[{option, value},
            If[MemberQ[allowedKeys, option] && MemberQ[ToList[value], Automatic, 2],
              Nothing,
              option->value
            ]
          ],
          primitive[[1]]
        ]
      ]
    ],
    listedPrimitives
  ];

  (* -- Check that our primitives are valid -- *)
  finalPrimitives=If[!MatchQ[fastTrack,True],
    Module[
      {throwMessageWithPrimitiveIndex, allPrimitiveInformation, primitiveSetInformation,
        invalidPrimitiveOptionKeysWithIndices, invalidPrimitiveOptionPatternsWithIndices,
        flattenedIndexMatchingPrimitives,validLengthsQList,
        invalidPrimitiveRequiredOptionsWithIndices},

      (* Lookup information about our primitive set from our backend association. *)
      primitiveSetInformation=Lookup[$PrimitiveSetPrimitiveLookup, Hold[ExperimentP]];
      allPrimitiveInformation=Lookup[primitiveSetInformation, Primitives];

      (* Helper function to prepend primitive index information to a message association. *)
      throwMessageWithPrimitiveIndex[messageAssociation_, index_, preCallMessageLength_, messageIndex_]:=Module[{permanentlyIgnoredMessages},
        (* Only bother throwing the message if it's not Error::InvalidInput or Error::InvalidOption. *)
        (* NOTE: Also silence Warning::UnknownOption and Warning::AmountRounded since we're collecting all messages that would normally not show up if they're *)
        (* usually inside of a Quiet[...]. *)
        permanentlyIgnoredMessages = {Hold[Error::InvalidInput],Hold[Error::InvalidOption],Hold[Warning::UnknownOption], Hold[Warning::AmountRounded]};
        If[!MatchQ[Lookup[messageAssociation, MessageName], Alternatives@@permanentlyIgnoredMessages],
          Module[{messageTemplate, numberOfMessageArguments, specialHoldHead, messageSymbol, messageTag, newMessageTemplate},
            (* Get the text of our message template. *)
            messageTemplate=ReleaseHold[Lookup[messageAssociation, MessageName]];

            (* Get the number of arguments that we have. *)
            numberOfMessageArguments=Length[Lookup[messageAssociation, MessageArguments]];

            (* Create a special hold head that we will replace our Hold[messageName] with. *)
            SetAttributes[specialHoldHead, HoldAll];

            (* Extract the message symbol and tag. *)
            messageSymbol=Extract[Lookup[messageAssociation, MessageName], {1,1}];
            messageTag=Extract[Lookup[messageAssociation, MessageName], {1,2}];

            (* Create a new message template string. *)
            newMessageTemplate="The following message was thrown at primitive index `"<>ToString[numberOfMessageArguments+1]<>"`: "<>messageTemplate;

            (* If we are in CommandCenter, we need to gather the positions of the original message that is quieted by this function, but would still be captured by EvaluationData. Otherwise it is okay in MM. *)
            If[MatchQ[$ECLApplication, CommandCenter],
              Module[{currentMessagePosition},
                (* Find the position of the message during function call pre-modified in the overall $MessageList, so that we can delete it eventually *)
                (* At this point in the local helper, the position of the original message in the overall $MessageList is the current index plus the length of messages before calling the child function. *)
                (* It avoids messing up the position numbers if there's multiple calls of this framework function or ModifyFunctionMessages, or the function is throwing multiple message with some permanently quieted ones in between. *)
                (* It does not affect throwing the modified version of the message, which is thrown below in the With block. *)
                currentMessagePosition = preCallMessageLength + First[messageIndex];

                (* Keep track of the quieted messages using the global variable, that is used to filtered out from EvaluationData results in resolvedOptionsAssoc*)
                Which[
                  (* In framework function, it is possible that the primitive function call involves ModifyFunctionMessages, so that the currentMessagePosition would point to the message that was stored in $MessageList but already quieted by ModifyFunctionMessages. *)
                  (* In this case, the message that we modify in the chunk below and thus want to remove from final ResolvedOptionsJSON message list would actually be the next one in the $MessageList *)
                  MatchQ[$MessagePositionsToQuiet, _List] && IntegerQ[currentMessagePosition] && MemberQ[$MessagePositionsToQuiet, ToList[currentMessagePosition]],
                  AppendTo[$MessagePositionsToQuiet, ToList[currentMessagePosition+1]],
                  (* Otherwise this original message is to be removed from the final list in ResolvedOptionsJSON *)
                  MatchQ[$MessagePositionsToQuiet, _List] && IntegerQ[currentMessagePosition],
                  AppendTo[$MessagePositionsToQuiet, ToList[currentMessagePosition]],
                  True,
                  Nothing
                ]
              ]
            ];

            (* Block our the head of our message name. This prevents us from overwriting in the real codebase since *)
            (* message name information is stored in the LanguageDefinition under the head (see Language`ExtendedDefinition *)
            (* if you're interested). *)
            With[{insertedMessageSymbol=messageSymbol},
              Block[{insertedMessageSymbol},
                Module[{messageNameWithSpecialHoldHead, heldMessageSet},
                  (* Replace the hold around the message name with our special hold head. *)
                  messageNameWithSpecialHoldHead=Lookup[messageAssociation, MessageName]/.{Hold->specialHoldHead};

                  (* Create a held set that will overwrite the message name. *)
                  heldMessageSet=With[{insertMe1=messageNameWithSpecialHoldHead, insertMe2=newMessageTemplate},
                    Hold[insertMe1=insertMe2]
                  ]/.{specialHoldHead[sym_]:>sym};

                  (* Do the set. *)
                  ReleaseHold[heldMessageSet];

                  (* Throw the message that has been modified. *)
                  With[{insertMe=messageTag},
                    Message[
                      MessageName[insertedMessageSymbol, insertMe],
                      Sequence@@Append[Lookup[messageAssociation, MessageArguments], index]
                    ]
                  ]
                ]
              ]
            ]
          ]
        ]
      ];

      (* Keep track of invalid primitives to throw messages about. *)
      invalidPrimitiveOptionKeysWithIndices={};
      invalidPrimitiveOptionPatternsWithIndices={};
      invalidPrimitiveRequiredOptionsWithIndices={};

      (* Go through each of our primitives and check them. *)
      MapThread[
        Function[{currentPrimitive, primitiveIndex},
          Module[{primitiveDefinition, patternCheckablePrimitive},
            (* Get the definition for this primitive, within the primitive set. *)
            primitiveDefinition=Lookup[allPrimitiveInformation, Head[currentPrimitive]];

            (* Drop any keys that shouldn't be in our primitive for pattern checking purposes. We build our pattern *)
            (* based on the legit options only. *)
            (* NOTE: Internally strip any Resource[...] blobs just for the pattern check. *)
            patternCheckablePrimitive=Head[currentPrimitive]@KeyDrop[
              Normal[currentPrimitive[[1]]],
              developerKeysForUnitOperationType[Object[UnitOperation, Head[currentPrimitive]]]
            ];

            (* Make sure that for the primitive head that we have, all the options match their pattern. *)
            If[!MatchQ[patternCheckablePrimitive, Lookup[primitiveDefinition, Pattern]],
              Module[{options, allowedKeys, invalidOptionKeys, invalidOptionPatterns, requiredOptions, missingRequiredOptions},
                (* Get the primitive options. *)
                options=Lookup[Lookup[primitiveDefinition, OptionDefinition], "OptionSymbol"];

                (* Get the allowed keys. These are the options plus the fields. *)
                allowedKeys=allowedKeysForUnitOperationType[Object[UnitOperation, Head[currentPrimitive]]];

                (* Get any options that don't exist in the primitive definition. *)
                invalidOptionKeys=Complement[
                  Keys[patternCheckablePrimitive[[1]]],
                  allowedKeys
                ];

                If[Length[invalidOptionKeys]>0,
                  AppendTo[invalidPrimitiveOptionKeysWithIndices, {invalidOptionKeys, primitiveIndex, Head[currentPrimitive]}];
                ];

                (* Get any options that don't match their pattern. *)
                invalidOptionPatterns=KeyValueMap[
                  Function[{option, value},
                    If[!MemberQ[options, option],
                      Nothing,
                      Module[{optionPattern},
                        (* Get the pattern for this option. If the option doesn't exist in the definition, just skip over it because it *)
                        (* will be covered by our invalidOptionKeys check. *)
                        (* For each option, if we have an ObjectP[], allow for a Resource as well. This is for develop uploads. *)
                        optionPattern=ReleaseHold@Lookup[
                          FirstCase[
                            Lookup[primitiveDefinition, OptionDefinition],
                            KeyValuePattern["OptionSymbol"->option],
                            <|"Pattern"->_|>
                          ]/.{pat : Verbatim[ObjectP][___] :> _Resource | _Link | pat},
                          "Pattern"
                        ];

                        If[!MatchQ[value, optionPattern],
                          option,
                          Nothing
                        ]
                      ]
                    ]
                  ],
                  patternCheckablePrimitive[[1]]
                ];

                If[Length[invalidOptionPatterns]>0,
                  AppendTo[invalidPrimitiveOptionPatternsWithIndices, {invalidOptionPatterns, primitiveIndex, Head[currentPrimitive]}];
                ];

                (* Detect if we are missing required options. *)
                requiredOptions=Lookup[Cases[Lookup[primitiveDefinition, OptionDefinition], KeyValuePattern["Required"->True]], "OptionSymbol"];
                missingRequiredOptions=Complement[requiredOptions, Keys[currentPrimitive[[1]]]];

                If[Length[missingRequiredOptions]>0,
                  AppendTo[invalidPrimitiveRequiredOptionsWithIndices, {missingRequiredOptions, primitiveIndex, Head[currentPrimitive]}];
                ];
              ]
            ]
          ]
        ],
        {listedPrimitivesWithoutAutomatics, Range[Length[listedPrimitivesWithoutAutomatics]]}
      ];

      invalidOptionKeysTest=If[gatherTests,
        Test["Our unit operations do not have any invalid options (that do not exist):",True,Length[invalidPrimitiveOptionKeysWithIndices]==0],
        Nothing
      ];

      If[Length[invalidPrimitiveOptionKeysWithIndices]>0,
        Message[Error::InvalidUnitOperationOptions, invalidPrimitiveOptionKeysWithIndices[[All,1]], invalidPrimitiveOptionKeysWithIndices[[All,2]], invalidPrimitiveOptionKeysWithIndices[[All,3]], UploadUnitOperation];
      ];

      invalidOptionValuesTest=If[gatherTests,
        Test["Our unit operations do not have any invalid values (that do not match their expected patterns):",True,Length[invalidPrimitiveOptionPatternsWithIndices]==0],
        Nothing
      ];

      If[Length[invalidPrimitiveOptionPatternsWithIndices]>0,
        Message[Error::InvalidUnitOperationValues, invalidPrimitiveOptionPatternsWithIndices[[All,1]], invalidPrimitiveOptionPatternsWithIndices[[All,2]], invalidPrimitiveOptionPatternsWithIndices[[All,3]], UploadUnitOperation];
      ];

      invalidRequiredOptions=If[gatherTests,
        Test["Our unit operations are not missing any of their required options:",True,Length[invalidPrimitiveRequiredOptionsWithIndices]==0],
        Nothing
      ];

      If[Length[invalidPrimitiveRequiredOptionsWithIndices]>0,
        Message[Error::InvalidUnitOperationRequiredOptions, invalidPrimitiveRequiredOptionsWithIndices[[All,1]], invalidPrimitiveRequiredOptionsWithIndices[[All,2]], invalidPrimitiveRequiredOptionsWithIndices[[All,3]], UploadUnitOperation];
      ];

      If[Or[
        Length[invalidPrimitiveOptionKeysWithIndices]>0,
        Length[invalidPrimitiveOptionPatternsWithIndices]>0,
        Length[invalidPrimitiveRequiredOptionsWithIndices]>0
      ],
        Message[
          Error::InvalidInput,
          listedPrimitives[[DeleteDuplicates[Flatten[{
            invalidPrimitiveOptionKeysWithIndices[[All,2]],
            invalidPrimitiveOptionPatternsWithIndices[[All,2]],
            invalidPrimitiveRequiredOptionsWithIndices[[All,2]]
          }]]]]
        ];

        Return[outputSpecification/.{
          Result->$Failed,
          Tests -> Flatten[{
            safeOptionTests,
            invalidOptionKeysTest,
            invalidOptionValuesTest,
            invalidRequiredOptions
          }],
          Options -> safeOptions,
          Preview -> Null
        }];
      ];

      (* Expand the options for each of our primitives so that we have index-matching. *)
      (* Since ExpandIndexMatchedInputs only works on functions, we have to make a "fake" function with the same information *)
      (* as our primitive so that we can do the expanding. *)
      {flattenedIndexMatchingPrimitives, validLengthsQList}=Transpose@MapThread[
        Function[{primitive, primitiveIndex},
          Block[{placeholderFunction},
            Module[
              {primitiveInformation, optionDefinition, primaryInputOption, otherInputOptions, inputLengthForPrimitive,
                optionsWithListedPrimaryInput, expandedPrimitive,  validLengthsQ, onlyDeveloperKeys, optionsWithoutDeveloperKeys},
              (* Lookup our primitive information. *)
              primitiveInformation=Lookup[Lookup[primitiveSetInformation, Primitives], Head[primitive], {}];

              (* Lookup the option definition of this primitive. *)
              (* For each option, if we have an ObjectP[], allow for a Resource as well. This is for develop uploads. *)
              optionDefinition=Lookup[primitiveInformation, OptionDefinition]/.{pat : Verbatim[ObjectP][___] :> _Resource | _Link | pat};

              (* Take the option definition for the head of this primitive and set it as the option definition of our fake function. *)
              (* NOTE: Have to overwrite the option definition here to make DestinationWell/AliquotContainer index matching. *)
              (* Case on whether the primitive is nested index matching or not. If it is, we need to pass NestedIndexMatching->True to *)
              (* OverwriteAliquotOptions in order to get the wanted form of the options *)
              If[Lookup[FirstCase[optionDefinition,KeyValuePattern[{"OptionSymbol"->First[Lookup[primitiveInformation,InputOptions]]}]],"NestedIndexMatching"],
                placeholderFunction /: OptionDefinition[placeholderFunction] = OverwriteAliquotOptionDefinition[placeholderFunction, optionDefinition, NestedIndexMatching->True],
                placeholderFunction /: OptionDefinition[placeholderFunction] = OverwriteAliquotOptionDefinition[placeholderFunction, optionDefinition]
              ];

              (* NOTE: Even though we shouldn't have any inputs, we have to put some inputs and output here, otherwise DefineUsage *)
              (* will get angry. There is no index matching to the usage, so this is just for show. *)
              DefineUsage[placeholderFunction,
                {
                  BasicDefinitions -> {
                    {
                      Definition -> {"ExperimentAbsorbanceIntensity[samples]", "protocol"},
                      Description -> "",
                      Inputs :> {
                        {
                          InputName -> "samples",
                          Description -> "The samples to be measured.",
                          Widget -> Adder[Widget[
                            Type -> Enumeration,
                            Pattern :> Alternatives[Null]
                          ]],
                          Expandable -> False
                        }
                      },
                      Outputs :> {
                        {
                          OutputName -> "protocol",
                          Description -> "A protocol object for measuring absorbance of samples at a specific wavelength.",
                          Pattern :> ObjectP[Object[Protocol, AbsorbanceIntensity]]
                        }
                      }
                    }
                  },
                  SeeAlso -> {
                    "Download"
                  },
                  Author -> {
                    "thomas"
                  }
                }
              ];

              (* Get our primary input option. *)
              primaryInputOption=FirstOrDefault[Lookup[primitiveInformation, InputOptions], Null];

              (* Make sure we have other options as well because they need to index match *)
              otherInputOptions=Cases[ToList[Lookup[primitiveInformation, InputOptions]],Except[primaryInputOption]];

              inputLengthForPrimitive=If[MatchQ[Lookup[primitive[[1]], primaryInputOption],_List],
                Null,
                Length[
                  FirstCase[Lookup[primitive[[1]],otherInputOptions,Null],_List,{}]
                ]
              ];

              (* Always ToList our primary input option. This is because if we are given ONLY singletons, the expander will *)
              (* leave everything as a singleton. We always want lists for consistency. *)
              (* NOTE: Make sure not to ToList if our primary input option isn't IndexMatching (as in the case of Wait). *)
              (* NOTE: This logic is mirrored in the Primitive Framework so make sure that if it changes here to also change it there. *)
              optionsWithListedPrimaryInput=If[And[
                MatchQ[primaryInputOption, Except[Null]],
                KeyExistsQ[primitive[[1]], primaryInputOption],
                !MatchQ[
                  Lookup[FirstCase[optionDefinition, KeyValuePattern["OptionSymbol"->primaryInputOption], <||>], "IndexMatching", "None"],
                  "None"
                ],
                (* NOTE: If there's already an expanded input or option, we don't have to ToList our primary input. In fact, we cannot *)
                (* since if another input is over length 1, this will cause our primitive to not expand. *)
                !MemberQ[
                  (
                    If[!KeyExistsQ[primitive[[1]], Lookup[#, "OptionSymbol"]],
                      True,
                      MatchQ[
                        Lookup[primitive[[1]], Lookup[#, "OptionSymbol"]],
                        ReleaseHold@Lookup[
                          #,
                          "SingletonPattern",
                          _
                        ]
                      ]
                    ]
                  &)/@Cases[optionDefinition, KeyValuePattern["IndexMatchingParent"->ToString@primaryInputOption]],
                  False
                ]
              ],
                Normal@Append[
                  primitive[[1]],
                  primaryInputOption-> {Lookup[primitive[[1]], primaryInputOption]}
                ],
                Normal@(primitive[[1]])
              ];

              (* Remove any developer keys. *)
              optionsWithoutDeveloperKeys=Normal@KeyDrop[
                optionsWithListedPrimaryInput,
                developerKeysForUnitOperationType[Object[UnitOperation, Head[primitive]]]
              ];

              (* Only get the developer keys (assume expanded). *)
              onlyDeveloperKeys=Cases[
                optionsWithListedPrimaryInput,
                Verbatim[Rule][Alternatives@@developerKeysForUnitOperationType[Object[UnitOperation, Head[primitive]]], _]
              ];

              (* If we don't have any options at all, then don't try to expand the options. *)
              expandedPrimitive=If[Length[optionsWithListedPrimaryInput]>0,
                Head[primitive]@Association@Join[
                  (ExpandIndexMatchedInputs[
                    placeholderFunction,
                    (* We don't have an input, but just pass down Null to make the expander happy. *)
                    {ConstantArray[Null, Length[ToList[Lookup[primitive[[1]], primaryInputOption]]]]},
                    optionsWithoutDeveloperKeys,
                    1,
                    (* NOTE: We do our own error checking, so we don't want any errors or messages here. *)
                    FastTrack -> True
                  ][[2]]),
                  onlyDeveloperKeys
                ],
                primitive
              ];

              (* See if this primitive has an index matching issue. *)
              validLengthsQ=Module[{myMessageList, messageHandler, validLengthsResult, preValidLengthMessageLength},
                myMessageList = {};

                (* Get the current count of total messages before calling ValidInputLengthsQ *)
                preValidLengthMessageLength = Length[$MessageList];

                messageHandler[one_String, two:Hold[msg_MessageName], three:Hold[Message[msg_MessageName, args___]]] := Module[{},
                  (* Keep track of the messages thrown during evaluation of the test. *)
                  AppendTo[myMessageList, <|MessageName->Hold[msg],MessageArguments->ToList[args]|>];
                ];

                validLengthsResult=SafeAddHandler[{"MessageTextFilter", messageHandler},
                  (* Are our index-matched options valid? *)
                  (* Block $Messages so that our messages aren't printed out. *)
                  Block[{$Messages},
                    ValidInputLengthsQ[
                      placeholderFunction,
                      {ConstantArray[Null, Length[ToList[Lookup[primitive[[1]], primaryInputOption]]]]},
                      optionsWithoutDeveloperKeys
                    ]
                  ]
                ];

                (* If they are not, throw some messages with prepended primitive index information. *)
                If[MatchQ[validLengthsResult, False],
                  MapIndexed[
                    throwMessageWithPrimitiveIndex[#1, primitiveIndex, preValidLengthMessageLength, #2]&,
                    myMessageList
                  ]
                ];

                validLengthsResult
              ];

              {
                expandedPrimitive,
                validLengthsQ
              }
            ]
          ]
        ],
        {listedPrimitivesWithoutAutomatics, Range[Length[listedPrimitivesWithoutAutomatics]]}
      ];

      indexMatchingTest=If[gatherTests,
        Test["Our unit operation's options have proper index matching, if applicable:",True,MatchQ[validLengthsQList, {True..}]],
        Nothing
      ];

      (* If we threw a valid lengths error, return $Failed. *)
      (* NOTE: We do this down here because we also want to throw pattern doesn't match errors before we return early. *)
      If[MemberQ[validLengthsQList, False],
        Return[outputSpecification/.{
          Result->$Failed,
          Tests -> Flatten[{
            safeOptionTests,
            invalidOptionKeysTest,
            invalidOptionValuesTest,
            indexMatchingTest,
            invalidRequiredOptions
          }],
          Options -> safeOptions,
          Preview -> Null
        }];
      ];

      (* Return our expanded primitives. *)
      flattenedIndexMatchingPrimitives
    ],
    (* Assume the primitives are valid and already expanded. *)
    Module[{},
      invalidOptionKeysTest=If[gatherTests,
        Test["Our unit operations do not have any invalid options (that do not exist):",True,True],
        Nothing
      ];

      invalidOptionValuesTest=If[gatherTests,
        Test["Our unit operations do not have any invalid values (that do not match their expected patterns):",True,True],
        Nothing
      ];

      indexMatchingTest=If[gatherTests,
        Test["Our unit operation's options have proper index matching, if applicable:",True,True],
        Nothing
      ];

      invalidRequiredOptions=If[gatherTests,
        Test["Our unit operations are not missing any of their required options:",True,True],
        Nothing
      ];

      listedPrimitivesWithoutAutomatics
    ]
  ];

  (* Drop the Name option if it's in our primitive because we don't want to be setting the option of our UO objects. *)
  finalPrimitivesWithoutName=(Head[#]@KeyDrop[#[[1]], Name]&)/@finalPrimitives;

  (*-- Basic checks of input and option validity passed. We are ready to map over the inputs and options. --*)

  (* We want to get all of the messages thrown by the function while not showing them to the user. *)
  (* Internal`InheritedBlock inherits the DownValues of Message while allowing block-scoped modification. *)
  packetsToUpload=MapThread[
    Function[{primitive, unitOperationType, preparation},
      uploadUnitOperationCore[primitive, UnitOperationType->unitOperationType, Preparation->preparation]
    ],
    {finalPrimitivesWithoutName, Lookup[expandedSafeOps, UnitOperationType], Lookup[expandedSafeOps, Preparation]}
  ];

  (* Compute our result. *)
  result=If[Lookup[safeOptions,Upload]&&!MemberQ[packetsToUpload,Null],
    Module[{allObjects,filteredObjects},
      allObjects=Upload[packetsToUpload];
      DeleteDuplicates[Cases[allObjects,ObjectP[Object[UnitOperation]]]]
    ],
    (* ELSE: Just return our packets with IDs. *)
    MapThread[Append[#1, Object->#2]&, {packetsToUpload, CreateID[Lookup[packetsToUpload, Type]]}]
  ];

  (* Return the output in the specification wanted. *)
  Return[outputSpecification/.{
    Result-> If[MatchQ[myPrimitives, _List],
      result,
      First[result]
    ],
    Tests -> Flatten[{
      safeOptionTests,
      invalidOptionKeysTest,
      invalidOptionValuesTest,
      indexMatchingTest,
      invalidRequiredOptions
    }],
    Options -> safeOptions,
    Preview -> Null
  }]
];

uploadUnitOperationCore[myInput:UnitOperationPrimitiveP,myOptions:OptionsPattern[]]:=Module[
  {listedOptions,outputSpecification,output,gatherTests,unitOperationType,unitOperationFieldDefinitions,changePacket,
    primitiveAssociation,fieldNameToSplitFieldsLookup,associationWithSplitFields,addBacklinks},

  (* Make sure we're working with a list of options *)
  listedOptions=ToList[myOptions];

  (* Determine the requested return value from the function *)
  outputSpecification=Lookup[ToList[myOptions],Output];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];

  (* --- Generate our formatted upload packet --- *)
  (* Get our primitive as an association. *)
  primitiveAssociation=myInput[[1]];

  (* Create our change packet based on the unit operation input. *)
  unitOperationType=Object[UnitOperation, Head[myInput]];
  unitOperationFieldDefinitions=Lookup[LookupTypeDefinition[unitOperationType], Fields];

  (* Group the fields that are split up into multiple fields right now because of alternative classes. *)
  fieldNameToSplitFieldsLookup=Constellation`Private`getUnitOperationsSplitFieldsLookup[unitOperationType];

  (* Go through our primitive and if a field isn't in our official object definition, try to the correspondance in *)
  (* fieldNameToSplitFieldsLookup. *)
  associationWithSplitFields=Association@KeyValueMap[
    Function[{option, value},
      Which[
        (* NOTE: Make sure that our option value is a list if the field ia a multiple becuase we're going to try to map *)
        (* over it later. *)
        KeyExistsQ[unitOperationFieldDefinitions, option],
          If[MatchQ[Lookup[LookupTypeDefinition[unitOperationType, option], Format], Multiple],
            option->ToList[value],
            option->value
          ],
        KeyExistsQ[fieldNameToSplitFieldsLookup, option],
          Module[{multipleFieldQ, listedValue},
            (* Only list for multiple fields. *)
            multipleFieldQ=MatchQ[
              Lookup[LookupTypeDefinition[unitOperationType, First@Lookup[fieldNameToSplitFieldsLookup, option]], Format],
              Multiple
            ];

            listedValue = If[And[
              multipleFieldQ,
              Or[
                !MatchQ[value, _List],
                (* NOTE: The pattern for multiple fields is actually of the single value. So, if we have a single match here and we don't have an all-match, then we have to add an extra list *)
                (* note that this means if you have Sample -> {"string1", "string2"} for a pooled field and it could go into SampleString -> {"string1", "string2"} or SampleExpression -> {{"string1", "string2"}}, it will pick the first one *)
                And[
                  MemberQ[
                    MatchQ[value, Lookup[LookupTypeDefinition[unitOperationType, #], Pattern]/.{Verbatim[_Link] :> (ObjectReferenceP[] | _Link | _Resource)}] & /@ Lookup[fieldNameToSplitFieldsLookup, option],
                    True
                  ],
                  MatchQ[
                    MatchQ[value, {(Lookup[LookupTypeDefinition[unitOperationType, #], Pattern] | Null)...}]/.{Verbatim[_Link] :> (ObjectReferenceP[] | _Link | _Resource)} & /@ Lookup[fieldNameToSplitFieldsLookup, option],
                    {False..}
                  ]
                ]
              ]
            ],
              {value},
              value
            ];

            If[MatchQ[multipleFieldQ, True],
              Module[{initializedSplitFields, patternsToFields},
                (* Initialize each of these split fields. *)
                initializedSplitFields=Association[
                  Map[
                    # -> If[Length[LookupTypeDefinition[unitOperationType, #, Class]]>1,
                      ConstantArray[Null, {Length[listedValue], Length[LookupTypeDefinition[unitOperationType, #, Class]]}],
                      ConstantArray[Null, Length[listedValue]]
                    ]&,
                    Lookup[fieldNameToSplitFieldsLookup, option]
                  ]
                ];

                (* Create a lookup between patterns to fields. *)
                patternsToFields=(Lookup[Lookup[unitOperationFieldDefinitions, #], Pattern] -> #&)/@Lookup[fieldNameToSplitFieldsLookup, option];

                (* Go through the list and find the first "real" field that matches it. *)
                MapThread[
                  Function[{singletonValue, index},
                    Module[{firstMatchingSplitField, previousFieldValue},
                      (* What fields should we put this value into? *)
                      firstMatchingSplitField=FirstCase[
                        patternsToFields/.{Verbatim[_Link] :> (ObjectReferenceP[] | _Link | _Resource)},
                        Verbatim[Rule][
                          _?(MatchQ[singletonValue, #]&),
                          field_
                        ]:>field,
                        First[patternsToFields][[2]]
                      ];

                      (* Write into that field. *)
                      previousFieldValue=initializedSplitFields[firstMatchingSplitField];
                      previousFieldValue[[index]]=singletonValue;

                      initializedSplitFields[firstMatchingSplitField] = previousFieldValue;
                    ]
                  ],
                  {listedValue, Range[Length[listedValue]]}
                ];

                (* Return our split fields. *)
                Sequence@@(Normal@initializedSplitFields)
              ],
              Module[{patternsToFields, firstMatchingSplitField},
                (* Create a lookup between patterns to fields. *)
                patternsToFields=(Lookup[Lookup[unitOperationFieldDefinitions, #], Pattern] -> #&)/@Lookup[fieldNameToSplitFieldsLookup, option];

                (* What fields should we put this value into? *)
                (* NOTE: _Link can match on an object because we'll add the link wrapper around it later. *)
                firstMatchingSplitField=FirstCase[
                  patternsToFields/.{Verbatim[_Link] :> (ObjectReferenceP[] | _Link | _Resource)},
                  Verbatim[Rule][
                    _?(MatchQ[listedValue, #]&),
                    field_
                  ]:>field,
                  First[patternsToFields][[2]]
                ];

                (* Return that split field pointing to the value. *)
                firstMatchingSplitField->listedValue
              ]
            ]
          ],
        True,
          Nothing
      ]
    ],
    primitiveAssociation
  ];

  (* Go through our cleaned association with split fields and change into proper change packet syntax. *)
  changePacket=Association@Join[
    KeyValueMap[
      Function[{optionSymbol,optionValue},
        Module[{fieldDefinition,formattedOptionSymbol},
          (* Get the information about this specific field. *)
          fieldDefinition=Association@Lookup[unitOperationFieldDefinitions,optionSymbol];

          (* Format our option symbol. *)
          (*If the Append options is true, switch the multiple field options to Append, otherwise Replace as usual*)
          formattedOptionSymbol=Switch[Lookup[fieldDefinition,Format],
            Single,
              optionSymbol,
            Multiple,
              Replace[optionSymbol]
          ];

          (* Based on the class of our field, we have to format the values differently. *)
          Switch[Lookup[fieldDefinition, Class],
            Link,
              (* If it's the Protocol field and they've already given us a link, don't touch it. *)
              If[MatchQ[optionValue, Protocol] && MatchQ[optionValue, _Link],
                formattedOptionSymbol->optionValue,
                Module[{relationsList,backlinkMap},
                  (* Convert our Relation field into a list of relations. *)
                  relationsList=If[MatchQ[Lookup[fieldDefinition,Relation],_Alternatives],
                    List@@Lookup[fieldDefinition,Relation],
                    ToList[Lookup[fieldDefinition,Relation]]
                  ];

                  (* Build the type \[Rule] backlink mapping. *)
                  backlinkMap=(
                    If[!MatchQ[#,TypeP[]],
                      obj:ObjectReferenceP[Head[#]]:>Link[obj,Sequence@@#],
                      obj:ObjectReferenceP[Head[#]]:>Link[obj]
                    ]
                  &)/@relationsList;

                  (* Apply the backlink mapping. *)
                  (* NOTE: Don't apply linking if we have a resource. UploadProtocol/RequireResources will do that for us. *)
                  formattedOptionSymbol->If[MatchQ[Lookup[fieldDefinition, Format], Multiple],
                    (If[MatchQ[#, _Resource | Verbatim[Link][_Resource, ___]], #, (#/.{link:LinkP[]:>Download[link,Object]})/.backlinkMap]&)/@optionValue,
                    (If[MatchQ[#, _Resource | Verbatim[Link][_Resource, ___]], #, (#/.{link:LinkP[]:>Download[link,Object]})/.backlinkMap]&)[optionValue]
                  ]
                ]
              ],
            (* Named Single/Multiple *)
            {_Rule..},
              formattedOptionSymbol->Module[{listedValue, convertedListedValue},
                (* Convert our field to a multiple, if it is not already one. *)
                listedValue=If[MatchQ[Lookup[fieldDefinition, Format], Single],
                  {optionValue},
                  optionValue
                ];

                (* Add links for link indices. *)
                convertedListedValue=Map[
                  Function[{namedSingle},
                    MapThread[
                      Function[{indexName, indexClass, singletonOptionValue},
                        indexName->If[MatchQ[indexClass, Link],
                          Module[{relationsList,backlinkMap},
                            (* Convert our Relation field into a list of relations. *)
                            relationsList=If[MatchQ[Lookup[Lookup[fieldDefinition,Relation], indexName], _Alternatives],
                              List@@Lookup[Lookup[fieldDefinition,Relation], indexName],
                              ToList[Lookup[Lookup[fieldDefinition,Relation], indexName]]
                            ];

                            (* Build the type \[Rule] backlink mapping. *)
                            backlinkMap=(
                              If[!MatchQ[#,TypeP[]],
                                obj:ObjectReferenceP[Head[#]]:>Link[obj,Sequence@@#],
                                obj:ObjectReferenceP[Head[#]]:>Link[obj]
                              ]
                            &)/@relationsList;

                            (* Apply the backlink mapping. *)
                            (* NOTE: Don't apply linking if we have a resource. UploadProtocol/RequireResources will do that for us. *)
                            (If[MatchQ[#, _Resource | Verbatim[Link][_Resource, ___]], #, (#/.{link:LinkP[]:>Download[link,Object]})/.backlinkMap]&)[singletonOptionValue]
                          ],
                          singletonOptionValue
                        ]
                      ],
                      {Lookup[fieldDefinition, Class][[All,1]], Lookup[fieldDefinition, Class][[All,2]], Values[namedSingle]}
                    ]
                  ],
                  listedValue
                ];

                (* Delist. *)
                If[MatchQ[Lookup[fieldDefinition, Format], Single],
                  First[convertedListedValue],
                  convertedListedValue
                ]
              ],
            (* Indexed Single/Multiple *)
            {_Symbol..},
              formattedOptionSymbol->Module[{listedValue, listedValueExpandedNull, convertedListedValue},
                (* Convert our field to a multiple, if it is not already one. *)
                listedValue=If[MatchQ[Lookup[fieldDefinition, Format], Single],
                  {optionValue},
                  optionValue
                ];

                (* If the value is Null - expand again so we have proper form *)
                listedValueExpandedNull = Map[
                  If[MatchQ[#,Null],ConstantArray[#,Length[Lookup[fieldDefinition, Class]]],#]&,
                  listedValue
                ];

                (* Add links for link indices. *)
                convertedListedValue=Map[
                  Function[{indexedSingle},
                    MapThread[
                      Function[{index, indexClass, singletonOptionValue},
                        If[MatchQ[indexClass, Link],
                          Module[{relationsList,backlinkMap},
                            (* Convert our Relation field into a list of relations. *)
                            relationsList=If[MatchQ[Lookup[fieldDefinition,Relation][[index]], _Alternatives],
                              List@@Lookup[fieldDefinition,Relation][[index]],
                              ToList[Lookup[fieldDefinition,Relation][[index]]]
                            ];
                            
                            (* Build the type \[Rule] backlink mapping. *)
                            backlinkMap=(
                              If[!MatchQ[#,TypeP[]],
                                obj:ObjectReferenceP[Head[#]]:>Link[obj,Sequence@@#],
                                obj:ObjectReferenceP[Head[#]]:>Link[obj]
                              ]
                            &)/@relationsList;

                            (* Apply the backlink mapping. *)
                            (* NOTE: Don't apply linking if we have a resource. UploadProtocol/RequireResources will do that for us. *)
                            (If[MatchQ[#, _Resource | Verbatim[Link][_Resource, ___]], #, (#/.{link:LinkP[]:>Download[link,Object]})/.backlinkMap]&)[singletonOptionValue]
                          ],
                          singletonOptionValue
                        ]
                      ],
                      {Range[Length[Lookup[fieldDefinition, Class]]], Lookup[fieldDefinition, Class], indexedSingle}
                    ]
                  ],
                  listedValueExpandedNull
                ];

                (* Delist. *)
                If[MatchQ[Lookup[fieldDefinition, Format], Single],
                  First[convertedListedValue],
                  convertedListedValue
                ]
              ],
            _,
              formattedOptionSymbol->optionValue
          ]
        ]
      ],
      associationWithSplitFields
    ],
    (* Add in the type information. *)
    {
      Type->unitOperationType,
      UnitOperationType->Lookup[listedOptions, UnitOperationType],
      Preparation->Lookup[listedOptions, Preparation]
    }
  ];

  (* Return our change packet. *)
  changePacket
];
