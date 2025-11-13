(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentStockSolution*)


(* ::Subsubsection:: *)
(*ExperimentStockSolution Options and Messages*)


DefineOptions[ExperimentPrepareReferenceElectrode,
	Options :> {
		(* Index matching options *)
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			(* Electrode Polishing *)
			{
				OptionName -> PolishReferenceElectrode,
				Default -> True,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if in the presence of rust, the non-working part (the metal part that does not directly contact experiment solution) of reference electrode is polished with a piece of 1200 grit sandpaper. The working part (the metal part that directly contacts experiment solution) will not be polished, and if rust is present on the working part, the electrode's RustyLog will be updated.",
				Category -> "Electrode Polishing"
			},

			(* Electrode Cleaning *)
			{
				OptionName -> PrimaryWashingSolution,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
				],
				Description -> "The solution used to wash the electrode metal wiring or plate and the electrode glass tube, after the previous reference solution (if any) is emptied and the optional polishing step is completed. This washing step helps to remove any remaining liquid or solid on the electrode metal wire or plate. A washing cycle includes rinsing the full surface areas of the electrode metal wiring or plate and the electrode glass tube (both inside and outside), with approximately 5 mL of solution.",
				ResolutionDescription -> "Automatically set to Model[Sample, \"Milli-Q water\"] if the RecommendedSolventType of the reference electrode model being prepared is Aqueous. If the RecommendedSolventType is Organic, it is automatically set to Model[Sample, \"Acetonitrile, Electronic Grade\"].",
				Category -> "Electrode Cleaning"
			},
			{
				OptionName -> NumberOfPrimaryWashings,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[1, 10, 1]
				],
				Description -> "Indicates the number of washing cycles performed with PrimaryWashingSolution.",
				ResolutionDescription -> "Automatically set to 2 if PrimaryWashingSolution is not Null. Automatically set to Null if PrimaryWashingSolution is set to Null.",
				Category -> "Electrode Cleaning"
			},
			{
				OptionName -> SecondaryWashingSolution,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
				],
				Description -> "The second solution used to wash the electrode metal wiring or plate and the electrode glass tube, after the primary washing step. This washing step helps to further remove any remaining liquid or solid on the electrode metal wire or plate. A washing cycle includes rinsing the full surface areas of the electrode metal wiring or plate and the electrode glass tube (both inside and outside), with approximately 5 mL of solution.",
				Category -> "Electrode Cleaning"
			},
			{
				OptionName -> NumberOfSecondaryWashings,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[1, 10, 1]
				],
				Description -> "Indicates the number of washing cycles performed with SecondaryWashingSolution.",
				ResolutionDescription -> "Automatically set to 2 if SecondaryWashingSolution is not Null. Automatically set to Null if SecondaryWashingSolution is set to Null.",
				Category -> "Electrode Cleaning"
			},

			(* Reference Electrode Preparation *)
			{
				OptionName -> NumberOfPrimings,
				Default -> 2,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[1, 10, 1]
				],
				Description -> "Indicates the number of priming cycles performed with ReferenceSolution defined in the reference electrode model being prepared. A priming cycle includes rinsing the full surface areas of the electrode metal wiring or plate and the electrode glass tube (only inside).",
				Category -> "Reference Electrode Preparation"
			},
			{
				OptionName -> PrimingVolume,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Milliliter, 20 Milliliter],
					Units -> {Milliliter, {Microliter, Milliliter}}
				],
				Description -> "Indicates the volume of the ReferenceSolution used to prime the reference electrode metal wire or plate and the inside of the glass tube in each priming cycle.",
				ResolutionDescription -> "Automatically set to the greater of 2 Milliliter or 2 times of the SolutionVolume defined in the reference electrode model being prepared.",
				Category -> "Reference Electrode Preparation"
			},
			{
				OptionName -> PrimingSoakTime,
				Default -> 5 Minute,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Minute, 15 Minute],
					Units -> {Minute, {Second, Minute}}
				],
				Description -> "Indicates the minimum duration of the reference electrode metal wire or plate will be soaked in the ReferenceSolution within the glass tube after the last priming cycle.",
				Category -> "Reference Electrode Preparation"
			},
			{
				OptionName -> ReferenceSolutionVolume,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Milliliter],
					Units -> {Milliliter, {Microliter, Milliliter}}
				],
				Description -> "Indicates the volume of the ReferenceSolution the electrode's glass tube is filled with. The ReferenceSolutionVolume should be within the range of 95% and 105% of the SolutionVolume defined by the reference electrode model being prepared.",
				ResolutionDescription -> "Automatically set to the SolutionVolume defined in the reference electrode model being prepared.",
				Category -> "Reference Electrode Preparation"
			}
		],

		(* --- Shared Standard Protocol Options --- *)
		ProtocolOptions,
		NonBiologyPostProcessingOptions,
		SamplesOutStorageOption,

		{
			OptionName -> NumberOfReplicates,
			Default -> Null,
			Description -> "Number of times each of the input reference electrode model should be prepared using identical experimental parameters.",
			AllowNull -> True,
			Category -> "Protocol",
			Widget -> Widget[Type -> Number, Pattern :> RangeP[2, 5, 1]]
		},

		(* --- Hidden Options --- *)
		{
			OptionName -> PreparedResources,
			Default -> {},
			AllowNull -> True,
			Widget -> Alternatives[
				Widget[
					Type -> Object,
					Pattern :> ListableP[ObjectP[Object[Resource,Sample]]],ObjectTypes->{Object[Resource,Sample]}
				],
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[{}]
				]
			],
			Description -> "Resources in the ParentProtocol that will be satisfied by preparation of the requested reference electrode models.",
			Category -> "Hidden"
		},
		SubprotocolDescriptionOption,
		PriorityOption,
		StartDateOption,
		HoldOrderOption,
		QueuePositionOption
	}
];

(* ======================== *)
(* ======= MESSAGES ======= *)
(* ======================== *)

Error::PREInputListsConflictingLength = "The input source reference electrode list `1` does not have the same length with the input target reference electrode model list `2`. Please make sure the source reference electrode list has the same length with the target reference electrode model list.";
Error::PREBlankModel = "The input target reference electrode models `1` do not have a Blank reference electrode model defined (look up the Blank field) and cannot be prepared by ExperimentPrepareReferenceElectrode. Please make sure only input reference electrode models that have a Blank defined as target reference electrode models.";
Error::PRENoReferenceElectrodeInContainer = "The input containers `1` do not have any reference electrodes stored in them. Please make sure to use containers that have at least one reference electrode as container inputs.";

Error::PREDuplicatedSourceReferenceElectrodes = "The input source reference electrode objects `1` are duplicated. Please do not use a reference electrode Object more than once as the source reference electrode input.";
Error::PREDiscardedSourceReferenceElectrodes = "The input source reference electrode objects `1` are discarded. Please swap them with available reference electrodes or use the models of the discarded reference electrodes as inputs.";
Error::PREDeprecatedReferenceElectrodeModels = "The input reference electrode models `1` are deprecated. Please only use non-deprecated reference electrode models as source or target reference electrode models. If there are input source reference electrode objects, please also these electrodes' models.";
Error::PREUnpreparableReferenceElectrodeModels = "The input target reference electrode models `1` are not preparable. Please check the Preparable field of these target reference electrode models. Only reference electrode models with Preparable -> True can be prepared by ExperimentPrepareReferenceElectrode.";
Error::PRETooManyTargetReferenceElectrodeModelInputs = "The number of reference electrode to be prepared (`1`) exceeds the capacity (`2`) of the experiment setup. Please decrease the number of input target reference electrode models or decrease the value of the NumberOfReplicates option.";

Error::PREMismatchingBlank = "The following input target reference electrode models `1` have a different Blank reference electrode model from their corresponding source reference electrodes. Please make sure the Blank model is identical for a pair of source and target reference electrode models.";
Error::PREReferenceElectrodeTypeSwitching = "The following input target reference electrode models `1` have a different reference electrode type from their corresponding source reference electrodes. Please make sure the reference electrode type is identical for a pair of source and target reference electrode models, unless the source electrode model is a Blank model.";
Warning::PREReferenceCouplingSampleSwitchingWarning = "The following input target reference electrode models `1` have a different reference coupling sample from their corresponding source reference electrodes. Please consider use a different source reference electrode model or object.";

Error::PRENonNullNumberOfReplicatesForReferenceElectrodeObject = "The NumberOfReplicates options is not Null for the following input source reference electrode objects `1`. Please do not use NumberOfReplicates option or set NumberOfReplicates option to Null when the input source reference electrodes list has at least one reference electrode object and not all models.";
Error::PRESourceReferenceElectrodeNeedsPolishing = "The following input source reference electrode objects `1` have rust observed on it non-working part (the part that does not directly contact experiment solution), while the PolishReferenceElectrode option is set to False. Please set the PolishReferenceElectrode option to True.";
Warning::PRESourceReferenceElectrodeWorkingPartRustWarning = "The following input source reference electrode objects `1` have rust observed on its working part (the part that directly contacts experiment solution) and should be discarded. Please consider use another reference electrode for the preparation and use the DiscardSamples function to discard the current reference electrode.";

Error::PRENonNullNumberOfPrimaryWashings = "The NumberOfPrimaryWashings options is specified while the PrimaryWashingSolution option is set to Null for the following input target reference electrode models `1`. Please set NumberOfPrimaryWashings option to Automatic or Null.";
Error::PREMissingNumberOfPrimaryWashings = "The NumberOfPrimaryWashings options is set to Null while the PrimaryWashingSolution option is specified for the following input target reference electrode models `1`. Please set NumberOfPrimaryWashings option to Automatic or to an integer.";
Error::PRESameWashingSolutions = "The PrimaryWashingSolution and SecondaryWashingSolution are identical for the following input target reference electrode models `1`. Please choose another sample for the SecondaryWashingSolution.";
Error::PREMissingPrimaryWashingSolution = "The SecondaryWashingSolution is specified while the PrimaryWashingSolution is set to Null for the following input target reference electrode models `1`. If only one type of washing solution is intended to be used, please set this solution to PrimaryWashingSolution.";
Error::PRENonNullNumberOfSecondaryWashings = "The NumberOfSecondaryWashings options is specified while the SecondaryWashingSolution option is set to Null for the following input target reference electrode models `1`. Please set NumberOfSecondaryWashings option to Automatic or Null.";
Error::PREMissingNumberOfSecondaryWashings = "The NumberOfSecondaryWashings options is set to Null while the SecondaryWashingSolution option is specified for the following input target reference electrode models `1`. Please set NumberOfSecondaryWashings option to Automatic or to an integer.";
Warning::PRENullPrimaryWashingSolutionWarning = "The PrimaryWashingSolution is set to Null for the following input target reference electrode models `1`. Please consider using a washing solution to wash the reference electrode before the priming step.";

Error::PRETooSmallPrimingVolume = "The PrimingVolume is set to a volume less than 3 Milliliter for the following input target reference electrode models `1`. Please set PrimingVolume to a volume greater than 1.5 Milliliter or twice of the target reference electrode model's SolutionVolume, whichever is larger.";
Error::PRETooSmallReferenceSolutionVolume = "The ReferenceSolutionVolume is set to a volume less than 95% of the reference electrode's SolutionVolume for the following input target reference electrode models `1`. Please set ReferenceSolutionVolume to a volume between 95% and 105% of the target reference electrode model's SolutionVolume.";
Error::PRETooLargeReferenceSolutionVolume = "The ReferenceSolutionVolume is set to a volume greater than 105% of the reference electrode's SolutionVolume for the following input target reference electrode models `1`. Please set ReferenceSolutionVolume to a volume between 95% and 105% of the target reference electrode model's SolutionVolume.";

Error::PREDisposalSamplesOutStorageCondition = "The SamplesOutStorageCondition is set to Disposal for the following input target reference electrode models `1`. Please set SamplesOutStorageCondition to Null or AmbientStorage.";
Error::PREIncompatibleSamplesOutStorageCondition = "The SamplesOutStorageCondition is set to a condition that is incompatible with the following input target reference electrode models `1`. Please set SamplesOutStorageCondition to Null or AmbientStorage.";

(* ::Subsubsection::Closed:: *)
(*ExperimentPrepareReferenceElectrode*)

(* == OVERLOAD 1: Take in target reference electrode models only == *)
(* Find out the Blanks of myTargetReferenceElectrodeModels and pass them to the CORE *)
(* We do not throw any messages or generate any tests in this overload. Leaving them in the CORE overload *)
ExperimentPrepareReferenceElectrode[
	myTargetReferenceElectrodeModels:ListableP[ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
	myOptions:OptionsPattern[ExperimentPrepareReferenceElectrode]
]:=Module[
	{
		blanks
	},

	(* We need to do a additional Download call in this overload to find the blanks *)
	blanks = Quiet[Download[myTargetReferenceElectrodeModels, Blank], {Download::ObjectDoesNotExist}] /. {$Failed -> Null, x : ObjectP[] :> Download[x, Object]};

	(* Call the CORE *)
	experimentPrepareReferenceElectrode[blanks, myTargetReferenceElectrodeModels, myOptions]
];

(* == OVERLOAD 2: Take in source target reference electrode objects/models and target reference electrode models == *)
ExperimentPrepareReferenceElectrode[
	mySourceReferenceElectrodes:ListableP[ObjectP[{Model[Item, Electrode, ReferenceElectrode], Object[Item, Electrode, ReferenceElectrode]}]],
	myTargetReferenceElectrodeModels:ListableP[ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
	myOptions:OptionsPattern[ExperimentPrepareReferenceElectrode]
]:=Module[{},

	(* Call the CORE *)
	experimentPrepareReferenceElectrode[mySourceReferenceElectrodes, myTargetReferenceElectrodeModels, myOptions]
];

(* == OVERLOAD 3: Take in a pair of {sourceElectrode, targetModel} == *)
ExperimentPrepareReferenceElectrode[
	myPair:{
		ObjectP[{Model[Item, Electrode, ReferenceElectrode], Object[Item, Electrode, ReferenceElectrode]}],
		ObjectP[Model[Item, Electrode, ReferenceElectrode]]
	},
	myOptions:OptionsPattern[ExperimentPrepareReferenceElectrode]
]:=Module[{mySourceReferenceElectrode, myTargetReferenceElectrodeModel},

	(* Get the source electrodes *)
	mySourceReferenceElectrode = First[myPair];

	(* Get the target electrode models *)
	myTargetReferenceElectrodeModel = Last[myPair];

	(* Call the OVERLOAD 4 *)
	ExperimentPrepareReferenceElectrode[{{mySourceReferenceElectrode, myTargetReferenceElectrodeModel}}, myOptions]
];

(* == OVERLOAD 4: Take in a list of {{sourceElectrode, targetModel}..} == *)
ExperimentPrepareReferenceElectrode[
	myPairedList:{{
		ObjectP[{Model[Item, Electrode, ReferenceElectrode], Object[Item, Electrode, ReferenceElectrode]}],
		ObjectP[Model[Item, Electrode, ReferenceElectrode]]
	}..},
	myOptions:OptionsPattern[ExperimentPrepareReferenceElectrode]
]:=Module[{mySourceReferenceElectrodes, myTargetReferenceElectrodeModels},

	(* Get the source electrodes *)
	mySourceReferenceElectrodes = myPairedList[[All, 1]];

	(* Get the target electrode models *)
	myTargetReferenceElectrodeModels = myPairedList[[All, 2]];

	(* Call the CORE *)
	experimentPrepareReferenceElectrode[mySourceReferenceElectrodes, myTargetReferenceElectrodeModels, myOptions]
];

(* == OVERLOAD 5: Container Overload for source reference electrode input list == *)
ExperimentPrepareReferenceElectrode[
	myContainers:ListableP[ObjectP[Object[Container]]],
	myTargetReferenceElectrodeModels:ListableP[ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
	myOptions:OptionsPattern[ExperimentPrepareReferenceElectrode]
]:=Module[
	{
		listedContainers, listedOptions, outputSpecification, output, gatherTests,
		containerContents, contentsReplaced, noReferenceElectrodeBool, containersWithoutReferenceElectrodesInvalidInputs, referenceElectrodeInContainerTests, referenceElectrodes
	},

	(* Make sure we're working with a list of containers *)
	listedContainers = ToList[myContainers];

	(* Make sure we're working with a list of options *)
	listedOptions = ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Download the contents of the listedContainers *)
	containerContents = Download[listedContainers, Contents[[All, 2]]] /. {x:ObjectP[] :> Download[x, Object]};

	(* Take out the reference electrodes form the containerContents *)
	contentsReplaced = Cases[#, ObjectP[Object[Item, Electrode, ReferenceElectrode]]]& /@ containerContents;

	(* Check if any level-2 lists are empty, which means the corresponding container doesn't have at least one reference electrode *)
	noReferenceElectrodeBool = Replace[contentsReplaced, {{} -> True, _ -> False}, 1];

	(* Get out the containers that do not have at least one reference electrode *)
	containersWithoutReferenceElectrodesInvalidInputs = PickList[listedContainers, noReferenceElectrodeBool, True];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[containersWithoutReferenceElectrodesInvalidInputs]>0&&!gatherTests,
		Message[Error::PRENoReferenceElectrodeInContainer, ToString[containersWithoutReferenceElectrodesInvalidInputs]];
		Message[Error::InvalidInput, ToString[containersWithoutReferenceElectrodesInvalidInputs]];
	];

	(* Build the tests *)
	referenceElectrodeInContainerTests = If[gatherTests,
		(* If we are gathering tests *)
		MapThread[
			Test["The input container " <> ToString[#1] <> " has at least one reference electrode.",
				#2,
				False
			]&,
			{listedContainers, noReferenceElectrodeBool}
		],

		(* If we are not gathering tests, set this to {} *)
		{}
	];

	(* If we are given a container that does not have at least one reference electrode, return early *)
	If[MemberQ[noReferenceElectrodeBool, True],

		outputSpecification/.{
			Result -> $Failed,
			Tests -> referenceElectrodeInContainerTests,
			Options -> $Failed,
			Preview -> Null
		},

		(* If the containers are fine, we gather the reference electrodes and pass them to the CORE *)
		referenceElectrodes = Flatten[contentsReplaced];
		experimentPrepareReferenceElectrode[referenceElectrodes, myTargetReferenceElectrodeModels, myOptions]
	]
];

(* == CORE: Take in source target reference electrode objects/models (which can be Null) and target reference electrode models == *)
experimentPrepareReferenceElectrode[
	mySourceReferenceElectrodes:ListableP[Alternatives[
		ObjectP[{Model[Item, Electrode, ReferenceElectrode], Object[Item, Electrode, ReferenceElectrode]}],
		Null
	]],
	myTargetReferenceElectrodeModels:ListableP[ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
	myOptions:OptionsPattern[ExperimentPrepareReferenceElectrode]
]:=Module[
	{
		(* Initialization *)
		listedSourceReferenceElectrodesNamed, listedTargetReferenceElectrodeModelsNamed,listedOptionsNamed,safeOptionsNamed,listedSourcesAndTargets, listedSourceReferenceElectrodes, listedTargetReferenceElectrodeModels, listedOptions, outputSpecification, output, gatherTests, messages, sameInputLengthsQ, sameInputLengthTests, unresolvedOptions, applyTemplateOptionTests, safeOptions, safeOptionTests, validLengths, validLengthTests, upload, confirm, canaryBranch, fastTrack, parentProt, inheritedCache, expandedSafeOptions,

		(* DatabaseMemberQ and BlankModel checks *)
		objectsFromOptions, userSpecifiedObjects, objectsExistQs, objectsExistTests, blankNotNullTests,

		(* Download *)
		storageConditionFieldNames, modelSampleFieldNames, moleculeFieldNames, solventAllFieldNames, referenceElectrodeFieldNames, referenceElectrodeObjectFieldNames, storageConditionFields, modelReferenceElectrodeFields, objectReferenceElectrodeFields, modelSampleFields, modelContainerFields, modelItemFields, resourceFields, referenceElectrodeModels, referenceElectrodeObjects, sampleModels, preparedResources, potentialContainerModels, potentialItemModels, cacheBall, preparedResourcesPackets,

		(* Resolve Options *)
		resolvedOptionsResult, resolvedOptions, resolvedOptionsTests, collapsedResolvedOptions,

		(* Resources and Protocol *)
		resourcePackets, resourcePacketTests, protocolObject
	},

	(* -------------------- *)
	(* -- Initialization -- *)
	(* -------------------- *)

	(* Make sure we're working with a list of mySourceReferenceElectrodes, myTargetReferenceElectrodeModels and options *)
	{{listedSourceReferenceElectrodesNamed, listedTargetReferenceElectrodeModelsNamed},listedOptionsNamed}=removeLinks[{ToList[mySourceReferenceElectrodes],ToList[myTargetReferenceElectrodeModels]},ToList[myOptions]];

	(* determine the requested return value; careful not to default this as it will throw error; it's Hidden, assume used correctly *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];
	messages = !gatherTests;

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptionsNamed,safeOptionTests}=If[gatherTests,
		SafeOptions[ExperimentPrepareReferenceElectrode,listedOptionsNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentPrepareReferenceElectrode,listedOptionsNamed,AutoCorrect->False],{}}
	];

	(*change all Names to objects *)
	(* important for the first variable here to be a signle one because it could return $Failed and we don't want a set error *)
	{listedSourcesAndTargets, safeOptions, listedOptions} = sanitizeInputs[{listedSourceReferenceElectrodesNamed, listedTargetReferenceElectrodeModelsNamed}, safeOptionsNamed, listedOptionsNamed];
	{listedSourceReferenceElectrodes, listedTargetReferenceElectrodeModels} = If[MatchQ[listedSourcesAndTargets, $Failed],
		{$Failed, $Failed},
		listedSourcesAndTargets
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[listedSourcesAndTargets,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> listedSourcesAndTargets,
			Options -> $Failed,
			Preview -> Null,
			RunTime -> 0 Minute
		}]
	];

	(* Check if the listedSourceReferenceElectrodes and listedTargetReferenceElectrodeModels are of the same length *)
	sameInputLengthsQ = MatchQ[Length[listedSourceReferenceElectrodes], Length[listedTargetReferenceElectrodeModels]];

	(* Build the tests for same length inputs *)
	sameInputLengthTests = If[gatherTests,
		(* If we are gathering tests *)
		{Test["The input source reference electrode list " <> ToString[listedSourceReferenceElectrodes] <> " and the input target reference electrode model list " <> ToString[listedTargetReferenceElectrodeModels] <> " have the same length.",
			sameInputLengthsQ,
			True
		]},

		(* If we are not gathering tests, set this to {} *)
		{}
	];

	(* If input lists are not of the same length, return failure *)
	If[MatchQ[sameInputLengthsQ, False],
		If[messages,
			Message[Error::PREInputListsConflictingLength, ToString[listedSourceReferenceElectrodes], ToString[listedTargetReferenceElectrodeModels]];
			Message[Error::InvalidInput, ToString[listedSourceReferenceElectrodes]]
		];

		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> sameInputLengthTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* set a local variable with the user-provided options in list form; make sure to gather tests from here *)
	{unresolvedOptions, applyTemplateOptionTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentPrepareReferenceElectrode, {listedTargetReferenceElectrodeModels}, listedOptions, 1, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentPrepareReferenceElectrode, {listedTargetReferenceElectrodeModels}, listedOptions, 1], {}}
	];

	(* If some hard error was encountered in getting template, return early with the requested output  *)
	If[MatchQ[unresolvedOptions, $Failed],
		Return[
			outputSpecification /. {
				Result -> $Failed,
				Tests -> Join[sameInputLengthTests, applyTemplateOptionTests],
				Preview -> Null,
				Options -> $Failed
			}
		]
	];


	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentPrepareReferenceElectrode, {listedTargetReferenceElectrodeModels}, safeOptions, 1,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentPrepareReferenceElectrode, {listedTargetReferenceElectrodeModels}, safeOptions, 1], Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[sameInputLengthTests, applyTemplateOptionTests, safeOptionTests, validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* get assorted hidden options *)
	{upload, confirm, canaryBranch, fastTrack, parentProt, inheritedCache} = Lookup[safeOptions, {Upload, Confirm, CanaryBranch, FastTrack, ParentProtocol, Cache}];

	(* Expand index-matching options *)
	expandedSafeOptions=Last[ExpandIndexMatchedInputs[ExperimentPrepareReferenceElectrode, {listedTargetReferenceElectrodeModels}, safeOptions, 1]];

	(* ---------------------------------------------------- *)
	(* -- Check for Objects that are not in the database -- *)
	(* ---------------------------------------------------- *)

	(* Get objects provided in options *)
	objectsFromOptions = Cases[Values[safeOptions], ObjectP[]];

	(* Extract any objects that the user has explicitly specified *)
	userSpecifiedObjects = DeleteDuplicates@Cases[
		Flatten[{listedSourceReferenceElectrodes, listedTargetReferenceElectrodeModels, objectsFromOptions}],
		ObjectP[]
	];

	(* Check if the userSpecifiedObjects exist *)
	objectsExistQs = DatabaseMemberQ[userSpecifiedObjects];

	(* Build tests for object existence *)
	objectsExistTests = If[gatherTests,
		MapThread[
			Test[StringTemplate["Specified object `1` exists in the database:"][#1],#2,True]&,
			{userSpecifiedObjects, objectsExistQs}
		],
		{}
	];

	(* If objects do not exist, return failure *)
	If[!(And@@objectsExistQs),
		If[!gatherTests,
			Message[Error::ObjectDoesNotExist,PickList[userSpecifiedObjects ,objectsExistQs, False]];
			Message[Error::InvalidInput,PickList[userSpecifiedObjects, objectsExistQs, False]]
		];

		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[sameInputLengthTests, applyTemplateOptionTests, safeOptionTests, validLengthTests, objectsExistTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* ----------------------------------------------------- *)
	(* -- Check if any source reference electrode is Null -- *)
	(* ----------------------------------------------------- *)
	(* Build tests for blank being not Null: if a targetReferenceElectrodeModel does not have a blank, itself is a blank model, which can't be prepared. *)
	blankNotNullTests = If[gatherTests,
		MapThread[
			Test[
				StringTemplate["Specified target reference electrode model `1` has a Blank defined:"][#1],
				#2,
				ObjectP[Model[Item, Electrode, ReferenceElectrode]]
			]&,
			{listedTargetReferenceElectrodeModels, listedSourceReferenceElectrodes}
		],
		{}
	];

	(* If any Blank is Null, return failure early *)
	If[MemberQ[listedSourceReferenceElectrodes, Null],
		If[messages,
			Message[Error::PREBlankModel,PickList[listedTargetReferenceElectrodeModels, listedSourceReferenceElectrodes, Null]];
			Message[Error::InvalidInput,PickList[listedTargetReferenceElectrodeModels, listedSourceReferenceElectrodes, Null]]
		];

		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[
				sameInputLengthTests,
				applyTemplateOptionTests,
				safeOptionTests,
				validLengthTests,
				objectsExistTests,
				blankNotNullTests
			],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* -------------- *)
	(* -- Download -- *)
	(* -------------- *)

	(* Download fields preparation *)
	storageConditionFieldNames = {Name, StorageCondition};

	modelSampleFieldNames = Join[SamplePreparationCacheFields[Model[Sample]], {DefaultStorageCondition, IncompatibleMaterials}];

	moleculeFieldNames = {Name, DefaultSampleModel, MolecularWeight};

	(* solvent fields are just model sample fields *)
	solventAllFieldNames = modelSampleFieldNames;

	referenceElectrodeFieldNames = {Name, Deprecated, Preparable, ReferenceElectrodeType, Blank, RecommendedSolventType, ReferenceSolution, ReferenceCouplingSample, SolutionVolume, RecommendedRefreshPeriod, Dimensions, DefaultStorageCondition, BulkMaterial, CoatMaterial, ElectrodeShape, ElectrodePackagingMaterial, WiringConnectors, WiringDiameters, WiringLength, MaxNumberOfUses, MinPotential, MaxPotential, MaxNumberOfPolishings, SonicationSensitive, WettedMaterials, IncompatibleMaterials};

	referenceElectrodeObjectFieldNames = {Name, Model, Status, RustCheckingLog, NumberOfUses, NumberOfPolishings, CurrentSolutionVolume, ReferenceElectrodeTypeLog, RefreshLog, WiringConnectors, WiringDiameters, WiringLength, RequestedResources};

	storageConditionFields = {
		Packet[Sequence@@storageConditionFieldNames];
	};

	modelReferenceElectrodeFields = {
		Packet[Sequence@@referenceElectrodeFieldNames],
		Packet[Blank[referenceElectrodeFieldNames]],
		Packet[DefaultStorageCondition[storageConditionFieldNames]],

		(* ReferenceSolution *)
		Packet[ReferenceSolution[modelSampleFieldNames]],
		Packet[ReferenceSolution[Analytes][moleculeFieldNames]],
		Packet[ReferenceSolution[Field[Composition[[All, 2]]]][moleculeFieldNames]],
		Packet[ReferenceSolution[Field[Solvent]][solventAllFieldNames]],

		(* ReferenceCouplingSample *)
		Packet[ReferenceCouplingSample[modelSampleFieldNames]],
		Packet[ReferenceCouplingSample[Analytes][moleculeFieldNames]],
		Packet[ReferenceCouplingSample[Field[Composition[[All, 2]]]][moleculeFieldNames]],
		Packet[ReferenceCouplingSample[Field[Solvent]][solventAllFieldNames]]
	};

	objectReferenceElectrodeFields = {
		Packet[Sequence@@referenceElectrodeObjectFieldNames],
		Packet[Model[referenceElectrodeFieldNames]],
		Packet[Model[Blank][referenceElectrodeFieldNames]],
		Packet[Model[DefaultStorageCondition][storageConditionFieldNames]],

		(* ReferenceSolution *)
		Packet[Model[ReferenceSolution][modelSampleFieldNames]],
		Packet[Model[ReferenceSolution][Analytes][moleculeFieldNames]],
		Packet[Model[ReferenceSolution][Field[Composition[[All, 2]]]][moleculeFieldNames]],
		Packet[Model[ReferenceSolution][Field[Solvent]][solventAllFieldNames]],

		(* ReferenceCouplingSample *)
		Packet[Model[ReferenceCouplingSample][modelSampleFieldNames]],
		Packet[Model[ReferenceCouplingSample][Analytes][moleculeFieldNames]],
		Packet[Model[ReferenceCouplingSample][Field[Composition[[All, 2]]]][moleculeFieldNames]],
		Packet[Model[ReferenceCouplingSample][Field[Solvent]][solventAllFieldNames]]
	};

	modelSampleFields = {
		Packet[Sequence@@modelSampleFieldNames],
		Packet[Analytes[moleculeFieldNames]],
		Packet[Field[Composition[[All, 2]]][moleculeFieldNames]],
		Packet[Field[Solvent][solventAllFieldNames]]
	};

	modelContainerFields = {
		Packet[Name, MaxVolume, ConnectionType, Dimensions]
	};

	modelItemFields = {
		Packet[Name, NeedleLength, ConnectionType, Grit]
	};

	resourceFields = {
		Packet[RentContainer]
	};

	(* -- Identify downloading objects -- *)
	referenceElectrodeModels = Cases[userSpecifiedObjects, ObjectP[Model[Item, Electrode, ReferenceElectrode]]];
	referenceElectrodeObjects = Cases[userSpecifiedObjects, ObjectP[Object[Item, Electrode, ReferenceElectrode]]];
	sampleModels = Cases[userSpecifiedObjects, ObjectP[Model[Sample]]];

	(* get preparedResources from safeOptions *)
	preparedResources = ToList[Lookup[safeOptions, PreparedResources]];

	(* Potential containers *)
	potentialContainerModels = Join[
		PreferredContainer[All],

		(* Potential syringe types *)
		TransferDevices[Model[Container, Syringe], 1 Milliliter][[All, 1]]
	];
	(* Potential Items *)
	potentialItemModels = Join[
		{
			(* Sandpaper models *)
			Model[Item,Consumable,Sandpaper,"3M 1200 Grit Sandpaper"]
		}
	];

	(* Download call *)
	cacheBall = Quiet[
		FlattenCachePackets[
			{
				inheritedCache,
				Download[
					{
						referenceElectrodeModels,
						referenceElectrodeObjects,
						sampleModels,
						potentialContainerModels,
						potentialItemModels,
						preparedResources
					},
					{
						modelReferenceElectrodeFields,
						objectReferenceElectrodeFields,
						modelSampleFields,
						modelContainerFields,
						modelItemFields,
						resourceFields
					},
					Cache -> inheritedCache,
					Date -> Now
				]
			}
		],
		{Download::FieldDoesntExist,Download::NotLinkField}
	];

	(* Retrieve the preparedResourcesPackets. This is used for the resource packets *)
	preparedResourcesPackets = Cases[cacheBall, PacketP[Object[Resource, Sample]]];

	(* -------------------------- *)
	(* --- RESOLVE THE OPTIONS ---*)
	(* -------------------------- *)

	(* Build the resolved options *)
	resolvedOptionsResult = If[gatherTests,

		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentPrepareReferenceElectrodeOptions[listedSourceReferenceElectrodes, listedTargetReferenceElectrodeModels, expandedSafeOptions, Cache->cacheBall,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentPrepareReferenceElectrodeOptions[listedSourceReferenceElectrodes, listedTargetReferenceElectrodeModels, expandedSafeOptions, Cache->cacheBall],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* ---------------------------- *)
	(* -- PREPARE OPTIONS OUTPUT -- *)
	(* ---------------------------- *)

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentPrepareReferenceElectrode,
		resolvedOptions,
		Ignore->listedOptions,
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[
				sameInputLengthTests,
				applyTemplateOptionTests,
				safeOptionTests,
				validLengthTests,
				objectsExistTests,
				blankNotNullTests,
				resolvedOptionsTests
			],
			Options->RemoveHiddenOptions[ExperimentPrepareReferenceElectrode,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* ---------------------------- *)
	(* Build packets with resources *)
	(* ---------------------------- *)

	{resourcePackets,resourcePacketTests} = If[gatherTests,
		prepareReferenceElectrodeResourcePackets[
			listedSourceReferenceElectrodes,
			listedTargetReferenceElectrodeModels,
			preparedResourcesPackets,
			expandedSafeOptions,
			resolvedOptions,
			collapsedResolvedOptions,
			Cache -> cacheBall,
			Output -> {Result,Tests}
		],
		{prepareReferenceElectrodeResourcePackets[
			listedSourceReferenceElectrodes,
			listedTargetReferenceElectrodeModels,
			preparedResourcesPackets,
			expandedSafeOptions,
			resolvedOptions,
			collapsedResolvedOptions,
			Cache -> cacheBall
		], {}}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests->Flatten[{
				sameInputLengthTests,
				applyTemplateOptionTests,
				safeOptionTests,
				validLengthTests,
				objectsExistTests,
				blankNotNullTests,
				resolvedOptionsTests,
				resourcePacketTests
			}],
			Options -> RemoveHiddenOptions[ExperimentPrepareReferenceElectrode,collapsedResolvedOptions],
			Preview -> Null
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = If[!MatchQ[resourcePackets,$Failed]&&!MatchQ[resolvedOptionsResult,$Failed],
		UploadProtocol[
			resourcePackets,
			Upload->Lookup[safeOptions,Upload],
			Confirm->Lookup[safeOptions,Confirm],
			CanaryBranch->Lookup[safeOptions,CanaryBranch],
			ParentProtocol->Lookup[safeOptions,ParentProtocol],
			Priority->Lookup[safeOptions,Priority],
			StartDate->Lookup[safeOptions,StartDate],
			HoldOrder->Lookup[safeOptions,HoldOrder],
			QueuePosition->Lookup[safeOptions,QueuePosition],
			ConstellationMessage->Object[Protocol,PrepareReferenceElectrode],
			Cache -> cacheBall
		],
		$Failed
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{
			sameInputLengthTests,
			applyTemplateOptionTests,
			safeOptionTests,
			validLengthTests,
			objectsExistTests,
			blankNotNullTests,
			resolvedOptionsTests,
			resourcePacketTests
		}],
		Options -> RemoveHiddenOptions[ExperimentPrepareReferenceElectrode,collapsedResolvedOptions],
		Preview -> Null
	}
];

(* resolveExperimentPrepareReferenceElectrodeOptions *)

(* ---------------------- *)
(* -- OPTIONS RESOLVER -- *)
(* ---------------------- *)

DefineOptions[
	resolveExperimentPrepareReferenceElectrodeOptions,
	Options:>{HelperOutputOption,CacheOption}
];

resolveExperimentPrepareReferenceElectrodeOptions[
	mySourceReferenceElectrodes:{ObjectP[{Model[Item, Electrode, ReferenceElectrode], Object[Item, Electrode, ReferenceElectrode]}]...},
	myTargetReferenceElectrodeModels:{ObjectP[Model[Item, Electrode, ReferenceElectrode]]...},
	myOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[resolveExperimentPrepareReferenceElectrodeOptions]
]:=Module[
	{
		(* == Initialization == *)
		outputSpecification, output, gatherTests, messages, inheritedCache, optionsAssociation,

		(* == Invalid input checks == *)
		sourceReferenceElectrodePackets, sourceReferenceElectrodeObjects, sourceReferenceElectrodeObjectPackets, sourceReferenceElectrodeObjectModels, sourceReferenceElectrodeObjectModelPackets, sourceReferenceElectrodeModels, sourceReferenceElectrodeModelPackets, targetReferenceElectrodeModelPackets, inputReferenceElectrodeModels, inputReferenceElectrodeModelPackets,

		referenceElectrodeTally, tallyElectrodeNames, tallyElectrodeCounts, duplicatedElectrodeNames, duplicatedReferenceElectrodeInvalidInputs, duplicatedReferenceElectrodeTests,
		discardedReferenceElectrodePackets, discardedReferenceElectrodeInvalidInputs, discardedReferenceElectrodeTests,
		deprecatedReferenceElectrodeModelPackets, deprecatedReferenceElectrodeModelInvalidInputs, deprecatedReferenceElectrodeModelTests,
		unpreparableReferenceElectrodeModelPackets, unpreparableReferenceElectrodeModelInvalidInputs, unpreparableReferenceElectrodeModelTests,

		(* == Rounding == *)
		optionPrecisions, roundedOptions, precisionTests,

		(* == MapThread == *)
		mapThreadFriendlyOptions, resolvedMapThreadOptionsAssociations, mapThreadErrorCheckingAssociations,  mapThreadWarningCheckingAssociations, resolvedOptionsAssociation, mapThreadErrorCheckingAssociation, mapThreadWarningCheckingAssociation,

		(* == MapThread errors, warnings == *)
		targetModelPacketsWithMismatchingBlank,
		targetModelPacketsWithReferenceElectrodeTypeSwitching,
		targetModelPacketsWithReferenceCouplingSampleSwitchingWarning,

		sourceElectrodePacketsWithNonNullNumberOfReplicatesForReferenceElectrodeObject,
		sourceElectrodePacketsWithSourceReferenceElectrodeNeedsPolishing,
		sourceElectrodePacketsWithSourceReferenceElectrodeWorkingPartRustWarning,

		targetModelPacketsWithNonNullNumberOfPrimaryWashings,
		targetModelPacketsWithMissingNumberOfPrimaryWashings,
		targetModelPacketsWithSameWashingSolutions,
		targetModelPacketsWithMissingPrimaryWashingSolution,
		targetModelPacketsWithNonNullNumberOfSecondaryWashings,
		targetModelPacketsWithMissingNumberOfSecondaryWashings,
		targetModelPacketsWithNullPrimaryWashingSolutionWarning,

		targetModelPacketsWithTooSmallPrimingVolume,
		targetModelPacketsWithTooSmallReferenceSolutionVolume,
		targetModelPacketsWithTooLargeReferenceSolutionVolume,

		targetModelPacketsWithDisposalSamplesOutStorageCondition,
		targetModelPacketsWithIncompatibleSamplesOutStorageCondition,

		(* == Mapthread tests == *)
		mismatchingBlankTests,
		referenceElectrodeTypeSwitchingTests,
		referenceCouplingSampleSwitchingWarningTests,

		nonNullNumberOfReplicatesForReferenceElectrodeObjectTests,
		sourceReferenceElectrodeNeedsPolishingTests,
		sourceReferenceElectrodeWorkingPartRustWarningTests,

		nonNullNumberOfPrimaryWashingsTests,
		missingNumberOfPrimaryWashingsTests,
		sameWashingSolutionsTests,
		missingPrimaryWashingSolutionTests,
		nonNullNumberOfSecondaryWashingsTests,
		missingNumberOfSecondaryWashingsTests,
		nullPrimaryWashingSolutionWarningTests,

		tooSmallPrimingVolumeTests,
		tooSmallReferenceSolutionVolumeTests,
		tooLargeReferenceSolutionVolumeTests,

		disposalSamplesOutStorageConditionTests,
		incompatibleSamplesOutStorageConditionTests,

		(* == Mapthread invalidInputs == *)
		compatibilityInvalidInputs,

		(* == Mapthread invalidOptions == *)
		numberOfReplicatesInvalidOptions,
		polishReferenceElectrodeInvalidOptions,
		numberOfPrimaryWashingsInvalidOptions,
		washingSolutionsInvalidOptions,
		numberOfSecondaryWashingsInvalidOptions,
		primingVolumeInvalidOptions,
		referenceSolutionVolumeInvalidOptions,
		samplesOutStorageConditionInvalidOptions,

		(* == Non-MapThread error checking == *)
		maxNumberOfReferenceElectrodes, numberOfTargetReferenceElectrodeModels, numberOfReplicatesNumber, tooManyInputQ, tooManyInputsList, tooManySamplesTests,

		(* == Outputs == *)
		resolvedPostProcessingOptions, invalidInputs, invalidOptions, prepareReferenceElectrodeTests, resolvedOptions
	},

	(* ------------------------------------------------ *)
	(* -- SETUP OUR USER SPECIFIED OPTIONS AND CACHE -- *)
	(* ------------------------------------------------ *)

	(* Determine the requested output format of this function. *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = !gatherTests;

	(* Fetch our cache from the parent function. *)
	inheritedCache = Lookup[ToList[myResolutionOptions], Cache, {}];

	optionsAssociation = Association[myOptions];

	(* ----------------------------- *)
	(* -- INPUT VALIDATION CHECKS -- *)
	(* ----------------------------- *)

	(* Fetch the packets of all the input source reference electrode objects or models *)
	sourceReferenceElectrodePackets = fetchPacketFromCache[#, inheritedCache]& /@ mySourceReferenceElectrodes;

	(* Fetch the packets of all the input target reference electrode models *)
	targetReferenceElectrodeModelPackets = fetchPacketFromCache[#, inheritedCache]& /@ myTargetReferenceElectrodeModels;

	(* Identify the input source reference electrode objects and their packets  *)
	sourceReferenceElectrodeObjects = Cases[mySourceReferenceElectrodes, ObjectP[Object[Item, Electrode, ReferenceElectrode]]] /. {x:ObjectP[] :> Download[x, Object]};
	sourceReferenceElectrodeObjectPackets = fetchPacketFromCache[#, inheritedCache]& /@ sourceReferenceElectrodeObjects;

	(* Identify the models of input source reference electrode objects and their packets  *)
	sourceReferenceElectrodeObjectModels = Lookup[sourceReferenceElectrodeObjectPackets, Model, {}] /. {x:ObjectP[] :> Download[x, Object]};
	sourceReferenceElectrodeObjectModelPackets = fetchPacketFromCache[#, inheritedCache]& /@ sourceReferenceElectrodeObjectModels;

	(* Identify the input source reference electrode models and their packets  *)
	sourceReferenceElectrodeModels = Cases[mySourceReferenceElectrodes, ObjectP[Model[Item, Electrode, ReferenceElectrode]]] /. {x:ObjectP[] :> Download[x, Object]};
	sourceReferenceElectrodeModelPackets = fetchPacketFromCache[#, inheritedCache]& /@ sourceReferenceElectrodeModels;

	(* Get all input reference electrode models *)
	inputReferenceElectrodeModels = DeleteDuplicates[Join[myTargetReferenceElectrodeModels, sourceReferenceElectrodeObjectModels, sourceReferenceElectrodeModels]] /. {x:ObjectP[] :> Download[x, Object]};
	inputReferenceElectrodeModelPackets = fetchPacketFromCache[#, inheritedCache]& /@ inputReferenceElectrodeModels;

	(* --- 0. Check if any two of the input source reference electrode Objects are the same (we can't prepare the same reference electrode more than once) --- *)
	referenceElectrodeTally = Tally[sourceReferenceElectrodeObjects];

	(* Get the tallyElectrodeNames and tallyElectrodeCounts if referenceElectrodeTally is not an empty list *)
	{tallyElectrodeNames, tallyElectrodeCounts} = If[!MatchQ[referenceElectrodeTally, {}],
		{referenceElectrodeTally[[All, 1]], referenceElectrodeTally[[All, 2]]},
		{{}, {}}
	];

	(* Get the tallyElectrodeNames that have a count higher than 1 *)
	duplicatedElectrodeNames = If[
		And[
			!MatchQ[tallyElectrodeNames, {}],
			!MatchQ[tallyElectrodeCounts, {}]
		],
		PickList[tallyElectrodeNames, tallyElectrodeCounts, GreaterP[1]],
		{}
	];

	(* Set duplicatedReferenceElectrodeInvalidInputs to the input source reference electrode objects that are duplicated *)
	duplicatedReferenceElectrodeInvalidInputs = If[!MatchQ[duplicatedElectrodeNames, {}],
		duplicatedElectrodeNames,
		{}
	];

	(* If there are duplicated input source reference electrode objects and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[duplicatedReferenceElectrodeInvalidInputs] > 0 && !gatherTests,
		Message[Error::PREDuplicatedSourceReferenceElectrodes, ObjectToString[duplicatedReferenceElectrodeInvalidInputs, Cache->inheritedCache]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	duplicatedReferenceElectrodeTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[MatchQ[Length[duplicatedReferenceElectrodeInvalidInputs],0],
				Nothing,
				Test["The input source reference electrode objects "<>ObjectToString[duplicatedReferenceElectrodeInvalidInputs, Cache->inheritedCache]<>" are not duplicated:",True,False]
			];

			passingTest = If[MatchQ[Length[duplicatedReferenceElectrodeInvalidInputs], Length[sourceReferenceElectrodeObjects]],
				Nothing,
				Test["The input source reference electrode objects "<>ObjectToString[Complement[sourceReferenceElectrodeObjects,duplicatedReferenceElectrodeInvalidInputs],Cache->inheritedCache]<>" are not duplicated:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* --- 1. Check if any of the input source reference electrodes is discarded --- *)
	(* Get the input reference electrodes that are discarded *)
	discardedReferenceElectrodePackets = Cases[sourceReferenceElectrodeObjectPackets, KeyValuePattern[Status -> Discarded]];

	(* Set discardedReferenceElectrodeInvalidInputs to the input source reference electrode objects whose statuses are Discarded *)
	discardedReferenceElectrodeInvalidInputs = If[MatchQ[discardedReferenceElectrodePackets,{}],
		{},
		Lookup[discardedReferenceElectrodePackets,Object]
	];

	(* If there are discarded input source reference electrode objects and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedReferenceElectrodeInvalidInputs] > 0 && !gatherTests,
		Message[Error::PREDiscardedSourceReferenceElectrodes, ObjectToString[discardedReferenceElectrodeInvalidInputs, Cache->inheritedCache]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedReferenceElectrodeTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[MatchQ[Length[discardedReferenceElectrodeInvalidInputs],0],
				Nothing,
				Test["The input source reference electrode objects "<>ObjectToString[discardedReferenceElectrodeInvalidInputs, Cache->inheritedCache]<>" are not discarded:",True,False]
			];

			passingTest = If[MatchQ[Length[discardedReferenceElectrodeInvalidInputs], Length[sourceReferenceElectrodeObjects]],
				Nothing,
				Test["The input source reference electrode objects "<>ObjectToString[Complement[sourceReferenceElectrodeObjects,discardedReferenceElectrodeInvalidInputs],Cache->inheritedCache]<>" are not discarded:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* --- 2. Check if any of the input reference electrode models (also the models of input source electrodes) is deprecated --- *)
	(* Get the input reference electrode models that are deprecated *)
	deprecatedReferenceElectrodeModelPackets = Cases[inputReferenceElectrodeModelPackets, KeyValuePattern[Deprecated -> True]];

	(* Set deprecatedReferenceElectrodeModelInvalidInputs to the input reference electrode models whose Deprecated fields are True *)
	deprecatedReferenceElectrodeModelInvalidInputs = If[MatchQ[deprecatedReferenceElectrodeModelPackets,{}],
		{},
		Lookup[deprecatedReferenceElectrodeModelPackets,Object]
	];

	(* If there are deprecated input reference electrode models and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[deprecatedReferenceElectrodeModelInvalidInputs] > 0 && !gatherTests,
		Message[Error::PREDeprecatedReferenceElectrodeModels, ObjectToString[deprecatedReferenceElectrodeModelInvalidInputs, Cache->inheritedCache]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	deprecatedReferenceElectrodeModelTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[MatchQ[Length[deprecatedReferenceElectrodeModelInvalidInputs],0],
				Nothing,
				Test["The input reference electrode models "<>ObjectToString[deprecatedReferenceElectrodeModelInvalidInputs, Cache->inheritedCache]<>" are not deprecated:",True,False]
			];

			passingTest = If[MatchQ[Length[deprecatedReferenceElectrodeModelInvalidInputs], Length[inputReferenceElectrodeModels]],
				Nothing,
				Test["The input reference electrode models "<>ObjectToString[Complement[inputReferenceElectrodeModels,deprecatedReferenceElectrodeModelInvalidInputs],Cache->inheritedCache]<>" are not deprecated:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* --- 3. Check if any of the input target reference electrode models is un-preparable --- *)
	(* Get the input target reference electrode models that are unpreparable *)
	unpreparableReferenceElectrodeModelPackets = Cases[targetReferenceElectrodeModelPackets, KeyValuePattern[Preparable -> Alternatives[False, Null]]];

	(* Set unpreparableReferenceElectrodeModelInvalidInputs to the input target reference electrode models whose Preparable fields are not True *)
	unpreparableReferenceElectrodeModelInvalidInputs = If[MatchQ[unpreparableReferenceElectrodeModelPackets,{}],
		{},
		Lookup[unpreparableReferenceElectrodeModelPackets, Object]
	];

	(* If there are unpreparable input target reference electrode models and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[unpreparableReferenceElectrodeModelInvalidInputs] > 0 && !gatherTests,
		Message[Error::PREUnpreparableReferenceElectrodeModels, ObjectToString[unpreparableReferenceElectrodeModelInvalidInputs, Cache->inheritedCache]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	unpreparableReferenceElectrodeModelTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[MatchQ[Length[unpreparableReferenceElectrodeModelInvalidInputs],0],
				Nothing,
				Test["The input target reference electrode models "<>ObjectToString[unpreparableReferenceElectrodeModelInvalidInputs, Cache->inheritedCache]<>" are preparable:",True,False]
			];

			passingTest = If[MatchQ[Length[unpreparableReferenceElectrodeModelInvalidInputs], Length[targetReferenceElectrodeModelPackets]],
				Nothing,
				Test["The input reference electrode models "<>ObjectToString[Complement[targetReferenceElectrodeModelPackets,unpreparableReferenceElectrodeModelInvalidInputs],Cache->inheritedCache]<>" are preparable:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* -------------- *)
	(* -- ROUNDING -- *)
	(* -------------- *)

	(* gather option precisions *)
	optionPrecisions = {
		{PrimingVolume, 10^0 * Milliliter},
		{ReferenceSolutionVolume, 10^-1 * Milliliter}
	};

	(* big round call on the joined lists of all roundable options *)
	{
		roundedOptions,
		precisionTests
	} = If[gatherTests,
		RoundOptionPrecision[optionsAssociation, optionPrecisions[[All,1]], optionPrecisions[[All,2]], Output -> {Result, Tests}],
		{
			RoundOptionPrecision[optionsAssociation,  optionPrecisions[[All,1]], optionPrecisions[[All,2]]],
			{}
		}
	];

	(* =============== *)
	(* == MAPTHREAD == *)
	(* =============== *)

	(*MapThreadFriendlyOptions have the Key value pairs expanded to index match, such that if you call Lookup[options, OptionName], it gives the Option value at the index we are interested in*)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentPrepareReferenceElectrode, roundedOptions];

	(* The output will be an association of the form <| OptionName -> resolvedOptionValue |> so that it is easy to look up at the end *)
	(* Same with error trackers and warning trackers *)
	{
		resolvedMapThreadOptionsAssociations,
		mapThreadErrorCheckingAssociations,
		mapThreadWarningCheckingAssociations
	} = Transpose[
		MapThread[
			Function[{options, sourceElectrode, sourceElectrodePacket, targetElectrodeModel, targetElectrodeModelPacket},
				Module[
					{
						(* == Options look-ups == *)
						polishReferenceElectrode, primaryWashingSolution, numberOfPrimaryWashings, secondaryWashingSolution, numberOfSecondaryWashings, numberOfPrimings, primingVolume, primingSoakTime, referenceSolutionVolume, numberOfReplicates, samplesOutStorageCondition,

						(* == Option associations == *)
						resolvedWashingOptionsAssociation, resolvedVolumeOptionsAssociation, resolvedSamplesOutStorageConditionOptionsAssociation,

						(* == Error associations == *)
						compatibilityErrorTrackerAssociation, sourceElectrodeOptionsErrorTrackerAssociation, washingOptionsErrorTrackerAssociation, volumeOptionsErrorTrackerAssociation, samplesOutStorageConditionOptionsErrorTrackerAssociation,

						(* == Warning associations == *)
						compatibilityWarningTrackerAssociation, sourceElectrodeOptionsWarningTrackerAssociation, washingOptionsWarningTrackerAssociation,

						(* == Outputs == *)
						resolvedOptionsAssociation, errorTrackersAssociation, warningTrackersAssociation
					},

					(* ------------------------------- *)
					(* -- LOOKUP UNRESOLVED OPTIONS -- *)
					(* ------------------------------- *)

					(* Since we do not have too many options, just look all of them up in one go *)
					{
						polishReferenceElectrode,
						primaryWashingSolution,
						numberOfPrimaryWashings,
						secondaryWashingSolution,
						numberOfSecondaryWashings,
						numberOfPrimings,
						primingVolume,
						primingSoakTime,
						referenceSolutionVolume,
						numberOfReplicates,
						samplesOutStorageCondition
					} = Lookup[options,
						{
							PolishReferenceElectrode,
							PrimaryWashingSolution,
							NumberOfPrimaryWashings,
							SecondaryWashingSolution,
							NumberOfSecondaryWashings,
							NumberOfPrimings,
							PrimingVolume,
							PrimingSoakTime,
							ReferenceSolutionVolume,
							NumberOfReplicates,
							SamplesOutStorageCondition
						}
					];

					(* ------------------------------------------------------------------- *)
					(* -- sourceElectrode and targetElectrodeModel Compatibility checks -- *)
					(* ------------------------------------------------------------------- *)

					{compatibilityErrorTrackerAssociation, compatibilityWarningTrackerAssociation} = Module[
						{
							(* Variables *)
							targetElectrodeModelBlankModel, sourceElectrodeModel, sourceElectrodeBlankModel, sourceElectrodeIsBlank, sourceElectrodeType, targetElectrodeType, sourceElectrodeReferenceCouplingSample, targetElectrodeReferenceCouplingSample,

							(* Error booleans *)
							mismatchingBlankBool, referenceElectrodeTypeSwitchingBool,

							(* Warning booleans *)
							referenceCouplingSampleSwitchingWarningBool
						},

						(* == targetElectrodeModel Blank existence check == *)
						targetElectrodeModelBlankModel = Lookup[targetElectrodeModelPacket, Blank] /. {x:ObjectP[] :> Download[x, Object]};

						(* == Check if the model of the sourceElectrode and the targetElectrodeModel are not identical == *)
						sourceElectrodeModel = If[MatchQ[sourceElectrode, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],

							(* If the sourceElectrode is a model itself, return directly *)
							sourceElectrode,

							(* Otherwise, find the model from the sourceElectrodePacket *)
							Lookup[sourceElectrodePacket, Model]
						] /. {x:ObjectP[] :> Download[x, Object]};

						(* == Check if the Blank are the same between the sourceElectrode and the targetElectrodeModel == *)
						sourceElectrodeBlankModel = If[
							MatchQ[Lookup[fetchPacketFromCache[sourceElectrodeModel, inheritedCache], Blank], Null],

							(* If the sourceElectrodeModel is a Blank, return sourceElectrodeModel directly *)
							sourceElectrodeIsBlank = True;
							sourceElectrodeModel,

							(* If the sourceElectrodeModel is not a Blank, return the Blank *)
							sourceElectrodeIsBlank = False;
							Lookup[fetchPacketFromCache[sourceElectrodeModel, inheritedCache], Blank]
						] /. {x:ObjectP[] :> Download[x, Object]};

						(* set up the error checking boolean *)
						mismatchingBlankBool = If[
							!MatchQ[sourceElectrodeBlankModel, targetElectrodeModelBlankModel],
							True,
							False
						];

						(* == If the sourceElectrode is not a Blank model, check if the ReferenceElectrodeType are the same between the sourceElectrode and the targetElectrodeModel == *)
						(* Get the ReferenceElectrodeTypes *)
						sourceElectrodeType = Lookup[fetchPacketFromCache[sourceElectrodeModel, inheritedCache], ReferenceElectrodeType];
						targetElectrodeType = Lookup[targetElectrodeModelPacket, ReferenceElectrodeType];

						(* set up the error checking boolean *)
						referenceElectrodeTypeSwitchingBool = If[
							And[
								MatchQ[sourceElectrodeIsBlank, False],
								!MatchQ[sourceElectrodeType, targetElectrodeType]
							],
							True,
							False
						];

						(* == If the sourceElectrode is not a Blank model, check if the ReferenceCouplingSample are the same between the sourceElectrode and the targetElectrodeModel == *)
						(* Get the ReferenceCouplingSamples *)
						sourceElectrodeReferenceCouplingSample = Lookup[fetchPacketFromCache[sourceElectrodeModel, inheritedCache], ReferenceCouplingSample] /. {x:ObjectP[] :> Download[x, Object]};
						targetElectrodeReferenceCouplingSample = Lookup[targetElectrodeModelPacket, ReferenceCouplingSample] /. {x:ObjectP[] :> Download[x, Object]};

						(* set up the warning checking boolean *)
						referenceCouplingSampleSwitchingWarningBool = If[
							And[
								MatchQ[sourceElectrodeIsBlank, False],
								MatchQ[referenceElectrodeTypeSwitchingBool, False],
								!MatchQ[sourceElectrodeReferenceCouplingSample, targetElectrodeReferenceCouplingSample]
							],
							True,
							False
						];

						(* Return the results *)
						{
							(* Errors *)
							Association[
								MismatchingBlankBool -> mismatchingBlankBool,
								ReferenceElectrodeTypeSwitchingBool -> referenceElectrodeTypeSwitchingBool
							],

							(* Warnings *)
							Association[
								ReferenceCouplingSampleSwitchingWarningBool -> referenceCouplingSampleSwitchingWarningBool
							]
						}
					];

					(* ------------------------ *)
					(* -- Experiment options -- *)
					(* ------------------------ *)

					(* == Resolve sourceElectrode related Options == *)
					(* In this section, we do not need to resolve any options, just need to check some errors and warnings *)
					{sourceElectrodeOptionsErrorTrackerAssociation, sourceElectrodeOptionsWarningTrackerAssociation} = Module[
						{
							(* Variables *)
							sourceElectrodeRustCheckingLog, checkingLogLatestEntry, currentRustStatus,

							(* Error booleans *)
							nonNullNumberOfReplicatesForReferenceElectrodeObjectBool, sourceReferenceElectrodeNeedsPolishingBool,

							(* Warning booleans *)
							sourceReferenceElectrodeWorkingPartRustWarningBool
						},

						(* == Resolve NumberOfReplicates == *)
						(* -- If sourceElectrode is an object, NumberOfReplicates can't be greater than 1 -- *)
						nonNullNumberOfReplicatesForReferenceElectrodeObjectBool = If[
							And[
								MatchQ[sourceElectrode, ObjectP[Object[Item, Electrode, ReferenceElectrode]]],
								MatchQ[numberOfReplicates, _Integer],
								GreaterQ[numberOfReplicates, 1]
							],

							(* If numberOfReplicates is greater than 1 when the sourceElectrode is a reference electrode object, set this error to True *)
							True,
							False
						];

						(* == Check PolishReferenceElectrode == *)
						(* First we need to get the RustCheckingLog of the sourceElectrode *)
						sourceElectrodeRustCheckingLog = If[MatchQ[sourceElectrode, ObjectP[Object[Item, Electrode, ReferenceElectrode]]],

							(* If the sourceElectrode is an Object, we continue *)
							SortBy[Lookup[sourceElectrodePacket, RustCheckingLog], First],

							(* If the sourceElectrode is not an Object, we directly return {} *)
							{}
						];

						(* Get the last entry of sourceElectrodeRustCheckingLog if it's not an empty list *)
						checkingLogLatestEntry = If[!MatchQ[sourceElectrodeRustCheckingLog, {}],
							Last[sourceElectrodeRustCheckingLog],
							Null
						];

						(* Get the current rust status of the sourceElectrode if checkingLogLatestEntry is not Null *)
						currentRustStatus = If[!MatchQ[checkingLogLatestEntry, Null],
							checkingLogLatestEntry[[2]],
							Null
						];

						(* Throw an warning if the currentRustStatus is Both or WorkingPart, since this means the electrode should be discarded *)
						sourceReferenceElectrodeWorkingPartRustWarningBool = If[MatchQ[currentRustStatus, Alternatives[Both, WorkingPart]],
							True,
							False
						];

						(* Throw an error if the currentRustStatus is Both or NonWorkingPart but PolishReferenceElectrode is set to False *)
						sourceReferenceElectrodeNeedsPolishingBool = If[
							And[
								MatchQ[currentRustStatus, Alternatives[Both, NonWorkingPart]],
								MatchQ[polishReferenceElectrode, False]
							],
							True,
							False
						];

						(* Return the results *)
						{
							(* Errors *)
							Association[
								NonNullNumberOfReplicatesForReferenceElectrodeObjectBool -> nonNullNumberOfReplicatesForReferenceElectrodeObjectBool,
								SourceReferenceElectrodeNeedsPolishingBool -> sourceReferenceElectrodeNeedsPolishingBool
							],

							(* Warnings *)
							Association[
								SourceReferenceElectrodeWorkingPartRustWarningBool -> sourceReferenceElectrodeWorkingPartRustWarningBool
							]
						}
					];

					(* == Resolve reference electrode washing related options == *)
					{
						resolvedWashingOptionsAssociation,
						washingOptionsErrorTrackerAssociation,
						washingOptionsWarningTrackerAssociation
					} = Module[
						{
							(* variables *)
							targetElectrodeRecommendedSolventType, resolvedPrimaryWashingSolution, resolvedNumberOfPrimaryWashings, resolvedSecondaryWashingSolution, resolvedNumberOfSecondaryWashings,

							(* error trackers *)
							nonNullNumberOfPrimaryWashingsBool, missingNumberOfPrimaryWashingsBool, sameWashingSolutionsBool, missingPrimaryWashingSolutionBool, nonNullNumberOfSecondaryWashingsBool, missingNumberOfSecondaryWashingsBool,

							(* warning trackers *)
							nullPrimaryWashingSolutionWarningBool,

							(* outputs *)
							washingOptions, washingErrors, washingWarnings
						},

						(* == Resolve PrimaryWashingSolution == *)
						targetElectrodeRecommendedSolventType = Lookup[targetElectrodeModelPacket, RecommendedSolventType];

						resolvedPrimaryWashingSolution = If[MatchQ[targetElectrodeRecommendedSolventType, Organic],

							(* If the targetElectrodeRecommendedSolventType is Organic, set Automatic PrimaryWashingSolution to Model[Sample, "Acetonitrile, Electronic Grade"] *)
							primaryWashingSolution /. {Automatic -> Model[Sample, "id:n0k9mG8nP18n"]},

							(* Otherwise, set Automatic PrimaryWashingSolution to Model[Sample, "Milli-Q water"] *)
							primaryWashingSolution /. {Automatic -> Model[Sample, "id:8qZ1VWNmdLBD"]}
						] /. {x:ObjectP[] :> Download[x, Object]};

						(* == Resolve NumberOfPrimaryWashings == *)
						resolvedNumberOfPrimaryWashings = If[MatchQ[resolvedPrimaryWashingSolution, Null],

							(* If resolvedPrimaryWashingSolution is Null, set Automatic NumberOfPrimaryWashings to Null *)
							numberOfPrimaryWashings /. {Automatic -> Null},

							(* Otherwise, set Automatic NumberOfPrimaryWashings to 2 *)
							numberOfPrimaryWashings /. {Automatic -> 2}
						];

						(* -- Check if resolvedNumberOfPrimaryWashings is Null when resolvedPrimaryWashingSolution is Null -- *)
						nonNullNumberOfPrimaryWashingsBool = If[
							And[
								MatchQ[resolvedPrimaryWashingSolution, Null],
								!MatchQ[resolvedNumberOfPrimaryWashings, Null]
							],

							True,
							False
						];

						(* -- Check if resolvedNumberOfPrimaryWashings is not Null when resolvedPrimaryWashingSolution is not Null -- *)
						missingNumberOfPrimaryWashingsBool = If[
							And[
								MatchQ[resolvedPrimaryWashingSolution, ObjectP[Model[Sample]]],
								!MatchQ[resolvedNumberOfPrimaryWashings, _Integer]
							],

							True,
							False
						];

						(* == Do not need to resolve SecondaryWashingSolution, just get its Object == *)
						resolvedSecondaryWashingSolution = secondaryWashingSolution /. {x:ObjectP[] :> Download[x, Object]};

						(* == Need to do two checks == *)
						(* -- 1. PrimaryWashingSolution and SecondaryWashingSolution should be different -- *)
						sameWashingSolutionsBool = If[
							And[
								MatchQ[resolvedPrimaryWashingSolution, ObjectP[Model[Sample]]],
								MatchQ[resolvedSecondaryWashingSolution, ObjectP[Model[Sample]]],
								MatchQ[resolvedPrimaryWashingSolution, resolvedSecondaryWashingSolution]
							],

							(* If two washing solutions are the same, set this error to True *)
							True,

							(* Otherwise, set this error to False *)
							False
						];

						(* -- 2. SecondaryWashingSolution should not be set if resolvedPrimaryWashingSolution is Null -- *)
						missingPrimaryWashingSolutionBool = If[
							And[
								MatchQ[resolvedPrimaryWashingSolution, Null],
								MatchQ[resolvedSecondaryWashingSolution, ObjectP[Model[Sample]]]
							],

							(* If primaryWashingSolution is Null when secondaryWashingSolution is specified, set this error to True *)
							True,

							(* Otherwise, set this error to False *)
							False
						];

						(* -- Check if resolvedPrimaryWashingSolution is Null. If it is Null, throw a warning -- *)
						nullPrimaryWashingSolutionWarningBool = If[MatchQ[missingPrimaryWashingSolutionBool, False] && MatchQ[resolvedPrimaryWashingSolution, Null],
							True,
							False
						];

						(* == Resolve NumberOfSecondaryWashings == *)
						resolvedNumberOfSecondaryWashings = If[MatchQ[resolvedSecondaryWashingSolution, Null],

							(* If resolvedSecondaryWashingSolution is Null, set Automatic NumberOfSecondaryWashings to Null *)
							numberOfSecondaryWashings /. {Automatic -> Null},

							(* Otherwise, set Automatic NumberOfSecondaryWashings to 2 *)
							numberOfSecondaryWashings /. {Automatic -> 2}
						];

						(* -- Check if resolvedNumberOfSecondaryWashings is Null when resolvedSecondaryWashingSolution is Null -- *)
						nonNullNumberOfSecondaryWashingsBool = If[
							And[
								MatchQ[resolvedSecondaryWashingSolution, Null],
								!MatchQ[resolvedNumberOfSecondaryWashings, Null]
							],

							True,
							False
						];

						(* -- Check if resolvedNumberOfSecondaryWashings is not Null when resolvedSecondaryWashingSolution is not Null -- *)
						missingNumberOfSecondaryWashingsBool = If[
							And[
								MatchQ[resolvedSecondaryWashingSolution, ObjectP[Model[Sample]]],
								!MatchQ[resolvedNumberOfSecondaryWashings, _Integer]
							],

							True,
							False
						];

						(* collect the resolved options relevant to the reference electrode washings *)
						washingOptions = Association[
							PrimaryWashingSolution -> resolvedPrimaryWashingSolution,
							NumberOfPrimaryWashings -> resolvedNumberOfPrimaryWashings,
							SecondaryWashingSolution -> resolvedSecondaryWashingSolution,
							NumberOfSecondaryWashings -> resolvedNumberOfSecondaryWashings
						];

						(* collect the error tracking variables for the reference electrode washings *)
						washingErrors = Association[
							NonNullNumberOfPrimaryWashingsBool -> nonNullNumberOfPrimaryWashingsBool,
							MissingNumberOfPrimaryWashingsBool -> missingNumberOfPrimaryWashingsBool,
							SameWashingSolutionsBool -> sameWashingSolutionsBool,
							MissingPrimaryWashingSolutionBool -> missingPrimaryWashingSolutionBool,
							NonNullNumberOfSecondaryWashingsBool -> nonNullNumberOfSecondaryWashingsBool,
							MissingNumberOfSecondaryWashingsBool -> missingNumberOfSecondaryWashingsBool
						];

						(* collect the warning tracking variables for the reference electrode washings *)
						washingWarnings = Association[
							NullPrimaryWashingSolutionWarningBool -> nullPrimaryWashingSolutionWarningBool
						];

						(* Return the associations *)
						{washingOptions, washingErrors, washingWarnings}
					];

					(* == Resolve Volume Options == *)
					{resolvedVolumeOptionsAssociation, volumeOptionsErrorTrackerAssociation} = Module[
						{
							(* Variables *)
							electrodeSolutionVolume, resolvedPrimingVolume, resolvedReferenceSolutionVolume,

							(* Error booleans *)
							tooSmallPrimingVolumeBool, tooSmallReferenceSolutionVolumeBool, tooLargeReferenceSolutionVolumeBool
						},

						(* Get the SolutionVolume from the targetElectrodeModelPacket *)
						electrodeSolutionVolume = Lookup[targetElectrodeModelPacket, SolutionVolume];

						(* == Resolve PrimingVolume == *)
						resolvedPrimingVolume = SafeRound[
							primingVolume /. {Automatic -> Max[2 * electrodeSolutionVolume, 2 Milliliter]},
							10^0 Milliliter,
							RoundAmbiguous -> Up
						];

						(* Check if resolvedPrimingVolume is too Small *)
						tooSmallPrimingVolumeBool = If[LessQ[resolvedPrimingVolume, 1.5 Milliliter],
							True,
							False
						];

						(* == Resolve ReferenceSolutionVolume == *)
						resolvedReferenceSolutionVolume = SafeRound[
							referenceSolutionVolume /. {Automatic -> electrodeSolutionVolume},
							10^-1 Milliliter,
							RoundAmbiguous -> Up
						];

						(* -- Check if resolvedReferenceSolutionVolume is less than 95% of the electrodeSolutionVolume -- *)
						tooSmallReferenceSolutionVolumeBool = If[LessQ[resolvedReferenceSolutionVolume, 0.95 * electrodeSolutionVolume],
							True,
							False
						];

						(* -- Check if resolvedReferenceSolutionVolume is greater than 105% of the electrodeSolutionVolume -- *)
						tooLargeReferenceSolutionVolumeBool = If[GreaterQ[resolvedReferenceSolutionVolume, 1.05 * electrodeSolutionVolume],
							True,
							False
						];

						(* Return the results *)
						{
							Association[
								PrimingVolume -> resolvedPrimingVolume,
								ReferenceSolutionVolume -> resolvedReferenceSolutionVolume
							],
							Association[
								TooSmallPrimingVolumeBool -> tooSmallPrimingVolumeBool,
								TooSmallReferenceSolutionVolumeBool -> tooSmallReferenceSolutionVolumeBool,
								TooLargeReferenceSolutionVolumeBool -> tooLargeReferenceSolutionVolumeBool
							]
						}
					];

					(* == Resolve SamplesOutStorageCondition == *)
					{resolvedSamplesOutStorageConditionOptionsAssociation, samplesOutStorageConditionOptionsErrorTrackerAssociation} = Module[
						{
							resolvedSamplesOutStorageCondition, disposalSamplesOutStorageConditionBool, incompatibleSamplesOutStorageConditionBool
						},

						(* Currently, all the reference electrodes are stored under AmbientStorage, which includes flammable *)
						resolvedSamplesOutStorageCondition = samplesOutStorageCondition /. {Null -> AmbientStorage};

						(* -- Check if resolvedSamplesOutStorageCondition is Disposal -- *)
						disposalSamplesOutStorageConditionBool = If[MatchQ[resolvedSamplesOutStorageCondition, Disposal],
							True,
							False
						];

						(* -- Check if resolvedReferenceSolutionVolume is not AmbientStorage -- *)
						incompatibleSamplesOutStorageConditionBool = If[
							!MatchQ[resolvedSamplesOutStorageCondition, AmbientStorage] && MatchQ[disposalSamplesOutStorageConditionBool, False],
							True,
							False
						];

						(* Return the results *)
						{
							Association[
								SamplesOutStorageCondition -> resolvedSamplesOutStorageCondition
							],
							Association[
								DisposalSamplesOutStorageConditionBool -> disposalSamplesOutStorageConditionBool,
								IncompatibleSamplesOutStorageConditionBool -> incompatibleSamplesOutStorageConditionBool
							]
						}
					];

					(* ------------------------------------------------- *)
					(* -- COMBINE RESOLVED OPTIONS AND ERROR TRACKING -- *)
					(* ------------------------------------------------- *)

					(* compose the resolved options in the form of <|OptionName -> resolvedOptionValue..|> *)
					resolvedOptionsAssociation = Join[
						resolvedWashingOptionsAssociation,
						resolvedVolumeOptionsAssociation,
						resolvedSamplesOutStorageConditionOptionsAssociation
					];

					(* compose the error trackers in the form of <|ErrorName -> errorTrackerValue .. |> *)
					errorTrackersAssociation = Join[
						compatibilityErrorTrackerAssociation,
						sourceElectrodeOptionsErrorTrackerAssociation,
						washingOptionsErrorTrackerAssociation,
						volumeOptionsErrorTrackerAssociation,
						samplesOutStorageConditionOptionsErrorTrackerAssociation
					];

					(* compose the warning trackers in the form of <|ErrorName -> errorTrackerValue .. |> *)
					warningTrackersAssociation = Join[
						compatibilityWarningTrackerAssociation,
						sourceElectrodeOptionsWarningTrackerAssociation,
						washingOptionsWarningTrackerAssociation
					];

					(* return the options and the error tracking booleans - note that because this is an association don't worry about order *)
					{resolvedOptionsAssociation, errorTrackersAssociation, warningTrackersAssociation}
				]
			],
			{mapThreadFriendlyOptions, mySourceReferenceElectrodes, sourceReferenceElectrodePackets, myTargetReferenceElectrodeModels, targetReferenceElectrodeModelPackets}
		]
	];

	(* -- MAPTHREAD CLEANUP -- *)
	resolvedOptionsAssociation = Merge[resolvedMapThreadOptionsAssociations, Join];
	mapThreadErrorCheckingAssociation = Merge[mapThreadErrorCheckingAssociations, Join];
	mapThreadWarningCheckingAssociation = Merge[mapThreadWarningCheckingAssociations, Join];

	(* == Extract samplePackets that had a problem in the MapThread == *)
	(* Compatibility errors *)
	{
		targetModelPacketsWithMismatchingBlank,
		targetModelPacketsWithReferenceElectrodeTypeSwitching
	} = Map[PickList[targetReferenceElectrodeModelPackets, #]&,
		Lookup[mapThreadErrorCheckingAssociation,
			{
				MismatchingBlankBool,
				ReferenceElectrodeTypeSwitchingBool
			}
		]
	];

	(* Compatibility warnings *)
	{
		targetModelPacketsWithReferenceCouplingSampleSwitchingWarning
	} = Map[PickList[targetReferenceElectrodeModelPackets, #]&,
		Lookup[mapThreadWarningCheckingAssociation,
			{
				ReferenceCouplingSampleSwitchingWarningBool
			}
		]
	];

	(* Source electrode errors *)
	{
		sourceElectrodePacketsWithNonNullNumberOfReplicatesForReferenceElectrodeObject,
		sourceElectrodePacketsWithSourceReferenceElectrodeNeedsPolishing
	} = Map[PickList[sourceReferenceElectrodePackets, #]&,
		Lookup[mapThreadErrorCheckingAssociation,
			{
				NonNullNumberOfReplicatesForReferenceElectrodeObjectBool,
				SourceReferenceElectrodeNeedsPolishingBool
			}
		]
	];

	(* Source electrode warnings *)
	{
		sourceElectrodePacketsWithSourceReferenceElectrodeWorkingPartRustWarning
	} = Map[PickList[sourceReferenceElectrodePackets, #]&,
		Lookup[mapThreadWarningCheckingAssociation,
			{
				SourceReferenceElectrodeWorkingPartRustWarningBool
			}
		]
	];

	(* Washing options errors *)
	{
		targetModelPacketsWithNonNullNumberOfPrimaryWashings,
		targetModelPacketsWithMissingNumberOfPrimaryWashings,
		targetModelPacketsWithSameWashingSolutions,
		targetModelPacketsWithMissingPrimaryWashingSolution,
		targetModelPacketsWithNonNullNumberOfSecondaryWashings,
		targetModelPacketsWithMissingNumberOfSecondaryWashings
	} = Map[PickList[targetReferenceElectrodeModelPackets, #]&,
		Lookup[mapThreadErrorCheckingAssociation,
			{
				NonNullNumberOfPrimaryWashingsBool,
				MissingNumberOfPrimaryWashingsBool,
				SameWashingSolutionsBool,
				MissingPrimaryWashingSolutionBool,
				NonNullNumberOfSecondaryWashingsBool,
				MissingNumberOfSecondaryWashingsBool
			}
		]
	];

	(* Washing options warnings *)
	{
		targetModelPacketsWithNullPrimaryWashingSolutionWarning
	} = Map[PickList[targetReferenceElectrodeModelPackets, #]&,
		Lookup[mapThreadWarningCheckingAssociation,
			{
				NullPrimaryWashingSolutionWarningBool
			}
		]
	];

	(* Volume options errors *)
	{
		targetModelPacketsWithTooSmallPrimingVolume,
		targetModelPacketsWithTooSmallReferenceSolutionVolume,
		targetModelPacketsWithTooLargeReferenceSolutionVolume
	} = Map[PickList[targetReferenceElectrodeModelPackets, #]&,
		Lookup[mapThreadErrorCheckingAssociation,
			{
				TooSmallPrimingVolumeBool,
				TooSmallReferenceSolutionVolumeBool,
				TooLargeReferenceSolutionVolumeBool
			}
		]
	];

	(* SamplesOutStorageCondition options errors *)
	{
		targetModelPacketsWithDisposalSamplesOutStorageCondition,
		targetModelPacketsWithIncompatibleSamplesOutStorageCondition
	} = Map[PickList[targetReferenceElectrodeModelPackets, #]&,
		Lookup[mapThreadErrorCheckingAssociation,
			{
				DisposalSamplesOutStorageConditionBool,
				IncompatibleSamplesOutStorageConditionBool
			}
		]
	];


	(* -------------------------------- *)
	(* -- CONFLICTING OPTIONS CHECKS -- *)
	(* -------------------------------- *)

	(* == Compatibility errors == *)

	(* -- PREMismatchingBlank: Message and Test -- *)
	(* throw the message *)
	If[!MatchQ[targetModelPacketsWithMismatchingBlank,{}]&&!gatherTests,
		Message[Error::PREMismatchingBlank,ObjectToString[targetModelPacketsWithMismatchingBlank,Cache->inheritedCache]]
	];
	(* make the test *)
	mismatchingBlankTests = prepareReferenceElectrodeTestHelper[gatherTests,
		Test,
		targetReferenceElectrodeModelPackets,
		targetModelPacketsWithMismatchingBlank,
		"The Blank fields in source electrode and target reference electrode model are identical for the input target reference electrode models `1`:",
		inheritedCache
	];

	(* -- PREReferenceElectrodeTypeSwitching: Message and Test -- *)
	(* throw the message *)
	If[!MatchQ[targetModelPacketsWithReferenceElectrodeTypeSwitching,{}]&&!gatherTests,
		Message[Error::PREReferenceElectrodeTypeSwitching,ObjectToString[targetModelPacketsWithReferenceElectrodeTypeSwitching,Cache->inheritedCache]]
	];
	(* make the test *)
	referenceElectrodeTypeSwitchingTests = prepareReferenceElectrodeTestHelper[gatherTests,
		Test,
		targetReferenceElectrodeModelPackets,
		targetModelPacketsWithReferenceElectrodeTypeSwitching,
		"The ReferenceElectrodeType fields in source electrode and target reference electrode model are identical (unless source is a blank electrode object or model) for the input target reference electrode models `1`:",
		inheritedCache
	];

	(* -- collect the invalid inputs for compatibility check -- *)
	compatibilityInvalidInputs = DeleteDuplicates[
		Flatten[{
			{Lookup[targetModelPacketsWithMismatchingBlank, Object, Nothing]},
			{Lookup[targetModelPacketsWithReferenceElectrodeTypeSwitching, Object, Nothing]}
		}]
	];

	(* == Compatibility warnings == *)
	(* -- PREReferenceCouplingSampleSwitchingWarning: Message and Test -- *)
	(* throw the message *)
	If[!MatchQ[targetModelPacketsWithReferenceCouplingSampleSwitchingWarning,{}]&&!gatherTests&&!MatchQ[$ECLApplication,Engine],
		Message[Warning::PREReferenceCouplingSampleSwitchingWarning,ObjectToString[targetModelPacketsWithReferenceCouplingSampleSwitchingWarning,Cache->inheritedCache]]
	];
	(* make the test *)
	referenceCouplingSampleSwitchingWarningTests = prepareReferenceElectrodeTestHelper[gatherTests,
		Warning,
		targetReferenceElectrodeModelPackets,
		targetModelPacketsWithReferenceCouplingSampleSwitchingWarning,
		"The Blank field is informed for the input target reference electrode models `1`:",
		inheritedCache
	];

	(* == Source electrode errors == *)
	(* -- PRENonNullNumberOfReplicatesForReferenceElectrodeObject: Message and Test -- *)
	(* throw the message *)
	If[!MatchQ[sourceElectrodePacketsWithNonNullNumberOfReplicatesForReferenceElectrodeObject,{}]&&!gatherTests,
		Message[Error::PRENonNullNumberOfReplicatesForReferenceElectrodeObject,ObjectToString[sourceElectrodePacketsWithNonNullNumberOfReplicatesForReferenceElectrodeObject,Cache->inheritedCache]]
	];
	(* make the test *)
	nonNullNumberOfReplicatesForReferenceElectrodeObjectTests = prepareReferenceElectrodeTestHelper[gatherTests,
		Test,
		sourceReferenceElectrodePackets,
		sourceElectrodePacketsWithNonNullNumberOfReplicatesForReferenceElectrodeObject,
		"The NumberOfReplicates options is specified for the input source reference electrodes `1`:",
		inheritedCache
	];

	(* -- collect the invalid option for PRENonNullNumberOfReplicatesForReferenceElectrodeObject -- *)
	numberOfReplicatesInvalidOptions = PickList[
		{NumberOfReplicates},
		{
			sourceElectrodePacketsWithNonNullNumberOfReplicatesForReferenceElectrodeObject
		},
		Except[{}]
	];

	(* -- PRESourceReferenceElectrodeNeedsPolishing: Message and Test -- *)
	(* throw the message *)
	If[!MatchQ[sourceElectrodePacketsWithSourceReferenceElectrodeNeedsPolishing,{}]&&!gatherTests,
		Message[Error::PRESourceReferenceElectrodeNeedsPolishing,ObjectToString[sourceElectrodePacketsWithSourceReferenceElectrodeNeedsPolishing,Cache->inheritedCache]]
	];
	(* make the test *)
	sourceReferenceElectrodeNeedsPolishingTests = prepareReferenceElectrodeTestHelper[gatherTests,
		Test,
		sourceReferenceElectrodePackets,
		sourceElectrodePacketsWithSourceReferenceElectrodeNeedsPolishing,
		"The PolishReferenceElectrode is set to True if the source reference electrode has rust on its non-working part for the input source reference electrodes `1`:",
		inheritedCache
	];

	(* -- collect the invalid option for PRESourceReferenceElectrodeNeedsPolishing -- *)
	polishReferenceElectrodeInvalidOptions = PickList[
		{PolishReferenceElectrode},
		{
			sourceElectrodePacketsWithSourceReferenceElectrodeNeedsPolishing
		},
		Except[{}]
	];

	(* == Source electrode warnings == *)
	(* -- PRESourceReferenceElectrodeWorkingPartRustWarning: Message and Test -- *)
	(* throw the message *)
	If[!MatchQ[sourceElectrodePacketsWithSourceReferenceElectrodeWorkingPartRustWarning,{}]&&!gatherTests&&!MatchQ[$ECLApplication,Engine],
		Message[Warning::PRESourceReferenceElectrodeWorkingPartRustWarning,ObjectToString[sourceElectrodePacketsWithSourceReferenceElectrodeWorkingPartRustWarning,Cache->inheritedCache]]
	];
	(* make the test *)
	sourceReferenceElectrodeWorkingPartRustWarningTests = prepareReferenceElectrodeTestHelper[gatherTests,
		Warning,
		sourceReferenceElectrodePackets,
		sourceElectrodePacketsWithSourceReferenceElectrodeWorkingPartRustWarning,
		"Rust is found on the working part for the input source reference electrodes `1`:",
		inheritedCache
	];

	(* == Washing options errors == *)
	(* -- PRENonNullNumberOfPrimaryWashings: Message and Test -- *)
	(* throw the message *)
	If[!MatchQ[targetModelPacketsWithNonNullNumberOfPrimaryWashings,{}]&&!gatherTests,
		Message[Error::PRENonNullNumberOfPrimaryWashings,ObjectToString[targetModelPacketsWithNonNullNumberOfPrimaryWashings,Cache->inheritedCache]]
	];
	(* make the test *)
	nonNullNumberOfPrimaryWashingsTests = prepareReferenceElectrodeTestHelper[gatherTests,
		Test,
		targetReferenceElectrodeModelPackets,
		targetModelPacketsWithNonNullNumberOfPrimaryWashings,
		"The NumberOfPrimaryWashings options resolves to Null when the PrimaryWashingSolution option is set to Null for the input target reference electrode models `1`:",
		inheritedCache
	];

	(* -- PREMissingNumberOfPrimaryWashings: Message and Test -- *)
	(* throw the message *)
	If[!MatchQ[targetModelPacketsWithMissingNumberOfPrimaryWashings,{}]&&!gatherTests,
		Message[Error::PREMissingNumberOfPrimaryWashings,ObjectToString[targetModelPacketsWithMissingNumberOfPrimaryWashings,Cache->inheritedCache]]
	];
	(* make the test *)
	missingNumberOfPrimaryWashingsTests = prepareReferenceElectrodeTestHelper[gatherTests,
		Test,
		targetReferenceElectrodeModelPackets,
		targetModelPacketsWithMissingNumberOfPrimaryWashings,
		"The NumberOfPrimaryWashings options is not set to Null while the PrimaryWashingSolution option is specified for the input target reference electrode models `1`:",
		inheritedCache
	];

	(* -- collect the invalid option for NumberOfPrimaryWashings -- *)
	numberOfPrimaryWashingsInvalidOptions = If[
		GreaterQ[Length[Join[
			targetModelPacketsWithNonNullNumberOfPrimaryWashings,
			targetModelPacketsWithMissingNumberOfPrimaryWashings
		]], 0],
		{NumberOfPrimaryWashings},
		{}
	];

	(* -- PRESameWashingSolutions: Message and Test -- *)
	(* throw the message *)
	If[!MatchQ[targetModelPacketsWithSameWashingSolutions,{}]&&!gatherTests,
		Message[Error::PRESameWashingSolutions,ObjectToString[targetModelPacketsWithSameWashingSolutions,Cache->inheritedCache]]
	];
	(* make the test *)
	sameWashingSolutionsTests = prepareReferenceElectrodeTestHelper[gatherTests,
		Test,
		targetReferenceElectrodeModelPackets,
		targetModelPacketsWithSameWashingSolutions,
		"The PrimaryWashingSolution and SecondaryWashingSolution are different for the input target reference electrode models `1`:",
		inheritedCache
	];

	(* -- PREMissingPrimaryWashingSolution: Message and Test -- *)
	(* throw the message *)
	If[!MatchQ[targetModelPacketsWithMissingPrimaryWashingSolution,{}]&&!gatherTests,
		Message[Error::PREMissingPrimaryWashingSolution,ObjectToString[targetModelPacketsWithMissingPrimaryWashingSolution,Cache->inheritedCache]]
	];
	(* make the test *)
	missingPrimaryWashingSolutionTests = prepareReferenceElectrodeTestHelper[gatherTests,
		Test,
		targetReferenceElectrodeModelPackets,
		targetModelPacketsWithMissingPrimaryWashingSolution,
		"The SecondaryWashingSolution is specified only when the PrimaryWashingSolution is specified for the input target reference electrode models `1`:",
		inheritedCache
	];

	(* -- collect the invalid options -- *)
	washingSolutionsInvalidOptions = If[
		GreaterQ[Length[Join[
			targetModelPacketsWithSameWashingSolutions,
			targetModelPacketsWithMissingPrimaryWashingSolution
		]], 0],
		{PrimaryWashingSolution, SecondaryWashingSolution},
		{}
	];

	(* -- PRENonNullNumberOfSecondaryWashings: Message and Test -- *)
	(* throw the message *)
	If[!MatchQ[targetModelPacketsWithNonNullNumberOfSecondaryWashings,{}]&&!gatherTests,
		Message[Error::PRENonNullNumberOfSecondaryWashings,ObjectToString[targetModelPacketsWithNonNullNumberOfSecondaryWashings,Cache->inheritedCache]]
	];
	(* make the test *)
	nonNullNumberOfSecondaryWashingsTests = prepareReferenceElectrodeTestHelper[gatherTests,
		Test,
		targetReferenceElectrodeModelPackets,
		targetModelPacketsWithNonNullNumberOfSecondaryWashings,
		"The NumberOfSecondaryWashings options resolves to Null when the SecondaryWashingSolution option is set to Null for the input target reference electrode models `1`:",
		inheritedCache
	];

	(* -- PREMissingNumberOfSecondaryWashings: Message and Test -- *)
	(* throw the message *)
	If[!MatchQ[targetModelPacketsWithMissingNumberOfSecondaryWashings,{}]&&!gatherTests,
		Message[Error::PREMissingNumberOfSecondaryWashings,ObjectToString[targetModelPacketsWithMissingNumberOfSecondaryWashings,Cache->inheritedCache]]
	];
	(* make the test *)
	missingNumberOfSecondaryWashingsTests = prepareReferenceElectrodeTestHelper[gatherTests,
		Test,
		targetReferenceElectrodeModelPackets,
		targetModelPacketsWithMissingNumberOfSecondaryWashings,
		"The NumberOfSecondaryWashings options is not set to Null when the SecondaryWashingSolution option is specified for the input target reference electrode models `1`:",
		inheritedCache
	];

	(* -- collect the invalid option for NumberOfSecondaryWashings -- *)
	numberOfSecondaryWashingsInvalidOptions = If[
		GreaterQ[Length[Join[
			targetModelPacketsWithNonNullNumberOfSecondaryWashings,
			targetModelPacketsWithMissingNumberOfSecondaryWashings
		]], 0],
		{NumberOfSecondaryWashings},
		{}
	];

	(* == Washing options warnings == *)
	(* -- PRENullPrimaryWashingSolutionWarning: Message and Test -- *)
	(* throw the message *)
	If[!MatchQ[targetModelPacketsWithNullPrimaryWashingSolutionWarning,{}]&&!gatherTests&&!MatchQ[$ECLApplication,Engine],
		Message[Warning::PRENullPrimaryWashingSolutionWarning,ObjectToString[targetModelPacketsWithNullPrimaryWashingSolutionWarning,Cache->inheritedCache]]
	];
	(* make the test *)
	nullPrimaryWashingSolutionWarningTests = prepareReferenceElectrodeTestHelper[gatherTests,
		Warning,
		targetReferenceElectrodeModelPackets,
		targetModelPacketsWithNullPrimaryWashingSolutionWarning,
		"The PrimaryWashingSolution is not set to Null for the input target reference electrode models `1`:",
		inheritedCache
	];

	(* == Volume options errors == *)
	(* -- PRETooSmallPrimingVolume: Message and Test -- *)
	(* throw the message *)
	If[!MatchQ[targetModelPacketsWithTooSmallPrimingVolume,{}]&&!gatherTests,
		Message[Error::PRETooSmallPrimingVolume,ObjectToString[targetModelPacketsWithTooSmallPrimingVolume,Cache->inheritedCache]]
	];
	(* make the test *)
	tooSmallPrimingVolumeTests = prepareReferenceElectrodeTestHelper[gatherTests,
		Test,
		targetReferenceElectrodeModelPackets,
		targetModelPacketsWithTooSmallPrimingVolume,
		"The PrimingVolume is set to a volume equal to or greater than 3 Milliliter for the input target reference electrode models `1`:",
		inheritedCache
	];

	(* -- collect the invalid option for PrimingVolume -- *)
	primingVolumeInvalidOptions = If[
		GreaterQ[Length[Join[
			targetModelPacketsWithTooSmallPrimingVolume
		]], 0],
		{PrimingVolume},
		{}
	];

	(* -- PRETooSmallReferenceSolutionVolume: Message and Test -- *)
	(* throw the message *)
	If[!MatchQ[targetModelPacketsWithTooSmallReferenceSolutionVolume,{}]&&!gatherTests,
		Message[Error::PRETooSmallReferenceSolutionVolume,ObjectToString[targetModelPacketsWithTooSmallReferenceSolutionVolume,Cache->inheritedCache]]
	];
	(* make the test *)
	tooSmallReferenceSolutionVolumeTests = prepareReferenceElectrodeTestHelper[gatherTests,
		Test,
		targetReferenceElectrodeModelPackets,
		targetModelPacketsWithTooSmallReferenceSolutionVolume,
		"The ReferenceSolutionVolume to a volume no less than 95% of the target reference electrode model's SolutionVolume for the input target reference electrode models `1`:",
		inheritedCache
	];

	(* -- PRETooLargeReferenceSolutionVolume: Message and Test -- *)
	(* throw the message *)
	If[!MatchQ[targetModelPacketsWithTooLargeReferenceSolutionVolume,{}]&&!gatherTests,
		Message[Error::PRETooLargeReferenceSolutionVolume,ObjectToString[targetModelPacketsWithTooLargeReferenceSolutionVolume,Cache->inheritedCache]]
	];
	(* make the test *)
	tooLargeReferenceSolutionVolumeTests = prepareReferenceElectrodeTestHelper[gatherTests,
		Test,
		targetReferenceElectrodeModelPackets,
		targetModelPacketsWithTooLargeReferenceSolutionVolume,
		"The ReferenceSolutionVolume to a volume no greater than 105% of the target reference electrode model's SolutionVolume for the input target reference electrode models `1`:",
		inheritedCache
	];

	(* -- collect the invalid option for ReferenceSolutionVolume -- *)
	referenceSolutionVolumeInvalidOptions = If[
		GreaterQ[Length[Join[
			targetModelPacketsWithTooSmallReferenceSolutionVolume,
			targetModelPacketsWithTooLargeReferenceSolutionVolume
		]], 0],
		{ReferenceSolutionVolume},
		{}
	];

	(* == SamplesOutStorageCondition options errors == *)
	(* -- PREDisposalSamplesOutStorageCondition: Message and Test -- *)
	(* throw the message *)
	If[!MatchQ[targetModelPacketsWithDisposalSamplesOutStorageCondition,{}]&&!gatherTests,
		Message[Error::PREDisposalSamplesOutStorageCondition,ObjectToString[targetModelPacketsWithDisposalSamplesOutStorageCondition,Cache->inheritedCache]]
	];
	(* make the test *)
	disposalSamplesOutStorageConditionTests = prepareReferenceElectrodeTestHelper[gatherTests,
		Test,
		targetReferenceElectrodeModelPackets,
		targetModelPacketsWithDisposalSamplesOutStorageCondition,
		"The SamplesOutStorageCondition is not set to Disposal the input target reference electrode models `1`:",
		inheritedCache
	];

	(* -- PREIncompatibleSamplesOutStorageCondition: Message and Test -- *)
	(* throw the message *)
	If[!MatchQ[targetModelPacketsWithIncompatibleSamplesOutStorageCondition,{}]&&!gatherTests,
		Message[Error::PREIncompatibleSamplesOutStorageCondition,ObjectToString[targetModelPacketsWithIncompatibleSamplesOutStorageCondition,Cache->inheritedCache]]
	];
	(* make the test *)
	incompatibleSamplesOutStorageConditionTests = prepareReferenceElectrodeTestHelper[gatherTests,
		Test,
		targetReferenceElectrodeModelPackets,
		targetModelPacketsWithIncompatibleSamplesOutStorageCondition,
		"The SamplesOutStorageCondition is set to AmbientStorage or Null for the input target reference electrode models `1`:",
		inheritedCache
	];

	(* -- collect the invalid option for PrimingVolume -- *)
	samplesOutStorageConditionInvalidOptions = If[
		GreaterQ[Length[Join[
			targetModelPacketsWithDisposalSamplesOutStorageCondition,
			targetModelPacketsWithIncompatibleSamplesOutStorageCondition
		]], 0],
		{SamplesOutStorageCondition},
		{}
	];

	(* ---------------------------------- *)
	(* -- Non-MapThread error checking -- *)
	(* ---------------------------------- *)
	maxNumberOfReferenceElectrodes = 5;
	numberOfTargetReferenceElectrodeModels = Length[myTargetReferenceElectrodeModels];

	(* Get the number of replicates and convert a Null to 1 *)
	numberOfReplicatesNumber = Lookup[roundedOptions, NumberOfReplicates] /. Null :> 1;

	(* If the NonNullNumberOfReplicatesForReferenceElectrodeObjectBool does not have True, we can check this error *)
	tooManyInputQ = If[
		And[
			!MemberQ[Lookup[mapThreadErrorCheckingAssociation, NonNullNumberOfReplicatesForReferenceElectrodeObjectBool], True],
			GreaterQ[numberOfReplicatesNumber * numberOfTargetReferenceElectrodeModels, maxNumberOfReferenceElectrodes]
		],
		True,
		False
	];

	(* gather the invalid inputs, which in this case is all of them *)
	tooManyInputsList = If[MatchQ[tooManyInputQ, True],
		Lookup[targetReferenceElectrodeModelPackets, Object],
		{}
	];

	(* throw the error *)
	If[MatchQ[tooManyInputQ, True]&&messages,
		Message[Error::PRETooManyTargetReferenceElectrodeModelInputs, numberOfReplicatesNumber * numberOfTargetReferenceElectrodeModels, maxNumberOfReferenceElectrodes]
	];

	(* make the test *)
	tooManySamplesTests = If[gatherTests,
		{
			Test["The input target reference electrode models and NumberOfReplicates option do not lead to more than 10 reference electrodes being prepared",
				tooManyInputQ,
				False
			]
		},
		(* If we are not gathering tests, set this to {} *)
		{}
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	(* gather the invalid inputs *)
	invalidInputs = DeleteDuplicates[Flatten[{
		duplicatedReferenceElectrodeInvalidInputs,
		discardedReferenceElectrodeInvalidInputs,
		deprecatedReferenceElectrodeModelInvalidInputs,
		unpreparableReferenceElectrodeModelInvalidInputs,
		tooManyInputsList,

		compatibilityInvalidInputs
	}]];

	(* gather the invalid options *)
	invalidOptions = DeleteCases[
		DeleteDuplicates[
			Flatten[
				{
					numberOfReplicatesInvalidOptions,
					polishReferenceElectrodeInvalidOptions,
					numberOfPrimaryWashingsInvalidOptions,
					washingSolutionsInvalidOptions,
					numberOfSecondaryWashingsInvalidOptions,
					primingVolumeInvalidOptions,
					referenceSolutionVolumeInvalidOptions,
					samplesOutStorageConditionInvalidOptions
				}
			]
		],
		Null
	];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->inheritedCache]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	prepareReferenceElectrodeTests = Cases[
		Flatten[
			{
				duplicatedReferenceElectrodeTests,
				discardedReferenceElectrodeTests,
				deprecatedReferenceElectrodeModelTests,
				unpreparableReferenceElectrodeModelTests,
				tooManySamplesTests,

				(* == Mapthread tests == *)
				mismatchingBlankTests,
				referenceElectrodeTypeSwitchingTests,
				referenceCouplingSampleSwitchingWarningTests,

				nonNullNumberOfReplicatesForReferenceElectrodeObjectTests,
				sourceReferenceElectrodeNeedsPolishingTests,
				sourceReferenceElectrodeWorkingPartRustWarningTests,

				nonNullNumberOfPrimaryWashingsTests,
				missingNumberOfPrimaryWashingsTests,
				sameWashingSolutionsTests,
				missingPrimaryWashingSolutionTests,
				nonNullNumberOfSecondaryWashingsTests,
				missingNumberOfSecondaryWashingsTests,
				nullPrimaryWashingSolutionWarningTests,

				tooSmallPrimingVolumeTests,
				tooSmallReferenceSolutionVolumeTests,
				tooLargeReferenceSolutionVolumeTests,

				disposalSamplesOutStorageConditionTests,
				incompatibleSamplesOutStorageConditionTests
			}
		], _EmeraldTest
	];

	(* ------------------------ *)
	(* --- RESOLVED OPTIONS --- *)
	(* ------------------------ *)

	resolvedOptions = ReplaceRule[Normal[roundedOptions],
		Flatten[
			{
				(* -- resolved options -- *)
				Normal[resolvedOptionsAssociation],

				(* --- pass through and other resolved options ---- *)
				resolvedPostProcessingOptions
			}
		]
	]/.x:ObjectP[]:>Download[x,Object];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result -> resolvedOptions,
		Tests -> prepareReferenceElectrodeTests
	}
];

(* ::Subsection::Closed:: *)
(* prepareReferenceElectrodeResourcePackets *)


(* ====================== *)
(* == RESOURCE PACKETS == *)
(* ====================== *)

DefineOptions[prepareReferenceElectrodeResourcePackets,
	Options:>{
		CacheOption,
		HelperOutputOption
	}
];

prepareReferenceElectrodeResourcePackets[
	mySourceReferenceElectrodes:{ObjectP[{Model[Item, Electrode, ReferenceElectrode], Object[Item, Electrode, ReferenceElectrode]}]..},
	myTargetReferenceElectrodeModels:{ObjectP[Model[Item, Electrode, ReferenceElectrode]]..},
	myPreparedResourcePackets:{PacketP[Object[Resource,Sample]]...},
	myUnresolvedOptions:{___Rule},
	myResolvedOptions:{___Rule},
	myCollapsedResolvedOptions:{___Rule},
	myOptions:OptionsPattern[]
]:=Module[
	{
		(* general variables *)
		expandedInputs, expandedResolvedOptions, resolvedOptionsNoHidden, outputSpecification, output,
		gatherTests, messages, cache, numReplicatesExpander,

		(* input electrode duplication *)
		numberOfReplicates, sourceReferenceElectrodesWithoutLinks, targetReferenceElectrodeModelsWithoutLinks, combinedInputElectrodeList, inputElectrodesWithReplicates, optionsWithReplicates, sourceReferenceElectrodesWithReplicates, targetReferenceElectrodeModelsWithReplicates,

		(* resolved option values *)
		polishReferenceElectrode, primaryWashingSolution, numberOfPrimaryWashings, secondaryWashingSolution, numberOfSecondaryWashings, numberOfPrimings, primingVolume, primingSoakTime, referenceSolutionVolume, sampleOutStorage,

		(* resources gathering *)
		preferredContainerModels, preferredContainerModelHeights, preferredContainerMaxVolumes, sortedPreferredContainerModelsByHeight, sortedPreferredContainerModelHeights, sortedPreferredContainerModelsByVolume, sortedPreferredContainerModelVolumes, sortedPreferredContainerModelsByHeightMaxVolumes, sandpaperModels, sandpaperGrits,

		sourceReferenceElectrodeResources, sourceReferenceElectrodeModelsWithoutLinks, sourceReferenceElectrodeModelsWithLinks,

		sourceReferenceElectrodeModelReferenceElectrodeTypes, referenceElectrodeNeedsAspirationField, needAspiration, totalAspirationVolume, wasteReferenceSolutionCollectionContainerModel, wasteReferenceSolutionCollectionContainerResource,

		referenceSolutionModels, uniqueReferenceSolutionModels, uniqueReferenceSolutionModelTotalVolumes, referenceSolutionContainerModels, referenceSolutionContainerCollectionModels, referenceSolutionResourcesReplaceRules, referenceSolutionsField, uniqueReferenceSolutionsField, uniqueReferenceSolutionsCollectionContainersResources, referenceSolutionCollectionContainerReplaceRules, referenceSolutionCollectionContainersField,

		washingVolumePerCycle, allWashingSolutionModels, uniqueWashingSolutionModels, uniqueWashingSolutionModelTotalVolumes, washingSolutionContainerModels, washingSolutionCollectionContainerModels, washingSolutionResourcesReplaceRules, primaryWashingSolutionResources, secondaryWashingSolutionResources, primaryWashingSolutionVolumes, secondaryWashingSolutionVolumes, safeNumberOfPrimaryWashings, safeNumberOfSecondaryWashings, uniqueWashingSolutionsField, uniqueWashingSolutionsCollectionContainersResources, washingCollectionContainerReplaceRules, primaryWashingSolutionCollectionContainersField, secondaryWashingSolutionCollectionContainersField,

		maxSingleWashingCycleVolume, maxSinglePrimingCycleVolume, maxRefillVolume, washingSyringeModelsList, primingSyringeModelsList, refillSyringeModelsList, washingSyringeModels, primingSyringeModels, refillSyringeModels, washingSyringeResolutions, primingSyringeResolutions, refillSyringeResolutions, washingSyringeResolutionPickListReference, primingSyringeResolutionPickListReference, refillSyringeResolutionPickListReference, qualifiedWashingSyringeModels, qualifiedPrimingSyringeModels, qualifiedRefillSyringeModels, selectedWashingSyringeModel, selectedPrimingSyringeModel, selectedRefillSyringeModel, washingSyringeResources, primingSyringeResources, washingSyringeReplaceRules, primingSyringeReplaceRules, primaryWashingSyringesField, secondaryWashingSyringesField, referenceElectrodePrimingSyringesField, referenceElectrodeRefillSyringeResources, selectedAspirationSyringeModel, wasteReferenceSolutionCollectionSyringeResource,

		uniqueTargetReferenceElectrodeModels, referenceElectrodeLengths, maxReferenceElectrodeLength, washingSolutionContainerModelHeights, washingSolutionContainerModelsMaxHeight, referenceSolutionContainerModelHeights, referenceSolutionContainerModelsMaxHeight, washingSyringeConnectionType, primingSyringeConnectionType, refillSyringeConnectionType, aspirationSyringeConnectionType, allNeedlePackets, selectedWashingNeedleModel, selectedPrimingNeedleModel, selectedRefillNeedleModel, selectedAspirationNeedleModel, washingNeedleResources, primingNeedleResources, referenceElectrodeRefillNeedleResources, wasteReferenceSolutionCollectionNeedleResource,

		selectedElectrodeContainerModels, referenceElectrodeStorageContainersResources,

		selectedSandpaperModel, sandpaperResource, tweezerResource, electrodeImagingRackResource, referenceElectrodeRackResource, electrodeImagingDeck,

		(* time estimates *)
		polishingTime, washingTime, primingTime, refillAndSoakingTime, gatherResourcesTime, fumeHoodModels, fumeHoodResource,

		(* FRQ check *)
		protocolPacket, allResourceBlobs, fulfillable, frqTests, resultRule, testsRule
	},

	(* --------------------------- *)
	(*-- SETUP OPTIONS AND CACHE --*)
	(* --------------------------- *)


	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentPrepareReferenceElectrode, {myTargetReferenceElectrodeModels}, myResolvedOptions, 1];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentPrepareReferenceElectrode,
		RemoveHiddenOptions[ExperimentPrepareReferenceElectrode, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages->False
	];

	(* Determine the requested output format of this function. *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = Not[gatherTests];

	(* Fetch our cache from the parent function. *)
	cache = Cases[Lookup[ToList[myOptions],Cache], PacketP[]];

	(* Get our number of replicates. *)
	numberOfReplicates = Lookup[myResolvedOptions, NumberOfReplicates] /. {Null->1};

	(* make a tiny function that expands index matching things with number of replicates *)
	numReplicatesExpander[myList_List]:=Module[{},
		Join @@ Map[
			ConstantArray[#, numberOfReplicates]&,
			myList
		]
	];

	(* Get the sourceReferenceElectrodes and targetReferenceElectrodeModels without links *)
	sourceReferenceElectrodesWithoutLinks = mySourceReferenceElectrodes /. {x:ObjectP[]:>Download[x, Object]};
	targetReferenceElectrodeModelsWithoutLinks = myTargetReferenceElectrodeModels /. {x:ObjectP[]:>Download[x, Object]};

	(* Create a list containing both source and target for the expandNumberOfReplicates function *)
	combinedInputElectrodeList = Transpose[{sourceReferenceElectrodesWithoutLinks, targetReferenceElectrodeModelsWithoutLinks}];

	(* Expand our samples and options according to NumberOfReplicates. *)
	{inputElectrodesWithReplicates, optionsWithReplicates} = expandNumberOfReplicates[ExperimentPrepareReferenceElectrode, combinedInputElectrodeList, myResolvedOptions];

	(* Get back the replicated source and target reference electrodes *)
	sourceReferenceElectrodesWithReplicates = inputElectrodesWithReplicates[[All, 1]];
	targetReferenceElectrodeModelsWithReplicates = inputElectrodesWithReplicates[[All, 2]];

	(* ------------------- *)
	(* -- OPTION LOOKUP -- *)
	(* ------------------- *)

	(* LOOK UP EXPERIMENT OPTIONS *)
	{
		polishReferenceElectrode, primaryWashingSolution, numberOfPrimaryWashings, secondaryWashingSolution, numberOfSecondaryWashings, numberOfPrimings, primingVolume, primingSoakTime, referenceSolutionVolume
	} = Lookup[optionsWithReplicates,
		{
			PolishReferenceElectrode, PrimaryWashingSolution, NumberOfPrimaryWashings, SecondaryWashingSolution, NumberOfSecondaryWashings, NumberOfPrimings, PrimingVolume, PrimingSoakTime, ReferenceSolutionVolume
		}
	];

	(* LOOK UP GENERAL OPTIONS *)
	{
		sampleOutStorage
	} = Lookup[optionsWithReplicates,
		{
			SamplesOutStorageCondition
		}
	];

	(* create container model lists and retrieve their heights and max volumes*)
	preferredContainerModels = PreferredContainer[All];
	preferredContainerModelHeights = (Lookup[fetchPacketFromCache[#, cache], Dimensions]& /@ preferredContainerModels)[[All, 3]];
	preferredContainerMaxVolumes = Lookup[fetchPacketFromCache[#, cache], MaxVolume]&/@preferredContainerModels;

	(* Prepared sorted preferredContainerModel lists, according to their heights and Volumes *)
	{sortedPreferredContainerModelsByHeight, sortedPreferredContainerModelHeights} = Transpose[Sort[Transpose[{preferredContainerModels, preferredContainerModelHeights}], Last[#1] < Last[#2]&]];

	{sortedPreferredContainerModelsByVolume, sortedPreferredContainerModelVolumes} = Transpose[Sort[Transpose[{preferredContainerModels, preferredContainerMaxVolumes}], Last[#1] < Last[#2]&]];
	sortedPreferredContainerModelVolumes = Sort[Transpose[{preferredContainerModels, preferredContainerMaxVolumes}], Last[#1] < Last[#2]&][[All, 2]];

	(* Get the MaxVolumes for sortedPreferredContainerModelsByHeight *)
	sortedPreferredContainerModelsByHeightMaxVolumes = Lookup[fetchPacketFromCache[#, cache], MaxVolume]&/@sortedPreferredContainerModelsByHeight;

	(* Create sand paper model *)
	sandpaperModels = {
		Model[Item, Consumable, Sandpaper, "3M 1200 Grit Sandpaper"]
	} /. {x:ObjectP[]:>Download[x, Object]};

	(* Make lists of necessary information *)
	sandpaperGrits = Lookup[fetchPacketFromCache[#, cache], Grit]&/@sandpaperModels;

	(* ----------------------------------------- *)
	(* -- INPUT REFERENCE ELECTRODE RESOURCES -- *)
	(* ----------------------------------------- *)

	(* -- Generate resources for the source reference electrodes -- *)
	sourceReferenceElectrodeResources = Map[
		Which[
			(* If the source reference electrode is a Model, gather a object resource *)
			MatchQ[#, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
			Link[Resource[
				Sample -> #,
				Name -> CreateUUID[]
			]],

			(* If the source reference electrode is already an Object, gather it *)
			MatchQ[#, ObjectP[Object[Item, Electrode, ReferenceElectrode]]],
			Link[Resource[
				Sample -> #
			]],

			(* Otherwise (which should not happen), set it to Null *)
			True,
			Null

		]&, sourceReferenceElectrodesWithReplicates
	];

	(* -- Retrieve the models for source reference electrodes -- *)
	sourceReferenceElectrodeModelsWithoutLinks = Map[
		If[MatchQ[#, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],

			(* If the source reference electrode is a Model, return it directly *)
			#,

			(* If the source reference electrode is already an Object, retrieve its model from the cache *)
			Lookup[fetchPacketFromCache[#, cache], Model]

		]&, sourceReferenceElectrodesWithReplicates
	] /. {x:ObjectP[]:>Download[x, Object, Cache -> cache]};

	(* Put in the Links again *)
	sourceReferenceElectrodeModelsWithLinks = Link[#]&/@sourceReferenceElectrodeModelsWithoutLinks;

	(* -- Find out if any of the input source reference electrodes need aspiration (take the previous reference solution out) -- *)
	(* First we check the reference electrode type of the input sourceReferenceElectrodeModels *)
	sourceReferenceElectrodeModelReferenceElectrodeTypes = Lookup[fetchPacketFromCache[#, cache], ReferenceElectrodeType]& /@ sourceReferenceElectrodeModelsWithoutLinks;

	(* If the reference electrode type is "bare", then we don't need to aspirate. Otherwise, we need to aspirate *)
	referenceElectrodeNeedsAspirationField = Not[#]& /@ (StringContainsQ["Bare", IgnoreCase -> True] /@ sourceReferenceElectrodeModelReferenceElectrodeTypes);

	(* If there is anything True in referenceElectrodeNeedsAspirationField, we need to collect WasteReferenceSolutionCollectionContainer, WasteReferenceSolutionCollectionSyringe, and WasteReferenceSolutionCollectionNeedle *)
	needAspiration = MemberQ[referenceElectrodeNeedsAspirationField, True];

	(* Estimate how much volume is going to be aspirated. We set 1 Milliliter for each electrode, which should be enough *)
	totalAspirationVolume = Total[referenceElectrodeNeedsAspirationField/.{True -> 1 Milliliter, False -> 0 Milliliter}];

	(* If totalAspirationVolume is greater than 0 Milliliter, we pick a container model; otherwise set the model to Null *)
	wasteReferenceSolutionCollectionContainerModel = If[GreaterQ[totalAspirationVolume, 0 Milliliter],
		First[PickList[sortedPreferredContainerModelsByHeight, sortedPreferredContainerModelsByHeightMaxVolumes, GreaterEqualP[totalAspirationVolume]]],
		Null
	];

	(* Resource pick the container *)
	wasteReferenceSolutionCollectionContainerResource = If[MatchQ[wasteReferenceSolutionCollectionContainerModel, ObjectP[Model[Container]]],
		Link[Resource[
			Sample -> wasteReferenceSolutionCollectionContainerModel,
			Name -> CreateUUID[],
			Rent -> True
		]],
		Null
	];

	(* --------------------------------------------- *)
	(* -- Reference Solution Resources and Fields -- *)
	(* --------------------------------------------- *)

	(* -- Retrieve the reference solution models from target reference electrode models -- *)
	referenceSolutionModels = Map[
		Lookup[fetchPacketFromCache[#, cache], ReferenceSolution]&,
		targetReferenceElectrodeModelsWithReplicates
	] /. {x:ObjectP[]:>Download[x, Object]};

	(* Find out the unique reference solution models *)
	uniqueReferenceSolutionModels = DeleteDuplicates[referenceSolutionModels];

	(* Find out the total volumes for each unique reference solution models *)
	uniqueReferenceSolutionModelTotalVolumes = Map[
		Function[{model},
			Module[{pickListReference, totalPrimingVolume, totalRefillVolume},

				(* Generate a pick list reference list from referenceSolutionModels *)
				pickListReference = referenceSolutionModels /. {model -> True, ObjectP[Model[Sample]] -> False};

				(* Get the priming volumes of this reference electrode model and calculate the total *)
				totalPrimingVolume = Total[PickList[primingVolume * numberOfPrimings, pickListReference, True]];

				(* Get the refill volumes of this reference electrode model and calculate the total *)
				totalRefillVolume = Total[PickList[referenceSolutionVolume, pickListReference, True]];

				(* Return the result *)
				SafeRound[1.2 * (totalPrimingVolume + totalRefillVolume), 10^0 Milliliter, Round -> Up]
			]
		],
		uniqueReferenceSolutionModels
	];

	(* Need to find out the Containers that can hold the input reference solutions *)
	referenceSolutionContainerModels = First[PickList[sortedPreferredContainerModelsByVolume, sortedPreferredContainerModelVolumes, GreaterEqualP[#]]]& /@ (uniqueReferenceSolutionModelTotalVolumes * 1.2);

	(* Find out the collection containers model *)
	referenceSolutionContainerCollectionModels = First[PickList[sortedPreferredContainerModelsByHeight, sortedPreferredContainerModelsByHeightMaxVolumes, GreaterEqualP[#]]]& /@ (uniqueReferenceSolutionModelTotalVolumes * 1.2);

	(* Once we get the container models, we can gather the model -> resource association *)
	referenceSolutionResourcesReplaceRules = MapThread[
		Function[{solutionModel, totalVolume, containerModel},
			solutionModel -> Resource[
				Sample -> solutionModel,
				Amount -> totalVolume,
				Container -> containerModel,
				Name -> CreateUUID[]
			]
		],
		{uniqueReferenceSolutionModels, uniqueReferenceSolutionModelTotalVolumes, referenceSolutionContainerModels}
	];

	(* Prepare the referenceSolutionsField *)
	referenceSolutionsField = Link[#]& /@ (referenceSolutionModels /. referenceSolutionResourcesReplaceRules);

	(* Prepare the uniqueReferenceSolutionsField *)
	uniqueReferenceSolutionsField = MapThread[
		{Link[#1], #2}&,
		{uniqueReferenceSolutionModels /. referenceSolutionResourcesReplaceRules, uniqueReferenceSolutionModelTotalVolumes}
	];

	(* Resource pick the collection containers *)
	uniqueReferenceSolutionsCollectionContainersResources = Link[Resource[
		Sample -> #,
		Name -> CreateUUID[],
		Rent -> True
	]]& /@ referenceSolutionContainerCollectionModels;

	(* Create the replace rules for the reference solution -> reference solution collection containers *)
	referenceSolutionCollectionContainerReplaceRules = MapThread[
		#1 -> #2&,
		{uniqueReferenceSolutionModels, uniqueReferenceSolutionsCollectionContainersResources}
	];

	(* Prepare the ReferenceSolutionCollectionContainers field *)
	referenceSolutionCollectionContainersField = referenceSolutionModels /. referenceSolutionCollectionContainerReplaceRules;

	(* ------------------------------------------- *)
	(* -- Washing Solution Resources and Fields -- *)
	(* ------------------------------------------- *)
	washingVolumePerCycle = 2 Milliliter;

	(* Get all of the washing solution models *)
	allWashingSolutionModels = Join[primaryWashingSolution, secondaryWashingSolution];

	(* Find out the unique washing solution models *)
	uniqueWashingSolutionModels = DeleteDuplicates[allWashingSolutionModels] /. {Null -> Nothing};

	(* Find out the total volumes for each unique washing solution models *)
	uniqueWashingSolutionModelTotalVolumes = If[!MatchQ[uniqueWashingSolutionModels, {}],

		(* If the uniqueWashingSolutionModels is not an empty list, we continue *)
		Map[
			Function[{model},
				Module[{pickListReference, totalWashingCycles, totalWashingVolume},

					(* Generate a pick list reference list from referenceSolutionModels *)
					pickListReference = allWashingSolutionModels /. {model -> True, ObjectP[Model[Sample]] -> False, Null -> False};

					(* Get the total washing cycles for each unique washing solution model *)
					totalWashingCycles = Total[PickList[Join[numberOfPrimaryWashings, numberOfSecondaryWashings], pickListReference, True]];

					(* Get the total washing solution volume for each unique washing solution model *)
					totalWashingVolume = totalWashingCycles * washingVolumePerCycle;

					(* Return the result *)
					SafeRound[1.2 * totalWashingVolume, 10^0 Milliliter, Round -> Up]
				]
			],
			uniqueWashingSolutionModels
		],

		(* If the uniqueWashingSolutionModels is an empty list, return an empty list as well *)
		{}
	];

	(* Find out the container model for resource picked washing solutions *)
	washingSolutionContainerModels = First[PickList[sortedPreferredContainerModelsByVolume, sortedPreferredContainerModelVolumes, GreaterEqualP[#]]]& /@ (uniqueWashingSolutionModelTotalVolumes * 1.2);

	(* Find out the container model for collecting washing solutions *)
	washingSolutionCollectionContainerModels = First[PickList[sortedPreferredContainerModelsByHeight, sortedPreferredContainerModelsByHeightMaxVolumes, GreaterEqualP[#]]]& /@ (uniqueWashingSolutionModelTotalVolumes * 1.2);

	(* Once we get the washing solution container models, we can gather the washing solution model -> resource association *)
	washingSolutionResourcesReplaceRules = MapThread[
		Function[{solutionModel, totalVolume, containerModel},
			solutionModel -> Resource[
				Sample -> solutionModel,
				Amount -> totalVolume,
				Container -> containerModel,
				Name -> CreateUUID[]
			]
		],
		{uniqueWashingSolutionModels, uniqueWashingSolutionModelTotalVolumes, washingSolutionContainerModels}
	];

	(* Use the washingSolutionReplaceRules to prepare the primaryWashingSolutionResources and secondaryWashingSolutionResources *)
	primaryWashingSolutionResources = If[MatchQ[primaryWashingSolution, {Null..}],

		(* If the primaryWashingSolution only contains Null, return Null *)
		primaryWashingSolution,

		(* Otherwise we use the replace rules *)
		(Link[#]& /@ primaryWashingSolution) /. washingSolutionResourcesReplaceRules
	];

	secondaryWashingSolutionResources = If[MatchQ[secondaryWashingSolution, {Null..}],

		(* If the primaryWashingSolution only contains Null, return Null *)
		secondaryWashingSolution,

		(* Otherwise we use the replace rules *)
		(Link[#]& /@ secondaryWashingSolution) /. washingSolutionResourcesReplaceRules
	];

	(* Get the washing solution volume fields *)
	primaryWashingSolutionVolumes = primaryWashingSolution /. {ObjectP[Model[Sample]] -> washingVolumePerCycle};
	secondaryWashingSolutionVolumes = secondaryWashingSolution /. {ObjectP[Model[Sample]] -> washingVolumePerCycle};

	(* Get the safe number of washings *)
	safeNumberOfPrimaryWashings = numberOfPrimaryWashings;
	safeNumberOfSecondaryWashings = numberOfSecondaryWashings;

	(* Prepare the uniqueWashingSolutionsField *)
	uniqueWashingSolutionsField = MapThread[
		{Link[#1], #2}&,
		{uniqueWashingSolutionModels /. washingSolutionResourcesReplaceRules, uniqueWashingSolutionModelTotalVolumes}
	];

	(* Resource pick the collection containers *)
	uniqueWashingSolutionsCollectionContainersResources = Link[Resource[
		Sample -> #,
		Name -> CreateUUID[],
		Rent -> True
	]]& /@ washingSolutionCollectionContainerModels;

	(* Create the replace rules for the washing solution -> washing collection containers *)
	washingCollectionContainerReplaceRules = MapThread[
		#1 -> #2&,
		{uniqueWashingSolutionModels, uniqueWashingSolutionsCollectionContainersResources}
	];

	(* Get the PrimaryWashingSolutionCollectionContainers field *)
	primaryWashingSolutionCollectionContainersField = primaryWashingSolution /. washingCollectionContainerReplaceRules;

	(* Get the SecondaryWashingSolutionCollectionContainers field *)
	secondaryWashingSolutionCollectionContainersField = secondaryWashingSolution /. washingCollectionContainerReplaceRules;

	(* -------------------- *)
	(* -- ITEM RESOURCES -- *)
	(* -------------------- *)

	(* -- Sandpaper -- *)
	(* Select the right sandpaper model *)
	selectedSandpaperModel = First[PickList[sandpaperModels, sandpaperGrits, GreaterEqualP[1200]]];

	(* If MemberQ[polishReferenceElectrode, True], we collect the sandpaper resource *)
	sandpaperResource = If[MemberQ[polishReferenceElectrode, True],
		Resource[Sample -> selectedSandpaperModel, Amount -> 1, Name -> CreateUUID[], Rent -> True],
		Null
	];

	(* -- Syringes -- *)
	(* Check the MaxVolume of Syringes, which have to be greater than the Max[Join[primaryWashingSolutionVolumes, secondaryWashingSolutionVolumes, primingVolume, referenceSolutionVolume]] *)

	(* get the max volume for any single cycle operation *)
	maxSingleWashingCycleVolume = Max[Flatten[{
		{primaryWashingSolutionVolumes},
		{secondaryWashingSolutionVolumes}
	}] /. {Null -> Nothing}];

	(* get the max volume for any single cycle operation *)
	maxSinglePrimingCycleVolume = Max[Flatten[{
		primingVolume,
		referenceSolutionVolume
	}] /. {Null -> Nothing}];

	(* get the max volume for the referenceSolutionVolume *)
	maxRefillVolume = Max[referenceSolutionVolume];

	(* We first find the syringes that we can potentially use *)
	washingSyringeModelsList = If[VolumeQ[maxSingleWashingCycleVolume],
		TransferDevices[Model[Container, Syringe], maxSingleWashingCycleVolume * 1.2],
		{}
	];
	primingSyringeModelsList = TransferDevices[Model[Container, Syringe], maxSinglePrimingCycleVolume * 1.2];
	refillSyringeModelsList = TransferDevices[Model[Container, Syringe], maxRefillVolume * 1.2];

	(* get out the models and resolutions *)
	washingSyringeModels = washingSyringeModelsList[[All, 1]];
	washingSyringeResolutions = washingSyringeModelsList[[All, 4]];
	primingSyringeModels = primingSyringeModelsList[[All, 1]];
	primingSyringeResolutions = primingSyringeModelsList[[All, 4]];
	refillSyringeModels = refillSyringeModelsList[[All, 1]];
	refillSyringeResolutions = refillSyringeModelsList[[All, 4]];

	(* find the syringe models with a resolution less than 1 Milliliter *)
	washingSyringeResolutionPickListReference = LessEqualQ[#, 1 Milliliter] & /@ washingSyringeResolutions;
	primingSyringeResolutionPickListReference = LessEqualQ[#, 1 Milliliter] & /@ primingSyringeResolutions;
	refillSyringeResolutionPickListReference = LessEqualQ[#, 0.2 Milliliter] & /@ refillSyringeResolutions;

	qualifiedWashingSyringeModels = PickList[washingSyringeModels, washingSyringeResolutionPickListReference];
	qualifiedPrimingSyringeModels = PickList[primingSyringeModels, primingSyringeResolutionPickListReference];
	qualifiedRefillSyringeModels = PickList[refillSyringeModels, refillSyringeResolutionPickListReference];

	(* Select the syringe model *)
	selectedWashingSyringeModel = If[Length[qualifiedWashingSyringeModels] > 0,
		First[qualifiedWashingSyringeModels],
		Null
	];
	selectedPrimingSyringeModel = First[qualifiedPrimingSyringeModels];
	selectedRefillSyringeModel = First[qualifiedRefillSyringeModels];

	(* Resource pick the syringes *)
	washingSyringeResources = If[Length[uniqueWashingSolutionModels] > 0,
		Link[Resource[
			Sample -> selectedWashingSyringeModel,
			Name -> CreateUUID[]
		]]& /@ uniqueWashingSolutionModels,
		{}
	];

	primingSyringeResources = Link[Resource[
		Sample -> selectedPrimingSyringeModel,
		Name -> CreateUUID[]
	]]& /@ uniqueReferenceSolutionModels;

	(* Create the replace rules for the washing solution -> syringe *)
	washingSyringeReplaceRules = MapThread[
		#1 -> #2&,
		{uniqueWashingSolutionModels, washingSyringeResources}
	];

	(* Create the replace rules for the reference solution -> syringe *)
	primingSyringeReplaceRules = MapThread[
		#1 -> #2&,
		{uniqueReferenceSolutionModels, primingSyringeResources}
	];

	(* Prepare the PrimaryWashingSyringes field *)
	primaryWashingSyringesField = primaryWashingSolution /. washingSyringeReplaceRules;

	(* Prepare the SecondaryWashingSyringes field *)
	secondaryWashingSyringesField = secondaryWashingSolution /. washingSyringeReplaceRules;

	(* Prepare the ReferenceElectrodePrimingSyringes field *)
	referenceElectrodePrimingSyringesField = referenceSolutionModels /. primingSyringeReplaceRules;

	(* Resource pick the refill syringes *)
	referenceElectrodeRefillSyringeResources = Link[Resource[
		Sample -> selectedRefillSyringeModel,
		Name -> CreateUUID[]
	]]& /@ targetReferenceElectrodeModelsWithReplicates;

	(* -- Resource pick the aspiration syringe -- *)
	(* Find the model *)
	selectedAspirationSyringeModel = If[MatchQ[wasteReferenceSolutionCollectionContainerModel, ObjectP[Model[Container]]],
		First[TransferDevices[Model[Container, Syringe], washingVolumePerCycle * 1.2][[All, 1]]],
		Null
	];

	(* Resource pick *)
	wasteReferenceSolutionCollectionSyringeResource = If[MatchQ[selectedAspirationSyringeModel, ObjectP[Model[Container, Syringe]]],
		Link[Resource[
			Sample -> selectedAspirationSyringeModel,
			Name -> CreateUUID[]
		]],
		Null
	];

	(* -- Needles -- *)
	(* Get unique target reference electrode models *)
	uniqueTargetReferenceElectrodeModels = DeleteDuplicates[targetReferenceElectrodeModelsWithReplicates];

	(* Get the reference electrode lengths *)
	referenceElectrodeLengths = (Lookup[fetchPacketFromCache[#, cache], Dimensions][[3]])& /@ uniqueTargetReferenceElectrodeModels;

	(* Get the maximum length of these models *)
	maxReferenceElectrodeLength = Max[referenceElectrodeLengths];

	(* Get the Height of different containerModels *)
	(* WashingSolutionContainerModel *)
	washingSolutionContainerModelHeights = (Lookup[fetchPacketFromCache[#, cache], Dimensions]& /@ washingSolutionContainerModels)[[All, 3]];
	washingSolutionContainerModelsMaxHeight = If[!MatchQ[washingSolutionContainerModelHeights, {}],
		Max[washingSolutionContainerModelHeights],
		Null
	];

	(* ReferenceSolutionContainerModel *)
	referenceSolutionContainerModelHeights = (Lookup[fetchPacketFromCache[#, cache], Dimensions]& /@ referenceSolutionContainerModels)[[All, 3]];
	referenceSolutionContainerModelsMaxHeight = Max[referenceSolutionContainerModelHeights];

	(* We need to find out the ConnectionType of different syringes *)
	washingSyringeConnectionType = If[!MatchQ[selectedWashingSyringeModel, Null],
		Lookup[fetchPacketFromCache[selectedWashingSyringeModel, cache], ConnectionType],
		Null
	];
	primingSyringeConnectionType = Lookup[fetchPacketFromCache[selectedPrimingSyringeModel, cache], ConnectionType];
	refillSyringeConnectionType = Lookup[fetchPacketFromCache[selectedRefillSyringeModel, cache], ConnectionType];
	aspirationSyringeConnectionType = If[!MatchQ[selectedAspirationSyringeModel, Null],
		Lookup[fetchPacketFromCache[selectedAspirationSyringeModel, cache], ConnectionType],
		Null
	];

	(* search for the qualified needle models *)
	allNeedlePackets = Download[Search[
		Model[Item, Needle],
		Deprecated != True
	]];

	(* Select the needle models using compatibleNeedles helper function *)
	selectedWashingNeedleModel = If[!MatchQ[washingSyringeConnectionType, Null],
		First[compatibleNeedles[allNeedlePackets, ConnectionType -> washingSyringeConnectionType, MinimumLength -> washingSolutionContainerModelsMaxHeight, Viscous -> True, Blunt -> True]],
		Null
	];

	selectedPrimingNeedleModel = First[compatibleNeedles[allNeedlePackets, ConnectionType -> primingSyringeConnectionType, MinimumLength -> referenceSolutionContainerModelsMaxHeight, Viscous -> True, Blunt -> True]];

	selectedRefillNeedleModel = First[compatibleNeedles[allNeedlePackets, ConnectionType -> refillSyringeConnectionType, MinimumLength -> referenceSolutionContainerModelsMaxHeight, Viscous -> True, Blunt -> True]];

	selectedAspirationNeedleModel = If[!MatchQ[aspirationSyringeConnectionType, Null],
		First[compatibleNeedles[allNeedlePackets, ConnectionType -> aspirationSyringeConnectionType, MinimumLength -> Max[maxReferenceElectrodeLength, referenceSolutionContainerModelsMaxHeight], Viscous -> True, Blunt -> True]],
		Null
	];

	(* Resource pick the needles *)
	washingNeedleResources = Link[Resource[
		Sample -> selectedWashingNeedleModel,
		Name -> CreateUUID[],
		Rent -> True
	]]& /@ uniqueWashingSolutionModels;

	primingNeedleResources = Link[Resource[
		Sample -> selectedPrimingNeedleModel,
		Name -> CreateUUID[],
		Rent -> True
	]]& /@ uniqueReferenceSolutionModels;

	referenceElectrodeRefillNeedleResources = Link[Resource[
		Sample -> selectedRefillNeedleModel,
		Name -> CreateUUID[],
		Rent -> True
	]]& /@ targetReferenceElectrodeModelsWithReplicates;

	wasteReferenceSolutionCollectionNeedleResource = If[!MatchQ[selectedAspirationNeedleModel, Null],
		Link[Resource[
			Sample -> selectedAspirationNeedleModel,
			Name -> CreateUUID[],
			Rent -> True
		]],
		Null
	];

	(* -- ReferenceElectrodeStorageContainers -- *)

	(* Select the right vessel model, which has to be tall enough to store the electrode *)
	selectedElectrodeContainerModels = MapThread[
		Function[{targetReferenceElectrodeModel, electrodeHeight},
			targetReferenceElectrodeModel -> First[
				PickList[
					sortedPreferredContainerModelsByHeight,
					sortedPreferredContainerModelHeights,
					RangeP[electrodeHeight * 1.3, electrodeHeight * 2]
				]
			]
		],
		{uniqueTargetReferenceElectrodeModels, referenceElectrodeLengths}
	];

	(* Resource pick the electrode storage containers *)
	referenceElectrodeStorageContainersResources = Link[Resource[
		Sample -> Lookup[selectedElectrodeContainerModels, #],
		Name -> CreateUUID[]
	]]& /@ targetReferenceElectrodeModelsWithReplicates;

	(* -- Tweezers -- *)
	(* Resource pick the tweezers *)
	tweezerResource = Resource[Sample -> Model[Item, Tweezer, "Straight flat tip tweezer"], Name -> CreateUUID[], Rent -> True];

	(* -- ElectrodeRack -- *)
	(* Resource pick the electrode imaging rack *)
	electrodeImagingRackResource = Resource[Sample -> Model[Container, Rack, "Electrode Imaging Holder for IKA Electrodes"], Name -> CreateUUID[], Rent -> True];

	(* Resource pick the reference electrode rack *)
	referenceElectrodeRackResource = Resource[Sample -> Model[Container, Rack, "Electrode Holder for IKA Reference Electrodes"], Name -> CreateUUID[], Rent -> True];

	(* -- Electrode Imaging Deck -- *)
	electrodeImagingDeck = Model[Container, Deck, "IKA Electrodes Imaging Deck"];

	(* -------------------- *)
	(* -- TIME ESTIMATES -- *)
	(* -------------------- *)

	(* -- reference electrode polishing time estimate -- *)
	(* We assume each polishing takes about 5 minutes *)
	polishingTime = Total[polishReferenceElectrode /. {True -> 1, False -> 0}] * 5 Minute;

	(* -- reference electrode washing time estimate -- *)
	(* We assume each washing cycle takes about 5 minutes *)
	washingTime = Total[Join[numberOfPrimaryWashings, numberOfSecondaryWashings] /. {Null -> 0}] * 5 Minute;

	(* -- reference electrode priming time estimate -- *)
	(* We assume each priming cycle takes about 5 minutes *)
	primingTime = Total[numberOfPrimings /. {Null -> 0}] * 5 Minute;

	(* -- reference electrode soaking time estimate -- *)
	(* We assume the total soaking time is twice of the max priming soaking time and the refill time is 10 minute for each reference electrode *)
	refillAndSoakingTime = Max[primingSoakTime] * 2 + Length[targetReferenceElectrodeModelsWithReplicates] * 10 Minute;

	(* -- resource picking estimate -- *)

	(*roughly calculate the time required to gather resources*)
	gatherResourcesTime = (20 Minute) * Length[targetReferenceElectrodeModelsWithReplicates];

	(* Request the fume hood *)
	fumeHoodModels = commonFumeHoodHandlingStationModels["Memoization"];
	fumeHoodResource = Resource[Instrument -> fumeHoodModels, Time -> (polishingTime + washingTime + primingTime + refillAndSoakingTime)];

	(* --------------------- *)
	(* -- PROTOCOL PACKET -- *)
	(* --------------------- *)

	(* Create our protocol packet. *)
	protocolPacket = Association[
		Type -> Object[Protocol,PrepareReferenceElectrode],
		Object -> CreateID[Object[Protocol,PrepareReferenceElectrode]],

		(* Reference Electrode Objects and Models *)
		Replace[SamplesIn] -> (Link[#, Protocols]&/@sourceReferenceElectrodesWithReplicates),
		Replace[ReferenceElectrodes] -> sourceReferenceElectrodeResources,
		Replace[TargetReferenceElectrodeModels] -> (Link[#]&/@targetReferenceElectrodeModelsWithReplicates),
		Replace[OriginReferenceElectrodeModels] -> sourceReferenceElectrodeModelsWithLinks,

		(* Reference Solutions *)
		Replace[ReferenceSolutions] -> referenceSolutionsField,

		(* FumeHood *)
		FumeHood -> Link[fumeHoodResource],

		(* Reference Electrode Polishing *)
		Replace[PolishReferenceElectrode] -> polishReferenceElectrode,
		Sandpaper -> Link[sandpaperResource],
		Replace[ReferenceElectrodeRustChecking] -> {},

		(* Reference Electrode Aspiration *)
		Replace[ReferenceElectrodeNeedsAspiration] -> referenceElectrodeNeedsAspirationField,
		WasteReferenceSolutionCollectionContainer -> wasteReferenceSolutionCollectionContainerResource,
		WasteReferenceSolutionCollectionSyringe -> wasteReferenceSolutionCollectionSyringeResource,
		WasteReferenceSolutionCollectionNeedle -> wasteReferenceSolutionCollectionNeedleResource,

		(* Reference Electrode Washing *)
		Replace[PrimaryWashingSolutions] -> primaryWashingSolutionResources,
		Replace[PrimaryWashingSolutionVolumes] -> primaryWashingSolutionVolumes,
		Replace[NumberOfPrimaryWashings] -> safeNumberOfPrimaryWashings,
		Replace[PrimaryWashingSyringes] -> primaryWashingSyringesField,
		Replace[PrimaryWashingSolutionCollectionContainers] -> primaryWashingSolutionCollectionContainersField,

		Replace[SecondaryWashingSolutions] -> secondaryWashingSolutionResources,
		Replace[SecondaryWashingSolutionVolumes] -> secondaryWashingSolutionVolumes,
		Replace[NumberOfSecondaryWashings] -> safeNumberOfSecondaryWashings,
		Replace[SecondaryWashingSyringes] -> secondaryWashingSyringesField,
		Replace[SecondaryWashingSolutionCollectionContainers] -> secondaryWashingSolutionCollectionContainersField,

		Replace[UniqueWashingSolutions] -> uniqueWashingSolutionsField,
		Replace[WashingSyringes] -> washingSyringeResources,
		Replace[WashingNeedles] -> washingNeedleResources,
		Replace[WashingSolutionCollectionContainers] -> uniqueWashingSolutionsCollectionContainersResources,

		(* Reference Electrode Preparation *)
		Replace[PrimingVolumes] -> primingVolume,
		Replace[NumberOfPrimings] -> numberOfPrimings,
		Replace[ReferenceElectrodePrimingSyringes] -> referenceElectrodePrimingSyringesField,
		Replace[ReferenceElectrodeReferenceSolutionCollectionContainers] -> referenceSolutionCollectionContainersField,

		Replace[ElectrodeRefillVolumes] -> referenceSolutionVolume,
		Replace[ReferenceElectrodeRefillSyringes] -> referenceElectrodeRefillSyringeResources,
		Replace[ReferenceElectrodeRefillNeedles] -> referenceElectrodeRefillNeedleResources,

		Replace[UniqueReferenceSolutions] -> uniqueReferenceSolutionsField,
		Replace[PrimingSyringes] -> primingSyringeResources,
		Replace[PrimingNeedles] -> primingNeedleResources,
		Replace[ReferenceSolutionCollectionContainers] -> uniqueReferenceSolutionsCollectionContainersResources,

		Replace[ReferenceElectrodePrimingSoakTimes] -> primingSoakTime,
		MaxPrimingSoakTime -> Max[primingSoakTime],
		Tweezers -> Link[tweezerResource],
		ElectrodeImagingRack -> Link[electrodeImagingRackResource],
		ElectrodeImagingDeck -> Link[electrodeImagingDeck],
		ReferenceElectrodeRack -> Link[referenceElectrodeRackResource],

		(* Storage Information *)
		Replace[ReferenceElectrodeStorageContainers] -> referenceElectrodeStorageContainersResources,


		(* this Preparation link is SUUUUUPER important for Engine to finish Resource Picking properly;
		 	assume that if prepared resources was sent in, it indexed to the models*)
		Replace[PreparedResources]->numReplicatesExpander[Link[myPreparedResourcePackets,Preparation]],

		(* checkpoints *)
		Replace[Checkpoints] -> {
			{"Picking Resources", gatherResourcesTime, "Reference electrodes, solutions, and other items required to execute this protocol are gathered from storage.", Resource[Operator->$BaselineOperator, Time -> gatherResourcesTime]},
			{"Clean Reference Electrodes", (polishingTime + washingTime), "The source reference electrodes are polished and washed.", Resource[Operator -> $BaselineOperator, Time -> (polishingTime + washingTime)]},
			{"Prime Reference Electrodes", primingTime, "The reference electrodes are primed.", Resource[Operator->$BaselineOperator, Time -> primingTime]},
			{"Fill and Soak Reference Electrodes", refillAndSoakingTime, "The reference electrodes are filled with reference solutions and soaked.",Resource[Operator->$BaselineOperator, Time -> refillAndSoakingTime]}
		},
		ResolvedOptions -> myCollapsedResolvedOptions,
		UnresolvedOptions -> myUnresolvedOptions,
		Replace[SamplesOutStorage] -> sampleOutStorage
	];

	(* ---------------------- *)
	(* -- CLEAN UP AND FRQ -- *)
	(* ---------------------- *)

	(* get all the resource "symbolic representations" *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs=DeleteDuplicates[Cases[Flatten[Values[protocolPacket]],_Resource,Infinity]];

	(* call fulfillableResourceQ on all resources we created *)
	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication,Engine],
		{True,{}},
		gatherTests,
		Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache -> cache],
		True,
		{Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->Result,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->Not[gatherTests],Cache -> cache],Null}
	];

	(* generate the tests rule *)
	testsRule=Tests->If[gatherTests,
		frqTests,
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule=Result->If[MemberQ[output,Result]&&TrueQ[fulfillable],
		protocolPacket,
		$Failed
	];

	(* Return our result. *)
	outputSpecification/.{resultRule,testsRule}
];

(* ====================== *)
(* == Sister Functions == *)
(* ====================== *)

(* ::Subsubsection::Closed:: *)
(*ExperimentPrepareReferenceElectrodeOptions*)

DefineOptions[ExperimentPrepareReferenceElectrodeOptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
			Description->"Indicates whether the function returns a table or a list of the options."
		}
	},
	SharedOptions :> {ExperimentPrepareReferenceElectrode}
];

(* == OVERLOAD 1: Take in target reference electrode models only == *)
ExperimentPrepareReferenceElectrodeOptions[
	myTargetReferenceElectrodeModels:ListableP[ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
	myOptions:OptionsPattern[ExperimentPrepareReferenceElectrodeOptions]
]:=Module[
	{listedOptions,preparedOptions,resolvedOptions},

	listedOptions=ToList[myOptions];

	(* Send in the correct Output option and remove OutputFormat option *)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}];

	resolvedOptions=ExperimentPrepareReferenceElectrode[myTargetReferenceElectrodeModels,preparedOptions];

	(* Return the option as a list or table *)
	If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table]&&MatchQ[resolvedOptions,{(_Rule|_RuleDelayed)..}],
		LegacySLL`Private`optionsToTable[resolvedOptions,ExperimentPrepareReferenceElectrode],
		resolvedOptions
	]
];

(* == OVERLOAD 2: Take in source target reference electrode objects/models and target reference electrode models == *)
ExperimentPrepareReferenceElectrodeOptions[
	mySourceReferenceElectrodes:ListableP[ObjectP[{Model[Item, Electrode, ReferenceElectrode], Object[Item, Electrode, ReferenceElectrode]}]],
	myTargetReferenceElectrodeModels:ListableP[ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
	myOptions:OptionsPattern[ExperimentPrepareReferenceElectrodeOptions]
]:=Module[
	{listedOptions,preparedOptions,resolvedOptions},

	listedOptions=ToList[myOptions];

	(* Send in the correct Output option and remove OutputFormat option *)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}];

	resolvedOptions=ExperimentPrepareReferenceElectrode[mySourceReferenceElectrodes,myTargetReferenceElectrodeModels,preparedOptions];

	(* Return the option as a list or table *)
	If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table]&&MatchQ[resolvedOptions,{(_Rule|_RuleDelayed)..}],
		LegacySLL`Private`optionsToTable[resolvedOptions,ExperimentPrepareReferenceElectrode],
		resolvedOptions
	]
];

(* == OVERLOAD 3: Take in Take in a pair of {sourceElectrode, targetModel} == *)
ExperimentPrepareReferenceElectrodeOptions[
	myPair:{
		ObjectP[{Model[Item, Electrode, ReferenceElectrode], Object[Item, Electrode, ReferenceElectrode]}],
		ObjectP[Model[Item, Electrode, ReferenceElectrode]]
	},
	myOptions:OptionsPattern[ExperimentPrepareReferenceElectrodeOptions]
]:=Module[
	{mySourceReferenceElectrode,myTargetReferenceElectrodeModel,listedOptions,preparedOptions,resolvedOptions},

	(* Get the source electrodes *)
	mySourceReferenceElectrode = First[myPair];

	(* Get the target electrode models *)
	myTargetReferenceElectrodeModel = Last[myPair];

	listedOptions=ToList[myOptions];

	(* Send in the correct Output option and remove OutputFormat option *)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}];

	resolvedOptions=ExperimentPrepareReferenceElectrode[{mySourceReferenceElectrode,myTargetReferenceElectrodeModel},preparedOptions];

	(* Return the option as a list or table *)
	If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table]&&MatchQ[resolvedOptions,{(_Rule|_RuleDelayed)..}],
		LegacySLL`Private`optionsToTable[resolvedOptions,ExperimentPrepareReferenceElectrode],
		resolvedOptions
	]
];

(* == OVERLOAD 4: Take in a list of {{sourceElectrode, targetModel}..} == *)
ExperimentPrepareReferenceElectrodeOptions[
	myPairedList:{{
		ObjectP[{Model[Item, Electrode, ReferenceElectrode], Object[Item, Electrode, ReferenceElectrode]}],
		ObjectP[Model[Item, Electrode, ReferenceElectrode]]
	}..},
	myOptions:OptionsPattern[ExperimentPrepareReferenceElectrodeOptions]
]:=Module[
	{mySourceReferenceElectrodes, myTargetReferenceElectrodeModels,listedOptions,preparedOptions,resolvedOptions},

	(* Get the source electrodes *)
	mySourceReferenceElectrodes = myPairedList[[All, 1]];

	(* Get the target electrode models *)
	myTargetReferenceElectrodeModels = myPairedList[[All, 2]];

	listedOptions=ToList[myOptions];

	(* Send in the correct Output option and remove OutputFormat option *)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}];

	resolvedOptions=ExperimentPrepareReferenceElectrode[mySourceReferenceElectrodes,myTargetReferenceElectrodeModels,preparedOptions];

	(* Return the option as a list or table *)
	If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table]&&MatchQ[resolvedOptions,{(_Rule|_RuleDelayed)..}],
		LegacySLL`Private`optionsToTable[resolvedOptions,ExperimentPrepareReferenceElectrode],
		resolvedOptions
	]
];

(* ::Subsubsection::Closed:: *)
(*ExperimentPrepareReferenceElectrodePreview*)

DefineOptions[ExperimentPrepareReferenceElectrodePreview,
	SharedOptions :> {ExperimentPrepareReferenceElectrode}
];

(* == OVERLOAD 1: Take in target reference electrode models only == *)
ExperimentPrepareReferenceElectrodePreview[
	myTargetReferenceElectrodeModels:ListableP[ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
	myOptions:OptionsPattern[ExperimentPrepareReferenceElectrodePreview]
]:=Module[
	{listedOptions},

	listedOptions=ToList[myOptions];

	ExperimentPrepareReferenceElectrode[myTargetReferenceElectrodeModels,ReplaceRule[listedOptions,Output->Preview]]
];

(* == OVERLOAD 2: Take in source target reference electrode objects/models and target reference electrode models == *)
ExperimentPrepareReferenceElectrodePreview[
	mySourceReferenceElectrodes:ListableP[ObjectP[{Model[Item, Electrode, ReferenceElectrode], Object[Item, Electrode, ReferenceElectrode]}]],
	myTargetReferenceElectrodeModels:ListableP[ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
	myOptions:OptionsPattern[ExperimentPrepareReferenceElectrodePreview]
]:=Module[
	{listedOptions},

	listedOptions=ToList[myOptions];

	ExperimentPrepareReferenceElectrode[mySourceReferenceElectrodes,myTargetReferenceElectrodeModels,ReplaceRule[listedOptions,Output->Preview]]
];

(* == OVERLOAD 3: Take in Take in a pair of {sourceElectrode, targetModel} == *)
ExperimentPrepareReferenceElectrodePreview[
	myPair:{
		ObjectP[{Model[Item, Electrode, ReferenceElectrode], Object[Item, Electrode, ReferenceElectrode]}],
		ObjectP[Model[Item, Electrode, ReferenceElectrode]]
	},
	myOptions:OptionsPattern[ExperimentPrepareReferenceElectrodePreview]
]:=Module[
	{mySourceReferenceElectrode,myTargetReferenceElectrodeModel,listedOptions},

	(* Get the source electrodes *)
	mySourceReferenceElectrode = First[myPair];

	(* Get the target electrode models *)
	myTargetReferenceElectrodeModel = Last[myPair];

	listedOptions=ToList[myOptions];

	ExperimentPrepareReferenceElectrode[{mySourceReferenceElectrode,myTargetReferenceElectrodeModel},ReplaceRule[listedOptions,Output->Preview]]
];

(* == OVERLOAD 4: Take in a list of {{sourceElectrode, targetModel}..} == *)
ExperimentPrepareReferenceElectrodePreview[
	myPairedList:{{
		ObjectP[{Model[Item, Electrode, ReferenceElectrode], Object[Item, Electrode, ReferenceElectrode]}],
		ObjectP[Model[Item, Electrode, ReferenceElectrode]]
	}..},
	myOptions:OptionsPattern[ExperimentPrepareReferenceElectrodePreview]
]:=Module[
	{mySourceReferenceElectrodes,myTargetReferenceElectrodeModels,listedOptions},

	(* Get the source electrodes *)
	mySourceReferenceElectrodes = myPairedList[[All, 1]];

	(* Get the target electrode models *)
	myTargetReferenceElectrodeModels = myPairedList[[All, 2]];

	listedOptions=ToList[myOptions];

	ExperimentPrepareReferenceElectrode[mySourceReferenceElectrodes,myTargetReferenceElectrodeModels,ReplaceRule[listedOptions,Output->Preview]]
];

(* ::Subsubsection::Closed:: *)
(*ValidExperimentPrepareReferenceElectrodeQ*)

DefineOptions[ValidExperimentPrepareReferenceElectrodeQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentPrepareReferenceElectrode}
];

(* == OVERLOAD 1: Take in target reference electrode models only == *)
ValidExperimentPrepareReferenceElectrodeQ[
	myTargetReferenceElectrodeModels:ListableP[ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
	myOptions:OptionsPattern[ValidExperimentRamanSpectroscopyQ]
]:=Module[
	{listedInput,listedOptions,preparedOptions,functionTests,initialTestDescription,allTests,safeOps,verbose,outputFormat,result},

	listedInput=ToList[myTargetReferenceElectrodeModels];
	listedOptions=ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Tests],{Verbose,OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=ExperimentPrepareReferenceElectrode[myTargetReferenceElectrodeModels,preparedOptions];

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
	safeOps=SafeOptions[ValidExperimentPrepareReferenceElectrodeQ,Normal@KeyTake[listedOptions,{Verbose,OutputFormat}]];
	{verbose,outputFormat}=Lookup[safeOps,{Verbose,OutputFormat}];

	(* Run the tests as requested and return just the summary not the association if OutputFormat->TestSummary*)
	Lookup[
		RunUnitTest[
			<|"ExperimentPrepareReferenceElectrode"->allTests|>,
			Verbose->verbose,
			OutputFormat->outputFormat
		],
		"ExperimentPrepareReferenceElectrode"
	]
];

(* == OVERLOAD 2: Take in source target reference electrode objects/models and target reference electrode models == *)
ValidExperimentPrepareReferenceElectrodeQ[
	mySourceReferenceElectrodes:ListableP[ObjectP[{Model[Item, Electrode, ReferenceElectrode], Object[Item, Electrode, ReferenceElectrode]}]],
	myTargetReferenceElectrodeModels:ListableP[ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
	myOptions:OptionsPattern[ValidExperimentRamanSpectroscopyQ]
]:=Module[
	{listedInput,listedOptions,preparedOptions,functionTests,initialTestDescription,allTests,safeOps,verbose,outputFormat,result},

	listedInput=Join[ToList[myTargetReferenceElectrodeModels], ToList[myTargetReferenceElectrodeModels]];
	listedOptions=ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Tests],{Verbose,OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=ExperimentPrepareReferenceElectrode[mySourceReferenceElectrodes, myTargetReferenceElectrodeModels,preparedOptions];

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
	safeOps=SafeOptions[ValidExperimentPrepareReferenceElectrodeQ,Normal@KeyTake[listedOptions,{Verbose,OutputFormat}]];
	{verbose,outputFormat}=Lookup[safeOps,{Verbose,OutputFormat}];

	(* Run the tests as requested and return just the summary not the association if OutputFormat->TestSummary*)
	Lookup[
		RunUnitTest[
			<|"ExperimentPrepareReferenceElectrode"->allTests|>,
			Verbose->verbose,
			OutputFormat->outputFormat
		],
		"ExperimentPrepareReferenceElectrode"
	]
];

(* == OVERLOAD 3: Take in Take in a pair of {sourceElectrode, targetModel} == *)
ValidExperimentPrepareReferenceElectrodeQ[
	myPair:{
		ObjectP[{Model[Item, Electrode, ReferenceElectrode], Object[Item, Electrode, ReferenceElectrode]}],
		ObjectP[Model[Item, Electrode, ReferenceElectrode]]
	},
	myOptions:OptionsPattern[ValidExperimentRamanSpectroscopyQ]
]:=Module[
	{mySourceReferenceElectrode,myTargetReferenceElectrodeModel,listedInput,listedOptions,preparedOptions,functionTests,initialTestDescription,allTests,safeOps,verbose,outputFormat,result},

	(* Get the source electrodes *)
	mySourceReferenceElectrode = First[myPair];

	(* Get the target electrode models *)
	myTargetReferenceElectrodeModel = Last[myPair];

	listedInput={mySourceReferenceElectrode, myTargetReferenceElectrodeModel};
	listedOptions=ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Tests],{Verbose,OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=ExperimentPrepareReferenceElectrode[{mySourceReferenceElectrode, myTargetReferenceElectrodeModel},preparedOptions];

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
	safeOps=SafeOptions[ValidExperimentPrepareReferenceElectrodeQ,Normal@KeyTake[listedOptions,{Verbose,OutputFormat}]];
	{verbose,outputFormat}=Lookup[safeOps,{Verbose,OutputFormat}];

	(* Run the tests as requested and return just the summary not the association if OutputFormat->TestSummary*)
	Lookup[
		RunUnitTest[
			<|"ExperimentPrepareReferenceElectrode"->allTests|>,
			Verbose->verbose,
			OutputFormat->outputFormat
		],
		"ExperimentPrepareReferenceElectrode"
	]
];

(* == OVERLOAD 4: Take in a list of {{sourceElectrode, targetModel}..} == *)
ValidExperimentPrepareReferenceElectrodeQ[
	myPairedList:{{
		ObjectP[{Model[Item, Electrode, ReferenceElectrode], Object[Item, Electrode, ReferenceElectrode]}],
		ObjectP[Model[Item, Electrode, ReferenceElectrode]]
	}..},
	myOptions:OptionsPattern[ValidExperimentRamanSpectroscopyQ]
]:=Module[
	{mySourceReferenceElectrodes,myTargetReferenceElectrodeModels,listedInput,listedOptions,preparedOptions,functionTests,initialTestDescription,allTests,safeOps,verbose,outputFormat,result},

	(* Get the source electrodes *)
	mySourceReferenceElectrodes = myPairedList[[All, 1]];

	(* Get the target electrode models *)
	myTargetReferenceElectrodeModels = myPairedList[[All, 2]];

	listedInput=Join[mySourceReferenceElectrodes, myTargetReferenceElectrodeModels];
	listedOptions=ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Tests],{Verbose,OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=ExperimentPrepareReferenceElectrode[mySourceReferenceElectrodes, myTargetReferenceElectrodeModels,preparedOptions];

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
	safeOps=SafeOptions[ValidExperimentPrepareReferenceElectrodeQ,Normal@KeyTake[listedOptions,{Verbose,OutputFormat}]];
	{verbose,outputFormat}=Lookup[safeOps,{Verbose,OutputFormat}];

	(* Run the tests as requested and return just the summary not the association if OutputFormat->TestSummary*)
	Lookup[
		RunUnitTest[
			<|"ExperimentPrepareReferenceElectrode"->allTests|>,
			Verbose->verbose,
			OutputFormat->outputFormat
		],
		"ExperimentPrepareReferenceElectrode"
	]
];

(* ========================================= *)
(* == prepareReferenceElectrodeTestHelper == *)
(* ========================================= *)

(* Conditionally returns appropriate tests based on the number of failing samples and the gather tests boolean
	Inputs:
		testFlag - Indicates if we should actually make tests
		allSamples - The input samples
		badSamples - Samples which are invalid in some way
		testDescription - A description of the sample invalidity check
			- must be formatted as a template with an `1` which can be replaced by a list of samples or "all input samples"
	Outputs:
		out: {(_Test|_Warning)...} - Tests for the good and bad samples - if all samples fall in one category, only one test is returned *)

prepareReferenceElectrodeTestHelper[testFlag:False,testHead:(Test|Warning),allSamples_,badSamples_,testDescription_,cache_]:={};

prepareReferenceElectrodeTestHelper[testFlag:True,testHead:(Test|Warning),allSamples:{PacketP[]..},badSamples:{PacketP[]...},testDescription_String,cache_]:=Module[{
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
		MatchQ[numberOfBadSamples,0],{testHead[StringTemplate[testDescription]["all input reference electrodes"],True,True]},

		(* All samples are bad *)
		MatchQ[numberOfBadSamples,numberOfSamples],{testHead[StringTemplate[testDescription]["all input reference electrodes"],False,True]},

		(* Mixed samples *)
		True,
		{
			(* Passing Test *)
			testHead[StringTemplate[testDescription][ObjectToString[goodObjects,Cache->cache]],True,True],
			(* Failing Test *)
			testHead[StringTemplate[testDescription][ObjectToString[badObjects,Cache->cache]],False,True]
		}
	]
];