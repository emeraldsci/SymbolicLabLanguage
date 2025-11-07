(* ::Package:: *)

(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section::Closed:: *)
(*Work Cell to Model Lookup*)


(* ::Code::Initialization:: *)
(* NOTE: List the liquid handlers from smaller to larger here. The order in which they are listed is the preference *)
(* order and we'd like to use the smaller liquid handlers over the larger liquid handlers, if possible, because they're *)
(* cheaper. *)
$WorkCellsToInstruments=<|
  STAR->{
    Model[Instrument, LiquidHandler, "id:kEJ9mqaW7xZP"], (* "Hamilton STARlet" *)
    Model[Instrument, LiquidHandler, "id:7X104vnRbRXd"], (* "Super STAR" *)
    Model[Instrument, LiquidHandler, "id:N80DNjkzez5W"], (*"Super STAR (with PlateWasher)"*)
    Model[Instrument, LiquidHandler, "id:R8e1PjeLn8Bj"] (* "Super STAR (Limited)" *)
  },
  bioSTAR->{
    Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"]
  },
  microbioSTAR->{
    Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"]
  },
  qPix->{
    Model[Instrument, ColonyHandler, "id:mnk9jORxz0El"]
  }
|>;

$InstrumentsToWorkCells:=Flatten[
  MapThread[
    Function[{models, cellName}, # -> cellName&/@models],
    {Values[$WorkCellsToInstruments], Keys[Experiment`Private`$WorkCellsToInstruments]}
  ],
  1
];

$WorkCellToExperimentFunction=<|
  STAR -> ExperimentRoboticSamplePreparation,
  bioSTAR -> ExperimentRoboticCellPreparation,
  microbioSTAR -> ExperimentRoboticCellPreparation,
  qPix -> ExperimentRoboticCellPreparation
|>;

ScriptGeneratingPrimitiveFunctionP=Experiment|ExperimentSamplePreparation|ExperimentCellPreparation;
ManualPrimitiveMethodsP=Experiment|ManualSamplePreparation|ManualCellPreparation;
RoboticPrimitiveMethodsP=Experiment|RoboticSamplePreparation|RoboticCellPreparation;

PrimitiveMethodsP=Experiment|ManualSamplePreparation|RoboticSamplePreparation|ManualCellPreparation|RoboticCellPreparation;

(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(* ExperimentSamplePreparation *)


(* ::Code::Initialization:: *)
Error::InvalidUnitOperationHeads="The following unit operation types, `1`, at indices, `2`, are not allowed unit operation types for `3`. Please consult the documentation for `3` or construct your experiment call in the command builder.";
Error::InvalidUnitOperationOptions="The following options, `1`, at indices, `2`, are not valid options for the unit operations, `3`, in `4`. Please only specify valid options for the unit operations chosen.";
Error::InvalidUnitOperationValues="The following options, `1`, at indices, `2`, do not match the allowed pattern for the unit operations, `3`, in `4`. Please make sure that these options match their allowed patterns for `3`.";
Error::InvalidUnitOperationRequiredOptions="The following options, `1`, are required to specify a valid `3` unit operation at indices, `2`, for `4`. Please specify these options in order to specify a valid experiment.";
Error::InvalidUnitOperationMethods="The following methods, `1`, at positions, `2`, are not valid methods for `3`. The supported methods for `3` are `4`. Please remove any incorrectly specified unit operation methods to create a protocol";
Error::InvalidMethodOptions="The following unit operation method heads, `1`, at indices, `3`, have the following invalid options, `2`. Please remove these options in order to specific a valid unit operation method head.";
Error::InvalidMultipleUnitOperationGroups="The inputted unit operations require `1` groupings in order to run in the given order, `2`, via the following preparation methods `3`. Please call the function Experiment[...] instead if you wish to run these unit operations. The current function only supports running one group of unit operations at a time.";
Error::NoWorkCellsPossibleForUnitOperation="The unit operation, `1`, at index, `2`, requires too many containers or instruments in a single work cell when combined with the previous unit operations and thus cannot be executed with the previous unit operations on the same work cell. This `1` unit operation requires, `3` additional container footprints, `4` additional instruments, and `5` additional tips. This results in a total of `6` container footprints, `7` instruments, `8` stacked tip positions of type `9`, and `10` non-stacked tip positions of type `11` for the work cell group. Please split up these unit operations into multiple groups or let ExperimentSamplePreparation automatically resolve the unit operation grouping. Please consult the ExperimentRoboticSamplePreparation/ExperimentRoboticCellPreparation documentation for more information about the available work cells.";
Error::UnknownLabels="The following label(s), `1`, are not defined for the following unit operations at indices, `2`, for unit operations, `3`. Please make sure that the given labels are all defined using another unit operation (such as LabelSample or LabelContainer) before being used in another unit operation.";
Error::UnableToAutofillUnitOperation="We were unable to automatically fill out the input to the unit operation(s), `1`, at indices, `2`. Please specify the inputs to these unit operations.";
Error::NoAvailableUnitOperationMethods="The following unit operations, `1`, at indices, `2` have no available methods that can satisfy all of the specified options for the given samples. Please modify the options given in order to specify a valid unit operation.";
Error::OverwrittenLabels="The following labels, `1`, were overwritten at indices, `2`, for unit operations, `3`. Please make sure that you do not try to reuse the same label when labeling new samples/containers. Please change the labels used at these unit operation indices.";
Error::NoUnitOperations="An empty list of unit operations was given to the function `1`. At least one unit operation must be given in order to specify a valid protocol. Please specify at least one unit operation.";
Error::InjectionSamplesUsedElsewhere="The injection sample(s), `1`, are required by other unit operations (not as injection samples) at indices, `2`. Injection sample(s) must be placed inside of the plate reader instrument(s) and cannot be used on deck. Please split up these unit operations into multiple batches if you would like to use these samples as both injection samples and on deck.";
Warning::TransferDestinationExpanded="The unit operation, `1`, has a singleton container model listed as the destination for multiple sources. Transfer will transfer each of the specified sources into a new instance of the specified destination container model. If the same destination is desired, please consider adding an index to the container model or using the labeling system.";
Error::WorkCellDoesntMatchPattern="The resolved work cell for the primitive, `1`, does not match WorkCellP. Please check your WorkCellResolverFunction or WorkCell option to DefinePrimitive";
Error::WorkCellIsIncompatibleWithMethod="The following method, `1`, is set for the primitive `2`, however, the only WorkCell types compatible with this primitive are of type `3`, which conflict with the chosen method. WorkCell types bioSTAR and microbioSTAR are only compatible with ExperimentRoboticCellPreparation and STAR is only compatible with ExperimentRoboticSamplePreparation. Please review primitive method specification to allow appropriate WorkCell selection.";
Error::WorkCellIsIncompatible="The following workcell, `1`, is set for primitive `2`, however, this experiment can only be performed in the following workcells, `3`. Please change the specified workcell or review the required instrumentation for your protocol to make sure it can be fulfilled by the workcell of your choice.";
Warning::UncoverUnitOperationAdded="The unit operation, `1`, requires that the container(s), `2`, to be uncovered in order to access the samples inside of the container. However, at the time of this unit operation, these containers will be covered with lid(s). An Uncover unit operation has been added automatically before this unit operation in order to uncover the container(s).";
Warning::NoRunTime="The unit operation at index `1` resolved by function `2` did not return valid RunTime. Please investigate.";
Error::ConflictingSpecifiedMagnetizationRackWithFilterUnitOperation="The specified magnetization rack `1` for the primitive `2` is a heavy rack that takes a low position and cannot be used together with any Filter unit operation for robotic preparation. Please either specify the lighter rack (Model[Item, MagnetizationRack, \"Alpaqua 96S Super Magnet 96-well Plate Rack\"]) or leave it to be set automatically.";
Error::ConflictingWorkCells = "The unit operation, `1`, at index, `2`, can only be performed on a `3` work cell that is conflicting with the work cells, `4`, required by the unit operations, `5`. `6` strictly requires that all unit operations be performed on the same work cell. Please change the specified WorkCell option or use Experiment/ExperimentCellPreparation/ExperimentSamplePreparation instead to allow scripts to be generated.";
Error::RoboticCellPreparationRequired = "The unit operation `1` has Preparation -> Robotic and requires samples `2`, which contain living material according to the information in their Living, CellType, and/or Composition fields. Please use ExperimentRoboticCellPreparation instead of RoboticSamplePreparation to submit a valid experiment.";
Warning::CellPreparationFunctionRecommended = "The unit operation `1` requires samples `2`, which contain living material according to the information in their Living, CellType, and/or Composition fields. To more rigorously maintain sterility and prevent contamination, consider using ExperimentManualCellPreparation instead of ExperimentManualSamplePreparation.";

(* Cache of previous results in the format {PrimitiveFrameworkFunction, myPrimitives_List} => simulation. *)
(* NOTE: This is important for simulateSamplePreparationPackets since the container overload call MSP first before *)
(* the sample overload does and we need the simulation to not happen again. This is also a performance enhancement. *)
$PrimitiveFrameworkOutputCache=<||>;

(* Store previous resolver results in the form of {resolverFunction, inputs, options, simulationHash} => output. *)
(* NOTE: Onto the regular output specification, we always append the list of captured messages so that messages are thrown *)
(* again if there was an issue. *)
(* NOTE: We hash our simulations because it's faster than doing a straight MatchQ. Additionally, the SimulatedObjects key *)
(* in the simulation can change once we upload our unit operations, so we key drop SimulatedObjects before we hash. *)
$PrimitiveFrameworkResolverOutputCache=<||>;

(* the following heads are dummy primitives, which means that these primitives should not be dictating how the WorkCell/LiquidHandler is resolved *)
$DummyPrimitiveP = _LabelSample | _LabelContainer | _Wait;

(* Store the labeled fields with indicies any time we are done with the primitive simulation
    this is not cumulative (we will store only the result of the labels calculated in the last round of the Experiment* call with
    UnitOperationPackets->True) and only the result of the last group of unit operation calculations will be stored and used.
    The primary consumer of this data is Experiment`Private`updateLabelFieldReferences
 *)
$PrimitiveFrameworkIndexedLabelCache={};

(* Helper function to KeyDrop if our resolver cache gets too large. *)
(* NOTE: Keys will return keys in order of first added to last added. *)
resizePrimitiveFrameworkCache[]:=If[Length[Keys[$PrimitiveFrameworkResolverOutputCache]]>250,
  KeyDropFrom[
    $PrimitiveFrameworkResolverOutputCache,
    Take[Keys[$PrimitiveFrameworkResolverOutputCache], Ceiling[Length[Keys[$PrimitiveFrameworkResolverOutputCache]]/2]]
  ];
];

(* NOTE: We keep the input pattern here extremely vague because we want to give the user informative messages if their *)
(* input doesn't match the primitive set pattern. *)
(* NOTE: We use the exact same logic for all Experiment, ExperimentSamplePreparation, ExperimentRoboticSamplePreparation, etc. so we use this *)
(* meta function installer. *)
installPrimitiveFunction[myOuterFunction_, myOuterHeldPrimitiveSet_]:=With[{myFunction=myOuterFunction, myHeldPrimitiveSet=myOuterHeldPrimitiveSet},
  Switch[myFunction,
    (* For robotic sample preparation *)
    ExperimentRoboticSamplePreparation,
      DefineOptions[myFunction,
        Options:>{
          ProtocolOptions,
          SimulationOption,
          DebugOption,
          OptimizeUnitOperationsOption,
          CoverAtEndOption,
          UnitOperationPacketsOption,
          DelayedMessagesOption,
          PreparedResourcesOption,
          OrderFulfilledOption,

          (* NOTE: This function can return additional outputs of Input and Simulation. *)
          {
            OptionName->Output,
            Default->Result,
            AllowNull->True,
            Widget->Alternatives[
              Widget[Type->Enumeration,Pattern:>Alternatives[CommandBuilderOutputP, Input, Simulation]],
              Adder[Widget[Type->Enumeration,Pattern:>Alternatives[CommandBuilderOutputP, Input, Simulation]]]
            ],
            Description->"Indicate what the function should return.",
            Category->"Hidden"
          },

          {
            OptionName->PreviewFinalizedUnitOperations,
            Default->True,
            AllowNull->False,
            Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
            Description->"Indicates if Output->Input should return the unit operations in their finalized form (with optimization, if OptimizeUnitOperations->True, and unit operation method wrappers, if they were not originally specified).",
            Category->"Hidden"
          },

          {
            OptionName->InputsFunction,
            Default->False,
            AllowNull->False,
            Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
            Description->"Indicates if we're being called from ExperimentBLAHInputs. If InputsFunction->True and PreviewFinalizedUnitOperations->True, we will return calculated inputs with method groupings. Otherwise, we will return optimized primitives with method groupings.",
            Category->"Hidden"
          },

          (* Extra options: *)
          RoboticSamplePreparationOptions
        }
      ],
    (* For robotic cell preparation *)
    ExperimentRoboticCellPreparation,
      DefineOptions[myFunction,
        Options :> {
          ProtocolOptions,
          SimulationOption,
          DebugOption,
          OptimizeUnitOperationsOption,
          CoverAtEndOption,
          UnitOperationPacketsOption,
          DelayedMessagesOption,
          PreparedResourcesOption,
          OrderFulfilledOption,

          {
            OptionName->Output,
            Default->Result,
            AllowNull->True,
            Widget->Alternatives[
              Widget[Type->Enumeration,Pattern:>Alternatives[CommandBuilderOutputP, Input, Simulation]],
              Adder[Widget[Type->Enumeration,Pattern:>Alternatives[CommandBuilderOutputP, Input, Simulation]]]
            ],
            Description->"Indicate what the function should return.",
            Category->"Hidden"
          },

          {
            OptionName->PreviewFinalizedUnitOperations,
            Default->True,
            AllowNull->False,
            Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
            Description->"Indicates if Output->Input should return the unit operations in their finalized form (with optimization, if OptimizeUnitOperations->True, and unit operation method wrappers, if they were not originally specified).",
            Category->"Hidden"
          },

          {
            OptionName->InputsFunction,
            Default->False,
            AllowNull->False,
            Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
            Description->"Indicates if we're being called from ExperimentBLAHInputs. If InputsFunction->True and PreviewFinalizedUnitOperations->True, we will return calculated inputs with method groupings. Otherwise, we will return optimized primitives with method groupings.",
            Category->"Hidden"
          },

          (* Extra Options. *)
          RoboticCellPreparationOptions
        }
      ],
    (* For manual sample preparation *)
    ExperimentManualSamplePreparation,
      DefineOptions[myFunction,
        Options:>{
          ProtocolOptions,
          SimulationOption,
          DebugOption,
          OptimizeUnitOperationsOption,
          UnitOperationPacketsOption,
          DelayedMessagesOption,
          PreparedResourcesOption,
          OrderFulfilledOption,

          (* NOTE: This function can return additional outputs of Input and Simulation. *)
          {
            OptionName->Output,
            Default->Result,
            AllowNull->True,
            Widget->Alternatives[
              Widget[Type->Enumeration,Pattern:>Alternatives[CommandBuilderOutputP, Input, Simulation]],
              Adder[Widget[Type->Enumeration,Pattern:>Alternatives[CommandBuilderOutputP, Input, Simulation]]]
            ],
            Description->"Indicate what the function should return.",
            Category->"Hidden"
          },

          {
            OptionName->PreviewFinalizedUnitOperations,
            Default->True,
            AllowNull->False,
            Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
            Description->"Indicates if Output->Input should return the unit operations in their finalized form (with optimization, if OptimizeUnitOperations->True, and unit operation method wrappers, if they were not originally specified).",
            Category->"Hidden"
          },

          {
            OptionName->InputsFunction,
            Default->False,
            AllowNull->False,
            Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
            Description->"Indicates if we're being called from ExperimentBLAHInputs. If InputsFunction->True and PreviewFinalizedUnitOperations->True, we will return calculated inputs with method groupings. Otherwise, we will return optimized primitives with method groupings.",
            Category->"Hidden"
          },

          (* Extra Options: *)
          ManualSamplePreparationOptions
        }
      ],
    (* For manual cell preparation: *)
    ExperimentManualCellPreparation,
      DefineOptions[myFunction,
        Options:>{
          ProtocolOptions,
          SimulationOption,
          DebugOption,
          OptimizeUnitOperationsOption,
          UnitOperationPacketsOption,
          DelayedMessagesOption,
          PreparedResourcesOption,
          OrderFulfilledOption,

          (* NOTE: This function can return additional outputs of Input and Simulation. *)
          {
            OptionName->Output,
            Default->Result,
            AllowNull->True,
            Widget->Alternatives[
              Widget[Type->Enumeration,Pattern:>Alternatives[CommandBuilderOutputP, Input, Simulation]],
              Adder[Widget[Type->Enumeration,Pattern:>Alternatives[CommandBuilderOutputP, Input, Simulation]]]
            ],
            Description->"Indicate what the function should return.",
            Category->"Hidden"
          },

          {
            OptionName->PreviewFinalizedUnitOperations,
            Default->True,
            AllowNull->False,
            Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
            Description->"Indicates if Output->Input should return the unit operations in their finalized form (with optimization, if OptimizeUnitOperations->True, and unit operation method wrappers, if they were not originally specified).",
            Category->"Hidden"
          },

          {
            OptionName->InputsFunction,
            Default->False,
            AllowNull->False,
            Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
            Description->"Indicates if we're being called from ExperimentBLAHInputs. If InputsFunction->True and PreviewFinalizedUnitOperations->True, we will return calculated inputs with method groupings. Otherwise, we will return optimized primitives with method groupings.",
            Category->"Hidden"
          },
          (* Extra Options: *)
          ManualSamplePreparationOptions
        }
      ],
    (* For Script generating functions *)
    ScriptGeneratingPrimitiveFunctionP,
      DefineOptions[myFunction,
        Options:>{
          ProtocolOptions,
          SimulationOption,
          DebugOption,
          OptimizeUnitOperationsOption,
          CoverAtEndOption,
          UnitOperationPacketsOption,
          DelayedMessagesOption,

          {
            OptionName -> MeasureWeight,
            Default -> Automatic,
            ResolutionDescription -> "Automatically set to False if the experiment involves Living cells and/or Sterile samples.",
            Description -> "Indicates if any solid samples that are modified in the course of the experiment should have their weights measured and updated after running the experiment.",
            AllowNull -> False,
            Category -> "Post Experiment",
            Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
          },
          {
            OptionName -> MeasureVolume,
            Default -> Automatic,
            ResolutionDescription -> "Automatically set to False if the experiment involves Living cells and/or Sterile samples.",
            Description -> "Indicates if any liquid samples that are modified in the course of the experiment should have their volumes measured and updated after running the experiment.",
            AllowNull -> False,
            Category -> "Post Experiment",
            Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
          },
          {
            OptionName -> ImageSample,
            Default -> Automatic,
            ResolutionDescription -> "Automatically set to False if the experiment involves Living cells and/or Sterile samples.",
            Description -> "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment.",
            AllowNull -> False,
            Category -> "Post Experiment",
            Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
          },

          (* NOTE: This function can return additional outputs of Input and Simulation. *)
          {
            OptionName->Output,
            Default->Result,
            AllowNull->True,
            Widget->Alternatives[
              Widget[Type->Enumeration,Pattern:>Alternatives[CommandBuilderOutputP, Input, Simulation]],
              Adder[Widget[Type->Enumeration,Pattern:>Alternatives[CommandBuilderOutputP, Input, Simulation]]]
            ],
            Description->"Indicate what the function should return.",
            Category->"Hidden"
          },

          {
            OptionName->PreviewFinalizedUnitOperations,
            Default->True,
            AllowNull->False,
            Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
            Description->"Indicates if Output->Input should return the unit operations in their finalized form (with optimization, if OptimizeUnitOperations->True, and unit operation method wrappers, if they were not originally specified).",
            Category->"Hidden"
          },

          {
            OptionName->InputsFunction,
            Default->False,
            AllowNull->False,
            Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
            Description->"Indicates if we're being called from ExperimentBLAHInputs. If InputsFunction->True and PreviewFinalizedUnitOperations->True, we will return calculated inputs with method groupings. Otherwise, we will return optimized primitives with method groupings.",
            Category->"Hidden"
          },
          {
            OptionName->IgnoreWarnings,
            Default->True,
            AllowNull->False,
            Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
            Description->"Indicates if the script should be continued even if warnings are thrown.",
            Category->"General"
          }
        }
      ]
  ];

(* Install empty list overload that throws an error. *)
myFunction[myPrimitives:{}, myOptions:OptionsPattern[]]:=Module[{},
  Message[Error::NoUnitOperations, myFunction];

  $Failed
];

(* Install overload the redirects to the main function. *)
myFunction[myPrimitive:Except[_List], myOptions:OptionsPattern[]]:=myFunction[{myPrimitive}, myOptions];

(* Install the main function. *)
myFunction[myPrimitives_List, myOptions:OptionsPattern[]]:=Block[{$ProgressPrinting=False},Module[
  {outputSpecification,output,gatherTests,safeOps,safeOpsTests,primitiveSetInformation,allPrimitiveInformation,primitiveHeads,
    invalidPrimitiveHeadsWithIndices,invalidPrimitiveOptionKeysWithIndices,invalidPrimitiveOptionPatternsWithIndices,
    invalidPrimitiveRequiredOptionsWithIndices,templatedOptions,templateTests,inheritedOptions,expandedSafeOps,
    invalidMethodWrappers,invalidMethodWrapperPositions,primitiveMethods,flattenedPrimitives,primitivesWithResolvedMethods,resolvedPrimitiveMethodResult,
    invalidPrimitiveMethodIndices,primitivesWithPreresolvedInputs,invalidLabelPrimitivesWithIndices,invalidAutofillPrimitivesWithIndices,
    invalidResolvePrimitiveMethodsWithIndices,allResolverTests,allPrimitiveGroupings,allPrimitiveGroupingWorkCellInstruments,currentPrimitiveGrouping,
    currentPrimitiveGroupingLabeledObjects,currentPrimitiveGroupingFootprints,currentPrimitiveGroupingTips,
    fakeContainer,fakeWaterSample,currentSimulation,previousSimulation,resolvedPrimitives,currentPrimitiveGroupingDateStarted,currentPrimitiveDateStarted,primitiveMethodIndexToOptionsLookup,invalidMethodOptionsWithIndices,
    allPrimitiveOptionGroupings,allPrimitiveInputGroupings,noInstrumentsPossibleErrorsWithIndices,currentPrimitiveGroupingPotentialWorkCellInstruments, cellsPresentQ, sterileQ, cellSamplesForErrorChecking,
    currentPrimitiveOptionGrouping,currentPrimitiveInputGrouping,allPrimitiveGroupingResources,allTipModels,heavyMagnetizationRacks,workCellModelPackets,workCellObjectPackets,tipModelPackets,microbialQ,footprintInformationKeys,allPrimitiveGroupingTips,allPrimitiveGroupingFootprints,
    allLabelFieldsWithIndicesGroupings,allPrimitiveOptionsWithLabelFieldsGroupings,currentLabelFieldsWithIndices,
    primitiveIndexToScriptVariableLookup,outputResult,currentPrimitiveGroupingRunTimes,allPrimitiveGroupingRunTimes,
    flattenedIndexMatchingPrimitives,cacheBall,containerPackets,samplePackets,sampleModelPackets,allContainerContentsPackets,allSamplePackets,allContainerModelPackets,containerModelToPosition,allContainerPackets,
    transferDestinationSampleLabelCounter,debug,invalidInputIndices,simulatedObjectsToLabelOutput,parentProtocolStack,rootProtocol,
    resolvedInput,allPrimitiveInputsWithLabelFieldsGroupings,allUnresolvedPrimitiveGroupings,currentUnresolvedPrimitiveGrouping,
    invalidResolverPrimitives,incompatibleWorkCellAndMethod,roboticCellPreparationRequired,resolvedOptions,fakeWaterSimulation,errorCheckingMessageCell,simulationPreparationMessageCell,
    primitiveMethodMessageCell,simulation,parentProtocol,orderToFulfill,intersectionLabels,overwrittenLabels,
    allOverwrittenLabelsWithIndices,optimizedPrimitives,nonIndexMatchingPrimitiveOptions,optimizeUnitOperations,
    doNotOptimizeQ,frqTests,nonObjectResources,currentPrimitiveGroupingIntegratedInstrumentsResources,allPrimitiveGroupingIntegratedInstrumentResources,
    sanitizedPrimitives,validLengthsQList,throwMessageWithPrimitiveIndex,allPrimitiveGroupingIncubatorContainerResources,
    currentPrimitiveGroupingIncubatorPlateResources,allPrimitiveGroupingAmbientContainerResources,currentPrimitiveGroupingAmbientPlateResources,
    fulfillableQ,allPrimitiveGroupingWorkCellIdlingConditionHistory,currentPrimitiveGroupingWorkCellIdlingConditionHistory,
    startNewPrimitiveGrouping,computeLabeledObjectsAndFutureLabeledObjects,finalOutput,allPrimitiveGroupingUnitOperationPackets,allPrimitiveGroupingBatchedUnitOperationPackets,
    currentPrimitiveGroupingUnitOperationPackets,currentPrimitiveGroupingBatchedUnitOperationPackets,sanitizedPrimitivesWithUnitOperationObjects,labelFieldGroupings,
    allUnresolvedPrimitivesWithLabelFieldGroupings,previewFinalizedUnitOperations,modelContainerFields,
    objectSampleFields,modelSampleFields,objectContainerFields,unitOperationPacketsQ,outputRules,invalidInjectorResourcesWithIndices,
    outputUnitOperationObjectsFromCache,liquidHandlerCompatibleRacks,accumulatedFulfillableResourceQ,delayedMessagesQ,
    liquidHandlerCompatibleRackPackets,inputsFunctionQ,coverOptimizedPrimitives,addedCoverAtEndPrimitiveQ,index,coverAtEnd,
    ignoreWarnings,primitiveIndexToOutputUnitOperationLookup,tipResources,nonTipResources,gatheredTipResources,combinedTipResources,
    counterWeightResources,counterWeightResourceReplacementRules,uniqueCounterweightResources,combinedCounterWeightResources,
    accumulatedFRQTests,userWorkCellChoice,specifiedWorkCell,containerModelFieldsList,totalWorkCellTime,
    invalidInputMagnetizationRacksWithIndices,optimizedPrimitivesWithMethods, resolvedImageSample,resolvedMeasureVolume,resolvedMeasureWeight,
    flattenedIndexMatchingPrimitivesWithCorrectedLabelSample
  },

  (* Determine the requested return value from the function *)
  outputSpecification=Quiet[OptionValue[Output]];
  output=ToList[outputSpecification];

  (* Are we running in debug mode? *)
  debug=Lookup[ToList[myOptions], Debug, False];
  simulation=Lookup[ToList[myOptions], Simulation, Null];
  parentProtocol=Lookup[ToList[myOptions], ParentProtocol, Null];
  orderToFulfill = Lookup[ToList[myOptions], OrderFulfilled, Null];
  optimizeUnitOperations=Lookup[ToList[myOptions], OptimizeUnitOperations, True];
  coverAtEnd=Lookup[ToList[myOptions], CoverAtEnd, Automatic]/.{Automatic->optimizeUnitOperations};
  previewFinalizedUnitOperations=Lookup[ToList[myOptions], PreviewFinalizedUnitOperations, True];
  inputsFunctionQ=Lookup[ToList[myOptions], InputsFunction, False];
  unitOperationPacketsQ = Lookup[ToList[myOptions], UnitOperationPackets, False];
  delayedMessagesQ = Which[
    (* If it is specified, use it *)
    !NullQ[Lookup[ToList[myOptions], DelayedMessages, Null]],
    Lookup[ToList[myOptions], DelayedMessages, Null],

    (* If debug is true, turn off delayed messages *)
    debug,False,

    (* Otherwise set to True *)
    True,True
  ];

  (* Set our size limit to a large number if we're debugging. *)
  If[MatchQ[debug, True],
    $SummaryBoxDataSizeLimit=10^15
  ];

  (* See if we already have a cached result. We only cache results when there are no errors thrown. *)
  If[KeyExistsQ[$PrimitiveFrameworkOutputCache, {myFunction, myPrimitives, MemberQ[output, Tests]}],
    (* NOTE: We can't use our cache if the user is asking for Output->Result because we need to generate a new protocol *)
    (* object. UNLESS they also gave us a simulation -- we assume that this means they won't upload the result. *)
    (* NOTE: Even if the user is asking for a new protocol and we can't use $PrimitiveFrameworkOutputCache, our primitive *)
    (* specific cache should save us a lot of time still. *)
    (* NOTE: This is used in the primitive framework since aliquot resolution happens both in resolveSamplePrepOptionsNew and *)
    (* in resolveAliquotOptions and we want it to memoize. *)
    If[Or[
        MemberQ[output, Result] && MatchQ[simulation, SimulationP],
        !MemberQ[output, Result]
      ],
      Return[outputSpecification/.Lookup[$PrimitiveFrameworkOutputCache, Key[{myFunction, myPrimitives, ToList[myOptions], MemberQ[output, Tests]}]]]
    ]
  ];

  (* Resize our cache, if necessary. *)
  resizePrimitiveFrameworkCache[];

  (* If we are working on building UO as children of another UO, empty the LabelField cache *)
  If[unitOperationPacketsQ,
    $PrimitiveFrameworkIndexedLabelCache={};
  ];

  (* Update our global simulation, if we have one. This is because we lookup directly from $CurrentSimulation to find *)
  (* SimulatedObjects. *)
  If[MatchQ[$CurrentSimulation, SimulationP] && !MatchQ[Lookup[$CurrentSimulation[[1]], Updated], True],
    $CurrentSimulation=UpdateSimulation[Simulation[], $CurrentSimulation];
  ];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];

  (* Call SafeOptions to make sure all options match pattern *)
  {safeOps,safeOpsTests}=If[gatherTests,
    SafeOptions[myFunction,ToList[myOptions],AutoCorrect->False,Output->{Result,Tests}],
    {SafeOptions[myFunction,ToList[myOptions],AutoCorrect->False],{}}
  ];

  (* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
  If[MatchQ[safeOps,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> safeOpsTests,
      Options -> $Failed,
      Preview -> Null,
      Input -> myPrimitives
    }]
  ];

  (*Initialize our error tracking for filter and magnetized transfer unit operations if this is the very start of a call*)
  If[MatchQ[Lookup[safeOps,Simulation], Null],
    $PotentialConflictingDeckPlacementUnitOperations = {}
  ];

  (* Sanitize our inputs. *)
  (* Experiments of individual UO should call sanitizeInput first by itself. Do not throw the message in framework *)
  sanitizedPrimitivesWithUnitOperationObjects = Quiet[
    (sanitizeInputs[myPrimitives, Simulation -> simulation]/.{link:LinkP[] :> Download[link, Object]}),
    Warning::OptionContainsUnusableObject];

  (* return early if we have nonexistent objects; the message will be thrown in sanitizeInputs *)
  If[MatchQ[sanitizedPrimitivesWithUnitOperationObjects, $Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> safeOpsTests,
      Options -> $Failed,
      Preview -> Null,
      Input -> myPrimitives
    }]
  ];

  (* -- STAGE 0: Convert any Object[UnitOperation]s that we have into Unit Operation Primitives -- *)
  If[debug, Echo["Beginning Stage 0: Converting any Object[UnitOperation]s to Unit Operation Primitives"]];

  (* Replace the unit operation objects. *)
  sanitizedPrimitives=Module[{userInputtedUnitOperationObjectsWithoutBoxForms, userInputtedUnitOperationObjects, userInputtedUnitOperationPackets, userInputtedUnitOperationObjectToPrimitive},
    (* If the user copied the box form of the unit operation object, we will get something that looks like Head[PacketP[]]. *)
    (* Convert these into raw unit operation objects. *)
    userInputtedUnitOperationObjectsWithoutBoxForms=(If[MatchQ[#, (_Symbol)[PacketP[]]], Lookup[#[[1]], Object], #]&)/@sanitizedPrimitivesWithUnitOperationObjects;

    (* Find any unit operation objects that were given as input. *)
    userInputtedUnitOperationObjects=DeleteDuplicates@Cases[userInputtedUnitOperationObjectsWithoutBoxForms, ObjectReferenceP[Object[UnitOperation]], Infinity];

    (* Download our unit operation objects. *)
    userInputtedUnitOperationPackets=Download[userInputtedUnitOperationObjects, Packet[All], Simulation -> simulation];

    (* Convert each of these packets into a primitive. *)
    (* WasteContainer is a hidden option in FillToVolume and in Transfer. There is no need to allow users to set this option so it is hidden, but we need to pass this down. Include this hidden option *)
    userInputtedUnitOperationObjectToPrimitive=(
      Lookup[#, Object]->ConstellationViewers`Private`UnitOperationPrimitive[#, IncludeCompletedOptions->False, IncludeEmptyOptions->False, IncludedHiddenOptions -> {WasteContainer}]
    &)/@userInputtedUnitOperationPackets;

    (* Experiments of individual UO should call sanitizeInput first by itself. Do not throw the message in framework *)
    Quiet[
      (sanitizeInputs[userInputtedUnitOperationObjectsWithoutBoxForms /. userInputtedUnitOperationObjectToPrimitive, Simulation -> simulation] /. {link : LinkP[] :> Download[link, Object]}),
      Warning::OptionContainsUnusableObject
    ]
  ];

  (* -- STAGE 1: Primitive Pattern Checks -- *)
  If[debug, Echo["Beginning stage 1: InitialPrimitive error checking"]];

  (* Tell the user that we're error checking. *)
  errorCheckingMessageCell=If[MatchQ[$ECLApplication, CommandCenter|Mathematica],
    PrintTemporary[
      Row[{
        Constellation`Private`constellationImage[$ConstellationIconSize],
        Spacer[10],
        "Checking Given Unit Operations For Basic Errors",
        If[Not[$CloudEvaluation], ProgressIndicator[Appearance->"Percolate"], Nothing]
      }]
    ]
  ];

  (* Lookup information about our primitive set from our backend association. *)
  primitiveSetInformation=Lookup[$PrimitiveSetPrimitiveLookup, myHeldPrimitiveSet];
  allPrimitiveInformation=Lookup[primitiveSetInformation, Primitives];
  primitiveHeads=Keys[allPrimitiveInformation];

  (* Figure out what methods (wrapper headers) are allowed by looking at the primitive methods allowed in each of our primitives. *)
  primitiveMethods=DeleteDuplicates[Flatten[Lookup[Values[allPrimitiveInformation], Methods]]];

  (* First go through our unflattened primitives and see if there are any invalid method heads. *)
  invalidMethodWrapperPositions=Position[
    sanitizedPrimitives,
    (* Get everything that does not look like a single primitive or a valid method wrapper head. *)
    _?(MatchQ[#, Except[_Symbol[_Association]]] && !MatchQ[#, (Alternatives@@primitiveMethods)[___]]&),
    1,
    Heads->False
  ];
  invalidMethodWrappers=Extract[sanitizedPrimitives, invalidMethodWrapperPositions];

  (* If we have things that look like invalid wrappers, yell and return early. *)
  If[Length[invalidMethodWrappers]>0,
    Message[Error::InvalidUnitOperationMethods, (Head/@invalidMethodWrappers), invalidMethodWrapperPositions, myFunction, primitiveMethods];
    Message[Error::InvalidInput, invalidMethodWrappers];

    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> safeOpsTests,
      Options -> $Failed,
      Preview -> Null,
      Input -> myPrimitives
    }];
  ];

  (* Now that we've verified that any primitive wrappers that we were given are valid, flatten out our primitives so we can *)
  (* map like normal. *)

  (* NOTE: We add the key PrimitiveMethod->PrimitiveMethodP if our primitive was originally in a method wrapper head. *)
  (* This option isn't exposed to the user and is only used internally in this function to resolve things. It is automatically *)
  (* included in our primitive pattern builder though. *)

  (* NOTE: We also add the PrimitiveMethodIndex->_Integer key if the primitive was originally in a method wrapper head. *)
  (* This is so that we can respect the user's wishes in terms of splitting up the work cell runs. *)
  flattenedPrimitives=Which[
    (* If the user gave us some primitive method wrappers, make sure to fill out the PrimitiveMethodIndex. *)
    !MatchQ[sanitizedPrimitives, {_Symbol[_Association]..}],
      MapThread[
        Function[{listElement, listIndex},
          (* Does this look like a wrapper and not an individual primitive? *)
          If[MatchQ[listElement, Except[_Symbol[_Association]]],
            (* We have a method wrapper. *)
            Sequence@@(
              (
                Head[#]@Append[
                  (* NOTE: If our primitive is so messed up, we will not get an association when we take off the head. *)
                  (* Attempt to get it into a valid format for later error checking. *)
                  If[MatchQ[#[[1]], _Association],
                    #[[1]],
                    Association[(Switch[#, _Rule, #, _Symbol, #->Null, _, Nothing]&)/@(List@@#)]
                  ],
                  {
                    PrimitiveMethod->Head[listElement],
                    PrimitiveMethodIndex->listIndex
                  }
                ]
              (* NOTE: We're filtering out _Rule here because each primitive wrapper can have additional options that can be set. *)
              &)/@(Cases[List@@listElement, Except[_Rule]])
            ),
            (* We just have a single primitive. *)
            listElement
          ]
        ],
        {sanitizedPrimitives, Range[Length[sanitizedPrimitives]]}
      ],
    (* If the user is calling RSP or RCP directly, they're telling us that they want the UOs to be done in a single run. *)
    MatchQ[myFunction, ExperimentRoboticSamplePreparation | ExperimentRoboticCellPreparation],
      (
        Head[#]@Append[
          #[[1]],
          PrimitiveMethodIndex->1
        ]
      &)/@sanitizedPrimitives,
    (* Otherwise, there is no PrimitiveMethodIndex information to set. *)
    True,
      sanitizedPrimitives
  ];

  (* Helper function to prepend primitive index information to a message association. *)
  throwMessageWithPrimitiveIndex[messageAssociation_, index_, primitiveHead_, simulation_, preCallMessageLength_, messageIndex_]:=Module[{permanentlyIgnoredMessages},
    (* Only bother throwing the message if it's not Error::InvalidInput or Error::InvalidOption. *)
    permanentlyIgnoredMessages = {Hold[Error::InvalidInput],Hold[Error::InvalidOption]};
    If[And[
        !MatchQ[Lookup[messageAssociation, MessageName], Alternatives@@permanentlyIgnoredMessages],
        !MatchQ[ReleaseHold[Lookup[messageAssociation, MessageName]], $Off[_]]
      ],
      Module[{messageTemplate, numberOfMessageArguments, specialHoldHead, messageSymbol, messageTag, newMessageTemplate, messageArguments},
        (* Get the text of our message template. *)
        (* NOTE: Some messages don't evaluate by themselves (ex. Lookup::invrl). *)
        messageTemplate=If[MatchQ[ReleaseHold[Lookup[messageAssociation, MessageName]], _String],
          ReleaseHold[Lookup[messageAssociation, MessageName]],
          With[{messageHead=First[ReleaseHold[Lookup[messageAssociation, MessageName]]]},
            ReleaseHold[Lookup[messageAssociation, MessageName]] /. Messages[messageHead]
          ]
        ];

        (* Get the number of arguments that we have. *)
        numberOfMessageArguments=Length[Lookup[messageAssociation, MessageArguments]];

        (* Create a special hold head that we will replace our Hold[messageName] with. *)
        SetAttributes[specialHoldHead, HoldAll];

        (* Extract the message symbol and tag. *)
        messageSymbol=Extract[Lookup[messageAssociation, MessageName], {1,1}];
        messageTag=Extract[Lookup[messageAssociation, MessageName], {1,2}];

        (* Create a new message template string. *)
        newMessageTemplate="The following message was thrown at unit operation index `"<>ToString[numberOfMessageArguments+1]<>"` ("<>ToString[primitiveHead]<>"): "<>ToString[messageTemplate];

        (* If we have a simulation, map any simulated sample IDs into labels. *)
        (* NOTE: We could get the samples in ObjectP[] form or in string form since ObjectToString could have been called. *)
        messageArguments=If[MatchQ[simulation, SimulationP],
          Module[{objectToLabelRules, stringObjectToLabelRules},
            (* Create our simulated sample to label replace rules. *)
            objectToLabelRules=(ObjectReferenceP[#[[2]]]|LinkP[#[[2]]]->#[[1]]&)/@Lookup[simulation[[1]], Labels];
            stringObjectToLabelRules=If[Length[Lookup[simulation[[1]], Labels]]>0,
              Rule@@@Transpose[{ObjectToString[Lookup[simulation[[1]], Labels][[All, 2]], OutputFormat->Expression], Lookup[simulation[[1]], Labels][[All, 1]]}],
              {}
            ];

            (If[MatchQ[#, _String], StringReplace[#, stringObjectToLabelRules], #/.objectToLabelRules]&)/@Lookup[messageAssociation, MessageArguments]
          ],
          Lookup[messageAssociation, MessageArguments]
        ];

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
                  Sequence@@Append[messageArguments, index]
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  ];

  (* Keep track of invalid primitives to throw messages about. *)
  invalidPrimitiveHeadsWithIndices={};
  invalidPrimitiveOptionKeysWithIndices={};
  invalidPrimitiveOptionPatternsWithIndices={};
  invalidPrimitiveRequiredOptionsWithIndices={};

  (* Go through each of our primitives and check them. *)
  MapThread[
    Function[{currentPrimitive, primitiveIndex},
      Module[{primitiveDefinition},
        (* Get the definition for this primitive, within the primitive set. *)
        primitiveDefinition=Lookup[allPrimitiveInformation, Head[currentPrimitive]];

        Which[
          (* First, check that the primitive head exists in our primitive set. *)
          !MatchQ[Head[currentPrimitive], Alternatives@@primitiveHeads],
            AppendTo[invalidPrimitiveHeadsWithIndices, {Head[currentPrimitive], primitiveIndex}],

          (* Next, make sure that for the primitive head that we have, all the options match their pattern. *)
          (* NOTE: We specifically form the primitive pattern for each primitive set to only include the options that relate *)
          (* to that primitive set (for each primitive). So, we can first just do a pattern match to see if all the options are okay. *)
          !MatchQ[currentPrimitive, Lookup[primitiveDefinition, Pattern]],
            Module[{invalidOptionKeys, invalidOptionPatterns, requiredOptions, missingRequiredOptions},
              (* Get any options that don't exist in the primitive definition. *)
              invalidOptionKeys=Complement[
                Keys[currentPrimitive[[1]]],
                Flatten[{Lookup[Lookup[primitiveDefinition, OptionDefinition], "OptionSymbol"], PrimitiveMethod, PrimitiveMethodIndex}]
              ];

              If[Length[invalidOptionKeys]>0,
                AppendTo[invalidPrimitiveOptionKeysWithIndices, {invalidOptionKeys, primitiveIndex, Head[currentPrimitive]}];
              ];

              (* Get any options that don't match their pattern. *)
              invalidOptionPatterns=KeyValueMap[
                Function[{option, value},
                  Module[{optionPattern},
                    (* Get the pattern for this option. If the option doesn't exist in the definition, just skip over it because it *)
                    (* will be covered by our invalidOptionKeys check. *)
                    optionPattern=ReleaseHold@Lookup[
                      FirstCase[Lookup[primitiveDefinition, OptionDefinition], KeyValuePattern["OptionSymbol"->option], <|"Pattern"->_|>],
                      "Pattern"
                    ];
                    If[!MatchQ[value, optionPattern],
                      option,
                      Nothing
                    ]
                  ]
                ],
                currentPrimitive[[1]]
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
            ],

          (* In our pattern we exempted the first input options from being required (even if it was marked as Required) because *)
          (* it can usually be autofilled. This is true for all primitives except for the first one. If we're the first primitive, *)
          (* make sure that we have our first primitive filled out. *)
          MatchQ[primitiveIndex, 1] && Length[Lookup[primitiveDefinition, InputOptions]]>0,
            Module[{firstInputOption},
              firstInputOption=FirstOrDefault[Lookup[primitiveDefinition, InputOptions]];

              If[!KeyExistsQ[currentPrimitive[[1]], firstInputOption],
                AppendTo[invalidPrimitiveRequiredOptionsWithIndices, {{firstInputOption}, primitiveIndex, Head[currentPrimitive]}]
              ];
            ],

          (* All of the primitives look good! *)
          True,
          Null
        ]
      ]
    ],
    {flattenedPrimitives, Range[Length[flattenedPrimitives]]}
  ];

  (* If we encountered any bad primitives, yell about them and return $Failed. *)
  If[Length[invalidPrimitiveHeadsWithIndices]>0,
    Message[Error::InvalidUnitOperationHeads, invalidPrimitiveHeadsWithIndices[[All,1]], invalidPrimitiveHeadsWithIndices[[All,2]], myFunction];
  ];

  If[Length[invalidPrimitiveOptionKeysWithIndices]>0,
    Message[Error::InvalidUnitOperationOptions, invalidPrimitiveOptionKeysWithIndices[[All,1]], invalidPrimitiveOptionKeysWithIndices[[All,2]], invalidPrimitiveOptionKeysWithIndices[[All,3]], myFunction];
  ];

  If[Length[invalidPrimitiveOptionPatternsWithIndices]>0,
    Message[Error::InvalidUnitOperationValues, invalidPrimitiveOptionPatternsWithIndices[[All,1]], invalidPrimitiveOptionPatternsWithIndices[[All,2]], invalidPrimitiveOptionPatternsWithIndices[[All,3]], myFunction];
  ];

  If[Length[invalidPrimitiveRequiredOptionsWithIndices]>0,
    Message[Error::InvalidUnitOperationRequiredOptions, invalidPrimitiveRequiredOptionsWithIndices[[All,1]], invalidPrimitiveRequiredOptionsWithIndices[[All,2]], invalidPrimitiveRequiredOptionsWithIndices[[All,3]], myFunction];
  ];

  If[Or[
    Length[invalidPrimitiveHeadsWithIndices]>0,
    Length[invalidPrimitiveOptionKeysWithIndices]>0,
    Length[invalidPrimitiveOptionPatternsWithIndices]>0,
    Length[invalidPrimitiveRequiredOptionsWithIndices]>0
  ],
    (* NOTE: If we're in the builder, we don't want to include the entire unit operation since they won't blob in the text display. *)
    If[MatchQ[$ShortenErrorMessages, True],
      Message[
        Error::InvalidInput,
        shortenPrimitives[
          flattenedPrimitives[[DeleteDuplicates[Flatten[{
            invalidPrimitiveHeadsWithIndices[[All,2]],
            invalidPrimitiveOptionKeysWithIndices[[All,2]],
            invalidPrimitiveOptionPatternsWithIndices[[All,2]],
            invalidPrimitiveRequiredOptionsWithIndices[[All,2]]
          }]]]]
        ]
      ],
      Message[
        Error::InvalidInput,
        flattenedPrimitives[[DeleteDuplicates[Flatten[{
          invalidPrimitiveHeadsWithIndices[[All,2]],
          invalidPrimitiveOptionKeysWithIndices[[All,2]],
          invalidPrimitiveOptionPatternsWithIndices[[All,2]],
          invalidPrimitiveRequiredOptionsWithIndices[[All,2]]
        }]]]]
      ]
    ];

    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> $Failed,
      Options -> $Failed,
      Preview -> Null,
      Input -> myPrimitives
    }];
  ];

  (* Expand the options for each of our primitives so that we have index-matching. *)
  (* Since ExpandIndexMatchedInputs only works on functions, we have to make a "fake" function with the same information *)
  (* as our primitive so that we can do the expanding. *)
  {flattenedIndexMatchingPrimitives, nonIndexMatchingPrimitiveOptions, validLengthsQList}=Transpose@MapThread[
    Function[{primitive, primitiveIndex},
      Block[{placeholderFunction},
        Module[
          {
            primitiveInformation, optionDefinition, primaryInputOption, optionsWithListedPrimaryInput, expandedPrimitive,
            nonIndexMatchingOptionsForPrimitiveHead, nonIndexMatchingOptions, validLengthsQ, destinationUpdateWarning, expandedOptions,
            multipleMultipleExpandedOptions, expandedOptionsWithoutMultipleMultiples, validLengthsMessageHandler, validLengthsMessages, preValidLengthMessageLength
          },

          (* Lookup our primitive information. *)
          primitiveInformation=Lookup[Lookup[primitiveSetInformation, Primitives], Head[primitive], {}];

          (* Lookup the option definition of this primitive. *)
          optionDefinition=Lookup[primitiveInformation, OptionDefinition];

          (* Take the option definition for the head of this primitive and set it as the option definition of our fake function. *)
          placeholderFunction /: OptionDefinition[placeholderFunction] = OverwriteAliquotOptionDefinition[placeholderFunction, optionDefinition];

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

          (* Always ToList our primary input option. This is because if we are given ONLY singletons, the expander will *)
          (* leave everything as a singleton. We always want lists for consistency. *)
          (* NOTE: Make sure not to ToList if our primary input option isn't IndexMatching (as in the case of Wait). *)
          (* NOTE: This logic is mirrored in UploadUnitOperation so make sure that if it changes here to also change it there. *)
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
              primaryInputOption->{Lookup[primitive[[1]], primaryInputOption]}
            ],
            Normal@(primitive[[1]])
          ];

          (* We take each container model to be a different container in SP. If the user specifies multiple sources and one destination container in the form of a model in a transfer primitive, we will expand that to a bunch of container models so each source ends up getting transferred to a different container. We are giving user a warning about this. *)
          destinationUpdateWarning=If[
            And[
              MatchQ[primitive,_Transfer],
              Length[ToList[Lookup[optionsWithListedPrimaryInput,primaryInputOption]]]>1,
              MatchQ[Lookup[optionsWithListedPrimaryInput,Destination],ObjectP[Model[Container]]]
            ],
            Message[Warning::TransferDestinationExpanded,primitive]
          ];

          (* If we don't have any options at all, then don't try to expand the options. *)
          (* NOTE: There's some stupid things that I (Thomas) wrote 4 years ago in ValidInputLengthsQ where it hardcode checks *)
          (* the input against the length of AliquotContainer. *)
          expandedOptions = ExpandIndexMatchedInputs[
            placeholderFunction,
            (* We don't have an input, but just pass down Null to make the expander happy. *)
            {ConstantArray[Null, Length[ToList[Lookup[primitive[[1]], primaryInputOption]]]]},
            optionsWithListedPrimaryInput,
            1,
            FastTrack -> True,
            Messages -> False
          ][[2]];

          (* get the multiple multiple options for Filter *)
          multipleMultipleExpandedOptions = {
            RetentateWashBuffer,
            RetentateWashVolume,
            NumberOfRetentateWashes,
            RetentateWashDrainTime,
            RetentateWashCentrifugeIntensity,
            RetentateWashMix,
            NumberOfRetentateWashMixes,
            RetentateWashPressure,
            RetentateWashBufferLabel,
            RetentateWashBufferContainerLabel,
            WashFlowThroughLabel,
            WashFlowThroughContainerLabel,
            WashFlowThroughContainer,
            WashFlowThroughDestinationWell,
            WashFlowThroughStorageCondition
          };

          expandedOptionsWithoutMultipleMultiples = ReplaceRule[
            expandedOptions,
            Select[optionsWithListedPrimaryInput,MemberQ[multipleMultipleExpandedOptions,Keys[#]]&]
          ];

          expandedPrimitive=If[Length[optionsWithListedPrimaryInput]>0,
            Head[primitive]@Association@expandedOptionsWithoutMultipleMultiples,
            primitive
          ];

          (* See if this primitive has an index matching issue. *)
          (* Prevent any messages from ValidInputLengthsQ from showing up by temporarily directing $Messages to nothing  *)
          validLengthsQ=Block[{$Messages}, Module[{},
            $Messages = {};

            validLengthsMessages = {};

            (* Get the current count of total messages before calling ValidInputLengthsQ *)
            preValidLengthMessageLength = Length[$MessageList];

            validLengthsMessageHandler[one_String, two:Hold[msg_MessageName], three:Hold[Message[msg_MessageName, args___]]] := Module[{},
              (* Keep track of the messages thrown during evaluation of the test. *)
              AppendTo[validLengthsMessages, <|MessageName->Hold[msg],MessageArguments->ToList[args]|>];
            ];

            SafeAddHandler[{"MessageTextFilter", validLengthsMessageHandler},
              Module[{validLengthsResult},
                (* Are our index-matched options valid? *)
                validLengthsResult=ValidInputLengthsQ[
                  placeholderFunction,
                  {ConstantArray[Null, Length[ToList[Lookup[primitive[[1]], primaryInputOption]]]]},
                  optionsWithListedPrimaryInput,
                  Messages->True
                ];

                (* Return our result. *)
                validLengthsResult
              ]
            ]
          ]];

          (* Now that we're out of our block throw our ValidLengths messages prepended primitive index information. *)
          If[MatchQ[validLengthsQ, False],
            MapIndexed[
              throwMessageWithPrimitiveIndex[#1, primitiveIndex, Head[primitive], currentSimulation, preValidLengthMessageLength, #2]&,
              validLengthsMessages
            ]
          ];

          (* Figure out what non-index-matching options we have in this primitive. This is for OptimizeUnitOperations *)
          (* combination later. *)
          nonIndexMatchingOptionsForPrimitiveHead=Cases[optionDefinition, KeyValuePattern["IndexMatching"->"None"]][[All,"OptionSymbol"]];
          nonIndexMatchingOptions=Cases[
            optionsWithListedPrimaryInput,
            Verbatim[Rule][Alternatives@@nonIndexMatchingOptionsForPrimitiveHead, _]
          ];

          {
            expandedPrimitive,
            nonIndexMatchingOptions,
            validLengthsQ
          }
        ]
      ]
    ],
    {flattenedPrimitives, Range[Length[flattenedPrimitives]]}
  ];

  (* For each primitive method index, look and see if we have any auxillary options that have been set. Keep track of them. *)
  invalidMethodOptionsWithIndices={};
  primitiveMethodIndexToOptionsLookup=MapThread[
    Function[{listElement, listIndex},
      (* Does this look like a wrapper and not an individual primitive? *)
      (* NOTE: We're doing the exact opposite as we did up above, here we ONLY want the additional option rules. *)
      If[MatchQ[listElement, Except[_Symbol[_Association]]],
        Module[{suppliedOptions, methodOptionDefinitions, methodOptionPattern},
          (* Get the options given for this primitive wrapper. *)
          suppliedOptions=Cases[List@@listElement, _Rule];

          (* Do some quick error checking to make sure that the options given here. *)
          methodOptionDefinitions=Lookup[Lookup[primitiveSetInformation, MethodOptions], Head[listElement], {}];
          methodOptionPattern=Alternatives@@((Lookup[#,"OptionSymbol"]->ReleaseHold[Lookup[#,"Pattern"]]&)/@methodOptionDefinitions);

          If[!MatchQ[suppliedOptions, {methodOptionPattern...}],
            AppendTo[invalidMethodOptionsWithIndices, {Head[listElement], Cases[suppliedOptions, Except[methodOptionPattern]], listIndex}];
          ];

          listIndex->suppliedOptions
        ],
        listIndex->{}
      ]
    ],
    {sanitizedPrimitives, Range[Length[sanitizedPrimitives]]}
  ];

  If[Length[invalidMethodOptionsWithIndices]>0,
    Message[Error::InvalidMethodOptions, invalidMethodOptionsWithIndices[[All,1]], invalidMethodOptionsWithIndices[[All,2]], invalidMethodOptionsWithIndices[[All,3]]];
  ];

  (* If we threw a valid lengths error, return $Failed. *)
  (* NOTE: We do this down here because we also want to throw pattern doesn't match errors before we return early. *)
  If[MemberQ[validLengthsQList, False],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> $Failed,
      Options -> $Failed,
      Preview -> Null,
      Input -> myPrimitives
    }];
  ];

  (* Use any template options to get values for options not specified in myOptions *)
  {templatedOptions,templateTests}=If[gatherTests,
    ApplyTemplateOptions[myFunction,{sanitizedPrimitives},ToList[myOptions],Output->{Result,Tests}],
    {ApplyTemplateOptions[myFunction,{sanitizedPrimitives},ToList[myOptions]],Null}
  ];

  (* Return early if the template cannot be used - will only occur if the template object does not exist. *)
  If[MatchQ[templatedOptions,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> $Failed,
      Options -> $Failed,
      Preview -> Null,
      Input -> myPrimitives
    }]
  ];

  (* Replace our safe options with our inherited options from our template. *)
  inheritedOptions=ReplaceRule[safeOps,templatedOptions];

  (* Expand index-matching options *)
  expandedSafeOps=Last[ExpandIndexMatchedInputs[myFunction,{sanitizedPrimitives},inheritedOptions]];

  (* Remove our error checking cell. *)
  If[MatchQ[$ECLApplication, CommandCenter|Mathematica],
    NotebookDelete[errorCheckingMessageCell];
  ];

  (*
    we need to do a bit of a weird operation here to LabelSample primitives because the PrimaryInputOption is Label, but it _really_ want to be Sample
    so if the user gives us a LabelSample primitive and specified Sample but not Label, we later on will try to auto-fill it from the _previous_ UO
    instead of respecting the Sample input
  *)
  flattenedIndexMatchingPrimitivesWithCorrectedLabelSample = Map[
    Function[{primitive},
      If[
        And[
          MatchQ[primitive,_LabelSample],
          MatchQ[Lookup[primitive[[1]],{Sample,Label},Null],{ListableP[_String],Null|{}}]
        ],
        LabelSample[Append[primitive[[1]],Label->Lookup[primitive[[1]], Sample]]],
        primitive
      ]
    ], flattenedIndexMatchingPrimitives
  ];

  (* -- STAGE 2: Pre-Resolve the Method to run each Primitive -- *)
  If[debug, Echo["Beginning stage 2: pre-resolving method"]];

  (* Tell the user that we're removing our primitive methods. *)
  primitiveMethodMessageCell=If[MatchQ[$ECLApplication, CommandCenter|Mathematica],
    PrintTemporary[
      Row[{
        Constellation`Private`constellationImage[$ConstellationIconSize],
        Spacer[10],
        "Calculating Allowable Work Cells",
        If[Not[$CloudEvaluation], ProgressIndicator[Appearance->"Percolate"], Nothing]
      }]
    ]
  ];

  (* Resolve the method by which to perform each of our primitives. *)
  (* NOTE: If it's not obvious which method to use, we will have a PrimitiveMethod->ListableP[PrimitiveMethodsP] in the *)
  (* primitive here. *)
  (* If this is the case, we will resolve the primitive method in-line during the simulation loop. *)
  resolvedPrimitiveMethodResult=Check[
    resolvePrimitiveMethods[myFunction, flattenedIndexMatchingPrimitivesWithCorrectedLabelSample, myHeldPrimitiveSet],
    $Failed,
    {Error::InvalidSuppliedPrimitiveMethod}
  ];

  If[MatchQ[resolvedPrimitiveMethodResult, $Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> $Failed,
      Options -> $Failed,
      Preview -> Null,
      Input -> myPrimitives
    }];
  ];

  {primitivesWithResolvedMethods, invalidPrimitiveMethodIndices}=resolvedPrimitiveMethodResult;

  (* -- STAGE 3: Pre-resolve any primary input keys that are expected to "autofill" -- *)
  If[debug, Echo["Beginning stage 3: pre-resolve any autofilling"]];

  (* Automatically propagate the primary input from the previous primitive to the next primitive, unless the previous *)
  (* primitive is generative. This is so that we can more easily resolve the Volume key in LabelSample[...] inside of *)
  (* our simulation MapThread. *)
  {primitivesWithPreresolvedInputs, doNotOptimizeQ}=Transpose@If[Length[primitivesWithResolvedMethods]==1,
    {{First[primitivesWithResolvedMethods], False}},
    (* Fold over our partition will pre-resolve all primitives. *)
    (* NOTE: We have to Fold here and not Map because if there is a sequence like: *)
    (* {Incubate[Sample->"taco"], Mix[Time->15 Minute], Mix[Time->15 Minute]} *)
    (* We need to propagate the "taco" to the first and second Mix primitives. Therefore, we need to map over our *)
    (* propagated list. *)
    FoldList[
      Function[{firstPrimitiveAndBoolean, secondPrimitive},
        Module[{firstPrimitive, firstPrimitiveInformation, firstPrimitiveGenerativeQ, secondPrimitiveInformation, firstPrimitivePrimaryInputOption, secondPrimitivePrimaryInputOption, secondPrimitivePrimaryInputOptionDefinition, secondPrimitiveGenerativeLabelOptions},
          (* The first argument to our function is the output of the last function -- {primitive, doNotOptimizeQ}. *)
          firstPrimitive=First@firstPrimitiveAndBoolean;

          (* For our primitive type, lookup the information about it from our primitive lookup. *)
          firstPrimitiveInformation=Lookup[allPrimitiveInformation, Head[firstPrimitive]];

          (* Are we dealing with a Generative primitive? *)
          firstPrimitiveGenerativeQ=Lookup[firstPrimitiveInformation, Generative];

          (* Lookup information about our second primitive. *)
          secondPrimitiveInformation=Lookup[allPrimitiveInformation, Head[secondPrimitive]];

          (* What option corresponds to the first input for each primitive type? *)
          firstPrimitivePrimaryInputOption=FirstOrDefault[Lookup[firstPrimitiveInformation, InputOptions], Null];
          secondPrimitivePrimaryInputOption=FirstOrDefault[Lookup[secondPrimitiveInformation, InputOptions], Null];
          secondPrimitivePrimaryInputOptionDefinition=FirstCase[Lookup[secondPrimitiveInformation, OptionDefinition], KeyValuePattern["OptionSymbol"->secondPrimitivePrimaryInputOption]];
          secondPrimitiveGenerativeLabelOptions=Lookup[secondPrimitiveInformation, LabeledOptions][[All,2]];

          (* If we're dealing with a generative first primitive, we can't autofill our second primitive. *)
          If[MatchQ[firstPrimitiveGenerativeQ, True],
            {
              secondPrimitive,
              (* NOTE: Do not optimize this primitive (combine it with others) if it is missing the primary input option *)
              (* since we can't fill it out bc the first primitive is generative. *)
              Or[
                !KeyExistsQ[secondPrimitive[[1]], secondPrimitivePrimaryInputOption],
                MatchQ[Lookup[secondPrimitive[[1]], secondPrimitivePrimaryInputOption], ListableP[Automatic]]
              ]
            },
            (* Otherwise, we can pre-resolve our second primitive with the input from our first primitive, if we don't *)
            (* already have input information for our second primitive. *)
            (* Should we fill out the input to the second primitive? *)
            If[
              Or[
                KeyExistsQ[secondPrimitive[[1]], secondPrimitivePrimaryInputOption] && !MatchQ[Lookup[secondPrimitive[[1]], secondPrimitivePrimaryInputOption], ListableP[Automatic]],
                !(KeyExistsQ[firstPrimitive[[1]], firstPrimitivePrimaryInputOption] && !MatchQ[Lookup[firstPrimitive[[1]], firstPrimitivePrimaryInputOption], ListableP[Automatic]]),
                !MatchQ[
                  Lookup[firstPrimitive[[1]], firstPrimitivePrimaryInputOption],
                  ReleaseHold[Lookup[secondPrimitivePrimaryInputOptionDefinition,"Pattern"]]
                ]
              ],
              (* Primary input option to the second primitive is already filled out or the primary input option to the first primitive is not filled out. Nothing to do. *)
              {
                secondPrimitive,
                False
              },
              (* Primary input option to the second primitive is NOT filled out. Fill it out using the first primitive's primary input. *)
              {
                Head[secondPrimitive]@Prepend[
                  secondPrimitive[[1]],
                  secondPrimitivePrimaryInputOption->Lookup[firstPrimitive[[1]], firstPrimitivePrimaryInputOption]
                ],
                False
              }
            ]
          ]
        ]
      ],
      {
        First[primitivesWithResolvedMethods],
        Module[{firstPrimitiveInformation, firstPrimitiveGenerativeLabelOptions},
          (* For our primitive type, lookup the information about it from our primitive lookup. *)
          firstPrimitiveInformation=Lookup[allPrimitiveInformation, Head[First[primitivesWithResolvedMethods]]];
          firstPrimitiveGenerativeLabelOptions=Lookup[firstPrimitiveInformation, LabeledOptions][[All,2]];

          (* NOTE: Do not optimize this primitive (combine it with others) if there are label options. The label *)
          (* options may show up downstream and we can't combine those into a single primitive. *)
          Or@@(KeyExistsQ[First[primitivesWithResolvedMethods][[1]], #]&/@firstPrimitiveGenerativeLabelOptions)
        ]
      },
      Rest@primitivesWithResolvedMethods
    ]
  ];

  (* -- STAGE 4: If OptimizeUnitOperations->True, reorganize and combine the primitives. -- *)
  If[debug, Echo["Beginning stage 4: reorganizing and combining primitives"]];

  (* NOTE: We optimize primitives by (1) hoisting LabelSample/Container unit operations to the front if they don't refer *)
  (* to specific samples, and (2) combining unit operations of the same type that are adjacent to one another. *)
  optimizedPrimitives=If[MatchQ[optimizeUnitOperations, True] && Length[primitivesWithPreresolvedInputs]>1 && MatchQ[previewFinalizedUnitOperations, True],
    Module[{labelHoistedPrimitives, reorderedNonIndexMatchingPrimitiveOptions, indexedUserInitalizedLabels, indexedUserUsedLabels},
      (* 1) Hoist LabelSample/LabelContainer to the front if they don't refer to specific samples. *)
      labelHoistedPrimitives=Module[{labelSamplePositions, labelContainerPositions},
        (* NOTE: We don't want to hoist unit operations up to the front if the user gives us a PrimitiveMethodIndex that is not 1. *)
        labelSamplePositions=Position[
          primitivesWithPreresolvedInputs,
          LabelSample[KeyValuePattern[Sample->ListableP[ObjectP[Model[Sample]]]]?(MatchQ[Lookup[#, PrimitiveMethodIndex], Except[_Integer]|1]&)]
        ];

        labelContainerPositions=Position[
          primitivesWithPreresolvedInputs,
          LabelContainer[KeyValuePattern[Container->ListableP[ObjectP[Model[Container]]]]?(MatchQ[Lookup[#, PrimitiveMethodIndex], Except[_Integer]|1]&)]
        ];

        Join[
          Extract[primitivesWithPreresolvedInputs, labelSamplePositions],
          Extract[primitivesWithPreresolvedInputs, labelContainerPositions],
          Delete[primitivesWithPreresolvedInputs, Join[labelSamplePositions, labelContainerPositions]]
        ]
      ];

      (* Reorder our non index matching options based on this hoisting. *)
      reorderedNonIndexMatchingPrimitiveOptions=labelHoistedPrimitives/.Rule@@@Transpose[{primitivesWithPreresolvedInputs, nonIndexMatchingPrimitiveOptions}];

      (* note that we do NOT convert Mix unit operations into Transfers anymore at this point because this caused bad unintended behavior if doing Mix on a plate *)
      (* this is because ExperimentMix does call containerToSamples but ExperimentTransfer does not, and so we get different behaviors between Mix and Transfer *)
      (* what we actually want is the Mix behavior, so we're just not going to optimize the Mix unit operations for now and let them get worked out on deck. *)

      (* Based on the label options in the primitive, figure out what labels are initialized by the user. *)
      indexedUserInitalizedLabels=Map[
        Function[{primitive},
          Module[{primitiveInformation, primitiveLabeledOptions},
            (* Lookup information about our primitive. *)
            primitiveInformation=Lookup[allPrimitiveInformation, Head[primitive]];
            primitiveLabeledOptions=Lookup[primitiveInformation, LabeledOptions];

            (* Lookup all of our label options and see if the user gave us anything. *)
            DeleteDuplicates@Cases[Flatten[Lookup[primitive[[1]], primitiveLabeledOptions[[All,2]], Null]], _String]
          ]
        ],
        labelHoistedPrimitives
      ];

      (* Figure out which labels are being specified by the user in Object widgets. *)
      indexedUserUsedLabels=Map[
        Function[{primitive},
          DeleteDuplicates@Flatten@KeyValueMap[
            Function[{option, value},
              Module[{primitiveInformation, primitiveOptionDefinitions, optionDefinition},
                (* Lookup information about our primitive. *)
                primitiveInformation=Lookup[allPrimitiveInformation, Head[primitive]];
                primitiveOptionDefinitions=Lookup[primitiveInformation, OptionDefinition];

                (* Lookup information about this option. *)
                optionDefinition=FirstCase[primitiveOptionDefinitions,KeyValuePattern["OptionSymbol"->option],Null];

                (* Do does this option allow for PreparedSample or PreparedContainer? *)
                Which[
                  MatchQ[optionDefinition, Null],
                  (* We don't know about this option. *)
                  Nothing,
                  (* NOTE: We have to convert any associations (widgets automatically evaluate into associations) because *)
                  (* Cases will only look inside of lists, not associations. *)
                  Length[Cases[Lookup[optionDefinition, "Widget"]/.{w_Widget :> Normal[w[[1]]]}, (PreparedContainer->True)|(PreparedSample->True), Infinity]]==0,
                  (* Nothing to replace. *)
                  Nothing,
                  True,
                  (* We may potentially have some labels. *)
                  Module[{matchedWidgetInformation, objectWidgetsWithLabels},
                    (* Match the value of our option to the widget that we have. *)
                    (* NOTE: This is the same function that we use in the command builder to match values to widgets. *)
                    matchedWidgetInformation=AppHelpers`Private`matchValueToWidget[value,optionDefinition];

                    (* Look for matched object widgets that have labels. *)
                    (* NOTE: A little wonky here, all of the Data fields from the AppHelpers function gets returned as a string, so we need *)
                    (* to separate legit strings from objects that were turned into strings. *)
                    objectWidgetsWithLabels=Cases[matchedWidgetInformation, KeyValuePattern[{"Type" -> "Object", "Data" -> _?(!StringStartsQ[#, "Object["] && !StringStartsQ[#, "Model["]&)}], Infinity];

                    (* This will give us our labels. *)
                    (StringReplace[#,"\""->""]&)/@Lookup[objectWidgetsWithLabels, "Data", {}]
                  ]
                ]
              ]
            ],
            primitive[[1]]
          ]
        ],
        labelHoistedPrimitives
      ];

      (* 3) Combine unit operations of the same type that are adjacent to one another.*)
      Module[{groupedPrimitives, currentGroupedPrimitives, nonIndexMatchingOptionsForGroups, currentNonIndexMatchingOptions, allSpecifiedPreparation, roboticQ, allSpecifiedModelContainers, allSpecifiedObjectContainers, allSpecifiedObjectSamples, allFootprintDownloads, sampleToContainerLookup, labelContainerPrimitives, labelSamplePrimitives, labelToContainerLookup, labelToSampleLookup, containerFootprintTuples, containerFootprintTuplesNoDup, allUniqueFootprintsRule, fullDeckForCurrentPrimitiveGroupQ},
        (* Group our primitives. *)
        groupedPrimitives={};
        currentGroupedPrimitives={};

        (* Group our non-index-matching options while we're at it. *)
        nonIndexMatchingOptionsForGroups={};
        currentNonIndexMatchingOptions=Null;

        (* Roughly count how many containers and footprints we have. If we have too many to fit on deck all at once, try to not combine them for now so we can do better grouping later in resolver *)
        (* We only need to care about Robotic ones *)
        allSpecifiedPreparation = Lookup[labelHoistedPrimitives[[All,1]],PrimitiveMethod,Automatic];
        (* Here we check all the preparation to see if Robotic is required (meaning that we can only do Robotic). We cannot PickList only Robotic primitives since our LabelSample/LabelContainer will still be Manual/Automatic here. The transfer primitives are still string labels because we don't have simulated objects yet. To count the correct number, we must get all primitives. Again, this is a rough estimate now. *)
        roboticQ = MemberQ[allSpecifiedPreparation, ListableP[(RoboticSamplePreparation|RoboticCellPreparation)]];

        (* We should try to avoid doing a download here so count only the labeled new containers as a rough estimate. Do it all together before MapThread to avoid unnecessary multiple download calls *)
        allSpecifiedModelContainers=Download[Cases[Flatten[Values[labelHoistedPrimitives[[All,1]]]],ObjectP[Model[Container]]],Object];
        (* Get all objects we need too. Need to delete duplicates since each object is placed once anyway *)
        allSpecifiedObjectContainers=DeleteDuplicates[
          Download[
            Cases[Flatten[Values[labelHoistedPrimitives[[All,1]]]],ObjectP[Object[Container]]],
            Object
          ]
        ];
        allSpecifiedObjectSamples=DeleteDuplicates[
          Download[
            Cases[Flatten[Values[labelHoistedPrimitives[[All,1]]]],ObjectP[Object[Sample]]],
            Object
          ]
        ];
        (* This is a small download to get the footprints of the required containers. It will slow down the code a little but will be a good estimate for our check. This is also a one-time download only *)
        allFootprintDownloads=Quiet[
          Download[
            {
              allSpecifiedObjectSamples,
              allSpecifiedObjectSamples,
              allSpecifiedObjectContainers,
              allSpecifiedModelContainers
            },
            {
              {Container[Object]},
              {Packet[Container[Model[{Footprint}]]]},
              {Packet[Model[{Footprint}]]},
              {Packet[Footprint]}
            },
            Simulation->simulation
          ],
          {Download::FieldDoesntExist,Download::NotLinkField}
        ];

        (* Sample to container Tuple *)
        sampleToContainerLookup=MapThread[
          (Download[#1,Object]->#2)&,
          {allSpecifiedObjectSamples,Flatten[allFootprintDownloads[[1]]]}
        ];

        (* Get the LabelContainer and LabelSample rules to better check footprint *)
        labelContainerPrimitives=Cases[labelHoistedPrimitives,_LabelContainer];
        labelSamplePrimitives=Cases[labelHoistedPrimitives,_LabelSample];

        labelToContainerLookup=Flatten@Map[
          Function[{labelContainer},
            If[KeyExistsQ[labelContainer,Label]&&KeyExistsQ[labelContainer,Container]&&MatchQ[Lookup[labelContainer,Container],ListableP[ObjectP[]]],
              MapThread[(#1->Download[#2,Object])&,{Lookup[labelContainer,Label],Lookup[labelContainer,Container]}],
              {}
            ]
          ],
          labelContainerPrimitives[[All,1]]
        ];

        labelToSampleLookup=Flatten@Map[
          Function[{labelSample},
            If[KeyExistsQ[labelSample,Label]&&KeyExistsQ[labelSample,Sample]&&MatchQ[Lookup[labelSample,Sample],ListableP[ObjectP[]]],
              MapThread[(#1->Download[#2,Object])&,{Lookup[labelSample,Label],Lookup[labelSample,Sample]}],
              {}
            ]
          ],
          labelSamplePrimitives[[All,1]]
        ];

        (* Group the Object[xxx] container and sample container with the footprint download info. Need to flatten out the extra layer of list. Need to do this since user can give us an Object[Sample] that is inside the specified Object[Container] *)
        containerFootprintTuples=Join[
          (* NOTE: Some of our samples may be discarded, but we want to make sure that we don't crash here. *)
          Cases[Transpose[{Flatten[allFootprintDownloads[[1]]],Flatten[allFootprintDownloads[[2]]]}], {ObjectP[], _}],
          Transpose[{allSpecifiedObjectContainers,Flatten[allFootprintDownloads[[3]]]}]
        ];

        (* Delete the duplicated Object[Contaienr] for footprint counting *)
        containerFootprintTuplesNoDup=DeleteDuplicatesBy[containerFootprintTuples,#[[1]]&];

        (* Get all unique footprints. For Object[Container], we count the non-duplicated ones. For Model[Container], since each Model means a new resource picking, we need to count them all *)
        allUniqueFootprintsRule=Join[
          Map[
            (#[[1]]->Lookup[#[[2]],Footprint,Null])&,
            containerFootprintTuplesNoDup
          ],
          Map[
            (Lookup[#,Object]->Lookup[#,Footprint,Null])&,
            Flatten[allFootprintDownloads[[4]]]
          ]
        ];

        (* Define a small helper to tally the footprints for our current primitive group and check if we are beyond the potential limit of full deck *)
        fullDeckForCurrentPrimitiveGroupQ[primitiveGroup_]:=Module[
          {currentGroupSpecifiedModelContainers,currentGroupSpecifiedObjectContainers,currentGroupSpecifiedObjectSamples,currentGroupSpecifiedLabelesObjects,uniqueCurrentGroupObjectContainers,uniqueFootprints,uniqueFootprintsTally,potentialFullDeckQ},

          (* We should try to avoid doing a download here so count only the labeled new containers as a rough estimate *)
          currentGroupSpecifiedModelContainers=Download[Cases[Flatten[Values[primitiveGroup[[All,1]]]],ObjectP[Model[Container]]],Object];
          (* Get all objects we need too. Need to delete duplicates since each object is placed once anyway *)
          currentGroupSpecifiedObjectContainers=DeleteDuplicates[
            Download[
              Cases[Flatten[Values[primitiveGroup[[All,1]]]],ObjectP[Object[Container]]],
              Object
            ]
          ];
          currentGroupSpecifiedObjectSamples=DeleteDuplicates[
            Download[
              Cases[Flatten[Values[primitiveGroup[[All,1]]]],ObjectP[Object[Sample]]],
              Object
            ]
          ];
          currentGroupSpecifiedLabelesObjects=DeleteDuplicates[Cases[Flatten[Values[primitiveGroup[[All,1]]]],_String]]/.Join[labelToContainerLookup,labelToSampleLookup/.sampleToContainerLookup];
          (* Get unique containers from the Object[Sample] and Object[Container] *)
          uniqueCurrentGroupObjectContainers=DeleteDuplicates[Join[currentGroupSpecifiedObjectContainers,currentGroupSpecifiedObjectSamples/.sampleToContainerLookup,Cases[currentGroupSpecifiedLabelesObjects,ObjectP[Object[Container]]]]];

          (* Count the unique footprints and tally them *)
          uniqueFootprints=Join[currentGroupSpecifiedModelContainers,Cases[currentGroupSpecifiedLabelesObjects,ObjectP[Model[Container]]],uniqueCurrentGroupObjectContainers]/.allUniqueFootprintsRule;

          uniqueFootprintsTally=(#[[1]]->#[[2]])&/@(Tally[uniqueFootprints]);

          (* Check if we are approaching a full deck and group accordingly. Note that if our UOs can end up all fit together on deck, we will still group them into a single protocol after resolver *)
          potentialFullDeckQ=Or[
            Length[primitiveGroup]>50,
            (* 50 mL tube. Max 12. Leave 2 Extra for Resources *)
            TrueQ[Lookup[uniqueFootprintsTally,Conical50mLTube,0]>=10],
            (* 2 mL tube or 1.5 mL tube or 0.5 mL tube. Max 60. Leave 10 Extra for Resources *)
            TrueQ[Lookup[uniqueFootprintsTally,MicrocentrifugeTube,0]>=50],
            (* Plate. Max 15. Leave 3 Extra for Resources *)
            TrueQ[Count[uniqueFootprintsTally,Plate]>=12]
          ]

        ];

        (* Go through our primitives and figure out our groupings. *)
        MapThread[
          Function[{primitive, nonIndexMatchingOptions, doNotOptimize, index},
            Which[
              (* If our current grouping is empty, append our primitive. *)
              Length[currentGroupedPrimitives]==0,
              Module[{},
                AppendTo[currentGroupedPrimitives, primitive];
                currentNonIndexMatchingOptions = nonIndexMatchingOptions;
              ],
              (* We can add the primitive to our current group if: *)
              And[
                (* 1) our primitive heads are the same *)
                MatchQ[Head[currentGroupedPrimitives[[1]]], Head[primitive]],
                (* 2) we weren't told to not optimize *)
                !TrueQ[doNotOptimize],
                (* 3) the primitive isn't using a label that was initialized in the previous group *)
                !MemberQ[
                  Flatten[indexedUserInitalizedLabels[[Length[Flatten[groupedPrimitives]]+1;;Length[Flatten[groupedPrimitives]]+Length[currentGroupedPrimitives]]]],
                  Alternatives@@(indexedUserUsedLabels[[index]])
                ],
                (* 4) the primitive has a method in common with the other primitives *)
                MemberQ[
                  Intersection@@(ToList[Lookup[#[[1]], PrimitiveMethod]]&/@currentGroupedPrimitives),
                  Alternatives@@ToList[Lookup[primitive[[1]], PrimitiveMethod]]
                ],
                (* 5) the non-index matching options of this primitive match those that are in our current grouping. *)
                MatchQ[nonIndexMatchingOptions, currentNonIndexMatchingOptions],
                (* 6) The PrimitiveMethodIndex of these primitives does not conflict. *)
                Or[
                  MatchQ[Lookup[primitive[[1]], PrimitiveMethodIndex, Automatic], Automatic],
                  !MemberQ[
                    Cases[Flatten[Lookup[#[[1]], PrimitiveMethodIndex, Automatic]&/@currentGroupedPrimitives], Except[Automatic]],
                    Except[Lookup[primitive[[1]], PrimitiveMethodIndex, Automatic]]
                  ]
                ],
                (* 7) We can potentially get all our containers onto the robot and we do not have too many containers *)
                Not[
                  fullDeckForCurrentPrimitiveGroupQ[currentGroupedPrimitives]&&roboticQ
                ]
              ],
              AppendTo[currentGroupedPrimitives, primitive],
              (* Otherwise, we have to start our new grouping. *)
              True,
              Module[{},
                AppendTo[groupedPrimitives, currentGroupedPrimitives];
                currentGroupedPrimitives={primitive};

                AppendTo[nonIndexMatchingOptionsForGroups, currentNonIndexMatchingOptions];
                currentNonIndexMatchingOptions = nonIndexMatchingOptions;
              ]
            ]
          ],
          {labelHoistedPrimitives, reorderedNonIndexMatchingPrimitiveOptions, doNotOptimizeQ, Range[Length[labelHoistedPrimitives]]}
        ];

        (* If we have a grouping left over, make sure to add it to our overall grouping. *)
        If[Length[currentGroupedPrimitives]>0,
          AppendTo[groupedPrimitives, currentGroupedPrimitives];
          currentGroupedPrimitives={};

          AppendTo[nonIndexMatchingOptionsForGroups, currentNonIndexMatchingOptions];
          currentNonIndexMatchingOptions=Null;
        ];

        (* Combine these primitives. *)
        MapThread[
          Function[{primitiveGroup, nonIndexMatchingOptionsGroup},
            (* If we only have one primitive in this group, nothing to do. *)
            If[Length[primitiveGroup]==1,
              primitiveGroup[[1]],
              Module[
                {primitiveInformation, optionDefinition, nonIndexMatchingOptions, primitiveHead, primitiveAssociations,
                  primitiveAssociationsWithoutSingletonOptions, indexMatchingOptions, indexMatchingOptionSingletonPatterns, indexMatchingOptionDefaults,indexMatchingOptionDefaultsPerPrimitive,
                  primitiveAssociationsWithAllIndexMatchingOptions, listifiedPrimitiveAssociationsWithAllIndexMatchingOptions},

                (* Get the head of the primitive type and convert the rest into associations. *)
                primitiveHead=Head[primitiveGroup[[1]]];
                primitiveAssociations=(#[[1]]&)/@primitiveGroup;

                (* Lookup our primitive information. *)
                primitiveInformation=Lookup[Lookup[primitiveSetInformation, Primitives], primitiveHead, {}];

                (* Lookup the option definition of this primitive. *)
                optionDefinition=Lookup[primitiveInformation, OptionDefinition];

                (* Get the names of the non index matching options to not join. *)
                (* NOTE: All primitives should have their PrimitiveMethod key by now. *)
                nonIndexMatchingOptions=nonIndexMatchingOptionsGroup[[All,1]];

                (* Only include keys in these primitive associations that are index matching. *)
                primitiveAssociationsWithoutSingletonOptions=(
                  Association@Cases[Normal@#, Verbatim[Rule][Except[Alternatives@@nonIndexMatchingOptions], _]]
                      &)/@primitiveAssociations;

                (* Get all of the option names that are index matching in this primitive group. *)
                indexMatchingOptions=Complement[
                  DeleteDuplicates[Flatten[Keys/@primitiveAssociationsWithoutSingletonOptions]],
                  {PrimitiveMethod}
                ];

                (* Get the singleton patterns for these index matching options. *)
                indexMatchingOptionSingletonPatterns=Map[
                  (#->ReleaseHold@Lookup[FirstCase[optionDefinition, KeyValuePattern["OptionSymbol"->#], <|"SingletonPattern"->Hold[_]|>], "SingletonPattern"])&,
                  indexMatchingOptions
                ];

                (* Get the defaults for these index matching options. *)
                indexMatchingOptionDefaults=(
                  #->ReleaseHold@Lookup[FirstCase[optionDefinition, KeyValuePattern["OptionSymbol"->#], <|"Default"->Null|>], "Default"]
                      &)/@indexMatchingOptions;

                (* Make sure our index matching options are expanded in the correct way *)
                indexMatchingOptionDefaultsPerPrimitive=Map[
                  Function[
                    {primitiveSingle},
                    Module[
                      {firstIndexMatchingValueInPrimitive,primitiveLength,indexMatchingKeys,indexMatchingValues},
                      indexMatchingKeys=Keys[indexMatchingOptionDefaults];
                      indexMatchingValues=Lookup[primitiveSingle,indexMatchingKeys,Null];
                      (* Check for the first index matching value that does not match singleton pattern (meaning that it is expanded), if any. Otherwise we have all options as singleton, and can just use 1 as the length *)
                      (* Note: In theory, our primitive should have been expanded properly at this moment (see flattenedIndexMatchingPrimitives). However, for rare case like Aliquot that we allow nested index matching and only the input was expanded to one layer of list, the options may not have been properly expanded (remain singleton). Here, we perform this additional check and expansion to handle that. The following check here is fairly safe to do regardless *)
                      firstIndexMatchingValueInPrimitive = FirstOrDefault[
                        MapThread[
                          Module[
                            {singletonPattern},
                            singletonPattern=Lookup[indexMatchingOptionSingletonPatterns,#1];
                            If[MatchQ[#2,singletonPattern],
                              Nothing,
                              #2
                            ]
                          ]&,
                          {indexMatchingKeys,indexMatchingValues}
                        ],
                        {Automatic}
                      ];
                      primitiveLength=Length[firstIndexMatchingValueInPrimitive];
                      KeyValueMap[
                        #1->ConstantArray[#2,primitiveLength]&,
                        Association@indexMatchingOptionDefaults
                      ]
                    ]
                  ],
                  primitiveAssociationsWithoutSingletonOptions
                ];

                (* Make sure that each association has the full set of index matching options. *)
                primitiveAssociationsWithAllIndexMatchingOptions=MapThread[
                  Merge[{#1, Association@#2}, First]&,
                  {primitiveAssociationsWithoutSingletonOptions,indexMatchingOptionDefaultsPerPrimitive}
                ];

                (* If the value of the index matching option is not already a list, we need to listify it before we merge the values together for optimization. *)
                (* Map through each of the primitive association we have *)
                listifiedPrimitiveAssociationsWithAllIndexMatchingOptions=Map[
                  Function[
                    {individualAssociation},
                    (* Map through each key in our association *)
                    Association@KeyValueMap[
                      Which[
                        (* If it is not in a list, ToList it *)
                        MatchQ[#2,Except[_List]],(#1->ToList[#2]),
                        (* A special case for value already in a list. We allow list {position,container} as values for a lot of the keys, like Sample key in the LabelSample primitive. We cannot just merge it! That will turn {A1,container1} and {A1,container2} into a flattened list {A1,container1,A2,container2}. This is NOT correct and will create down-stream issues! We should turn that into an extra layer of list. *)
                        (* NOTE: We don't want to wrap an additional list around {"A1", "A1"}. This should probably use the SingletonPattern logic that we use in other cases. *)
                        MatchQ[#2,{WellPositionP,ObjectP[{Model[Container],Object[Container]}]|Except[WellPositionP, _String]}],(#1->List[#2]),
                        (* Otherwise, our option is already in a list and we can go with it. *)
                        True,#1->#2
                      ]&,
                      individualAssociation
                    ]
                  ],
                  primitiveAssociationsWithAllIndexMatchingOptions
                ];

                (* Construct the combined primitive. *)
                primitiveHead@@{
                  (* Merged index matching options, using the already listed values prepared above. We can just join the lists together here and they will be index matched. *)
                  Sequence@@Normal@Merge[listifiedPrimitiveAssociationsWithAllIndexMatchingOptions, (Join@@(#)&)],
                  (* Singleton options. *)
                  Sequence@@nonIndexMatchingOptionsGroup,
                  (* Internal PrimitiveMethod option. *)
                  PrimitiveMethod->FirstOrDefault@Intersection[Lookup[primitiveAssociations, PrimitiveMethod]],
                  (* Internal PrimitiveMethodIndex option. *)
                  PrimitiveMethodIndex->FirstCase[Flatten[Lookup[primitiveAssociations, PrimitiveMethodIndex, Automatic]], _Integer, Automatic]
                }
              ]
            ]
          ],
          {groupedPrimitives, nonIndexMatchingOptionsForGroups}
        ]
      ]
    ],
    primitivesWithPreresolvedInputs
  ];

  (* Remove our primitive method cell. *)
  If[MatchQ[$ECLApplication, CommandCenter|Mathematica],
    NotebookDelete[primitiveMethodMessageCell];
  ];

  (* -- STAGE 5: Simulation Loop to Resolve Primitives and Resolve Primitive Groupings --*)
  If[debug, Echo["Beginning stage 5: Main resolving/simulation loop"]];

  (* Tell the user that we're removing our primitive methods. *)
  simulationPreparationMessageCell=If[MatchQ[$ECLApplication, CommandCenter|Mathematica],
    PrintTemporary[
      Row[{
        Constellation`Private`constellationImage[$ConstellationIconSize],
        Spacer[10],
        "Initializing virtual laboratory for protocol simulation",
        If[Not[$CloudEvaluation], ProgressIndicator[Appearance->"Percolate"], Nothing]
      }]
    ]
  ];

  (* -- Resolver Globals -- *)
  (* Keep track of any primitives with bad labels that don't match their option patterns. *)
  invalidLabelPrimitivesWithIndices={};

  (* Keep track of any invalid input autofills -- this can really only happen during the first primitive. *)
  invalidAutofillPrimitivesWithIndices={};

  (* Keep track of primitives that cannot be performed by any methods. *)
  invalidResolvePrimitiveMethodsWithIndices={};

  (* Keep track of the tests that we get back from each resolver function. *)
  allResolverTests={};

  (* Keep track of the label fields that we get, with the primitive indices that they correspond to -- {label_String->LabelField[]...} *)
  allLabelFieldsWithIndicesGroupings={};

  (* NOTE: We have to have this current label fields and NOT append to the total list when within a workcell grouping because *)
  (* we do not want to be replacing labels to LabelFields[...] WITHIN a work cell grouping, since it's self contained. We DO want *)
  (* to replace labels with LabelFields[...] within an Experiment group (NOT ManualSamplePreparation) though since they will ultimately be *)
  (* split up. *)
  currentLabelFieldsWithIndices={};

  (* -- Primitive Method Grouping Globals -- *)
  (* Keep track of the total list of groupings that we have and our current grouping. *)
  allPrimitiveGroupings={};
  allUnresolvedPrimitiveGroupings={};
  allPrimitiveInputGroupings={};
  allPrimitiveOptionGroupings={};

  allPrimitiveGroupingResources={};
  allPrimitiveGroupingUnitOperationPackets={};
  allPrimitiveGroupingBatchedUnitOperationPackets={};
  (* NOTE: This is the format:*)
  (*
    {
      {
        containerFootprint:FootprintP,
        liquidHandlerAdapter:(ObjectP[Model[Container, Rack]]|Null),
        container:ObjectP[Object[Container]],
        resource:ResourceP
      }..
    }.
  *)
  allPrimitiveGroupingFootprints={};
  allPrimitiveGroupingTips={};
  allPrimitiveGroupingIntegratedInstrumentResources={};
  allPrimitiveGroupingWorkCellInstruments={};
  allPrimitiveGroupingIncubatorContainerResources={};
  allPrimitiveGroupingAmbientContainerResources={};
  allPrimitiveGroupingWorkCellIdlingConditionHistory={};
  allPrimitiveGroupingRunTimes={};

  (* Keep track of the current things required to be on the workcell deck. *)
  currentPrimitiveGrouping={};
  currentUnresolvedPrimitiveGrouping={};
  currentPrimitiveInputGrouping={};
  currentPrimitiveOptionGrouping={};

  (* NOTE: The following will MAINLY be used in robotic protocols. It will also be used for LabelSample/LabelContainer *)
  (* in Manual protocols. *)
  currentPrimitiveGroupingLabeledObjects={}; (* {(_String->ResourceP)..} *)
  currentPrimitiveGroupingUnitOperationPackets={}; (* {{PacketP[Object[UnitOperation]]..}..} *)
  currentPrimitiveGroupingBatchedUnitOperationPackets={}; (* {{PacketP[Object[UnitOperation]]..}..} *)

  (* NOTE: The following will NOT be filled out for a ManualSamplePreparation/Experiment grouping because we have no *)
  (* footprint/tip limitations. *)
  currentPrimitiveGroupingFootprints={}; (* {{FootprintP, ObjectP[Object[Container]], ResourceP}..} *)
  currentPrimitiveGroupingTips={}; (* {Resource[Sample->Model[Item, Tips], Amount->_Integer]..} *)
  currentPrimitiveGroupingIntegratedInstrumentsResources={}; (* {InstrumentResourceP..} *)
  (* These are the potential Model[Instrument, LiquidHandler] or Model[Instrument, ColonyHandler]s that meet the requirements. *)
  currentPrimitiveGroupingPotentialWorkCellInstruments={}; (* {ObjectP[{Model[Instrument, LiquidHandler],Model[InstrumentColonyHandler]}]..} *)

  (* These are, respectively, the Object[Container]s that should be placed in the incubator for the start of the run *)
  (* and the Object[Container]s that should be place Ambient-ly (either on deck or off deck) since they don't *)
  (* contain cells. *)
  currentPrimitiveGroupingIncubatorPlateResources={}; (* {ResourceP..} *)
  currentPrimitiveGroupingAmbientPlateResources={}; (* {ResourceP..} *)
  currentPrimitiveGroupingWorkCellIdlingConditionHistory={}; (* {(ObjectP[Object[Container]] -> WorkCellIdlingConditionP)..} *)
  currentPrimitiveGroupingRunTimes={}; (* {(TimeP|Null)..} *)

  (* Keep track of primitives that cannot fit on any work cell, regardless of grouping. *)
  noInstrumentsPossibleErrorsWithIndices={};

  (* Keep track of any overwritten labels. *)
  allOverwrittenLabelsWithIndices={};

  (* Keep track of if we've already added an automatic cover primitive to CoverAtEnd for robotic groupings. *)
  addedCoverAtEndPrimitiveQ=False;

  (* Initialize our primitive index to 1. *)
  index=1;

  (* Helper function overload *)
  startNewPrimitiveGrouping[]:=startNewPrimitiveGrouping[False];
  (* Helper function that will reset our lists for us. *)
  startNewPrimitiveGrouping[cleanUpBool_]:=Module[{startNewGroupingQ},
    (* Set this variable to continue since Return[] doesn't work as expected. *)
    startNewGroupingQ=True;

    If[Length[currentPrimitiveGrouping]>0,
      (* Should we add a cover primitive and go back to the top of our MapThread to add the cover primitive's information to *)
      (* our grouping before REALLY starting a new grouping? *)
      If[And[
        MatchQ[optimizeUnitOperations, True],
        MatchQ[previewFinalizedUnitOperations, True],
        MatchQ[coverAtEnd, True],
        MatchQ[Lookup[currentPrimitiveGrouping[[1]][[1]], PrimitiveMethod], RoboticSamplePreparation|RoboticCellPreparation],
        !MatchQ[Lookup[currentPrimitiveGrouping[[1]][[1]], WorkCell], qPix],
        MatchQ[addedCoverAtEndPrimitiveQ, False],
        Length[invalidResolverPrimitives]==0
      ],
        Module[
          {uniqueContainersInGrouping, uniqueContainersInGroupingLabelLookup, currentGroupingCoverPrimitives, coveredContainers,
            rawContainersToCover, lidInternalDimensions2D, rawContainersToCoverDownload, containerCanCoverQ, containersToCover},
          (* Get all of the unique containers that were manipulated in our current primitive grouping. *)
          (* NOTE: We only get the plates here because we cannot cover vessels. *)
          uniqueContainersInGrouping=Cases[currentPrimitiveGroupingFootprints[[All,3]], ObjectP[Object[Container, Plate]]];
          uniqueContainersInGroupingLabelLookup=Cases[Lookup[currentSimulation[[1]], Labels], Verbatim[Rule][_String, ObjectP[uniqueContainersInGrouping]]];

          (* Get any cover primitives that are within our grouping. *)
          currentGroupingCoverPrimitives=Cases[currentPrimitiveGrouping, _Cover];

          (* Get the containers that we are operating on. Also translate everything into objects if possible. *)
          coveredContainers=DeleteDuplicates[Flatten[{(Lookup[#[[1]], Sample]&)/@currentGroupingCoverPrimitives}]/.uniqueContainersInGroupingLabelLookup];

          (* Get our containers to cover. *)
          rawContainersToCover=Complement[
            uniqueContainersInGroupingLabelLookup[[All,2]],
            coveredContainers
          ];

          {{{lidInternalDimensions2D}},rawContainersToCoverDownload}=Quiet[
            Download[
              {
                {Model[Item, Lid, "id:N80DNj16AaKA"]},
                rawContainersToCover
              },
              {
                {InternalDimensions2D},
                {
                  Packet[Cover,Model,AwaitingDisposal],
                  Packet[Model[{CoverFootprints,CoverTypes,ExternalDimensions3D}]]
                }
              },
              Simulation->currentSimulation
            ],
            Download::FieldDoesntExist
          ];

          containerCanCoverQ=Map[
            And[
              (* No cover currently *)
              NullQ[Lookup[#[[1]],Cover]],
              (* Not flagged for awaiting disposal so that the simulation does not mess up with cover primitive calculation*)
              Not[TrueQ[Lookup[#[[1]],AwaitingDisposal]]],
              (* Can accept Place Lid *)
              MatchQ[Lookup[#[[2]],CoverFootprints],{___, LidSBSUniversal, ___}],
              MatchQ[Lookup[#[[2]],CoverTypes],{___, Place, ___}],
              Or[
                NullQ[lidInternalDimensions2D],
                MatchQ[
                  (* Top dimensions is at the largest z *)
                  LastOrDefault[SortBy[Lookup[#[[2]],ExternalDimensions3D],Last],Null],
                  Alternatives[
                    Null,
                    (* 0.5mm smaller on both x and y *)
                    {LessEqualP[(lidInternalDimensions2D[[1]]/.(Null->200Millimeter))-0.5Millimeter],LessEqualP[(lidInternalDimensions2D[[2]]/.(Null->200Millimeter))-0.5Millimeter],_}
                  ]
                ]
              ]
            ]&,
            rawContainersToCoverDownload
          ];

          (* Make sure that these containers really do not have covers on them. Then, translate to labels if possible. *)
          containersToCover=PickList[
            rawContainersToCover,
            containerCanCoverQ,
            True
          ]/.(Reverse/@uniqueContainersInGroupingLabelLookup);

          (* If we have containers to cover at the end of our robotic grouping, insert the cover primitive. *)
          If[Length[containersToCover]>0,
            (* Set this flag to True. It resets when we actually start a new grouping. *)
            addedCoverAtEndPrimitiveQ=True;

            Module[{primitiveMethodIndexOfLastPrimitive},
              (* Get the primitive method index of the last primitive. We have to specify the PrimitiveMethodIndex so that we *)
              (* will be okay adding the Cover primitive to the previous method index grouping. *)
              primitiveMethodIndexOfLastPrimitive=Lookup[Last[currentPrimitiveGrouping][[1]], PrimitiveMethodIndex, Automatic];

              (* Insert this into our coverOptimizedPrimitives and Continue[] to automatically go to the next iteration of the While[...] loop. *)
              (* NOTE: We insert at the same index because we want to add the cover primitive BEFORE we go to the next grouping. Unless *)
              (* we're calling this function because we're at the very end of our list of primitives. *)
							(* we have an edge case where we may be trying to create a new cover primitive during the cleanup phase below, and we want to add the cover primitive at the end *)
							(* if we are not cleaning up though, we will need to Continue[] to resolve the cover primitive before re-resolving the final primitive, so make this decision based off the cleaning-up Boolean *)
              If[index==Length[coverOptimizedPrimitives] && TrueQ[cleanUpBool],
                Module[{},
                  coverOptimizedPrimitives=Insert[coverOptimizedPrimitives, Cover[Sample->containersToCover, Preparation->Robotic, PrimitiveMethodIndex->primitiveMethodIndexOfLastPrimitive], index+1];

                  (* NOTE: This makes us exist out of this helper function and back into the while loop. *)
                  startNewGroupingQ=False;
                ],
                Module[{},

                  (* We are here since we need to add a new Cover primitive into our old group, after we decide we need to start a new group. *)
                  (* When we decide we need to start a new group, we already processed the newest primitive and simulated everything. Since it will be in the new group, we need to remove the simulation there and we will do it again in the correct group.
    Note that previousSimulation and currentSimulation are both variables set up in the While loop *)
                  (* We don't do this in the clean up case as that is not to start a new group. It is to conclude the whole set of unit operations. We are not skipping anything there. *)
                  currentSimulation=previousSimulation;

                  coverOptimizedPrimitives=Insert[coverOptimizedPrimitives, Cover[Sample->containersToCover, Preparation->Robotic, PrimitiveMethodIndex->primitiveMethodIndexOfLastPrimitive], index];

                  Continue[];
                ]
              ];
            ]
          ];
        ];
      ];

      If[startNewGroupingQ,
        (* Reset our flag since we're really starting a new grouping. *)
        addedCoverAtEndPrimitiveQ=False;

        (* Setup a new grouping and add this primitive to that new grouping. *)
        AppendTo[allPrimitiveGroupings, currentPrimitiveGrouping];
        AppendTo[allUnresolvedPrimitiveGroupings, currentUnresolvedPrimitiveGrouping];
        AppendTo[allPrimitiveInputGroupings, currentPrimitiveInputGrouping];
        AppendTo[allPrimitiveOptionGroupings, currentPrimitiveOptionGrouping];
        AppendTo[allPrimitiveGroupingFootprints, currentPrimitiveGroupingFootprints];
        AppendTo[allPrimitiveGroupingTips, currentPrimitiveGroupingTips];
        AppendTo[allPrimitiveGroupingIntegratedInstrumentResources, currentPrimitiveGroupingIntegratedInstrumentsResources];
        AppendTo[allPrimitiveGroupingWorkCellInstruments, currentPrimitiveGroupingPotentialWorkCellInstruments];
        AppendTo[allPrimitiveGroupingIncubatorContainerResources, currentPrimitiveGroupingIncubatorPlateResources];
        AppendTo[allPrimitiveGroupingAmbientContainerResources, currentPrimitiveGroupingAmbientPlateResources];
        AppendTo[allPrimitiveGroupingWorkCellIdlingConditionHistory, currentPrimitiveGroupingWorkCellIdlingConditionHistory];
        AppendTo[allPrimitiveGroupingResources, currentPrimitiveGroupingLabeledObjects];
        AppendTo[allPrimitiveGroupingUnitOperationPackets, currentPrimitiveGroupingUnitOperationPackets];
        AppendTo[allPrimitiveGroupingBatchedUnitOperationPackets, currentPrimitiveGroupingBatchedUnitOperationPackets];
        AppendTo[allPrimitiveGroupingRunTimes, currentPrimitiveGroupingRunTimes];
        AppendTo[allLabelFieldsWithIndicesGroupings, currentLabelFieldsWithIndices];

        (* Reset our tracking variables. *)
        currentPrimitiveGrouping={};
        currentUnresolvedPrimitiveGrouping={};
        currentPrimitiveInputGrouping={};
        currentPrimitiveOptionGrouping={};
        currentPrimitiveGroupingFootprints={};
        currentPrimitiveGroupingTips={};
        currentPrimitiveGroupingIntegratedInstrumentsResources={};
        currentPrimitiveGroupingPotentialWorkCellInstruments={};
        currentPrimitiveGroupingIncubatorPlateResources={};
        currentPrimitiveGroupingAmbientPlateResources={};
        currentPrimitiveGroupingWorkCellIdlingConditionHistory={};
        currentPrimitiveGroupingLabeledObjects={};
        currentPrimitiveGroupingUnitOperationPackets={};
        currentPrimitiveGroupingBatchedUnitOperationPackets={};
        currentPrimitiveGroupingRunTimes={};
        currentLabelFieldsWithIndices={};
        (* Record the date we are starting the primitive resolving, if this is a new group *)
        currentPrimitiveGroupingDateStarted=currentPrimitiveDateStarted;
      ];
    ]
  ];

  (* Create a single fake water sample to use for any unknown labels during our resolving processing. *)
  (* This will be our first sample in our simulation. *)
  {fakeContainer, fakeWaterSample, fakeWaterSimulation}=simulateFakeWaterSample[];

  (* Get our current simulation. *)
  currentSimulation=UpdateSimulation[
    If[MatchQ[Lookup[safeOps, Simulation], Null],
      Simulation[],
      Lookup[safeOps, Simulation]
    ],
    fakeWaterSimulation
  ];

  (* Find all racks that we can use on the liquid handler. Figure out how many individual vessels that we can place *)
  (* inside of each of these racks. Also note that we need to include spacers in here *)
  liquidHandlerCompatibleRacks = hamiltonRackModelSearch["Memoization"];
  (* Download the necessary information about our workcells and potential tips before we go into our loop. *)
  allTipModels = hamiltonTipModelSearch["Memoization"];
  modelContainerFields = Flatten[{SamplePreparationCacheFields[Model[Container], Format -> List], Immobile, MetaXpressPrefix, HighPrecisionPositionRequired, CoverTypes}];
  objectContainerFields = Flatten[{SamplePreparationCacheFields[Object[Container], Format -> List], CoverLog}];
  (* TODO: when this system is migrated to UploadProtocol, remove the extra field *)
  objectSampleFields = Append[SamplePreparationCacheFields[Object[Sample], Format -> List], DoubleGloveRequired];
  modelSampleFields = Append[SamplePreparationCacheFields[Model[Sample], Format -> List], DoubleGloveRequired];

  {
    workCellModelPackets,
    workCellObjectPackets,
    liquidHandlerCompatibleRackPackets,
    tipModelPackets,
    samplePackets,
    sampleModelPackets,
    containerPackets,
    heavyMagnetizationRacks,
    parentProtocolStack
  }=Quiet[
    With[{insertMe1=Packet@@objectSampleFields,insertMe2=Packet@@objectContainerFields,insertMe3=Packet@@modelSampleFields},
      Download[
        {
          Flatten[Values[$WorkCellsToInstruments]],
          (* NOTE: We can be told by the user to use a specific Object[Instrument, LiquidHandler] either through the global *)
          (* Instrument option or via the primitive grouping wrapper Instrument option. *)
          DeleteDuplicates@Download[Cases[Join[primitiveMethodIndexToOptionsLookup,{Lookup[safeOps,Instrument]}], ObjectP[Object[Instrument]], Infinity], Object],
          liquidHandlerCompatibleRacks,
          allTipModels,
          DeleteDuplicates[Download[Cases[flattenedPrimitives, ObjectReferenceP[Object[Sample]], Infinity], Object]],
          DeleteDuplicates[Download[Cases[flattenedPrimitives, ObjectReferenceP[Model[Sample]], Infinity], Object]],
          DeleteDuplicates[Download[Cases[flattenedPrimitives, ObjectReferenceP[Object[Container]], Infinity], Object]],
          {Model[Item, MagnetizationRack, "id:kEJ9mqJYljjz"]},
          {parentProtocol} /. {Null -> Nothing}
        },
        Evaluate[{
          List@Packet[Name, AvailableFootprints, MaxNonStackedTipPositions, MaxStackedTipPositions, IntegratedInstruments, MaxIncubatorPlatePositions, MaxOffDeckStoragePositions],
          List@Packet[Name, Model],
          List@Packet[Name, Positions, Footprint],
          List@Packet[Object, Name, PipetteType, Sterile, RNaseFree, WideBore,Filtered,GelLoading,Aspirator, Material, AspirationDepth, TipConnectionType, MinVolume, MaxVolume, NumberOfTips, MaxStackSize, Footprint],
          {
            insertMe1,
            Packet[Container[objectContainerFields]],
            Packet[Container[Model[modelContainerFields]]],
            Packet[Container[Model[LiquidHandlerAdapter][{Footprint}]]]
          },
          {
            insertMe3
          },
          {
            insertMe2,
            Packet[Field[Contents[[All,2]]][objectSampleFields]],
            Packet[Field[Contents[[All,2]]][Model][modelSampleFields]],
            Packet[Model[modelContainerFields]],
            Packet[Model[LiquidHandlerAdapter][{Footprint}]]
          },
          {Object,Objects},
          {Object, ParentProtocol..[Object]}
        }],
        Simulation -> currentSimulation
      ]
    ],
    {Download::FieldDoesntExist,Download::NotLinkField,Download::Part}
  ];

  (* get the root protocol here; in this case Null means that we don't have a parent (so root is self) *)
  rootProtocol = If[NullQ[parentProtocol],
    Null,
    LastOrDefault[Cases[Flatten[parentProtocolStack], ObjectP[]]]
  ];

  cacheBall=FlattenCachePackets[{workCellModelPackets, workCellObjectPackets, liquidHandlerCompatibleRackPackets, tipModelPackets, samplePackets, sampleModelPackets, containerPackets}];

  {workCellModelPackets, workCellObjectPackets, liquidHandlerCompatibleRackPackets, tipModelPackets}=Flatten/@{workCellModelPackets, workCellObjectPackets, liquidHandlerCompatibleRackPackets, tipModelPackets};

  (* Get all Object[Sample]s and Model[Sample]s referenced in our primitives and see if we can find any *)
  (* microbial cells in them. This will be used for defaulting the work cell to use for each of the unit operations. *)
  (* If we're dealing with microbes at all and are on the robot, use the microbioSTAR. *)
  {cellsPresentQ, sterileQ, microbialQ, cellSamplesForErrorChecking} = Module[
    {sampleAndContainerCache, sampleCachePackets, samplesContainingCells, sterileSamplesQ, livingMaterialQ, cellModels, cellTypes, microbialMaterialQ},

    (* Gather information on the sample models and objects. *)
    sampleAndContainerCache = FlattenCachePackets[{samplePackets, sampleModelPackets}];
    sampleCachePackets = Cases[sampleAndContainerCache, PacketP[{Object[Sample], Model[Sample]}]];

    samplesContainingCells = Map[
      Function[{cachePacket},
        Which[
          (* Check for Living -> True. *)
          TrueQ[Lookup[cachePacket, Living, Null]], Lookup[cachePacket, Object],
          (* Check for CellType -> CellTypeP. *)
          MemberQ[Lookup[cachePacket, CellType, Null], CellTypeP], Lookup[cachePacket, Object],
          (* Check for cell models in the Composition. *)
          MemberQ[Flatten@Lookup[cachePacket, Composition], ObjectP[Model[Cell]]], Lookup[cachePacket, Object],
          (* If we made it this far, consider this sample cell-free. *)
          True, Nothing
        ]
      ],
      sampleCachePackets
    ];

    (* Check for Sterile/AsepticHandling -> True. *)
    sterileSamplesQ = MemberQ[Flatten@Lookup[sampleCachePackets, {Sterile, AsepticHandling}, Null], True];

    (* Determine whether we have any cells or living samples. *)
    livingMaterialQ = GreaterQ[Length[samplesContainingCells], 0];

    (* If we have cells, get any cell models and cell types from the composition of all samples. *)
    {cellModels, cellTypes} = If[livingMaterialQ,
      {
        Cases[Flatten[Lookup[sampleCachePackets, Composition]], ObjectP[Model[Cell]]],
        Lookup[sampleCachePackets, CellType, Null]
      },
      {{}, {}}
    ];

    (* Determine whether we have microbes. *)
    microbialMaterialQ = Or[
      MemberQ[cellModels, ObjectP[{Model[Cell, Bacteria], Model[Cell, Yeast]}]],
      MemberQ[cellTypes, MicrobialCellTypeP]
    ];

    (* Return the final values for cellsOrSterileQ and microbialQ, as well as any samples which have cells. *)
    {livingMaterialQ, sterileSamplesQ, microbialMaterialQ, samplesContainingCells}
  ];

  (* Resolve the post processing options. *)
  {resolvedImageSample, resolvedMeasureVolume, resolvedMeasureWeight} = Module[
    {preResolvedImageSample, preResolvedMeasureVolume, preResolvedMeasureWeight, cellsOrSterileSamplesQ},

    (* Get the post-processing option values from the sample preparation function; default to Automatic if they don't have post-processing options (like ExperimentManualCellPreparation) *)
    preResolvedImageSample = Lookup[safeOps, ImageSample, Automatic];
    preResolvedMeasureVolume = Lookup[safeOps, MeasureVolume, Automatic];
    preResolvedMeasureWeight = Lookup[safeOps, MeasureWeight, Automatic];

    (* We resolve post processing in the same way for cell-containing samples and otherwise sterile samples. *)
    cellsOrSterileSamplesQ = Or[cellsPresentQ, sterileQ];

    (* Resolve and return. *)
    Map[
      Function[
        {preResolvedValue},
        Switch[{preResolvedValue, cellsOrSterileSamplesQ},
          {Except[Automatic], _}, preResolvedValue,
          {Automatic, True}, False,
          {_, _}, True
        ]
      ],
      {preResolvedImageSample, preResolvedMeasureVolume, preResolvedMeasureWeight}
    ]
  ];

  (* Build a lookup relating each liquid handler adapter to the maximum number of vessels that can fit into each adapter. *)

  (* Helper function to figure out how many footprints are going to be used on the liquid handler deck given footprint information *)
  (* in the form: *)
  (*
	{
	  {
		Footprint->containerFootprint:FootprintP,
		LiquidHandlerAdapter->liquidHandlerAdapter:(ObjectP[Model[Container, Rack]]|Null),
		Container->container:ObjectP[Object[Container]],
		Resource->resource:ResourceP,
		HighPrecisionPositionRequired->highPrecisionPositionContainer:Boolean,
		(* to track future resource consolidation *)
		Index->index,
		(* to show the container grouping/resource consolidation *)
		(* this containerModels is the updates possible list of containers, with small containers (MaxVolume < consolidated volume) removed *)
		ContainerModels->containerModels,
		ContainerName->containerName,
		Well->well,
		(* NOTE: This is only populated for resources that are coming out of a ThawCells unit operation since *)
		(* we don't want to group together vials on the same liquid handler adapter if they should be thawed *)
		(* for different amounts of time. *)
		IncubationTime->incubationTime:(TimeP|Null)
	  }..
	}.
  *)
  footprintInformationKeys={
    Footprint,
    LiquidHandlerAdapter,
    Container,
    Resource,
    HighPrecisionPositionRequired,
    Index,
    ContainerModels,
    ContainerName,
    Well,
    IncubationTime
  };
  tallyFootprints[footprintInformation_List]:=Module[{nonAdaptedFootprintInformation, adaptedFootprintInformation, groupedAdaptedFootprintInformation, groupedTalliedAdaptedFootprintInformation, convertedAdaptedFootprints},
    (* Get all of the footprints that aren't in a liquid handler adapter. *)
    nonAdaptedFootprintInformation=Cases[footprintInformation, KeyValuePattern[LiquidHandlerAdapter->Null]];
    adaptedFootprintInformation=Cases[footprintInformation, KeyValuePattern[LiquidHandlerAdapter->Except[Null]]];

    (* Group our adapted footprints by the incubation time entry before we perform a tally. This is because we don't want *)
    (* containers with different incubation times to go onto the same liquid handler rack. *)
    groupedAdaptedFootprintInformation=GatherBy[adaptedFootprintInformation, Lookup[#,IncubationTime]&];
    groupedTalliedAdaptedFootprintInformation=(Sequence@@Tally[Lookup[#,LiquidHandlerAdapter]]&)/@groupedAdaptedFootprintInformation;

    (* Tally up the adapted footprints, taking into account which adapters they're in. *)
    (* NOTE: Here we're assuming that liquid handler adapters can only hold vessels of the same footprint, aka, we're doing *)
    (* Length[Lookup[liquidHandlerAdapterPacket, Positions]] which might be an invalid assumption in the future. *)
    convertedAdaptedFootprints=If[Length[adaptedFootprintInformation]>0,
      MapThread[
        Function[{liquidHandlerAdapter, count},
          Module[{liquidHandlerAdapterPacket},
            (* Get the packet of liquid handler adapter. *)
            liquidHandlerAdapterPacket=fetchPacketFromCache[liquidHandlerAdapter, liquidHandlerCompatibleRackPackets];

            Sequence@@ConstantArray[
              Lookup[liquidHandlerAdapterPacket, Footprint],
              Ceiling[count/Length[Lookup[liquidHandlerAdapterPacket, Positions]]]
            ]
          ]
        ],
        Transpose[groupedTalliedAdaptedFootprintInformation]
      ],
      {}
    ];

    Tally[Join[Lookup[nonAdaptedFootprintInformation,Footprint,{}], convertedAdaptedFootprints]]
  ];

  (* Keep track of primitives that we have a problem resolving. *)
  invalidResolverPrimitives={};

  (* Keep track of which primitives resulted in failed workcell selection *)
  incompatibleWorkCellAndMethod={};

  (* Keep track of which primitives resulted in a non-CellPreparation method despite the presence of cells. *)
  roboticCellPreparationRequired={};

  (* Create a variable to keep track of our FRQ tests, if we have any. *)
  frqTests={};

  (* create a variable to compile together all the resources we need to call FRQ on at the end of the UOs, not between each one *)
  nonObjectResources={};

  (* Keep track of if our primitives have unfulfillable resources. *)
  fulfillableQ=True;

  (* Keep track of any output unit operation objects that we retrieved from our resolver cache. If we're trying to upload *)
  (* this protocol, then we will need to change the object IDs since we don't want to point to previously used object IDs. *)
  outputUnitOperationObjectsFromCache={};

  (* Remove our message cell. *)
  If[MatchQ[$ECLApplication, CommandCenter|Mathematica],
    NotebookDelete[simulationPreparationMessageCell];
  ];
  (* Before we start our MapThread, create a new unique label session. *)
  (* NOTE: This session helper function will enable the proper functioning of CreateUniqueLabel[...] inside of our *)
  (* resolver functions. It also supports nested sessions (ExperimentSP called inside of ExperimentSP). *)
  (* In cases where a unit operation uses other unit ops inside it (Ex. MBS creates Transfer unit ops) we don't want to *)
  (* reset the label session because then duplicate labels will be created *)
  If[!unitOperationPacketsQ,
    StartUniqueLabelsSession[];
  ];

  (* make sure that the Label* primitives have a matching method to the next primitive after them *)
  optimizedPrimitivesWithMethods = Module[
    {primitiveHeads,labelPositions,otherPrimitivePositions,labelPrimitiveReplacementRules},

    primitiveHeads = Head/@optimizedPrimitives;
    labelPositions = Flatten@Position[primitiveHeads,LabelContainer|LabelSample];
    (* if we don't have Label* primitives - return early *)
    If[Length[labelPositions]==0, Return[optimizedPrimitives,Module]];

    otherPrimitivePositions = Complement[Range[Length[primitiveHeads]],labelPositions];
    (* if we don't have any other primitives - return early *)
    If[Length[otherPrimitivePositions]==0, Return[optimizedPrimitives,Module]];

    labelPrimitiveReplacementRules = Map[Function[{position},Module[{currentPrimitive,currentMethod,nextPrimitiveMethod,nextPrimitivePosition,nextPrimitive},
      currentPrimitive = optimizedPrimitives[[position]];
      currentMethod = ToList@Lookup[currentPrimitive[[1]],PrimitiveMethod];

      (* if this Label* primitive can have only 1 method, return as it is *)
      If[Length[currentMethod]==1,
        Return[position->currentPrimitive,Module]
      ];

      (* if we have LabelSample as a last primitive, merge it into the previous UO instead *)
      nextPrimitivePosition = If[position==Length[optimizedPrimitives],
        Last[otherPrimitivePositions],
        FirstCase[otherPrimitivePositions,GreaterP[position]]
        ];
      nextPrimitive = optimizedPrimitives[[nextPrimitivePosition]];
      (* NOTE: from my current understanding, only Label* primitives can have more than 1 PrimitiveMethod, so this should always have a list of 1 here *)
      nextPrimitiveMethod = Lookup[nextPrimitive[[1]],PrimitiveMethod];
      (* Reconstruct the primitive *)
      position -> Head[currentPrimitive][Append[currentPrimitive[[1]],PrimitiveMethod->nextPrimitiveMethod]]
    ]],labelPositions];

    ReplacePart[optimizedPrimitives,labelPrimitiveReplacementRules]
  ];

  (* Copy over our list of optimized primitives. We will automatically insert Cover primitives into this list if we *)
  (* 1) are robotic and detect that a container that has KeepCovered->True was manipulated *)
  (* 2) are at the end of a robotic grouping, detect that there are uncovered containers at the end of the grouping, and CoverAtEnd->True. *)
  (* In order to do any cover optimization, OptimizeUnitOperations must be True. *)
  coverOptimizedPrimitives=optimizedPrimitivesWithMethods;

  (* Initialize our list of resolved primitives. *)
  resolvedPrimitives={};

  (* Record the date we are starting the primitive resolving *)
  currentPrimitiveGroupingDateStarted=Now;
  currentPrimitiveDateStarted=Now;

  (* Resolve our primitives! *)
  While[index<=Length[coverOptimizedPrimitives],
    Module[
      {primitive,primitiveInformation, primitiveOptionDefinitions, primaryInputOption, primitiveOptionsWithResolvedPrimaryInput,
        allPrimitiveOptionsWithSimulatedObjects, inputsFromPrimitiveOptions, optionsFromPrimitiveOptions, resolvedPrimitiveMethod,
        resolverFunction, resolvedOptions, newSimulation, resolverTests, simulatedObjectsToLabel, unitOperationPacketsMinusOptions,
        resolvedOptionsWithPrimitiveOptionsOnly, resolvedPrimitive, primitiveMethodIndex, unitOperationPacketsRaw, unitOperationPackets,batchedUnitOperationPackets,
        resolvedOptionsWithNoSimulatedObjects, newLabelFieldKeys, runTimeEstimate, resolverErrorQ, messagesThrown,
        primitiveResolvingMessageCell, resolvedWorkCell, previousWorkCells, previousPrimitiveToWorkCellLookup, requestedInstrument, newSimulationWithoutOverwrittenLabels,
        primaryInputOptionDefinition, safeResolverOptions, newLabelFields, inputsWithNoSimulatedObjects,
        optionsWithNoSimulatedObjects, prePrimitiveFunctionCallMessageLength, usedResolverCacheQ, delayedMessagesFalseMessagesBool, savedDelayedMessagesFalseMessagesBool,
        emptyContainerFailureQ, hardResolverFailureQ, inputsFromPrimitiveOptionsWithExpandedTransfers,
        optionsFromPrimitiveOptionsWithExpandedTransfers, emptyWellFailureQ, nonExistedWellFailureQ, preparation,
        inputFromPrimitiveOptionsWithRearrangedTransfers, optionsFromPrimitiveOptionsWithRearrangedTransfers,
        downloadInformation,fastCacheBall, optionsWithNoSimulatedObjectsIndexMatchingToSample, startNewPrimitiveGroupingQ,
        preparativeReplicatesQ,numberOfPreparativeReplicates, resolvedCorrectedOptions, expandedInputs},

      (* Get our current primitive. *)
      primitive=coverOptimizedPrimitives[[index]];

      currentPrimitiveDateStarted=Now;

      (* Lookup information about our primitive. *)
      primitiveInformation=Lookup[allPrimitiveInformation, Head[primitive]];
      primitiveOptionDefinitions=Lookup[primitiveInformation, OptionDefinition];

      (* Tell the user that we're about to resolve our primitive. *)
      primitiveResolvingMessageCell=If[MatchQ[$ECLApplication, CommandCenter|Mathematica],
        PrintTemporary[
          Row[{
            Lookup[primitiveInformation, Icon],
            Spacer[10],
            "Calculating Options for "<>ToString[Head[primitive]]<>" Unit Operation ("<>ToString[index]<>"/"<>ToString[Length[coverOptimizedPrimitives]]<>")",
            If[Not[$CloudEvaluation], ProgressIndicator[Appearance->"Percolate"], Nothing]
          }]
        ]
      ];

      (* -- Finish Autofilling the Primary Input, if necessary -- *)
      (* We previously tried to autofill all primary input keys for our primitives during stage 2, but we may not have been *)
      (* able to if the primitive before us was a generative primitive. If that was the case, autofill it now. *)
      (* NOTE: This implies that all generative primitives MUST give us a label for the SamplesOut that they generate *)
      (* because this is the only way that we will be able to autofill the next primitive. *)
      primaryInputOption=FirstOrDefault[Lookup[primitiveInformation, InputOptions]];
      primaryInputOptionDefinition=FirstCase[primitiveOptionDefinitions,KeyValuePattern["OptionSymbol"->primaryInputOption],Null];

      (* Make sure that we actually have a primary input option and if we do, see if it's specified. *)
      (* NOTE: We are assuming that the primary input option is either ENTIRELY automatic or is specified. *)
      primitiveOptionsWithResolvedPrimaryInput=If[MatchQ[primaryInputOption, Null] || MatchQ[Lookup[primitive[[1]], primaryInputOption, Automatic], Except[Automatic]],
        primitive[[1]],
        (* If we are actually the first primitive, we have to throw an error here since we can't resolve the input key for the first primitive. *)
        If[MatchQ[index, 1],
          AppendTo[invalidAutofillPrimitivesWithIndices, {primitive, index}];

          (* NOTE: Since we're using the singleton fakeWaterSample here, it should expand to whatever length we need it to expand to. *)
          Append[
            primitive[[1]],
            primaryInputOption->fakeWaterSample
          ],
          (* Otherwise, autofill from the previous primitive. *)
          Module[{previousPrimitive, previousPrimitiveInformation, resolvedPrimaryInput},
            (* Get the previous primitive. *)
            previousPrimitive=If[Length[currentPrimitiveGrouping]==0,
              Last[Flatten[allPrimitiveGroupings]],
              Last[currentPrimitiveGrouping]
            ];

            (* Get the information for the previous primitive. *)
            previousPrimitiveInformation=Lookup[allPrimitiveInformation, Head[previousPrimitive]];

            (* Autofill our current primary input from our previous primitive. *)
            resolvedPrimaryInput=Which[
              (* Last primitive was generative. Get the label option of the generative output. *)
              (* NOTE: We only take _String here because sometimes the label can intentionally be set to Null. We also *)
              (* flatten in the case of pooled labels (ex. WashCells). *)
              And[
                MatchQ[Lookup[previousPrimitiveInformation, Generative], True],
                MatchQ[{"Test String"}, ReleaseHold[Lookup[primaryInputOptionDefinition,"Pattern"]]]
              ],
                Cases[Flatten@ToList@Lookup[previousPrimitive[[1]], Lookup[previousPrimitiveInformation, GenerativeLabelOption]], _String],

              (* Last primitive had an AliquotSampleLabel Option and it isn't completely Null. *)
              (* NOTE: Here we are assuming that 1) the only time that the input is going to change containers, without *)
              (* the primitive being generative, is due to an aliquot and 2) if there is an aliquot, the resulting samples *)
              (* will always be given a label under the AliquotSampleLabel option. *)
              And[
                KeyExistsQ[previousPrimitive[[1]], AliquotSampleLabel],
                !MatchQ[Lookup[previousPrimitive[[1]], AliquotSampleLabel], ListableP[Null]],
                MatchQ[{"Test String"}, ReleaseHold[Lookup[primaryInputOptionDefinition,"Pattern"]]]
              ],
                Module[{primaryInput, aliquotSampleLabels},
                  (* Do we have a primary input option as well? *)
                  primaryInput=If[!MatchQ[FirstOrDefault[Lookup[primitiveInformation, InputOptions]], Null],
                    Lookup[previousPrimitive[[1]], FirstOrDefault[Lookup[primitiveInformation, InputOptions]]],
                    {}
                  ];

                  (* Get our aliquot label option. *)
                  aliquotSampleLabels=Lookup[previousPrimitive[[1]], AliquotSampleLabel];

                  (* Is our primary Input the same length as our aliquot label option? *)
                  Which[
                    (* Is our aliquot label option completely filled out? If so, then just use it. *)
                    !MemberQ[ToList[aliquotSampleLabels], Null],
                      ToList[aliquotSampleLabels],
                    (* Otherwise, this implies that our aliquot label option has some Nulls in it. *)
                    (* If our primary input option is the same length as our aliquot label option, then autofill from that. *)
                    (* NOTE: This SHOULD be the case unless we have a very weird situation going on. *)
                    Length[primaryInput]==Length[aliquotSampleLabels],
                      MapThread[
                        Function[{input, aliquotSampleLabel},
                          If[MatchQ[aliquotSampleLabel, Null],
                            input,
                            aliquotSampleLabel
                          ]
                        ],
                        {primaryInput, aliquotSampleLabels}
                      ],
                    (* Otherwise, just use the aliquot label option, but without Nulls. *)
                    True,
                      Cases[ToList[aliquotSampleLabels], Except[Null]]
                  ]
                ],

              (* Last primitive had primary input. Take that. *)
              And[
                !MatchQ[FirstOrDefault[Lookup[previousPrimitiveInformation, InputOptions]], Null],
                MatchQ[
                  Lookup[previousPrimitive[[1]], FirstOrDefault[Lookup[previousPrimitiveInformation, InputOptions]]],
                  ReleaseHold[Lookup[primaryInputOptionDefinition,"Pattern"]]
                ]
              ],
                Lookup[previousPrimitive[[1]], FirstOrDefault[Lookup[previousPrimitiveInformation, InputOptions]]],

              (* Don't know what to take! Use a water sample and report an error. *)
              True,
                Module[{},
                  AppendTo[invalidAutofillPrimitivesWithIndices, {primitive, index}];
                  fakeWaterSample
                ]
            ];

            (* Add our resolved primary input to our primitive. *)
            Append[
              primitive[[1]],
              primaryInputOption->resolvedPrimaryInput
            ]
          ]
        ]
      ];

      (* -- Call our Primitive Method Resolver Function -- *)
      (* For each option in our primitive, replace any labels with their respective objects. *)
      (* If we find an invalid label (that hasn't been initialized yet), keep track of it. *)
      allPrimitiveOptionsWithSimulatedObjects=KeyValueMap[
        Function[{option, value},
          Module[{optionDefinition},
            (* Lookup information about this option. *)
            optionDefinition=FirstCase[primitiveOptionDefinitions,KeyValuePattern["OptionSymbol"->option],Null];

            (* Do does this option allow for PreparedSample or PreparedContainer? *)
            Which[
              MatchQ[optionDefinition, Null],
                (* We don't know about this option. *)
                Nothing,
              (* NOTE: We have to convert any associations (widgets automatically evaluate into associations) because *)
              (* Cases will only look inside of lists, not associations. *)
              Length[Cases[Lookup[optionDefinition, "Widget"]/.{w_Widget :> Normal[w[[1]]]}, (PreparedContainer->True)|(PreparedSample->True), Infinity]]==0,
                (* Nothing to replace. *)
                option->value,
              True,
                (* We may potentially have some labels. *)
                Module[{matchedWidgetInformation, objectWidgetsWithLabels, labelsInOption, unknownLabels, knownLabels, optionValueWithoutUnknownLabels},
                  (* Match the value of our option to the widget that we have. *)
                  (* NOTE: This is the same function that we use in the command builder to match values to widgets. *)
                  matchedWidgetInformation=AppHelpers`Private`matchValueToWidget[value,optionDefinition];

                  (* Look for matched object widgets that have labels. *)
                  (* NOTE: A little wonky here, all of the Data fields from the AppHelpers function gets returned as a string, so we need *)
                  (* to separate legit strings from objects that were turned into strings. *)
                  objectWidgetsWithLabels=Cases[matchedWidgetInformation, KeyValuePattern[{"Type" -> "Object", "Data" -> _?(!StringStartsQ[#, "Object["] && !StringStartsQ[#, "Model["]&)}], Infinity];

                  (* This will give us our labels. *)
                  (* Why are we doing this? If the user specifies a \" in their labels (unlikely, but not impossible, and certainly possible in code by developers), we mess up their UOs *)
                  labelsInOption=(StringReplace[#,"\""->""]&)/@Lookup[objectWidgetsWithLabels, "Data", {}];

                  (* Do we have labels that we don't know about? *)
                  unknownLabels=Complement[labelsInOption, Lookup[currentSimulation[[1]], Labels][[All,1]]];
                  knownLabels=Complement[labelsInOption, unknownLabels];

                  (* If we have unknown labels, replace those labels with fake water samples/containers. *)
                  optionValueWithoutUnknownLabels=If[Length[unknownLabels]>0,
                    AppendTo[invalidLabelPrimitivesWithIndices,{unknownLabels,index,primitive}];

                    value/.{(Alternatives@@unknownLabels)->fakeWaterSample},
                    value
                  ];

                  (* Replace any other labels that we have with their values from our simulation. *)
                  option-> (
                    optionValueWithoutUnknownLabels /. (#1 -> Lookup[Lookup[currentSimulation[[1]], Labels], #1]&) /@ knownLabels
                  )
                ]
            ]
          ]
        ],
        primitiveOptionsWithResolvedPrimaryInput
      ];

      (* Separate out our primitive options into inputs and function options. *)
      inputsFromPrimitiveOptions=(Lookup[allPrimitiveOptionsWithSimulatedObjects, #, Null]&)/@Lookup[primitiveInformation, InputOptions];
      optionsFromPrimitiveOptions=Cases[
        allPrimitiveOptionsWithSimulatedObjects,
        Verbatim[Rule][
          Except[Alternatives[PrimitiveMethod, PrimitiveMethodIndex, WorkCell, (Sequence@@Lookup[primitiveInformation, InputOptions])]],
          _
        ]
      ];

      (* Download some necessary information for transfer splitting and rearranging. Need to do this after every primitive resolving, based on the most recent simulation *)
      (* Get the containers and destinations of any samples that we have. *)
      downloadInformation=If[
        And[
          MatchQ[primitive,_Transfer],
          !MatchQ[Lookup[primitive[[1]], PrimitiveMethod, Automatic], ListableP[ManualPrimitiveMethodsP]],
          MatchQ[previewFinalizedUnitOperations, True]
        ],
        (* Only do Download if we need to since this information is only needed in Transfer splitting and expansion *)
        Quiet[
          Download[
            {
              Cases[Flatten[Values[allPrimitiveOptionsWithSimulatedObjects]], ObjectP[Object[Sample]]],
              Cases[Flatten[Values[allPrimitiveOptionsWithSimulatedObjects]], ObjectP[Object[Container]]],
              Cases[Flatten[Values[allPrimitiveOptionsWithSimulatedObjects]], ObjectP[Model[Container]]]
            },
            {
              {
                Packet[Container, Position, NumberOfWells, Model, Ventilated, Volume],
                Packet[Model[Ventilated]],
                Packet[Container[Model]],
                Packet[Container[Model][NumberOfWells]]
              },
              {
                Packet[Contents[[All, 2]][{Ventilated, Position, Container, Volume}]],
                Packet[Contents[[All, 2]][Model][{Ventilated}]],
                Packet[Model,Contents],
                Packet[Model[{NumberOfWells,Positions}]]
              },
              {
                Packet[NumberOfWells,Positions]
              }
            },
            Simulation->currentSimulation,
            Cache->cacheBall
          ],
          {Download::FieldDoesntExist, Download::NotLinkField}
        ],
        {{},{},{}}
      ];
      fastCacheBall = makeFastAssocFromCache[Cases[Flatten[downloadInformation], _Association]];
      allContainerContentsPackets=Flatten[downloadInformation[[2,All,1]]];
      allSamplePackets=Flatten[downloadInformation[[1,All,1]]];
      allContainerModelPackets=DeleteDuplicates@Flatten[{downloadInformation[[2,All,4]],downloadInformation[[3]]}];
      containerModelToPosition=Map[
        Lookup[#,Object]->Lookup[Lookup[#,Positions],Name]&,
        allContainerModelPackets
      ];
      allContainerPackets=DeleteDuplicates@Flatten[downloadInformation[[2,All,3]]];

      (* Track the counter of "transfer destination sample" because we may need to create some labels below for split transfers before calling ExperimentTransfer. However, we may not end up using these if we end up resolving to Manual *)
      transferDestinationSampleLabelCounter=Lookup[Constellation`Private`$UniqueLabelLookup,"transfer destination sample",0];

      (* NOTE: Not all inputs are required (ex. PCR). If we don't find the input, pass down Automatic. *)
      (* NOTE: If we have a Transfer primitive and we're transferring less than 450mL in this primitive (the maximum *)
      (* amount to transfer robotically in a single primitive) or if the user has specified to perform this primitive *)
      (* robotically, we have to expand any transfers more than 970 Microliter into multiple transfers. *)
      (* NOTE: We use this when resolving the primitive method to see if we should be robotic. *)
      {inputsFromPrimitiveOptionsWithExpandedTransfers, optionsFromPrimitiveOptionsWithExpandedTransfers}=If[And[
          MatchQ[primitive,_Transfer],
          MatchQ[Total[Append[Cases[Lookup[allPrimitiveOptionsWithSimulatedObjects, Amount], VolumeP],0Milliliter]], LessEqualP[450 Milliliter]],
          MemberQ[Lookup[allPrimitiveOptionsWithSimulatedObjects, Amount], (GreaterP[970 Microliter]|All)],
          !MatchQ[Lookup[primitive[[1]], PrimitiveMethod, Automatic], ListableP[ManualPrimitiveMethodsP]],
          MatchQ[previewFinalizedUnitOperations, True]
        ],
        Module[{allDestinations,allDestinationWells,allTransferAmounts,convertedTransferAmounts, largeVolumePositions, volumesToReplace, currentModelContainerInteger, expandedSources, expandedDestinations, expandedAmounts, expandedDestinationLabels, expandedOptions, allPreviousTransfers, containerObjectToUsedPositions},

          (* Get the destination information to help us decide the amount for All transfer *)
          allDestinations=Lookup[allPrimitiveOptionsWithSimulatedObjects,Destination]/.{object:LinkP[]:>Download[object,Object]};
          allDestinationWells=Lookup[
            allPrimitiveOptionsWithSimulatedObjects,
            DestinationWell,
            ConstantArray[Automatic,Length[Lookup[allPrimitiveOptionsWithSimulatedObjects, Source]]]
          ];
          allTransferAmounts=Lookup[allPrimitiveOptionsWithSimulatedObjects, Amount];
          (* Initialize previous transfer tracking for each transfer in this UO *)
          allPreviousTransfers={};
          (* Create a temporary map of simulated container ID to used positions. This is to help us resolve DestinationWell. *)
          (* We have to do this here because we don't actually know what wells are going to be used until time of transfer in the MapThread so this is cheating a bit. *)
          (* This is the same logic as in ExperimentTransfer *)
          containerObjectToUsedPositions=Association[Map[
            If[MatchQ[Lookup[#, Contents, {}],$Failed|{}],
              Lookup[#, Object] -> {},
              Lookup[#, Object] -> Lookup[#, Contents][[All,1]]
            ]&,
            allContainerPackets
          ]];

          (* Convert the All amount transfers to volume transfers *)
          convertedTransferAmounts=MapThread[
            Function[
              {source,sourceWell,amount,destination,destinationWell,transferIndex},
              Module[
                {sourceContainerObject,sourceSampleObject,sourceSamplePacket,resolvedSourceWell,destinationSampleObject,destinationSamplePacket,destinationContainerObject,destinationContainerModel,resolvedDestinationWell,defaultWaterModelVolume,defaultModelVolume,previousTransfersInAmounts,previousTransfersOutAmounts,totalTransferredInAmount,totalTransferredOutAmount,totalTransferredAmount,finalAmount},

                (* Get the sample object *)
                sourceSampleObject=If[MatchQ[source, ObjectP[Object[Sample]]],
                  Download[source,Object],
                  Null
                ];

                sourceSamplePacket=fetchPacketFromFastAssoc[sourceSampleObject, fastCacheBall];

                (* Get the container object. Set to the sample's container if it is a sample *)
                sourceContainerObject=Which[
                  MatchQ[source, {_, ObjectP[Object[Container]]}],
                    Download[source[[2]],Object],
                  MatchQ[source,ObjectP[Object[Container]]],
                    Download[source,Object],
                  !NullQ[sourceSamplePacket],
                    Download[Lookup[sourceSamplePacket,Container],Object],
                  (* If we have an indexed container, make sure to keep it so we can recognize the same container later. *)
                  MatchQ[source, {_Integer, ObjectP[Model[Container]]}],
                    {source[[1]],Download[source[[2]],Object]},
                  True,
                    Null
                ];

                (* Resolve the source well option, using the same logic from ExperimentTransfer, so that we can decide the exact sample to change All amount to amount *)
                (* NOTE: If you want to change this, please also change ExperimentTransfer. Resolving source well shows up in multiple branches in ExperimentTransfer. *)
                resolvedSourceWell=Which[
                  (* Did the user give us an option? *)
                  MatchQ[sourceWell, Except[Automatic]],
                    sourceWell,
                  !NullQ[sourceSamplePacket],
                    Lookup[sourceSamplePacket,Position],
                  (* We do not care about source well if we are dealing with a sample model since we won't be able to transfer into it *)
                  MatchQ[source,ObjectP[Model[Sample]]],
                    Null,
                  (* Were we given {_String, ObjectP[Object[Container]]} as input? *)
                  MatchQ[source, {_String, ObjectP[Object[Container]]}],
                    source[[1]],
                  (* Do we have a sample in this container that is non-empty? *)
                  (* The sample must be liquid to be transferred robotically so we only need to consider volume here *)
                  MatchQ[source,ObjectP[Object[Container]]]&&MatchQ[FirstCase[allContainerContentsPackets, KeyValuePattern[{Container->ObjectP[sourceContainerObject], Volume -> GreaterP[0 Liter]}], Null], PacketP[]],
                    Lookup[FirstCase[allContainerContentsPackets, KeyValuePattern[{Container->ObjectP[sourceContainerObject], Volume -> GreaterP[0 Liter]}], Null], Position],
                  (* Do we have a destination transfer into this container later? If so, take the destination well of that. *)
                  MatchQ[FirstCase[Transpose[{allDestinations, allDestinationWells}], {ObjectP[sourceContainerObject], position_String}:>position], _String],
                    FirstCase[Transpose[{allDestinations, allDestinationWells}], {ObjectP[sourceContainerObject], position_String}:>position],
                  (* Give up and use "A1". *)
                  True,
                    "A1"
                ];

                (* Get the sample object *)
                destinationSampleObject=If[MatchQ[destination, ObjectP[Object[Sample]]],
                  Download[destination,Object],
                  Null
                ];

                destinationSamplePacket=fetchPacketFromFastAssoc[destinationSampleObject, fastCacheBall];

                (* Resolve the destination *)
                destinationContainerObject=Which[
                  MatchQ[destination, {_, ObjectP[Object[Container]]}],
                    Download[destination[[2]],Object],
                  MatchQ[destination,ObjectP[Object[Container]]],
                    Download[destination,Object],
                  !NullQ[destinationSamplePacket],
                    Download[Lookup[destinationSamplePacket,Container],Object],
                  (* If we have an indexed container, make sure to keep it so we can recognize the same container later. *)
                  MatchQ[destination, {_Integer, ObjectP[Model[Container]]}],
                    {destination[[1]],Download[destination[[2]],Object]},
                  (* We do not care about destination container if it is a pure model since we will treat it as a new container every time *)
                  True,
                    Null
                ];
                (* Get the destination's model packet *)
                destinationContainerModel=Which[
                  MatchQ[destinationContainerObject,ObjectP[Object[Container]]],
                    Download[Lookup[fetchPacketFromFastAssoc[destinationContainerObject,fastCacheBall],Model],Object],
                  MatchQ[destinationContainerObject,{_,ObjectP[Model[Container]]}],
                    destinationContainerObject[[2]],
                  True,
                    Null
                ];
                (* Resolve the destination well option, using the same logic from ExperimentTransfer, so that we can look at the sample transfer history correctly *)
                (* NOTE: If you want to change this, please also change ExperimentTransfer. Resolving destination well shows up in multiple branches in ExperimentTransfer. *)
                resolvedDestinationWell=Which[
                  MatchQ[destinationWell, Except[Automatic]],
                    destinationWell,
                  !NullQ[destinationSamplePacket],
                    Lookup[destinationSamplePacket,Position],
                  (* Well/Container *)
                  MatchQ[destination, {_String, ObjectP[Object[Container]]}],
                    destination[[1]],
                  (* Container object - Find first empty position *)
                  MatchQ[destination,ObjectP[Object[Container]]],
                    Module[{emptyPositions},
                      (* Try to get the empty positions of this container. *)
                      emptyPositions=UnsortedComplement[
                        Lookup[containerModelToPosition,destinationContainerModel],
                        (* Used position in container before *)
                        Lookup[containerObjectToUsedPositions,destinationContainerObject,{}],
                        (* Destination of previous transfers *)
                        Cases[allPreviousTransfers,{_,_,destinationContainerObject,_,_}][[All,4]]
                      ];
                      FirstOrDefault[emptyPositions, "A1"]
                    ],
                  (* Container model with index - Find first empty position *)
                  MatchQ[destination,{_Integer, ObjectP[Model[Container]]}],
                    Module[{emptyPositions},
                      (* Try to get the empty positions of this container. *)
                      emptyPositions=UnsortedComplement[
                        Lookup[containerModelToPosition,destinationContainerModel],
                        (* Used position in container before *)
                        Lookup[containerObjectToUsedPositions,destinationContainerObject,{}],
                        (* Destination of previous transfers *)
                        Cases[allPreviousTransfers,{_,_,destinationContainerObject,_,_}][[All,4]]
                      ];
                      FirstOrDefault[emptyPositions, "A1"]
                    ],
                  True,
                    "A1"
                ];
                (* By default, we request 1.5 mL resource for Model[Sample,"Milli-Q water"] in Transfer resolution, if no Amount is provided *)
                defaultWaterModelVolume=$MicroWaterMaximum;
                (* By default, we request 1mL resource for Model[Sample] (except water) in Transfer resolution, if no Amount is provided *)
                defaultModelVolume=1Milliliter;
                (* Check if we have transferred any sample into the destination well BEFORE this transfer  *)
                (* Get the transfers that have gone into this position/sample earlier and get the list of the transfer amounts *)
                previousTransfersInAmounts=Cases[
                  allPreviousTransfers,
                  {_,_,sourceContainerObject,resolvedSourceWell,amount:VolumeP}:>amount
                ];
                previousTransfersOutAmounts=Cases[
                  allPreviousTransfers,
                  {sourceContainerObject,resolvedSourceWell,_,_,amount:VolumeP}:>amount
                ];

                (* Get the total amount of samples. If there is no sample, set to 0 *)
                totalTransferredInAmount=If[MatchQ[previousTransfersInAmounts,{}],
                  0Milliliter,
                  Total[previousTransfersInAmounts]
                ];
                totalTransferredOutAmount=If[MatchQ[previousTransfersOutAmounts,{}],
                  0Milliliter,
                  Total[previousTransfersOutAmounts]
                ];

                totalTransferredAmount=totalTransferredInAmount-totalTransferredOutAmount;

                (* Get the sample volume to replace All *)
                finalAmount=Which[
                  (* Keep the amount if it is not All *)
                  !MatchQ[amount,All],
                    amount,
                  MatchQ[source,ObjectP[Object[Sample]]],
                    (* Old sample volume + any transfer into the sample *)
                    Max[Lookup[sourceSamplePacket, Volume, defaultModelVolume]+totalTransferredAmount,0Milliliter],
                  (* For model sample, default to their resource fulfillment volume *)
                  MatchQ[source,ObjectP[Model[Sample,"id:8qZ1VWNmdLBD"]]],
                    defaultWaterModelVolume,
                  MatchQ[source,ObjectP[Model[Sample]]],
                    defaultModelVolume,
                  (* Container. Find the existing sample volume and add the transfer volume *)
                  (* If none available, safely set to the default volume *)
                  MatchQ[source,{_String, ObjectP[Object[Container]]}|ObjectP[Object[Container]]],
                    Max[
                      Total[{
                        Lookup[FirstCase[allContainerContentsPackets, KeyValuePattern[{Container -> ObjectP[sourceContainerObject], Position -> resolvedSourceWell}], <||>], Volume, 0Milliliter],
                        totalTransferredAmount
                      }],
                      0Milliliter
                    ]/.{amount:EqualP[0Milliliter]:>defaultModelVolume},
                  (* Index model container. Use the transfer volume *)
                  (* If none available, safely set to the default volume *)
                  MatchQ[source,{_, ObjectP[Model[Container]]}],
                    Max[totalTransferredAmount,0Milliliter]/.{amount:EqualP[0Milliliter]:>defaultModelVolume},
                  True,
                    defaultModelVolume
                ];
                (* Record this transfer *)
                AppendTo[allPreviousTransfers,{sourceContainerObject,resolvedSourceWell,destinationContainerObject,resolvedDestinationWell,finalAmount}];
                finalAmount
              ]
            ],
            {
              Lookup[allPrimitiveOptionsWithSimulatedObjects, Source],
              (* SourceWell *)
              Lookup[
                allPrimitiveOptionsWithSimulatedObjects,
                SourceWell,
                ConstantArray[Automatic,Length[Lookup[allPrimitiveOptionsWithSimulatedObjects, Source]]]
              ],
              allTransferAmounts,
              allDestinations,
              allDestinationWells,
              Range[Length[Lookup[allPrimitiveOptionsWithSimulatedObjects, Source]]]
            }
          ];

          (* Get all positions in which we have an amount greater than 970 Microliter. *)
          largeVolumePositions=Position[convertedTransferAmounts, GreaterP[970 Microliter]];

          (* Get the volumes that should replace these large volumes. *)
          (* This step is to split any transfer over 970 uL into multiple transfers. This logic here matches the logic in splitTransfersBy970  *)
          (* here we are splitting the transfer evenly rather than in 970 increments.  This is because if we want to transfer 970.5 uL, we don't want to transfer 970 uL then 0.5 uL.  We want to do 970.5 uL / 2. This can avoid doing an invalid transfer - < 1 uL transfer is invalid and also can improve the inaccuracy of each individual transfer *)
          (* the way this happens is a little goofy; basically take the total amount to transfer, and divide it by the quotient + 1 (if there is a remainder); if there is no remainder, just do it in 970 increments directly *)
          volumesToReplace=Map[
            Module[
              {quotient,mod},
              mod=Mod[#, 970 Microliter];
              quotient=Quotient[#, 970 Microliter];
              If[MatchQ[mod,0Microliter],
                ConstantArray[970Microliter, quotient],
                ConstantArray[RoundOptionPrecision[#/(quotient+1), 10^-1 Microliter, Round -> Down, AvoidZero -> True], (quotient+1)]
              ]
            ]&,
            Extract[convertedTransferAmounts, largeVolumePositions]
          ];

          (* Keep track of an integer to make Model[Container]s distinct when we expand them. *)
          currentModelContainerInteger=Max[
            Append[
              Cases[Flatten[Lookup[allPrimitiveOptionsWithSimulatedObjects, {Source, Destination}]], _Integer],
              1
            ]
          ];

          (* Expand the source/destination inputs and options. *)
          expandedSources=ReplacePart[
            Lookup[allPrimitiveOptionsWithSimulatedObjects, Source],
            MapThread[
              Function[{position, volumeList},
                If[MatchQ[Extract[Lookup[allPrimitiveOptionsWithSimulatedObjects, Source], position], ObjectP[Model[Container]]],
                  Module[{returnValue},
                    returnValue=position->Sequence@@ConstantArray[
                      {currentModelContainerInteger, Extract[Lookup[allPrimitiveOptionsWithSimulatedObjects, Source], position]},
                      Length[volumeList]
                    ];

                    currentModelContainerInteger=currentModelContainerInteger+1;

                    returnValue
                  ],
                  position->Sequence@@ConstantArray[
                    Extract[Lookup[allPrimitiveOptionsWithSimulatedObjects, Source], position],
                    Length[volumeList]
                  ]
                ]
              ],
              {largeVolumePositions, volumesToReplace}
            ]
          ];

          expandedDestinations=ReplacePart[
            Lookup[allPrimitiveOptionsWithSimulatedObjects, Destination],
            MapThread[
              Function[{position, volumeList},
                If[MatchQ[Extract[Lookup[allPrimitiveOptionsWithSimulatedObjects, Destination], position], ObjectP[Model[Container]]],
                  Module[{returnValue},
                    returnValue=position->Sequence@@ConstantArray[
                      {currentModelContainerInteger, Extract[Lookup[allPrimitiveOptionsWithSimulatedObjects, Destination], position]},
                      Length[volumeList]
                    ];

                    currentModelContainerInteger=currentModelContainerInteger+1;

                    returnValue
                  ],
                  position->Sequence@@ConstantArray[
                    Extract[Lookup[allPrimitiveOptionsWithSimulatedObjects, Destination], position],
                    Length[volumeList]
                  ]
                ]
              ],
              {largeVolumePositions, volumesToReplace}
            ]
          ];

          expandedAmounts=ReplacePart[
            convertedTransferAmounts,
            MapThread[
              Function[{position, volumeList},
                position->Sequence@@volumeList
              ],
              {largeVolumePositions, volumesToReplace}
            ]
          ];

          (* When we expand the volumes, we also need to make sure our destinations are kept the same. *)
          (* This is not an issue for a normal transfer with a set destination but can be a problem if our destination is a container and we are looking for the first non-empty position *)
          (* We do this by feeding the same DestinationLabel to transfer if not set *)
          expandedDestinationLabels=Module[
            {suppliedDestinationLabels,destinationLabelReplacementRules},
            suppliedDestinationLabels=Lookup[allPrimitiveOptionsWithSimulatedObjects,DestinationLabel,ConstantArray[Automatic,Length[Lookup[allPrimitiveOptionsWithSimulatedObjects, Source]]]];
            destinationLabelReplacementRules=MapThread[
              If[MatchQ[suppliedDestinationLabels[[#1[[1]]]],_String],
                (* If there is already a label provided by the user, expand it (this is the same as other options) *)
                #1->Sequence@@ConstantArray[suppliedDestinationLabels[[#1[[1]]]],Length[#2]],
                (* If there is no existing label, create a unique label for "robotic transfer destination sample" *)
                (* We distinguish this from "transfer destination sample" used in Transfer because we want to make sure our labels are resolved in the same way even if grouping of primitives changes due to special reasons, like in a rare case that the "full deck" definition of liquid handler has to change. *)
                (* For example: consider two Transfer UOs. Transfer[xxx (no need for splitting)] and Transfer[xxx (split required)]. If we don't optimize the UOs (do not combine them), the first Transfer would have "transfer destination sample 1" as label (created in Transfer) and second has "transfer destination sample 2" as the label (created here). However, if we combine them with optimization, the order would change. *)
                (* This is very important when we have PreparatoryUnitOperations in a protocol. When the protocol call is first run, we resolve the labels and populate PreparedSamples field with the labels. Then when we really call ExperimentSamplePreparation in procedure, the same labels must be resolved so we run the correct samples *)
                (* Note that this may cause multiple labels to be created for the sample destination sample since we are not resolving destination well and container here. However, that is not a problem in our labeling system *)
                #1->Sequence@@ConstantArray[CreateUniqueLabel["robotic transfer destination sample"],Length[#2]]
              ]&,
              {
                largeVolumePositions,
                volumesToReplace
              }
            ];
            ReplacePart[suppliedDestinationLabels,destinationLabelReplacementRules]
          ];

          expandedOptions=Module[{primitiveOptionDefinitions, indexMatchingOptionSymbols, indexMatchingOptions, nonIndexMatchingOptions, expandedIndexMatchingOptions},
            (* Get the option definition. *)
            primitiveOptionDefinitions=Lookup[primitiveInformation, OptionDefinition];

            (* Get the index matching options. *)
            indexMatchingOptionSymbols=Lookup[
              DeleteDuplicates@Cases[primitiveOptionDefinitions,
                Alternatives[
                  KeyValuePattern[{"IndexMatchingParent"->Except[Null]}],
                  KeyValuePattern[{"IndexMatchingInput"->Except[Null]}]
                  ]
                ],
              "OptionSymbol"
            ];
            indexMatchingOptions=Cases[
              optionsFromPrimitiveOptions,
              Verbatim[Rule][
                Alternatives@@indexMatchingOptionSymbols,
                _
              ]
            ];
            nonIndexMatchingOptions=Complement[
              optionsFromPrimitiveOptions,
              indexMatchingOptions
            ];

            (* Expand the index matching options. *)
            (* NOTE: We have to specify to only normalize the association here because there was a bug where Normal was converting *)
            (* options with AngularDegree to radians. *)
            expandedIndexMatchingOptions=Normal[
              KeyValueMap[
                Function[{key, option},
                  key->ReplacePart[
                    option,
                    MapThread[
                      Function[{position, volumeList},
                        position->Sequence@@ConstantArray[
                          Extract[option, position],
                          Length[volumeList]
                        ]
                      ],
                      {largeVolumePositions, volumesToReplace}
                    ]
                  ]
                ],
                Association[indexMatchingOptions]
              ],
              Association
            ];

            Join[ReplaceRule[expandedIndexMatchingOptions,DestinationLabel->expandedDestinationLabels], nonIndexMatchingOptions]
          ];

          {
            {
              expandedSources,
              expandedDestinations,
              expandedAmounts
            },
            expandedOptions
          }
        ],
        {inputsFromPrimitiveOptions, optionsFromPrimitiveOptions}
      ];

      (* If we have a Transfer primitive, detect transfers that are defined in row order instead of column order and *)
      (* rearrange them. *)
      (* Exclude the transfers specified as MultiProbeHead transfers since that is not necessary and can lead to problems *)
      (* For back-to-back MPH transfers, we may have combined multiple UOs into one UO as of now. They may have different volumes/pipetting parameters. If we rearrange in row instead of column, we may actually break the MPH MxN format *)
      {inputFromPrimitiveOptionsWithRearrangedTransfers, optionsFromPrimitiveOptionsWithRearrangedTransfers}=If[And[
          MatchQ[primitive,_Transfer],
          Length[inputsFromPrimitiveOptionsWithExpandedTransfers[[1]]]>1,
          !MatchQ[Lookup[primitive[[1]], PrimitiveMethod, Automatic], ListableP[ManualPrimitiveMethodsP]],
          MatchQ[optimizeUnitOperations, True],
          MatchQ[previewFinalizedUnitOperations, True]
        ],
        Module[
          {sourceWells, destinationWells, sourceContainers, destinationContainers, groupedTransfers, nonIndexMatchingOptionsForTransfer,
            transposed384WellNamesByColumn, idealWellOrder, reorderedIndices, groupedTransfersWithoutReusingDestinations},

          (* Get the source and destination wells that we're transferring from/to. *)
          sourceWells=MapThread[
            Function[{source, sourceWellOption},
              Which[
                (* If the source well option is set, use that. *)
                MatchQ[sourceWellOption, _String],
                  sourceWellOption,
                (* If we're given the source well in the input, use that. *)
                MatchQ[source, {_String, _}],
                  source[[1]],
                (* If we have a sample, lookup the position of the sample from the packet. *)
                MatchQ[source, ObjectP[Object[Sample]]],
                  Lookup[fetchPacketFromFastAssoc[source, fastCacheBall], Position],
                (* Otherwise, assume that we're going to aspirate from "A1". *)
                True,
                  "A1"
              ]
            ],
            {
              inputsFromPrimitiveOptionsWithExpandedTransfers[[1]],
              Lookup[
                optionsFromPrimitiveOptionsWithExpandedTransfers,
                SourceWell,
                ConstantArray[Automatic, Length[inputsFromPrimitiveOptionsWithExpandedTransfers[[1]]]]
              ]
            }
          ];

          destinationWells=MapThread[
            Function[{destination, destinationWellOption},
              Which[
                (* If the source well option is set, use that. *)
                MatchQ[destinationWellOption, _String],
                  destinationWellOption,
                (* If we're given the source well in the input, use that. *)
                MatchQ[destination, {_String, _}],
                  destination[[1]],
                (* If we have a sample, lookup the position of the sample from the packet. *)
                MatchQ[destination, ObjectP[Object[Sample]]],
                  Lookup[fetchPacketFromFastAssoc[destination, fastCacheBall], Position],
                (* Otherwise, assume that we're going to aspirate from "A1". *)
                True,
                  "A1"
              ]
            ],
            {
              inputsFromPrimitiveOptionsWithExpandedTransfers[[2]],
              Lookup[
                optionsFromPrimitiveOptionsWithExpandedTransfers,
                DestinationWell,
                ConstantArray[Automatic, Length[inputsFromPrimitiveOptionsWithExpandedTransfers[[2]]]]
              ]
            }
          ];

          (* Get the source containers/destination containers that we're transferring to/from. *)
          sourceContainers=Map[
            Function[{source},
              Which[
                MatchQ[source, ObjectP[Object[Sample]]],
                  Download[Lookup[fetchPacketFromFastAssoc[source, fastCacheBall], Container], Object],
                MatchQ[source, ObjectP[Object[Container]]],
                  source,
                MatchQ[source, {_, ObjectP[Object[Container]]}],
                  source[[2]],
                True,
                  source
              ]
            ],
            inputsFromPrimitiveOptionsWithExpandedTransfers[[1]]
          ];

          destinationContainers=Map[
            Function[{destination},
              Which[
                MatchQ[destination, ObjectP[Object[Sample]]],
                  Download[Lookup[fetchPacketFromFastAssoc[destination, fastCacheBall], Container], Object],
                MatchQ[destination, ObjectP[Object[Container]]],
                  destination,
                MatchQ[destination, {_, ObjectP[Object[Container]]}],
                  destination[[2]],
                True,
                  destination
              ]
            ],
            inputsFromPrimitiveOptionsWithExpandedTransfers[[2]]
          ];

          nonIndexMatchingOptionsForTransfer=Cases[OptionDefinition[ExperimentTransfer],KeyValuePattern["IndexMatching" -> "None"]][[All, "OptionSymbol"]];

          (* Split our transfers into groups of the same sources and destinations. *)
          (* NOTE: We also split by tip type here because we don't want to rearrange transfer order across different tip types *)
          (* if tip types have been specified. This is because we can mess up full plate stamps this way. Imagine the scenario where *)
          (* we have the following transfer destinations {"A1", "A1", ..., "H12"} with the tips {tip1, tip2, ..., tip2}. If we optimized *)
          (* across the group we would get {"A1", "A2", ..., "H12", "A1"} and would mess up our perfect plate stamp. *)
          (* We also want to avoid grouping MPH transfers with other transfers as we don't want to rearrange MPH transfers *)
          groupedTransfers=SplitBy[
            Transpose[{
              sourceContainers,
              destinationContainers,
              sourceWells,
              destinationWells,
              Transpose[inputsFromPrimitiveOptionsWithExpandedTransfers],
              If[MatchQ[Normal@KeyDrop[optionsFromPrimitiveOptionsWithExpandedTransfers,nonIndexMatchingOptionsForTransfer], {}],
                ConstantArray[{}, Length[sourceContainers]],
                (* Remove non index-matching options back so we don't expand them unexpectedly *)
                OptionsHandling`Private`mapThreadOptions[ExperimentTransfer, Normal@KeyDrop[optionsFromPrimitiveOptionsWithExpandedTransfers,nonIndexMatchingOptionsForTransfer]]
              ],
              Lookup[optionsFromPrimitiveOptionsWithExpandedTransfers, Tips, ConstantArray[Automatic, Length[sourceContainers]]],
              (* Treat any non MultiProbeHead transfers as Automatic for grouping purposes *)
              Replace[
                Lookup[optionsFromPrimitiveOptionsWithExpandedTransfers, DeviceChannel, ConstantArray[Automatic, Length[sourceContainers]]],
                {Except[MultiProbeHead]->Automatic},
                1
              ]
            }],
            ({#[[1]], #[[2]], #[[7]], #[[8]]}&)
          ];

          (* Split transfer groups further so that we don't use a destination sample in the group as a source (since this would result in an incorrect transfer). *)
          groupedTransfersWithoutReusingDestinations=Map[
            Function[{transferGroup},
              Module[{allTransferSubgroups, currentTransferSubgroup, currentTransferSubgroupDestinationContainerAndWells},
                allTransferSubgroups={};
                currentTransferSubgroup={};
                currentTransferSubgroupDestinationContainerAndWells={};

                Map[
                  Function[{transferTuple},
                    If[!MemberQ[currentTransferSubgroupDestinationContainerAndWells, {transferTuple[[1]], transferTuple[[3]]}],
                      Module[{},
                        AppendTo[currentTransferSubgroup, transferTuple];
                        AppendTo[currentTransferSubgroupDestinationContainerAndWells, {transferTuple[[2]], transferTuple[[4]]}];
                      ],
                      Module[{},
                        AppendTo[allTransferSubgroups, currentTransferSubgroup];

                        currentTransferSubgroup={};
                        currentTransferSubgroupDestinationContainerAndWells={};

                        AppendTo[currentTransferSubgroup, transferTuple];
                        AppendTo[currentTransferSubgroupDestinationContainerAndWells, {transferTuple[[2]], transferTuple[[4]]}];
                      ]
                    ]
                  ],
                  transferGroup
                ];

                If[Length[currentTransferSubgroup]>0,
                  AppendTo[allTransferSubgroups, currentTransferSubgroup]
                ];

                Sequence@@allTransferSubgroups
              ]
            ],
            groupedTransfers
          ];

          (* Assign the transposed 384-well plate well order to a variable since it's slow to compute *)
          transposed384WellNamesByColumn = Transpose[AllWells[NumberOfWells -> 384]];

          (* Define ideal well orders for common plate layouts *)
          idealWellOrder[96] = Flatten[Transpose[AllWells[]]];
          (* for 384-well plates we want to preserve "sub-plates" in the order and in the column order *)
          idealWellOrder[384] = Flatten[{Transpose@map384["A1"], Transpose@map384["B1"], Transpose@map384["A2"], Transpose@map384["B2"]}];
          (* For any other number of wells, use 96-well layout *)
          idealWellOrder[_] = idealWellOrder[96];

          (* For each transfer group, see if the source wells or destination wells are in row order instead of column order. *)
          (* If so, transpose the order. *)
          reorderedIndices=Map[
            Function[{transferGroup},
              (* If we only have one transfer in our group or this group is for MPH transfer, just return the index. *)
              If[(Length[transferGroup]==1)||MatchQ[transferGroup[[1,-1]],MultiProbeHead],
                transferGroup,
                Module[
                  {sourceContainer, destinationContainer, sourceIdealOrdering, destinationIdealOrdering, useSourceIdealOrderingQ,
                    idealOrderingToUse, wellToIndexLookup, wellToNumberOfTimesSeenLookup},

                  (* Get our source and destination container. *)
                  sourceContainer=First@First@transferGroup;
                  destinationContainer=(First@transferGroup)[[2]];

                  (* What's the ideal ordering for our source and destination containers. *)
                  sourceIdealOrdering=Which[
                    MatchQ[sourceContainer, ObjectP[Object[Container, Vessel]]],
                      ConstantArray["A1", Length[transferGroup]],
                    MatchQ[sourceContainer, ObjectP[Object[Container, Plate]]],
                      idealWellOrder[Lookup[fetchPacketFromFastAssoc[Lookup[fetchPacketFromFastAssoc[sourceContainer, fastCacheBall], Model], fastCacheBall], NumberOfWells]],
                    MatchQ[sourceContainer, ObjectP[Model[Container, Plate]]],
                      idealWellOrder[Lookup[fetchPacketFromFastAssoc[sourceContainer, fastCacheBall], NumberOfWells]],
                    MatchQ[sourceContainer, {_, ObjectP[Model[Container, Plate]]}],
                      idealWellOrder[Lookup[fetchPacketFromFastAssoc[sourceContainer[[2]], fastCacheBall], NumberOfWells]],
                    True,
                      idealWellOrder[96]
                  ];

                  destinationIdealOrdering=Which[
                    MatchQ[destinationContainer, ObjectP[Object[Container, Vessel]]],
                      ConstantArray["A1", Length[transferGroup]],
                    MatchQ[destinationContainer, ObjectP[Object[Container, Plate]]],
                      idealWellOrder[Lookup[fetchPacketFromFastAssoc[Lookup[fetchPacketFromFastAssoc[destinationContainer, fastCacheBall], Model], fastCacheBall], NumberOfWells]],
                    MatchQ[destinationContainer, ObjectP[Model[Container, Plate]]],
                      idealWellOrder[Lookup[fetchPacketFromFastAssoc[destinationContainer, fastCacheBall], NumberOfWells]],
                    MatchQ[destinationContainer, {_, ObjectP[Model[Container, Plate]]}],
                      idealWellOrder[Lookup[fetchPacketFromFastAssoc[destinationContainer[[2]], fastCacheBall], NumberOfWells]],
                    True,
                      idealWellOrder[96]
                  ];

                  (* Which ideal ordering should we use? *)
                  useSourceIdealOrderingQ=Length[LongestCommonSequence[transferGroup[[All,3]], sourceIdealOrdering]] >= Length[LongestCommonSequence[transferGroup[[All,4]], destinationIdealOrdering]];
                  idealOrderingToUse=If[useSourceIdealOrderingQ,
                    sourceIdealOrdering,
                    destinationIdealOrdering
                  ];

                  (* Create a lookup of well to index. *)
                  wellToIndexLookup=Rule@@@Transpose[{idealOrderingToUse, Range[Length[idealOrderingToUse]]}];

                  (* NOTE: If we're transferring into the same well multiple times, we want to try to go through the entire plate ordering first *)
                  (* before we transfer into that well again. The most common example of this is when we have to expand the volume that *)
                  (* the user gives us so the well ordering actually looks like {"A1", "A1", "A2", "A2" ..}. We want to transform this into *)
                  (* {"A1", "A2", ..., "A1", "A2", ...} aka two full plate stamps. *)

                  (* Create a lookup of the number of times we've seen the well in the ideal ordering. *)
                  wellToNumberOfTimesSeenLookup = <||>;

                  (* Create the reordering for our transfer group. *)
                  If[useSourceIdealOrderingQ,
                    SortBy[
                      transferGroup[[All,;;-2]],
                      Function[{group},
                        wellToNumberOfTimesSeenLookup[group[[3]]]=Lookup[wellToNumberOfTimesSeenLookup,group[[3]],0]+1;
                        Lookup[wellToIndexLookup,group[[3]]]+(Lookup[wellToNumberOfTimesSeenLookup,group[[3]]]*Length[idealOrderingToUse])
                      ]
                    ],
                    SortBy[
                      transferGroup[[All,;;-2]],
                      Function[{group},
                        wellToNumberOfTimesSeenLookup[group[[4]]]=Lookup[wellToNumberOfTimesSeenLookup,group[[4]],0]+1;
                        Lookup[wellToIndexLookup,group[[4]]]+(Lookup[wellToNumberOfTimesSeenLookup,group[[4]]]*Length[idealOrderingToUse])
                      ]
                    ]
                  ]
                ]
              ]
            ],
            groupedTransfersWithoutReusingDestinations
          ];

          (* NOTE: 5 is the index of the inputs, 6 is the index of the options. We want to combine all of the reordered groups into one *)
          (* big reordered list. *)
          (* NOTE: We have to be careful of the inputs list since there can be multiple inputs in the case of Transfer so we have to Transpose. *)
          (* For the options, we just have to Flatten and merge all the options into a list together. *)
          {
            Join@@@Transpose[Transpose/@(reorderedIndices[[All,All,5]])],
            (* Add non index-matching options back *)
            (* NOTE: We have to specify to only normalize the association here because there was a bug where Normal was converting *)
            (* options with AngularDegree to radians. *)
            Normal[Join[Merge[Flatten[(reorderedIndices[[All, All, 6]])], Join],KeyTake[Association@optionsFromPrimitiveOptionsWithExpandedTransfers,nonIndexMatchingOptionsForTransfer]], Association]
          }
        ],
        {inputsFromPrimitiveOptionsWithExpandedTransfers, optionsFromPrimitiveOptionsWithExpandedTransfers}
      ];

      (* Do we have a resolved PrimitiveMethod by which to resolve/simulate this primitive? *)
      resolvedPrimitiveMethod=Which[
        (* we got a symbol of 1 *)
        MatchQ[Lookup[primitive[[1]], PrimitiveMethod], _Symbol],
        Lookup[primitive[[1]], PrimitiveMethod],

        (* we have a list of 1 *)
        MatchQ[Lookup[primitive[[1]], PrimitiveMethod], {_Symbol}],
        Lookup[primitive[[1]], PrimitiveMethod][[1]],

        (* Otherwise, we have to call the primitive method resolver function. *)
        True,
        Module[{primitiveResolverMethod,potentialRawMethods,potentialMethods},
          (* Lookup the method resolver function. *)
          primitiveResolverMethod=Lookup[primitiveInformation, MethodResolverFunction];

          (* Pass down the inputs and options down to the resolver function. *)
          (* NOTE: We have to quiet here because we'll internally call the method resolver function again by calling the *)
          (* experiment function, so if there are messages, they'll be thrown there. *)
          potentialRawMethods=If[MatchQ[primitive, plateReaderPrimitiveP],
            Quiet[
              ToList@primitiveResolverMethod[
                Sequence@@inputFromPrimitiveOptionsWithRearrangedTransfers,
                Object[Protocol, Head[primitive]],
                Join[
                  optionsFromPrimitiveOptionsWithRearrangedTransfers,
                  {
                    Simulation->currentSimulation,
                    Cache->cacheBall,
                    Output->Result
                  }
                ]
              ]
            ],
            Quiet[
              ToList@primitiveResolverMethod[
                Sequence@@inputFromPrimitiveOptionsWithRearrangedTransfers,
                Join[
                  optionsFromPrimitiveOptionsWithRearrangedTransfers,
                  {
                    Simulation->currentSimulation,
                    Cache->cacheBall,
                    Output->Result
                  }
                ]
              ]
            ]
          ];

          (* NOTE: We always return Manual/Robotic from our method resolver function. Add Cell or Sample depending *)
          (* on the experiment function that we're in. *)
          potentialMethods=Flatten@{
            Which[
              MemberQ[potentialRawMethods, Manual] && MatchQ[myFunction, ExperimentManualCellPreparation|ExperimentCellPreparation],
                Cases[Lookup[primitiveInformation, Methods], ManualCellPreparation],
              MemberQ[potentialRawMethods, Manual] && cellsPresentQ && MatchQ[myFunction, Experiment],
                Cases[Lookup[primitiveInformation, Methods], ManualCellPreparation],
              MemberQ[potentialRawMethods, Manual] && MatchQ[myFunction, ExperimentManualSamplePreparation|ExperimentSamplePreparation],
                Cases[Lookup[primitiveInformation, Methods], ManualSamplePreparation],
              MemberQ[potentialRawMethods, Manual] && MatchQ[myFunction, Experiment],
                Cases[Lookup[primitiveInformation, Methods], ManualSamplePreparation|ManualCellPreparation|Experiment],
              True,
                {}
            ],
            Which[
              MemberQ[potentialRawMethods, Robotic] && cellsPresentQ || MatchQ[myFunction, ExperimentRoboticCellPreparation|ExperimentCellPreparation],
                Cases[Lookup[primitiveInformation, Methods], RoboticCellPreparation],
              MemberQ[potentialRawMethods, Robotic] && MatchQ[myFunction, ExperimentRoboticSamplePreparation|ExperimentSamplePreparation],
                Cases[Lookup[primitiveInformation, Methods], RoboticSamplePreparation],
              MemberQ[potentialRawMethods, Robotic] && MatchQ[myFunction, Experiment],
                Cases[Lookup[primitiveInformation, Methods], RoboticSamplePreparation|RoboticCellPreparation|Experiment],
              True,
                {}
            ]
          };

          (* From potentially multiple methods, pick the best one to use to resolve the primitive. *)
          Which[
            (* If we aren't able to perform this primitive via any method, default to Experiment and throw an error. *)
            Length[potentialMethods]==0,
              Module[{},
                AppendTo[invalidResolvePrimitiveMethodsWithIndices, {primitive, index}];

                Experiment
              ],
            (* Are we in a Manual or Robotic specific experiment function? *)
            (* NOTE: Even if these methods aren't part of the returned list, we will pass the Preparation option down *)
            (* to the experiment function later and its method resolver function should yell at us if this is a problem. *)
            MatchQ[myFunction, ExperimentManualSamplePreparation],
              ManualSamplePreparation,
            MatchQ[myFunction, ExperimentManualCellPreparation],
              ManualCellPreparation,
            MatchQ[myFunction, ExperimentRoboticSamplePreparation],
              RoboticSamplePreparation,
            MatchQ[myFunction, ExperimentRoboticCellPreparation],
              RoboticCellPreparation,
            (* If we only have one method, then it's clear which one to use. *)
            Length[potentialMethods]==1,
              First[potentialMethods],
            (* If the specified workcell for this primitive is a bioSTAR, microbioSTAR, or QPix, use RCP. *)
            MatchQ[Lookup[allPrimitiveOptionsWithSimulatedObjects, WorkCell, Automatic], Alternatives[bioSTAR, microbioSTAR, QPix]],
              RoboticCellPreparation,
            (* Do we already have a primitive in our primitive grouping and we can continue that method type? *)
            (* OTHERWISE, we will need to start a new primitive grouping. *)
            Length[currentPrimitiveGrouping]>0 && MemberQ[potentialMethods, Lookup[First[currentPrimitiveGrouping][[1]], PrimitiveMethod]],
              Lookup[First[currentPrimitiveGrouping][[1]], PrimitiveMethod],
            (* If we're choosing between Manual/non-Manual AND we're not LabelSample/LabelContainer/Wait, pick non-Manual. *)
            And[
              Length[potentialMethods]>1,
              MemberQ[potentialMethods, Except[ManualPrimitiveMethodsP]],
              !MatchQ[primitive, $DummyPrimitiveP],
              Or[
                Not[MatchQ[primitive, _Transfer]],
                And[
                  MatchQ[primitive, _Transfer] && Max[Flatten[{Cases[primitive[Amount], VolumeP], 0 Milliliter}]] <= 10 Milliliter,
                  !MemberQ[ToList[primitive[Amount]],All]
                ]
              ]
            ],
              FirstOrDefault[Cases[potentialMethods, Except[ManualPrimitiveMethodsP]]],
            (* if we're choosing between Manual/non-Manual and have a Transfer that is more than 10 mL or use All, pick Manual *)
            And[
              Length[potentialMethods]>1,
              MemberQ[potentialMethods, Except[RoboticPrimitiveMethodsP]],
              MatchQ[primitive, _Transfer],
              Or[
                Max[Flatten[{Cases[primitive[Amount], VolumeP], 0 Milliliter}]] > 10 Milliliter,
                MemberQ[ToList[primitive[Amount]],All]
              ]
            ],
              FirstOrDefault[Cases[potentialMethods, Except[RoboticPrimitiveMethodsP]]],
            (* If we're just starting off and all of our primitives can be done manually, just choose manual. *)
            And[
              Length[allPrimitiveGroupings]==0,
              MemberQ[Intersection@@((ToList[Lookup[#[[1]], PrimitiveMethod]]&)/@coverOptimizedPrimitives), ManualPrimitiveMethodsP]
            ],
              FirstOrDefault[Cases[potentialMethods, ManualPrimitiveMethodsP]],
            (* Try to solve the method globally for all primitives if we haven't started grouping at all. *)
            Length[allPrimitiveGroupings]==0 && Length[Intersection@@((ToList[Lookup[#[[1]], PrimitiveMethod]]&)/@coverOptimizedPrimitives)]>0,
              Module[{allPrimitiveMethods},
                (* Try to get a common method between ALL primitives. *)
                (* NOTE: We stash the primitive methods that match the primitive method pattern ahead of time before calling the *)
                (* method resolver, so the intersection here may be incorrect. *)
                allPrimitiveMethods=(ToList[Lookup[#[[1]], PrimitiveMethod]]&)/@coverOptimizedPrimitives;

                (* Favor robotic methods over manual methods. *)
                First@SortBy[
                  Intersection[potentialMethods, Intersection@@allPrimitiveMethods],
                  (Position[{RoboticSamplePreparation, RoboticCellPreparation, ManualSamplePreparation, ManualCellPreparation}, #, 5]&)
                ]
              ],
            (* Otherwise, pick based on what the other primitives within the local vicinity of this primitive look like. *)
            (* We only look ahead because at this point, we're going to start a new method grouping so we don't care about the past. *)
            True,
              Module[{nextRealPrimitiveIndex, surroundingPrimitives,surroundingPrimitiveMethods,mostCommonPrimitiveMethods},
                (* Get the first future index that does not contain _LabelSample|_LabelContainer|_Wait. *)
                (* This is because these primitives can always be performed via any method so it doesn't give us any additional *)
                (* information to include these. *)
                nextRealPrimitiveIndex=FirstPosition[coverOptimizedPrimitives[[index;;-1]], Except[$DummyPrimitiveP], {1}][[1]] + index - 1;

                (* Get the primitives that surround this primitive. *)
                surroundingPrimitives=Take[
                  coverOptimizedPrimitives,
                  {
                    index,
                    Min[{Length[coverOptimizedPrimitives], nextRealPrimitiveIndex+5}]
                  }
                ];

                (* Lookup the PrimitiveMethod keys from these primitives. *)
                surroundingPrimitiveMethods=Cases[(Lookup[#[[1]], PrimitiveMethod, Automatic]&)/@surroundingPrimitives, Except[Automatic]];

                (* Of our potential methods, get the ones that are the most common, in relation to our surrounding primitives. *)
                mostCommonPrimitiveMethods=UnsortedIntersection[potentialMethods,Commonest[Flatten[surroundingPrimitiveMethods]], DeleteDuplicates -> True];

                (* If we have nothing in common with our surrounding primitives, just take the first method. *)
                If[Length[mostCommonPrimitiveMethods]==0,
                  FirstOrDefault[potentialMethods, Experiment],
                  First[mostCommonPrimitiveMethods]
                ]
              ]
          ]
        ]
      ];

      (* If there are cell samples, but the resolved Primitive method is RoboticSamplePreparation, throw an error. *)
      If[And[cellsPresentQ, MatchQ[resolvedPrimitiveMethod, RoboticSamplePreparation]],
        Message[Error::RoboticCellPreparationRequired, primitive, ObjectToString[cellSamplesForErrorChecking, Cache -> cacheBall]];
        AppendTo[roboticCellPreparationRequired, index]
      ];

      (* If there are cell samples, preparation is Manual, and the primitive is compatible with MSP and MCP, tell the user to consider using MCP. *)
      If[And[
        !MatchQ[$ECLApplication, Engine],
        cellsPresentQ,
        MatchQ[resolvedPrimitiveMethod, ManualSamplePreparation],
        MemberQ[Lookup[lookupPrimitiveDefinition[Head[primitive]], Methods], ManualCellPreparation]
      ],
        Message[Warning::CellPreparationFunctionRecommended, primitive, ObjectToString[cellSamplesForErrorChecking, Cache -> cacheBall]],
        Nothing
      ];

      (* If we are in a Transfer primitive and ended up going with robotic, then set the inputs/options to the expanded ones. *)
      If[MatchQ[primitive, _Transfer] && MatchQ[resolvedPrimitiveMethod, Except[ManualPrimitiveMethodsP]],
        {inputsFromPrimitiveOptions, optionsFromPrimitiveOptions}={inputFromPrimitiveOptionsWithRearrangedTransfers, optionsFromPrimitiveOptionsWithRearrangedTransfers};,
        (* Otherwise we need to reset the label for "transfer destination sample" in $UniqueLabelLookup *)
        If[MatchQ[transferDestinationSampleLabelCounter,0],
          KeyDropFrom[Constellation`Private`$UniqueLabelLookup,"transfer destination sample"],
          Constellation`Private`$UniqueLabelLookup["transfer destination sample"]=transferDestinationSampleLabelCounter
        ];
      ];

      (* Lookup our primitive method index. *)
      primitiveMethodIndex=Lookup[primitive[[1]], PrimitiveMethodIndex, Automatic];

      (* Check if we are going to have a covered container for our next step. If yes, throw a warning and add Uncover UnitOperation *)
      (* This is performed after we have the resolvedPrimitiveMethod since we only need this in RSP/RCP *)
      If[
        And[
          MatchQ[resolvedPrimitiveMethod, Except[ManualPrimitiveMethodsP]],
          (* If we are going to start a new group, make sure we skip this Uncover task. This is because our currentPrimitiveGroupingDateStarted has not been updated for new group - which happens at the end of the loop *)
          !MatchQ[
            (Lookup[#[[1]], PrimitiveMethod]&)/@currentPrimitiveGrouping,
            {(ManualPrimitiveMethodsP)..}
          ]
        ],
        Module[
          {uncoverRequiredQ},
          (* Check on the primitive information to decide if we need the cover off. We need the cover off except for covered incubation, or an Uncover unit operation *)
          (* also for IncubateCells (where we actually _need_ it to be covered) *)
          (* The only other possible case is covered plate reading. exportReadPlateRoboticPrimitive automatically insert Uncover/Cover commands if the plate is covered but RetainCover->False. We don't have to worry about that here  *)
          uncoverRequiredQ=Or[
            MatchQ[Head[primitive],Except[Incubate|Mix|Uncover|IncubateCells]],
            And[
              MatchQ[Head[primitive], (Incubate|Mix)],
              (* We automatically resolve to Pipette mixing. Check if we specify Shake by MixType option or related options *)
              !Or[
                MatchQ[Lookup[optionsFromPrimitiveOptions,MixType,Automatic],ListableP[Shake]],
                MemberQ[Lookup[optionsFromPrimitiveOptions,#,Automatic]&/@{Time,MixRate,Temperature,ResidualIncubation,ResidualTemperature}, Except[ListableP[(Automatic|False|Null|Ambient)]]]
              ]
            ]
          ];

          If[TrueQ[uncoverRequiredQ],
            Module[{primitiveSamples,primitiveContainers,primitiveCoverDownload,platesWithCover,plateCoveredInProtocol,objectToLabelRules,plateLabelsCoveredInProtocol},
              (* Check allPrimitiveOptionsWithSimulatedObjects to get any plate that we plan to use in this primitive *)
              primitiveSamples=Cases[Flatten[Values[allPrimitiveOptionsWithSimulatedObjects]], ObjectP[Object[Sample]]];
              primitiveContainers=Cases[Flatten[Values[allPrimitiveOptionsWithSimulatedObjects]], ObjectP[Object[Container,Plate]]];
              (* Download the cover and log information *)
              primitiveCoverDownload=Quiet[
                Download[
                  {primitiveSamples,primitiveContainers},
                  {
                    {
                      Packet[Container[{Cover, CoverLog}]],
                      Packet[Container[Cover[{Model}]]],
                      Packet[Container[Cover[Model[{CoverType}]]]]
                    },
                    {
                      Packet[Cover, CoverLog],
                      Packet[Cover[{Model}]],
                      Packet[Cover[Model[{CoverType}]]]
                    }
                  },
                  Simulation->currentSimulation,
                  Cache->cacheBall
                ],
                {Download::FieldDoesntExist,Download::NotLinkField}
              ];

              (* Only check the plates that are now covered *)
              platesWithCover=Cases[Flatten[primitiveCoverDownload,1],{KeyValuePattern[{Object->ObjectP[Object[Container, Plate]],Cover->Except[Null]}],_,_}];

              (* Make sure only worry about the containers that are covered within our primitive resolver *)
              (* The plate may be covered before the experiment but we always uncover when we load the deck. That means, the Cover from before this primitive resolver does not count here for Automatic Uncover *)
              (* Also check if the cover is a black lid. PCR may put plate seal on top and that is fine for downstream manipulations *)
              plateCoveredInProtocol=DeleteDuplicates@Map[
                If[
                  And[
                    MemberQ[
                      ToList@Lookup[#[[1]],CoverLog,{}],
                      {GreaterEqualP[currentPrimitiveGroupingDateStarted],On,_,_}
                    ],
                    MatchQ[
                      Lookup[#[[2]]/.{Null-><||>},Model,Null],
                      ObjectP[Model[Item, Lid]]
                    ],
                    MatchQ[
                      Lookup[#[[3]]/.{Null-><||>},CoverType,Null],
                      Place
                    ]
                  ],
                  Lookup[#[[1]],Object],
                  Nothing
                ]&,
                platesWithCover
              ];

              (* Convert the objects to labels so we can add Uncover UO and also give user clear message *)
              objectToLabelRules=If[!NullQ[currentSimulation],
                (ObjectReferenceP[#[[2]]]|LinkP[#[[2]]]->#[[1]]&)/@Lookup[currentSimulation[[1]], Labels],
                {}
              ];
              plateLabelsCoveredInProtocol=plateCoveredInProtocol/.objectToLabelRules;

              If[Length[plateCoveredInProtocol]>0,
                (* we are not throwing this warning if we have an IncubateCells UO in the stack *)
                If[Not[MemberQ[coverOptimizedPrimitives, _IncubateCells]],
                  Message[Warning::UncoverUnitOperationAdded,primitive,plateLabelsCoveredInProtocol]
                ];
                coverOptimizedPrimitives=Insert[
                  coverOptimizedPrimitives,
                  Uncover[Sample->plateLabelsCoveredInProtocol,Preparation->Robotic,PrimitiveMethodIndex->primitiveMethodIndex],
                  index
                ];
                Continue[];
              ]
            ]
          ]
        ]
      ];

      (* Check if we are going to have an uncovered container for our next step. If yes and it's a unit operation that _requires_ a covered container, throw a warning and add Cover UnitOperation *)
      (* This is performed after we have the resolvedPrimitiveMethod since we only need this in RSP/RCP *)
      If[
        And[
          MatchQ[resolvedPrimitiveMethod, Except[ManualPrimitiveMethodsP]],
          (* If we are going to start a new group, make sure we skip this Cover task. This is because our currentPrimitiveGroupingDateStarted has not been updated for new group - which happens at the end of the loop *)
          !MatchQ[
            (Lookup[#[[1]], PrimitiveMethod]&)/@currentPrimitiveGrouping,
            {(ManualPrimitiveMethodsP)..}
          ]
        ],
        Module[
          {coverRequiredQ},
          (* Check on the primitive information to decide if we need the cover on.  Currently we _always_ need the cover on when going to an IncubateCells primitive *)
          coverRequiredQ = MatchQ[Head[primitive], IncubateCells];

          If[TrueQ[coverRequiredQ],
            Module[{primitiveSamples,primitiveContainers,primitiveCoverDownload,platesWithoutCover,plateCoveredInProtocol,objectToLabelRules,plateLabelsWithoutCover},
              (* Check allPrimitiveOptionsWithSimulatedObjects to get any plate that we plan to use in this primitive *)
              primitiveSamples=Cases[Flatten[Values[allPrimitiveOptionsWithSimulatedObjects]], ObjectP[Object[Sample]]];
              primitiveContainers=Cases[Flatten[Values[allPrimitiveOptionsWithSimulatedObjects]], ObjectP[Object[Container,Plate]]];
              (* Download the cover and log information *)
              primitiveCoverDownload=Quiet[
                Download[
                  {primitiveSamples,primitiveContainers},
                  {
                    {
                      Packet[Container[{Cover, CoverLog}]],
                      Packet[Container[Cover[{Model}]]],
                      Packet[Container[Cover[Model[{CoverType}]]]]
                    },
                    {
                      Packet[Cover, CoverLog],
                      Packet[Cover[{Model}]],
                      Packet[Cover[Model[{CoverType}]]]
                    }
                  },
                  Simulation->currentSimulation,
                  Cache->cacheBall
                ],
                {Download::FieldDoesntExist,Download::NotLinkField}
              ];

              (* Only check the plates that are now covered *)
              platesWithoutCover = Cases[Flatten[primitiveCoverDownload, 1], {KeyValuePattern[{Object -> ObjectP[Object[Container, Plate]], Cover -> Null}], _, _}];

              (* Convert the objects to labels so we can add Cover UO and also give user clear message *)
              objectToLabelRules=If[!NullQ[currentSimulation],
                (ObjectReferenceP[#[[2]]]|LinkP[#[[2]]]->#[[1]]&)/@Lookup[currentSimulation[[1]], Labels],
                {}
              ];
              plateLabelsWithoutCover = Lookup[platesWithoutCover[[All, 1]], Object, {}] /. objectToLabelRules;

              If[Length[plateLabelsWithoutCover] > 0,
                coverOptimizedPrimitives = Insert[
                  coverOptimizedPrimitives,
                  Cover[Sample -> plateLabelsWithoutCover, Preparation -> Robotic, PrimitiveMethodIndex -> primitiveMethodIndex],
                  index
                ];
                Continue[];
              ]
            ]
          ]
        ]
      ];

      (* Get user requested liquid handler -- this can come either from the global Instrument option or within a *)
      (* primitive grouping option. *)
      requestedInstrument=Which[
        MatchQ[Lookup[Lookup[primitiveMethodIndexToOptionsLookup, primitiveMethodIndex, <||>], Instrument, Null], ObjectP[{Model[Instrument], Object[Instrument]}]],
          Lookup[Lookup[primitiveMethodIndexToOptionsLookup, primitiveMethodIndex], Instrument],
        MatchQ[Lookup[safeOps,Instrument], ObjectP[{Model[Instrument], Object[Instrument]}]],
          Lookup[safeOps,Instrument],
        True,
          Automatic
      ];

      (* Do we know what WorkCell we're going to use (if we're doing this via RoboticBLAH)? *)
      resolvedWorkCell=If[MatchQ[resolvedPrimitiveMethod, ManualPrimitiveMethodsP],
        (* We don't use work cells for manual methods. *)
        Null,
        (* When we have more than one work cell in a primitive, we will need to resolve the work cell. *)
        If[Length[ToList[Lookup[primitiveInformation, WorkCells]]]==1,
          First[ToList[Lookup[primitiveInformation, WorkCells]]],
          Module[{workCellResolverFunction, potentialWorkCells, requestedWorkCell, allowedWorkCells},
            (* Lookup the method resolver function. *)
            workCellResolverFunction=Lookup[primitiveInformation, WorkCellResolverFunction];

            (* Pass down the inputs and options down to the work cell resolver function. *)
            potentialWorkCells=ToList@If[MatchQ[primitive, plateReaderPrimitiveP],
              workCellResolverFunction[
                Lookup[primitiveInformation, ExperimentFunction],
                Sequence@@inputsFromPrimitiveOptions,
                Join[
                  optionsFromPrimitiveOptions,
                  {
                    Simulation->currentSimulation,
                    Cache->cacheBall
                  }
                ]
              ],
              workCellResolverFunction[
                Sequence@@inputsFromPrimitiveOptions,
                Join[
                  optionsFromPrimitiveOptions,
                  {
                    Simulation->currentSimulation,
                    Cache->cacheBall
                  }
                ]
              ]
            ];
            (* if the user picked a workcell that is not possible, create warning *)
            userWorkCellChoice=Lookup[allPrimitiveOptionsWithSimulatedObjects,WorkCell,Automatic];
            (* Convert liquid handler object to work cell shortcut symbol (e.g. bioSTAR) *)
            requestedWorkCell=Which[
              (* Nothing requested - all work cells are at least possible *)
              MatchQ[requestedInstrument,Automatic],
              Keys[Experiment`Private`$WorkCellsToInstruments],
              (* Convert requested model to work cell *)
              MatchQ[requestedInstrument,ObjectP[Model[Instrument]]],
              Lookup[$InstrumentsToWorkCells,Lookup[fetchPacketFromCache[requestedInstrument,workCellModelPackets],Object]],
              (* Convert requested instrument to work cell *)
              MatchQ[requestedInstrument,ObjectP[Object[Instrument]]],
              Lookup[$InstrumentsToWorkCells,Lookup[fetchPacketFromCache[requestedInstrument,workCellObjectPackets],Model][Object]]
            ];

            (* Check if the specified work cell is compatible with the primitive *)
            specifiedWorkCell=If[MatchQ[userWorkCellChoice,Automatic],
              (* If Instrument option is specified, requestedWorkCell is single, matching WorkCellP. Otherwise just do Automatic *)
              If[MatchQ[requestedWorkCell,WorkCellP],
                requestedWorkCell,
                Automatic
              ],
              userWorkCellChoice
            ];

            If[Not[MemberQ[Append[potentialWorkCells,Automatic],specifiedWorkCell]],
              Message[Error::WorkCellIsIncompatible,specifiedWorkCell,primitive,potentialWorkCells];
              AppendTo[incompatibleWorkCellAndMethod,index];,

              (* don't allow using STAR if user picks RCP, or using bioSTAR/microbioSTAR if user picks RSP  *)
              Which[
                MatchQ[resolvedPrimitiveMethod, RoboticSamplePreparation] && (Not[MemberQ[potentialWorkCells, STAR]] || MatchQ[specifiedWorkCell, Alternatives[bioSTAR,microbioSTAR]]),
                  Message[Error::WorkCellIsIncompatibleWithMethod,resolvedPrimitiveMethod,primitive,Intersection[potentialWorkCells,{STAR}]];
                  AppendTo[incompatibleWorkCellAndMethod,index];,
                MatchQ[resolvedPrimitiveMethod, RoboticCellPreparation] && (Not[MemberQ[potentialWorkCells, Alternatives[bioSTAR,microbioSTAR,qPix]]] || MatchQ[specifiedWorkCell, STAR]),
                  Message[Error::WorkCellIsIncompatibleWithMethod,resolvedPrimitiveMethod,primitive,Intersection[potentialWorkCells,{bioSTAR,microbioSTAR,qPix}]];
                  AppendTo[incompatibleWorkCellAndMethod,index];,
                True,
                  Nothing
              ];
            ];

            (* Figure out which work cells are actually possible given the user request and the instrument constraints *)
            allowedWorkCells = UnsortedIntersection[potentialWorkCells, ToList[requestedWorkCell], DeleteDuplicates -> True];

            (* create a lookup so we can spit the error message with more clarity, ruling out LabelSample, and LabelContainer since really these two primitives can be done on any of the work cells in general *)
            previousPrimitiveToWorkCellLookup = Map[
              (* if it does not have/need a workcell, skip *)
              If[MatchQ[Lookup[#[[1]], WorkCell], WorkCellP] && !MatchQ[#, $DummyPrimitiveP],
                # -> Lookup[#[[1]], WorkCell],
                Nothing
              ]&,
              currentPrimitiveGrouping
            ];

            (* find out all previously resolved work cells *)
            previousWorkCells = DeleteDuplicates[previousPrimitiveToWorkCellLookup[[All, 2]]];

            (* preferences for workcells but not requirements *)
            Which[
              (* pass through user choice *)
              Not[MatchQ[userWorkCellChoice,Automatic]],
                userWorkCellChoice,
              (* if we already have a workcell chosen for our group and we can keep using it then do that *)
              Length[UnsortedIntersection[allowedWorkCells, previousWorkCells]] > 0,
                First[UnsortedIntersection[allowedWorkCells, previousWorkCells]],
              (* if we are in RSP, and we can use STAR then do that *)
              MatchQ[resolvedPrimitiveMethod, RoboticSamplePreparation] && MemberQ[allowedWorkCells, STAR],
                STAR,
              (* if we are in RCP and we have microbial samples and we can use microbioSTAR then do that *)
              MatchQ[resolvedPrimitiveMethod, RoboticCellPreparation] && MemberQ[potentialWorkCells, microbioSTAR] && MatchQ[microbialQ, True],
                microbioSTAR,
              (* if we are in RCP and we don't have microbial samples and we can use bioSTAR then do that *)
              MatchQ[resolvedPrimitiveMethod, RoboticCellPreparation] && MemberQ[potentialWorkCells, bioSTAR] && Not[MatchQ[microbialQ, True]],
                bioSTAR,
              (* failsafe clause: if we are in RCP, prefer either bioSTAR or microbioSTAR, or just pick the first workcell*)
              MatchQ[resolvedPrimitiveMethod, RoboticCellPreparation] && Length[Cases[potentialWorkCells,bioSTAR|microbioSTAR|qPix]]>0,
                FirstCase[potentialWorkCells, bioSTAR|microbioSTAR,First[potentialWorkCells]],
              (* If we get to here, it means STAR is not one of the potentialWorkCells but we must pick it anyway *)
              MatchQ[resolvedPrimitiveMethod,RoboticSamplePreparation],
                STAR,
              (* If we get here, it means bioSTAR or microbioSTAR are not one of the potentialWorkCells but we must pick it anyway *)
              MatchQ[resolvedPrimitiveMethod,RoboticCellPreparation],
                bioSTAR,
              MatchQ[allowedWorkCells,{__}],
                First[allowedWorkCells],
              (* ideally never reached, but this makes sure we pick any workcell *)
              True,
                First[potentialWorkCells]
            ]
          ]
        ]
      ];

      (* Check to make sure that the work cell matches WorkCellP. If not, warn the developer that something went wrong. *)
      (* resolvedWorkCell can be Null when doing the unit operation manually. *)
      If[!MatchQ[resolvedWorkCell, WorkCellP|Null],
        Message[Error::WorkCellDoesntMatchPattern, primitive];
      ];

      (* check to make sure that the work cell is the same as the previous work cell in the same primitive group *)

      (* see if we are starting a new primitive grouping or not *)
      startNewPrimitiveGroupingQ = Or[
        (* If the user told us that we should use a different method index, we're forced to split. *)
        !MatchQ[
          (Lookup[#[[1]], PrimitiveMethodIndex, Automatic]&) /@ currentPrimitiveGrouping,
          (* NOTE: PrimitiveMethodIndex is going to exist in the non-resolved primitive as well. *)
          {(primitiveMethodIndex | Automatic)...}
        ],
        (* If the user told us that we have to use a new primitive method. *)
        !MatchQ[
          (Lookup[#[[1]], PrimitiveMethod]&) /@ currentPrimitiveGrouping,
          {(resolvedPrimitiveMethod)...}
        ],
        (* Or if they left the primitive method index to be Automatic and... *)
        And[
          MatchQ[
            primitiveMethodIndex,
            Automatic
          ],
          Or[
            (* The user told us to use a different work cell. *)
            !MatchQ[
              previousWorkCells,
              {(resolvedWorkCell)...}
            ],
            (* Or we have more than $MaxPlateReaderInjectionSamples injection sample resources, we can't fit them in a single group. *)
            Module[{injectionResourceGroups},
              (* NOTE: We don't have to check for the number of injection resource groups here because that is covered *)
              (* by the plate reader instrument resources. *)
              injectionResourceGroups = computeInjectionSampleResourceGroups[currentPrimitiveGrouping];

              MemberQ[
                (MatchQ[Length[#], GreaterP[$MaxPlateReaderInjectionSamples]]&) /@ injectionResourceGroups[[All, 2]],
                True
              ]
            ],
            (* If our injection samples show up elsewhere, we have to start a new group since we can't put injection samples *)
            (* inside of the plate reader and on deck. *)
            MatchQ[
              Length[computeInvalidInjectionSampleResources[currentPrimitiveGrouping, currentPrimitiveGroupingUnitOperationPackets]],
              GreaterP[0]
            ]
          ]
        ]
      ];

      (* throw error only if we are NOT starting a new primitive group, and the resolved work cell is different from the previous one *)
      If[
        And[
          MatchQ[{resolvedWorkCell, previousWorkCells}, {WorkCellP, {WorkCellP..}}],
          !MemberQ[previousWorkCells, resolvedWorkCell],
          !startNewPrimitiveGroupingQ
        ],
        Message[Error::ConflictingWorkCells, primitive, index, resolvedWorkCell, previousPrimitiveToWorkCellLookup[[All, 2]], previousPrimitiveToWorkCellLookup[[All, 1]], myFunction];
        AppendTo[incompatibleWorkCellAndMethod, index]
      ];

      (* Lookup the function to call that goes with our resolved method. *)
      resolverFunction=Lookup[primitiveInformation, ExperimentFunction, Null];

      (* -- With the Primitive Method resolved, call our actual resolver function -- *)

      (* Get our safe options, based off of our option definitions in our primitive definition. This is because *)
      (* our primitive option definition might be different than the option definition in the resolver function if *)
      (* the resolver function is shared for multiple primitive types. *)
      safeResolverOptions=Module[{placeholderFunction},
        (* Take the option definition for the head of this primitive and set it as the option definition of our fake function. *)
        placeholderFunction /: OptionDefinition[placeholderFunction] = Lookup[primitiveInformation, OptionDefinition];

        Normal@KeyDrop[
          Association@SafeOptions[placeholderFunction, optionsFromPrimitiveOptions],
          Lookup[primitiveInformation, InputOptions]
        ]
      ];

      (* Resolve our primitive. *)
      (* NOTE: If we are dealing with a non-manual method, we must also ask for the resources that we will need *)
      (* to execute the primitive. This will be used for workcell grouping and we also will need to place the resources on *)
      (* deck in order to generate the JSON to perform the workcell protocol. *)

      (* Get the current count of total messages before calling the primitive function *)
      prePrimitiveFunctionCallMessageLength = Length[$MessageList];

      (* Keep track of if we used the cache for this primitive. This signals that we need to add unitOperationObjects *)
      (* to outputUnitOperationObjectsFromCache. *)
      usedResolverCacheQ=False;

      (* Define a bool that will be used to detect if any message was thrown when delayedMessages -> False *)
      delayedMessagesFalseMessagesBool = False;

      (* Get the resolver output and the messages thrown. *)
      (* NOTE: messagesThrown is in the format {<|MessageName->Hold[messageName], MessageArguments->_List|>}. *)
      {
        resolvedOptions,
        newSimulation,
        resolverTests,
        unitOperationPacketsRaw,
        runTimeEstimate,
        messagesThrown
      }=Module[{myMessageList, messageHandler},
        myMessageList = {};

        messageHandler[one_String, two:Hold[msg_MessageName], three:Hold[Message[msg_MessageName, args___]]] := Module[{},
          (* Keep track of the messages thrown during evaluation of the test. *)
          AppendTo[myMessageList, <|MessageName->Hold[msg],MessageArguments->ToList[args]|>];
        ];

        SafeAddHandler[{"MessageTextFilter", messageHandler},
          Module[
            {options, simulation, tests, result, timeEstimate, errorMessagesThrownQ,
              resolverPlateReaderRule, simulationHash, userReaderRequest},

            (* Helper function to see if myMessageList contains an Error. *)
            errorMessagesThrownQ[]:=MemberQ[myMessageList, KeyValuePattern[{MessageName->Hold[Verbatim[MessageName][Except[Warning],_]]}]];

            (* Translate between our primitive method wrappers and preparation option. *)
            preparation=resolvedPrimitiveMethod/.{
              ManualSamplePreparation|ManualCellPreparation|Experiment -> Manual,
              RoboticSamplePreparation|RoboticCellPreparation->Robotic
            };

            (* Initialize our variables. *)
            (* NOTE: Result will be an non-RequireResource'd Object[UnitOperation] in the case that the unit operation *)
            (* is being run via a non-manual method. *)
            options={};
            simulation=Null;
            tests={};
            result={};
            timeEstimate=Null;

            (* Get the hash of our simulation. We drop SimulatedObjects because previously non-uploaded unit operations *)
            (* can be seen as simulated by the Simulation, but once uploaded are now non-simulated, causing the simulation *)
            (* to be different on the second run through, causing the cache to not be triggered. *)
            (* NOTE: We can probably make the hashing function smarter in the future. *)
            simulationHash=Hash[KeyDrop[currentSimulation[[1]], SimulatedObjects]];

            (* Check if the user asked for a given instrument - if so we can't intervene and we should get an error later when finalizing liquid handler *)
            userReaderRequest=Lookup[safeResolverOptions,Instrument];

            (* If a specific Hamilton was requested, we need to make sure we use the instruments integrated with this model *)
            (* Currently this only applies for plate reader experiments which have different plate reader models associated with different Hamilton models *)
            resolverPlateReaderRule=If[MatchQ[primitive,plateReaderPrimitiveP] && MatchQ[requestedInstrument,ObjectP[]] && MatchQ[userReaderRequest,Automatic],
              Module[{requestedModel,integratedInstruments,plateReader,nephReader,readerToRequest},

                (* Grab the requested liquid handler *)
                requestedModel=If[MatchQ[requestedInstrument,ObjectP[Model[Instrument]]],
                  requestedInstrument,
                  Lookup[fetchPacketFromCache[requestedInstrument,workCellObjectPackets],Model][Object]
                ];

                (* Grab the instruments connected to this liquid handler *)
                integratedInstruments=Lookup[fetchPacketFromCache[requestedModel,Join[workCellObjectPackets,workCellModelPackets]],IntegratedInstruments];

                (* Get the models of interest - right now we only have one plate reader/neph. If this changed we could run into trouble here *)
                plateReader=FirstCase[integratedInstruments,ObjectP[Model[Instrument,PlateReader]]];
                nephReader=FirstCase[integratedInstruments,ObjectP[Model[Instrument, Nephelometer]]];

                (* Request the neph, or the plate reader for our PlateReader unit op *)
                readerToRequest=If[MatchQ[primitive, _Nephelometry|_NephelometryKinetics],
                  nephReader,
                  plateReader
                ];

                (* Prepare the option to send down to the plate reader experiment resolver *)
                Instrument->readerToRequest
              ],
              Nothing
            ];

            (* Evaluate the resolver function. Turn off message printing while doing so (we'll throw messages later). *)
            (* NOTE: Preparation is not an option if the experiment function can only be performed manually. *)
            (* NOTE: Do NOT send down the Cache->cacheBall option to the experiment function since the cache ball can contain *)
            (* historic packets that are not up to date with the simulation now. We expect the values of objects to change *)
            (* frequently since we're simulating changes in the lab. *)
            Block[{$Messages},
              Module[{},
                Which[
                  (* If we have a LabelSample primitive, we ALWAYS ask for the Object[UnitOperation] and send down a full *)
                  (* primitive list so that it can resolve the Volume key. *)
                  MatchQ[primitive, _LabelSample|_LabelContainer],
                  Module[{},
                    (* Print debug statement if asked. *)
                    If[MatchQ[debug, True],
                      Echo[
                        {
                          DateObject[],
                          Sequence @@ inputsFromPrimitiveOptions,
                          ReplaceRule[
                            safeResolverOptions,
                            {
                              Simulation -> currentSimulation,
                              Output -> {Options, Simulation, If[gatherTests, Tests, Nothing], Result},
                              If[MemberQ[Options[resolverFunction][[All,1]], "Preparation"],
                                Preparation->preparation,
                                Nothing
                              ],

                              (* NOTE: Option to send down the full primitive list for LabelSample but not LabelContainer. *)
                              If[MatchQ[primitive, _LabelSample],
                                Primitives -> primitivesWithPreresolvedInputs,
                                Nothing
                              ],

                              (* NOTE: Option to send down the parent protocol so we can perform the volume check correctly. *)
                              If[MatchQ[primitive, _LabelSample],
                                ParentProtocol -> parentProtocol,
                                Nothing
                              ]
                            }
                          ]
                        },
                        resolverFunction
                      ];
                    ];

                    If[MatchQ[gatherTests, True],
                      Module[{fullResolverOptions},
                        fullResolverOptions=ReplaceRule[
                          safeResolverOptions,
                          {
                            Simulation->currentSimulation,
                            Output->{Options, Simulation, Tests, Result},
                            If[MemberQ[Options[resolverFunction][[All,1]], "Preparation"],
                              Preparation->preparation,
                              Nothing
                            ],

                            (* NOTE: Option to send down the full primitive list for LabelSample but not LabelContainer. *)
                            If[MatchQ[primitive, _LabelSample],
                              Primitives->primitivesWithPreresolvedInputs,
                              Nothing
                            ],

                            (* NOTE: Option to send down the parent protocol so we can perform the volume check correctly. *)
                            If[MatchQ[primitive, _LabelSample],
                              ParentProtocol->parentProtocol,
                              Nothing
                            ],
                            resolverPlateReaderRule
                          }
                        ];

                        If[KeyExistsQ[$PrimitiveFrameworkResolverOutputCache, {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}],
                          usedResolverCacheQ=True;
                          {options,simulation,tests,result,myMessageList,Constellation`Private`$UniqueLabelLookup}=Lookup[$PrimitiveFrameworkResolverOutputCache, Key[{resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}]],
                          {options,simulation,tests,result}=resolverFunction[
                            Sequence@@inputsFromPrimitiveOptions,
                            fullResolverOptions
                          ]
                        ];

                        If[And[
                          !KeyExistsQ[$PrimitiveFrameworkResolverOutputCache, {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}],
                          !errorMessagesThrownQ[]
                        ],
                          AppendTo[
                            $PrimitiveFrameworkResolverOutputCache,
                            {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}->{options,simulation,tests,result,myMessageList,Constellation`Private`$UniqueLabelLookup}
                          ]
                        ]
                      ],
                      Module[{fullResolverOptions},
                        fullResolverOptions=ReplaceRule[
                          safeResolverOptions,
                          {
                            Simulation->currentSimulation,
                            Output->{Options, Simulation, Result},
                            If[MemberQ[Options[resolverFunction][[All,1]], "Preparation"],
                              Preparation->preparation,
                              Nothing
                            ],

                            (* NOTE: Option to send down the full primitive list for LabelSample but not LabelContainer. *)
                            If[MatchQ[primitive, _LabelSample],
                              Primitives->primitivesWithPreresolvedInputs,
                              Nothing
                            ],

                            (* NOTE: Option to send down the parent protocol so we can perform the volume check correctly. *)
                            If[MatchQ[primitive, _LabelSample],
                              ParentProtocol->parentProtocol,
                              Nothing
                            ],
                            resolverPlateReaderRule
                          }
                        ];

                        If[KeyExistsQ[$PrimitiveFrameworkResolverOutputCache, {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}],
                          usedResolverCacheQ=True;
                          {options,simulation,result,myMessageList,Constellation`Private`$UniqueLabelLookup}=Lookup[$PrimitiveFrameworkResolverOutputCache, Key[{resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}]],
                          {options,simulation,result}=resolverFunction[
                            Sequence@@inputsFromPrimitiveOptions,
                            fullResolverOptions
                          ]
                        ];

                        If[And[
                          !KeyExistsQ[$PrimitiveFrameworkResolverOutputCache, {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}],
                          !errorMessagesThrownQ[]
                        ],
                          AppendTo[
                            $PrimitiveFrameworkResolverOutputCache,
                            {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}->{options,simulation,result,myMessageList,Constellation`Private`$UniqueLabelLookup}
                          ]
                        ]
                      ]
                    ]
                  ],

                  (* If we're using a work cell, we ALWAYS ask for Object[UnitOperation] and on deck containers. *)
                  !MatchQ[resolvedPrimitiveMethod, ManualPrimitiveMethodsP],
                  Module[{},
                    (* Print debug statement if asked. *)
                    If[MatchQ[debug, True],
                      Echo[
                        {
                          DateObject[],
                          Sequence@@inputsFromPrimitiveOptions,
                          ReplaceRule[
                            safeResolverOptions,
                            {
                              Simulation->currentSimulation,
                              Output->{Options, Simulation, If[gatherTests, Tests, Nothing], Result, RunTime},
                              (* NOTE: FastTrack->True prevents Error::ContainerIsAlreadyCovered and Error::NoActiveCartForCover since we don't simulate cover state or the cover environment on active cart. *)
                              If[MatchQ[primitive,_Cover|_Uncover],
                                FastTrack->True,
                                Nothing
                              ],
                              If[MemberQ[Options[resolverFunction][[All,1]], "Preparation"],
                                Preparation->preparation,
                                Nothing
                              ],
                              If[MemberQ[Options[resolverFunction][[All,1]], "WorkCell"],
                                WorkCell->resolvedWorkCell,
                                Nothing
                              ],
                              Upload->False
                            }
                          ]
                        },
                        resolverFunction
                      ];
                    ];

                    If[MatchQ[gatherTests, True],
                      Module[{fullResolverOptions},
                        fullResolverOptions=ReplaceRule[
                          safeResolverOptions,
                          {
                            Simulation->currentSimulation,
                            Output->{Options, Simulation, Tests, Result, RunTime},
                            (* NOTE: FastTrack->True prevents Error::ContainerIsAlreadyCovered and Error::NoActiveCartForCover since we don't simulate cover state or the cover environment on active cart. *)
                            If[MatchQ[primitive,_Cover|_Uncover],
                              FastTrack->True,
                              Nothing
                            ],
                            If[MemberQ[Options[resolverFunction][[All,1]], "Preparation"],
                              Preparation->preparation,
                              Nothing
                            ],
                            If[MemberQ[Options[resolverFunction][[All,1]], "WorkCell"],
                              WorkCell->resolvedWorkCell,
                              Nothing
                            ],
                            resolverPlateReaderRule,
                            Upload->False
                          }
                        ];

                        If[KeyExistsQ[$PrimitiveFrameworkResolverOutputCache, {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}],
                          usedResolverCacheQ=True;
                          {options,simulation,tests,result,timeEstimate,myMessageList,Constellation`Private`$UniqueLabelLookup}=Lookup[$PrimitiveFrameworkResolverOutputCache, Key[{resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}]],
                          {options,simulation,tests,result,timeEstimate}=resolverFunction[
                            Sequence@@inputsFromPrimitiveOptions,
                            fullResolverOptions
                          ]
                        ];

                        If[And[
                          !KeyExistsQ[$PrimitiveFrameworkResolverOutputCache, {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}],
                          !errorMessagesThrownQ[]
                        ],
                          AppendTo[
                            $PrimitiveFrameworkResolverOutputCache,
                            {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}->{options,simulation,tests,result,timeEstimate,myMessageList,Constellation`Private`$UniqueLabelLookup}
                          ]
                        ]
                      ],
                      Module[{fullResolverOptions},
                        fullResolverOptions=ReplaceRule[
                          safeResolverOptions,
                          {
                            Simulation->currentSimulation,
                            Output->{Options, Simulation, Result, RunTime},
                            (* NOTE: FastTrack->True prevents Error::ContainerIsAlreadyCovered and Error::NoActiveCartForCover since we don't simulate cover state or the cover environment on active cart. *)
                            If[MatchQ[primitive,_Cover|_Uncover],
                              FastTrack->True,
                              Nothing
                            ],
                            If[MemberQ[Options[resolverFunction][[All,1]], "Preparation"],
                              Preparation->preparation,
                              Nothing
                            ],
                            If[MemberQ[Options[resolverFunction][[All,1]], "WorkCell"],
                              WorkCell->resolvedWorkCell,
                              Nothing
                            ],
                            resolverPlateReaderRule,
                            Upload->False
                          }
                        ];

                        If[KeyExistsQ[$PrimitiveFrameworkResolverOutputCache, {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}],
                          usedResolverCacheQ=True;
                          {options,simulation,result,timeEstimate,myMessageList,Constellation`Private`$UniqueLabelLookup}=Lookup[$PrimitiveFrameworkResolverOutputCache, Key[{resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}]],
                          {options,simulation,result,timeEstimate}=resolverFunction[
                            Sequence@@inputsFromPrimitiveOptions,
                            fullResolverOptions
                          ]
                        ];

                        If[And[
                          !KeyExistsQ[$PrimitiveFrameworkResolverOutputCache, {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}],
                          !errorMessagesThrownQ[]
                        ],
                          AppendTo[
                            $PrimitiveFrameworkResolverOutputCache,
                            {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}->{options,simulation,result,timeEstimate,myMessageList,Constellation`Private`$UniqueLabelLookup}
                          ]
                        ]
                      ]
                    ]
                  ],

                  (* OTHERWISE, we have a manual primitive and we don't care about the resource packets, on deck containers, *)
                  (* or runtime etc. *)
                  True,
                  Module[{},
                    (* Print debug statement if asked. *)
                    If[MatchQ[debug, True],
                      Echo[
                        {
                          DateObject[],
                          Sequence@@inputsFromPrimitiveOptions,
                          ReplaceRule[
                            safeResolverOptions,
                            {
                              Simulation->currentSimulation,
                              ParentProtocol->parentProtocol,
                              Output->{Options, Simulation, If[gatherTests, Tests, Nothing]},
                              (* NOTE: FastTrack->True prevents Error::ContainerIsAlreadyCovered and Error::NoActiveCartForCover since we don't simulate cover state or the cover environment on active cart. *)
                              If[MatchQ[primitive,_Cover|_Uncover],
                                FastTrack->True,
                                Nothing
                              ],
                              If[MemberQ[Options[resolverFunction][[All,1]], "Preparation"],
                                Preparation->preparation,
                                Nothing
                              ]
                            }
                          ]
                        },
                        resolverFunction
                      ];
                    ];

                    If[MatchQ[gatherTests, True],
                      Module[{fullResolverOptions},
                        fullResolverOptions=ReplaceRule[
                          safeResolverOptions,
                          {
                            Simulation->currentSimulation,
                            ParentProtocol->parentProtocol,
                            Output->{Options, Simulation, Tests,RunTime},
                            (* NOTE: FastTrack->True prevents Error::ContainerIsAlreadyCovered and Error::NoActiveCartForCover since we don't simulate cover state or the cover environment on active cart. *)
                            If[MatchQ[primitive,_Cover|_Uncover],
                              FastTrack->True,
                              Nothing
                            ],
                            If[MemberQ[Options[resolverFunction][[All,1]], "Preparation"],
                              Preparation->preparation,
                              Nothing
                            ],
                            resolverPlateReaderRule
                          }
                        ];

                        If[KeyExistsQ[$PrimitiveFrameworkResolverOutputCache, {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}],
                          usedResolverCacheQ=True;
                          {options,simulation,tests,timeEstimate,myMessageList,Constellation`Private`$UniqueLabelLookup}=Lookup[$PrimitiveFrameworkResolverOutputCache, Key[{resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}]],
                          {options,simulation,tests,timeEstimate}=resolverFunction[
                            Sequence@@inputsFromPrimitiveOptions,
                            fullResolverOptions
                          ]
                        ];

                        If[And[
                          !KeyExistsQ[$PrimitiveFrameworkResolverOutputCache, {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}],
                          !errorMessagesThrownQ[]
                        ],
                          AppendTo[
                            $PrimitiveFrameworkResolverOutputCache,
                            {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}->{options,simulation,tests,myMessageList,Constellation`Private`$UniqueLabelLookup}
                          ]
                        ]
                      ],
                      Module[{
                        primitiveImageSample,primitiveMeasureVolume,primitiveMeasureWeight, resolvedPrimitiveImageSampleRule,
                        resolvedPrimitiveMeasureVolumeRule,resolvedPrimitiveMeasureWeightRule,fullResolverOptions},

                        (* Get the post-processing option values from this primitive *)
                        primitiveImageSample=Lookup[safeResolverOptions,ImageSample];
                        primitiveMeasureVolume=Lookup[safeResolverOptions,MeasureVolume];
                        primitiveMeasureWeight=Lookup[safeResolverOptions,MeasureWeight];

                        (* If preparation is Manual and the primitive doesn't have a post-processing option specified,
                        then use the value resolved for the MSP, otherwise don't change the value *)
                        resolvedPrimitiveImageSampleRule=Switch[{primitiveImageSample,preparation},
                          {Automatic,Manual}, ImageSample -> resolvedImageSample,
                          {_,_}, Nothing
                        ];
                        resolvedPrimitiveMeasureVolumeRule=Switch[{primitiveMeasureVolume,preparation},
                          {Automatic,Manual}, MeasureVolume -> resolvedMeasureVolume,
                          {_,_}, Nothing
                        ];
                        resolvedPrimitiveMeasureWeightRule=Switch[{primitiveMeasureWeight,preparation},
                          {Automatic,Manual}, MeasureWeight -> resolvedMeasureWeight,
                          {_,_}, Nothing
                        ];

                        fullResolverOptions=ReplaceRule[
                          safeResolverOptions,
                          {
                            Simulation->currentSimulation,
                            ParentProtocol->parentProtocol,
                            Output->{Options, Simulation, RunTime},
                            (* NOTE: FastTrack->True prevents Error::ContainerIsAlreadyCovered and Error::NoActiveCartForCover since we don't simulate cover state or the cover environment on active cart. *)
                            If[MatchQ[primitive,_Cover|_Uncover],
                              FastTrack->True,
                              Nothing
                            ],
                            If[MemberQ[Options[resolverFunction][[All,1]], "Preparation"],
                              Preparation->preparation,
                              Nothing
                            ],
                            resolvedPrimitiveImageSampleRule,
                            resolvedPrimitiveMeasureVolumeRule,
                            resolvedPrimitiveMeasureWeightRule,
                            resolverPlateReaderRule
                          }
                        ];

                        If[KeyExistsQ[$PrimitiveFrameworkResolverOutputCache, {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}],
                          usedResolverCacheQ=True;
                          {options,simulation,timeEstimate,myMessageList,Constellation`Private`$UniqueLabelLookup}=Lookup[$PrimitiveFrameworkResolverOutputCache, Key[{resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}]],
                          {options,simulation,timeEstimate}=resolverFunction[
                            Sequence@@inputsFromPrimitiveOptions,
                            fullResolverOptions
                          ]
                        ];

                        If[And[
                          !KeyExistsQ[$PrimitiveFrameworkResolverOutputCache, {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}],
                          !errorMessagesThrownQ[]
                        ],
                          AppendTo[
                            $PrimitiveFrameworkResolverOutputCache,
                            {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}->{options,simulation,myMessageList,Constellation`Private`$UniqueLabelLookup}
                          ]
                        ]
                      ]
                    ]
                  ]
                ]
              ]
            ];

            (* Return our information. *)
            {
              options,
              simulation,
              tests,
              result,
              timeEstimate,
              myMessageList
            }
          ]
        ]
      ];

      (* NOTE: We have to do this because of some weirdness with weird RoundOptionsPrecision warnings that get detected *)
      savedDelayedMessagesFalseMessagesBool = delayedMessagesFalseMessagesBool;

      (* These three errors are all hard framework errors that make it such that the experiment function doesn't continue. *)
      (* If one of these happen, we have to handle it to fail gracefully. *)
      emptyContainerFailureQ=MemberQ[messagesThrown, <|MessageName -> Hold[Error::EmptyContainers], _|>];
      emptyWellFailureQ=MemberQ[messagesThrown, <|MessageName -> Hold[Error::ContainerEmptyWells], _|>];
      nonExistedWellFailureQ=MemberQ[messagesThrown, <|MessageName -> Hold[Error::WellDoesNotExist], _|>];
      (* NOTE: Here, since if delayedMessages -> False, we don't know what errors have been thrown, assume the worst *)
      hardResolverFailureQ = emptyContainerFailureQ || emptyWellFailureQ || nonExistedWellFailureQ || savedDelayedMessagesFalseMessagesBool || MatchQ[resolvedOptions, $Failed] || MatchQ[unitOperationPacketsRaw, $Failed];

      (* If the simulation that we get back doesn't match SimulationP, set it to an empty simulation. This is due to *)
      (* some weird Command Center bugs that have arisen. *)
      newSimulation=If[!MatchQ[newSimulation, SimulationP],
        Simulation[],
        newSimulation
      ];

      (* If unitOperationPacketsRaw is a single packet, ToList it. *)
      (* This is because we can get back a list of multiple unit operation packets from the resource packets function *)
      (* since you can have sub UnitOperations inside of your UnitOperation (ex. Transfer inside of Filter). *)
      (* NOTE: The last case is to stop trainwrecking in case we get back $Failed. *)
      (* NOTE: We need to separate the BatchedUnitOperations from the other types of unit operations, do this by the UnitOperationType field *)
      (* We only do this for the qpix unit operations *)
      {unitOperationPacketsMinusOptions, batchedUnitOperationPackets}=Which[
        MatchQ[unitOperationPacketsRaw, Alternatives[{PacketP[]..}, PacketP[]]],
        {
          Cases[ToList[unitOperationPacketsRaw], Alternatives[
            KeyValuePattern[UnitOperationType -> Input | Output | Calculated | Optimized],
            KeyValuePattern[
              {UnitOperationType -> Batched,
                Type -> Except[TypeP[
                  {
                    Object[UnitOperation,PickColonies],
                    Object[UnitOperation,InoculateLiquidMedia],
                    Object[UnitOperation,SpreadCells],
                    Object[UnitOperation,StreakCells],
                    Object[UnitOperation,ImageColonies],
                    Object[UnitOperation,QuantifyColonies]
                  }
                ]]
              }
            ]
          ]],
          Cases[ToList[unitOperationPacketsRaw], KeyValuePattern[
            {UnitOperationType -> Batched,
              Type -> TypeP[
                {
                  Object[UnitOperation,PickColonies],
                  Object[UnitOperation,InoculateLiquidMedia],
                  Object[UnitOperation,SpreadCells],
                  Object[UnitOperation,StreakCells],
                  Object[UnitOperation,ImageColonies],
                  Object[UnitOperation,QuantifyColonies]
                }
              ]
            }
          ]]
        },
        True,
          {{},{}}
      ];

      (* add the resolved options and unresolved options to the first unit operation packet (i.e., the one that goes into the top level OutputUnitOperations field) *)
      (* note that this ALWAYS ASSUMES the first packet here is the one that goes into OutputUnitOperations and the rest are accessory packets (either that they are RoboticUnitOperations, or the qpix BatchedUnitOperations, or something else) *)
      unitOperationPackets = If[MatchQ[unitOperationPacketsMinusOptions, {PacketP[]..}],
        Flatten[{
          Join[
            First[unitOperationPacketsMinusOptions],
            <|
              UnresolvedUnitOperationOptions -> Normal[KeyDrop[safeResolverOptions, {Simulation, Cache}], Association],
              ResolvedUnitOperationOptions -> Normal[KeyDrop[resolvedOptions, {Simulation, Cache}], Association]
            |>
          ],
          Rest[unitOperationPacketsMinusOptions]
        }],
        {}
      ];
      (*At the deepest level of unit operations, if we have any Transfer UnitOperation with MagnetizationRack -> "Alpaqua Magnum FLX Enhanced Universal Magnet 96-well Plate Rack", while having Filter. They will have conflicts when placing on deck. Add unit operation to the list for error tracking*)

      If[Length[unitOperationPackets]>0&&MatchQ[First[unitOperationPackets],Alternatives[
        KeyValuePattern[{Type -> Object[UnitOperation, Transfer], ResolvedUnitOperationOptions -> {___, MagnetizationRack -> ListableP[ObjectP[{Model[Item, MagnetizationRack, "id:kEJ9mqJYljjz"]}]],___}}],
        KeyValuePattern[{Type -> Object[UnitOperation, Filter]}]]
      ],
        (*If there is potential conflicting unit operation, add it to the error tracking list*)
        Module[{potentialConflictingDeckPlacementUnitOperation},
        potentialConflictingDeckPlacementUnitOperation = If[MatchQ[$PotentialConflictingDeckPlacementUnitOperations,{PacketP[]..}|{}],
          Append[$PotentialConflictingDeckPlacementUnitOperations,First[unitOperationPackets]],
          (*In case the parent function did send a simulation so the global constant was not properly initiated, *)
          {First[unitOperationPackets]}];
        Unset[$PotentialConflictingDeckPlacementUnitOperations];
        $PotentialConflictingDeckPlacementUnitOperations=potentialConflictingDeckPlacementUnitOperation
        ]
      ];

      (* If we used the cache, then add our unit operation objects to outputUnitOperationObjectsFromCache. *)
      If[MatchQ[usedResolverCacheQ, True] && Length[unitOperationPackets]>0,
        outputUnitOperationObjectsFromCache=Join[outputUnitOperationObjectsFromCache, Lookup[unitOperationPackets, Object]];
      ];

      (* Print debug statement if asked. *)
      If[MatchQ[debug, True],
        Echo[
          {DateObject[],If[FailureQ[resolvedOptions], resolvedOptions, Normal@KeyDrop[resolvedOptions, Cache]], newSimulation, resolverTests, unitOperationPackets, runTimeEstimate, messagesThrown},
          "{resolvedOptions, newSimulation, resolverTests, unitOperationPackets, runTimeEstimate, messagesThrown}"
        ]
      ];

      (* if we have not returned the legal RunTime, throw a warning (not on prod! and not for non-developer) *)
      If[
        And[
          MatchQ[ProductionQ[],Except[True]],
          MatchQ[$PersonID, ObjectP[Object[User, Emerald, Developer]]],
          MatchQ[preparation,Robotic],
          MatchQ[runTimeEstimate,Except[TimeP]],
          (* we explicitly exclude LabelContainer/LabelSample primitives from this check since they are not capable of returning RunTime*)
          !MatchQ[resolverFunction, Experiment`Private`resolveLabelContainerPrimitive | Experiment`Private`resolveLabelSamplePrimitive]
        ],
        (
          MapThread[
            ManifoldEcho[#1, #2]&,
            {
              {resolverFunction, inputsFromPrimitiveOptions, safeResolverOptions, If[FailureQ[resolvedOptions], resolvedOptions, Normal@KeyDrop[resolvedOptions, Cache]], newSimulation, resolverTests, unitOperationPackets, runTimeEstimate, messagesThrown},
              {"resolverFunction", "inputsFromPrimitiveOptions", "safeResolverOptions", "resolvedOptions", "newSimulation", "resolverTests", "unitOperationPackets", "runTimeEstimate", "messagesThrown"}
            }
          ];
          Message[Warning::NoRunTime, index, resolverFunction]
        )
      ];

      (* If we got back invalid inputs or invalid options, add this primitive to our list of invalid inputs. *)
      resolverErrorQ = Which[
        (* NOTE: We would normally do the Check[...] to get this, but due to the non-standard way we're capturing *)
        (* messages, we have to do this instead. *)
        (* NOTE: Once again if DelayedMessages -> False, if any message was thrown, assume the worst *)
        MemberQ[messagesThrown || savedDelayedMessagesFalseMessagesBool, KeyValuePattern[{MessageName->(Hold[Error::InvalidOption]|Hold[Error::InvalidInput])}]],
          True,
        hardResolverFailureQ,
          True,
        gatherTests,
          Not[RunUnitTest[<|"Tests" -> resolverTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
        True,
          False
      ];

      If[MatchQ[resolverErrorQ, True],
        AppendTo[invalidResolverPrimitives, index];
      ];

      (* Append any tests we got back to our global resolver tests list. *)
      allResolverTests=AppendTo[allResolverTests, resolverTests];

      (* See what new label fields we have. Keep track of the primitive index that we got these new label fields. *)
      newLabelFieldKeys=Complement[
        Join[Lookup[newSimulation[[1]], LabelFields][[All,1]], Lookup[newSimulation[[1]], Labels][[All,1]]],
        Lookup[currentSimulation[[1]], LabelFields][[All,1]]
      ];

      (* Add all new Labels to the LabelField key in the simulation. *)
      newLabelFields=Join[
        Cases[Lookup[newSimulation[[1]], LabelFields], Verbatim[Rule][Alternatives@@newLabelFieldKeys,_]],
        (#->#&)/@Intersection[Complement[Lookup[newSimulation[[1]], Labels][[All,1]], Lookup[newSimulation[[1]], LabelFields][[All,1]]], newLabelFieldKeys]
      ];

      (* Did we get back new labels that point to a different object? *)
      intersectionLabels=Intersection[Lookup[newSimulation[[1]],Labels][[All,1]],Lookup[currentSimulation[[1]],Labels][[All,1]]];
      overwrittenLabels=If[
        !MatchQ[Download[Lookup[Lookup[newSimulation[[1]],Labels],#],Object],Download[Lookup[Lookup[currentSimulation[[1]],Labels],#],Object]],
          #,
          Nothing
        ]&/@intersectionLabels;

      (* If we have labels that are trying to overwrite old labels, don't let that happen. *)
      (* NOTE: Also have to put the unit operation packets into the simulation since we will try to download from them and *)
      (* they will not yet be uploaded. *)
      newSimulationWithoutOverwrittenLabels=If[Length[overwrittenLabels]>0,
        AppendTo[allOverwrittenLabelsWithIndices, {overwrittenLabels, index, primitive}];

        Simulation[
          Packets->Lookup[newSimulation[[1]], Packets],
          Labels->Cases[Lookup[newSimulation[[1]], Labels], Verbatim[Rule][Except[Alternatives@@overwrittenLabels],_]],
          LabelFields->Cases[newLabelFields, Verbatim[Rule][Except[Alternatives@@overwrittenLabels],_]],
          Updated->False,
          SimulatedObjects->Lookup[newSimulation[[1]], SimulatedObjects]
        ],
        Simulation[
          Packets->Lookup[newSimulation[[1]], Packets],
          Labels->Lookup[newSimulation[[1]], Labels],
          LabelFields->newLabelFields,
          SimulatedObjects->Lookup[newSimulation[[1]], SimulatedObjects]
        ]
      ];

      (* For each message that was thrown, overwrite the message text to have the primitive index at the beginning of *)
      (* the message. *)
      (* NOTE: We have to wait until this point in the code to throw the errors because we need the updated simulation *)
      (* in order to map simulated samples to their labels since the simulated sample IDs should be hidden from the user. *)

      (* NOTE: Similar to ModifyFunctionMessages*)
      (* General::stop is quieted here because if we are calling primitive function which could also call ModifyFunctionMessages. *)
      (* With ModifyFunctionMessages, the errors are still collected properly (and eventually only thrown once), however the counter for General::stop *)
      (* is still counting in the background. So even though the message is only thrown once, we still see a General::stop error. *)
      (* We quiet this here to prevent this. *)
      (* Example: ExperimentCellPreparation calls ExperimentQuantifyCells, which uses ModifyFunctionMessages to call ExperimentAbsorbanceSpectroscopy, which throws a Warning::AliquotRequired in resolvedAliquotOptions.*)
      (* The General::stop counter for this warning will be triggered 3 times (thus having the General::stop message appear), even though we only eventually throw it once (the final version of message modifyed here) *)
      Quiet[
        MapIndexed[
          throwMessageWithPrimitiveIndex[#1, index, Head[primitive], newSimulationWithoutOverwrittenLabels, prePrimitiveFunctionCallMessageLength, #2]&,
          messagesThrown
        ],
        General::stop
      ];

      (* Store our previous simulation temporarily since we may need it in our FRQ call. This is because we want to *)
      (* look at resource availability BEFORE the experiment has been run. *)
      previousSimulation=currentSimulation;

      (* Update our current simulation with the simulation that we got back from our primitive. *)
      currentSimulation=UpdateSimulation[currentSimulation, newSimulationWithoutOverwrittenLabels];

      (* Filter out any options that aren't in our option definition. *)
      resolvedOptionsWithPrimitiveOptionsOnly=(If[!MemberQ[Lookup[primitiveOptionDefinitions, "OptionSymbol"], #[[1]]], Nothing, #]&)/@resolvedOptions;

      (* -- Insert our Resolved Options back into Primitive form to return them -- *)

      (* Create a map to convert any simulated objects back to their labels. *)
      simulatedObjectsToLabel=Module[{allObjectsInSimulation, simulatedQ},
        (* Get all objects out of our simulation. *)
        allObjectsInSimulation=Download[Lookup[currentSimulation[[1]], Labels][[All,2]], Object];

        (* Figure out which objects are simulated. *)
        simulatedQ = simulatedObjectQs[allObjectsInSimulation, currentSimulation];

        (Reverse/@PickList[Lookup[currentSimulation[[1]], Labels], simulatedQ])/.{link_Link:>Download[link,Object]}
      ];

      (* Make sure that we're not returning simulated objects. *)
      resolvedOptionsWithNoSimulatedObjects=resolvedOptionsWithPrimitiveOptionsOnly/.simulatedObjectsToLabel;
      inputsWithNoSimulatedObjects=inputsFromPrimitiveOptions/.simulatedObjectsToLabel;
      optionsWithNoSimulatedObjects=optionsFromPrimitiveOptions/.simulatedObjectsToLabel;

      (* Set a flag for the special case of FreezeCells with replicates. If this boolean is True, we need to expand the *)
      (* samples and options for the number of replicates because this option splits the input sample into multiple samples. *)
      (* we have to do the same for Aliquot since it has to generate the numOfSamples*replicates number of labels *)
      preparativeReplicatesQ = And[
        (* check straight ahead if resolved options ever failed *)
        Not[FailureQ[resolvedOptionsWithPrimitiveOptionsOnly]],
        Or[
          MatchQ[Head[primitive],FreezeCells],
          And[
            MemberQ[ToList@Lookup[resolvedOptionsWithPrimitiveOptionsOnly,Aliquot],True],
            (* lyse cells primitive does expansion before it feeds here so we shouldn't try to do the expansion here *)
            !MatchQ[Head[primitive],LyseCells]
          ]
        ],
        GreaterQ[Lookup[resolvedOptionsWithPrimitiveOptionsOnly,NumberOfReplicates],1],
        (* need a resolver function do to this expansion properly *)
        Not[NullQ[preparativeReplicatesQ]]
      ];
      numberOfPreparativeReplicates = If[preparativeReplicatesQ, Lookup[resolvedOptionsWithPrimitiveOptionsOnly, NumberOfReplicates], Null];

      (* Correct the resolved options for replicates if needed. *)
      {expandedInputs, resolvedCorrectedOptions} = If[!preparativeReplicatesQ,
        (* Without preparative replicates, this is straightforward. *)
        {inputsFromPrimitiveOptions, resolvedOptionsWithNoSimulatedObjects},
        (* Otherwise we need to handle the special case of preparative replicates. *)
        (* note that we are ALSO setting ResetNumberOfReplicates -> True because we don't want to expand by NumberOfReplicates here and then again when we are actually running the Experiment *)
        ExpandIndexMatchedInputs[resolverFunction, inputsFromPrimitiveOptions, resolvedOptionsWithNoSimulatedObjects, ExpandReplicates -> True, ResetNumberOfReplicates -> True]
      ];

      (* Put our resolved options (and inputs, which don't need to be resolved, back into primitive format. *)
      {resolvedPrimitive, optionsWithNoSimulatedObjectsIndexMatchingToSample}=If[hardResolverFailureQ,
        {primitive, optionsWithNoSimulatedObjects},
        Module[{innerResolvedPrimitive, innerOptionsIndexMatched, inputOptionsWithContainers, inputOptionNames, currentContainerPackets, innerOptionsWithResolvedLabels, generativeQ},
          inputOptionNames = Lookup[primitiveInformation, InputOptions];

          currentContainerPackets=Download[
            DeleteDuplicates[Cases[inputsFromPrimitiveOptions, ObjectP[Object[Container]], Infinity]],
            Packet[Contents],
            Simulation->previousSimulation
          ];

          innerResolvedPrimitive = Module[{},
            Head[primitive][Association@Join[
            (* Make sure to convert all containers to samples since the functions will do this internally and we need the *)
            (* index matching to work out. *)
            (* NOTE: ExperimentTransfer/Cover/Uncover leaves containers alone so do not do this for those experiments. *)
            If[MatchQ[Head[primitive], Transfer|Cover|Uncover],
              Rule@@@Transpose[{Lookup[primitiveInformation, InputOptions], inputsWithNoSimulatedObjects}],
              Module[{containerToAllSampleLookup,allcontainerToSamples,positionToSampleLookup,allpositionsToSamples},

                inputOptionsWithContainers = MapThread[
                  #1 -> #2 &,
                  {inputOptionNames, expandedInputs}
                ];

                (* Build a look up to transfer container to all the sample inside that container *)
                containerToAllSampleLookup=(Lookup[#, Object] -> Sequence@@Download[Lookup[#, Contents][[All,2]], Object]&)/@currentContainerPackets;

                positionToSampleLookup=Flatten[Module[{object,allSamples,allPositions},

                  object=Lookup[#, Object];
                  allSamples=Download[Lookup[#, Contents][[All,2]], Object];
                  allPositions=Lookup[#, Contents][[All,1]];

                  MapThread[({#1,object}->#2)&,{allPositions,allSamples}]

                ]&/@currentContainerPackets,1];

                (* Replace simulated objects with their labels. *)
                allpositionsToSamples=inputOptionsWithContainers/.positionToSampleLookup;


                allcontainerToSamples=allpositionsToSamples/.containerToAllSampleLookup;

                (* Replace simulated (and real) containers with simulated (and real) samples. *)
                (* Also, replace any simulated objects with their labels (keep real objects in object form) *)
                (* note that preparative replicates are already handled by the ExpandIndexMatchedInputs expanidng above *)
                allcontainerToSamples /. simulatedObjectsToLabel
              ]
            ],
            (* Add our primitive options based on the resolved information we got back. *)
            (* Remove any simulated objects and replace them with labels. *)
            resolvedCorrectedOptions,

            (* These aren't really options to the primitive, so make sure to add them back. *)
            (* NOTE: We don't use the "safe" primitive method here, we use the original one given by the user as to not change *)
            (* the command builder view. *)
            {
              PrimitiveMethod->resolvedPrimitiveMethod,
              PrimitiveMethodIndex->primitiveMethodIndex,
              WorkCell->resolvedWorkCell,
              (* add the resolved options and unresolved options to the first unit operation packet (i.e., the one that goes into the top level OutputUnitOperations field) *)
              (* need to do this here in addition to what we did before because if dealing with a unit operation that doesn't return unit operation packets then we need a different way to make it into the unit operation object *)
              UnresolvedUnitOperationOptions -> Normal[KeyDrop[safeResolverOptions, {Simulation, Cache}], Association],
              ResolvedUnitOperationOptions -> Normal[KeyDrop[resolvedCorrectedOptions, {Simulation, Cache}], Association]
            }
          ]]];

          (* Here we are doing some modifications to the unresolved options *)
          (* 1. we need to fix the index-matching of unresolved primitives. If we have containers in InputOptions some options may index-match to container, *)
          (*    then after expanding container into sample it's no longer index-matched *)
          (* 2. some primitives are generative. new samples generated from these primitives can be referred by the resolved labels in later primitives *)
          (*    however, if the label name doesn't exist in the unresolved options, later function can error out in the script because it can't find that label *)

          (* First fix problem 1 *)
          innerOptionsIndexMatched = If[MatchQ[Head[primitive], Transfer|Cover|Uncover],
            optionsWithNoSimulatedObjects,
            Module[{correctedIndexMatchingOptionValues, containerToAllSampleLengthLookup, indexMatchingOptions},

              containerToAllSampleLengthLookup = (Lookup[#, Object] -> Length[Lookup[#, Contents]]&)/@currentContainerPackets;
              (* Find all index-matching options *)
              indexMatchingOptions = Lookup[Cases[Lookup[primitiveInformation, OptionDefinition], (KeyValuePattern["IndexMatchingParent" -> Alternatives@@(ToString /@ inputOptionNames)] | KeyValuePattern["IndexMatchingInput" -> "experiment samples"])], "OptionSymbol"];

              correctedIndexMatchingOptionValues = Map[
                Function[{optionValueRule},
                  (* If the option is not index-matching to input, or the option value is not a list, don't change anything *)
                  If[
                    And[
                      MatchQ[Values[optionValueRule], _List],
                      MemberQ[indexMatchingOptions, Keys[optionValueRule]],
                      !MemberQ[inputOptionNames, Keys[optionValueRule]],
                      Length[Values[First[inputOptionsWithContainers]]] == Length[Values[optionValueRule]]
                    ],
                    Flatten[
                      MapThread[
                        Function[{singleOption, singleInput},
                          Module[{containerMultiplicity, multipliedOptionValue},
                            (* Key[singleInput] is...key here.  if singleInput is a container then it will work fine. But if it is something like {"A1", Object[Container, Plate, "id:lkjlkj"]}, then this lookup is goign to give weird results *)
                            (* For instance: *)
                            (* Lookup[{container1 -> 4}, container1] obviously gives 4 *)
                            (* Lookup[{container1 -> 4}, {"A1", container1}] weirdly gives {Missing[KeyAbsent, "A1"], 4} *)
                            (* Lookup[{container1 -> 4}, Key[{"A1", container1}]] gives Missing[KeyAbsent, {"A1", container1}] as we expect *)
                            (* since we're doing weird flatten shenanigans and using 1 as the third argument of lookup, we will get unexpected behavior if we have the {position, container} format and DON'T use Key *)
                            containerMultiplicity = Lookup[containerToAllSampleLengthLookup, Key[singleInput], 1];
                            multipliedOptionValue = ConstantArray[singleOption, containerMultiplicity]
                          ]
                        ],
                        {Values[optionValueRule], Values[First[inputOptionsWithContainers]]}
                      ],
                      1
                    ],
                    Values[optionValueRule]
                  ]
                ],
                optionsWithNoSimulatedObjects
              ];

              MapThread[#1 -> #2&, {Keys[optionsWithNoSimulatedObjects], correctedIndexMatchingOptionValues}]
            ]
          ];

          (* Now fix problem 2 *)
          generativeQ = Lookup[primitiveInformation, Generative, False];

          (* If primitive is generative, replace the GenerativeLabelOption with the resolved option; otherwise don't change anything *)
          innerOptionsWithResolvedLabels = If[TrueQ[generativeQ],
            Module[{generativeLabelOptionName, generativeLabelOptionValue},

              generativeLabelOptionName = Lookup[primitiveInformation, GenerativeLabelOption];
              generativeLabelOptionValue = Lookup[resolvedCorrectedOptions, generativeLabelOptionName];
              ReplaceRule[innerOptionsIndexMatched, {generativeLabelOptionName -> generativeLabelOptionValue}]
            ],
            innerOptionsIndexMatched
          ];
          {innerResolvedPrimitive, innerOptionsWithResolvedLabels}
        ]
      ];

      (* We're about to return. Remove our temporary print cell. *)
      If[MatchQ[$ECLApplication, CommandCenter|Mathematica],
        NotebookDelete[primitiveResolvingMessageCell]
      ];

      (* -- Figure out our Primitive Method Groupings -- *)
      Which[
        (* We never have to worry about deck capacity for manual primitives. Therefore, we do NOT *)
        (* do the resource deck checking that we do for work cell primitives. *)
        MatchQ[resolvedPrimitiveMethod, ManualPrimitiveMethodsP],
          Module[{},
            (* Do we have an existing group of the same method (or non-initialized group)? If so, we can safely append. *)
            (* Otherwise, we first have to clear it, then append. *)
            If[Or[
                (* If the user didn't specify that we should use a new primitive grouping, we're allowed to add it to *)
                (* the previous one. *)
                !Or[
                  MatchQ[
                    Lookup[primitive[[1]], PrimitiveMethodIndex, Automatic],
                    Automatic
                  ],
                  MatchQ[
                    (Lookup[#[[1]], PrimitiveMethodIndex, Automatic]&)/@currentPrimitiveGrouping,
                    (* NOTE: PrimitiveMethodIndex is going to exist in the non-resolved primitive as well. *)
                    {(Lookup[primitive[[1]], PrimitiveMethodIndex, Automatic]|Automatic)...}
                  ]
                ],
                !MatchQ[
                  (Lookup[#[[1]], PrimitiveMethod]&)/@currentPrimitiveGrouping,
                  {resolvedPrimitiveMethod...}
                ]
              ],
              startNewPrimitiveGrouping[];
            ];

            (* Fill out our new grouping with our primitive information. *)
            AppendTo[currentPrimitiveGrouping, resolvedPrimitive];
            AppendTo[currentUnresolvedPrimitiveGrouping, Head[primitive]@KeyDrop[primitive[[1]], {PrimitiveMethod, PrimitiveMethodIndex, WorkCell}]];
            AppendTo[currentPrimitiveInputGrouping, inputsWithNoSimulatedObjects];
            AppendTo[currentPrimitiveOptionGrouping, resolvedCorrectedOptions];
            AppendTo[currentPrimitiveGroupingUnitOperationPackets, unitOperationPackets];
            AppendTo[currentPrimitiveGroupingBatchedUnitOperationPackets, batchedUnitOperationPackets];
            currentLabelFieldsWithIndices=Join[
              currentLabelFieldsWithIndices,
              (#[[1]]->LabelField[#[[2]], index]&)/@newLabelFields
            ];

            (* 1) Call FRQ if we have required resource (this is the case for LabelContainer and LabelSample). *)
            (* For other manual primitives, FRQ is called in the resource packets function by the experiment function. *)

            (* 2) Add the resources created by LabelContainer/LabelSample to currentPrimitiveGroupingLabeledObjects so *)
            (* that they will be included in the protocol-level LabeledObjects. *)

            (* 3) We do NOT keep track of UnitOperation packets, even though we have them, for Preparation->Manual and *)
            (* instead rely on OutputUnitOperationParserFunction to resolve the Sample key in the Object[UnitOperation] *)
            (* to be consistent with all other manual unit operations. *)
            If[MatchQ[unitOperationPackets, {PacketP[]..}],
              Module[{labeledObjectsLookup, allResourceBlobs, nonSimulatedResourceBlobs, newFrqTests, newFulfillableQ,
                objectResources, newNonObjectResources},
                (* Lookup the LabeledObjects field from our packet. *)
                labeledObjectsLookup=Rule@@@((Sequence@@Lookup[#, Replace[LabeledObjects], {}]&)/@unitOperationPackets);

                (* NOTE: We are adding resources here because we can still have a LabelSample/LabelContainer primitive *)
                (* in a manual group. *)
                currentPrimitiveGroupingLabeledObjects=Join[currentPrimitiveGroupingLabeledObjects, labeledObjectsLookup];

                (* Get all of the resources in our unit operation packet. *)
                allResourceBlobs=DeleteDuplicates[Cases[Normal/@unitOperationPackets,_Resource,Infinity]];

                (* Exclude simulated resources using the current simulation here. FRQ usually does this for us, but *)
                (* we are passing down a previous simulation which may not have newly simulated objects in it. *)
                nonSimulatedResourceBlobs=Module[{objectsInResourceBlobs,simulatedObjects},
                  (* Get all of the objects from the resource blobs. *)
                  objectsInResourceBlobs=DeleteDuplicates[Cases[allResourceBlobs, ObjectReferenceP[], Infinity]];

                  (* Figure out which objects are simulated. *)
                  (* note that although elsewhere in this code we don't want to count things in $CurrentSimulation as "simulated", here we do because FRQ will not work nicely with any simulated objects, $CurrentSimulation or not *)
                  simulatedObjects=If[MatchQ[$CurrentSimulation, SimulationP],
                    Intersection[Join[Lookup[$CurrentSimulation[[1]], SimulatedObjects], Lookup[currentSimulation[[1]], SimulatedObjects]], objectsInResourceBlobs],
                    Intersection[Lookup[currentSimulation[[1]], SimulatedObjects], objectsInResourceBlobs]
                  ];

                  (* Only check if non-simulated objects are fulfillable. *)
                  (
                    If[MemberQ[#, Alternatives @@ simulatedObjects, Infinity],
                      Nothing,
                      #
                    ]
                  &)/@allResourceBlobs
                ];

                (* split up the resources that have Sample set to an Object vs all the rest of them *)
                (* doing this because we must call FRQ on the objects at the proper time between unit operations, but for performance sake, would like to save all the models (which are considerably slower) to the end of the SP call *)
                objectResources = Select[nonSimulatedResourceBlobs, MatchQ[#[Sample], ObjectP[Object]]&];
                newNonObjectResources = DeleteCases[nonSimulatedResourceBlobs, Alternatives @@ objectResources];

                (* call fulfillableResourceQ on all the resources we created *)
                (* NOTE: we want to look at resource availability BEFORE the experiment has been run. *)
                (* if UnitOperationPackets -> True, then we are not calling frq right now because it will get called by whatever was asking for the UnitOperationPackets *)
                {newFulfillableQ, newFrqTests} = Which[
                  MatchQ[$ECLApplication, Engine] || unitOperationPacketsQ, {True, {}},
                  gatherTests, Resources`Private`fulfillableResourceQ[objectResources, Simulation->previousSimulation, Output -> {Result, Tests}],
                  True, {Resources`Private`fulfillableResourceQ[objectResources, Simulation->previousSimulation], {}}
                ];

                (* Append our new non-Object Resources *)
                AppendTo[nonObjectResources, newNonObjectResources];

                (* Append our new FRQ tests. *)
                AppendTo[frqTests, newFrqTests];

                (* If we aren't fulfillable, keep track of that globally. *)
                If[MatchQ[newFulfillableQ, False],
                  fulfillableQ=False;
                ];
              ]
            ];
          ],

        (* Otherwise, we must have a work cell primitive. Do the resource checks that relate to 1) footprint, 2) tips, *)
        (* and 3) integrated instruments. *)
        True,
          Module[
            {sampleAndContainerResourceBlobs, updatedSampleAndContainerResourceBlobs,sampleAndContainerResourceBlobToIncubationTimeLookup, instrumentResourceObjects, instrumentResourceModels,
              sampleObjects, nonSampleObjects, resourceCache, newFootprintResult, currentFootprintResult, currentFootprintResultNoDuplicates,
              allFootprintResult, newFootprintTally, currentPrimitiveGroupingResourceBlobs, currentPrimitiveGroupingMagnetizationRackResourceBlobs,
              currentUOResourceBlobs, currentUOMagnetizationRackResourceBlobs, singlePrimitiveFootprintTally, allTipResources,
              flattenedStackedTipTuples, singlePrimitiveFlattenedStackedTipTuples, flattenedNonStackedTipTuples, singlePrimitiveFlattenedNonStackedTipTuples,
              filteredInstruments, newLabeledObjectsLookup,startingIncubatorContainers, singlePrimitiveStartingIncubatorContainers,
              startingAmbientContainers, singlePrimitiveStartingAmbientContainers,
              instrumentResourceBlobs, tipResourceBlobs, objectContainersFromResourcesExistQ, objectContainerPacketsFromResource,
              incubatorPlateResources, ambientPlateResources, newPlateFootprintResult, labeledObjectsLookup, allResourceBlobs,
              samplesAndContainerObjects, newFootprintResultNoDuplicates, workCellIdlingConditions, objectsToDownloadFrom,
              fieldsToDownloadFrom, allInstrumentResourceModels, highPrecisionPositionContainersBools, singlePrimitiveHighPrecisionPositionContainersBools,
              currentPrimitiveGroupingIntegratedInstruments, tipAdapterUsedQ},

            (* Setup a new grouping if our current grouping isn't the same work cell type. *)
            If[startNewPrimitiveGroupingQ,
              startNewPrimitiveGrouping[];
            ];

            (* Lookup the LabeledObjects field from our packet. *)
            labeledObjectsLookup=ReplaceAll[
              Rule@@@((Sequence@@Lookup[#, Replace[LabeledObjects], {}]&)/@unitOperationPackets),
              {$Failed->{}}
            ]/.{link:Verbatim[Link][Resource[___]]:>First[link]};

            (* Get all of the resources in our unit operation packet. *)
            allResourceBlobs=DeleteDuplicates[Cases[Normal/@unitOperationPackets,_Resource,Infinity]];

            (* check we are using tip adapter in our unit operations *)
            tipAdapterUsedQ = MatchQ[
              FirstCase[allResourceBlobs, Resource[KeyValuePattern[Sample->Model[Item, "id:Y0lXejMp6aRV"]]],{}],
              _Resource];

            (* Call FRQ on our new resources. *)
            Module[{nonSimulatedResourceBlobs, newFrqTests, newFulfillableQ, objectResources, newNonObjectResources},
              (* Exclude simulated resources using the current simulation here. FRQ usually does this for us, but *)
              (* we are passing down a previous simulation which may not have newly simulated objects in it. *)
              nonSimulatedResourceBlobs=Module[{objectsInResourceBlobs,simulatedObjects},
                (* Get all of the objects from the resource blobs. *)
                objectsInResourceBlobs=DeleteDuplicates[Cases[allResourceBlobs, ObjectReferenceP[], Infinity]];

                (* Figure out which objects are simulated. *)
                (* note that although elsewhere in this code we don't want to count things in $CurrentSimulation as "simulated", here we do because FRQ will not work nicely with any simulated objects, $CurrentSimulation or not *)
                simulatedObjects=If[MatchQ[$CurrentSimulation, SimulationP],
                  Intersection[Join[Lookup[$CurrentSimulation[[1]], SimulatedObjects], Lookup[currentSimulation[[1]], SimulatedObjects]], objectsInResourceBlobs],
                  Intersection[Lookup[currentSimulation[[1]], SimulatedObjects], objectsInResourceBlobs]
                ];

                (* Only check if non-simulated objects are fulfillable. *)
                (
                  If[MemberQ[#, Alternatives @@ simulatedObjects, Infinity],
                    Nothing,
                    #
                  ]
                &)/@allResourceBlobs
              ];

              (* split up the resources that have Sample set to an Object vs all the rest of them *)
              (* doing this because we must call FRQ on the objects at the proper time between unit operations, but for performance sake, would like to save all the models (which are considerably slower) to the end of the SP call *)
              objectResources = Select[nonSimulatedResourceBlobs, MatchQ[#[Sample], ObjectP[Object]]&];
              newNonObjectResources = DeleteCases[nonSimulatedResourceBlobs, Alternatives @@ objectResources];

              (* call fulfillableResourceQ on all the resources we created *)
              (* NOTE: we want to look at resource availability BEFORE the experiment has been run. *)
              (* if UnitOperationPackets -> True, then we aren't calling FRQ because the function that called it will do it instead *)
              {newFulfillableQ, newFrqTests} = Which[
                MatchQ[$ECLApplication, Engine] || unitOperationPacketsQ, {True, {}},
                gatherTests, Resources`Private`fulfillableResourceQ[objectResources, Simulation->previousSimulation, Output -> {Result, Tests}],
                True, {Resources`Private`fulfillableResourceQ[objectResources, Simulation->previousSimulation], {}}
              ];

              (* Append our new non-Object Resources *)
              AppendTo[nonObjectResources, newNonObjectResources];

              (* Append our new FRQ tests. *)
              AppendTo[frqTests, newFrqTests];

              (* If we aren't fulfillable, keep track of that globally. *)
              If[MatchQ[newFulfillableQ, False],
                fulfillableQ=False;
              ];
            ];

            (* TODO: Need to deal with resource constraints differently according to the work cell type that we're on. *)

            (* Figure out what new labeled objects we have from this primitive. *)
            (* NOTE: There may be other new objects that we require on deck that are NOT labeled. This is only for *)
            (* keeping track of what we should put in the protocol-level LabeledObjects/FutureLabeledObjects fields. *)
            newLabeledObjectsLookup=Module[{newLabeledObjectKeys},
              newLabeledObjectKeys=Complement[
                labeledObjectsLookup[[All,1]],
                currentPrimitiveGroupingLabeledObjects[[All,1]]
              ];

              DeleteDuplicates@Cases[
                labeledObjectsLookup,
                Verbatim[Rule][Alternatives@@newLabeledObjectKeys, _]
              ]
            ];

            (* Lookup the footprints of any samples/containers/etc. For sample resources, we really care about the *)
            (* container to see if we already have an equivalent resource. *)
            (* NOTE: Object[Resource, Sample] is used for samples, containers, items, and parts. We explicitly leave out *)
            (* Model[Item, Tips] since we check that separately. Lid spacers go on each plate, so if we can fit the plates *)
            (* we can fit the lid spacers. We assume that we can fit all the lids since we're constrained by plates, not lids. *)
            sampleAndContainerResourceBlobs=Module[
              {allResourcesWithoutInjectionSamples, allResourcesWithoutItems},

              allResourcesWithoutInjectionSamples=If[MatchQ[unitOperationPackets, {PacketP[]..}],
                DeleteDuplicates[
                  Cases[
                    Normal/@KeyDrop[unitOperationPackets, {Replace[PrimaryInjectionSampleLink], Replace[SecondaryInjectionSampleLink], Replace[TertiaryInjectionSample], Replace[QuaternaryInjectionSample]}],
                    _Resource,
                    Infinity
                  ]
                ],
                {}
              ];

              allResourcesWithoutItems=Cases[
                allResourcesWithoutInjectionSamples,
                Resource[
                  KeyValuePattern[{
                    Type->Object[Resource,Sample],
                    Sample->Except[ObjectReferenceP[{
                      Model[Item, Tips],
                      Object[Item, Tips],
                      Model[Item, Consumable],
                      Object[Item, Consumable],
                      Model[Item, Lid],
                      Object[Item, Lid],
                      Model[Item, PlateSeal],
                      Object[Item,PlateSeal],
                      Model[Item, LidSpacer],
                      Object[Item, LidSpacer],
                      Object[Item, MagnetizationRack],
                      Model[Item, MagnetizationRack]
                    }] | ObjectReferenceP[Model[Item,"id:Y0lXejMp6aRV"]]] (*"Hamilton MultiprobeHead tip rack"*)
                  }]
                ]
              ];

              allResourcesWithoutItems
            ];

            samplesAndContainerObjects=Flatten[(
              If[KeyExistsQ[#[[1]], Container],
                Lookup[#[[1]], Container],
                Lookup[#[[1]], Sample]
              ]
            &)/@sampleAndContainerResourceBlobs];

            (* Do we have a ThawCells unit operation? If so, create a map of sample/container resources to the thawing time *)
            (* for each of these samples. This is so that we don't put samples into the same liquid handler adapter if *)
            (* they have different thawing times. *)
            sampleAndContainerResourceBlobToIncubationTimeLookup=If[!MemberQ[unitOperationPackets, PacketP[Object[UnitOperation, ThawCells]]],
              {},
              Module[{thawCellsUnitOperationPackets},
                (* Get the thaw cells unit operation packets. *)
                thawCellsUnitOperationPackets=Cases[unitOperationPackets, PacketP[Object[UnitOperation, ThawCells]]];

                (* Assume that the Times field will always be index matched to the SampleLink field. Use that to create a lookup. *)
                Rule@@@Transpose[{Flatten[Lookup[thawCellsUnitOperationPackets, Replace[SampleLink]]], Flatten[Lookup[thawCellsUnitOperationPackets, Replace[Time]]]}]
              ]
            ];

            (* Gather the models of any requested instruments. *)
            instrumentResourceBlobs=Cases[allResourceBlobs, Resource[KeyValuePattern[Type -> Object[Resource, Instrument]]]];
            instrumentResourceObjects=Download[(Lookup[#[[1]], Instrument]&)/@instrumentResourceBlobs, Object];
            instrumentResourceModels=instrumentResourceObjects/.{
              Rule[
                ObjectP[Cases[instrumentResourceObjects, ObjectP[Object[Instrument]]]],
                Download[Cases[instrumentResourceObjects, ObjectP[Object[Instrument]]], Model[Object]]
              ]
            };

            (* gather instruments from primitive grouping resource blobs *)
            currentPrimitiveGroupingIntegratedInstruments=Download[(Lookup[#[[1]], Instrument]&)/@currentPrimitiveGroupingIntegratedInstrumentsResources, Object];

            (* gather only instrument models from our resources *)
            allInstrumentResourceModels=DeleteDuplicates@Flatten[{
              instrumentResourceModels,
              currentPrimitiveGroupingIntegratedInstruments/. {
                Rule[
                  ObjectP[Cases[Flatten[{instrumentResourceObjects,currentPrimitiveGroupingIntegratedInstruments}], ObjectP[Object[Instrument]]]],
                  Download[Cases[Flatten[{instrumentResourceObjects,currentPrimitiveGroupingIntegratedInstruments}], ObjectP[Object[Instrument]]], Model[Object]]
                ]
              }
            }];

            (* Gather the tip models that we need for this primitive. *)
            tipResourceBlobs=Cases[
              allResourceBlobs,
              Resource[KeyValuePattern[Sample -> LinkP[Model[Item, Tips]]|ObjectReferenceP[Model[Item, Tips]]|LinkP[Model[Item, Consumable]]|ObjectReferenceP[Model[Item, Consumable]]]]
            ]/.{link_Link :> Download[link, Object]};

            (* Further split up samplesAndContainerObjects into samples and not samples. *)
            sampleObjects=Download[Cases[samplesAndContainerObjects, ObjectP[Object[Sample]]], Object];
            nonSampleObjects=Download[UnsortedComplement[samplesAndContainerObjects, sampleObjects], Object];

            (* join the objects we're Downloading from together *)
            objectsToDownloadFrom = Join[
              sampleObjects,
              nonSampleObjects,
              If[MatchQ[unitOperationPackets,{PacketP[]..}],
                Lookup[unitOperationPackets, Object],
                {}
              ]
            ];
            containerModelFieldsList = {Name,Footprint,CoverFootprints,CoverTypes,LiquidHandlerAdapter,HighPrecisionPositionRequired,Dimensions,TareWeight,WellDepth,Positions,MaxVolume,MinVolume};
            (* NOTE: We are assuming here that all of the "non-samples" that we're given will have a Footprint field in their Model. *)
            (* NOTE: We are downloading the simulated version of our unit operation packet here to get the simulated Object[...] *)
            (* of any Model[...] resources that should be created by SimulateResources for us. *)
            (* make the fields that we're downloading from; importantly, don't get Model fields from things that aren't models *)
            fieldsToDownloadFrom = Map[
              Switch[#,
                ObjectP[Object[UnitOperation]],
                {Packet[All]},
                ObjectP[Object[Sample]],
                {
                  Packet[Container, Name],
                  Packet[Container[{Name, Model}]],
                  Packet[Container[Model][containerModelFieldsList]]
                },
                ObjectP[Object[Container]],
                {
                  Packet[Model, KeepCovered, Cover, Name],
                  Packet[Model[containerModelFieldsList]]
                },
                ObjectP[Model[Container]],
                {
                  Packet[Sequence@@containerModelFieldsList]
                },
                _,
                {
                  Packet[
                    Model,
                    Name,
                    Footprint,
                    LiquidHandlerAdapter
                  ],
                  Packet[
                    Model[containerModelFieldsList]
                  ]
                }
              ]&,
              objectsToDownloadFrom
            ];

            resourceCache=Flatten@Quiet[
              Download[
                objectsToDownloadFrom,
                Evaluate[fieldsToDownloadFrom],
                Simulation->currentSimulation,
                Cache->cacheBall
              ],
              {Download::FieldDoesntExist, Download::NotLinkField}
            ];

            cacheBall=FlattenCachePackets[{cacheBall, resourceCache}];

            (* Find all of the footprint of all the containers that we need to place in the work cell for this primitive. *)
            (* Before we calculate the footprint required, we need to combine the resources required across different unit operations and eliminate unnecessary footprints *)
            (* This includes two different cases: *)
            (* 1) Multiple resources of the same Model[Sample] and their total volume still fit in the same container's MaxVolume. We can create one resource and request the total volume *)
            (* 2) Multiple resources require the same incubation parameters and same container model. We can share the same container model but put the resources into different wells *)
            (* Update the resources to include containerName and well to show their possible consolidations with previous resource blobs *)
            updatedSampleAndContainerResourceBlobs=Module[
              {currentPrimitiveGroupingTuples,accumulatedResourceTuples},

              (* Parse the previous resources to be in tuples of {sampleModel,containerModel,containerName,well} *)
              currentPrimitiveGroupingTuples=Map[
                If[
                  And[
                    MatchQ[Lookup[#,Resource],Resource[KeyValuePattern[{Type->Object[Resource,Sample],Sample->ObjectP[Model[Sample]],Amount->VolumeP,Container->ListableP[ObjectP[Model[Container]]],ConsolidateTransferResources->True}]]],
                    (* Make sure the resource blob does not have existing container name. If it has a container name, we should not put new resources into the same container *)
                    !KeyExistsQ[Lookup[#,Resource][[1]],ContainerName],
                    (* We have set ConsolidateTransferResources key as True in transfer if it is to fulfill one Model[Sample] resource and can be combined *)
                    TrueQ[Lookup[Lookup[#,Resource][[1]],ConsolidateTransferResources,False]]
                  ],
                  (* Only care about Model[Sample] resource with a specified container model and volume *)
                  {
                    Download[Lookup[Lookup[#,Resource][[1]],Sample],Object],
                    (* Use the updated container list (instead of the full list from resource blob) *)
                    Lookup[#,ContainerModels],
                    Lookup[Lookup[#,Resource][[1]],SourceTemperature,Null],
                    Lookup[Lookup[#,Resource][[1]],SourceEquilibrationTime,Null],
                    Lookup[Lookup[#,Resource][[1]],MaxSourceEquilibrationTime,Null],
                    Lookup[Lookup[#,Resource][[1]],Amount],
                    Lookup[#,ContainerName],
                    Lookup[#,Well]
                  },
                  Nothing
                ]&,
                currentPrimitiveGroupingFootprints
              ];
              (* Track any new resource with existing resource list too so we don't over-consolidate or use duplicated wells *)
              accumulatedResourceTuples=currentPrimitiveGroupingTuples;

              (* We only perform possible consolidations on sample resources with Container. All other resources will remain unchanged *)
              (* Note that within one primitive, we do NOT have resource with the same Model[Sample] that can be consolidated together because that would have been done within the resource packets of the experiment function *)
              Map[
                Function[
                  {resourceBlob},
                  If[
                    And[
                      MatchQ[resourceBlob,Resource[KeyValuePattern[{Type->Object[Resource,Sample],Sample->ObjectP[Model[Sample]],Amount->VolumeP,Container->ListableP[ObjectP[Model[Container]]],ConsolidateTransferResources->True}]]],
                      (* Make sure the resource blob does not have existing container name. If it has a container name, we should not put new resources into the same container *)
                      !KeyExistsQ[resourceBlob[[1]],ContainerName]
                    ],
                    Module[
                      {containerModels,sampleModel,sourceTemperature,sourceEquilibrationTime,maxSourceEquilibrationTime,volume,accumulatedResourceTuplesMatchingContainerModels,existingSampleModelResourceTuples,existingContainerModelResourceTuples,containerNameVolumeTuples,containerNamePositionTuples,updatedContainerModels,containerName,well,newResourceTuple,updatedAccumulatedResourceTuples},
                      containerModels=ToList[Download[Lookup[resourceBlob[[1]],Container],Object]];
                      (* Get the model of the sample *)
                      sampleModel=Download[Lookup[resourceBlob[[1]],Sample],Object];
                      (* Get the incubation parameters (this has to match for the resources to consolidate or group *)
                      sourceTemperature=Lookup[resourceBlob[[1]],SourceTemperature,Null];
                      sourceEquilibrationTime=Lookup[resourceBlob[[1]],SourceEquilibrationTime,Null];
                      maxSourceEquilibrationTime=Lookup[resourceBlob[[1]],MaxSourceEquilibrationTime,Null];
                      volume=Lookup[resourceBlob[[1]],Amount];

                      (* Get the accumulated resources with at least one matching container model *)
                      accumulatedResourceTuplesMatchingContainerModels=Select[
                        accumulatedResourceTuples,
                        IntersectingQ[#[[2]],containerModels]&
                      ];
                      (* Get the existing resources with the same model and container model. See if we can fit the new volume into the same resource *)
                      existingSampleModelResourceTuples=Cases[accumulatedResourceTuplesMatchingContainerModels,{sampleModel,_,sourceTemperature,sourceEquilibrationTime,maxSourceEquilibrationTime,_,_,_}];
                      (* Get the existing resources with the same container model and incubation parameters see if it has more position for new resource *)
                      existingContainerModelResourceTuples=Cases[accumulatedResourceTuplesMatchingContainerModels,{_,_,sourceTemperature,sourceEquilibrationTime,maxSourceEquilibrationTime,_,_,_}];

                      (* Group the existing resource tuples by ContainerName and Well. If we consolidate some of the previous resources, we have assigned the same well and will need to add the volumes together *)
                      containerNameVolumeTuples=Map[
                        Function[
                          {resourceTupleGroup},
                          Module[
                            {totalVolume,commonContainers,containerModelPackets,containerMaxVolumes,containerMinVolumes,sourceContainerDeadVolumes,qualifiedContainers},
                            totalVolume=Total[Flatten[{resourceTupleGroup[[All,-3]],volume}]];
                            commonContainers=UnsortedIntersection[containerModels,resourceTupleGroup[[1,2]]];
                            containerModelPackets=fetchPacketFromCache[#,resourceCache]&/@commonContainers;
                            containerMaxVolumes=Lookup[containerModelPackets,MaxVolume,Null];
                            containerMinVolumes=Lookup[containerModelPackets,MinVolume,Null];
                            (* Get the dead volume of the container *)
                            (* use the MinVolume of the container as the required dead volume. If not available, use 10% of max volume *)
                            sourceContainerDeadVolumes=MapThread[
                              If[!NullQ[#2],
                                #2,
                                0.1 * #1
                              ]&,
                              {containerMaxVolumes,containerMinVolumes}
                            ];

                            (* Select the large enough container model(s) *)
                            qualifiedContainers=MapThread[
                              If[TrueQ[(totalVolume+#3)<#2],
                                #1,
                                Nothing
                              ]&,
                              {commonContainers,containerMaxVolumes,sourceContainerDeadVolumes}
                            ];

                            If[Length[qualifiedContainers]==0,
                              (* Do no track if the volume is too large for all models *)
                              Nothing,
                              (* Track the total volume, updated container models and containerName/well tuple  *)
                              {totalVolume,qualifiedContainers,resourceTupleGroup[[1,-2]],resourceTupleGroup[[1,-1]]}
                            ]
                          ]
                        ],
                        GatherBy[existingSampleModelResourceTuples,(#[[-2;;-1]])&]
                      ];

                      containerNamePositionTuples=Map[
                        Function[
                          {resourceTupleGroup},
                          Module[
                            {commonContainers,containerModelPackets,containerPositions,occupiedPositions,qualifiedContainers,emptyPosition},
                            commonContainers=UnsortedIntersection[containerModels,resourceTupleGroup[[1,2]]];
                            containerModelPackets=fetchPacketFromCache[#,resourceCache]&/@commonContainers;
                            containerPositions=Lookup[containerModelPackets,Positions,{}];

                            (* Get the positions occupied *)
                            occupiedPositions=DeleteDuplicates[resourceTupleGroup[[All,-1]]];

                            (* Select the large enough container model(s) and track container model and first open position *)
                            qualifiedContainers=MapThread[
                              If[MatchQ[Complement[Lookup[#2,Name,{}],occupiedPositions],{}],
                                Nothing,
                                {#1,Sort@Complement[Lookup[#2,Name,{}],occupiedPositions]}
                              ]&,
                              {commonContainers,containerPositions}
                            ];

                            (* We always fill resource containers in sorted order so select the common empty position of all container models to use *)
                            emptyPosition=If[Length[qualifiedContainers]>0,
                              First[Intersection@@(qualifiedContainers[[All,2]])],
                              Null
                            ];

                            If[Length[qualifiedContainers]==0,
                              (* Do no track if the volume is too large for all models *)
                              Nothing,
                              (* Track the first open position, updated container models and containerName/well tuple  *)
                              {qualifiedContainers[[All,1]],emptyPosition,resourceTupleGroup[[1,-2]]}
                            ]
                          ]
                        ],
                        GatherBy[existingContainerModelResourceTuples,(#[[-2]])&]
                      ];

                      (* Select the existing resource position to consolidate or create a new one *)
                      {updatedContainerModels,containerName,well}=Which[
                        Length[containerNameVolumeTuples]>0,
                        (* Select the resource position that prepares largest volume to get the best efficiency for resouce consolidation *)
                        ReverseSortBy[containerNameVolumeTuples,First][[1,2;;4]],
                        Length[containerNamePositionTuples]>0,
                        (* Use the first possible position *)
                        {containerNamePositionTuples[[1,1]],containerNamePositionTuples[[1,3]],containerNamePositionTuples[[1,2]]},
                        True,
                        (* Use a UUID and "A1" position for new resource *)
                        {containerModels,CreateUUID[],"A1"}
                      ];

                      (* create the new resource tuple to be tracked and also return the updated *)
                      newResourceTuple={sampleModel,updatedContainerModels,sourceTemperature,sourceEquilibrationTime,maxSourceEquilibrationTime,volume,containerName,well};

                      (* Update the accumulated resource tuple list to reflect updated containerModels for the same containerName *)
                      updatedAccumulatedResourceTuples=ReplacePart[
                        accumulatedResourceTuples,
                        ({#,2}->updatedContainerModels)&/@Flatten[Position[accumulatedResourceTuples,{___,containerName,_}]]
                      ];

                      accumulatedResourceTuples=Append[updatedAccumulatedResourceTuples,newResourceTuple];
                      {resourceBlob,updatedContainerModels,containerName,well}
                    ],
                    (* Other resource blobs remain unchanged *)
                    {resourceBlob,Lookup[resourceBlob[[1]],Container,{}],CreateUUID[],Null}
                  ]
                ],
                sampleAndContainerResourceBlobs
              ]
            ];

            (* NOTE: This is in the format: *)
            (*
              {
                {
                  containerFootprint:FootprintP,
                  liquidHandlerAdapter:(ObjectP[Model[Container, Rack]]|Null),
                  container:ObjectP[Object[Container]],
                  resource:ResourceP,
                  highPrecisionPositionContainer:Boolean,
                  (* to track future resource consolidation *)
                  index,
                  (* to show the container grouping/resource consolidation *)
                  (* this containerModels is the updates possible list of containers, with small containers (MaxVolume < consolidated volume) removed *)
                  containerModels,
                  containerName,
                  well,
                  (* NOTE: This is only populated for resources that are coming out of a ThawCells unit operation since *)
                  (* we don't want to group together vials on the same liquid handler adapter if they should be thawed *)
                  (* for different amounts of time. *)
                  incubationTime:(TimeP|Null)
                }..
              }.
            *)
            currentFootprintResult=Map[
              Function[{resourceContainerNameTuple},
                Module[{container,resource,containerModels,containerName,well},
                  {resource,containerModels,containerName,well}=resourceContainerNameTuple;
                  (* Get the container of the sample. *)
                  container=Which[
                    !MatchQ[containerModels,{}],
                    (* Use the first possible container for footprint purpose *)
                    First[containerModels],
                    !MatchQ[resource,Resource[KeyValuePattern[Type->Object[Resource,Sample]]]],
                    Null,
                    KeyExistsQ[resource[[1]],Container],
                    (* Container in resource can be a list but we limit them to have the same footprint in UO resolvers *)
                    First[ToList[Download[Lookup[resource[[1]],Container],Object]]],
                    MatchQ[Lookup[resource[[1]],Sample],ObjectP[Object[Sample]]],
                    Download[
                      Lookup[fetchPacketFromCache[Lookup[resource[[1]],Sample],resourceCache],Container],
                      Object
                    ],
                    MatchQ[Lookup[resource[[1]],Sample],ObjectP[{Object[],Model[]}]],
                    Download[Lookup[resource[[1]],Sample],Object],
                    True,
                    Null
                  ];

                  Module[{containerModelPacket,footprint,liquidHandlerAdapter,highPrecisionPositionRequired},
                    (* Get the packet of the container model. *)
                    containerModelPacket=Which[
                      MatchQ[container,ObjectP[{Object[Container],Object[Item]}]],
                      fetchPacketFromCache[
                        Lookup[fetchPacketFromCache[container,resourceCache],Model],
                        resourceCache
                      ],
                      MatchQ[container,ObjectP[{Model[Container],Model[Item]}]],
                      fetchPacketFromCache[container,resourceCache],
                      True,
                      Null
                    ];

                    (* Get the direct footprint of the container model. *)
                    footprint=If[NullQ[containerModelPacket],
                      Null,
                      Lookup[containerModelPacket,Footprint]
                    ];

                    (* Get the footprint of the liquid handler adapter (if we need to use one). *)
                    liquidHandlerAdapter=If[NullQ[containerModelPacket],
                      Null,
                      Download[Lookup[containerModelPacket,LiquidHandlerAdapter],Object]/.{$Failed->Null}
                    ];

                    (* Get the precision boolean of the container model. *)
                    highPrecisionPositionRequired=If[NullQ[containerModelPacket],
                      Null,
                      Lookup[containerModelPacket,HighPrecisionPositionRequired]/.{($Failed|_Missing)->Null}
                    ];

                    Which[
                      (* Don't include resources for simulated containers since these simulated containers are already *)
                      (* counted for by the Model[Container] resources that were made by upstream primitives. *)
                      MatchQ[container,ObjectP[Object[]]] && MemberQ[Lookup[currentSimulation[[1]], SimulatedObjects], container],
                        Nothing,
                      MatchQ[container,ObjectP[Object[]]],
                        AssociationThread[
                          footprintInformationKeys,
                          {
                            footprint,
                            liquidHandlerAdapter,
                            Download[container,Object],
                            resource,
                            highPrecisionPositionRequired,
                            index,
                            containerModels,
                            containerName,
                            well,
                            Lookup[sampleAndContainerResourceBlobToIncubationTimeLookup, resource, Null]
                          }
                        ],
                      (* We do not use simulated object for counterweights since we are going to do 1 counterweight object per model *)
                      MatchQ[container,ObjectP[Model[Item,Counterweight]]],
                        AssociationThread[
                          footprintInformationKeys,
                          {
                            footprint,
                            liquidHandlerAdapter,
                            Download[container,Object],
                            resource,
                            highPrecisionPositionRequired,
                            index,
                            containerModels,
                            containerName,
                            well,
                            Lookup[sampleAndContainerResourceBlobToIncubationTimeLookup, resource, Null]
                          }
                        ],
                      MatchQ[container,ObjectP[Model[]]],
                        AssociationThread[
                          footprintInformationKeys,
                          {
                            footprint,
                            liquidHandlerAdapter,
                            (* NOTE: If we have a Model[...], lookup its simulated Object[...] from the simulation. *)
                            (* This is the Object[...] that will be used in future resource requests. *)
                            Module[{unitOperationPacketWithResource,position,simulatedObject},
                              (* Find which unit operation packet (we may have multiple due to unit operation "subs") our *)
                              (* resource is in. *)
                              unitOperationPacketWithResource=FirstCase[unitOperationPackets,_?(MemberQ[Normal[#],resource,Infinity]&)];

                              (* Figure out what field our resource is in. *)
                              (* NOTE: We're going to find where our resource was because we did a Cases[...] of our *)
                              (* unit operation packet to get the resources in the first place. *)
                              position=FirstPosition[unitOperationPacketWithResource,resource,$Failed]/.{Replace[x_]:>x};

                              (* Get the simulated version of our resource from the SimulateResource'd simulated *)
                              (* unit operation. *)
                              simulatedObject=Extract[
                                fetchPacketFromCache[Lookup[unitOperationPacketWithResource,Object],cacheBall],
                                position
                              ];

                              Download[simulatedObject,Object]
                            ],
                            resource,
                            highPrecisionPositionRequired,
                            index,
                            containerModels,
                            containerName,
                            well,
                            Lookup[sampleAndContainerResourceBlobToIncubationTimeLookup, resource, Null]
                          }
                        ],
                      True,
                        Nothing
                    ]
                  ]
                ]
              ],
              updatedSampleAndContainerResourceBlobs
            ];

            (* Merge footprint results that show up multiple times that are the same but just have different incubation times. *)
            (* Pick the longest incubation time when merging if there are multiple. *)
            currentFootprintResult=(Module[{times},
              times=Cases[Lookup[#,IncubationTime], TimeP];

              If[Length[times]==0,
                Join[First[#], <|IncubationTime->Null|>],
                Join[First[#], <|IncubationTime->Max[times]|>]
              ]
            ]&)/@GatherBy[currentFootprintResult, KeyDrop[#,IncubationTime]&];

            (* Remove any duplicates (same object or same container name) from the current primitive's footprint result *)
            currentFootprintResultNoDuplicates=DeleteDuplicatesBy[
              DeleteDuplicatesBy[currentFootprintResult, (Lookup[#,Container]&)],
              (Lookup[#,ContainerName]&)
            ];

            (* Remove any footprints that are already in the workcell from a previous primitive. *)
            (* This can be the same container object (sample ID or container ID), or the same containerName *)
            newFootprintResult=Select[
              currentFootprintResult,
              (And[
                !MemberQ[Lookup[currentPrimitiveGroupingFootprints,Container,{}], Lookup[#,Container]],
                !MemberQ[Lookup[currentPrimitiveGroupingFootprints,ContainerName,{}], Lookup[#,ContainerName]]
              ]&)
            ];
            (* Get rid of any duplicates from the new container list. *)
            newFootprintResultNoDuplicates=DeleteDuplicatesBy[
              DeleteDuplicatesBy[newFootprintResult, (Lookup[#,Container]&)],
              (Lookup[#,ContainerName]&)
            ];

            (* Join this with our existing footprints. *)
            allFootprintResult=Join[newFootprintResultNoDuplicates, currentPrimitiveGroupingFootprints];

            (* DeleteDuplicates by the container and resource ID. *)
            (* NOTE: We are effectively LEAVING OUT some of our label->footprint rules here because you can have a label *)
            (* for the sample and a label for the container and we only want to count the footprint once. *)
            newFootprintTally=tallyFootprints[allFootprintResult];

            (* Append a plate footprint to newFootprintTally if there is a Model[Item,MagnetizationRack] or Object[Item,MagnetizationRack] *)
            (* Anywhere in the previous resources *)
            currentPrimitiveGroupingResourceBlobs = Cases[currentPrimitiveGroupingUnitOperationPackets,_Resource,Infinity];

            (* Get the MagnetizationRack resource blobs *)
            currentPrimitiveGroupingMagnetizationRackResourceBlobs=Cases[currentPrimitiveGroupingResourceBlobs,KeyValuePattern[Sample -> LinkP[Model[Item, MagnetizationRack]]|ObjectReferenceP[Model[Item, MagnetizationRack]]]];
            (* If there is a magnetization rack resource blob, increment the counter of footprint Plate in newFootprintTally by 1 *)
            (* Otherwise do nothing *)
            newFootprintTally=If[!MatchQ[currentPrimitiveGroupingMagnetizationRackResourceBlobs,{}],
              If[MemberQ[newFootprintTally,{Plate,_Integer}],
                newFootprintTally/.{Plate,x_Integer}:>{Plate,x+1},
                Append[newFootprintTally,{Plate,1}]
              ],
              newFootprintTally
            ];
            (* Also count for only this primitive just in case we need to start a new protocol in the script here *)
            singlePrimitiveFootprintTally=tallyFootprints[currentFootprintResultNoDuplicates];

            (* Do the same append to this variable if there is a Model[Item,MagnetizationRack] or Object[Item,MagnetizationRack] *)
            (* Anywhere in the current uo resources *)
            currentUOResourceBlobs = Cases[unitOperationPackets,_Resource,Infinity];

            (* Get the MagnetizationRack resource blobs *)
            currentUOMagnetizationRackResourceBlobs=Cases[currentUOResourceBlobs,KeyValuePattern[Sample -> LinkP[Model[Item, MagnetizationRack]]|ObjectReferenceP[Model[Item, MagnetizationRack]]]];
            (* If there is a magnetization rack resource blob, increment the counter of footprint Plate in newFootprintTally by 1 *)
            (* Otherwise do nothing *)
            singlePrimitiveFootprintTally=If[!MatchQ[currentUOMagnetizationRackResourceBlobs,{}],
              If[MemberQ[singlePrimitiveFootprintTally,{Plate,_Integer}],
                singlePrimitiveFootprintTally/.{Plate,x_Integer}:>{Plate,x+1},
                Append[singlePrimitiveFootprintTally,{Plate,1}]
              ],
              singlePrimitiveFootprintTally
            ];

            (* Get a list of all of tip resources that we need. *)
            allTipResources=Flatten[{tipResourceBlobs, currentPrimitiveGroupingTips}];

            (* Figure out the number of stacked and non-stacked tips that we're going to have in the form of *)
            (* {{ObjectP[Model[Item, Tip]], tipCountRequired_Integer}..} *)
            {flattenedStackedTipTuples, flattenedNonStackedTipTuples}=partitionTips[tipModelPackets, allTipResources, currentPrimitiveGrouping];
            {singlePrimitiveFlattenedStackedTipTuples, singlePrimitiveFlattenedNonStackedTipTuples}=partitionTips[tipModelPackets, tipResourceBlobs, {resolvedPrimitive}];

            (* -- Compute the starting positions (Ambient or Incubator) of our new containers with Footprint->Plate. -- *)
            (* NOTE: In order to do this, for our current primitive grouping (with our new primitive added), we need to *)
            (* compute the starting positions of the containers (Incubator or Ambient) based on if they have cells in *)
            (* them. Then, we need to march through the idling condition history to make sure that we don't run out of *)
            (* Ambient or Incubator positions. *)

            (* NOTE: We only care about containers that have a Plate footprint (taking into account adapters as well) because *)
            (* these are the only types of containers that we can move around on the deck. Everything else will stay where *)
            (* it is originally placed. *)

            (* NOTE: Any Model[Container]s must start off Ambient because they cannot have cells in them. *)
            (* NOTE: We also want to download the CellType from these containers BEFORE any simulation occurs. *)

            (* Filter out to only care about plates or vessels that have adapters (that will make them into plates). *)
            newPlateFootprintResult=Cases[newFootprintResultNoDuplicates, KeyValuePattern[{Footprint->Plate,LiquidHandlerAdapter->Except[Null]}]];

            objectContainersFromResourcesExistQ=If[MatchQ[$CurrentSimulation, SimulationP],
              Module[{allSimulatedObjects},
                allSimulatedObjects=Join[Lookup[$CurrentSimulation[[1]], SimulatedObjects], Lookup[currentSimulation[[1]], SimulatedObjects]];

                (!MemberQ[allSimulatedObjects, #]&)/@Lookup[newPlateFootprintResult,Container,{}]
              ],
              (!MemberQ[Lookup[currentSimulation[[1]], SimulatedObjects], #]&)/@Lookup[newPlateFootprintResult,Container,{}]
            ];

            objectContainerPacketsFromResource=Quiet[
              Download[
                PickList[Lookup[newPlateFootprintResult,Container,{}], objectContainersFromResourcesExistQ, True],
                Packet[Contents[[All,2]][{CellType}]]
              ],
              {Download::FieldDoesntExist, Download::NotLinkField}
            ];

            (* Separate out the containers that should go on deck from the containers that should go in the incubator. *)

            (* Containers that go into the incubator must be Object[Container]s (in order to previously have cells in them). *)
            (* And must already exist in the database. *)
            incubatorPlateResources=Select[
              Transpose[{
                PickList[Lookup[newPlateFootprintResult,Resource,{}], objectContainersFromResourcesExistQ, True],
                objectContainerPacketsFromResource
              }],
              Not[MatchQ[#[[2]], $Failed]] && MemberQ[Lookup[Flatten[#[[2]]], CellType, Null], Except[Null|$Failed]]&
            ][[All, 1]];

            (* The ambient containers are the ones that we're not putting in the incubator. *)
            ambientPlateResources=DeleteDuplicates@Join[
              (* The rest of the Object[Container]s that actually exist that aren't going into the incubator. *)
              UnsortedComplement[
                PickList[Lookup[newPlateFootprintResult,Resource,{}], objectContainersFromResourcesExistQ, True],
                incubatorPlateResources
              ],
              (* Plus any Model[Container] resources. *)
              Cases[Lookup[newPlateFootprintResult,Resource,{}], KeyValuePattern[Sample->ObjectP[Model[Container]]]]
            ];

            (* Get the Object[Container]s (some may be simulated) that correspond to all our starting incubator/ambient *)
            (* containers. *)
            (* NOTE: We're filtering out containers that need an adapter here. *)
            startingIncubatorContainers=(
              Lookup[FirstCase[allFootprintResult, KeyValuePattern[{LiquidHandlerAdapter->Null,Resource->#}],{}],Container,Nothing]
            &)/@Join[currentPrimitiveGroupingIncubatorPlateResources, incubatorPlateResources];
            startingAmbientContainers=(
              Lookup[FirstCase[allFootprintResult, KeyValuePattern[{LiquidHandlerAdapter->Null,Resource->#}],{}],Container,Nothing]
            &)/@Join[currentPrimitiveGroupingAmbientPlateResources, ambientPlateResources];
            (*which containers require high Precision*)
            highPrecisionPositionContainersBools=allFootprintResult[[All,5]];

            (* Repeat for this only primitive *)
            (* This should use currentFootprintResultNoDuplicates instead of newFootprintResultNoDuplicates because we use these only when starting a new group, where the old footprint were no longer part of the same protocol and new footprint should have all that are used in this primitive *)
            singlePrimitiveStartingIncubatorContainers=(
              Lookup[FirstCase[currentFootprintResultNoDuplicates, KeyValuePattern[{LiquidHandlerAdapter->Null,Resource->#}],{}],Container,Nothing]
            &)/@Join[currentPrimitiveGroupingIncubatorPlateResources, incubatorPlateResources];
            singlePrimitiveStartingAmbientContainers=(
              Lookup[FirstCase[currentFootprintResultNoDuplicates, KeyValuePattern[{LiquidHandlerAdapter->Null,Resource->#}],{}],Container,Nothing]
            &)/@Join[currentPrimitiveGroupingAmbientPlateResources, ambientPlateResources];
            (*which containers require high Precision*)
            singlePrimitiveHighPrecisionPositionContainersBools=Lookup[currentFootprintResultNoDuplicates,HighPrecisionPositionRequired,{}];

            (* Get the Object[Container]s that must be OnDeck/Incubator because we're going to use them in our primitive. *)
            (* NOTE: This is slightly incorrect because we're assuming that no single primitive can exceed the on deck *)
            (* capacity. That is, we're treating Ambient the same as OnDeck. *)
            (* NOTE: Object[UnitOperation, IncubateCells] is the only unit operation that can put containers INTO the incubator. *)
            workCellIdlingConditions=If[MatchQ[Lookup[FirstOrDefault[unitOperationPackets,{}], Object], ObjectP[Object[UnitOperation, IncubateCells]]],
              (* Assume that everything that is required by IncubateCells and is Footprint->Plate will end up going into the incubator. *)
              Join[
                (#->Incubator&)/@Cases[currentFootprintResult, {Plate, ___}][[All,3]],
                (#->Ambient&)/@Cases[currentFootprintResult, {Except[Plate], ___}][[All,3]]
              ],
              (#->Ambient&)/@currentFootprintResult[[All,3]]
            ];
            (* If we've already have a list of potential instruments, then work to whittle down that list and see if we *)
            (* can fit in this primitive. Otherwise, start with our full list. *)
            filteredInstruments=filterInstruments[
              Which[
                MatchQ[requestedInstrument,ObjectP[{Model[Instrument], Object[Instrument]}]],
                  {requestedInstrument},
                MatchQ[currentPrimitiveGroupingPotentialWorkCellInstruments, {ObjectP[{Model[Instrument], Object[Instrument]}]..}],
                  currentPrimitiveGroupingPotentialWorkCellInstruments,
                True,
                  Lookup[$WorkCellsToInstruments, Lookup[resolvedPrimitive[[1]], WorkCell]]
              ],
              newFootprintTally,
              startingAmbientContainers,
              startingIncubatorContainers,
              Join[currentPrimitiveGroupingWorkCellIdlingConditionHistory, workCellIdlingConditions],
              Length[flattenedStackedTipTuples],
              Length[flattenedNonStackedTipTuples],
              allInstrumentResourceModels,
              highPrecisionPositionContainersBools,
              Flatten[{workCellObjectPackets, workCellModelPackets}],
              tipAdapterUsedQ
            ];


            Which[
              (* If we have instruments that can perform this primitive (along with the rest of the primitives in our *)
              (* current group), just update the instrument list. *)
              Length[filteredInstruments]>0,
               currentPrimitiveGroupingPotentialWorkCellInstruments=If[MatchQ[resolvedPrimitive, $DummyPrimitiveP],
                 currentPrimitiveGroupingPotentialWorkCellInstruments,
                 filteredInstruments
               ],

              (* OTHERWISE: There are no instruments to fit all of our primitives, plus our current primitive, on deck. *)

              (* Is the user forcing us to put this primitive into the current method index group? *)
              MatchQ[primitiveMethodIndex, Except[Automatic]],
                (* Don't update the instrument list, just log an error. *)
                Message[
                  Error::NoWorkCellsPossibleForUnitOperation,
                  Head[resolvedPrimitive],
                  index,
                  tallyFootprints[newFootprintResultNoDuplicates],
                  ObjectToString[DeleteDuplicates[instrumentResourceModels], Cache->cacheBall],
                  Length[tipResourceBlobs],
                  newFootprintTally,
                  ObjectToString[allInstrumentResourceModels, Cache->cacheBall],
                  Length[flattenedStackedTipTuples],
                  ObjectToString[flattenedStackedTipTuples[[All,1]], Cache->tipModelPackets],

                  (* NOTE: If we're using a tip adapter, we will be using 1 more non-stacked tip position, which can cause the deck to not fit our tips. *)
                  If[tipAdapterUsedQ,
                    Length[flattenedNonStackedTipTuples]+1,
                    Length[flattenedNonStackedTipTuples]
                  ],
                  If[tipAdapterUsedQ,
                    ObjectToString[Append[flattenedNonStackedTipTuples[[All,1]], Model[Item, "Hamilton 96 MultiProbeHead Tip Adapter (Used for NxM shifted pipetting)"]], Cache->tipModelPackets],
                    ObjectToString[flattenedNonStackedTipTuples[[All,1]], Cache->tipModelPackets]
                  ]
                ];
                AppendTo[noInstrumentsPossibleErrorsWithIndices, {Head[resolvedPrimitive], index, primitive}],

              (* If we aren't able to put this primitive on deck due to capacity requirements and the user isn't forcing *)
              (* us to put the primitive in a certain group (PrimitiveMethodIndex), then start a new group. *)
              True,
               Module[{filteredInstrumentsStartingFromFullList},
                (* Start a new grouping. *)
                startNewPrimitiveGrouping[];

                (* Start from our FULL list of instruments for our work cell, then whittle it down again. *)
                filteredInstrumentsStartingFromFullList=filterInstruments[
                  If[MatchQ[requestedInstrument,ObjectP[{Model[Instrument], Object[Instrument]}]],
                    {requestedInstrument},
                    Lookup[$WorkCellsToInstruments, Lookup[resolvedPrimitive[[1]], WorkCell]]
                  ],
                  singlePrimitiveFootprintTally,
                  singlePrimitiveStartingAmbientContainers,
                  singlePrimitiveStartingIncubatorContainers,
                  workCellIdlingConditions,
                  Length[singlePrimitiveFlattenedStackedTipTuples],
                  Length[singlePrimitiveFlattenedNonStackedTipTuples],
                  allInstrumentResourceModels,
                  singlePrimitiveHighPrecisionPositionContainersBools,
                  Flatten[{workCellObjectPackets,workCellModelPackets}],
                  (* this is for the Tip Adapter, since we are starting a new group, we can't have one yet*)
                  tipAdapterUsedQ
                ];
                (* If we STILL don't have any instruments that we can use, make sure to record an error and just *)
                (* use all instruments for resolving. *)
                currentPrimitiveGroupingPotentialWorkCellInstruments=If[Length[filteredInstrumentsStartingFromFullList]==0,
                   Message[
                     Error::NoWorkCellsPossibleForUnitOperation,
                     Head[resolvedPrimitive],
                     index,
                     tallyFootprints[currentFootprintResultNoDuplicates],
                     ObjectToString[instrumentResourceModels, Cache->cacheBall],
                     Length[tipResourceBlobs],
                     newFootprintTally,
                     ObjectToString[allInstrumentResourceModels, Cache->cacheBall],
                     Length[flattenedStackedTipTuples],
                     ObjectToString[flattenedStackedTipTuples[[All,1]], Cache->tipModelPackets],
                     Length[flattenedNonStackedTipTuples],
                     ObjectToString[flattenedNonStackedTipTuples[[All,1]], Cache->tipModelPackets]
                   ];

                  (* NOTE: We still append here so that we can keep track of our invalid inputs. *)
                  AppendTo[noInstrumentsPossibleErrorsWithIndices, {Head[resolvedPrimitive], index, primitive}];

                   If[MatchQ[requestedInstrument,ObjectP[{Model[Instrument], Object[Instrument]}]],
                     {requestedInstrument},
                     Lookup[$WorkCellsToInstruments, Lookup[resolvedPrimitive[[1]], WorkCell]]
                   ],
                  filteredInstrumentsStartingFromFullList
                ];
              ]
            ];

            (* Fill out our new grouping with our primitive information. *)
            AppendTo[currentPrimitiveGrouping, resolvedPrimitive];
            AppendTo[currentUnresolvedPrimitiveGrouping, Head[primitive]@KeyDrop[primitive[[1]], {PrimitiveMethod, PrimitiveMethodIndex, WorkCell}]];
            AppendTo[currentPrimitiveInputGrouping, inputsWithNoSimulatedObjects];
            (* If we are in a subprotocol, export all resolved options to RSP here in currentPrimitiveOptionGrouping (and then in allPrimitiveOptionGroupings) for our final script. *)
            (* We do not do this for stand-alone user-submitted script so that it matches the exact input from the user and we do not need the generated labels (described below) anywhere else *)
            (* This is necessary for subprotocol script when it is used as the sample prep for PreparatoryUnitOperations. *)
            (* When the PrepUOs are calculated for an experiment, we generate necessary automatic labels in our resolved options. The automatic labels are unique across the entire UOs (script) *)
            (* For example, we may have RSP-MSP-RSP UOs as part of the script and each does 2 transfers. Then our labels will be like "transfer destination sample 1" & "2" in first RSP UO, "3" & "4" in MSP UO and "5" & "6" in the last RSP UO *)
            (* If the corresponding labels are used in the main experiment, they show up in the PreparedSamples field of the protocol *)
            (* For example, we may have "myPlate" as the experiment input and "myPlate" has a transferred sample in the PrepUOs with an automatic label "transfer destination sample 6". The PreparedSamples field will list it as {"transfer destination sample 6", SamplesIn, 1, Null, Null} *)
            (* Here, the plate label "myPlate" is specified by the user but its content sample's label "transfer destination sample 6" is generated automatically by Transfer *)
            (* When the script is generated, it becomes 3 separate protocols (RSP-MSP-RSP), if the resolved labels are not feeded into the script, it has no memory of the previous labels when each individual SP protocol is generated. *)
            (* We must make sure the SAME labels are used in the real experiment protocols so we can associate the main experiment's PreparedSamples with the sample prep protocol *)
            If[MatchQ[parentProtocol,ObjectP[]],
              AppendTo[currentPrimitiveOptionGrouping, resolvedCorrectedOptions],
              AppendTo[currentPrimitiveOptionGrouping, optionsWithNoSimulatedObjectsIndexMatchingToSample]
            ];
            AppendTo[currentPrimitiveGroupingRunTimes, runTimeEstimate];
            currentPrimitiveGroupingAmbientPlateResources=Join[currentPrimitiveGroupingAmbientPlateResources, ambientPlateResources];
            currentPrimitiveGroupingIncubatorPlateResources=Join[currentPrimitiveGroupingIncubatorPlateResources, incubatorPlateResources];
            currentPrimitiveGroupingWorkCellIdlingConditionHistory=Join[currentPrimitiveGroupingWorkCellIdlingConditionHistory, workCellIdlingConditions];
            currentPrimitiveGroupingFootprints=Join[currentPrimitiveGroupingFootprints, newFootprintResultNoDuplicates];
            currentPrimitiveGroupingTips=Join[currentPrimitiveGroupingTips, tipResourceBlobs];
            currentPrimitiveGroupingIntegratedInstrumentsResources=Join[currentPrimitiveGroupingIntegratedInstrumentsResources, instrumentResourceBlobs];
            currentPrimitiveGroupingLabeledObjects=Join[currentPrimitiveGroupingLabeledObjects, newLabeledObjectsLookup];
            currentPrimitiveGroupingUnitOperationPackets=Append[currentPrimitiveGroupingUnitOperationPackets, unitOperationPackets];
            currentPrimitiveGroupingBatchedUnitOperationPackets=Append[currentPrimitiveGroupingBatchedUnitOperationPackets, batchedUnitOperationPackets];

            (* Add our primitive index. *)
            currentLabelFieldsWithIndices=Join[
              currentLabelFieldsWithIndices,
              (#[[1]]->LabelField[#[[2]], index]&)/@newLabelFields
            ];

            (* Are we supposed to optimize our robotic keep covered? *)
            If[MatchQ[optimizeUnitOperations, True] && index>1 && !MatchQ[coverOptimizedPrimitives[[index-1]], _Cover],
              Module[{containerPackets, keepCoveredContainers, filteredKeepCoveredContainers},
                (* See if we have any Object[Container]s from this latest unit operation packet that have KeepCovered->True. *)
                containerPackets=Cases[resourceCache, PacketP[Object[Container]]];
                keepCoveredContainers=Cases[
                  containerPackets,
                  KeyValuePattern[{
                    KeepCovered->True,
                    Cover->Null
                  }]
                ];

                (* Make sure that these containers can be covered with the universal lid. *)
                filteredKeepCoveredContainers=PickList[
                  keepCoveredContainers,
                  (fetchPacketFromCache[Lookup[#, Model], resourceCache]&)/@keepCoveredContainers,
                  KeyValuePattern[{CoverFootprints->{___, LidSBSUniversal, ___}, CoverTypes->{___, Place, ___}}]
                ];

                (* Convert any simulated objects to their labels. *)
                If[Length[filteredKeepCoveredContainers]>0,
                  coverOptimizedPrimitives=Insert[
                    coverOptimizedPrimitives,
                    Cover[Sample->Lookup[filteredKeepCoveredContainers, Object]/.simulatedObjectsToLabel, Preparation->Robotic],
                    index+1
                  ]
                ];
              ]
            ];
          ]
      ];

      (* Return our resolved primitive. *)
      AppendTo[resolvedPrimitives, resolvedPrimitive];

      (* If we're at the end of our list of primitives, make sure to clean up our current primitive group. *)
      If[index==Length[coverOptimizedPrimitives],
        startNewPrimitiveGrouping[True];
      ];

      (* Increment our index. *)
      index=index+1;
    ]
  ];

  (* Resolving is over. End our unique label session. *)
  (* In cases where a unit operation uses other unit ops inside it (Ex. MBS creates Transfer unit ops) we don't want to *)
  (* reset the label session because then duplicate labels will be created *)
  If[!unitOperationPacketsQ,
    EndUniqueLabelsSession[];
  ];

  (* if we are resolving all of this for another function, make sure to update the currentSimulation to de-reference the correct index of the OutputUnitOperation *)
  If[
    unitOperationPacketsQ,
    $PrimitiveFrameworkIndexedLabelCache=Flatten@allLabelFieldsWithIndicesGroupings;
  ];

  (* get all the tips resources *)
  tipResources = Select[Flatten[nonObjectResources], MatchQ[#[Sample], ObjectP[Model[Item, Tips]]] && IntegerQ[#[Amount]]&];
  counterWeightResources = Select[Flatten[nonObjectResources], MatchQ[#[Sample], ObjectP[Model[Item, Counterweight]]]&];
  nonTipResources = DeleteCases[Flatten[nonObjectResources], Alternatives @@ tipResources];

  (* combine the tip resources together, but only up to 96 at a time  *)
  gatheredTipResources = GatherBy[tipResources, #[Sample]&];
  combinedTipResources = Map[
    Function[{resources},
      Module[{resourceSample, tipAmount, partitionedTipAmount},

        resourceSample = resources[[1]][Sample];
        tipAmount = Total[Cases[#[Amount]& /@ resources, _Integer]];
        partitionedTipAmount = Flatten[{
          ConstantArray[96, Quotient[tipAmount, 96]],
          Mod[tipAmount, 96]
        }];

        Map[
          Resource[
            Sample -> resourceSample,
            Amount -> #,
            Name -> ToString[Unique[]]
          ]&,
          partitionedTipAmount
        ]
      ]
    ],
    gatheredTipResources
  ];

  (* combine the counter weight resources together, one per model only *)
  (* this is valid on robotic because the robotic centrifuges only have two positions, meaning that only 1 counterweight is needed at a time *)
  (* centrifuge resources are created in Centrifuge UOs and only created for robotic UOs *)
  uniqueCounterweightResources=Map[
    (#->Resource[Sample->#,Name->CreateUUID[]])&,
    DeleteDuplicates[Download[Lookup[counterWeightResources[[All,1]],Sample,{}],Object]]
  ];
  combinedCounterWeightResources=Download[Lookup[counterWeightResources[[All,1]],Sample,{}],Object]/.uniqueCounterweightResources;
  counterWeightResourceReplacementRules=Normal[AssociationThread[counterWeightResources,combinedCounterWeightResources]];

  (* call FRQ on all the accumulated resource blobs that we've gathered in the MapThread *)
  (* if UnitOperationPackets -> True, then we aren't calling FRQ because the function that called it will do it instead *)
  {accumulatedFulfillableResourceQ, accumulatedFRQTests} = Which[
    MatchQ[$ECLApplication, Engine] || unitOperationPacketsQ, {<||>, {}},
    gatherTests, Resources`Private`fulfillableResourceQ[Flatten[{nonTipResources, combinedTipResources, combinedCounterWeightResources}], Simulation->simulation, Output -> {Result, Tests}],
    True, {Resources`Private`fulfillableResourceQ[Flatten[{nonTipResources, combinedTipResources, combinedCounterWeightResources}], Simulation->simulation], {}}
  ];

  (* Throw errors that we discovered during the MapThread. *)
  If[Length[allOverwrittenLabelsWithIndices]>0,
    If[MatchQ[$ShortenErrorMessages, True],
      Message[Error::OverwrittenLabels, allOverwrittenLabelsWithIndices[[All,1]], allOverwrittenLabelsWithIndices[[All,2]], shortenPrimitives[allOverwrittenLabelsWithIndices[[All,3]]]],
      Message[Error::OverwrittenLabels, allOverwrittenLabelsWithIndices[[All,1]], allOverwrittenLabelsWithIndices[[All,2]], allOverwrittenLabelsWithIndices[[All,3]]]
    ];
  ];

  If[Length[invalidLabelPrimitivesWithIndices]>0,
    If[MatchQ[$ShortenErrorMessages, True],
      Message[Error::UnknownLabels, invalidLabelPrimitivesWithIndices[[All,1]], invalidLabelPrimitivesWithIndices[[All,2]], shortenPrimitives[invalidLabelPrimitivesWithIndices[[All,3]]]],
      Message[Error::UnknownLabels, invalidLabelPrimitivesWithIndices[[All,1]], invalidLabelPrimitivesWithIndices[[All,2]], invalidLabelPrimitivesWithIndices[[All,3]]]
    ];
  ];

  If[Length[invalidAutofillPrimitivesWithIndices]>0,
    If[MatchQ[$ShortenErrorMessages, True],
      Message[Error::UnableToAutofillUnitOperation, shortenPrimitives[invalidAutofillPrimitivesWithIndices[[All,1]]], invalidAutofillPrimitivesWithIndices[[All,2]]],
      Message[Error::UnableToAutofillUnitOperation, invalidAutofillPrimitivesWithIndices[[All,1]], invalidAutofillPrimitivesWithIndices[[All,2]]]
    ];
  ];

  If[Length[invalidResolvePrimitiveMethodsWithIndices]>0,
    If[MatchQ[$ShortenErrorMessages, True],
      Message[Error::NoAvailableUnitOperationMethods, shortenPrimitives[invalidResolvePrimitiveMethodsWithIndices[[All,1]]], invalidResolvePrimitiveMethodsWithIndices[[All,2]]],
      Message[Error::NoAvailableUnitOperationMethods, invalidResolvePrimitiveMethodsWithIndices[[All,1]], invalidResolvePrimitiveMethodsWithIndices[[All,2]]]
    ];
  ];

  (* If we have plate reader primitives, find other places where injector samples are used outside of the injector sample fields. *)
  invalidInjectorResourcesWithIndices=Join@@MapThread[
    computeInvalidInjectionSampleResources,
    {allPrimitiveGroupings, allPrimitiveGroupingUnitOperationPackets}
  ];

  If[Length[invalidInjectorResourcesWithIndices]>0,
    Message[Error::InjectionSamplesUsedElsewhere, ObjectToString[invalidInjectorResourcesWithIndices[[All,1]]], invalidInjectorResourcesWithIndices[[All,2]]];
  ];

  (* If we encountered FRQ problems, return $Failed. *)
  If[MatchQ[fulfillableQ, False] || MatchQ[accumulatedFulfillableResourceQ, False],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> {
        Flatten@{
          safeOpsTests,
          templateTests,
          frqTests,
          accumulatedFRQTests
        },
        Sequence@@allResolverTests
      },
      Options -> $Failed,
      Preview -> Null,
      Input -> myPrimitives
    }];
  ];

  (*If we have any Transfer UnitOperation with MagnetizationRack -> "Alpaqua Magnum FLX Enhanced Universal Magnet 96-well Plate Rack", or Filter, we need to check if they coexist *)

  (*Initiate the error tracking variable so that invalid input will not error out.*)
  invalidInputMagnetizationRacksWithIndices = {};

  If[Length[$PotentialConflictingDeckPlacementUnitOperations]>0,
    Module[{types,coexistFilterTransferQ,replaceHeavyRacks},
      (*Look up all the types *)
      types = Lookup[$PotentialConflictingDeckPlacementUnitOperations,Type];
      coexistFilterTransferQ =  MemberQ[types,Object[UnitOperation,Transfer]]&&MemberQ[types,Object[UnitOperation,Filter]];
      (*Look up the user specified Magnetization racks. If we have coexistence of Filter and potentially problematic Transfer primitives, the heavy racks specified are invalid*)
      invalidInputMagnetizationRacksWithIndices = If[coexistFilterTransferQ,
        MapIndexed[
          Function[{primitive, primitiveIndex},
            Module[{transferUnresolvedMagnetizationRack,userSpecifiedMagnumFLXRacks},
              transferUnresolvedMagnetizationRack = Lookup[primitive[[1]],UnresolvedMagnetizationRackFromParentProtocol,Null];

              (*Get all the user input cases of the heavy magnet*)
              userSpecifiedMagnumFLXRacks=If[MatchQ[Head[primitive],Transfer]&&MatchQ[transferUnresolvedMagnetizationRack,ListableP[Null|Automatic]],
                (*If this primitive is Transfer, and the unresolved Magnetization rack from its higher level experiment is Null or Automatic, we are not logging it as problematic*)
                {},
                (*Otherwise this is not transfer or the user actually input the rack, if the heavy magnetization rack is present in primitive values, we log it as invalid*)
                Cases[Flatten[Values[primitive[[1]]]],ObjectP[Flatten[heavyMagnetizationRacks]]]
              ];
              (*If there is any user specified Magnum FLX heavy magnet, return the value and primitive index*)
              If[Length[userSpecifiedMagnumFLXRacks]>0,
                {userSpecifiedMagnumFLXRacks,primitiveIndex},
                (*Otherwise the user did not specify any heavy magnet, return nothing*)
                Nothing
              ]
            ]
          ],
          Flatten[coverOptimizedPrimitives]],
        {}
      ];

      (*Helper function to replace all occurrences of the heavy racks *)
      replaceHeavyRacks[myVariableValues_] := Replace[myVariableValues,{ObjectReferenceP[Model[Item, MagnetizationRack, "id:kEJ9mqJYljjz"](*Model[Item,MagnetizationRack,"Alpaqua Magnum FLX Enhanced Universal Magnet 96-well Plate Rack"*)]->Model[Item, MagnetizationRack, "id:aXRlGn6O3vqO"](*Model[Item, MagnetizationRack, "Alpaqua 96S Super Magnet 96-well Plate Rack"]*),
        Resource[Sample->Model[Item, MagnetizationRack, "id:kEJ9mqJYljjz"]]->Resource[Sample->Model[Item, MagnetizationRack, "id:aXRlGn6O3vqO"](*Model[Item, MagnetizationRack, "Alpaqua 96S Super Magnet 96-well Plate Rack"]*)]},Infinity];

      Which[
        (* If Filter and Transfer coexist & transfer and user specified the heavy magnet, throw an error*)
        coexistFilterTransferQ&&Length[invalidInputMagnetizationRacksWithIndices]>0,
        If[MatchQ[$ShortenErrorMessages, True],
          Message[Error::ConflictingSpecifiedMagnetizationRackWithFilterUnitOperation, ObjectToString[invalidInputMagnetizationRacksWithIndices[[All,1]]], shortenPrimitives[invalidInputMagnetizationRacksWithIndices[[All,2]]]],
          Message[Error::ConflictingSpecifiedMagnetizationRackWithFilterUnitOperation, ObjectToString[invalidInputMagnetizationRacksWithIndices[[All,1]]],invalidInputMagnetizationRacksWithIndices[[All,2]]]
        ];
          Nothing,
        (*Otherwise if Filter and Transfer coexist, we need to swap all the heavy magnet to the lighter one because we resolved to the model*)
        coexistFilterTransferQ,
         allPrimitiveGroupingUnitOperationPackets = replaceHeavyRacks[allPrimitiveGroupingUnitOperationPackets];
          allPrimitiveOptionGroupings=replaceHeavyRacks[allPrimitiveOptionGroupings];
          allPrimitiveGroupings=replaceHeavyRacks[allPrimitiveGroupings];
         safeOps = replaceHeavyRacks[safeOps];
          Nothing,
        (*Otherwise, we dont have Filter and potential problematic Transfer at the same time, no need to worry about it*)
        True,
          Nothing
      ]
    ]
  ];

  (* Keep track of our invalid inputs. *)
  invalidInputIndices=DeleteDuplicates[Flatten[{
    invalidResolvePrimitiveMethodsWithIndices[[All,2]],
    invalidAutofillPrimitivesWithIndices[[All,2]],
    invalidLabelPrimitivesWithIndices[[All,2]],
    noInstrumentsPossibleErrorsWithIndices[[All,2]],
    invalidResolverPrimitives,
    allOverwrittenLabelsWithIndices[[All,2]],
    invalidInjectorResourcesWithIndices[[All,2]],
    incompatibleWorkCellAndMethod,
    roboticCellPreparationRequired,
    invalidInputMagnetizationRacksWithIndices[[All,2]]
  }]];

  (* if we are supposed to return unit operation packets, then do that here *)
  (* NOTE: Even if we have invalid inputs, we have to return our packets here because experiments that call us are expecting *)
  (* that. *)

  If[TrueQ[unitOperationPacketsQ],
    If[Length[invalidInputIndices]>0 && Not[gatherTests],
      If[MatchQ[$ShortenErrorMessages, True],
        Message[Error::InvalidInput, shortenPrimitives[coverOptimizedPrimitives[[invalidInputIndices]]]],
        Message[Error::InvalidInput, coverOptimizedPrimitives[[invalidInputIndices]]]
      ];
    ];

    (* Return the run time too. If we are here, we are called by a Robotic compatible function that generates sub RoboticUnitOperations.*)
    (* ExperimentRoboticSamplePreparation or ExperimentRoboticCellPreparation has been called directly and we can do time estimate based on the sub UOs. We should be guaranteed to have only one group *)
    totalWorkCellTime=Max[{
      1Minute,
      Total[ToList[Replace[First[allPrimitiveGroupingRunTimes],{Except[TimeP]->0Minute}, {1}]]]
    }];

    Return[outputSpecification/.{
      Result-> {Flatten[allPrimitiveGroupingUnitOperationPackets],totalWorkCellTime},
      Tests->If[gatherTests,
        {
          Flatten@{
            safeOpsTests,
            templateTests,
            frqTests,
            accumulatedFRQTests
          },
          Sequence@@allResolverTests
        },
        Null
      ],
      Simulation->currentSimulation,
      Input->Null
    }]
  ];

  (* -- STAGE 6: Creating Upload Packets -- *)
  If[debug, Echo["Beginning stage 6: creating upload packets"]];

  (* Helper function to pass down post-processing options. *)
  postProcessingOption[myOptionSymbol_, myUnresolvedOptions_List, myUserSpecifiedMethodGroupOptions_List, myGlobalOptions_]:=Which[
    KeyExistsQ[myUnresolvedOptions, myOptionSymbol] && !MatchQ[Lookup[myUnresolvedOptions, myOptionSymbol], Automatic],
      Nothing,
    KeyExistsQ[myUserSpecifiedMethodGroupOptions, myOptionSymbol] && !MatchQ[Lookup[myUnresolvedOptions, myOptionSymbol], Automatic],
      myOptionSymbol->Lookup[myUnresolvedOptions, myOptionSymbol],
    KeyExistsQ[myGlobalOptions, myOptionSymbol] && !MatchQ[Lookup[myGlobalOptions, myOptionSymbol], Automatic],
      myOptionSymbol->Lookup[myGlobalOptions, myOptionSymbol],
    True,
      Nothing
  ];

  (* Resolve any options that we have for this function that aren't automatic. *)
  resolvedOptions=If[MatchQ[FirstOrDefault[DeleteDuplicates[Flatten[allPrimitiveGroupingWorkCellInstruments]]], ObjectP[]],
    ReplaceRule[safeOps,
      {
        Instrument->FirstOrDefault[DeleteDuplicates[Flatten[allPrimitiveGroupingWorkCellInstruments]]],
        If[MemberQ[safeOps[[All,1]], CoverAtEnd],
          CoverAtEnd->coverAtEnd,
          Nothing
        ]
      }
    ],
    safeOps
  ];

  (* Helper function to compute the labeled and future labeled objects. *)

  (* NOTE: Some of our LabeledObjects can't be resolved at ResourcePicking time because some of the objects are *)
  (* either not referencable using the current Resource system, or the objects will only exist at Parse time. The *)
  (* framework will detect these labels that refer to resources with simulated objects and put them in *)
  (* FutureLabeledObjects if there is not another valid resource that can be used to resolve the label at RP time. *)

  (* Example 1:
    "source sample label"->Resource[Sample->Model[Sample, "Milli-Q water"], Container->Model[Container, Vessel, "2mL Tube"]]
    "source container label"->Object[Container, Vessel, "simulated 2mL Tube"]
  *)

  (* Example 2:
    "destination container label"->Model[Container, Vessel, "2mL Tube"]
    "destination sample label"->Object[Sample, "simulated sample in 2mL Tube that will only exist after parse"]
  *)

  (* NOTE: In Manual, we get unit operation packets back from the resolver function when calling LabelSample/Container. Other than *)
  (* LabelSample/Container, we do NOT get resources from the resolver functions so myLabeledObjects will be empty. *)
  (* NOTE: This function is called using Flatten[allPrimitiveGroupingResources]. *)
  computeLabeledObjectsAndFutureLabeledObjects[myLabeledObjects:{_Rule...}, options:OptionsPattern[]]:=Module[
    {
      nonExistentContainersAndSamples, nonSimulatedLabeledObjectResourceLookup, simulatedLabeledObjectResourceLookup,
      simulatedContainerLabeledObjectResourceLookup, simulatedSampleLabeledObjectResourceLookup, labeledObjectLabelFieldLookup,
      filteredSimulatedLabeledObjectResourceLookup, simulatedContainerPackets, simulatedSamplePackets,
      simulatedSampleContainerPackets, simulatedContainerLabels, simulatedSampleLabels, futureLabeledObjects,
      allSimulationLabelLookup,sortedLabeledObjects,sortedFutureLabeledObjects,existentContainersAndSamples,
      nonSimulatedLabeledObjectLinkLookup
    },

    (* OVERVIEW: We categorize our labeled objects into four categories: *)
    (* 1A) We get Resources for them (from Replace[LabeledObjects] in the unit operation packet returned) and the resource *)
    (* does NOT point to a simulated object. We put this into LabeledObjects at the protocol level. *)
    (* 1B) We don't have a resource for the label, but the object that the label points to is not simulated. Note that this *)
    (* happens when we are doing manual unit operations and don't get resources (unlike in robotic). *)
    (* The above two cases should always be the first since they are REAL objects and nothing need to be done in the protocol to get them *)
    (* 2) We get Resources for them (from Replace[LabeledObjects] in the unit operation packet returned) and the resource *)
    (* DOES point to a simulated object. This has to go into FutureLabeledObjects. *)
    (* The resources are fulfilled in resource picking and can be populated directly. This should go after the real objects. *)
    (* 3) We get a LabelField, telling us how to download the resolved object from the subprotocol field after it's finished. *)
    (* LabelField should go next because these fields are populated directly in the protocols. Once the subprotocol (manual) or the unit operation (robotic) is completed, the fields are directly available *)
    (* 4) We find the simulated object in the Labels field from our simulation. *)
    (* Dereferencing from other labeled objects last to avoid creating sample lable <-> container label loops *)
    (* We favor 1), 2), 3), 4) -- in that order. *)

    (* First, try to get the labels that have simulated Resources associated with them. *)
    {nonExistentContainersAndSamples, existentContainersAndSamples}=Module[
      {allResourceContainerAndSampleObjects, allLabelContainerAndSampleObjects, allContainerAndSampleObjects, allContainerAndSampleObjectsSimulatedQ},

      (* NOTE: Some of our Resources will point to simulated samples. This is because the samples may not exist in the *)
      (* {Container, Well} syntax of the LabelSample primitive. We will detect these later and fill them out in the parser. *)
      allResourceContainerAndSampleObjects=DeleteDuplicates@Cases[
        myLabeledObjects[[All,2]],
        ObjectReferenceP[{Object[Sample], Object[Container]}],
        Infinity
      ];
      (* NOTE: Some of our Labels in the Simulation[...] will also not exist. *)
      allLabelContainerAndSampleObjects=DeleteDuplicates@Cases[
        Lookup[currentSimulation[[1]], Labels][[All,2]],
        ObjectReferenceP[{Object[Sample], Object[Container]}],
        Infinity
      ];

      allContainerAndSampleObjects=DeleteDuplicates[Join[allResourceContainerAndSampleObjects, allLabelContainerAndSampleObjects]];

      allContainerAndSampleObjectsSimulatedQ=If[MatchQ[$CurrentSimulation, SimulationP],
        Module[{allSimulatedObjectsUOOnly},
          allSimulatedObjectsUOOnly=DeleteCases[Lookup[currentSimulation[[1]], SimulatedObjects], Alternatives @@ Lookup[$CurrentSimulation[[1]], SimulatedObjects]];

          (* The variable namespace here is confusing and hard to deconvolute but worth explaining: *)
          (* 1.) allObjectsInSimulation are all the Labeled objects inside of the currentSimulation (i.e., the simulation that came out of the options resolvers) *)
          (* 2.) allSimulatedObjectsUOOnly are the SimulatedObjects that exist in the currentSimulation, but NOT in $CurrentSimulation *)
          (* The reason we want this is because if it's in $CurrentSimulation, then we are in the global simulation space and the objects were put there by Upload.  For all intents and purposes, those are "real" objects, and not ones we need to replace with labels.*)
          (* 3.) Thus, the MemberQ will only return True if the objects are labeled by currentSimulation and NOT in $CurrentSimulation*)
          (MemberQ[allSimulatedObjectsUOOnly, #]&)/@allContainerAndSampleObjects
        ],
        (MemberQ[Lookup[currentSimulation[[1]], SimulatedObjects], #]&)/@allContainerAndSampleObjects
      ];

      {
        PickList[
          allContainerAndSampleObjects,
          allContainerAndSampleObjectsSimulatedQ,
          True
        ],
        PickList[
          allContainerAndSampleObjects,
          allContainerAndSampleObjectsSimulatedQ,
          False
        ]
      }
    ];

    (* This gives us 1A) (non-simulation dependent resources) and almost 3) (simulation dependent resources, before filtering). *)
    {nonSimulatedLabeledObjectResourceLookup, simulatedLabeledObjectResourceLookup}=Module[{uniqueLabeledObjectResourceLookup,labeledObjectResourceLookupWithoutFutureSimulatedDuplicateObjects,nonSimulatedLookup},
      (* Merge any duplicate labels that we have. We might have a real resource for the first primitive that actually *)
      (* needs to pick that sample/container and then resources for a simulated sample/container in subsequent primitives. *)
      uniqueLabeledObjectResourceLookup=Normal@Merge[
        myLabeledObjects,
        (* NOTE: Try to find the first resource that doesn't include a simulated object, if we can't find any, then *)
        (* just pick the first one. *)
        (FirstCase[#, _?(!MemberQ[#, Alternatives@@nonExistentContainersAndSamples, Infinity]&), #[[1]]]&)
      ];

      (* Our labeling system is such that multiple labels can be attached to a single sample/container. Make sure that if *)
      (* there are multiple labels being assigned to a single sample/container, we pick the resource that points to a non simulated *)
      (* sample/container if possible. *)
      (* NOTE: This is because after we simulate a model->object, if we label the same sample/container again, it'll make a resource *)
      (* for the simulated sample/container when we want to point to the real model. *)
      labeledObjectResourceLookupWithoutFutureSimulatedDuplicateObjects=Flatten@Map[
        Function[{labeledObjectList},
          (* Do we have multiple labels that point to the same object and is that object simulated? *)
          If[Length[labeledObjectList]>1 && MemberQ[labeledObjectList, Alternatives@@nonExistentContainersAndSamples, Infinity],
            Module[{realResource},
              (* Get the first resource that don't contain nonExistentContainersAndSamples. *)
              realResource=FirstCase[
                Lookup[uniqueLabeledObjectResourceLookup, labeledObjectList[[All,1]]],
                _?(!MemberQ[#, Alternatives@@nonExistentContainersAndSamples, Infinity]&),
                Null
              ];

              (* If we didn't find anything, don't touch things. *)
              If[MatchQ[realResource, Null],
                (#->Lookup[uniqueLabeledObjectResourceLookup, #]&)/@labeledObjectList[[All,1]],
                (#->realResource&)/@labeledObjectList[[All,1]]
              ]
            ],
            (* No, just use the regular value we previously had. *)
            (#->Lookup[uniqueLabeledObjectResourceLookup, #]&)/@labeledObjectList[[All,1]]
          ]
        ],
        (* Group our labeled object lookup by labels that point to the same object. *)
        Values[GroupBy[Cases[Lookup[currentSimulation[[1]], Labels], Verbatim[Rule][Alternatives@@myLabeledObjects[[All,1]], _]], (#[[2]] &)]]
      ];

      nonSimulatedLookup=Select[
        labeledObjectResourceLookupWithoutFutureSimulatedDuplicateObjects,
        (!MemberQ[#[[2]], Alternatives@@nonExistentContainersAndSamples, Infinity]&)
      ];

      {
        nonSimulatedLookup,
        UnsortedComplement[labeledObjectResourceLookupWithoutFutureSimulatedDuplicateObjects, nonSimulatedLookup]
      }
    ];

    (* Get the objects that are in allLabeledObjects that already exist and aren't in 1A) (we don't have resources for these). This happens *)
    (* when we have manual methods. *)
    (* NOTE: Don't include non simulated objects for which we have labels for. *)
    nonSimulatedLabeledObjectLinkLookup=(#[[1]]->Link[#[[2]]]&)/@Cases[
      Lookup[currentSimulation[[1]], Labels],
      Verbatim[Rule][Except[Alternatives@@(nonSimulatedLabeledObjectResourceLookup[[All,1]])], Alternatives@@existentContainersAndSamples]
    ];

    (* This will give us 2). *)
    filteredSimulatedLabeledObjectResourceLookup=Cases[
      simulatedLabeledObjectResourceLookup,
      Verbatim[Rule][
        Except[Alternatives@@(Flatten[{nonSimulatedLabeledObjectResourceLookup[[All,1]], nonSimulatedLabeledObjectLinkLookup[[All,1]]}])],
        _
      ]
    ];

    (* For the labeled objects that still point to simulated objects, break them into the ones that point *)
    (* to simulated samples and the ones that point to simulated containers. We SHOULDN'T have any other simulated *)
    (* types other than those that can't be resolved at RP time. *)
    simulatedContainerLabeledObjectResourceLookup=Cases[
      filteredSimulatedLabeledObjectResourceLookup,
      Verbatim[Rule][_, Resource[KeyValuePattern[{Sample->ObjectReferenceP[Object[Container]]}]]]
    ];
    simulatedSampleLabeledObjectResourceLookup=UnsortedComplement[filteredSimulatedLabeledObjectResourceLookup, simulatedContainerLabeledObjectResourceLookup];

    (* Find the labels for which we have LabelFields for. Exclude labels for which we've already found non-simulated *)
    (* resources for via 1) and 2). This will give us 3). *)
    (* NOTE: Don't include LabelFields here that just have _String in them. This is useless information if we couldn't *)
    (* previously find a resource that went along with the label. *)
    (* allLabelFieldsWithIndicesGroupings is in the correct order of manipulation index since we always AppendTo the new UO group to the end. *)
    labeledObjectLabelFieldLookup=Cases[
      Flatten[allLabelFieldsWithIndicesGroupings],
      Verbatim[Rule][
        Except[Alternatives@@(Join[nonSimulatedLabeledObjectResourceLookup[[All,1]], nonSimulatedLabeledObjectLinkLookup[[All,1]], filteredSimulatedLabeledObjectResourceLookup[[All,1]]])],
        Verbatim[LabelField][Except[_String], _]
      ]
    ];

    (* Get the labels from our simulation that are simulated AND do not show up in our resource list/label fields already. *)
    (* This is excluding 1), 2), and 3). This will give us 4). *)
    allSimulationLabelLookup=Cases[
      Lookup[currentSimulation[[1]], Labels],
      Verbatim[Rule][
        Except[Alternatives@@(Flatten[{nonSimulatedLabeledObjectResourceLookup[[All,1]], labeledObjectLabelFieldLookup[[All,1]], nonSimulatedLabeledObjectLinkLookup[[All,1]], filteredSimulatedLabeledObjectResourceLookup[[All,1]]}])],
        _
      ]
    ];

    (* Now we have to download information for 2) and 4) in order to put them into proper FutureLabeledObjects form. *)
    (* For the containers, get the contents and try to relate that to a non-simulated label. *)
    (* For the samples, get the container and try to relate that to a non-simulated label. *)
    {simulatedContainerPackets, simulatedSamplePackets, simulatedSampleContainerPackets, simulatedContainerLabels, simulatedSampleLabels}=Module[
      {sampleSimulationLabelLookup, containerSimulationLabelLookup, allSimulatedSamples, allSimulatedContainers},

      (* Separate 4) into containers and samples. *)
      sampleSimulationLabelLookup=Cases[allSimulationLabelLookup, Verbatim[Rule][_, ObjectReferenceP[Object[Sample]]]];
      containerSimulationLabelLookup=Cases[allSimulationLabelLookup, Verbatim[Rule][_, ObjectReferenceP[Object[Container]]]];

      (* Get all simulated containers and samples. *)
      allSimulatedSamples=Flatten[{
        (Lookup[#[[1]], Sample]&)/@simulatedSampleLabeledObjectResourceLookup[[All,2]],
        sampleSimulationLabelLookup[[All,2]]
      }];
      allSimulatedContainers=Flatten[{
        (Lookup[#[[1]], Sample]&)/@simulatedContainerLabeledObjectResourceLookup[[All,2]],
        containerSimulationLabelLookup[[All,2]]
      }];

      {
        Sequence@@(Flatten/@Download[
          {
            allSimulatedContainers,
            allSimulatedSamples,
            allSimulatedSamples
          },
          {
            {Packet[Object, Contents]},
            {Packet[Object, Container]},
            {Packet[Container[Contents]]}
          },
          Simulation->currentSimulation
        ]
        ),
        Flatten[{simulatedContainerLabeledObjectResourceLookup[[All,1]], containerSimulationLabelLookup[[All,1]]}],
        Flatten[{simulatedSampleLabeledObjectResourceLookup[[All,1]], sampleSimulationLabelLookup[[All,1]]}]
      }
    ];

    (* Convert these simulated containers and samples into the expected FutureLabeledObjects field format. *)
    futureLabeledObjects=Module[
      {
        containerFutureLabeledObjects, sampleFutureLabeledObjects,validContainerFutureLabeledObjects,validSampleFutureLabeledObjects,
        noContainerFutureLabeledObjects,noContainerLabelFutureLabeledObjectsLookup
      },

      (* Relate each container to its non-simulated sample label. *)
      containerFutureLabeledObjects=MapThread[
        Function[{containerPacket, containerLabel},
          Module[{samplesInContainer},
            (* Get the sample objects that are in this container. *)
            samplesInContainer=Download[Lookup[containerPacket, Contents][[All,2]], Object];

            (* "Future Label"->{"Existing Label","Relation to Existing Label's Object"} *)
            containerLabel->{
              FirstCase[
                Lookup[currentSimulation[[1]], Labels],
                Verbatim[Rule][sampleLabel_String, Alternatives@@samplesInContainer]:>sampleLabel,
                Null
              ],
              Container
            }
          ]
        ],
        {
          simulatedContainerPackets,
          simulatedContainerLabels
        }
      ];

      (* Relate each container to its non-simulated sample label. *)
      sampleFutureLabeledObjects=MapThread[
        Function[{samplePacket, sampleContainerPacket, sampleLabel},
          Module[{container},
            (* Get the container of the simulated sample. *)
            container=Download[Lookup[samplePacket, Container], Object];

            (* "Future Label"->{"Existing Label","Relation to Existing Label's Object"} *)
            sampleLabel->{
              FirstCase[
                Lookup[currentSimulation[[1]], Labels],
                Verbatim[Rule][containerLabel_String, container]:>containerLabel,
                Null
              ],
              FirstCase[
                Lookup[sampleContainerPacket, Contents],
                {position_String, LinkP[Download[Lookup[samplePacket, Object], Object]]}:>position,
                Null
              ]
            }
          ]
        ],
        {simulatedSamplePackets, simulatedSampleContainerPackets, simulatedSampleLabels}
      ];

      (* remove cases of resolved "label"->{Null,XX} since they are not valid *)
      validSampleFutureLabeledObjects=DeleteCases[sampleFutureLabeledObjects,Rule[_,{Null,_}]];
      validContainerFutureLabeledObjects=DeleteCases[containerFutureLabeledObjects,Rule[_,{Null,_}]];

      (* in a rare case that we have a "sample label" but not "container label", pull in the LabelField[] for that "sample label" *)
      noContainerFutureLabeledObjects = Cases[Join[sampleFutureLabeledObjects,containerFutureLabeledObjects],Verbatim[Rule][_,{Null,_}]][[All,1]];
      noContainerLabelFutureLabeledObjectsLookup = Cases[
        Flatten[allLabelFieldsWithIndicesGroupings],
        Verbatim[Rule][
          Alternatives@@noContainerFutureLabeledObjects,
          (* we restrict the pattern here in case of an unknown failure mode upstream, we should _only_ have proper LabelField[] here *)
          Verbatim[LabelField][Except[_String], _]
        ]
      ];

      (* Return our information. *)
      Join[validContainerFutureLabeledObjects, validSampleFutureLabeledObjects, labeledObjectLabelFieldLookup, noContainerLabelFutureLabeledObjectsLookup]
    ];

    (* Sort our LabeledObjects and FutureLabeledObjects to show up in the order that they show up in the Simulation's *)
    (* Label key. *)
    sortedLabeledObjects=SortBy[
      Join[List@@@nonSimulatedLabeledObjectResourceLookup, List@@@nonSimulatedLabeledObjectLinkLookup],
      (FirstOrDefault@Flatten@FirstPosition[Lookup[currentSimulation[[1]], Labels][[All,1]], #[[1]], {Infinity}]&)
    ];

    sortedFutureLabeledObjects=SortBy[
      futureLabeledObjects,
      (FirstOrDefault@Flatten@FirstPosition[Lookup[currentSimulation[[1]], Labels][[All,1]], #[[1]], {Infinity}]&)
    ];

    (* Return LabeledObjects for RP-time and FutureLabeledObjects. *)
    {
      sortedLabeledObjects,
      sortedFutureLabeledObjects
    }
  ];

  (* For each primitive grouping, figure out the label fields that should be used. *)
  labelFieldGroupings=MapThread[
    Function[{index, method},
      Flatten[allLabelFieldsWithIndicesGroupings[[1;;index-1]]]
    ],
    {
      Range[Length[allPrimitiveGroupings]],
      (Lookup[#[[1]][[1]], PrimitiveMethod]&)/@allPrimitiveGroupings
    }
  ];

  (* Compute our primitives with label fields. *)
  (* NOTE: We have to do this outside of the MapThread because inside of the MapThread we are still determining what *)
  (* primitives go with each grouping. We only want to use LabelFields to replace labels from previous groupings *)
  (* since labels within our own grouping will be replace by the SP function itself. *)
  {allUnresolvedPrimitivesWithLabelFieldGroupings, allPrimitiveInputsWithLabelFieldsGroupings, allPrimitiveOptionsWithLabelFieldsGroupings}=If[Length[invalidInputIndices]>0,
    {{},{},{}},
    Transpose@MapThread[
      Function[{labelFieldLookup, optionGrouping, resolvedGrouping},
        Transpose@MapThread[
          Function[{options, resolvedPrimitive},
            Module[
              {
                primitiveHead, primitiveInformation, primitiveOptionDefinitions,  inputNames,
                inputRules, primitiveInputsWithLabelFields, primitiveOptionsWithLabelFields
              },

                (* Get our primitive head *)
                primitiveHead = Head[resolvedPrimitive];

                (* Lookup primitive information. *)
                primitiveInformation=Lookup[allPrimitiveInformation, primitiveHead];
                primitiveOptionDefinitions=Lookup[primitiveInformation, OptionDefinition];

                (* Get our resolved inputs since our label options are index-matched to samples *)
                (* Using allPrimitiveInputGroupings here will throw errors when inputs are plates *)
                inputNames=Lookup[primitiveInformation, InputOptions];
                inputRules=(#->resolvedPrimitive[#])&/@inputNames;


                (* For each option in our primitive, replace any labels with their label fields. *)
                (* If we find an invalid label (that hasn't been initialized yet), keep track of it. *)
                primitiveInputsWithLabelFields=addLabelFields[inputRules,primitiveOptionDefinitions,labelFieldLookup];
                primitiveOptionsWithLabelFields=addLabelFields[options,primitiveOptionDefinitions,labelFieldLookup];

                {
                  primitiveHead@@Join[primitiveInputsWithLabelFields, primitiveOptionsWithLabelFields],
                  primitiveInputsWithLabelFields[[All,2]],
                  primitiveOptionsWithLabelFields
                }
            ]
          ],
          {optionGrouping, resolvedGrouping}
        ]
      ],
      {
        labelFieldGroupings,
        allPrimitiveOptionGroupings,
        allPrimitiveGroupings
      }
    ]
  ];

  (* Keep track of the primitive index to assignment variable that we're putting in the script. *)
  primitiveIndexToScriptVariableLookup={};
  primitiveIndexToOutputUnitOperationLookup={};

  (* We should create a script if we have more than one primitive grouping that needs to be executed. *)
  outputResult=Which[
    (* We had invalid inputs and should not create any packets. *)
    Length[invalidInputIndices]>0,
      $Failed,

    (* Create a script that will link these all primitive groups together. *)
    And[
      MatchQ[myFunction, ScriptGeneratingPrimitiveFunctionP],
      Length[allPrimitiveGroupings]>1
    ],
      If[debug,Echo[ToString[Length@allPrimitiveGroupings]<>" primitive groups detected, making a script..."]];
      Module[
        {heldScriptCells, heldCompoundExpression, uploadPackets},

        (* Go through our grouped primitives and create script cells. *)
        heldScriptCells=Flatten[
          MapThread[
            Function[{resolvedPrimitiveGroup, unresolvedPrimitiveGroup, instrument, indexGroup},
              Module[{workCellFunction, newVariableName, heldVariableAssignment, specialHoldHead, specialHoldHead2, allLabelFields, allDownloadSyntax,allLabeledObjects,allLabeledObjectsWithNames,allLabeledObjectsJoined,restrictSamplesCommand},
                (* Figure out what ExperimentBLAH[...] function to call for our group of primitives. *)
                workCellFunction=ToExpression["Experiment"<>ToString@Lookup[First[resolvedPrimitiveGroup][[1]], PrimitiveMethod]];

                (* Figure out what to call this next variable. *)
                newVariableName=ToExpression[
                  "Global`my"<>ToString[workCellFunction]<>"Protocol"<>ToString[First[indexGroup]],
                  InputForm,
                  Hold
                ];

                (* Setup our hold heads. *)
                SetAttributes[specialHoldHead, HoldAll];
                SetAttributes[specialHoldHead2, HoldAll];

                (* Append this variable name to our index to variable name lookup. *)
                (* NOTE: The variables names in this lookup are all held in case they're already defined. *)

                (* NOTE: We use this lookup when we need to get to the OutputUnitOperation first before we download the resulting field. *)
                primitiveIndexToOutputUnitOperationLookup=Join[
                  primitiveIndexToOutputUnitOperationLookup,
                  (* Here we are constructing primitive index to output UO index rule. To calculate output UO index, we need to take the primitive index and subtract by the first index of the same group *)
                  (With[{insertMe=(# +1 - First[indexGroup])},
                    #->holdCompositionList[Sequence,{newVariableName, Hold[OutputUnitOperations[[insertMe]]]}]
                  ]&)/@indexGroup
                ];

                (* This is just the held variable name. *)
                primitiveIndexToScriptVariableLookup=Join[primitiveIndexToScriptVariableLookup, (#->newVariableName&)/@indexGroup];

                (* Put these primitives into the correct format, within a hold. *)
                heldVariableAssignment=Switch[workCellFunction,
                  ExperimentManualSamplePreparation,
                  With[{insertMe1 = newVariableName, insertMe2 = workCellFunction, insertMe3 = unresolvedPrimitiveGroup, insertMe5 = parentProtocol, imageSampleOption = resolvedImageSample, measureVolumeOption = resolvedMeasureVolume, measureWeightOption = resolvedMeasureWeight},
                    holdCompositionList[Set, {insertMe1, Hold[insertMe2[insertMe3, ParentProtocol -> insertMe5, ImageSample -> imageSampleOption, MeasureVolume -> measureVolumeOption, MeasureWeight -> measureWeightOption]]}]
                  ],
                  (* MCP does not have post processing options *)
                  ExperimentManualCellPreparation,
                  With[{insertMe1 = newVariableName, insertMe2 = workCellFunction, insertMe3 = unresolvedPrimitiveGroup, insertMe5 = parentProtocol},
                    holdCompositionList[Set, {insertMe1, Hold[insertMe2[insertMe3, ParentProtocol -> insertMe5]]}]
                  ],
                  (* only RoboticBlah has the Instrument option *)
                  _,
                  With[{insertMe1 = newVariableName, insertMe2 = workCellFunction, insertMe3 = unresolvedPrimitiveGroup, insertMe4 = instrument, insertMe5 = parentProtocol, imageSampleOption = resolvedImageSample, measureVolumeOption = resolvedMeasureVolume, measureWeightOption = resolvedMeasureWeight},
                    holdCompositionList[Set, {insertMe1, Hold[insertMe2[insertMe3, Instrument -> insertMe4, ParentProtocol -> insertMe5, ImageSample -> imageSampleOption, MeasureVolume -> measureVolumeOption, MeasureWeight -> measureWeightOption]]}]
                  ]
                ];

                (* Get all label fields out and create the corresponding download syntax. *)
                (* NOTE: We can't do the regular replace rule here because we need to do more complicated holding. *)
                allLabelFields=Cases[heldVariableAssignment, _LabelField, Infinity];
                allDownloadSyntax=(
                  If[MatchQ[#,LabelField[_String,_]],
                    (* NOTE: This becomes LookupLabeledObject[variableName, label]. *)
                    With[{insertMe1=Lookup[primitiveIndexToScriptVariableLookup, #[[2]]], insertMe2=#[[1]]},
                      Append[insertMe1, insertMe2]/.{Hold->specialHoldHead2}
                    ],
                    (* NOTE: This becomes Download[Download[variableName, OutputUnitOperation[[#]]], labelField]. *)
                    With[{insertMe1=Lookup[primitiveIndexToOutputUnitOperationLookup, #[[2]]], insertMe2=#[[1]]},
                      Hold[insertMe1, insertMe2]/.{Hold->specialHoldHead}
                    ]
                  ]
                &)/@allLabelFields;

                (* Set the labeled samples to Restricted *)
                (* Get the LabeledObjects field. This is in the form of {{"Label",Object[xxx]}...} *)
                allLabeledObjectsWithNames=Map[
                  With[{insertMe1=#},
                    Append[insertMe1,LabeledObjects]/.{Hold->specialHoldHead}
                  ]&,
                  DeleteDuplicates[primitiveIndexToScriptVariableLookup[[All,2]]]
                ];

                (* Get [[All,2]] of the LabeledObjects field. This is for only the objects *)
                allLabeledObjects=Map[
                  With[{insertMe1=#},
                    holdCompositionList[Part,{Hold[insertMe1],Hold[All],Hold[2]}]
                  ]&,
                  allLabeledObjectsWithNames
                ];

                allLabeledObjectsJoined=holdCompositionList[Join,allLabeledObjects];

                (* Restrict our samples *)
                (* Note that we are repeating this for the samples we already restricted earlier. This is to make sure the newly generated samples are also getting restricted too. For example, we picked a container earlier and did a Transfer of ss, we want the Object[Sample] to be restricted too so the sample is not picked up by another protocol. User can still refer to this container in later part of the script *)
                (* We only do this if we are not at the very last script cell. If we are at the last, we unrestict everything instead *)
                restrictSamplesCommand=If[!MatchQ[indexGroup,Last[Unflatten[Range[Length[Flatten[allPrimitiveGroupings]]], allPrimitiveGroupings]]],
                  With[{insertMe1=allLabeledObjectsJoined},
                    holdComposition[RestrictLabeledSamples,insertMe1]
                  ],
                  With[{insertMe1=allLabeledObjectsJoined},
                    holdComposition[UnrestrictLabeledSamples,insertMe1]
                    ]
                ];

                (* Convert any LabelField[...] syntax that we have to instead be downloads from our assigned variables. *)
                ReplaceAll[
                  {heldVariableAssignment,restrictSamplesCommand},
                  MapThread[#1->#2&,{allLabelFields,allDownloadSyntax}]
                ]/.{specialHoldHead->Download, specialHoldHead2->LookupLabeledObject}
              ]
            ],
            {
              allPrimitiveGroupings,
              allUnresolvedPrimitivesWithLabelFieldGroupings,
              FirstOrDefault/@allPrimitiveGroupingWorkCellInstruments,
              Unflatten[Range[Length[Flatten[allPrimitiveGroupings]]], allPrimitiveGroupings]
            }
          ]
        ];

        (* First, we need to go from {Hold[Set[...]], Hold[Set[...]]} to Hold[CompoundExpression[Set[...], Set[...]]]. *)
        heldCompoundExpression=With[{insertMe=heldScriptCells},
          holdCompositionList[CompoundExpression, insertMe]
        ];

        (* lookup if we need to add IgnoreWarnings to the script that we are generating - if users wish to Ignore them, we should let them *)
        ignoreWarnings = Lookup[safeOps, IgnoreWarnings];

        (* Then, put this into a script call. *)
        (* If we were told to Upload->False, append that before releasing the hold. *)
        uploadPackets=If[MatchQ[Lookup[safeOps, Upload], False] || !MemberQ[output, Result],
          With[{insertMe=Fold[Append,heldCompoundExpression, {Upload->False, ParentProtocol -> parentProtocol, IgnoreWarnings->ignoreWarnings,TimeConstraint->2 Hour, Autogenerated -> True}]},
            ECL`ExperimentScript@@insertMe
          ],
          With[{insertMe = Fold[Append,heldCompoundExpression, {ParentProtocol -> parentProtocol,IgnoreWarnings->ignoreWarnings,TimeConstraint->2 Hour, Autogenerated -> True}]},
            ECL`ExperimentScript@@insertMe
          ]
        ];

        uploadPackets
      ],

    (* Throw an error. Only the Experiment/ExperimentSamplePreparation[...] function can generate scripts. *)
    Length[allPrimitiveGroupings]>1,
      Module[{},
        Message[Error::InvalidMultipleUnitOperationGroups, Length[allPrimitiveGroupings], Map[Head,allPrimitiveGroupings,{2}], (Lookup[First[#][[1]], PrimitiveMethod]&)/@allPrimitiveGroupings];

        $Failed
      ],

    (* BELOW THIS LINE WE ARE GUARANTEED TO HAVE ONE PRIMITIVE GROUPING ONLY. *)

    (* We have one ManualSamplePreparation/ManualCellPreparation group. *)
    (* Create an Object[Protocol, ManualSamplePreparation/ManualCellPreparation]. *)
    Or[
      MatchQ[myFunction, ExperimentManualSamplePreparation|ExperimentManualCellPreparation],
      And[
        MatchQ[myFunction, Experiment|ExperimentSamplePreparation],
        MatchQ[Lookup[First[Flatten[allPrimitiveGroupings]][[1]], PrimitiveMethod], ManualSamplePreparation|ManualCellPreparation]
      ],
      And[
        MatchQ[myFunction, ExperimentCellPreparation],
        MatchQ[Lookup[First[Flatten[allPrimitiveGroupings]][[1]], PrimitiveMethod], ManualCellPreparation]
      ]
    ],
      Module[
        {protocolAndPrimitiveType,protocolPacket,labeledObjects,futureLabeledObjects,primitiveMethodIndex,
          userSpecifiedMethodGroupOptions,inputUnitOperationPackets,optimizedUnitOperationPackets,calculatedUnitOperationPackets,
          supplementaryPackets,outputUnitOperationsMinusResolvedOptions,outputUnitOperationPackets,
          primGroupingsWithLabels,outputUnitOperationPacketsWithLabelSampleAndContainer,simulatedObjectsToLabel,doubleGloveRequired,
          allSupplementalCertifications},

        (* Depending on what function we're in, either make a ManualSamplePreparation or ManualCellPreparation protocol. *)
        protocolAndPrimitiveType=Lookup[First[Flatten[allPrimitiveGroupings]][[1]], PrimitiveMethod];

        (* Get the options that the user gave us. *)
        primitiveMethodIndex=Lookup[First[allPrimitiveGroupings][[1]][[1]], PrimitiveMethodIndex];
        userSpecifiedMethodGroupOptions=If[!MatchQ[primitiveMethodIndex, _Integer],
          {},
          Lookup[primitiveMethodIndexToOptionsLookup, primitiveMethodIndex]
        ];

        (* lookup any advanced certification that is calculated from individual unit operations *)
        allSupplementalCertifications = DeleteDuplicates@Download[Flatten[Lookup[#, SupplementalCertification, Nothing]& /@ First[allPrimitiveOptionGroupings]], Object];

        (* Get our labeled objects for the Object[Protocol] level. *)
        {labeledObjects, futureLabeledObjects}=computeLabeledObjectsAndFutureLabeledObjects[Flatten[allPrimitiveGroupingResources]];

        (* Convert our unit operation primitives into unit operation objects. *)
        inputUnitOperationPackets=UploadUnitOperation[
          (Head[#]@KeyDrop[#[[1]], {PrimitiveMethod, PrimitiveMethodIndex, WorkCell}]&)/@flattenedIndexMatchingPrimitivesWithCorrectedLabelSample,
          UnitOperationType->Input,
          Preparation->Manual,
          FastTrack->True,
          Upload->False
        ];

        optimizedUnitOperationPackets = UploadUnitOperation[
          (Head[#]@KeyDrop[#[[1]], {PrimitiveMethod, PrimitiveMethodIndex, WorkCell}]&) /@ coverOptimizedPrimitives,
          UnitOperationType -> Optimized,
          Preparation -> Manual,
          FastTrack -> True,
          Upload -> False
        ];

        (* Create a map to convert any simulated objects back to their labels. *)
        simulatedObjectsToLabel = Module[{allObjectsInSimulation, simulatedQ},
          (* Get all objects out of our simulation. *)
          allObjectsInSimulation = Download[Lookup[currentSimulation[[1]], Labels][[All, 2]], Object];

          (* Figure out which objects are simulated. *)
          simulatedQ = simulatedObjectQs[allObjectsInSimulation, currentSimulation];

          (Reverse /@ PickList[Lookup[currentSimulation[[1]], Labels], simulatedQ]) /. {link_Link :> Download[link, Object]}
        ];

        primGroupingsWithLabels = First[allPrimitiveGroupings]/.simulatedObjectsToLabel;

        (* NOTE: Cannot fast track here because the options don't come back from the resolver expanded and FastTrack *)
        (* assumes that things are already expanded. *)
        calculatedUnitOperationPackets = UploadUnitOperation[
          (* NOTE: We have to translate from Object[...]s back to labels so that we don't try to upload simulated objects. *)
          (Head[#]@KeyDrop[#[[1]], {PrimitiveMethod, PrimitiveMethodIndex, WorkCell}]&) /@ primGroupingsWithLabels,
          UnitOperationType -> Calculated,
          Preparation -> Manual,
          Upload -> False
        ];

        (* NOTE: Cannot fast track here because the options don't come back from the resolver expanded and FastTrack *)
        (* assumes that things are already expanded. *)
        outputUnitOperationsMinusResolvedOptions = UploadUnitOperation[
          (* NOTE: We have to translate from Object[...]s back to labels so that we don't try to upload simulated objects. *)
          (Head[#]@KeyDrop[#[[1]], {PrimitiveMethod, PrimitiveMethodIndex, WorkCell}]&) /@ primGroupingsWithLabels,
          UnitOperationType -> Output,
          Preparation -> Manual,
          Upload -> False
        ];

        (* note that we need to add these back in because UploadUnitOperation doesn't put them in the field directly even if they're in the input *)
        outputUnitOperationPackets = MapThread[
          Join[
            #1,
            <|
              UnresolvedUnitOperationOptions -> #2[UnresolvedUnitOperationOptions],
              ResolvedUnitOperationOptions -> #2[ResolvedUnitOperationOptions]
            |>
          ]&,
          {outputUnitOperationsMinusResolvedOptions, primGroupingsWithLabels}
        ];

        (* NOTE: Our LabelSample/LabelContainer unit operation packets in manual are already made and have resources inside *)
        (* of them. For all other indices, we should have Null since we will not have asked for Output->Result from the Experiment *)
        (* function -- with the exception of LabelSample/LabelContainer. *)
        (* The only thing we would like to change from the output result of LabelSample/LabelContainer is that we want to make sure we are using the correct NEW unit operation ID. If a user runs the same command multiple times without clearing Memoization, we are not calling the LabelSample/LabelContainer resolver again. That means, the packet in allPrimitiveGroupingUnitOperationPackets has an existing Object[UnitOperation,LabelSample/LabelContainer] that may have been uploaded before. We should not use it again to cause multiple protocols sharing the same UO. *)
        (* We basically can combine the newly created UO ID from outputUnitOperationPackets, with the packets with resources from LabelContainer/LabelSample UO in allPrimitiveGroupingUnitOperationPackets *)
        outputUnitOperationPacketsWithLabelSampleAndContainer=MapThread[
          If[MatchQ[#2, PacketP[]], Join[#2,KeyTake[#1,Object]], #1]&,
          {outputUnitOperationPackets, Flatten[(If[MatchQ[#, {}], Null, #]&)/@First[allPrimitiveGroupingUnitOperationPackets]]}
        ];

        (* Gather all up of our auxilliary packets. *)
        supplementaryPackets=Cases[
          Join[
            inputUnitOperationPackets,
            optimizedUnitOperationPackets,
            calculatedUnitOperationPackets,
            outputUnitOperationPacketsWithLabelSampleAndContainer
          ],
          Except[Null]
        ];

        (* calculate if this protocol will need operator to double glove *)
        doubleGloveRequired=Module[{allFoundSamples,doubleGloveBooleans},
          (* ObjectReferenceP doesn't support list, so use 2 of them to get all object/model samples used in this protocol *)
          allFoundSamples = DeleteDuplicates@Cases[outputUnitOperationPacketsWithLabelSampleAndContainer,
            ObjectReferenceP[{Object[Sample],Model[Sample]}],
            Infinity];

          doubleGloveBooleans = Download[
            allFoundSamples,
            DoubleGloveRequired,
            Cache->cacheBall,
            Simulation->currentSimulation
            ];

          AnyTrue[doubleGloveBooleans,TrueQ]
        ];


        (* Create our protocol packet. *)
        protocolPacket=<|
          Object->CreateID[Object[Protocol, protocolAndPrimitiveType]],

          Replace[InputUnitOperations]->(Link[#, Protocol]&)/@Lookup[inputUnitOperationPackets, Object],
          Replace[OptimizedUnitOperations]->(Link[#, Protocol]&)/@Lookup[optimizedUnitOperationPackets, Object],
          Replace[CalculatedUnitOperations]->(Link[#, Protocol]&)/@Lookup[calculatedUnitOperationPackets, Object],
          Replace[OutputUnitOperations]->(Link[#, Protocol]&)/@Lookup[outputUnitOperationPacketsWithLabelSampleAndContainer, Object],

          (* NOTE: Resolved starts off the same as Unresolved and we update it inside of the loop. *)
          Module[{unresolvedUnitOperationInputs},
            unresolvedUnitOperationInputs=Map[
              Function[{unresolvedInputs},
                If[Length[unresolvedInputs]==1,
                  First[unresolvedInputs]/.{obj:ObjectP[]:>Download[obj, Object]},
                  unresolvedInputs/.{obj:ObjectP[]:>Download[obj, Object]}
                ]
              ],
              First[allPrimitiveInputsWithLabelFieldsGroupings]
            ];

            Sequence@@{
              Replace[UnresolvedUnitOperationInputs]->unresolvedUnitOperationInputs /. simulatedObjectsToLabel,
              Replace[ResolvedUnitOperationInputs]->unresolvedUnitOperationInputs /. simulatedObjectsToLabel
            }
          ],

          Module[{unresolvedUnitOperationOptions},
            unresolvedUnitOperationOptions=MapThread[
              Function[{unresolvedPrimitive, unresolvedOptions},
                (* No need to pass down post-processing options to LabelSample, LabelContainer, Wait, or any post processing primitives (MeasureWeight, ImageSample, MeasureVolume) since we don't do post-processing in those *)
                If[MatchQ[Head[unresolvedPrimitive], LabelSample|LabelContainer|Wait|MeasureWeight|ImageSample|MeasureVolume],
                  unresolvedOptions/.{obj:ObjectP[]:>Download[obj, Object]},
                  Join[
                    unresolvedOptions,
                    (* NOTE: These post-processing options only apply to ManualSamplePreparation. *)
                    If[MatchQ[protocolAndPrimitiveType, ManualSamplePreparation],
                      {
                        (* If the user has specific post-processing options to the primitive already, use those. *)
                        (* If the user has specific post-processing options as part of our method group use that. *)
                        (* If the user has specified them to the function itself (as SafeOptions), use that. *)
                        (* Otherwise, let the specific experiment function resolve the options. *)
                        postProcessingOption[MeasureWeight, unresolvedOptions, userSpecifiedMethodGroupOptions, safeOps],
                        postProcessingOption[ImageSample, unresolvedOptions, userSpecifiedMethodGroupOptions, safeOps],
                        postProcessingOption[MeasureVolume, unresolvedOptions, userSpecifiedMethodGroupOptions, safeOps]
                      },
                      {}
                    ]
                  ]/.{obj:ObjectP[]:>Download[obj, Object]}
                ]
              ],
              {
                First[allUnresolvedPrimitiveGroupings],
                First[allPrimitiveOptionsWithLabelFieldsGroupings]
              }
            ];

            Sequence@@{
              Replace[UnresolvedUnitOperationOptions]->unresolvedUnitOperationOptions,
              Replace[ResolvedUnitOperationOptions]->unresolvedUnitOperationOptions
            }
          ],

          Replace[LabeledObjects]->labeledObjects,
          Replace[FutureLabeledObjects]->futureLabeledObjects,

          (* always drop the cache and simulation from these fields *)
          UnresolvedOptions-> DeleteCases[ToList[myOptions], (Verbatim[Cache] -> _) | (Verbatim[Simulation] -> _)],
          ResolvedOptions-> DeleteCases[safeOps, (Verbatim[Cache] -> _) | (Verbatim[Simulation] -> _)],
          DoubleGloveRequired->doubleGloveRequired,

          Replace[Checkpoints]->{
            {"Picking Resources",15 Minute,"Samples required to execute this protocol are gathered from storage.", Null},
            {
              If[MatchQ[protocolAndPrimitiveType, ManualSamplePreparation],
                "Sample Preparation",
                "Cell Preparation"
              ],
              0 Minute,
              "The given unit operations are executed, in the order in which they are specified.",
              Resource[Operator->$BaselineOperator,Time->0 Minute]
            },
            {"Returning Materials",15 Minute,"Samples are returned to storage.",Resource[Operator->$BaselineOperator,Time->15 Minute]}
          },

          MeasureWeight->resolvedMeasureWeight,
          MeasureVolume->resolvedMeasureVolume,
          ImageSample->resolvedImageSample,

          Replace[OrdersFulfilled] -> Link[Cases[ToList[orderToFulfill], ObjectP[Object[Transaction, Order]]], Fulfillment],
          Replace[PreparedResources]->Link[Lookup[safeOps,PreparedResources,Null],Preparation]
        |>;

        (* Upload if asked to. *)
        Which[
          !MemberQ[output, Result],
            Null,
          True,
            ECL`InternalUpload`UploadProtocol[
              protocolPacket,
              supplementaryPackets,
              Upload->Lookup[safeOps,Upload],
              Confirm->Lookup[safeOps,Confirm],
              CanaryBranch->Lookup[safeOps,CanaryBranch],
              ParentProtocol->Lookup[safeOps,ParentProtocol],
              SupplementalCertification->allSupplementalCertifications,
              Priority->Lookup[safeOps,Priority],
              StartDate->Lookup[safeOps,StartDate],
              HoldOrder->Lookup[safeOps,HoldOrder],
              QueuePosition->Lookup[safeOps,QueuePosition],
              ConstellationMessage->{Object[Protocol, ManualSamplePreparation], Object[Protocol, ManualCellPreparation]},
              Simulation->currentSimulation
            ]
        ]
      ],

    (* We have one work cell group. Create a work cell protocol object. *)
    True,
      Module[
        {
          protocolType,allTipResources,tipRackResources,protocolPacket,tareContainers,labeledObjects,futureLabeledObjects,uniqueInstrumentResources,instrumentResourcesWithUpdatedTimeEstimate,cellContainerLinkResources,nonCellContainerLinkResources,
          livingCellContainerLinkResources,userSpecifiedOptions,primitiveMethodIndex,primitiveMethod,inputUnitOperationPackets,optimizedUnitOperationPackets,
          calculatedUnitOperationPackets,supplementaryPackets,skipTareFunction,samplesIn,containersIn,tipResourceReplacementRules,
          outputUnitOperationPackets,subOutputUnitOperationPackets,requiredObjects,plateReaderFields,simulatedObjectsToLabel, outputUnitOperationPacketsNotFlat,
          allOutputUnitOperationPacketsWithConsolidatedInjectionSampleResources,instrumentResourceReplaceRules,overclockQ,supplementaryPacketsMinusRootProtocol,
          overclockingPacket,finalInstrumentResources,colonyHandlerResource,liquidHandlerResource,estimatedNumberOfPositionsNeeded,
          allTransferUnitOperations,tipAdapter,tipAdapterResourceReplacementRule,tipAdapterResource,magnetizationRackResourceReplacementRules,modelSampleResourceReplacementRules
          ,experimentRunTime,instrumentInitializationTime,workCell,supplementalCertifications,allSupplementalCertifications},

        (* Depending on what function we're in, either make a ManualSamplePreparation or ManualCellPreparation protocol. *)
        protocolType=Lookup[First[Flatten[allPrimitiveGroupings]][[1]], PrimitiveMethod];

        (* figure out if we are using a tip adapter in any of the Transfer UOs in the group *)
        allTransferUnitOperations = Flatten@PickList[First[allPrimitiveGroupingUnitOperationPackets],MatchQ[_Transfer]/@First[allPrimitiveGroupings]];
        tipAdapter = If[Length[allTransferUnitOperations]==0, Null,
          FirstCase[Lookup[allTransferUnitOperations, TipAdapter], _Resource, Null]
        ];

        (* lookup any advanced certification that is calculated from individual unit operations *)
        supplementalCertifications = DeleteDuplicates@Download[Flatten[Lookup[#, SupplementalCertification, Nothing]& /@ First[allPrimitiveOptionGroupings]], Object];

        (* Get our labeled objects for the Object[Protocol] level. *)
        {labeledObjects, futureLabeledObjects}=computeLabeledObjectsAndFutureLabeledObjects[Flatten[allPrimitiveGroupingResources]];

        (* Compute our tip placements and tip resource replacement rules. *)
        (* NOTE: We have to perform tip resource replacement for each of our calculated unit operations (with tip resources inside) *)
        (* because each of our unit operations is making tip resources individually but the framework will group them together *)
        (* into combined resources. *)
        {allTipResources, tipRackResources, tipResourceReplacementRules} = Module[
          {flattenedStackedTipTuples, flattenedNonStackedTipTuples, stackedTipResources, nonStackedTipResources},

          (* Figure out the number of stacked and non-stacked tips that we're going to have in the form of *)
          (* {{ObjectP[Model[Item, Tip]], tipCountRequired_Integer}..} *)
          {flattenedStackedTipTuples, flattenedNonStackedTipTuples}=partitionTips[tipModelPackets, First[allPrimitiveGroupingTips], First[allPrimitiveGroupings]];

          (* Make resources for our stacked and non-stacked tip tuples. *)
          stackedTipResources=(Resource[Sample->#[[1]], Amount->#[[2]], UpdateCount -> False, Name->CreateUUID[]]&)/@flattenedStackedTipTuples;
          nonStackedTipResources=(Resource[Sample->#[[1]], Amount->#[[2]], UpdateCount -> False, Name->CreateUUID[]]&)/@flattenedNonStackedTipTuples;

          (* Return placement tuples in form {{tip object, {positions..}}..} *)
          {
            Join[
              stackedTipResources,
              nonStackedTipResources
            ],
            (* We only ask for tip racks if we're going onto the bioSTAR/microbioSTAR. *)
            (* On the regular STARs, the plan is to have the operator grab the entire blister pack of tips *)
            (* and move that to the liquid handler, load the tips from that, then put the blister pack back in the VLM. *)
            (* On the bioSTAR/microbioSTAR, the plan is to have the operator grab the entire blister pack to tips and a tip box, *)
            (* move to the BSC, then load in the tips sterile. *)
            (* NOTE that this isn't how it works right now, for the bioSTAR, we load in tips directly, but this is the plan. *)
            If[MatchQ[myFunction, ExperimentCellPreparation|ExperimentRoboticCellPreparation],
              With[{length = If[NullQ[tipAdapter], Length[nonStackedTipResources], Length[nonStackedTipResources]+1]},
                Table[
                  Resource[
                    Sample->Model[Container,Rack,"id:7X104vn9E4nZ"],
                    Name->CreateUUID[]
                  ],
                  length]
              ],
              {}
            ], (* Model[Container, Rack, "Sterile Hamilton Tip Box"] *)
            (* NOTE: This isn't entirely accurate because if we have multiple racks of tips of the same model, it'll be replaced *)
            (* with the first resource instance -- instead of tracking with the exact Object[Item, Tip]s that were used. *)
            (Resource[KeyValuePattern[Sample->(ObjectReferenceP[Lookup[#[[1]], Sample]]|LinkP[Lookup[#[[1]], Sample]])]] -> #&)/@Join[stackedTipResources, nonStackedTipResources]
          }
        ];

        (* Combine the sample resources *)
        (* This includes two different cases: *)
        (* 1) Multiple resources of the same Model[Sample] and their total volume still fit in the same container's MaxVolume. We can create one resource and request the total volume *)
        (* 2) Multiple resources require the same incubation parameters and same container model. We can share the same container model but put the resources into different wells *)
        (* This part is the same as what we did for footprint check in UO resolver *)
        modelSampleResourceReplacementRules=Module[
          {modelSampleResources,modelSampleResourcesToCombine,resourceCache,accumulatedResourceTuples,modelSampleResourcesWithContainerNames},
          modelSampleResources=Cases[
            allPrimitiveGroupingUnitOperationPackets,
            Resource[KeyValuePattern[{Type->Object[Resource,Sample],Sample->ObjectP[Model[Sample]],Amount->VolumeP,Container->ListableP[ObjectP[Model[Container]]],ConsolidateTransferResources->True}]],
            Infinity
          ];
          modelSampleResourcesToCombine=Select[
            modelSampleResources,
            !KeyExistsQ[#[[1]],ContainerName]&
          ];
          (* Download some information about the container models to make a smaller cache for future lookup *)
          resourceCache=Flatten@Quiet[
            Download[
              DeleteDuplicates@Flatten[Lookup[modelSampleResourcesToCombine[[All,1]],Container,{}]],
              Packet[Positions,MaxVolume,MinVolume],
              Simulation->currentSimulation,
              Cache->cacheBall
            ],
            {Download::FieldDoesntExist, Download::NotLinkField}
          ];

          (* Track the processed resource blobs *)
          accumulatedResourceTuples={};
          modelSampleResourcesWithContainerNames=Map[
            Function[
              {resourceBlob},
              Module[
                {containerModels,containerModelPacket,containerMaxVolume,containerPositions,sampleModel,sourceTemperature,sourceEquilibrationTime,maxSourceEquilibrationTime,volume,accumulatedResourceTuplesMatchingContainerModels,existingSampleModelResourceTuples,existingContainerModelResourceTuples,containerNameVolumeTuples,containerNamePositionTuples,updatedContainerModels,containerName,well,newResourceTuple,updatedAccumulatedResourceTuples},
                (* Get all the possible models *)
                containerModels=ToList[Download[Lookup[resourceBlob[[1]],Container],Object]];
                (* Get the model of the sample *)
                sampleModel=Download[Lookup[resourceBlob[[1]],Sample],Object];
                (* Get the incubation parameters (this has to match for the resources to consolidate or group *)
                sourceTemperature=Lookup[resourceBlob[[1]],SourceTemperature,Null];
                sourceEquilibrationTime=Lookup[resourceBlob[[1]],SourceEquilibrationTime,Null];
                maxSourceEquilibrationTime=Lookup[resourceBlob[[1]],MaxSourceEquilibrationTime,Null];
                volume=Lookup[resourceBlob[[1]],Amount];

                (* Get the accumulated resources with at least one matching container model *)
                accumulatedResourceTuplesMatchingContainerModels=Select[
                  accumulatedResourceTuples,
                  IntersectingQ[#[[2]],containerModels]&
                ];

                (* Get the existing resources with the same model and container model. See if we can fit the new volume into the same resource *)
                existingSampleModelResourceTuples=Cases[accumulatedResourceTuplesMatchingContainerModels,{sampleModel,_,sourceTemperature,sourceEquilibrationTime,maxSourceEquilibrationTime,_,_,_}];
                (* Get the existing resources with the same container model and incubation parameters see if it has more position for new resource *)
                existingContainerModelResourceTuples=Cases[accumulatedResourceTuplesMatchingContainerModels,{_,_,sourceTemperature,sourceEquilibrationTime,maxSourceEquilibrationTime,_,_,_}];

                (* Group the existing resource tuples by ContainerName and Well. If we consolidate some of the previous resources, we have assigned the same well and will need to add the volumes together *)
                (* Group the existing resource tuples by ContainerName and Well. If we consolidate some of the previous resources, we have assigned the same well and will need to add the volumes together *)
                containerNameVolumeTuples=Map[
                  Function[
                    {resourceTupleGroup},
                    Module[
                      {totalVolume,commonContainers,containerModelPackets,containerMaxVolumes,containerMinVolumes,sourceContainerDeadVolumes,qualifiedContainers},
                      totalVolume=Total[Flatten[{resourceTupleGroup[[All,-3]],volume}]];
                      commonContainers=UnsortedIntersection[containerModels,resourceTupleGroup[[1,2]]];
                      containerModelPackets=fetchPacketFromCache[#,resourceCache]&/@commonContainers;
                      containerMaxVolumes=Lookup[containerModelPackets,MaxVolume,Null];
                      containerMinVolumes=Lookup[containerModelPackets,MinVolume,Null];
                      (* Get the dead volume of the container *)
                      (* use the MinVolume of the container as the required dead volume. If not available, use 10% of max volume *)
                      sourceContainerDeadVolumes=MapThread[
                        If[!NullQ[#2],
                          #2,
                          0.1 * #1
                        ]&,
                        {containerMaxVolumes,containerMinVolumes}
                      ];

                      (* Select the large enough container model(s) *)
                      qualifiedContainers=MapThread[
                        If[TrueQ[(totalVolume+#3)<#2],
                          #1,
                          Nothing
                        ]&,
                        {commonContainers,containerMaxVolumes,sourceContainerDeadVolumes}
                      ];

                      If[Length[qualifiedContainers]==0,
                        (* Do no track if the volume is too large for all models *)
                        Nothing,
                        (* Track the total volume, updated container models and containerName/well tuple  *)
                        {totalVolume,qualifiedContainers,resourceTupleGroup[[1,-2]],resourceTupleGroup[[1,-1]]}
                      ]
                    ]
                  ],
                  GatherBy[existingSampleModelResourceTuples,(#[[-2;;-1]])&]
                ];

                containerNamePositionTuples=Map[
                  Function[
                    {resourceTupleGroup},
                    Module[
                      {commonContainers,containerModelPackets,containerPositions,occupiedPositions,qualifiedContainers,emptyPosition},
                      commonContainers=UnsortedIntersection[containerModels,resourceTupleGroup[[1,2]]];
                      containerModelPackets=fetchPacketFromCache[#,resourceCache]&/@commonContainers;
                      containerPositions=Lookup[containerModelPackets,Positions,{}];

                      (* Get the positions occupied *)
                      occupiedPositions=DeleteDuplicates[resourceTupleGroup[[All,-1]]];

                      (* Select the large enough container model(s) and track container model and first open position *)
                      qualifiedContainers=MapThread[
                        If[MatchQ[Complement[Lookup[#2,Name,{}],occupiedPositions],{}],
                          Nothing,
                          {#1,Sort@Complement[Lookup[#2,Name,{}],occupiedPositions]}
                        ]&,
                        {commonContainers,containerPositions}
                      ];

                      (* We always fill resource containers in sorted order so select the common empty position of all container models to use *)
                      emptyPosition=If[Length[qualifiedContainers]>0,
                        First[Intersection@@(qualifiedContainers[[All,2]])],
                        Null
                      ];

                      If[Length[qualifiedContainers]==0,
                        (* Do no track if the volume is too large for all models *)
                        Nothing,
                        (* Track the first open position, updated container models and containerName/well tuple  *)
                        {qualifiedContainers[[All,1]],emptyPosition,resourceTupleGroup[[1,-2]]}
                      ]
                    ]
                  ],
                  GatherBy[existingContainerModelResourceTuples,(#[[-2]])&]
                ];

                (* Select the existing resource position to consolidate or create a new one *)
                {updatedContainerModels,containerName,well}=Which[
                  Length[containerNameVolumeTuples]>0,
                  (* Select the resource position that prepares largest volume to get the best efficiency for resouce consolidation *)
                  ReverseSortBy[containerNameVolumeTuples,First][[1,2;;4]],
                  Length[containerNamePositionTuples]>0,
                  (* Use the first possible position *)
                  {containerNamePositionTuples[[1,1]],containerNamePositionTuples[[1,3]],containerNamePositionTuples[[1,2]]},
                  True,
                  (* Use a UUID and "A1" position for new resource *)
                  {containerModels,CreateUUID[],"A1"}
                ];

                (* create the new resource tuple to be tracked and also return the updated *)
                newResourceTuple={sampleModel,updatedContainerModels,sourceTemperature,sourceEquilibrationTime,maxSourceEquilibrationTime,volume,containerName,well};

                (* Update the accumulated resource tuple list to reflect updated containerModels for the same containerName *)
                updatedAccumulatedResourceTuples=ReplacePart[
                  accumulatedResourceTuples,
                  ({#,2}->updatedContainerModels)&/@Flatten[Position[accumulatedResourceTuples,{___,containerName,_}]]
                ];

                accumulatedResourceTuples=Append[updatedAccumulatedResourceTuples,newResourceTuple];
                {resourceBlob,updatedContainerModels,containerName,well}
              ]
            ],
            DeleteDuplicates[modelSampleResourcesToCombine]
          ];

          (* Group modelSampleResourcesWithContainerNames by ContainerName and Well so we can create resources to update *)
          Flatten@Map[
            Function[
              {resourceTuples},
              Module[
                {resourceBlobs,containerModel,containerName,well,containerModelPacket,containerMaxVolume,containerMinVolume,sourceContainerDeadVolume,totalVolume,totalVolumeRoundedUp,newResource},
                resourceBlobs=resourceTuples[[All,1]];
                (* Use the first container model as the model since we are going to use this to determine dead volume *)
                (* Have to use the last resource's model list because we may have deleted some models as we go on and we don't go back to update the models of previous handled resource *)
                containerModel=First[resourceTuples[[-1,2]]];
                containerName=resourceTuples[[1,3]];
                well=resourceTuples[[1,4]];

                (* Get the dead volume of the container *)
                containerModelPacket=fetchPacketFromCache[containerModel,resourceCache];
                containerMaxVolume=Lookup[containerModelPacket,MaxVolume,Null];
                containerMinVolume=Lookup[containerModelPacket,MinVolume,Null];
                sourceContainerDeadVolume=Which[
                  NullQ[containerMinVolume]&&NullQ[containerMaxVolume],
                  0Microliter,
                  NullQ[containerMinVolume],
                  0.1*containerMaxVolume,
                  True,
                  containerMinVolume
                ];

                (* Add total resource volume with dead volume *)
                totalVolume=Total[Lookup[resourceBlobs[[All,1]],Amount]]+sourceContainerDeadVolume;
                (*Round total volume to avoid tiny amount accumulates to large amount with too small of a precision. e.g. filling a few plates with 500.7uL and ends up requesting 101.642 mL. *)
                totalVolumeRoundedUp = Which[
                  (*If the total volume gets greater than 100 mL, round it up to 1mL precision*)
                  GreaterQ[totalVolume,100*Milliliter],
                    SafeRound[totalVolume,1.0*Milliliter,Round->Up],
                  (*If the total volume gets greater than 10 mL, round it up to 0.1mL precision*)
                  GreaterQ[totalVolume,10*Milliliter],
                    SafeRound[totalVolume,0.1*Milliliter,Round->Up],
                  (*Otherwise, leave as it is *)
                  True,
                  totalVolume];

                newResource=Resource[
                  Join[
                    resourceTuples[[1,1,1]],
                    <|
                      Amount->totalVolumeRoundedUp,
                      Name->CreateUUID[],
                      Container->containerModel,
                      ContainerName->containerName,
                      Well->well
                    |>
                  ]
                ];
                (#->newResource)&/@resourceBlobs
              ]
            ],
            (* Group the resources with same container name and well *)
            GatherBy[modelSampleResourcesWithContainerNames,(#[[3;;4]])&]
          ]
        ];

        (* Compute MagnetizationRack resource replacement rules. Similar to tips, we want all magnetization rack  *)
        (* resources to be replaced with the same resource because the same magnetization rack is used for every uo that needs it *)
        magnetizationRackResourceReplacementRules = Module[{magnetizationRackResources,uniqueMagnetizationRacks},
          magnetizationRackResources = Cases[allPrimitiveGroupingUnitOperationPackets,KeyValuePattern[Sample -> LinkP[Model[Item, MagnetizationRack]]|ObjectReferenceP[Model[Item, MagnetizationRack]]],Infinity];
          uniqueMagnetizationRacks = DeleteDuplicates[Lookup[#,Sample]&/@magnetizationRackResources];
          (Resource[KeyValuePattern[Sample->(ObjectP[#])]] -> Resource[Sample->#, Name -> CreateUUID[]]&)/@uniqueMagnetizationRacks
        ];

        (* Determine if we want to get the tare weight for an object *)
        skipTareFunction[containerResource_, cache_]:=Module[{containerObject,containerPacket,containerModelPacket,containerModelsToNotTareWeigh},
          (* Get the container object. *)
          containerObject=Lookup[containerResource[[1]], Sample];

          (* Get the packet. *)
          {containerPacket,containerModelPacket}=If[MatchQ[containerObject,ObjectP[Model[Container]]],
            {<||>,fetchPacketFromCache[containerObject,cache]},
            Module[{packet,model,modelPacket},
              packet = fetchPacketFromCache[containerObject,cache];
              model = Lookup[packet,Model,Null];
              modelPacket = fetchPacketFromCache[model,cache];
              {packet,modelPacket}
            ]
          ];

          containerModelsToNotTareWeigh={
            (* Phytip columns -- we throw these out at the end so there's no point in tare weighing. *)
            Model[Container, Vessel, "id:zGj91a7nlzM6"]
          };

          Or[
            (* It's impossible to tare this container -- note that this matches the logic in MeasureWeight. *)
            !MatchQ[Lookup[containerModelPacket, Object], ObjectP[MeasureWeightModelContainerTypes]],
            MatchQ[Lookup[containerModelPacket,Immobile,Null],True],
            MatchQ[Lookup[containerModelPacket,Ampoule,Null],True],
            Length[Lookup[containerPacket,Contents,{}]]!=0,

            (* Or we just don't want to tare weight this container. *)
            MatchQ[Lookup[containerPacket,TareWeight,Null],MassP],
            MatchQ[Lookup[containerModelPacket,Object,Null],ObjectReferenceP[containerModelsToNotTareWeigh]]
          ]
        ];

        (* Get our containers that we need to tare. *)
        tareContainers=If[MatchQ[Lookup[resolvedOptions, TareWeighContainers], False],
          {},
          Module[{containerResources, containerCache},
            (* Get all of the container resources. We only care about containers because if we already have a sample *)
            (* in it, we cannot get a tare weight. We are looking for empty containers. *)
            (* NOTE: Lookup from LabeledObjects because these objects will exist immediately after resource picking. *)
            containerResources=Cases[
              labeledObjects[[All,2]],
              Resource[KeyValuePattern[Sample->ObjectP[{Object[Container], Model[Container]}]]]
            ];

            (* Make sure that we have all of the cache information. *)
            containerCache=Flatten@Download[
              {
                Cases[containerResources, ObjectP[Object[Container]], Infinity],
                Cases[containerResources, ObjectP[Model[Container]], Infinity]
              },
              {
                {Packet[TareWeight, Model, Contents], Packet[Model[{Immobile, Object}]]},
                {Packet[Immobile, Object]}
              },
              Cache->cacheBall,
              Simulation->currentSimulation
            ];

            PickList[containerResources, (skipTareFunction[#, containerCache]&)/@containerResources, False]
          ]
        ];

        (* When dealing with cell samples, we do NOT want to post-process them after the robotic protocol is complete. *)
        (* This is because post-processing will take too long and kill the cells. We therefore store container resources *)
        (* that will have cells in them in a separate field so that we don't pass them down to the post-processing *)
        (* subprotocols. Also determine whether a container contains Living cells. *)
        {cellContainerLinkResources, livingCellContainerLinkResources, nonCellContainerLinkResources}=If[MatchQ[protocolType,RoboticCellPreparation],
          Module[
            {simulatedObjects, containerResult, simulatedContainers, labeledContainers, containerResources,
              sampleResult, simulatedSamples, sampleObjects, sampleResources, containerContentPackets,
              containerIncludesCellsQ, nonCellContainerResources,cellContainerResources, sampleContainsCellsQ,
              containerIncludesLivingCellsQ, sampleContainsLivingCellsQ, nonCellSampleResources, cellSampleResources, livingCellContainerResources},

            (* Get the objects that correspond to our labels. *)
            (* NOTE: Lookup from LabeledObjects because these objects will exist immediately after resource picking. *)
            simulatedObjects=(Lookup[Lookup[currentSimulation[[1]], Labels],#]&)/@labeledObjects[[All,1]];

            (* Partition labeled objects into containers and samples. *)
            containerResult=PickList[labeledObjects, simulatedObjects, ObjectP[Object[Container]]];
            simulatedContainers=Cases[simulatedObjects, ObjectP[Object[Container]]];
            {labeledContainers, containerResources}=If[Length[containerResult]==0,
              {{},{}},
              Transpose[containerResult]
            ];

            sampleResult=PickList[labeledObjects, simulatedObjects, ObjectP[Object[Sample]]];
            simulatedSamples=Cases[simulatedObjects, ObjectP[Object[Sample]]];
            {sampleObjects, sampleResources}=If[Length[sampleResult]==0,
              {{},{}},
              Transpose[sampleResult]
            ];

            (* Download information from our simulated objects. *)
            (* NOTE: We are downloading from the very last simulation here so this will reflect the contents of the *)
            (* containers after all manipulations on the robot are completed. *)
            {samplePackets, containerContentPackets}=Quiet[
              Download[
                {
                  simulatedSamples,
                  simulatedContainers
                },
                {
                  {Packet[CellType]},
                  {Packet[Contents[[All,2]][{CellType, Living}]]}
                },
                Cache->cacheBall,
                Simulation->currentSimulation
              ],
              {Download::NotLinkField,Download::MissingCacheField}
            ];
            samplePackets=Flatten@samplePackets;
            containerContentPackets=Flatten/@containerContentPackets;

            (* Determine which containers/samples contain cells. *)
            containerIncludesCellsQ=(MemberQ[Lookup[#, CellType, Null], Except[Null]]&)/@containerContentPackets;
            sampleContainsCellsQ=(MatchQ[Lookup[#, CellType], CellTypeP]&)/@samplePackets;

            (* Determine which containers contain Living cells. *)
            containerIncludesLivingCellsQ=(MemberQ[Lookup[#, Living, Null], True]&)/@containerContentPackets;

            (* Pick containers/samples that will not have cell samples in them, and those that will have living cells. *)
            nonCellContainerResources=PickList[containerResources, containerIncludesCellsQ, False];
            cellContainerResources=PickList[containerResources, containerIncludesCellsQ];
            livingCellContainerResources=PickList[containerResources, containerIncludesLivingCellsQ];

            nonCellSampleResources=PickList[sampleResources, sampleContainsCellsQ, False];
            cellSampleResources=PickList[sampleResources, sampleContainsCellsQ];

            (* Return the value accordingly *)
            {Join[cellContainerResources, cellSampleResources], livingCellContainerResources, Join[nonCellContainerResources, nonCellSampleResources]}
          ],
          {{},{},labeledObjects[[All,2]]}
        ];

        (* ASSUME that each primitive knows how many instrument models will be available on deck. Right now the only *)
        (* primitive that can use multiple of the same Model[Instrument] at the same time is the Incubate/Mix primitive *)
        (* and since every liquid handler as exactly 4 incubate positions on deck, this is hard coded into the Incubate/Mix *)
        (* primitive when it resolves its Batches option. *)
        (* Therefore, we only make 1 request for each Model[Instrument] on/off deck. *)
        uniqueInstrumentResources=DeleteDuplicatesBy[
          Flatten[allPrimitiveGroupingIntegratedInstrumentResources],
          (Download[Lookup[#[[1]], Instrument], Object]&)
        ];

        (* Figure out what primitive method we're dealing with for this group. *)
        primitiveMethod=Lookup[Flatten[allPrimitiveGroupings][[1]][[1]], PrimitiveMethod];
        primitiveMethodIndex=Lookup[Flatten[allPrimitiveGroupings][[1]][[1]], PrimitiveMethodIndex];

        liquidHandlerResource = Module[{liquidHandler},
          (* determine a liquid handler model/object to use *)
          liquidHandler = Which[
            (* if we have decided on a liquid handler object to use, use that for sure *)
            MemberQ[Flatten[allPrimitiveGroupingWorkCellInstruments], ObjectP[Object[Instrument, LiquidHandler]]],
              FirstCase[DeleteDuplicates[Flatten[allPrimitiveGroupingWorkCellInstruments]], ObjectP[Object[Instrument, LiquidHandler]]],
            (* otherwise we allow all supported instrument models *)
            MemberQ[Flatten[allPrimitiveGroupingWorkCellInstruments], ObjectP[Model[Instrument, LiquidHandler]]],
              DeleteDuplicates[Download[Flatten[allPrimitiveGroupingWorkCellInstruments], Object]],
            (* special treatment that allPrimitiveGroupingWorkCellInstruments maybe {} when this primitive group is made up with only LabelSample/LabelContainer/Wait dummy operations, in this case we should still give it a instrument anyway *)
            MatchQ[Flatten[allPrimitiveGroupingWorkCellInstruments], {}] && MatchQ[Flatten[allPrimitiveGroupings], {$DummyPrimitiveP..}],
              Module[{dummyPrimitive},
                (* get the first dummy primitive, _LabelSample | _LabelContainer | _Wait *)
                dummyPrimitive = First[Flatten[allPrimitiveGroupings], <||>];

                (* now try to assign an instrument *)
                Which[
                  (* if user supplies an instrument within a primitive grouping option, use that *)
                  MatchQ[Lookup[Lookup[primitiveMethodIndexToOptionsLookup, primitiveMethodIndex, <||>], Instrument, Null], ObjectP[{Model[Instrument], Object[Instrument]}]],
                    Lookup[Lookup[primitiveMethodIndexToOptionsLookup, primitiveMethodIndex], Instrument],
                  (* otherwise if user supplies an instrument using the global Instrument option, use that *)
                  MatchQ[Lookup[safeOps, Instrument], ObjectP[{Model[Instrument], Object[Instrument]}]],
                    Lookup[safeOps, Instrument],
                  (* otherwise get the instrument determined from the resolved work cell *)
                  True,
                    Lookup[$WorkCellsToInstruments, Lookup[dummyPrimitive[[1]], WorkCell]]
                ]
              ],
            True,
              Null
          ];

          (* make resource *)
          If[NullQ[liquidHandler],
            Null,
            (* make a resource if we can find a liquid handler instrument to use *)
            Resource[
              Instrument -> liquidHandler,
              (* we will update the time later on in the code *)
              Time -> 1 Minute
            ]
          ]
        ];

        workCell=workCellFromLiquidHandler[liquidHandlerResource];
        (* Replace each instrument resource with the entire length of time that it'll take to complete the entire run *)
        (* since we can't release the integrations mid-run. *)
        instrumentInitializationTime=Module[{tipCountingTime},
          (* this is our safety clause - we don't do this calculation for neither qpix or if we somehow got an unexpected workcell *)
          If[
            MatchQ[workCell,qPix|_String],
            Return[0Minute,Module]
          ];

          (* now we are on Hamilton *)
          tipCountingTime=If[MatchQ[workCell,bioSTAR|microbioSTAR],
            (* only 7 tip boxes on deck *)
            Min[{Length[allTipResources],7}],
            (*STARs can have up to 10 tips *)
            Min[{Length[allTipResources],10}]
          ]*1 Minute;

          Total[{
            5 Minute,(* initialization of the instrument *)
            tipCountingTime,
            1Minute,(* HHS initialization - we always initialize them on all instruments *)
            10 Minute,(* instrument container setup *)
            10Minute (* instrument teardown, this is lower than the one in a couple of experiments I saw, but feels like this should be enough *)
          }]
        ];
        totalWorkCellTime=Max[{
          1 Minute,
          Total[ToList[Replace[First[allPrimitiveGroupingRunTimes],{Except[TimeP]->0 Minute},{1}]]]+instrumentInitializationTime
        }];
        (* we use this number for calculating how long we might be holding operator if we don't go into the InstrumentProcessing stage, initialization/teardown doesn't count here *)
        experimentRunTime=totalWorkCellTime-instrumentInitializationTime;

        (* now that we have calculated the correct time that we expect to use on the instrument, we need to update the resource request *)
        liquidHandlerResource =If[MatchQ[liquidHandlerResource,_Resource],
            Resource[
              Instrument->Lookup[liquidHandlerResource[[1]],Instrument],
              (* NOTE: We should be given back valid time estimates here, but if we're not default to 1 minute so we make *)
              (* a valid resource and don't error on upload. *)
              Time->If[MatchQ[totalWorkCellTime,GreaterP[1 Minute]],totalWorkCellTime,1 Minute]
            ]
        ];

        instrumentResourcesWithUpdatedTimeEstimate=(
          Resource[
            Instrument->Lookup[#[[1]], Instrument],
            Name->CreateUUID[],
            Time->totalWorkCellTime
          ]
              &)/@uniqueInstrumentResources;

        (* Create instrument resource replace rules to replace instrument resources inside of the output unit operations. *)
        instrumentResourceReplaceRules=(
          Verbatim[Resource][KeyValuePattern[Instrument->ObjectP[Lookup[#[[1]], Instrument]]]]->#
              &)/@instrumentResourcesWithUpdatedTimeEstimate;

        (* Get the options that the user gave us. *)
        userSpecifiedOptions=If[!MatchQ[primitiveMethodIndex, _Integer],
          safeOps,
          ReplaceRule[safeOps, Lookup[primitiveMethodIndexToOptionsLookup, primitiveMethodIndex]]
        ];

        (* Convert our unit operation primitives into unit operation objects. *)
        inputUnitOperationPackets=UploadUnitOperation[
          (Head[#]@KeyDrop[#[[1]], {PrimitiveMethod, PrimitiveMethodIndex, WorkCell}]&)/@flattenedIndexMatchingPrimitivesWithCorrectedLabelSample,
          UnitOperationType->Input,
          Preparation->Robotic,
          FastTrack->True,
          Upload->False
        ];

        optimizedUnitOperationPackets=UploadUnitOperation[
          (Head[#]@KeyDrop[#[[1]], {PrimitiveMethod, PrimitiveMethodIndex, WorkCell}]&)/@coverOptimizedPrimitives,
          UnitOperationType->Optimized,
          Preparation->Robotic,
          FastTrack->True,
          Upload -> False
        ];

        (* Create a map to convert any simulated objects back to their labels. *)
        simulatedObjectsToLabel = Module[{allObjectsInSimulation, simulatedQ},
          (* Get all objects out of our simulation. *)
          allObjectsInSimulation = Download[Lookup[currentSimulation[[1]], Labels][[All, 2]], Object];

          (* Figure out which objects are simulated. *)
          simulatedQ = simulatedObjectQs[allObjectsInSimulation, currentSimulation];

          (Reverse /@ PickList[Lookup[currentSimulation[[1]], Labels], simulatedQ]) /. {link_Link :> Download[link, Object]}
        ];

        (* NOTE: Cannot fast track here because the options don't come back from the resolver expanded and FastTrack *)
        (* assumes that things are already expanded. *)
        calculatedUnitOperationPackets=UploadUnitOperation[
          (* NOTE: We have to translate from Object[...]s back to labels so that we don't try to upload simulated objects. *)
          (Head[#]@KeyDrop[#[[1]], {PrimitiveMethod, PrimitiveMethodIndex, WorkCell}]&)/@(First[allPrimitiveGroupings]/.simulatedObjectsToLabel),
          UnitOperationType->Calculated,
          Preparation->Robotic,
          Upload->False
        ];

        tipAdapterResource = If[!NullQ[tipAdapter],Resource[Sample->Model[Item,"id:Y0lXejMp6aRV"],Rent->True,Name->CreateUUID[]]];
        tipAdapterResourceReplacementRule = If[NullQ[tipAdapter],
          {},
          {Rule[
            Resource[KeyValuePattern[Sample->(ObjectReferenceP[Model[Item,"id:Y0lXejMp6aRV"]] | LinkP[Model[Item,"id:Y0lXejMp6aRV"]])]],
            tipAdapterResource
          ]}
        ];

        (* NOTE: We put resources in our unit operation packets for Preparation->Robotic. *)
        (* NOTE: Our unitOperationPackets is a list since we get back a list of unit operation packets back from the *)
        (* resource packets function since our unit operation can have a unit operation sub (ex. Transfer inside Filter). *)
        (* since we can spin off two parent UOs from a single experiment (with the LabelSample example/model input), we need to flatten the outputUnitOperations later *)
        {outputUnitOperationPacketsNotFlat, subOutputUnitOperationPackets}=Module[{unitOperationObjectsReplaceRules},
          (* Create new IDs for any unit operations that we fetched from our cache. *)
          unitOperationObjectsReplaceRules=If[Length[outputUnitOperationObjectsFromCache]>0,
            Rule@@@Transpose[{
              outputUnitOperationObjectsFromCache,
              CreateID[Download[outputUnitOperationObjectsFromCache, Type]]
            }],
            {}
          ];

          Transpose@Map[
            Function[{unitOperationPackets},
              Module[{strippedUnitOperationPackets, roboticUnitOperations, pcrAssayPlateUnitOperations, roboParentPosition, pcrParentPosition, parentUOPackets, childUOPackets},
                (* Strip off the LabeledObjects field from the Object[UnitOperation]s. They should only be kept *)
                (* in the parent protocol. *)
                strippedUnitOperationPackets=(KeyDrop[#, Replace[LabeledObjects]]&)/@unitOperationPackets;

                (* determine if these are a parent UO and subsequent sub-UOs, or if it's something like LabelSample + Filter where we want to have multiple unit operations at the top level *)
                roboticUnitOperations = Lookup[strippedUnitOperationPackets, Replace[RoboticUnitOperations]];
                roboParentPosition = Position[roboticUnitOperations, {ObjectP[]..}, {1}];
                (* in PCR primitive the sub UOs live in a different field.*)
                pcrAssayPlateUnitOperations = Lookup[strippedUnitOperationPackets, Replace[AssayPlateUnitOperations]];
                pcrParentPosition = Position[pcrAssayPlateUnitOperations, {ObjectP[]..}, {1}];

                {parentUOPackets, childUOPackets} = Which[
                  MatchQ[roboParentPosition, {}] && MatchQ[pcrParentPosition, {}],
                   {strippedUnitOperationPackets, {}},
                  !MatchQ[pcrParentPosition, {}],
                  (*We have a PCR parent*)
                    TakeDrop[strippedUnitOperationPackets, pcrParentPosition[[1]]],
                  True,
                  (*We have any other type of parent UO*)
                    TakeDrop[strippedUnitOperationPackets, roboParentPosition[[1]]]
                ];


                {
                  Map[
                    Join[
                      #,
                      <|
                        UnitOperationType->Output,
                        Preparation->Robotic
                      |>
                    ]&,
                    parentUOPackets
                  ],
                  childUOPackets
                }
              ]

            ],
            (First[allPrimitiveGroupingUnitOperationPackets]/.Join[tipResourceReplacementRules,magnetizationRackResourceReplacementRules,modelSampleResourceReplacementRules,tipAdapterResourceReplacementRule,counterWeightResourceReplacementRules])/.unitOperationObjectsReplaceRules
          ]
        ];
        outputUnitOperationPackets = Flatten[outputUnitOperationPacketsNotFlat];

        (* -- Compute Injection Sample Resources for Plate Reader Primitives -- *)
        plateReaderFields=Module[{injectionResourceGroups},

          (* NOTE: We already did error checking during our MapThread to make sure that we don't have more than 2 *)
          (* injection samples. *)
          injectionResourceGroups=computeInjectionSampleResourceGroups[First[allPrimitiveGroupings]];

          MapThread[
            Function[{instrumentObject, injectionResources, index},
              Module[{primaryInjectionSample, secondaryInjectionSample, numberOfInjectionContainers, anyInjectionsQ,
                washVolume, fields},

                primaryInjectionSample = If[Length[injectionResources]>0,
                  injectionResources[[1]],
                  Null
                ];
                secondaryInjectionSample = If[Length[injectionResources]>1,
                  injectionResources[[2]],
                  Null
                ];

                numberOfInjectionContainers = Which[
                  !NullQ[secondaryInjectionSample],
                  2,
                  !NullQ[primaryInjectionSample],
                  1,
                  True,
                  0
                ];

                anyInjectionsQ = Or[
                  !NullQ[primaryInjectionSample],
                  !NullQ[secondaryInjectionSample]
                ];


                (* Wash each line being used with the flush volume - request a little extra to avoid air in the lines *)
                (* Always multiply by 2 - either we'll use same resource for prepping and flushing or we have two lines to flush *)
                washVolume = ($BMGFlushVolume + 2.5 Milliliter) * 2;

                (*
                  Prepping/Flushing Overview:
                  - ethanol (25mL per line) PrimaryPurgingSolvent
                  - water (25mL per line) SecondaryPurgingSolvent
                  - prime samples ($BMGPrimeVolume)
                  - run
                  - ethanol (25mL per line) PrimaryPurgingSolvent
                  - water (25mL per line) SecondaryPurgingSolvent

                  - If using 1 line, request 1 x 50mL of 70% Ethanol and 1 x 50mL of Water
                  - If using 2 lines, request 2 x 50mL of 70% Ethanol and 2 x 50mL of Water
                *)

                (* Populate fields needed to clean the lines before/after the run *)
                fields=If[anyInjectionsQ,
                  {
                    PlateReader -> FirstCase[
                      instrumentResourcesWithUpdatedTimeEstimate,
                      Verbatim[Resource][KeyValuePattern[{Instrument->ObjectP[instrumentObject]}]],
                      Null
                    ],
                    InjectionSample -> primaryInjectionSample,
                    SecondaryInjectionSample -> secondaryInjectionSample,

                    Line1PrimaryPurgingSolvent -> Resource@@{
                      Sample -> Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"] (* 70% Ethanol *),
                      (* Wash each line being used with the wash volume - request a little extra to avoid air in the lines *)
                      Amount->washVolume,
                      Container -> Model[Container, Vessel, "id:bq9LA0dBGGR6"],
                      Name->"Primary Solvent Container 1"
                    },
                    Line1SecondaryPurgingSolvent -> Resource@@{
                      Sample->Model[Sample,"id:8qZ1VWNmdLBD"] (*Milli-Q water *),
                      (* Wash each line being used with the wash volume - request a little extra to avoid air in the lines *)
                      Amount->washVolume,
                      Container->Model[Container,Vessel,"id:bq9LA0dBGGR6"],
                      Name->"Secondary Solvent Container 1"
                    },

                    Line2PrimaryPurgingSolvent -> If[numberOfInjectionContainers==2,
                      Resource@@{
                        Sample -> Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"] (* 70% Ethanol *),
                        (* Wash each line being used with the wash volume - request a little extra to avoid air in the lines *)
                        Amount->washVolume,
                        Container -> Model[Container, Vessel, "id:bq9LA0dBGGR6"],
                        Name->"Primary Solvent Container 2"
                      },
                      Null
                    ],
                    Line2SecondaryPurgingSolvent -> If[numberOfInjectionContainers==2,
                      Resource@@{
                        Sample->Model[Sample,"id:8qZ1VWNmdLBD"] (*Milli-Q water *),
                        (* Wash each line being used with the wash volume - request a little extra to avoid air in the lines *)
                        Amount->washVolume,
                        Container->Model[Container,Vessel,"id:bq9LA0dBGGR6"],
                        Name->"Secondary Solvent Container 2"
                      },
                      Null
                    ]
                  },
                  (* NOTE: Even if we don't have any injections, we have to populate the Primary and SecondaryPlateReader fields *)
                  (* so that we setup the method in the software. *)
                  {
                    PlateReader -> FirstCase[
                      instrumentResourcesWithUpdatedTimeEstimate,
                      Verbatim[Resource][KeyValuePattern[{Instrument->ObjectP[instrumentObject]}]],
                      Null
                    ]
                  }
                ];

                (* Append PrimaryPlateReader or SecondaryPlateReader prefixes to our plate reader fields. *)
                (* NOTE: We also have a field called PlateReader already so we have to account for that when prepending. *)
                Sequence@@Which[
                  MatchQ[index, 1],
                    (If[MatchQ[#[[1]], PlateReader], ToExpression["Primary"<>ToString[#[[1]]]], ToExpression["PrimaryPlateReader"<>ToString[#[[1]]]]] -> #[[2]]&)/@fields,
                  MatchQ[index, 2],
                    (If[MatchQ[#[[1]], PlateReader], ToExpression["Secondary"<>ToString[#[[1]]]], ToExpression["SecondaryPlateReader"<>ToString[#[[1]]]]] -> #[[2]]&)/@fields,
                  True,
                    {}
                ]
              ]
            ],
            {Keys[injectionResourceGroups], Values[injectionResourceGroups], Range[Length[Keys[injectionResourceGroups]]]}
          ]
        ];

        (* Make sure to replace the injection sample resources inside of the plate reader output unit operations, if they *)
        (* exist. *)
        (* NOTE: This contains both outputUnitOperationPackets and subOutputUnitOperationPackets. *)
        allOutputUnitOperationPacketsWithConsolidatedInjectionSampleResources=Module[
          {primaryPlateReaderInjectionSampleReplaceRules, secondaryPlateReaderInjectionSampleReplaceRules},

          (* Create replace rules. *)
          primaryPlateReaderInjectionSampleReplaceRules={
            If[KeyExistsQ[plateReaderFields, PrimaryPlateReaderInjectionSample],
              Verbatim[Resource][KeyValuePattern[{Sample->ObjectP[Lookup[plateReaderFields, PrimaryPlateReaderInjectionSample][Sample]]}]]->Lookup[plateReaderFields, PrimaryPlateReaderInjectionSample],
              Nothing
            ],
            If[KeyExistsQ[plateReaderFields, PrimaryPlateReaderSecondaryInjectionSample],
              Verbatim[Resource][KeyValuePattern[{Sample->ObjectP[Lookup[plateReaderFields, PrimaryPlateReaderSecondaryInjectionSample][Sample]]}]]->Lookup[plateReaderFields, PrimaryPlateReaderSecondaryInjectionSample],
              Nothing
            ]
          };

          secondaryPlateReaderInjectionSampleReplaceRules={
            If[KeyExistsQ[plateReaderFields, SecondaryPlateReaderInjectionSample],
              Verbatim[Resource][KeyValuePattern[{Sample->ObjectP[Lookup[plateReaderFields, SecondaryPlateReaderInjectionSample][Sample]]}]]->Lookup[plateReaderFields, SecondaryPlateReaderInjectionSample],
              Nothing
            ],
            If[KeyExistsQ[plateReaderFields, SecondaryPlateReaderSecondaryInjectionSample],
              Verbatim[Resource][KeyValuePattern[{Sample->ObjectP[Lookup[plateReaderFields, SecondaryPlateReaderSecondaryInjectionSample][Sample]]}]]->Lookup[plateReaderFields, SecondaryPlateReaderSecondaryInjectionSample],
              Nothing
            ]
          };

          Map[
            Function[{outputUnitOperationPacket},
              Which[
                (* Don't do instrument replacement for qpix unit operations (there are no integrated instruments and it can mess up the batched unit operations) *)
                MatchQ[Lookup[outputUnitOperationPacket, Object],ObjectP[Object[UnitOperation, #]&/@qpixPrimitiveTypes]],
                outputUnitOperationPacket,

                (* If we have a plate reader primitive, do the injection sample replacement *)
                MatchQ[Lookup[outputUnitOperationPacket, Object], ObjectP[Object[UnitOperation, #]&/@plateReaderPrimitiveTypes]],
                Module[{replaceRulesToUse},
                  replaceRulesToUse=If[MatchQ[Lookup[outputUnitOperationPacket, Instrument], Verbatim[Resource][KeyValuePattern[{Instrument->ObjectP[Lookup[plateReaderFields, PrimaryPlateReader][Instrument]]}]]],
                    primaryPlateReaderInjectionSampleReplaceRules,
                    secondaryPlateReaderInjectionSampleReplaceRules
                  ];

                  Association@Append[
                    (* NOTE: Also replace any instrument resources with our global ones. *)
                    Normal[outputUnitOperationPacket]/.instrumentResourceReplaceRules,
                    {
                      If[KeyExistsQ[outputUnitOperationPacket, Replace[PrimaryInjectionSampleLink]],
                        Replace[PrimaryInjectionSampleLink]->Lookup[outputUnitOperationPacket, Replace[PrimaryInjectionSampleLink]]/.replaceRulesToUse,
                        Nothing
                      ],
                      If[KeyExistsQ[outputUnitOperationPacket, Replace[SecondaryInjectionSampleLink]],
                        Replace[SecondaryInjectionSampleLink]->Lookup[outputUnitOperationPacket, Replace[SecondaryInjectionSampleLink]]/.replaceRulesToUse,
                        Nothing
                      ],
                      If[KeyExistsQ[outputUnitOperationPacket, Replace[TertiaryInjectionSample]],
                        Replace[TertiaryInjectionSample]->Lookup[outputUnitOperationPacket, Replace[TertiaryInjectionSample]]/.replaceRulesToUse,
                        Nothing
                      ],
                      If[KeyExistsQ[outputUnitOperationPacket, Replace[QuaternaryInjectionSample]],
                        Replace[QuaternaryInjectionSample]->Lookup[outputUnitOperationPacket, Replace[QuaternaryInjectionSample]]/.replaceRulesToUse,
                        Nothing
                      ]
                    }
                  ]
                ],

                True,
                (* Otherwise we have a non plate reader hamilton run: Replace any instrument resources with our global ones. *)
                Association[Normal[outputUnitOperationPacket]/.instrumentResourceReplaceRules]
              ]
            ],
            Flatten[{outputUnitOperationPackets, subOutputUnitOperationPackets}]
          ]
        ];


        (* Gather all up of our auxilliary packets. *)
        supplementaryPacketsMinusRootProtocol=Cases[
          Join[
            inputUnitOperationPackets,
            optimizedUnitOperationPackets,
            calculatedUnitOperationPackets,
            allOutputUnitOperationPacketsWithConsolidatedInjectionSampleResources,
            Flatten@allPrimitiveGroupingBatchedUnitOperationPackets
          ],
          Except[Null]
        ];

        (* determine if we need to overclock our threads or not; we only do this if there is an IncubateCells unit operation somewhere in the stack *)
        (* note that I am a little worried about the RoboticUnitOperations field recursively down ultimately including an IncubateCells such that we miss it and don't do Overclocking *)
        (* thus, I'm checking _all_ the supplementary packets for an Object[UnitOperation, IncubateCells] to be absolutely sure *)
        overclockQ = MemberQ[supplementaryPacketsMinusRootProtocol, PacketP[Object[UnitOperation, IncubateCells]]];

        (* if we are overclocking and we are not the parent protocol, set Overclock -> True in the root protocol (if we are the parent then we deal with this below) *)
        overclockingPacket = If[overclockQ && Not[NullQ[parentProtocol]],
          <|Object -> rootProtocol, Overclock -> True|>,
          Nothing
        ];
        supplementaryPackets = Flatten[{supplementaryPacketsMinusRootProtocol, overclockingPacket}];

        (* Compute SamplesIn/ContainersIn. *)
        samplesIn=Cases[Download[labeledObjects[[All,2]], Object], ObjectReferenceP[Object[Sample]],Infinity];
        containersIn=(Lookup[fetchPacketFromCache[#, cacheBall], Container]&)/@samplesIn;

        (* Include non-simulated resources in our RequiredObjects field. *)
        requiredObjects=Module[
          {
            sampleResourceBlobs, objectsInResourceBlobs,simulatedQ,simulatedObjects,
            nonSimulatedSampleResourceBlobs, cellResources, hamiltonTipModels, hamiltonTipResources
          },

          (* Get our resources out of our unit operation packets. *)
          sampleResourceBlobs=DeleteDuplicates@Cases[
            supplementaryPackets,
            Resource[KeyValuePattern[Type->Object[Resource, Sample]]],
            Infinity
          ];

          (* Get all of the objects from the resource blobs. *)
          objectsInResourceBlobs=DeleteDuplicates[Cases[sampleResourceBlobs, ObjectReferenceP[], Infinity]];

          (* Figure out which objects are simulated. *)
          simulatedQ = simulatedObjectQs[objectsInResourceBlobs, currentSimulation];
          simulatedObjects=PickList[objectsInResourceBlobs, simulatedQ];

          (* Only check if non-simulated objects are fulfillable. *)
          nonSimulatedSampleResourceBlobs = (
            If[MemberQ[#, Alternatives @@ simulatedObjects, Infinity],
              Nothing,
              #
            ]
          &)/@sampleResourceBlobs;

          (* We also want to exclude any objects that contain cells - they will be picked later in procedures at *)
          (* more opportune times so the cells do not die *)
          (* Get the sample resources that contain cells *)
          (* NOTE: This is a very similar process to how the variable cellContainerLinkResources is generated *)
          (* However, that variable contains the cell resources AFTER the protocol, here we want the cell resources *)
          (* BEFORE the protocol *)
          (* NOTE: We only do this if the work cell is the qpix *)
          cellResources = If[MemberQ[Flatten[allPrimitiveGroupingWorkCellInstruments], ObjectP[{Object[Instrument,ColonyHandler], Model[Instrument,ColonyHandler]}]],
            Module[
              {
                nonSimulatedObjects,sampleObjects,containerObjects,containerContentPackets,
                containerIncludesCellsQ,sampleContainsCellsQ,cellSamples,cellContainers
              },

              (* Get all of the non simulated objects *)
              nonSimulatedObjects = UnsortedComplement[objectsInResourceBlobs,simulatedObjects];

              (* Separate the simulated objects into simulated samples and simulated containers *)
              sampleObjects = Cases[nonSimulatedObjects, ObjectP[Object[Sample]]];
              containerObjects = DeleteCases[Cases[nonSimulatedObjects, ObjectP[Object[Container]]],ObjectP[Object[Container,ColonyHandlerHeadCassetteHolder]]];(*cassette holders are containers but the contents are cassettes that does not have cell type*)

              (* Download information from our objects. *)
              (* NOTE: We are downloading from the very first simulation here so this will reflect the contents of the *)
              (* containers before all manipulations on the robot are completed. *)
              {samplePackets, containerContentPackets}=Quiet[
                Download[
                  {
                    sampleObjects,
                    containerObjects
                  },
                  {
                    {Packet[CellType]},
                    {Packet[Contents[[All,2]][{CellType}]]}
                  },
                  Cache->cacheBall,
                  Simulation->simulation
                ],
                {Download::NotLinkField,Download::MissingCacheField}
              ];

              (* Flatten the packets *)
              samplePackets=Flatten@samplePackets;
              containerContentPackets=Flatten/@containerContentPackets;

              (* Determine the which container/samples contains cells. *)
              containerIncludesCellsQ=(MemberQ[Lookup[#, CellType, Null], CellTypeP]&)/@containerContentPackets;
              sampleContainsCellsQ=(MatchQ[Lookup[#, CellType], CellTypeP]&)/@samplePackets;

              (* Pick containers/samples that will not have cell samples in them. *)
              cellSamples=PickList[sampleObjects, sampleContainsCellsQ];
              cellContainers=PickList[containerObjects, containerIncludesCellsQ];

              (
                If[MemberQ[#, Alternatives@@Join[cellSamples,cellContainers], Infinity],
                  #,
                  Nothing
                ]&)/@sampleResourceBlobs
            ],
            {}
          ];

          (* we are excluding tip resources from here because we want to pick them up in a separate task from the rest of the objects *)
          hamiltonTipModels=hamiltonTipModelSearch["Memoization"];
          hamiltonTipResources = Select[nonSimulatedSampleResourceBlobs,Count[#,Alternatives@@hamiltonTipModels,Infinity]>0&];

          (* Exclude the cell and tips Resources *)
          UnsortedComplement[nonSimulatedSampleResourceBlobs,cellResources,hamiltonTipResources]
        ];

        (* estimate the total number of positions we will use on/off deck *)
        estimatedNumberOfPositionsNeeded=Module[{allDeckResources,allRequestedObjects},
          allDeckResources=Cases[Flatten@{tipAdapterResource,livingCellContainerLinkResources,magnetizationRackResourceReplacementRules,requiredObjects},_Resource];
          allRequestedObjects=Map[If[MatchQ[#[[1]],ObjectP[]],#[[1]],#[[2]]]&,Lookup[allDeckResources[[All,1]],{Sample,Models},{Null, Null}]];
          Count[allRequestedObjects,ObjectP[{Object[Container,Plate],Model[Container,Plate],Object[Item,MagnetizationRack],Model[Item,MagnetizationRack],Model[Item,"id:Y0lXejMp6aRV"],Model[Item,Rack]}]]
          ];

        (* for RCP, we are reserving all integrated instruments even when we want only one of them *)
        finalInstrumentResources=If[MatchQ[liquidHandlerResource,Null],
          {},
          getAdditionalIntegrations[First@ToList@Lookup[liquidHandlerResource[[1]],Instrument],instrumentResourcesWithUpdatedTimeEstimate,protocolType,estimatedNumberOfPositionsNeeded,Length[tipRackResources],totalWorkCellTime,Cache->cacheBall]
        ];

        (* Extract the colony handler resource from the output unit operation, if we are working with the qpix *)
        (* NOTE: All qpix unit operations MUST have the Instrument field or else this will break *)
        colonyHandlerResource = Module[{allQPixPrimitives,resourceFromOutputUnitOperations},
          (* If we have a qpix output unit operation, extract the Instrument field (will contain the instrument resource) *)
          allQPixPrimitives = PickList[outputUnitOperationPackets,Lookup[outputUnitOperationPackets,Type, {}],Alternatives@@(Object[UnitOperation, #]&/@qpixPrimitiveTypes)];

          (* Get the resource *)
          resourceFromOutputUnitOperations = First@Lookup[allQPixPrimitives,Instrument, {Null}];

          Which[
            (* Use the resource from the output unit operations if it exits *)
            MatchQ[resourceFromOutputUnitOperations,_Resource|_Link],
            resourceFromOutputUnitOperations,

            (* Otherwise, as a fallback, create one from our work cell instrument grouping *)
            MemberQ[Flatten[allPrimitiveGroupingWorkCellInstruments], ObjectP[{Object[Instrument,ColonyHandler], Model[Instrument,ColonyHandler]}]],
            Resource[
              Instrument->If[MemberQ[DeleteDuplicates[Flatten[allPrimitiveGroupingWorkCellInstruments]],ObjectP[Object[Instrument,ColonyHandler]]],
                (* If we have instrument object, go with it *)
                FirstCase[DeleteDuplicates[Flatten[allPrimitiveGroupingWorkCellInstruments]],ObjectP[Object[Instrument,ColonyHandler]]],
                (* Allow all supported instrument models *)
                DeleteDuplicates[Download[Flatten[allPrimitiveGroupingWorkCellInstruments],Object]]
              ],
              (* NOTE: We should be given back valid time estimates here, but it we're not default to 1 minute so we make *)
              (* a valid resource and don't error on upload. *)
              Time->If[MatchQ[totalWorkCellTime, GreaterP[1 Minute]], totalWorkCellTime, 1 Minute]
            ],

            (* If we don't have a colony handler, set to Null *)
            True,
            Null
          ]
        ];

        (* Create a protocol object for these manipulations. *)
        protocolPacket=(<|
          Object->CreateID[Object[Protocol, protocolType]],
          Type->Object[Protocol, protocolType],

          Replace[SamplesIn]->(Link[#,Protocols]&)/@samplesIn,
          Replace[ContainersIn]->(Link[#,Protocols]&)/@containersIn,

          Replace[InputUnitOperations]->(Link[#, Protocol]&)/@Lookup[inputUnitOperationPackets, Object],
          Replace[OptimizedUnitOperations]->(Link[#, Protocol]&)/@Lookup[optimizedUnitOperationPackets, Object],
          Replace[CalculatedUnitOperations]->(Link[#, Protocol]&)/@Lookup[calculatedUnitOperationPackets, Object],

          (* NOTE: We don't use allOutputUnitOperationPacketsWithConsolidatedInjectionSampleResources here since that contains *)
          (* packets from both outputUnitOperationPackets and subOutputUnitOperationPackets. *)
          Replace[OutputUnitOperations]->(Link[#, Protocol]&)/@Lookup[outputUnitOperationPackets, Object],

          (* if we have an IncubateCells unit operation in here and we are the root protocol, set Overclock -> True *)
          (* if we have an IncubateCells unit operation but we are not the root protocol, then the root protocol has been set to Overclock -> True above *)
          If[NullQ[parentProtocol] && overclockQ,
            Overclock -> True,
            Nothing
          ],

          (* NOTE: We only upload the ColonyHandler field for RCP protocols, not RSP *)
          If[MatchQ[myFunction,ExperimentRoboticCellPreparation],
            ColonyHandler -> colonyHandlerResource,
            Nothing
          ],

          LiquidHandler->liquidHandlerResource,
          RunTime->If[MatchQ[experimentRunTime, GreaterP[1 Minute]], experimentRunTime, 1 Minute],

          Replace[RequiredInstruments]->finalInstrumentResources,

          (* Include Plate Reader Fields. *)
          Sequence@@plateReaderFields,

          Replace[LabeledObjects]->labeledObjects,
          Replace[FutureLabeledObjects]->futureLabeledObjects,

          (* NOTE: We need this field because not all of our objects will be labeled. *)
          Replace[RequiredObjects]->requiredObjects,
          Replace[RequiredTips]->allTipResources,
          If[NullQ[tipAdapterResource], Nothing, TipAdapter->tipAdapterResource],

          Replace[TipRacks]->tipRackResources,

          Replace[InitialContainerIdlingConditions]->Join[
            ({#, Ambient}&)/@Flatten[allPrimitiveGroupingAmbientContainerResources],
            ({#, Incubator}&)/@Flatten[allPrimitiveGroupingIncubatorContainerResources]
          ],

          (* always drop the cache and simulation from these fields *)
          UnresolvedOptions-> DeleteCases[ToList[myOptions], (Verbatim[Cache] -> _) | (Verbatim[Simulation] -> _)],
          ResolvedOptions-> DeleteCases[safeOps, (Verbatim[Cache] -> _) | (Verbatim[Simulation] -> _)],

          Replace[TaredContainers]->tareContainers,
          Replace[CellContainers]->cellContainerLinkResources,
          Replace[LivingCellContainers] -> livingCellContainerLinkResources,
          Replace[PostProcessingContainers]->nonCellContainerLinkResources,

          MeasureWeight->resolvedMeasureWeight,
          MeasureVolume->resolvedMeasureVolume,
          ImageSample->resolvedImageSample,

          Replace[Checkpoints]->{
            {"Picking Resources",15 Minute,"Samples required to execute this protocol are gathered from storage.", Resource[Operator->$BaselineOperator,Time->15 Minute]},
            {
              "Liquid Handling",
              totalWorkCellTime,
              "The given unit operations are executed, in the order in which they are specified.",
              Resource[Operator->$BaselineOperator,Time->totalWorkCellTime]
            },
            {"Sample Post-Processing",1 Minute,"Any measuring of volume, weight, or sample imaging post experiment is performed.", Resource[Operator->$BaselineOperator,Time->1 Minute]},
            {"Returning Materials",15 Minute,"Samples are returned to storage.", Resource[Operator->$BaselineOperator,Time->15 Minute]}
          },

          Replace[OrdersFulfilled] -> Link[Cases[ToList[orderToFulfill], ObjectP[Object[Transaction, Order]]], Fulfillment],
          Replace[PreparedResources]->Link[Lookup[safeOps,PreparedResources,Null],Preparation]
        |>)/.modelSampleResourceReplacementRules;

        (* Add the Magnetic Hazard Safety Cert if we are going to be using the QPix *)
        allSupplementalCertifications = If[!NullQ[colonyHandlerResource],
          Append[supplementalCertifications, Model[Certification, "id:XnlV5jNAkGmM"]], (* Model[Certification, "Magnetic Hazard Safety"] *)
          supplementalCertifications
        ];

        (* Upload if asked to. *)
        Which[
          !MemberQ[output, Result],
            Null,
          True,
            ECL`InternalUpload`UploadProtocol[
              protocolPacket,
              supplementaryPackets,
              Upload->Lookup[safeOps,Upload],
              Confirm->Lookup[safeOps,Confirm],
              CanaryBranch->Lookup[safeOps,CanaryBranch],
              ParentProtocol->Lookup[safeOps,ParentProtocol],
              SupplementalCertification->allSupplementalCertifications,
              Priority->Lookup[safeOps,Priority],
              StartDate->Lookup[safeOps,StartDate],
              HoldOrder->Lookup[safeOps,HoldOrder],
              QueuePosition->Lookup[safeOps,QueuePosition],
              ConstellationMessage->{Object[Protocol]},
              Simulation->currentSimulation
            ]
        ]
    ]
  ];

  (* -- STAGE 7: Output -- *)
  If[debug, Echo["Beginning stage 7: Returning and memoizing output"]];

	(* Create a map to convert any simulated objects back to their labels. *)
	simulatedObjectsToLabelOutput=Module[{allObjectsInSimulation, simulatedQ},
		(* Get all objects out of our simulation. *)
		allObjectsInSimulation=Download[Lookup[currentSimulation[[1]], Labels][[All,2]], Object];

		(* Figure out which objects are simulated. *)
		simulatedQ = simulatedObjectQs[allObjectsInSimulation, currentSimulation];

		(Reverse/@PickList[Lookup[currentSimulation[[1]], Labels], simulatedQ])/.{link_Link:>Download[link,Object]}
	];

  (* Convert the resolved input primitives into a format that the command builder can understand. *)
  (* Has the command builder asked us for a finalized version of our primitives? *)
  (* NOTE: If we get PreviewFinalizedUnitOperations->True, we want to return our primitives with new method wrappers around *)
  (* them. This is in contrast to False where we shouldn't add method wrappers if they didn't exist. This also implies that *)
  (* if False, we shouldn't optimize. This is because if we're not previewing the final UOs, the front end needs the primitives *)
  (* in the same form that it fed them in so that the command builder doesn't keep crazily rearranging the UOs. *)
  resolvedInput=If[MatchQ[previewFinalizedUnitOperations, True],
    (* Yes, return resolved primitives with the method wrappers around them. *)
    Module[{calculatedPrimitivesWithMethodWrappers, anyPrimitiveP, primitivePositions},
      (* Get our calculated primitives with method wrappers. *)
      calculatedPrimitivesWithMethodWrappers=Map[
        Function[{primitiveGroup},
          Module[{primitiveMethod, cleanPrimitives},
            (* Figure out what primitive method we're dealing with for this group. *)
            primitiveMethod=Lookup[First[primitiveGroup][[1]], PrimitiveMethod];

            (* Strip out the PrimitiveMethod and PrimitiveMethodIndex keys since they're internal and shouldn't be returned *)
            (* to the user. *)
            cleanPrimitives=Map[
              Function[primitive,
                Module[{primitiveInformation, primitiveOptionDefinitions,resolverFunction},
                  (* Lookup information about our primitive. *)
                  primitiveInformation=Lookup[allPrimitiveInformation, Head[primitive]];
                  primitiveOptionDefinitions=Lookup[primitiveInformation, OptionDefinition];
                  resolverFunction=Lookup[primitiveInformation, ExperimentFunction, Null];

                  (* Only drop the WorkCell option if it's not a real option for our experiment function. *)
                  If[MemberQ[Options[resolverFunction][[All,1]], "WorkCell"],
                    Head[primitive]@KeyDrop[primitive[[1]], {PrimitiveMethod, PrimitiveMethodIndex, UnresolvedUnitOperationOptions, ResolvedUnitOperationOptions}],
                    Head[primitive]@KeyDrop[primitive[[1]], {PrimitiveMethod, PrimitiveMethodIndex, UnresolvedUnitOperationOptions, ResolvedUnitOperationOptions, WorkCell}]
                  ]
                ]
              ],
              primitiveGroup
            ]/.simulatedObjectsToLabelOutput;

            (* We should not put a head on our primitives we're not in a script generating function. *)
            If[!MatchQ[myFunction, ScriptGeneratingPrimitiveFunctionP],
              Sequence@@cleanPrimitives,
              primitiveMethod[Sequence@@cleanPrimitives]
            ]
          ]
        ],
        allPrimitiveGroupings
      ];

      (* Our calculated primitives should index match to our optimized primitives. *)

      (* NOTE: Since we didn't optimize above, we should have the same number of primitives inputted as resolved. *)
      anyPrimitiveP=Alternatives@@(Blank[#]&/@primitiveHeads);
      primitivePositions=Position[calculatedPrimitivesWithMethodWrappers, anyPrimitiveP, 2];

      (* If we're called by ExperimentBLAHInputs, return the primitives with fully calculated options. Otherwise, assume that *)
      (* we're being called by the front end and return the minimal set of options (from the optimized primitives) as not to *)
      (* overwhelm the user in the front end and also not to tell the front end that every calculated option is "specified". *)
      If[MatchQ[inputsFunctionQ, True],
        calculatedPrimitivesWithMethodWrappers,
        Module[{cleanOptimizedPrimitives},
          (* Clean up our optimized primitives. *)
          cleanOptimizedPrimitives=Map[
            Function[primitive,
              Module[{primitiveInformation, primitiveOptionDefinitions,resolverFunction},
                (* Lookup information about our primitive. *)
                primitiveInformation=Lookup[allPrimitiveInformation, Head[primitive]];
                primitiveOptionDefinitions=Lookup[primitiveInformation, OptionDefinition];
                resolverFunction=Lookup[primitiveInformation, ExperimentFunction, Null];

                (* Only drop the WorkCell option if it's not a real option for our experiment function. *)
                If[MemberQ[Options[resolverFunction][[All,1]], "WorkCell"],
                  Head[primitive]@KeyDrop[primitive[[1]], {PrimitiveMethod, PrimitiveMethodIndex, UnresolvedUnitOperationOptions, ResolvedUnitOperationOptions}],
                  Head[primitive]@KeyDrop[primitive[[1]], {PrimitiveMethod, PrimitiveMethodIndex, UnresolvedUnitOperationOptions, ResolvedUnitOperationOptions, WorkCell}]
                ]
              ]
            ],
            coverOptimizedPrimitives
          ];

          (* Replace our primitives with the original optimized ones. *)
          ReplacePart[calculatedPrimitivesWithMethodWrappers, Rule@@@Transpose[{primitivePositions, cleanOptimizedPrimitives}]]
        ]
      ]
    ],
    (* No. Return resolved primitives only with method wrappers if the user originally included them. *)
    (* NOTE: In this case, we made sure not to optimize our unit operations above, even if the user specified *)
    (* OptimizedUnitOperations->True since we don't want to change the user's primitives before the optimization page in the CB. *)
    Module[{resolvedFlattenedPrimitives, anyPrimitiveP, primitivePositions},
      (* Drop our internal keys from these resolved primitives. *)
      resolvedFlattenedPrimitives=Map[
        Function[primitive,
          Module[{primitiveInformation, primitiveOptionDefinitions,resolverFunction},
            (* Lookup information about our primitive. *)
            primitiveInformation=Lookup[allPrimitiveInformation, Head[primitive]];
            primitiveOptionDefinitions=Lookup[primitiveInformation, OptionDefinition];
            resolverFunction=Lookup[primitiveInformation, ExperimentFunction, Null];

            (* Only drop the WorkCell option if it's not a real option for our experiment function. *)
            If[MemberQ[Options[resolverFunction][[All,1]], "WorkCell"],
              Head[primitive]@KeyDrop[primitive[[1]], {PrimitiveMethod, PrimitiveMethodIndex, UnresolvedUnitOperationOptions, ResolvedUnitOperationOptions}],
              Head[primitive]@KeyDrop[primitive[[1]], {PrimitiveMethod, PrimitiveMethodIndex, UnresolvedUnitOperationOptions, ResolvedUnitOperationOptions, WorkCell}]
            ]
          ]
        ],
        Flatten[allPrimitiveGroupings]
      ];

      (* NOTE: Since we didn't optimize above, we should have the same number of primitives inputted as resolved. *)
      anyPrimitiveP=Alternatives@@(Blank[#]&/@primitiveHeads);
      primitivePositions=Position[sanitizedPrimitives, anyPrimitiveP, 2];

      (* Replace our primitives with the resolved ones. *)
      ReplacePart[sanitizedPrimitives, Rule@@@Transpose[{primitivePositions, (resolvedFlattenedPrimitives)/.simulatedObjectsToLabelOutput}]]
    ]
  ];

  If[Length[invalidInputIndices]>0 && Not[gatherTests],
    If[MatchQ[$ShortenErrorMessages, True],
      Message[Error::InvalidInput, shortenPrimitives[coverOptimizedPrimitives[[invalidInputIndices]]]],
      Message[Error::InvalidInput, coverOptimizedPrimitives[[invalidInputIndices]]]
    ];
  ];

  (* NOTE: We need a Output->Simulation to this function so that we can return a simulation back, in the case that we're called from *)
  (* PreparatoryUnitOperations. *)

  (* Return the requested output *)
  outputRules={
    Result -> outputResult,
    Preview -> Null,
    Options -> resolvedOptions,
    (* NOTE: We return our tests in an indexed format so that we can show specific tests on the unit operation edit screen *)
    (* via ValidQTestsJSON. The first list is expected to be the general function tests, the rest of the lists are index matched *)
    (* to the unit operations. *)
    Tests->If[gatherTests,
      {
        Flatten@{
          safeOpsTests,
          templateTests,
          frqTests,
          accumulatedFRQTests
        },
        Sequence@@allResolverTests
      },
      Null
    ],
    Input->resolvedInput,
    Simulation->currentSimulation
  };
  finalOutput=outputSpecification /. outputRules;

  (* Cache the value right before returning if we didn't have any issues. *)
  If[Length[invalidResolverPrimitives]==0,
    $PrimitiveFrameworkOutputCache[{myFunction, myPrimitives, ToList[myOptions], gatherTests}] = outputRules;
  ];

  finalOutput
]];

(* Install the options function. *)
Module[{optionsFunction},
  optionsFunction=ToExpression[SymbolName[myFunction]<>"Options"];

  With[{myOptionsFunction=optionsFunction},

    DefineOptions[myOptionsFunction,
      Options:>{
        {
          OptionName->OutputFormat,
          Default->Table,
          AllowNull->False,
          Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
          Description->"Indicates whether the function returns a table or a list of the options."
        }
      },
      SharedOptions :> {myFunction}
    ];

    Authors[myOptionsFunction] := {"steven"};

    myOptionsFunction[myPrimitives_List,myOptions:OptionsPattern[myOptionsFunction]]:=Module[
      {listedOptions,preparedOptions,resolvedOptions,functionOptions,commonOptions,cleanedOptions},

      listedOptions=ToList[myOptions];

      (* Send in the correct Output option and remove OutputFormat option *)
      preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}];

      resolvedOptions=myFunction[myPrimitives,preparedOptions];
      (* we need to remove things that are not in the options, I am not sure how they got here but seems to be some super weird framework weirdness *)
      functionOptions=Options[myFunction];
      commonOptions=ToExpression/@Intersection[ToString/@Keys[resolvedOptions],Keys[functionOptions]];
      cleanedOptions=Cases[resolvedOptions, Verbatim[Rule][Alternatives @@ commonOptions, _]];

      (* Return the option as a list or table *)
      If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table]&&MatchQ[cleanedOptions,{(_Rule|_RuleDelayed)..}],
        LegacySLL`Private`optionsToTable[cleanedOptions,myFunction],
        cleanedOptions
      ]
    ];

    myOptionsFunction[myPrimitive:Except[_List],myOptions:OptionsPattern[myOptionsFunction]]:=myOptionsFunction[{myPrimitive},myOptions];
  ];
];

(* Install the ValidQ function. *)
Module[{validQFunction},
  validQFunction=ToExpression["Valid"<>SymbolName[myFunction]<>"Q"];

  With[{myValidQFunction=validQFunction},

    DefineOptions[myValidQFunction,
      Options:>{
        VerboseOption,
        OutputFormatOption
      },
      SharedOptions :> {myFunction}
    ];

    Authors[myValidQFunction] := {"steven"};


    myValidQFunction[myPrimitives_List,myOptions:OptionsPattern[myValidQFunction]]:=Module[
      {listedInput,listedOptions,preparedOptions,functionTests,initialTestDescription,allTests,safeOps,verbose,outputFormat,result},

      listedInput=myPrimitives;
      listedOptions=ToList[myOptions];

      (* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
      preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Tests],{Verbose,OutputFormat}];

      (* Call the function to get a list of tests *)
      functionTests=myFunction[myPrimitives,preparedOptions];

      initialTestDescription="All provided options and inputs match their provided patterns and containers are not empty (no further testing can proceed if this test fails):";

      allTests=If[MatchQ[functionTests,$Failed],
        {Test[initialTestDescription,False,True]},
        Module[{initialTest,validObjectBooleans,voqWarnings,objects},
          initialTest=Test[initialTestDescription,True,True];

          objects=DeleteDuplicates[Cases[listedInput, ObjectReferenceP[], Infinity]];

          (* Create warnings for invalid objects *)
          validObjectBooleans=ValidObjectQ[objects,OutputFormat->Boolean];
          voqWarnings=MapThread[
            Warning[ToString[#1,InputForm]<>" is valid (run ValidObjectQ for more detailed information):",
              #2,
              True
            ]&,
            {objects,validObjectBooleans}
          ];

          (* Get all the tests/warnings *)
          Flatten[Join[{initialTest},functionTests,voqWarnings]]
        ]
      ];

      (* Lookup test running options *)
      safeOps=SafeOptions[myValidQFunction,Normal@KeyTake[listedOptions,{Verbose,OutputFormat}]];
      {verbose,outputFormat}=Lookup[safeOps,{Verbose,OutputFormat}];

      (* Run the tests as requested and return just the summary not the association if OutputFormat->TestSummary*)
      Lookup[
        RunUnitTest[
          <|ToString[myFunction]->allTests|>,
          Verbose->verbose,
          OutputFormat->outputFormat
        ],
        ToString[myFunction]
      ]
    ];

    myValidQFunction[myPrimitive:Except[_List],myOptions:OptionsPattern[myValidQFunction]]:=myValidQFunction[{myPrimitive},myOptions];
  ];
];

(* Install the inputs function. *)
Module[{inputsFunction},
  inputsFunction=ToExpression[SymbolName[myFunction]<>"Inputs"];

  With[{myInputsFunction=inputsFunction},

    DefineOptions[myInputsFunction,
      Options:>{},
      SharedOptions :> {myFunction}
    ];

    Authors[myInputsFunction] := {"steven"};

    myInputsFunction[myPrimitives_List,myOptions:OptionsPattern[myInputsFunction]]:=Module[
      {listedOptions,preparedOptions},

      listedOptions=ToList[myOptions];

      (* Send in the correct Output option *)
      preparedOptions=Join[listedOptions,{Output->Input, InputsFunction->True}];

      myFunction[myPrimitives,preparedOptions]
    ];

    myInputsFunction[myPrimitive:Except[_List],myOptions:OptionsPattern[myOptionsFunction]]:=myInputsFunction[{myPrimitive},myOptions];
  ];
];

(* Install the preview function. *)
Module[{previewFunction},
  previewFunction=ToExpression[SymbolName[myFunction]<>"Preview"];

  With[{myPreviewFunction=previewFunction},

    DefineOptions[myPreviewFunction,
      Options:>{},
      SharedOptions :> {myFunction}
    ];

    Authors[myPreviewFunction] := {"steven"};

    myPreviewFunction[myPrimitives_List,myOptions:OptionsPattern[myPreviewFunction]]:=Null;

    myPreviewFunction[myPrimitive:Except[_List],myOptions:OptionsPattern[myOptionsFunction]]:=myPreviewFunction[{myPrimitive},myOptions];
  ];
];

];

installPrimitiveFunction[Experiment, Hold[ExperimentP]];

installPrimitiveFunction[ExperimentSamplePreparation, Hold[SamplePreparationP]];
installPrimitiveFunction[ExperimentManualSamplePreparation, Hold[ManualSamplePreparationP]];
installPrimitiveFunction[ExperimentRoboticSamplePreparation, Hold[RoboticSamplePreparationP]];

installPrimitiveFunction[ExperimentCellPreparation, Hold[CellPreparationP]];
installPrimitiveFunction[ExperimentManualCellPreparation, Hold[ManualCellPreparationP]];
installPrimitiveFunction[ExperimentRoboticCellPreparation, Hold[RoboticCellPreparationP]];

shortenPrimitives[myList_List]:=myList/.{primitive:(_Symbol)[_Association]:>(ToString[Head[primitive]]<>"[...]")};



(* ::Subsubsection::Closed:: *)
(*holdComposition*)


(* ::Code::Initialization:: *)
(* Given f and Hold[g[x]], return Hold[f[g[x]]] without evaluating anything. *)
holdComposition[f_,Hold[expr__]]:=Hold[f[expr]];
SetAttributes[holdComposition,HoldAll];



(* ::Subsubsection::Closed:: *)
(*holdCompositionList*)


(* ::Code::Initialization:: *)
(* Given f and {Hold[a[x]], Hold[b[x]]..}, returns Hold[f[a[x],b[x]..]]. *)
holdCompositionList[f_,{helds___Hold}]:=Module[{joinedHelds},
  (* Join the held heads. *)
  joinedHelds=Join[helds];

  (* Swap the outer most hold with f. Then hold the result. *)
  With[{insertMe=joinedHelds},holdComposition[f,insertMe]]
];
SetAttributes[holdCompositionTimesList,HoldAll];

(* Helper function. *)
listToString[myList_List]:=Switch[Length[myList],
  (* If there is only one element in the list, there is no formatting to do. *)
  1,
    "1) "<>ToString[myList[[1]]],
  (* If there are two elements in the list, add an "or" between them. *)
  2,
    StringJoin@{"1) ",myList[[1]]," and 2) ", myList[[2]]},
  _,
    (* Otherwise, there are more than 2 elements. Riffle in commas and then add "or" before the last element. *)
    StringJoin@Insert[Riffle[MapThread[ToString[#1]<>") "<>#2&, {Range[Length[myList]], myList}],", "],"and ",-2]
];

(* Get all of the injection samples in this robotic group from the Plate Reader unit operations. *)
(* Returns {(PrimitiveHead->{_Resource..})..} *)
computeInjectionSampleResourceGroups[myResolvedPrimitives_List]:=Module[
  {plateReaderPrimitives, partitionedPlateReaderPrimitives},

  (* Get the plate reader primitives. *)
  plateReaderPrimitives=Cases[myResolvedPrimitives, plateReaderPrimitiveP];

  (* If we don't have any plate reader primitives, we don't have any injection samples that we have *)
  (* to separately load. *)
  If[Length[plateReaderPrimitives]==0,
    Return[{}];
  ];

  (* Partition our plate reader primitives by the resolved instrument (convert to model if we have an object). *)
  (*TODO: we really should pass cache here so we don't do trips to the database, but this should be exceedingly rare to have an Object here instead of Model*)
  partitionedPlateReaderPrimitives=Values@GroupBy[plateReaderPrimitives, (Download[Lookup[#[[1]], Instrument], Object]/.{object:ObjectP[Object[]]:>Download[object, Model[Object]]}&)];

  Map[
    Function[{plateReaderPrimitiveGroup},
      Module[{resolvedReadPlateAssociations, allInjectionSamples, allInjectionVolumes,
        uniqueInjectionSamples, injectionSampleVolumeLookup, resources},
        (* Strip out associations *)
        resolvedReadPlateAssociations = First/@plateReaderPrimitiveGroup;

        (* Extract injection samples from associations, defaulting to Null if not specified *)
        allInjectionSamples = Flatten[Map[
          Lookup[#,{PrimaryInjectionSample,SecondaryInjectionSample,TertiaryInjectionSample,QuaternaryInjectionSample},Null]&,
          resolvedReadPlateAssociations
        ]];

        (* Extract injection volumes from associations, defaulting to Null if not specified *)
        allInjectionVolumes = Flatten[Map[
          Lookup[#,{PrimaryInjectionVolume,SecondaryInjectionVolume,TertiaryInjectionVolume,QuaternaryInjectionVolume},Null]&,
          resolvedReadPlateAssociations
        ]];

        uniqueInjectionSamples = DeleteDuplicates@DeleteCases[Flatten@allInjectionSamples,Null];

        injectionSampleVolumeLookup = If[Length[uniqueInjectionSamples] > 0,
          Merge[
            MapThread[
              If[NullQ[#1],
                Nothing,
                Download[#1,Object] -> #2
              ]&,
              {allInjectionSamples,allInjectionVolumes}
            ],
            Total
          ],
          <||>
        ];

        (* Create replace rules to replace any existing resources we may have made. *)
        resources=KeyValueMap[
          Function[{sample, volume},
            (* Create a resource for the sample *)
            If[MatchQ[volume + $BMGPrimeVolume, LessEqualP[50 Milliliter]],
              Resource@@{
                Sample -> sample,
                (* Include volume lost due to priming lines (compiler sets to 1mL)
                - prime should account for all needed dead volume - prime fluid stays in syringe/line (which have vol of ~750 uL) *)
                Amount -> (volume + $BMGPrimeVolume),

                (* Specify a container if we're working with a model or if current container isn't workable *)
                If[MatchQ[sample,ObjectP[Object[Sample]]],
                  Nothing,
                  Container -> Model[Container, Vessel, "50mL Tube"]
                ],
                Name->CreateUUID[]
              },
              Sequence@@(
                Resource@@{
                  Sample -> sample,
                  (* Include volume lost due to priming lines (compiler sets to 1mL)
                  - prime should account for all needed dead volume - prime fluid stays in syringe/line (which have vol of ~750 uL) *)
                  Amount -> #,

                  (* Specify a container if we're working with a model or if current container isn't workable *)
                  If[MatchQ[sample,ObjectP[Object[Sample]]],
                    Nothing,
                    Container -> Model[Container, Vessel, "50mL Tube"]
                  ],
                  Name->CreateUUID[]
                }
                    &)/@QuantityPartition[volume + $BMGPrimeVolume, 50 Milliliter]
            ]
          ],
          injectionSampleVolumeLookup
        ];

        Lookup[resolvedReadPlateAssociations[[1]], Instrument] -> resources
      ]
    ],
    partitionedPlateReaderPrimitives
  ]
];

(* Returns {{invalidSampleObject, primitiveIndex}..}. *)
computeInvalidInjectionSampleResources[myResolvedPrimitives_List, myUnitOperationPackets_List]:=Module[
  {plateReaderPrimitives, resolvedReadPlateAssociations, allInjectionSamples, allResourcesWithoutInjectionSampleFields, invalidInjectionResourcePositions},

  (* Get the plate reader primitives. *)
  plateReaderPrimitives=Cases[myResolvedPrimitives, plateReaderPrimitiveP];

  (* Strip out associations *)
  resolvedReadPlateAssociations = First/@plateReaderPrimitiveGroup;

  (* NOTE: We only care about Object[Sample]s here! *)
  allInjectionSamples = Cases[
    Join@@Map[
      Lookup[#,{PrimaryInjectionSample,SecondaryInjectionSample,TertiaryInjectionSample,QuaternaryInjectionSample},Null]&,
      resolvedReadPlateAssociations
    ],
    ObjectP[Object[Sample]]
  ];

  (* These SHOULD not include any injection sample resources. *)
  allResourcesWithoutInjectionSampleFields=DeleteDuplicates[
    Cases[
      Normal@KeyDrop[
        #,
        {Replace[PrimaryInjectionSampleLink], Replace[SecondaryInjectionSampleLink], Replace[TertiaryInjectionSample], Replace[QuaternaryInjectionSample]}
      ]&/@myUnitOperationPackets,
      _Resource,
      Infinity
    ]
  ];

  (* Try to find invalid injection resources. *)
  invalidInjectionResourcePositions=Position[
    allResourcesWithoutInjectionSampleFields,
    Verbatim[Resource][KeyValuePattern[{Sample -> ObjectP[allInjectionSamples]}]]
  ][[All,1]];

  If[Length[invalidInjectionResourcePositions]>0,
    Transpose[{
      (Lookup[#[[1]], Sample]&)/@Extract[allResourcesWithoutInjectionSampleFields, invalidInjectionResourcePositions],
      invalidInjectionResourcePositions
    }],
    {}
  ]
];

(* ValidateUnitOperationsJSON *)


(* Authors definition for Experiment`Private`ValidateUnitOperationsJSON *)
Authors[Experiment`Private`ValidateUnitOperationsJSON]:={"malav.desai"};

ValidateUnitOperationsJSON[myPrimitives_List, myOptions:OptionsPattern[]]:=Module[
  {primitiveSetInformation, allPrimitiveInformation, sanitizedPrimitives, flattenedPrimitives, cacheBall,
    primitivesWithPreresolvedInputs, primitiveMessages},

  (* Lookup information about our primitive set from our backend association. *)
  primitiveSetInformation=Lookup[$PrimitiveSetPrimitiveLookup, Hold[ExperimentP]];
  allPrimitiveInformation=Lookup[primitiveSetInformation, Primitives];

  (* Replace the unit operation objects. *)
  sanitizedPrimitives=Module[{sanitizedPrimitivesWithUnitOperationObjects, userInputtedUnitOperationObjects, userInputtedUnitOperationPackets, userInputtedUnitOperationObjectToPrimitive},
    (* Sanitize our inputs. *)
    (* Experiments of individual UO should call sanitizeInput first by itself. Do not throw the message in framework *)
    sanitizedPrimitivesWithUnitOperationObjects=Quiet[
      (sanitizeInputs[myPrimitives]/.{link:LinkP[] :> Download[link, Object]}),
      Warning::OptionContainsUnusableObject
    ];

    (* Find any unit operation objects that were given as input. *)
    userInputtedUnitOperationObjects=DeleteDuplicates@Cases[sanitizedPrimitivesWithUnitOperationObjects, ObjectReferenceP[Object[UnitOperation]], Infinity];

    (* Download our unit operation objects. *)
    userInputtedUnitOperationPackets=Download[userInputtedUnitOperationObjects, Packet[All]];

    (* Convert each of these packets into a primitive. *)
    userInputtedUnitOperationObjectToPrimitive=(Lookup[#, Object]->ConstellationViewers`Private`UnitOperationPrimitive[#, IncludeCompletedOptions->False, IncludeEmptyOptions->False,IncludedHiddenOptions -> {WasteContainer}]&)/@userInputtedUnitOperationPackets;
    (* Experiments of individual UO should call sanitizeInput first by itself. Do not throw the message in framework *)
    Quiet[
      (sanitizeInputs[sanitizedPrimitivesWithUnitOperationObjects/.userInputtedUnitOperationObjectToPrimitive]/.{link:LinkP[] :> Download[link, Object]}),
      Warning::OptionContainsUnusableObject
    ]
  ];

  (* Flatten out our primitives, setting the PrimitiveMethod option if the method wrapper is given. *)
  flattenedPrimitives=MapThread[
    Function[{listElement, listIndex},
      (* Does this look like a wrapper and not an individual primitive? *)
      If[MatchQ[listElement, Except[_Symbol[_Association]]],
        (* We have a method wrapper. *)
        Sequence@@(
          (
            Head[#]@Append[
              #[[1]],
              {
                PrimitiveMethod->Head[listElement],
                PrimitiveMethodIndex->listIndex
              }
            ]
          (* NOTE: We're filtering out _Rule here because each primitive wrapper can have additional options that can be set. *)
          &)/@(Cases[List@@listElement, Except[_Rule]])
        ),
        (* We just have a single primitive. *)
        listElement
      ]
    ],
    {sanitizedPrimitives, Range[Length[sanitizedPrimitives]]}
  ];

  (* Get our cache ball. *)
  cacheBall=Module[{modelContainerFields, objectContainerFields, objectSampleFields},
    modelContainerFields=SamplePreparationCacheFields[Model[Container],Format->List];
    objectContainerFields=SamplePreparationCacheFields[Object[Container],Format->List];
    objectSampleFields=SamplePreparationCacheFields[Object[Sample],Format->List];

    FlattenCachePackets@Quiet[
      With[{insertMe1=Packet@@objectSampleFields,insertMe2=Packet@@objectContainerFields},
        Download[
          {
            DeleteDuplicates[Download[Cases[flattenedPrimitives, ObjectReferenceP[Object[Sample]], Infinity], Object]],
            DeleteDuplicates[Download[Cases[flattenedPrimitives, ObjectReferenceP[Object[Container]], Infinity], Object]]
          },
          {
            {insertMe1, Packet[Container[objectContainerFields]],Packet[Container[Model[modelContainerFields]]]},
            {insertMe2, Packet[Contents[[All,2]][objectSampleFields]], Packet[Model[modelContainerFields]]}
          }
        ]
      ],
      {Download::FieldDoesntExist,Download::NotLinkField,Download::Part}
    ]
  ];

  (* Try to "autofill" the next primitive's input, if we find it missing. *)
  (* Automatically propagate the primary input from the previous primitive to the next primitive, unless the previous *)
  (* primitive is generative. This is so that we can more easily resolve the Volume key in DefineSample[...] inside of *)
  (* our simulation MapThread. *)
  primitivesWithPreresolvedInputs=If[Length[flattenedPrimitives]==1,
    flattenedPrimitives,
    (* Fold over our partition will pre-resolve all primitives. *)
    (* NOTE: We have to Fold here and not Map because if there is a sequence like: *)
    (* {Incubate[Sample->"taco"], Mix[Time->15 Minute], Mix[Time->15 Minute]} *)
    (* We need to propagate the "taco" to the first and second Mix primitives. Therefore, we need to map over our *)
    (* propagated list. *)
    FoldList[
      Function[{firstPrimitive, secondPrimitive},
        Module[{firstPrimitiveInformation, firstPrimitiveGenerativeQ, secondPrimitiveInformation, firstPrimitivePrimaryInputOption, secondPrimitivePrimaryInputOption, secondPrimitivePrimaryInputOptionDefinition, secondPrimitiveGenerativeLabelOptions},
          (* For our primitive type, lookup the information about it from our primitive lookup. *)
          firstPrimitiveInformation=Lookup[allPrimitiveInformation, Head[firstPrimitive]];

          (* Are we dealing with a Generative primitive? *)
          firstPrimitiveGenerativeQ=Lookup[firstPrimitiveInformation, Generative];

          (* Lookup information about our second primitive. *)
          secondPrimitiveInformation=Lookup[allPrimitiveInformation, Head[secondPrimitive]];

          (* What option corresponds to the first input for each primitive type? *)
          firstPrimitivePrimaryInputOption=FirstOrDefault[Lookup[firstPrimitiveInformation, InputOptions], Null];
          secondPrimitivePrimaryInputOption=FirstOrDefault[Lookup[secondPrimitiveInformation, InputOptions], Null];
          secondPrimitivePrimaryInputOptionDefinition=FirstCase[Lookup[secondPrimitiveInformation, OptionDefinition], KeyValuePattern["OptionSymbol"->secondPrimitivePrimaryInputOption]];
          secondPrimitiveGenerativeLabelOptions=Lookup[secondPrimitiveInformation, LabeledOptions][[All,2]];

          (* If we're dealing with a generative first primitive, we can't autofill our second primitive. *)
          If[MatchQ[firstPrimitiveGenerativeQ, True],
            secondPrimitive,
            (* Otherwise, we can pre-resolve our second primitive with the input from our first primitive, if we don't *)
            (* already have input information for our second primitive. *)
            (* Should we fill out the input to the second primitive? *)
            If[
              Or[
                KeyExistsQ[secondPrimitive[[1]], secondPrimitivePrimaryInputOption] && !MatchQ[Lookup[secondPrimitive[[1]], secondPrimitivePrimaryInputOption], ListableP[Automatic]],
                !(KeyExistsQ[firstPrimitive[[1]], firstPrimitivePrimaryInputOption] && !MatchQ[Lookup[firstPrimitive[[1]], firstPrimitivePrimaryInputOption], ListableP[Automatic]]),
                !MatchQ[
                  Lookup[firstPrimitive[[1]], firstPrimitivePrimaryInputOption],
                  ReleaseHold[Lookup[secondPrimitivePrimaryInputOptionDefinition,"Pattern"]]
                ]
              ],
              (* Primary input option to the second primitive is already filled out or the primary input option to the first primitive is not filled out. Nothing to do. *)
              secondPrimitive,
              (* Primary input option to the second primitive is NOT filled out. Fill it out using the first primitive's primary input. *)
              Head[secondPrimitive]@Prepend[
                secondPrimitive[[1]],
                secondPrimitivePrimaryInputOption->Lookup[firstPrimitive[[1]], firstPrimitivePrimaryInputOption]
              ]
            ]
          ]
        ]
      ],
      flattenedPrimitives
    ]
  ];

  (* Call each primitive's method resolver function, keeping track of any errors that were thrown. *)
  primitiveMessages=Map[
    Function[{primitive},
      Module[{primitiveInformation,primitiveResolverMethod,inputsFromPrimitiveOptions,optionsFromPrimitiveOptions,
        inputsWithAutomatics,potentialRawMethods,messageStrings,filteredMessageStrings,potentialMethods,evaluationData,
        conflictingPreparationAndMethodWrapperText,conflictingMethodResolverText},

        (* Lookup information about our primitive. *)
        primitiveInformation=Lookup[allPrimitiveInformation, Head[primitive]];

        (* Lookup the method resolver function. *)
        primitiveResolverMethod=Lookup[primitiveInformation, MethodResolverFunction];

        (* Separate out our primitive options into inputs and function options. *)
        inputsFromPrimitiveOptions=(#->Lookup[primitive[[1]], #, Automatic]&)/@Lookup[primitiveInformation, InputOptions];
        optionsFromPrimitiveOptions=Cases[
          Normal[primitive[[1]]],
          Verbatim[Rule][
            Except[Alternatives[PrimitiveMethod, PrimitiveMethodIndex, WorkCell, (Sequence@@Lookup[primitiveInformation, InputOptions])]],
            _
          ]
        ];

        (* Change the labels in our inputs into Automatics because they're not simulated yet. *)
        inputsWithAutomatics=Module[{primitiveInformation, primitiveOptionDefinitions},
          (* Lookup information about this primitive. *)
          primitiveInformation=Lookup[allPrimitiveInformation, Head[primitive]];
          primitiveOptionDefinitions=Lookup[primitiveInformation, OptionDefinition];

          (* Only bother swapping out labels with Automatics if we're dealing with an input option. This is because the *)
          (* method resolver function will not accept labels for the inputs, but will accept labels for the options. *)
          KeyValueMap[
            Function[{option, value},
              Module[{optionDefinition},
                (* Lookup information about this option. *)
                optionDefinition=FirstCase[primitiveOptionDefinitions,KeyValuePattern["OptionSymbol"->option],Null];

                (* Do does this option allow for PreparedSample or PreparedContainer? *)
                Which[
                  (* NOTE: We have to convert any associations (widgets automatically evaluate into associations) because *)
                  (* Cases will only look inside of lists, not associations. *)
                  Length[Cases[Lookup[optionDefinition, "Widget"]/.{w_Widget :> Normal[w[[1]]]}, (PreparedContainer->True)|(PreparedSample->True), Infinity]]==0,
                    (* Nothing to replace. *)
                    option->value,
                    True,
                  (* We may potentially have some labels. *)
                    Module[{matchedWidgetInformation, objectWidgetsWithLabels, labelsInOption},
                      (* Match the value of our option to the widget that we have. *)
                      (* NOTE: This is the same function that we use in the command builder to match values to widgets. *)
                      matchedWidgetInformation=AppHelpers`Private`matchValueToWidget[value,optionDefinition];

                      (* Look for matched object widgets that have labels. *)
                      (* NOTE: A little wonky here, all of the Data fields from the AppHelpers function gets returned as a string, so we need *)
                      (* to separate legit strings from objects that were turned into strings. *)
                      objectWidgetsWithLabels=Cases[ToList@matchedWidgetInformation, KeyValuePattern[{"Type" -> "Object", "Data" -> _?(!StringStartsQ[#, "Object["] && !StringStartsQ[#, "Model["]&)}], Infinity];

                      (* This will give us our labels. *)
                      labelsInOption=(StringReplace[#,"\""->""]&)/@Lookup[objectWidgetsWithLabels, "Data", {}];

                      (* Replace any labels that we have with Automatics. *)
                      option-> (
                        value /. (Alternatives@@labelsInOption -> Automatic)
                      )
                    ]
                ]
              ]
            ],
            Association@inputsFromPrimitiveOptions
          ]
        ];

        (* Pass down the inputs and options down to the resolver function. *)
        evaluationData=Block[{$Messages},
          $Messages = {};
          EvaluationData[
            If[MatchQ[primitive, plateReaderPrimitiveP],
              ToList@primitiveResolverMethod[
                Sequence@@(inputsWithAutomatics[[All,2]]),
                Object[Protocol, Head[primitive]],
                Join[
                  optionsFromPrimitiveOptions,
                  {
                    Cache->cacheBall,
                    (* Pass down the Preparation option if our primitive was in a method wrapper. *)
                    If[!MatchQ[Lookup[primitive[[1]], PrimitiveMethod, Null], Null] && !KeyExistsQ[primitive[[1]], Preparation],
                      Preparation->Lookup[primitive[[1]], PrimitiveMethod, Null]/.{
                        ManualSamplePreparation|ManualCellPreparation|Experiment -> Manual,
                        RoboticSamplePreparation|RoboticCellPreparation->Robotic
                      },
                      Nothing
                    ]
                  }
                ]
              ],
              ToList@primitiveResolverMethod[
                Sequence@@(inputsWithAutomatics[[All,2]]),
                Join[
                  optionsFromPrimitiveOptions,
                  {
                    Cache->cacheBall,
                    (* Pass down the Preparation option if our primitive was in a method wrapper. *)
                    If[!MatchQ[Lookup[primitive[[1]], PrimitiveMethod, Null], Null] && !KeyExistsQ[primitive[[1]], Preparation],
                      Preparation->Lookup[primitive[[1]], PrimitiveMethod, Null]/.{
                        ManualSamplePreparation|ManualCellPreparation|Experiment -> Manual,
                        RoboticSamplePreparation|RoboticCellPreparation->Robotic
                      },
                      Nothing
                    ]
                  }
                ]
              ]
            ]
          ]
        ];

        (* Lookup from our evaluation data. *)
        potentialRawMethods=Lookup[evaluationData,"Result"];
        messageStrings=Lookup[evaluationData,"MessagesText"];

        (* Remove Warning::UnknownOption and remove the message heads. *)
        filteredMessageStrings=Function[{errorString},
          Module[{functionHead,functionMessage},
            (* Parse out the function head and the function message. *)
            {functionHead,functionMessage}=Check[
              First[StringCases[errorString,((x:(__~~"::"~~__))~~" : "~~y___):>{x,y}]],
              {Null,Null}
            ];

            (* If we weren't able to successfully parse our the message, don't throw anything. *)
            If[!MatchQ[{functionHead,functionMessage},{Null,Null}],
              (* Don't throw Warning::UnknownOption. RunUnitTest is a degenerate function that sometimes will throw things that we don't want. *)
              If[MatchQ[functionHead,"Warning::UnknownOption"],
                Nothing,
                functionMessage
              ]
            ]
          ]
        ]/@messageStrings;

        (* NOTE: We always return Manual/Robotic from our method resolver function. Add Cell or Sample depending *)
        (* on the experiment function that we're in. *)
        conflictingPreparationAndMethodWrapperText=Module[{preparationOption, primitiveMethod},
          (* Lookup the preparation option. *)
          preparationOption=Lookup[primitive[[1]], Preparation, Null];
          primitiveMethod=Lookup[primitive[[1]], PrimitiveMethod, Null];

          (* If the preparation option was given and it doesn't match the primitive method, include an additional error. *)
          If[Or[
              MatchQ[preparationOption, Manual] && MatchQ[primitiveMethod, RoboticSamplePreparation|RoboticCellPreparation],
              MatchQ[preparationOption, Robotic] && MatchQ[primitiveMethod, ManualSamplePreparation|ManualCellPreparation|Experiment]
            ],
            "The preparation option for this unit operation was specified as "<>ToString[preparationOption]<>" but the primitive is placed in a "<>ToString[primitiveMethod]<>" group. Please resolve this conflict in order to generate a valid unit operation.",
            Nothing
          ]
        ];

        (* The given Preparation or method wrapper head doesn't support the methods returned by the method resolver function. *)
        conflictingMethodResolverText=Module[{preparationOption, primitiveMethod},
          (* Lookup the preparation option. *)
          preparationOption=Lookup[primitive[[1]], Preparation, Null];
          primitiveMethod=Lookup[primitive[[1]], PrimitiveMethod, Null];

          (* If the preparation option was given and it doesn't match the primitive method, include an additional error. *)
          Which[
            (* NOTE: This means that the primitive method resolver function is defined incorrectly in terms of taking in Automatics. *)
            (* Something didn't pattern match. Instead of yelling at the user, just quiet this. *)
            !MatchQ[potentialRawMethods, Manual|Robotic|_List],
              "",
            And[
              MatchQ[preparationOption, Robotic] || MatchQ[primitiveMethod, RoboticSamplePreparation|RoboticCellPreparation],
              !MemberQ[potentialRawMethods, Robotic]
            ],
              "The unit operation was specified as Robotic but based on the options/inputs specified, it is not compatible with the Robotic method. Please let the Preparation of this unit operation resolve automatically.",
            And[
              MatchQ[preparationOption, Manual] || MatchQ[primitiveMethod, ManualSamplePreparation|ManualCellPreparation],
              !MemberQ[potentialRawMethods, Manual]
            ],
              "The unit operation was specified as Manual but based on the options/inputs specified, it is not compatible with the Manual method. Please let the Preparation of this unit operation resolve automatically.",
            True,
              ""
          ]
        ];

        StringRiffle@Flatten@{
          filteredMessageStrings,
          conflictingPreparationAndMethodWrapperText,
          conflictingMethodResolverText
        }
      ]
    ],
    flattenedPrimitives
  ];

  (* Return JSON association. *)
  ExportJSON@{
    "Messages"->primitiveMessages
  }
];

(* Helper function to memoize the creation of a fake water sample in a 50mL tube. This is for speed. *)
simulateFakeWaterSample[]:=simulateFakeWaterSample[]=Module[{newContainerPackets, newContainerObject, simulationWithContainerPackets, newSamplePackets},
  (* Create a new container. *)
  (* DANGER: This uses the first shelf of the room temperature VLM. This is probably not a good idea and should be changed for something more sustainable. *)
  newContainerPackets = UploadSample[
    Model[Container, Vessel, "50mL Tube"],
    {"A1", Object[Container, Room, "id:AEqRl9KmEAz5"]}, (* Object[Container, Room, "Empty Room for Simulated Objects"] *)
    FastTrack->True,
    SimulationMode -> True,
    Upload -> False
  ];
  newContainerObject = Lookup[newContainerPackets[[1]], Object];

  (* Update it with the container packets. *)
  simulationWithContainerPackets = Simulation[newContainerPackets];

  (* Put some water in our container. *)
  newSamplePackets = UploadSample[
    Model[Sample, "Milli-Q water"],
    {"A1", newContainerObject},
    State->Liquid,
    InitialAmount->25 Milliliter,
    Simulation -> simulationWithContainerPackets,
    SimulationMode -> True,
    FastTrack->True,
    Upload -> False
  ];

  {
    newContainerObject,
    Lookup[newSamplePackets[[1]], Object],
    UpdateSimulation[simulationWithContainerPackets, Simulation[newSamplePackets]]
  }
];



(* ::Subsubsection::Closed:: *)
(*holdComposition*)


(* ::Code::Initialization:: *)
(* Given f and Hold[g[x]], return Hold[f[g[x]]] without evaluating anything. *)
holdComposition[f_,Hold[expr__]]:=Hold[f[expr]];
SetAttributes[holdComposition,HoldAll];



(* ::Subsubsection::Closed:: *)
(*holdCompositionList*)


(* ::Code::Initialization:: *)
(* Given f and {Hold[a[x]], Hold[b[x]]..}, returns Hold[f[a[x],b[x]..]]. *)
holdCompositionList[f_,{helds___Hold}]:=Module[{joinedHelds},
  (* Join the held heads. *)
  joinedHelds=Join[helds];

  (* Swap the outer most hold with f. Then hold the result. *)
  With[{insertMe=joinedHelds},holdComposition[f,insertMe]]
];
SetAttributes[holdCompositionTimesList,HoldAll];



(* ::Subsubsection::Closed:: *)
(*stackableTipPositions/nonStackableTipPositions*)


(* ::Code::Initialization:: *)
(* "STARlet", "Super STAR" *)
stackableTipPositions[Model[Instrument,LiquidHandler,"id:kEJ9mqaW7xZP"]|Model[Instrument, LiquidHandler, "id:7X104vnRbRXd"]|Model[Instrument, LiquidHandler, "id:N80DNjkzez5W"]|Model[Instrument, LiquidHandler, "id:R8e1PjeLn8Bj"]]:={
  {"Deck Slot","Tip Carrier Slot 2","A1"},
  {"Deck Slot","Tip Carrier Slot 2","B1"},
  {"Deck Slot","Tip Carrier Slot 2","C1"},
  {"Deck Slot","Tip Carrier Slot 2","D1"},
  {"Deck Slot","Tip Carrier Slot 2","E1"}
};

(* "Super STAR" *)

nonStackableTipPositions[Model[Instrument, LiquidHandler, "id:7X104vnRbRXd"]|Model[Instrument, LiquidHandler, "id:N80DNjkzez5W"]|Model[Instrument, LiquidHandler, "id:R8e1PjeLn8Bj"]]:={
  {"Deck Slot","Tip Carrier Slot 1","A1"},
  {"Deck Slot","Tip Carrier Slot 1","B1"},
  {"Deck Slot","Tip Carrier Slot 1","C1"},
  {"Deck Slot","Tip Carrier Slot 1","D1"},
  {"Deck Slot","Tip Carrier Slot 1","E1"}
};

(* "STARlet" *)

nonStackableTipPositions[Model[Instrument,LiquidHandler,"id:kEJ9mqaW7xZP"]]:={
  {"Deck Slot","Tip Carrier Slot 1","A1"},
  {"Deck Slot","Tip Carrier Slot 1","B1"},
  {"Deck Slot","Tip Carrier Slot 1","C1"},
  {"Deck Slot","Tip Carrier Slot 1","D1"},
  {"Deck Slot","MALDI Carrier Slot","Tip Slot"}
};

(* "bioSTAR" and "microbioSTAR" *)
stackableTipPositions[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"]|Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"]]:={};

nonStackableTipPositions[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"]|Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"]]:={
  {"Deck Slot","Tip Carrier Slot 1","A1"},
  {"Deck Slot","Tip Carrier Slot 1","B1"},
  (* NOTE: We leave the third position on the first carrier empty as a tip hand off position. *)
  {"Deck Slot","Tip Carrier Slot 1","D1"},
  {"Deck Slot","Tip Carrier Slot 2","A1"},
  {"Deck Slot","Tip Carrier Slot 2","B1"},
  {"Deck Slot","Tip Carrier Slot 2","C1"},
  {"Deck Slot","Tip Carrier Slot 2","D1"}
};



(* ::Subsubsection::Closed:: *)
(*lookupPrimitiveDefinition*)


(* ::Code::Initialization:: *)
lookupPrimitiveDefinition[myPrimitiveName_Symbol]:=Lookup[Lookup[Lookup[$PrimitiveSetPrimitiveLookup, Hold[ExperimentP]], Primitives], myPrimitiveName];



(* ::Subsubsection::Closed:: *)
(*allActiveInstrumentPackets*)

(* function that gets all active instrument packets and memoizes it so that SimulateResources can go fast and stay fast *)
allActiveInstrumentPackets[myTypes:{TypeP[]...}]:=Module[
  {cache},
  cache = allActiveInstrumentPacketsCache["Memoization"];
  (* if we're on production, we won't be creating/erasing instrument objects.  So we can save some performance by not having to call DatabaseMemberQ *)
  (* for stage, though, since we might step on each others' toes when searching for instruments, we need to do this filtering *)
  (* in either case, we should filter down to fewer objects at this stage though *)
  (* also doing the _Association match to ensure any $Faileds that come from allActiveInstrumentPacketsCache don't go any further *)
  With[{relevantCache = Select[cache, MatchQ[#, _Association] && MemberQ[myTypes, Model @@ Lookup[#, Type]]&]},
    If[ProductionQ[],
      relevantCache,
      PickList[relevantCache, DatabaseMemberQ[relevantCache]]
    ]
  ]
];

allActiveInstrumentPacketsCache[fakeString_String]:=allActiveInstrumentPacketsCache[fakeString] = Module[
  {allInstruments},
  (*Add allActiveInstrumentPackets to list of Memoized functions*)
  AppendTo[$Memoization,Experiment`Private`allActiveInstrumentPacketsCache];

  allInstruments = Search[Object[Instrument], Status != Retired && DeveloperObject!=True];
  (* on production just Download; quiet Download::ObjectDoesNotExist on test dbs because the only time where this happens with any frequency is with test instruments that get erased in the time since we did the Search *)
  If[ProductionQ[],
    Download[allInstruments, Packet[Model, Site]],
    Quiet[
      Download[allInstruments, Packet[Model, Site]],
      Download::ObjectDoesNotExist
    ]
  ]
];

(* ::Subsubsection::Closed:: *)
(*hamiltonTipModelSearch*)

(* memoized search for hamilton tips *)
hamiltonTipModelSearch[fakeString_String]:=hamiltonTipModelSearch[fakeString] = Module[
  {},

  (*Add hamiltonTipModelSearch to list of Memoized functions*)
  AppendTo[$Memoization,Experiment`Private`hamiltonTipModelSearch];

  Search[Model[Item, Tips], PipetteType == Hamilton && Deprecated != True && DeveloperObject != True]

];


(* ::Subsubsection::Closed:: *)
(*hamiltonRackModelSearch*)

(* memoized search for hamilton tips *)
hamiltonRackModelSearch[fakeString_String]:=hamiltonRackModelSearch[fakeString] = Module[
  {},

  (*Add hamiltonRackModelSearch to list of Memoized functions*)
  AppendTo[$Memoization,Experiment`Private`hamiltonRackModelSearch];

  Search[{Model[Container, Rack], Model[Container, Spacer]}, LiquidHandlerPrefix != Null && DeveloperObject != True]

];


(* ::Subsubsection::Closed:: *)
(*resolvePrimitiveMethods*)


(* ::Code::Initialization:: *)
Error::InvalidSuppliedPrimitiveMethod="The following primitives, `1`, at indices, `2`, have the following primitive methods specified, `3`. These primitive methods are not valid for the given primitives. Please let the primitive method resolve automatically or move the primitive into a valid method wrapper.";

resolvePrimitiveMethods[myFunction_, myPrimitives_List, myHeldPrimitiveSet_Hold]:=Module[
  {primitiveSetInformation, allPrimitivesInformation, primitiveToAllowedMethodsLookup, singleMethodResolvedPrimitives,
    invalidPrimitiveMethodsWithIndices},

  (* Lookup our primitive set information again. *)
  primitiveSetInformation=Lookup[$PrimitiveSetPrimitiveLookup, myHeldPrimitiveSet];
  allPrimitivesInformation=Lookup[primitiveSetInformation, Primitives];

  (* Build an easy to use lookup of our primitive head to the allowed methods for that primitive. *)
  primitiveToAllowedMethodsLookup=(Lookup[#,PrimitiveHead]->Lookup[#, Methods]&)/@Values[allPrimitivesInformation];

  (* STEP 1: Certain primitives can only be performed via one method (ex. HPLC can only be done manually). Resolve the *)
  (* method for these primitives. *)

  (* Keep track of primitives that were given to us with a PrimitiveMethod by the user, but don't allow for that PrimitiveMethod. *)
  invalidPrimitiveMethodsWithIndices={};

  singleMethodResolvedPrimitives=MapThread[
    Function[{primitive, index},
      Which[
        (* This primitive already has a PrimitiveMethod key so we don't have anything to resolve. But, we error check *)
        (* to make sure that this method is valid. *)
        KeyExistsQ[primitive[[1]], PrimitiveMethod] && MatchQ[Lookup[primitive[[1]], PrimitiveMethod], Except[Automatic]],
          Module[{givenPrimitiveMethod, methods},
            (* The user gave us a PrimitiveMethod. Make sure that this primitive allows for that primitive method. *)
            givenPrimitiveMethod=Lookup[primitive[[1]], PrimitiveMethod];

            (* Lookup the allowable methods for this primitive head. *)
            methods=Lookup[
              Lookup[allPrimitivesInformation, Head[primitive]],
              Methods
            ];

            If[!MemberQ[methods, givenPrimitiveMethod],
              AppendTo[invalidPrimitiveMethodsWithIndices, {Head[primitive], givenPrimitiveMethod, index}];
            ];

            (* Return the primitive. *)
            primitive
          ],
        (* Are we in a specific function? *)
        MatchQ[myFunction, ExperimentManualSamplePreparation],
          Head[primitive]@Append[
            primitive[[1]],
            PrimitiveMethod->ManualSamplePreparation
          ],
        MatchQ[myFunction, ExperimentManualCellPreparation],
          Head[primitive]@Append[
            primitive[[1]],
            PrimitiveMethod->ManualCellPreparation
          ],
        MatchQ[myFunction, ExperimentRoboticSamplePreparation],
          Head[primitive]@Append[
            primitive[[1]],
            PrimitiveMethod->RoboticSamplePreparation
          ],
        MatchQ[myFunction, ExperimentRoboticCellPreparation],
          Head[primitive]@Append[
            primitive[[1]],
            PrimitiveMethod->RoboticCellPreparation
          ],
        (* Otherwise, see if we only have one allowed method for this primitive head. *)
        Length[Lookup[primitiveToAllowedMethodsLookup, Head[primitive], {}]]==1,
          Head[primitive]@Append[
            primitive[[1]],
            PrimitiveMethod->FirstOrDefault[Lookup[primitiveToAllowedMethodsLookup, Head[primitive], {}]]
          ],
        (* TODO: Otherwise, call the method resolver function for the primitive to try and narrow down the list. *)
        True,
          Module[
            {allPrimitiveInformation, primitiveInformation, primitiveResolverMethod, primitiveOptionDefinitions, inputsFromPrimitiveOptions,
              optionsFromPrimitiveOptions, inputsWithAutomatics, optionsWithAutomatics, potentialRawMethods, potentialMethods},

            (* Lookup the method resolver function. *)
            allPrimitiveInformation=Lookup[primitiveSetInformation, Primitives];
            primitiveInformation=Lookup[allPrimitiveInformation, Head[primitive]];
            primitiveResolverMethod=Lookup[primitiveInformation, MethodResolverFunction];
            primitiveOptionDefinitions=Lookup[primitiveInformation, OptionDefinition];

            (* Separate out our primitive options into inputs and function options. *)
            inputsFromPrimitiveOptions=(#->Lookup[primitive[[1]], #, Automatic]&)/@Lookup[primitiveInformation, InputOptions];
            optionsFromPrimitiveOptions=Cases[
              Normal[primitive[[1]], Association],
              Verbatim[Rule][
                Except[Alternatives[PrimitiveMethod, PrimitiveMethodIndex, WorkCell, (Sequence@@Lookup[primitiveInformation, InputOptions])]],
                _
              ]
            ];

            (* If we're in Transfer, the transfers will be split into multiple transfers with 970 Microliters in the main resolution loop. *)
            (* Set the volume of any transfers over 970 Microliter so that the resolver doesn't think it can only be manual. *)
            inputsFromPrimitiveOptions=If[MatchQ[primitive, _Transfer],
              inputsFromPrimitiveOptions/.{vol:GreaterP[970 Microliter]:>970 Microliter},
              inputsFromPrimitiveOptions
            ];

            (* Change any labels to Automatics since we don't have any simulated objects that correspond to the labels yet. *)
            inputsWithAutomatics=KeyValueMap[
              Function[{option, value},
                Module[{optionDefinition},
                  (* Lookup information about this option. *)
                  optionDefinition=FirstCase[primitiveOptionDefinitions,KeyValuePattern["OptionSymbol"->option],Null];

                  (* Do does this option allow for PreparedSample or PreparedContainer? *)
                  Which[
                    (* NOTE: We have to convert any associations (widgets automatically evaluate into associations) because *)
                    (* Cases will only look inside of lists, not associations. *)
                    Length[Cases[Lookup[optionDefinition, "Widget"]/.{w_Widget :> Normal[w[[1]]]}, (PreparedContainer->True)|(PreparedSample->True), Infinity]]==0,
                    (* Nothing to replace. *)
                    option->value,
                    True,
                    (* We may potentially have some labels. *)
                    Module[{matchedWidgetInformation, objectWidgetsWithLabels, labelsInOption},
                      (* Match the value of our option to the widget that we have. *)
                      (* NOTE: This is the same function that we use in the command builder to match values to widgets. *)
                      matchedWidgetInformation=AppHelpers`Private`matchValueToWidget[value,optionDefinition];

                      (* Look for matched object widgets that have labels. *)
                      (* NOTE: A little wonky here, all of the Data fields from the AppHelpers function gets returned as a string, so we need *)
                      (* to separate legit strings from objects that were turned into strings. *)
                      objectWidgetsWithLabels=Cases[ToList@matchedWidgetInformation, KeyValuePattern[{"Type" -> "Object", "Data" -> _?(!StringStartsQ[#, "Object["] && !StringStartsQ[#, "Model["]&)}], Infinity];

                      (* This will give us our labels. *)
                      labelsInOption=(StringReplace[#,"\""->""]&)/@Lookup[objectWidgetsWithLabels, "Data", {}];

                      (* Replace any labels that we have with Automatics. *)
                      option-> (
                        value /. (Alternatives@@labelsInOption -> Automatic)
                      )
                    ]
                  ]
                ]
              ],
              Association@inputsFromPrimitiveOptions
            ];

            optionsWithAutomatics=KeyValueMap[
              Function[{option, value},
                Module[{optionDefinition},
                  (* Lookup information about this option. *)
                  optionDefinition=FirstCase[primitiveOptionDefinitions,KeyValuePattern["OptionSymbol"->option],Null];

                  (* Do does this option allow for PreparedSample or PreparedContainer? *)
                  Which[
                    (* NOTE: We have to convert any associations (widgets automatically evaluate into associations) because *)
                    (* Cases will only look inside of lists, not associations. *)
                    Length[Cases[Lookup[optionDefinition, "Widget"]/.{w_Widget :> Normal[w[[1]]]}, (PreparedContainer->True)|(PreparedSample->True), Infinity]]==0,
                    (* Nothing to replace. *)
                    option->value,
                    True,
                    (* We may potentially have some labels. *)
                    Module[{matchedWidgetInformation, objectWidgetsWithLabels, labelsInOption},
                      (* Match the value of our option to the widget that we have. *)
                      (* NOTE: This is the same function that we use in the command builder to match values to widgets. *)
                      matchedWidgetInformation=AppHelpers`Private`matchValueToWidget[value,optionDefinition];

                      (* Look for matched object widgets that have labels. *)
                      (* NOTE: A little wonky here, all of the Data fields from the AppHelpers function gets returned as a string, so we need *)
                      (* to separate legit strings from objects that were turned into strings. *)
                      objectWidgetsWithLabels=Cases[ToList@matchedWidgetInformation, KeyValuePattern[{"Type" -> "Object", "Data" -> _?(!StringStartsQ[#, "Object["] && !StringStartsQ[#, "Model["]&)}], Infinity];

                      (* This will give us our labels. *)
                      labelsInOption=(StringReplace[#,"\""->""]&)/@Lookup[objectWidgetsWithLabels, "Data", {}];

                      (* Replace any labels that we have with Automatics. *)
                      option-> (
                        value /. (Alternatives@@labelsInOption -> Automatic)
                      )
                    ]
                  ]
                ]
              ],
              Association@optionsFromPrimitiveOptions
            ];

            (* Pass down the inputs and options down to the resolver function. *)
            (* NOTE: We have to quiet here because we'll internally call the method resolver function again by calling the *)
            (* experiment function, so if there are messages, they'll be thrown there. *)
            potentialRawMethods=If[MatchQ[primitive, plateReaderPrimitiveP],
              Quiet[
                ToList@primitiveResolverMethod[
                  Sequence@@Values[inputsWithAutomatics],
                  Object[Protocol, Head[primitive]],
                  Join[
                    optionsWithAutomatics,
                    {
                      Output->Result
                    }
                  ]
                ]
              ],
              Quiet[
                ToList@primitiveResolverMethod[
                  Sequence@@Values[inputsWithAutomatics],
                  Join[
                    optionsWithAutomatics,
                    {
                      Output->Result
                    }
                  ]
                ]
              ]
            ];

            (* NOTE: We always return Manual/Robotic from our method resolver function. Add Cell or Sample depending *)
            (* on the experiment function that we're in. *)
            potentialMethods=Flatten@{
              Which[
                MemberQ[potentialRawMethods, Manual] && MatchQ[myFunction, ExperimentManualSamplePreparation|ExperimentSamplePreparation],
                Cases[Lookup[primitiveInformation, Methods], ManualSamplePreparation],
                MemberQ[potentialRawMethods, Manual] && MatchQ[myFunction, ExperimentManualCellPreparation|ExperimentCellPreparation],
                Cases[Lookup[primitiveInformation, Methods], ManualCellPreparation],
                MemberQ[potentialRawMethods, Manual] && MatchQ[myFunction, Experiment],
                Cases[Lookup[primitiveInformation, Methods], ManualSamplePreparation|ManualCellPreparation|Experiment],
                True,
                {}
              ],
              Which[
                MemberQ[potentialRawMethods, Robotic] && MatchQ[myFunction, ExperimentRoboticSamplePreparation|ExperimentSamplePreparation],
                Cases[Lookup[primitiveInformation, Methods], RoboticSamplePreparation],
                MemberQ[potentialRawMethods, Robotic] && MatchQ[myFunction, ExperimentRoboticCellPreparation|ExperimentCellPreparation],
                Cases[Lookup[primitiveInformation, Methods], RoboticCellPreparation],
                MemberQ[potentialRawMethods, Robotic] && MatchQ[myFunction, Experiment],
                Cases[Lookup[primitiveInformation, Methods], RoboticSamplePreparation|RoboticCellPreparation|Experiment],
                True,
                {}
              ]
            };

            Head[primitive]@Append[
              primitive[[1]],
              PrimitiveMethod->If[MatchQ[potentialMethods, {PrimitiveMethodsP..}],
                potentialMethods,
                Lookup[primitiveToAllowedMethodsLookup, Head[primitive], {}]
              ]
            ]
          ]
      ]
    ],
    {myPrimitives, Range[Length[myPrimitives]]}
  ];

  If[Length[invalidPrimitiveMethodsWithIndices]>0,
    Message[Error::InvalidSuppliedPrimitiveMethod, invalidPrimitiveMethodsWithIndices[[All,1]], invalidPrimitiveMethodsWithIndices[[All,3]], invalidPrimitiveMethodsWithIndices[[All,2]]];
  ];

  (* Return our resolved result. *)
  {
    singleMethodResolvedPrimitives,
    DeleteDuplicates[Flatten[{invalidPrimitiveMethodsWithIndices[[All,3]]}]]
  }
];



(* ::Subsubsection::Closed:: *)
(*tallySubsetQ*)


(* ::Code::Initialization:: *)
(* Helper function that returns True if the first tally contains all of the elements of the second tally. *)
tallySubsetQ[tally1_List,tally2_List]:=And@@Map[
  Function[{secondTallyElement},
    Module[{firstTallyElement},
      (* Find the element of the second tally within the first tally. *)
      firstTallyElement=FirstCase[tally1, {secondTallyElement[[1]], _}, Null];

      (* If were unable to find the element in the first tally, or the number in the first tally *)
      (* is less than the number in the second tally, then we're not a subset. *)
      And[
        !MatchQ[firstTallyElement, Null],
        MatchQ[firstTallyElement[[2]], GreaterEqualP[secondTallyElement[[2]]]]
      ]
    ]
  ],
  tally2
];

(* Helper function that will filter out any instruments that are not compatible with the given
1) Footprint requirements
2) Tip Requirements
3) Integrated Instrument Requirements
4) Idling Condition Requirements. *)
filterInstruments[
  potentialInstruments_List,
  newFootprintTally_List,
  startingAmbientContainers_List,
  startingIncubatorContainers_List,
  workCellIdlingConditionHistory_List, (* {(ObjectP[Object[Container]] -> Incubator|Ambient)..} *)
  stackedTipPositionsNeeded_Integer,
  nonStackedTipPositionsNeeded_Integer,
  instrumentResourceModels_List,
  highPrecisionPositionContainersBools_List,
  cache_List,
  tipAdapterUsed_?BooleanQ
]:=Map[
  Function[{potentialInstrument},
    Module[{potentialInstrumentAsModel, instrumentModelPacket, availableFootprints, maxNonStackedTipPositions,
      maxStackedTipPositions, integratedInstrumentModels, maxIncubatorPlatePositions, updatedMaxOffDeckStoragePositions, updatedMaxNonStackedTipPositions,
      currentAmbientContainers, currentIncubatorContainers, highPrecisionContainerTally, maxOffDeckStoragePositions,
      maxAmbientPlatePositions},

      (* Convert to a model if necessary. *)
      potentialInstrumentAsModel=If[MatchQ[potentialInstrument, ObjectP[Model[Instrument]]],
        potentialInstrument,
        Lookup[fetchPacketFromCache[potentialInstrument, cache], Model]
      ];

      (* Get the packet for this instrument. *)
      instrumentModelPacket=fetchPacketFromCache[potentialInstrumentAsModel, cache];

      (* Short circuit if we have a Object/Model[Instrument,ColonyHandler], the qpix does not have all of these checks *)
      If[MatchQ[instrumentModelPacket, PacketP[{Object[Instrument,ColonyHandler],Model[Instrument,ColonyHandler]}]],
        Return[potentialInstruments, Module]
      ];

      (* Lookup information from this instrument. *)
      availableFootprints=Lookup[instrumentModelPacket, AvailableFootprints];
      maxNonStackedTipPositions=With[{lookup = Lookup[instrumentModelPacket, MaxNonStackedTipPositions]/.Null->0},
        (* if we are using a tip adapter, we need to take out one position from the non-stacked instruments *)
        If[tipAdapterUsed,
          If[lookup==0, 0, lookup-1],
          lookup
        ]];
      maxStackedTipPositions=Lookup[instrumentModelPacket, MaxStackedTipPositions]/.Null->0;
      integratedInstrumentModels=Lookup[instrumentModelPacket, IntegratedInstruments];
      maxIncubatorPlatePositions=Lookup[instrumentModelPacket, MaxIncubatorPlatePositions];
      maxOffDeckStoragePositions=Lookup[instrumentModelPacket, MaxOffDeckStoragePositions];

      (* If we have too many non stacked tips, put them off deck. *)
      (* NOTE: We only have off deck tip storage on the bioSTAR/microbioSTAR since it requires a HMotion. We can only *)
      (* use non stacked tips on the bioSTAR/microbioSTAR due to sterility requirements. Also, we need non stacked tips *)
      (* since we need a tip box to load up the tips in the first place (non stacked tips can't fit in the tip box. *)
      {updatedMaxOffDeckStoragePositions, updatedMaxNonStackedTipPositions}=If[And[
          MatchQ[nonStackedTipPositionsNeeded, GreaterP[maxNonStackedTipPositions]],
          MatchQ[nonStackedTipPositionsNeeded, LessEqualP[maxNonStackedTipPositions + maxOffDeckStoragePositions]]
        ],
        {
          maxOffDeckStoragePositions-(nonStackedTipPositionsNeeded-maxNonStackedTipPositions),
          nonStackedTipPositionsNeeded
        },
        {
          maxOffDeckStoragePositions,
          maxNonStackedTipPositions
        }
      ];

      (* Get the total number of ambient deck positions that we have available to us for plates (the number of positions *)
      (* available for plates on deck plus the number of off deck plate positions). *)
      maxAmbientPlatePositions=updatedMaxOffDeckStoragePositions + Lookup[Rule@@@availableFootprints, Plate, 0];

      (* If we have too many on deck positions, put some of them *)

      (* Filter out this instrument if the basic requirements (1-3) don't match up. *)
      If[Or[
          (* Has to be able to fit all necessary footprints. *)
          (* NOTE: Add the additional off deck plate storage positions we have to our available footprints. *)
          !tallySubsetQ[
            List@@@ReplaceRule[Rule@@@availableFootprints, Plate->maxAmbientPlatePositions],
            newFootprintTally
          ],

          (* Has to be able to fit all tips, stacked and non-stacked. *)
          !MatchQ[stackedTipPositionsNeeded, LessEqualP[maxStackedTipPositions]],
          !MatchQ[nonStackedTipPositionsNeeded, LessEqualP[updatedMaxNonStackedTipPositions]],

          (* Has to be integrated with all required instrument models. *)
          (* since instrumentResourceModels can be a list or a list of lists (because instrument models can be either) need to do it this way.  Also note that if you have a resource requesting more than one instrument, the corresponding liquid handler only needs one *)
          !AllTrue[
            Download[instrumentResourceModels, Object],
            MemberQ[Download[integratedInstrumentModels, Object], Alternatives @@ ToList[#]]&
          ]
        ],
        Return[Nothing, Module];
      ];

      (* Otherwise, check the idling condition requirements. *)

      (* NOTE: We're only making associations here because doing KeyExistsQ on it is faster. *)
      (* NOTE: This is only checking containers that are Footprint->Plate because that is the only type of container *)
      (* that we can move around. *)
      currentAmbientContainers=Association@((#->Null&)/@startingAmbientContainers);
      currentIncubatorContainers=Association@((#->Null&)/@startingIncubatorContainers);

      (* If we don't have incubation positions (not on the bioSTAR/microbioSTAR) or we have too many plates just starting off, return False. *)
      If[Or[
          And[MatchQ[currentAmbientContainers, _Integer], MatchQ[maxAmbientPlatePositions, Null]],
          And[MatchQ[currentIncubatorContainers, _Integer], MatchQ[maxIncubatorPlatePositions, Null]],
          MatchQ[Length[currentAmbientContainers], GreaterP[maxAmbientPlatePositions]],
          MatchQ[Length[currentIncubatorContainers], GreaterP[maxIncubatorPlatePositions]]
        ],
        Return[Nothing, Module];
      ];

      (* Map through the idling conditions and make changes to our lists of labels. If we ever exceed the ambient or *)
      (* incubator capacity, do not include this instrument. *)
      Map[
        Function[{idlingConditionChange},
          (* If this label isn't in our starting plate label lookup, it must not have Footprint->Plate so just ignore it. *)
          (* Otherwise, if this plate label is changing locations, update our lookups. *)
          Which[
            KeyExistsQ[currentAmbientContainers, idlingConditionChange[[1]]],
              If[MatchQ[idlingConditionChange[[2]], Ambient],
                Null,

                KeyDropFrom[currentAmbientContainers, idlingConditionChange[[1]]];
                AppendTo[currentIncubatorContainers, idlingConditionChange[[1]]->Null];
              ],
            KeyExistsQ[currentIncubatorContainers, idlingConditionChange[[1]]],
              If[MatchQ[idlingConditionChange[[2]], Incubator],
                Null,

                KeyDropFrom[currentIncubatorContainers, idlingConditionChange[[1]]];
                AppendTo[currentAmbientContainers, idlingConditionChange[[1]]->Null];
              ],
            True,
              Null
          ];

          (* If we've run out of positions, filter out this instrument. *)
          (* NOTE: We assume that we will have enough ambient deck . *)
          If[Or[
              And[MatchQ[currentAmbientContainers, _Integer], MatchQ[maxAmbientPlatePositions, Null]],
              And[MatchQ[currentIncubatorContainers, _Integer], MatchQ[maxIncubatorPlatePositions, Null]],
              MatchQ[Length[currentAmbientContainers], GreaterP[maxAmbientPlatePositions]],
              MatchQ[Length[currentIncubatorContainers], GreaterP[maxIncubatorPlatePositions]]
            ],
              Return[Nothing, Module];
          ];
        ],
        workCellIdlingConditionHistory
      ];

      (*Check how many of the container models have HighPrecisionPositionRequired True*)
      highPrecisionContainerTally=Count[highPrecisionPositionContainersBools,True];

      (*Filter out instruments that can not handle the high precision tally *)
      (*The starlet only has one high precision position*)
      If[
        MatchQ[Download[potentialInstrumentAsModel,Object],ObjectP[Model[Instrument, LiquidHandler, "id:kEJ9mqaW7xZP"]]]&&MatchQ[highPrecisionContainerTally,GreaterP[1]],
        Return[Nothing, Module];
      ];

      (* We've passed all of our checks. Return the instrument. *)
      potentialInstrument
    ]
  ],
  potentialInstruments
];

(* This is the minimum buffer of tips that we want to be in each tip box since we can use more tips than we expect in each *)
(* tip box due to incorrect tip counts in SLL or interrupted hamilton runs. *)
$HamiltonTipBoxBuffer=12;



(* Authors definition for Experiment`Private`partitionTips *)
Authors[Experiment`Private`partitionTips]:={"taylor.hochuli"};

partitionTips[tipModelPackets_List, allTipResources_List, primitiveGrouping_List]:=Module[
  {tipModelsForMultiProbeHeadTransfers, allTips, talliedTipModels, partitionedTipCountLookup, requiredStackedTipTypes, requiredNonStackedTipTypes},

  (* Return early if we don't have any tips to partition. *)
  If[MatchQ[allTipResources, {}],
    Return[{{},{}}];
  ];

  (* --  Figure out what tip models will be used in multi probe head transfers. -- *)
  (* EXPLANATION: This is important because a multi probe head transfer requires a full rack of 96 tips. So, if we had *)
  (* a 96 head transfer followed by a single transfer, we would need 97 (plus extra tips for the rack abandonment issue) *)
  (* tips, but we can't request for those 97 tips to be in a single stack (96 on the bottom, 1 on the top) because the *)
  (* 96 head transfer will happen first, so it'll need to throw out the tip on the top rack to reach the full tip rack below, *)
  (* then when we get to the single transfer, we won't have any tips left. *)
  (* We get around this by seeing what tip models have a 96 head (MultiProbeHead) transfer associated with them and then *)
  (* making sure that we have the partial tip request on another tip position. Our tip selection code in selectTipsForPipetting *)
  (* in the robotic exporter for transfer/mix selects non-full tips first to preserve full tip rack levels for multi head *)
  (* transfers. *)
  (* NOTE: This only affects stacked tip models since non stacked tip models will always have their partial (non 96) racks *)
  (* on different positions on deck. *)
  tipModelsForMultiProbeHeadTransfers=DeleteDuplicates@Flatten@Map[
    Function[transferPrimitive,
      Module[{tips, deviceChannel, listedTips, listedDeviceChannel},
        {tips, deviceChannel}=Lookup[transferPrimitive[[1]], {Tips, DeviceChannel}];

        (* NOTE: Don't want to use ExpandIndexMatchedInputs here because it's wasteful. Do manual expanding. *)
        {listedTips, listedDeviceChannel}=Switch[{tips, deviceChannel},
          {_List, _List},
          {tips, deviceChannel},
          {Except[_List], _List},
          {ConstantArray[tips, Length[deviceChannel]], deviceChannel},
          {_List, Except[_List]},
          {tips, ConstantArray[deviceChannel, Length[tips]]},
          {Except[_List], Except[_List]},
          {{tips}, {deviceChannel}}
        ];

        (* For pipetting Mix, the DeviceChannel is Null and automatically excluded here *)
        Download[Cases[PickList[listedTips, listedDeviceChannel, MultiProbeHead], ObjectP[Model[Item, Tips]]], Object]
      ]
    ],
    (* Consider both Transfer and pipetting Mix *)
    Cases[primitiveGrouping, (_Transfer|_Mix)]
  ];

  (* Expand our tip resources so that every model is listed the number of times that tip is used. *)
  allTips=Flatten[(ConstantArray[Lookup[#[[1]], Sample], Lookup[#[[1]], Amount]]&)/@allTipResources];

  (* Tally our tip models. *)
  talliedTipModels=(Rule@@#&)/@Tally[allTips];

  (* Build lookup relating tip type to a list of tip counts partitioned by sample. For example, if we need *)
  (* 100 300ul stackable tips, <| Model[Item, Tip, "300ul tips"] -> {4,96} ...|> *)
  partitionedTipCountLookup = Association@KeyValueMap[
    Function[{tipModel,requiredCount},
      Module[{tipPacket,stackSize,maxUsableTipCountPerStack,fullLayersNeeded,tipRemainder,extraLayersNeeded,numberOfFullTipBoxesNeeded,numberOfOtherLayersNeeded,tipBoxCounts},
        (* Fetch tip model packet *)
        tipPacket = fetchPacketFromCache[tipModel,tipModelPackets];

        (* Fetch the number of levels in a stack *)
        stackSize = If[MatchQ[Lookup[tipPacket,MaxStackSize], GreaterP[1]],
          Lookup[tipPacket,MaxStackSize],
          1
        ];

        (* NOTE: For every tip box, we want to make sure that we are requesting AT LEAST $HamiltonTipBoxBuffer extra tips. This is because *)
        (* our tip counts may not be exactly precise due to pipetting issues (re-performing the pipetting will result in extra tips being used) *)
        (* or incorrect tip counts in the tip objects. *)
        (* NOTE: Also, Hamilton may discard the top layer of a tip rack if it has less than 8 tips -- so $HamiltonTipBoxBuffer has *)
        (* to be AT LEAST 8. *)
        maxUsableTipCountPerStack = Lookup[tipPacket,NumberOfTips] - $HamiltonTipBoxBuffer;

        (* Get the number of layers of tips that we will need. *)
        {fullLayersNeeded, tipRemainder} = QuotientRemainder[requiredCount,maxUsableTipCountPerStack];

        (* For tips required in MultiProbeHead transfer, we need extra tip rack at the bottom rack so we don't have collision issue when tip size delta is 3 *)
        (* More details in https://app.asana.com/0/1202908637230347/1203437241522836/f *)
        (* Need one extra layer for each tip object *)
        (* If we are requiring an extra tip box below since we want 2 tip positions per tip type, we don't really need an extra here *)
        extraLayersNeeded=If[MemberQ[tipModelsForMultiProbeHeadTransfers, ObjectP[tipModel]]&&(Floor[fullLayersNeeded/stackSize]>0)&&!MatchQ[stackSize, 1],
          Ceiling[fullLayersNeeded/(stackSize-1)],
          0
        ];

        (* Get the number of full tip boxes that we need. *)
        numberOfFullTipBoxesNeeded = Floor[(fullLayersNeeded+extraLayersNeeded)/stackSize];
        numberOfOtherLayersNeeded = (fullLayersNeeded+extraLayersNeeded) - (numberOfFullTipBoxesNeeded * stackSize);

        (* Create the list of the amounts of tips that we need in each of our tip boxes. *)
        tipBoxCounts = Prepend[
          Table[Lookup[tipPacket,NumberOfTips] * stackSize, numberOfFullTipBoxesNeeded],
          (* NOTE: We have to add $HamiltonTipBoxBuffer here again because tipRemainder will add another layer *)
          (* to our entire request, and we want $HamiltonTipBoxBuffer on each layer we request. *)
          Which[
            tipRemainder > 0 && numberOfOtherLayersNeeded > 0,
              (Lookup[tipPacket,NumberOfTips] * numberOfOtherLayersNeeded) + tipRemainder + $HamiltonTipBoxBuffer,
            tipRemainder > 0,
              tipRemainder + $HamiltonTipBoxBuffer,
            numberOfOtherLayersNeeded > 0,
              (Lookup[tipPacket,NumberOfTips] * numberOfOtherLayersNeeded),
            True,
              Nothing
          ]
        ];

        (* If we have stacked tips, make sure there are two instances of the stacked tips on deck in different spots *)
        (* if we're using the multi-probe head. This is because if there are single transfers in between the MPH transfers, *)
        (* we may need to throw out entire rack layers, which can make us run out of tips. This can be avoided by having *)
        (* two positions on deck since selectTipsForPipetting will prefer used boxes of tips to not throw out layers. *)
        If[
          And[
            (* If our tip model is non-stacked, we don't have to worry about the 96 head issue and discarding partial rack *)
            (* issue that we described earlier since all tip racks will be on different positions. *)
            !MatchQ[stackSize, 1],
            (* If we're not using our tip model for a multi probe head transfer, then we don't have to do any special tip arrangement on deck. *)
            MemberQ[tipModelsForMultiProbeHeadTransfers, ObjectP[tipModel]],
            (* If we have more than one position on deck for this tip type, we shouldn't run into the 96 head issue. *)
            !(Length[tipBoxCounts]>1)
          ],
          tipBoxCounts=Append[tipBoxCounts, Lookup[tipPacket,NumberOfTips] * stackSize];
        ];

        (* Return rule *)
        tipModel -> tipBoxCounts
      ]
    ],
    Association@talliedTipModels
  ];

  (* Extract required tip types that are stacked *)
  requiredStackedTipTypes = Select[
    DeleteDuplicates[allTips],
    TrueQ[Lookup[fetchPacketFromCache[#,tipModelPackets],MaxStackSize] > 1]&
  ];

  (* Extract required tip types that are not stacked *)
  requiredNonStackedTipTypes = UnsortedComplement[DeleteDuplicates[allTips],requiredStackedTipTypes];

  (* Build tuples of a stacked tip type and its required count for each sample request in the form: *)
  (* {{tip type, tip count required}..}. *)
  {
    Join@@Map[
      Function[tipModel,
        {tipModel,#}&/@Lookup[partitionedTipCountLookup,tipModel]
      ],
      requiredStackedTipTypes
    ],
    Join@@Map[
      Function[tipModel,
        {tipModel,#}&/@Lookup[partitionedTipCountLookup,tipModel]
      ],
      requiredNonStackedTipTypes
    ]
  }
];


(* helper function to determine if the input objects are Simulated or not; this is not as simple as looking at SimulatedObjects because $CreatedObjects makes things more complicated; see comments below *)
simulatedObjectQs[mySamples:{ObjectP[]...}, mySimulation_Simulation]:=If[MatchQ[$CurrentSimulation, SimulationP],
  Module[{allSimulatedObjectsUOOnly},
    allSimulatedObjectsUOOnly=DeleteCases[Lookup[mySimulation[[1]], SimulatedObjects], Alternatives @@ Lookup[$CurrentSimulation[[1]], SimulatedObjects]];

    (* The variable namespace here is confusing and hard to deconvolute but worth explaining: *)
    (* 1.) Lookup[mySimulation[[1]], SimulatedObjects] are all the Labeled objects inside of the currentSimulation (i.e., the simulation that came out of the options resolvers) *)
    (* 2.) allSimulatedObjectsUOOnly are the SimulatedObjects that exist in the currentSimulation, but NOT in $CurrentSimulation *)
    (* The reason we want this is because if it's in $CurrentSimulation, then we are in the global simulation space and the objects were put there by Upload.  For all intents and purposes, those are "real" objects, and not ones we need to replace with labels.*)
    (* 3.) Thus, the MemberQ will only return True if the objects are labeled by currentSimulation and NOT in $CurrentSimulation*)
    (MemberQ[allSimulatedObjectsUOOnly, #]&)/@mySamples
  ],
  (MemberQ[Lookup[mySimulation[[1]], SimulatedObjects], #]&)/@mySamples
];

