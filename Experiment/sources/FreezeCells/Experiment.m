(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*Options*)


DefineOptions[ExperimentFreezeCells,
	Options:>{
		
		IndexMatching[
			IndexMatchingParent->Batches,
			
			(* ---------- Inputs ---------- *)
			
			{
				OptionName->Batches,
				Default->Automatic,
				AllowNull->False,
				Widget->Adder[
					Widget[
						Type->Object,
						Pattern:>ObjectP[Object[Sample]],
						PreparedSample->False
					],
					Orientation->Horizontal
				],
				Description->"The groups of samples that are processed simultaneously. Batches up to the maximum capacity of the experiment will be handled simultaneously (e.g. with multiple insulated coolers). However, if the number of samples exceeds the maximum capacity of the experiments, batches will be run sequentially.",
				ResolutionDescription->"Automatically set to a grouping that splits the samples based on compatible containers. Samples are grouped into the fewest number of batches, with the samples spread as evenly as possible amongst those batches. For example, if 24 samples of the same type in compatible containers are being frozen in a rack with 20 positions, the experiment freezes two batches of 12 samples.",
				Category->"General"
			},
			
			(* ---------- Method Definitions ---------- *)
			
			{
				OptionName->FreezingMethods,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>FreezeCellMethodP
				],
				Description->"The process used to freeze the batches. ControlledRateFreezer uses an instrument that electronically controls the sample temperature in a programmable way to freeze cells. InsulatedCooler methods use racks containing a coolant solution, which freezes cell when placed in a storage freezer.",
				ResolutionDescription->"Automatically set to ControlledRateFreezer unless one or more InsulatedCooler options are specified. Additionally, if samples are in cryogenic vials that cannot be frozen in a ControlledRateFreezer due to size, InsulatedCooler is used.",
				Category->"Method"
			},
			
			{
				OptionName->Instruments,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{
						Model[Instrument,ControlledRateFreezer],
						Object[Instrument,ControlledRateFreezer],
						Model[Instrument,Freezer],
						Object[Instrument,Freezer]
					}]
				],
				Description->"The cooling device used to lower the temperature of batches.",
				ResolutionDescription->"Automatically set to an appropriate instrument for ControlledRateFreezer methods, or to a deep freezer at -80 Celsius for InsulatedCooler methods.",
				Category->"Method"
			},
			
			(* ---------- ControlledRateFreezer Options ---------- *)
			
			{
				OptionName->FreezingProfiles,
				Default->Automatic,
				AllowNull->True,
				Widget->Adder[
					{
						"Temperature"->Widget[
							Type->Quantity,
							Pattern:>RangeP[-100 Celsius,20 Celsius],
							Units->{Celsius,{Celsius,Kelvin,Fahrenheit}}
						],
						"Time"->Widget[
							Type->Quantity,
							Pattern:>RangeP[0 Minute,$MaxExperimentTime],
							Units->{Minute,{Minute,Hour}}
						]
					},
					Orientation->Horizontal
				],
				Description->"The series of cooling steps applied to the batches. The specified time is cumulative and the profile linearly interpolates between the specified points. For example, between the points {0 Celsius,10 Minute} and {-60 Celsius,40 Minute}, the temperature would decrease at a constant rate of 2 Celsius/Minute. The last specified temperature is held until the samples are transported to the final storage. In the previous example, the samples would stay at -60 Celsius until removed from the instrument and moved to storage. Finally, an initial condition of {20 Celsius,0 Minute} is assumed.",
				ResolutionDescription->"Automatically set to a profile that reduces the temperature is to -2 Celsius to minimize DMSO toxicity with a hold to accommodate thermal lag from the cryogenic vial. The temperature is then reduced to -30 Celsius to start ice nucleation with an additional hold to allow the entire the sample to freeze. The temperature is finally decreased to -80 Celsius, below the intracellular colloidal glass transition with a safety margin. At the glass transition temperature, cells cannot respond osmotically to ice formation and no free water is available to form intracellular ice.",
				Category->"Controlled Rate Freezing"
			},
			
			{
				OptionName->FreezingRates,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0.01 Celsius/Minute,2 Celsius/Minute],
					Units->CompoundUnit[{1,{Celsius,{Celsius,Kelvin,Fahrenheit}}},{-1,{Minute,{Minute,Hour}}}]
				],
				Description->"The decrease in temperature per unit time for each batch if cooling at a constant rate is desired.",
				ResolutionDescription->"Automatically set to a value that would allow ResidualTemperature to be reached in the specified Duration for ControlledRateFreezer methods.",
				Category->"Controlled Rate Freezing"
			},
			
			{
				OptionName->Durations,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Minute,$MaxExperimentTime],
					Units->{Minute,{Minute,Hour}}
				],
				Description->"The amount of time the batch will be cooled at FreezingRate.",
				ResolutionDescription->"Automatically set to a duration that would allow ResidualTemperature to be reached at the specified FreezingRate for ControlledRateFreezer methods.",
				Category->"Controlled Rate Freezing"
			},
			
			{
				OptionName->ResidualTemperatures,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[-100 Celsius,20 Celsius],
					Units->{Celsius,{Celsius,Kelvin,Fahrenheit}}
				],
				Description->"The final temperature at which the batches will be kept before moving to final storage.",
				ResolutionDescription->"Automatically set to a temperature that would be reached in the specified Duration at the specified FreezingRate for ControlledRateFreezer methods.",
				Category->"Controlled Rate Freezing"
			},
			
			(* ---------- InsulatedCooler Options ---------- *)
			
			{
				OptionName->FreezingContainers,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Container,Rack,InsulatedCooler],Object[Container,Rack,InsulatedCooler]}]
				],
				Description->"The cooling apparatus that will be used to freeze the batches.",
				ResolutionDescription->"Automatically set to a container that can accommodate the vials containing the specified samples for InsulatedCooler methods.",
				Category->"Insulated Cooling"
			},
			
			{
				OptionName->FreezingConditions,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[Freezer,DeepFreezer]
				],
				Description->"The type of freezer that the FreezingContainer will be stored in during the cell freezing process.",
				ResolutionDescription->"Automatically set to -80 Celsius for InsulatedCooler methods.",
				Category->"Insulated Cooling"
			},
			
			{
				OptionName->Coolants,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Description->"Liquid that fills the chamber of the insulated cooler in which the sample rack is immersed. The coolant transports heat away from the samples during freezing at a controlled rate characteristic to the coolant fluid.",
				ResolutionDescription->"Automatically set to isopropanol for InsulatedCooler methods.",
				Category->"Insulated Cooling"
			},
			
			{
				OptionName->CoolantVolumes,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Milliliter,500 Milliliter],
					Units->{Milliliter,{Milliliter,Liter}}
				],
				Description->"The amount of cooling liquid that will be placed in the coolant chamber of the FreezingContainers.",
				ResolutionDescription->"Automatically set to the manufacturer recommended volume for InsulatedCooler methods.",
				Category->"Insulated Cooling"
			},
			
			(* ---------- Storage Options ---------- *)
			
			{
				OptionName->TransportConditions,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>TransportColdConditionP
				],
				Description->"The temperature at which the batches are transported from the instrument to the final storage container.",
				ResolutionDescription->"Automatically set to a closest temperature above the temperature of the samples at the end of the protocol for ControlledRateFreezer methods. For example, if the temperature of the samples are -60 Celsius before transport, -40 Celsius container are used to move the samples to their final destination to avoid further cooling of samples. For InsulatedCooler methods, the samples are transported in the insulated cooler in which they are frozen, since the rack contains a large amount to coolant solution at the final temperature of the samples.",
				Category->"Storage"
			}
		],
		
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->StorageConditions,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>CellStorageTypeP
				],
				Description->"The long-term storage type for the sample after freezing.",
				ResolutionDescription->"Automatically set to cryogenic storage for all samples.",
				Category->"Storage"
			}
		],
		
		{
			OptionName->UploadResources,
			Default->True,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Description->"Indicates if the resource blobs from the resource packets function should actually be uploaded.",
			Category->"Hidden"
		},
		{
			OptionName->ReturnPrimitives,
			Default->False,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Description->"Indicates if Object[Primitive, FreezeCell] objects should be returned instead of a protocol object.",
			Category->"Hidden"
		},
		ProtocolOptions,
		{
			OptionName->FastTrack,
			Default->False,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Description->"Indicates if certain checks should be skipped for performance.",
			Category->"Hidden"
		}
	}
];


(* ::Subsection:: *)
(*Main Overload*)


Error::FreezeCellsObjectNotInDatabase="Specified objects `1` cannot be found in the database. Please verify the objects' IDs or names, or enter the objects into the database.";
Error::FreezeCellsInvalidTemplate="Specified template has a different input length than the current experiment. Because of this difference, Batches cannot be templated from the specified protocol. Please specify a template whose input length is the same as the current experiment.";

ExperimentFreezeCells[mySamples:{ObjectP[Object[Sample]]..},myOptions:OptionsPattern[]]:=Module[
	{
		(* Framework Variables *)
		outputSpecification,output,gatherTests,listedSamples,listedOptions,safeOps,safeOpsTests,validLengths,validLengthTests,templatedOptions,templateTests,inheritedOptions,expandedSafeOps,cacheBall,resolvedOptionsResult,resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,resourcePackets,resourcePacketTests,
		
		(* Manual option length checks and expansion *)
		indexMatchedOptions,indexMatchedOptionsAssociation,indexMatchedOptionLengths,validNestedOptionLengthsQ,longestOptions,invalidLengthOptions,invalidLengthOptionLengths,validNestedOptionLengthsTest,expandedBatchOptions,combinedExpandedOptions,
		
		(* Error checking *)
		templatedOptionsWithUpdatedBatches,allObjectInputs,validObjectsQList,failedObjects,objectsInDatabaseTest,
		
		(* Cacheball Variables *)
		cache,initialInstruments,controlledRateFreezerModels,freezerModels,portableFreezerModels,controlledRateFreezerRackModels,initialInsulatedCoolers,initialCoolantObjects,insulatedCoolerModels,initialCoolantModels,transportConditions,storageConditions,namedObjects,downloadedPackets,
		
		(* Preview plots *)
		previewPlots
	},
	
	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];
	
	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	
	(* Remove temporal links and named objects. *)
	{listedSamples,listedOptions}=removeLinks[ToList[mySamples],ToList[myOptions]];
	
	(* Call SafeOptions to make sure all options match pattern *)
	{safeOps,safeOpsTests}=If[
		gatherTests,
		SafeOptions[ExperimentFreezeCells,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentFreezeCells,listedOptions,AutoCorrect->False],{}}
	];
	
	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[
		MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->safeOpsTests,
			Options->$Failed,
			Preview->Null
		}]
	];
	
	(* ---------- Check Option Lengths ---------- *)
	
	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[
		gatherTests,
		ValidInputLengthsQ[ExperimentFreezeCells,{listedSamples},listedOptions,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentFreezeCells,{listedSamples},listedOptions],{}}
	];
	
	(* List all of the options that are index matched to Batches -- we have to expand/length check these manually *)
	indexMatchedOptions=Prepend[
		ToExpression/@("OptionName"/.Cases[OptionDefinition[ExperimentFreezeCells],KeyValuePattern["IndexMatchingParent"->"Batches"]]),
		Batches
	];
	
	(* Make an association from the index matched options *)
	indexMatchedOptionsAssociation=If[
		
		(* Check if FreezingProfiles is a "singleton". Since it is a nested list when it is in singleton form we need to ensure that a single profile is counted as one regardless of length so we are replacing it with a list of one thing -- also we have to list everything because singleton values for objects return the objects' number of parts. So if Instruments -> Object[Instrument, ControlledRateFreezer, "Coldfinger"] is specified, it returns a length of 3, which is not what we want *)
		MatchQ[Lookup[listedOptions,FreezingProfiles],{{UnitsP[1 Celsius],UnitsP[1 Minute]}..}],
		Append[
			KeyDrop[ToList[#]&/@KeyTake[listedOptions,indexMatchedOptions],FreezingProfiles],
			FreezingProfiles->{Lookup[listedOptions,FreezingProfiles]}
		],
		
		(* Otherwise, just take all the keys *)
		ToList[#]&/@KeyTake[listedOptions,indexMatchedOptions]
	];
	
	(* Find the option lengths -- this will return the length options only once so we should have a list of option lengths where each length only appears once. Singleton options will return 1 since we put everything in a list, and lists will return their lengths *)
	indexMatchedOptionLengths=DeleteDuplicates[Length[First[#]]&/@Tally[indexMatchedOptionsAssociation]];
	
	(* Check the lengths of Batches and FreezingProfiles manually -- ValidInputLengthsQ does not check any nested list options so you can specify 10 batches with 3 instruments and it will return True. So we need to manually check here to ensure that lengths of Batches and FreezingProfiles are not incorrect *)
	validNestedOptionLengthsQ=Which[
		
		(* If ValidInputLengthsQ failed already, we are failing anyways so return false *)
		!validLengths,False,
		
		(* If the list only contains no elements, then no options were specified *)
		Length[indexMatchedOptionLengths]==0,True,
		
		(* If the list only contains one element, everything is the same length *)
		Length[indexMatchedOptionLengths]==1,True,
		
		(* If the list only contains two elements, everything is only valid if one of those elements is one, i.e. we have a mix of singleton options and same length lists *)
		Length[indexMatchedOptionLengths]==2,MemberQ[indexMatchedOptionLengths,1],
		
		(* Otherwise, we have a list that contains at least two different lengths *)
		True,False
	];
	
	(* Find the longest options *)
	longestOptions=If[
		!validNestedOptionLengthsQ,
		Flatten[PositionIndex[Length[#]&/@indexMatchedOptionsAssociation][Max[indexMatchedOptionLengths]]]
	];
	
	(* Make a list of invalid options if we have them *)
	invalidLengthOptions=If[
		!validNestedOptionLengthsQ,
		Module[{incorrectLengths},
			
			(* Find the option lengths that aren't singleton or the longest *)
			incorrectLengths=Cases[indexMatchedOptionLengths,Except[0|Max[indexMatchedOptionLengths]]];
			
			(* Return the options with those lengths *)
			Flatten[(PositionIndex[Length[#]&/@indexMatchedOptionsAssociation][#])&/@incorrectLengths]
		]
	];
	
	(* Find the lengths for the invalid options *)
	invalidLengthOptionLengths=If[
		!validNestedOptionLengthsQ,
		Lookup[Length[#]&/@indexMatchedOptionsAssociation,invalidLengthOptions]
	];
	
	(* If we have any length issues and messages are on, throw an error -- I decided to return only the first of the longest options since that what ValidInputLengthsQ does *)
	If[
		validLengths&&!validNestedOptionLengthsQ&&!gatherTests,
		Message[Error::InputLengthMismatch,invalidLengthOptions,invalidLengthOptionLengths,First[longestOptions],Max[indexMatchedOptionLengths]]
	];
	
	(* If gathering tests, create a passing or failing test *)
	validNestedOptionLengthsTest=Which[
		!gatherTests,Nothing,
		gatherTests&&validNestedOptionLengthsQ,Test["Options index-matched to Batches are of the same length:",True,True],
		gatherTests&&!validNestedOptionLengthsQ,Test["Options index-matched to Batches are of the same length:",True,False]
	];
	
	(* If option lengths are invalid return $Failed or the tests up to this point *)
	If[
		Or[!validLengths,!validNestedOptionLengthsQ],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,validNestedOptionLengthsTest],
			Options->$Failed,
			Preview->Null
		}]
	];
	
	(* ---------- Template Options ---------- *)
	
	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests}=If[
		gatherTests,
		ApplyTemplateOptions[ExperimentFreezeCells,{listedSamples},listedOptions,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentFreezeCells,{listedSamples},listedOptions],Null}
	];
	
	(* Return early if the template cannot be used - will only occur if the template object does not exist *)
	If[
		MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,validNestedOptionLengthsTest,templateTests],
			Options->$Failed,
			Preview->Null
		}]
	];
	
	(* If template was specified, replace batches from the templated options since that option is input sample specific *)
	templatedOptionsWithUpdatedBatches=Which[
		
		(* If no template, do nothing *)
		!KeyExistsQ[Association@@templatedOptions,Template],templatedOptions,
		
		(* If the lengths of samples do not match, fail *)
		!SameLengthQ[Flatten[Lookup[templatedOptions,Batches]],mySamples],$Failed,
		
		(* Otherwise, update batches in templated options *)
		True,Module[{templateSamples,batches,batchesWithIndices,updatedBatches},
			
			(* Get the samples from the template *)
			templateSamples=Download[Lookup[templatedOptions,Template],SamplesIn[Object]];
			
			(* Get the batches from template -- depending on the number of batches, collapsing them will either return a list of lists, or just a single list for a single batch. We need to check the pattern and make sure we have the right kind of listiness *)
			batches=If[
				MatchQ[Lookup[templatedOptions,Batches],{ObjectP[Object[Sample]]..}],
				Lookup[templatedOptions,{Batches}],
				Lookup[templatedOptions,Batches]
			];
			
			(* Find the indices of samples in batches -- this is a basically batches but with the sample index instead of sample object *)
			batchesWithIndices=Function[batch,Flatten[Position[templateSamples,#]&/@batch]]/@batches;
			
			(* Replace the indexed batches with the current samples *)
			updatedBatches=Function[batch,Flatten[Take[listedSamples,{#}]&/@batch]]/@batchesWithIndices;
			
			(* Replace the batches in templated options with the current batches *)
			Normal[Append[KeyDrop[templatedOptions,Batches],<|Batches->updatedBatches|>]]
		]
	];
	
	(* If Batches doesn't make sense, throw an error *)
	If[
		FailureQ[templatedOptionsWithUpdatedBatches],
		Module[{},
			Message[Error::FreezeCellsInvalidTemplate];
			Return[$Failed]
		]
	];
	
	(* ---------- Expand All Options ---------- *)
	
	(* Replace our safe options with our inherited options from our template *)
	inheritedOptions=ReplaceRule[safeOps,templatedOptionsWithUpdatedBatches];
	
	(* Expand sample index-matching options only for options not index matched to Batches *)
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentFreezeCells,{listedSamples},Normal[KeyDrop[inheritedOptions,indexMatchedOptions]]]];
	
	(* Expand other options -- ExpandIndexMatchedInputs does not expand if the specified option is a nested list. So if Batches or FreezingProfiles are specified, nothing gets expanded. If anything else is specified, then everything gets expanded so we don't get consistent lists of the same size depending on which options are specified. Therefore we are expanding options index matched to Batches manually here *)
	expandedBatchOptions=Module[{optionsAssociation,maxLength},
		
		(* Make an association from the index matched options -- we templated our options so we need to prepare the association again in case something longer came in from the template *)
		optionsAssociation=ToList[#]&/@KeyTake[inheritedOptions,indexMatchedOptions];
		
		(* Find the longest option *)
		maxLength=If[
			
			(* Check if FreezingProfiles is a "singleton". Since it is a nested list when it is in singleton form we need to ensure that a single profile is counted as one regardless of length so we need to not count it *)
			MatchQ[Lookup[inheritedOptions,FreezingProfiles],{{UnitsP[1 Celsius],UnitsP[1 Minute]}..}],
			Max[Length[#]&/@KeyDrop[optionsAssociation,FreezingProfiles]],
			
			(* Otherwise, just find the longest option *)
			Max[Length[#]&/@optionsAssociation]
		];
		
		(* Return the expanded options *)
		Which[
			
			(* If we have a singleton FreezingProfiles, expand it separately since it is a list of lists *)
			MatchQ[#,{{UnitsP[1 Celsius],UnitsP[1 Minute]}..}],ConstantArray[#,maxLength],
			
			(* If the option is a list at max length, return as is *)
			MatchQ[#,_List]&&Length[#]==maxLength,#,
			
			(* Otherwise, take the first item and replicate as a list the length of max length -- we should only have cases where everything is either a list of the right size or we have a singleton in a list because we have already returned $Failed above if that was not the case *)
			True,ConstantArray[First[#],maxLength]
		]&/@optionsAssociation
	];
	
	(* Put all the options together *)
	combinedExpandedOptions=Join[expandedSafeOps,Normal[expandedBatchOptions]];
	
	(* ---------- Check Objects ---------- *)
	
	(* List of all options that can be objects *)
	allObjectInputs=Flatten[{
		mySamples,
		Cases[Lookup[combinedExpandedOptions,Instruments],Except[Automatic]],
		Cases[Lookup[combinedExpandedOptions,FreezingContainers],Except[Automatic]],
		Cases[Lookup[combinedExpandedOptions,Coolants],Except[Automatic]]
	}]/.Null->Nothing;
	
	(* Check if all objects are in the database *)
	validObjectsQList=If[Lookup[safeOps,FastTrack],
		ConstantArray[True,Length[allObjectInputs]],
		DatabaseMemberQ[allObjectInputs]
	];
	
	(* Find which objects failed *)
	failedObjects=Pick[allObjectInputs,validObjectsQList,False];
	
	(* If any objects don't exist, throw an error *)
	If[
		!And@@validObjectsQList,
		Message[Error::FreezeCellsObjectNotInDatabase,"\""<>StringRiffle[failedObjects,"\", \""]<>"\""]
	];
	
	(* Prepare a test *)
	objectsInDatabaseTest=If[
		And@@validObjectsQList,
		Test["All specified objects are in the database:",True,True],
		Test["All specified objects are in the database:",True,False]
	];
	
	(* If any objects are not in the database, return early *)
	If[
		!And@@validObjectsQList,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,validNestedOptionLengthsTest,templateTests,objectsInDatabaseTest],
			Options->$Failed,
			Preview->Null
		}]
	];
	
	(* ---------- Prepare the Cacheball ---------- *)
	
	(* Get the cache *)
	cache=Lookup[listedOptions,Cache];
	
	(* ----- Find any objects in options ----- *)
	
	(* Check if any instruments are specified as an object *)
	initialInstruments=Cases[Lookup[combinedExpandedOptions,Instruments],ObjectP[{Object[Instrument,ControlledRateFreezer],Object[Instrument,Freezer]}]];
	
	(* Check if InsulatedCoolers are specified as an object *)
	initialInsulatedCoolers=Cases[Lookup[combinedExpandedOptions,FreezingContainers],ObjectP[Object[Container,Rack,InsulatedCooler]]];
	
	(* Check if coolants are specified as objects *)
	initialCoolantObjects=Cases[Lookup[combinedExpandedOptions,Coolants],ObjectP[Object[Sample]]];
	
	(* ----- Find Models ----- *)
	
	(* Find all instrument models *)
	controlledRateFreezerModels=Join[
		Search[Model[Instrument,ControlledRateFreezer],Deprecated!=True],
		Cases[combinedExpandedOptions,ObjectP[Model[Instrument,ControlledRateFreezer]], Infinity]
	];
	freezerModels=Join[
		Search[Model[Instrument,Freezer],Deprecated!=True],
		Cases[combinedExpandedOptions,ObjectP[Model[Instrument,Freezer]], Infinity]
	];
	portableFreezerModels=DeleteDuplicates@Join[
		Search[Model[Instrument,PortableCooler],Deprecated!=True],
		Cases[combinedExpandedOptions,ObjectP[Model[Instrument,PortableCooler]], Infinity]
	];

	(* Find the racks for the controlled rate freezers *)
	controlledRateFreezerRackModels=Search[Model[Container,Rack],Footprint==ControlledRateFreezerRack&&Deprecated!=True];
	
	(* Find all insulated cooler models *)
	insulatedCoolerModels=Search[Model[Container,Rack,InsulatedCooler],Deprecated!=True];
	
	(* Get the coolant models -- we only will resolve to isopropanol unless specified so we are getting the specified models, and the isopropanol *)
	initialCoolantModels=Append[
		Cases[Lookup[combinedExpandedOptions,Coolants],ObjectP[Model[Sample]]],
		Model[Sample,"Isopropanol"]
	];
	
	(* Find all transport condition models *)
	transportConditions=Search[Model[TransportCondition]];
	
	(* Find all storage condition models *)
	storageConditions=Search[Model[StorageCondition]];
	
	(* Make a list of named objects -- these are objects that are used with a name in the code below. We don't technically need to do this but functions like Upload will need actual object IDs to find them in the database, and I don't like having a bunch of IDs around because they are not human readable. So, we are just going to include them in our download call to prevent additional download calls whenever they show up *)
	namedObjects={
		Model[User,Emerald,Operator,"Trainee"],
		Model[Item,Tweezer,"Cryogenic Vial Grippers"]
	};
	
	(* Download all packets *)
	downloadedPackets=Quiet[
		Flatten[{
			cache,
			Download[
				{
					(*1*)listedSamples,
					(*2*)controlledRateFreezerModels,
					(*3*)freezerModels,
					(*4*)portableFreezerModels,
					(*5*)controlledRateFreezerRackModels,
					(*6*)insulatedCoolerModels,
					(*7*)transportConditions,
					(*8*)storageConditions,
					(*9*)initialInstruments,
					(*10*)initialInsulatedCoolers,
					(*11*)initialCoolantModels,
					(*12*)initialCoolantObjects,
					(*13*)namedObjects
				},
				{
					(*1*){Packet[Name,Composition,Container,Status,RequestedResources,Model,State,Volume],Packet[Container[{Name,Model,RequestedResources,Status,Contents}]],Packet[Container[Model][{Name,MinTemperature,Footprint,Dimensions,RequestedResources,MaxVolume,Reusability,Products,RentByDefault}]]},
					(*2*){Packet[Name,MinCoolingRate,MaxCoolingRate,MinTemperature,Deprecated]},
					(*3*){Packet[Name,DefaultTemperature,Deprecated,MinTemperature,MaxTemperature]},
					(*4*){Packet[Name,Deprecated,MinTemperature,MaxTemperature]},
					(*5*){Packet[Name,Footprint,NumberOfPositions,Positions]},
					(*6*){Packet[Name,DefaultContainer,NumberOfPositions,Positions,RentByDefault],Packet[DefaultContainer[{Name,MaxVolume,ContainerMaterials,RentByDefault}]]},
					(*7*){Packet[Name,TransportLightSensitive,TransportTemperature,TransportCondition]},
					(*8*){Packet[Name,StorageCondition,Temperature]},
					(*9*){Packet[Name,Model,MinCoolingRate,MaxCoolingRate,MinTemperature,Status,Contents,ProvidedStorageCondition],Packet[Contents[[All]][[2]][{Name,NumberOfPositions,Positions}]]},
					(*10*){Packet[Name,DefaultTemperature,DefaultContainer,Status,NumberOfPositions,Positions,Model],Packet[Model[DefaultContainer][{Name,MaxVolume}]]},
					(*11*){Packet[Name,IncompatibleMaterials,State,MeltingPoint]},
					(*12*){Packet[Name,Composition,Volume,State,Model],Packet[Composition[[All,2]][{Name,IncompatibleMaterials}]],Packet[Model[{Name,IncompatibleMaterials,MeltingPoint}]]},
					(*13*){Packet[Status,Model,Name,RentByDefault]}
				},
				Cache->cache,
				Date->Now
			]
		}],
		Download::FieldDoesntExist
	];
	
	(* Prepare the cacheball *)
	cacheBall=DeleteDuplicates[FlattenCachePackets[downloadedPackets]];
	
	(* ---------- Resolve Options ---------- *)
	
	(* Build the resolved options *)
	resolvedOptionsResult=If[
		
		(* If gathering tests *)
		gatherTests,
		Module[{},
			
			(* Resolve options *)
			{resolvedOptions,resolvedOptionsTests}=resolveExperimentFreezeCellsOptions[listedSamples,ReplaceRule[combinedExpandedOptions,{Cache->cacheBall,Output->{Result,Tests}}]];
			
			(* Gathering tests silences any messages being thrown. Therefore, we have to run the tests to see if we encountered a failure *)
			If[
				RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
				{resolvedOptions,resolvedOptionsTests},
				$Failed
			]
		],
		
		(* If not gathering tests, check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentFreezeCellsOptions[listedSamples,ReplaceRule[combinedExpandedOptions,{Cache->cacheBall,Output->Result}]],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];
	
	(* Collapse the resolved options *)
	collapsedResolvedOptions=CollapseIndexMatchedOptions[
		ExperimentFreezeCells,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];
	
	(* If option resolution failed, return early *)
	If[
		MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,validNestedOptionLengthsTest,templateTests,objectsInDatabaseTest,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentFreezeCells,collapsedResolvedOptions],
			Preview->Null
		}]
	];
	
	(* ---------- Prepare Resource Packets ---------- *)
	
	(* Prepare the resource packets *)
	{resourcePackets,resourcePacketTests}=Which[
		
		(* If both Result and Tests are requested *)
		MemberQ[output,Result]&&gatherTests,freezeCellsResourcePackets[listedSamples,combinedExpandedOptions,resolvedOptions,Cache->cacheBall,Output->{Result,Tests}],
		
		(* If only Result is requested *)
		MemberQ[output,Result]&&!gatherTests,{freezeCellsResourcePackets[listedSamples,combinedExpandedOptions,resolvedOptions,Cache->cacheBall,Output->Result],{}},
		
		(* If only Tests are requested *)
		gatherTests,{{},freezeCellsResourcePackets[listedSamples,combinedExpandedOptions,resolvedOptions,Cache->cacheBall,Output->Tests]},
		
		(* Otherwise, skip as we are asked for some combination of Preview and Options, neither of which need resource packets*)
		True,{Null,Null}
	];
	
	(* Prepare preview if needed *)
	previewPlots=If[
		MemberQ[output,Preview],
		freezeCellsPreviewGenerator[resolvedOptions,Cache->cacheBall]
	];
	
	(* If we don't have to return a protocol object, return early *)
	If[
		!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result->Null,
			Tests->Flatten[{safeOpsTests,validLengthTests,validNestedOptionLengthsTest,templateTests,objectsInDatabaseTest,resolvedOptionsTests,resourcePacketTests}],
			Options->RemoveHiddenOptions[ExperimentFreezeCells,collapsedResolvedOptions],
			Preview->previewPlots
		}]
	];
	
	(* If told to return the raw resource packets, do that. *)
	(* NOTE: We are returning the non-collapsed options here. *)
	If[MatchQ[Lookup[safeOps,UploadResources],False],
		Return[outputSpecification/.{
			Result->resourcePackets,
			Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options->resolvedOptions,
			Preview->Null,
			Simulation->Null
		}]
	];
	
	(* If we have to return the result, call UploadProtocol to prepare our protocol packet and upload it if asked *)
	protocolObject=If[
		!MatchQ[resourcePackets,$Failed]&&!MatchQ[resolvedOptionsResult,$Failed],
		ECL`InternalUpload`UploadProtocol[
			resourcePackets,
			Upload->Lookup[combinedExpandedOptions,Upload],
			Confirm->Lookup[combinedExpandedOptions,Confirm],
			Email->Lookup[combinedExpandedOptions,Email],
			ParentProtocol->Lookup[combinedExpandedOptions,ParentProtocol],
			ConstellationMessage->{Object[Protocol,FreezeCells]},
			Cache->cacheBall
		],
		$Failed
	];
	
	(* Return requested output *)
	outputSpecification/.{
		Result->protocolObject,
		Tests->Flatten[{safeOpsTests,validLengthTests,validNestedOptionLengthsTest,templateTests,objectsInDatabaseTest,resolvedOptionsTests,resourcePacketTests}],
		Options->RemoveHiddenOptions[ExperimentFreezeCells,collapsedResolvedOptions],
		Preview->previewPlots
	}
];

(* ::Subsection:: *)
(*Container Overload*)

ExperimentFreezeCells[myContainers:{(ObjectP[{Object[Container],Object[Sample]}]|{LocationPositionP,_String|ObjectP[Object[Container]]})..},myOptions:OptionsPattern[]]:=Module[
	{
		listedContainers,listedOptions,outputSpecification,sampleCache,output,gatherTests,cache,containerToSampleResult,containerToSampleOutput,samples,sampleOptions,containerToSampleTests
	},
	
	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];
	
	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	
	(* Remove temporal links and named objects. *)
	{listedContainers,listedOptions}=removeLinks[ToList[myContainers],ToList[myOptions]];
	
	(* Get the cache from any previous experiments *)
	cache=Lookup[listedOptions,Cache,{}];
	
	(* Convert our given containers into samples and sample index-matched options *)
	containerToSampleResult=If[
		
		(* If gathering tests *)
		gatherTests,
		Module[{},
			
			(* Convert containers to samples *)
			{containerToSampleOutput,containerToSampleTests}=containerToSampleOptions[
				ExperimentFreezeCells,
				listedContainers,
				listedOptions,
				Output->{Result,Tests},
				Cache->cache
			];
			
			(* Gathering tests silences any messages being thrown. Therefore, we have to run the tests to see if we encountered a failure *)
			If[
				RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
				Null,
				$Failed
			]
		],
		
		(* If not gathering tests, check for Error::InvalidInput and Error::InvalidOption *)
		Check[
			containerToSampleOutput=containerToSampleOptions[
				ExperimentFreezeCells,
				listedContainers,
				listedOptions,
				Output->Result,
				Cache->cache
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
		]
	];
	
	(* If containerToSampleOptions failed, return $Failed *)
	If[
		MatchQ[containerToSampleResult,$Failed],
		outputSpecification/.{
			Result->$Failed,
			Tests->containerToSampleTests,
			Options->$Failed,
			Preview->Null
		},
		
		(* Otherwise *)
		Module[{},
			
			(* Split up our containerToSample result into the samples and sampleOptions *)
			{samples,sampleOptions, sampleCache}=containerToSampleOutput;
			
			(* Call our main function with our samples and converted options *)
			ExperimentFreezeCells[samples,ReplaceRule[sampleOptions,Cache->Flatten[{cache,sampleCache}]]]
		]
	]
];


(* ::Subsection:: *)
(*Options Resolver*)


DefineOptions[
	resolveExperimentFreezeCellsOptions,
	Options:>{
		HelperOutputOption,
		CacheOption
	},
	SharedOptions:>{ExperimentFreezeCells}
];

Error::FreezeCellsRepeatedSamples="Specified samples `1` are repeated. Please ensure that the input samples are only specified once.";
Error::FreezeCellsSolidSamples="Specified samples `1` are in a solid state. Please ensure that the input samples are not already frozen.";
Error::FreezeCellsIncompatibleContainers="Specified samples `1` are not in compatible containers. Please ensure that the input samples are in compatible cryogenic vials.";
Warning::FreezeCellsInstrumentalPrecision="The specified precision for option(s) `1` is beyond the capabilities of the instrument. The values of these options will be rounded from `2` to `3`.";
Error::FreezeCellsUnsupportedInstruments="The specified instruments \"`1`\" are either Retired or Deprecated. Please choose a different instrument.";
Error::FreezeCellsUnsupportedFreezingContainers="The specified freezing containers \"`1`\" are either Discarded or Deprecated. Please choose a different freezing container.";
Error::FreezeCellsTooManyBatches="The number of specified batches exceed the number of samples. Please specify more samples, or decrease the number of batches. Please note that the batches can be specified implicitly through other options such as FreezingMethods or Instruments. The longest option is used to determine how many batches are created.";
Warning::FreezeCellsIgnoredOptions="The specified options `1` are not consistent with the specified method for batches at indices `2`. These options will be ignored. Please specify a different method if you wish to utilize these options.";
Error::FreezeCellsIncompatibleOptions="Both `1` and options conflicting with these groups were specified at indices `2`. Please ensure that only `1` are specified at these indices, or remove any `1` to specify another type of processing.";
Error::FreezeCellsInvalidOptions="Specified `1` contain Null values for required options at indices `2`. Please ensure that options within `1` do not contain Null values for relevant options.";
Error::FreezeCellsInconsistentBatchContainers="The specified Batches have containers that are incompatible with each other at indices `1`. Please ensure that all containers in these batches can be used in a single insulated cooler rack or controlled rate freezer.";
Error::FreezeCellsBatchesMethodInconsistent="The specified Batches have containers that are incompatible with the specified FreezingMethods at indices `1`. Please ensure that all containers in these batches can be used with the specified FreezingMethods. Please note that this error will be shown if Variable Rate ControlledRateFreezer, Constant Rate ControlledRateFreezer, or InsulatedCooler options groups are specified without explicit specification of FreezingMethods.";
Error::FreezeCellsBatchesRackInconsistent="Specified Batches contains samples whose containers are not consistent with the specified `1` at indices `2`. Please ensure that the samples in these batches are in appropriate containers, or specify a different value for `1`.";
Error::FreezeCellsInvalidBatches="Specified Batches `1` samples `2`. Please `3`. ";
Error::FreezeCellsExcessiveBatchLengths="Specified batches at indices `1` are longer than the maximum possible that can be accommodated based on specified or default options. Please ensure these batches do not exceed `2` samples.";
Warning::FreezeCellsMixedMethodTypes="FreezingMethods contain more than one type of method without specification of Batches. Samples will be distributed between InsulatedCooler and ControlledRateFreezer batches to minimize the number of batches, and spread samples as evenly as possible between batches. Please specify Batches if you would like to control how samples are processed.";
Error::FreezeCellsInstrumentIncompatibleWithMethod="Specified instruments `1` are inconsistent with the specified method for indices `2`. Please specify instruments that are compatible with the method, or change the method.";
Warning::FreezeCellsIgnoredFreezerObject="Currently, ExperimentFreezeCells does not support specification of freezer locations. Specified freezer instruments `1` will be ignored, and the location selection will be handled by the storage system based on the specified instruments.";
Error::FreezeCellsInvalidConstantRateOptions="Specified `1` produce `2` values that do not match their pattern at indices `3`. Please ensure that the specified options produce a valid value for `2`.";
Error::FreezeCellsInconsistentConstantRateOptions="Specified FreezingRates, Durations and ResidualTemperatures are mathematically inconsistent at indices `1`. FreezingRate must be equal to (20 Celsius-ResidualTemperature) divided by Duration for each batch. Please specify values that satisfy this relationship, or specify one of more options as Automatic to calculate the remaining values.";
Warning::FreezeCellsProfileContainsWarmingStep="Specified FreezingProfiles contains a warming step at indices `1`. Please ensure that this step will not cause any issues for the freezing process.";
Error::FreezeCellsExcessiveCoolingRate="Specified FreezingProfiles contains steps that require a cooling rate above what can be achieved by the specified or default instrument at indices `1`. Please ensure that the cooling rates specified at these indices do not exceed `2`.";
Error::FreezeCellsIncompatibleFreezingContainers="Samples `1` are not compatible with the specified FreezingContainers. Please specify a different FreezingContainer, or remove these samples from the experiment.";
Error::FreezeCellsInvalidTimeSpecification="Specified FreezingProfiles have decreasing time steps at indices `1`. Please ensure that the specified times cumulative, and therefore increase over the course of the experiment.";
Error::FreezeCellsInvalidCoolantVolumeSpecification="CoolantVolumes were specified without Batches or FreezingContainers. Sample vials do not fit every type of insulated cooler, so Coolant Volumes cannot be used to determine FreezingContainers. Therefore, without specifying which sample vials are in a batch, or which insulated cooler is used with it, CoolantVolumes cannot be accounted for in calculations. Please specify Batches or FreezingContainers, or remove CoolantVolumes.";
Error::FreezeCellsInvalidCoolantState="Coolants `1` are not in liquid form. Please specify Coolants that are liquids at room temperature.";
Warning::FreezeCellsLowMeltingCoolant="Coolants `1` have melting points that are below the specified or default FreezingCondition. Upon freezing, the coolants may lose efficiency in heat transfer, and result in unpredictable cooling rates. Please ensure that the specified coolants are acceptable for this experiment.";
Error::FreezeCellsCoolantVolumeInvalid="The specified coolant volumes exceed the maximum volume of the freezing container at indices `1`. Please ensure that these volumes do not exceed `2`.";
Error::FreezeCellsIncompatibleFreezer="The specified FreezingConditions are not compatible with the specified Instruments at indices `1`. Please ensure that the specified FreezingConditions can be achieved by the specified Instruments.";
Warning::FreezeCellsInvalidTransportConditions="The specified TransportConditions are not set to Minus40 or Minus 80 at indices `1`. Please ensure that these conditions are acceptable for the transport of the frozen cells.";
Warning::FreezeCellsWarmingDuringTransport="The specified TransportConditions is above the final freezing temperature of the cells at indices `1` and will cause warming of the cells during transport. Please ensure that the warming during transport will not cause problems with the cells.";
Warning::FreezeCellsWarmStorageCondition="Specified StorageConditions for samples `1` are warmer than the final freezing temperature of the samples. Please ensure that the increase in temperature during final storage is acceptable for this experiment.";
Error::FreezeCellsCannotResolveBatches="Batches cannot be resolved because specified samples `1` because `2`. Please update FreezingMethods, or remove these samples.";
Error::FreezeCellsIncompatibleCoolants="Specified Coolants `1` are not chemically compatible with their freezing containers. Please specify different coolants.";
Error::FreezeCellsInsufficientCoolants="Specified Coolants `1` do not have enough volume for the experiment. Please specify different coolants, or Model[Sample] coolants that will be prepared during the experiment.";

resolveExperimentFreezeCellsOptions[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{
		(* Framework variables *)
		outputSpecification,output,gatherTests,messages,cache,invalidInputs,invalidOptionsList,invalidOptionErrors,invalidOptions,errors,allOptions,
		
		(* Initial options *)
		initialBatches,initialFreezingMethods,initialInstruments,initialFreezingProfiles,initialFreezingRates,initialDurations,initialResidualTemperatures,initialFreezingContainers,initialFreezingConditions,initialCoolants,initialCoolantVolumes,initialTransportConditions,initialStorageConditions,initialName,initialFastTrack,
		
		(* Cacheball extraction *)
		samplePackets,controlledRateFreezerModelPackets,controlledRateFreezerRackPackets,portableFreezerPackets,nonPortableFreezerPackets,insulatedCoolerModelPackets,transportConditionPackets,storageConditionPackets,sampleNames,
		
		(* Input validation checks *)
		uniqueInputsQ,duplicatedSamples,uniqueInputsTest,validInputsQ,discardedSamples,validInputTest,liquidInputsQ,solidSamples,liquidInputsTest,sampleContainers,sampleContainerModels,containerModels,controlledRateFreezerRacks,allowedRacks,allowedRackHeights,containerTolerance,containerHeights,compatibleContainersQList,compatibleContainersQ,incompatibleSamples,compatibleContainersTest,
		
		(* Option precision checks *)
		optionsWithSeparatedFreezingProfiles,freezingProfileNames,roundedOptions,reassembledRoundedOptions,precisionTests,optionsRounded,roundedOptionNames,roundedOptionValues,roundedFreezingRates,roundedDurations,roundedResidualTemperatures,roundedCoolantVolumes,roundedFreezingProfilesWithoutInitialCondition,roundedFreezingProfiles,
		
		(* Miscellaneous checks *)
		inputInstrumentPackets,validInstrumentsQ,invalidInstruments,validInstrumentTest,inputFreezingContainersPackets,validFreezingContainersQ,invalidFreezingContainers,totalBatchLengthValidQ,totalBatchLengthValidTest,validFreezingContainersTest,batchesWithDuplicateSamplesList,nonDuplicatedSamplesWithinBatchesQ,nonDuplicatedBatchesTest,samplesDuplicatedInSingleBatch,unspecifiedBatchSamples,specifiedBatchSamplesQ,specifiedBatchSamplesTest,unspecifiedSamplesInBatches,allSamplesInBatchesQ,allSamplesInBatchesTest,samplesDuplicatedAcrossBatches,nonDuplicatedSamplesAcrossBatchesQ,nonDuplicatedSamplesAcrossBatchesTest,
		
		(* Conflicting options checks *)
		specifiedOptionAssociation,ignoredOptionsSpecifiedList,ignoredOptionsSpecified,ignoredOptions,ignoredBatchIndices,incompatibleOptionsList,incompatibleOptionsQ,incompatibleOptionIndices,incompatibleOptions,incompatibleOptionsTest,groupedInvalidOptionsList,groupedInvalidOptionsQ,groupedInvalidOptionsIndices,groupedInvalidOptions,groupedInvalidOptionsTest,controlledRateFreezerCompatibleContainers,insulatedCoolerCompatibleContainers,batchedSamplePackets,batchedContainers,batchedContainerModels,validBatchContainersList,validBatchContainersQ,mixedBatchIndices,validBatchContainersTest,preResolvedMethods,universallyCompatibleContainers,controlledRateFreezerOnlyContainers,insulatedCoolerOnlyContainers,categorizedContainers,validMethodContainersList,validMethodContainersQ,invalidMethodContainerIndices,validMethodContainersTest,batchedContainerHeights,batchRackValidList,batchRackValidQ,invalidBatchRackIndices,invalidBatchRackOptions,batchRackValidTest,allowedRackMaxPositions,maxBatchLengths,batchLengthsValidList,batchLengthsValidQ,excessiveBatchIndices,excessiveBatchMaxLengths,batchLengthsValidTest,methodTypesValidQ,instrumentCompatibleList,instrumentCompatibleQ,incompatibleInstruments,incompatibleInstrumentIndices,instrumentCompatibleTest,freezerObjectSpecifiedQ,freezerObjects,constantRateOptionsValidList,constantRateOptionsValidQ,invalidConstantRateIndices,invalidConstantRateOptions,missingInvalidConstantRateOption,constantRateOptionsValidTest,constantRateOptionsConsistentQ,incompatibleConstantRateOptionsIndices,constantRateOptionsConsistentTest,freezingProfilesIncreasingTimeStepList,freezingProfilesIncreasingTimeStepQ,failedTimeStepIndices,freezingProfilesIncreasingTimeStepTest,freezingProfilesWarmingStepList,freezingProfilesWarmingStepQ,freezingProfilesWarmingStepIndices,validProfileCoolingRateList,validProfileCoolingRateQ,invalidProfileCoolingRateIndices,invalidMaxCoolingRates,validProfileCoolingRateTest,specifiedFreezingContainerModels,specifiedFreezingContainerHeights,freezingContainerSampleCompatibleQList,freezingContainerSampleCompatibleQ,freezingContainerIncompatibleSamples,freezingContainerSampleCompatibleTest,coolantVolumeSpecificationValidQ,coolantVolumeSpecificationValidTest,coolantStateValidQList,coolantStateValidQ,invalidCoolants,coolantStateValidTest,coolantMeltingPoints,freezingTemperatures,coolantTemperatureValidQList,coolantTemperatureValidQ,lowMeltingCoolants,validCoolantVolumesList,validCoolantVolumesQ,invalidCoolantVolumesIndices,invalidCoolantVolumesMax,validCoolantVolumesTest,transportConditionsValidList,validFreezingConditionList,validFreezingConditionQ,validFreezingConditionIndices,validFreezingConditionTest,transportConditionsValidQ,invalidTransportConditionsIndices,transportConditionsCoolingList,transportConditionsCoolingQ,coolingTransportConditionsIndices,
		
		(* Options resolver *)
		minRacksNeeded,sampleCompatibleRacks,rackSampleCount,allowedRacksMaxBatchSize,insulatedCoolerOnlyGroup,universalRackGroup,resolvedBatches,numberOfBatches,insulatedCoolerRestrictedBatchesValidQ,finalAssignedRacks,rackReplacementsValidQ,universalSamples,restrictedSamples,requiredRacks,batchesResolvableTest,expandedFreezingMethods,expandedInstruments,expandedFreezingProfiles,expandedFreezingRates,expandedDurations,expandedResidualTemperatures,expandedFreezingContainers,expandedFreezingConditions,expandedCoolants,expandedCoolantVolumes,expandedTransportConditions,resolvedRacks,resolvedFreezingMethods,resolvedInstruments,resolvedFreezingProfiles,resolvedFreezingRates,resolvedDurations,resolvedResidualTemperatures,resolvedFreezingContainers,resolvedFreezingConditions,resolvedCoolants,resolvedCoolantVolumes,resolvedTransportConditions,resolvedStorageConditions,resolvedFastTrack,
		
		(* New compatible boolean list *)
		compatibleContainerFPBoolList,batchedContainerModelList,controlledRFRackFPBoolList,specifiedFreezingContainerFPBoolList,racks,rackFPBoolList,insulatedCoolerFPBoolList,
		
		(* Compatibility checks *)
		coolantsExistQ,coolantIncompatibleMaterials,insulatedRackContainerMaterials,coolantsCompatibleList,coolantsCompatibleQ,incompatibleCoolants,coolantsCompatibleTest,
		
		(* Other checks *)
		nonRepeatedCoolants,nonRepeatedCoolantVolumes,coolantVolumeValidList,coolantVolumeValidQ,insufficientCoolants,coolantVolumeValidTest,finalBatchTemperature,batchedStorageConditionTemperatures,storageWarmedSamplesList,storageWarmedSamplesQ,nameUniqueQ,duplicateNameTest
	},
	
	(* Determine the requested output format *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];
	
	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;
	
	(* Fetch the cacheball *)
	cache=Lookup[myOptions,Cache];
	
	(* Lookup the initial values of the options index matched to samples *)
	{initialBatches,initialFreezingMethods,initialInstruments,initialFreezingProfiles,initialFreezingRates,initialDurations,initialResidualTemperatures,initialFreezingContainers,initialFreezingConditions,initialCoolants,initialCoolantVolumes,initialTransportConditions,initialStorageConditions,initialName,initialFastTrack}=Lookup[myOptions,{Batches,FreezingMethods,Instruments,FreezingProfiles,FreezingRates,Durations,ResidualTemperatures,FreezingContainers,FreezingConditions,Coolants,CoolantVolumes,TransportConditions,StorageConditions,Name,FastTrack}];
	
	(* ---------- EXTRACT PACKETS ---------- *)
	
	(* Fetch packets that are always present *)
	{
		samplePackets,
		controlledRateFreezerModelPackets,
		controlledRateFreezerRackPackets,
		nonPortableFreezerPackets,
		portableFreezerPackets,
		insulatedCoolerModelPackets,
		transportConditionPackets,
		storageConditionPackets
	}={
		fetchPacketFromCache[#,cache]&/@mySamples,
		Select[cache,MatchQ[Lookup[#,Type],Model[Instrument,ControlledRateFreezer]]&],
		Select[cache,MatchQ[Lookup[#,Type],Model[Container,Rack]]&&MatchQ[Lookup[#,Footprint],ControlledRateFreezerRack]&],
		Select[cache,MatchQ[Lookup[#,Type],Model[Instrument,Freezer]]&],
		Select[cache,MatchQ[Lookup[#,Type],Model[Instrument,PortableCooler]]&],
		Select[cache,MatchQ[Lookup[#,Type],Model[Container,Rack,InsulatedCooler]]&],
		Select[cache,MatchQ[Lookup[#,Type],Model[TransportCondition]]&],
		Select[cache,MatchQ[Lookup[#,Type],Model[StorageCondition]]&]
	};
	
	(* Find the sample names for error reporting *)
	sampleNames=If[
		NullQ[Lookup[#,Name]],
		Lookup[#,Object],
		Lookup[#,Name]
	]&/@samplePackets;
	
	(* ---------- INPUT VALIDATION CHECKS ---------- *)
	
	(* ----- Are any samples repeated? ----- *)
	
	(* Check if any samples are repeated *)
	uniqueInputsQ=DuplicateFreeQ[mySamples];
	
	(* Find which samples are duplicated *)
	duplicatedSamples=First/@DeleteCases[Tally[mySamples],{_,1}];
	
	(* If any sample are duplicated and messages are on, throw an error *)
	If[
		!uniqueInputsQ&&messages,
		Message[Error::FreezeCellsRepeatedSamples,duplicatedSamples]
	];
	
	(* If gathering tests, create a passing or failing test *)
	uniqueInputsTest=Which[
		!gatherTests,Nothing,
		gatherTests&&uniqueInputsQ,Test["Specified samples are not repeated:",True,True],
		gatherTests&&!uniqueInputsQ,Test["Specified samples are not repeated:",True,False]
	];
	
	(* ----- Are any samples discarded? ----- *)
	
	(* Check if any samples are discarded *)
	validInputsQ=!MemberQ[Lookup[samplePackets,Status,Null],Discarded];
	
	(* Find which samples are discarded *)
	discardedSamples=Pick[sampleNames,Lookup[samplePackets,Status,Null],Discarded];
	
	(* If any samples are discarded and messages are on, throw an error *)
	If[
		!validInputsQ&&messages,
		Message[Error::DiscardedSamples,discardedSamples]
	];
	
	(* If gathering tests, create a passing or failing test *)
	validInputTest=Which[
		!gatherTests,Nothing,
		gatherTests&&validInputsQ,Test["Specified samples are not discarded:",True,True],
		gatherTests&&!validInputsQ,Test["Specified samples are not discarded:",True,False]
	];
	
	(* ----- Are any samples solid? ----- *)
	
	(* Check if any samples are solid *)
	liquidInputsQ=!MemberQ[Lookup[samplePackets,State,Null],Solid];
	
	(* Find which samples are discarded *)
	solidSamples=Pick[sampleNames,Lookup[samplePackets,State,Null],Solid];
	
	(* If any samples are solid and messages are on, throw an error *)
	If[
		!liquidInputsQ&&messages,
		Message[Error::FreezeCellsSolidSamples,solidSamples]
	];
	
	(* If gathering tests, create a passing or failing test *)
	liquidInputsTest=Which[
		!gatherTests,Nothing,
		gatherTests&&liquidInputsQ,Test["Specified samples are not in a solid state:",True,True],
		gatherTests&&!liquidInputsQ,Test["Specified samples are not in a solid state:",True,False]
	];
	
	(* ----- Are any samples in incompatible containers? ----- *)
	
	(* Find the containers for samples *)
	sampleContainers=Download[Lookup[samplePackets,Container],Object];
	
	(* Find the models for the containers *)
	sampleContainerModels=Download[Lookup[fetchPacketFromCache[#,cache]&/@sampleContainers,Model],Object];
	
	(* Remove duplicates from the sample container models *)
	containerModels=DeleteDuplicates[sampleContainerModels];
	
	(* Get the models for the controlled rate freezer racks *)
	controlledRateFreezerRacks=Lookup[controlledRateFreezerRackPackets,Object];
	
	(* Make a list of all allowed racks *)
	allowedRacks=Join[controlledRateFreezerRacks,Lookup[insulatedCoolerModelPackets,Object]];
	
	(* Find the heights of the allowed racks *)
	allowedRackHeights=Max[Lookup[#,MaxHeight]]&/@Lookup[fetchPacketFromCache[#,cache]&/@allowedRacks,Positions];
	
	(* Define our tolerance for containers *)
	containerTolerance=0.5 Centimeter;
	
	(* Find the container heights *)
	containerHeights=Last/@Lookup[fetchPacketFromCache[#,cache]&/@containerModels,Dimensions];
	
	(* Generate a boolean list for compatible footprint for container model *)
	compatibleContainerFPBoolList=CompatibleFootprintQ[ConstantArray[allowedRacks,Length[containerModels]],containerModels,Tolerance->ConstantArray[containerTolerance,Length[containerModels]],Cache->cache,FlattenOutput->False];
	
	(* Check if each of the containers we have are compatible with the experiment *)
	compatibleContainersQList=MapThread[
		Function[
			{containerModel,containerHeight,compatibleContainerModelBool},
			And[
				MemberQ[
					Apply[And,#]&/@Transpose[{
						
						(* Does the container fit into the rack? *)
						compatibleContainerModelBool,
						
						(* Is the container dramatically shorter than the container? -- CompatibleFootprintQ only checks that the rack height is above the container so basically any container will fit into 5mL Mr Frosty even though that is not what we want in general because the liquid height in Mr Frosty has to be above the liquid in the container for effective freezing *)
						(#-containerTolerance<=containerHeight<=#+containerTolerance)&/@allowedRackHeights
					}],
					True
				],
				
				(* Can the container tolerate cryogenic temperatures? *)
				Lookup[fetchPacketFromCache[containerModel,cache],MinTemperature]<=-196 Celsius
			]
		],
		{containerModels,containerHeights,compatibleContainerFPBoolList}
	];
	
	(* Boolean for error check *)
	compatibleContainersQ=And@@compatibleContainersQList;
	
	(* If there are incompatible containers, find their samples *)
	incompatibleSamples=Module[{failedSampleIndices},
		
		(* Find which samples have the failed models *)
		failedSampleIndices=Flatten[Position[sampleContainerModels,#]&/@Pick[containerModels,compatibleContainersQList,False]];
		
		(* Find the failed samples *)
		Part[mySamples,Sort[failedSampleIndices]]
	];
	
	(* If any samples are in incompatible containers and messages are on, throw an error *)
	If[
		!compatibleContainersQ&&messages,
		Message[Error::FreezeCellsIncompatibleContainers,incompatibleSamples]
	];
	
	(* If gathering tests, create a passing or failing test *)
	compatibleContainersTest=Which[
		!gatherTests,Nothing,
		gatherTests&&compatibleContainersQ,Test["Specified samples are in cryogenic vials that are compatible with the experimental setup:",True,True],
		gatherTests&&!compatibleContainersQ,Test["Specified samples are in cryogenic vials that are compatible with the experimental setup:",True,False]
	];
	
	(* ---------- OPTION PRECISION CHECK ---------- *)
	
	(* Separate FreezingProfiles -- because this option is a multiple of a multiple, we either have to split the option or map over it. This seemed easier than having multiple RoundOptionsPrecision calls patched together *)
	optionsWithSeparatedFreezingProfiles=If[
		MatchQ[initialFreezingProfiles,Except[{Automatic..}]],
		Append[
			KeyDrop[Association@@myOptions,FreezingProfiles],
			AssociationThread[Table["FreezingProfile (Batch "<>ToString[i]<>")",{i,1,Length[initialFreezingProfiles]}],initialFreezingProfiles]
		],
		Association@@myOptions
	];
	
	(* Create the option names for FreezingProfiles *)
	freezingProfileNames=If[
		MatchQ[initialFreezingProfiles,Except[{Automatic..}]],
		Table["FreezingProfile (Batch "<>ToString[i]<>")",{i,1,Length[initialFreezingProfiles]}],
		{"FreezingProfiles"}
	];
	
	(* Round the options *)
	{roundedOptions,precisionTests}=RoundOptionPrecision[
		optionsWithSeparatedFreezingProfiles,
		{
			FreezingRates,
			Durations,
			ResidualTemperatures,
			CoolantVolumes,
			Sequence@@freezingProfileNames
		},
		{
			10^-2 Celsius/Minute,
			10^-1 Minute,
			10^-2 Celsius,
			1 Milliliter,
			Sequence@@ConstantArray[{10^-2 Celsius,10^-1 Minute},Length[freezingProfileNames]]
		},
		AvoidZero->{True,True,True,True,Sequence@@ConstantArray[True,Length[freezingProfileNames]]},
		Output->{Result,Tests}
	];
	
	(* Put Humpty Dumpty back together: assemble FreezingProfiles into a single key *)
	reassembledRoundedOptions=If[
		MatchQ[roundedOptions,KeyValuePattern["FreezingProfile (Batch 1)"->_]],
		Append[
			KeyDrop[roundedOptions,Table["FreezingProfile (Batch "<>ToString[i]<>")",{i,1,Length[freezingProfileNames]}]],
			<|FreezingProfiles->Lookup[roundedOptions,Table["FreezingProfile (Batch "<>ToString[i]<>")",{i,1,Length[freezingProfileNames]}]]|>
		],
		roundedOptions
	];
	
	(* Check if any options were actually rounded *)
	optionsRounded=Nand@@(RunTest[#][Passed]&/@precisionTests);
	
	(* Find which options we rounded -- we have to get the names from the tests because they are not always in the same order *)
	roundedOptionNames=Pick[
		Flatten[StringCases[Flatten[Values[KeyTake[First[#]&/@precisionTests,Description]]],"The precision of any user-supplied "~~x__~~" options is compatible with instrumental precision:":>x]],
		RunTest[#][Passed]&/@precisionTests,
		False
	];
	
	(* Find what the options were rounded to *)
	roundedOptionValues={Lookup[optionsWithSeparatedFreezingProfiles,ToExpression/@roundedOptionNames],Lookup[roundedOptions,ToExpression/@roundedOptionNames]};
	
	(* If we rounded, display a warning *)
	If[
		optionsRounded&&messages&&!MatchQ[$ECLApplication,Engine],
		Message[Warning::FreezeCellsInstrumentalPrecision,roundedOptionNames,First[roundedOptionValues],Last[roundedOptionValues]]
	];
	
	(* Update any rounded options -- we have to get some options in this janky way because MM does not understand Fahrenheit so we get all kinds of errors when we try to manipulate them in any way. Since MM is not smart enough to add 5 Celsius and 5 Fahrenheit together, we are going to convert all the units to Celsius now. We already threw a rounding error, so we can safely round here when we convert to Celsius. Also, it turned out it struggles with time too. It can add times with different units, but can't multiply compound units with a different one. 1 Celsius/Minute x 1 Hour returns -426.3 Celsius... So we are also going to convert all the times to minutes while we are at it... *)
	{
		roundedCoolantVolumes,
		roundedDurations,
		roundedFreezingRates,
		roundedResidualTemperatures,
		roundedFreezingProfilesWithoutInitialCondition
	}={
		Lookup[reassembledRoundedOptions,CoolantVolumes],
		If[
			MatchQ[#,UnitsP[1 Minute]],
			Round[N[UnitConvert[#,Minute]],0.1 Minute],
			#
		]&/@Lookup[reassembledRoundedOptions,Durations],
		If[
			MatchQ[#,UnitsP[1 Celsius/Minute]],
			Round[N[UnitConvert[#,Celsius/Minute]],0.01 Celsius/Minute],
			#
		]&/@Lookup[reassembledRoundedOptions,FreezingRates],
		If[
			MatchQ[#,UnitsP[1 Celsius]],
			Round[N[UnitConvert[#,Celsius]],0.01 Celsius],
			#
		]&/@Lookup[reassembledRoundedOptions,ResidualTemperatures],
		Function[
			freezingProfile,
			If[
				MatchQ[freezingProfile,{{UnitsP[1 Celsius],UnitsP[1 Minute]}..}],
				{Round[N[UnitConvert[First[#],Celsius]],0.01 Celsius],Last[#]}&/@freezingProfile,
				freezingProfile
			]
		]/@Lookup[reassembledRoundedOptions,FreezingProfiles]
	};
	
	(* Append the initial condition to any freezing profiles without it *)
	roundedFreezingProfiles=Which[
		
		(* If its automatic or null, carry on *)
		MatchQ[#,Automatic|Null],#,
		
		(* If the first member of the freezing profile is {20 Celsius,0 Minute}, carry on -- we have to check in this weird way because for templates and such, we may have 20.` as the number, which only returns true when compared with equal*)
		First[First[#]]==20 Celsius&&Last[First[#]]==0 Minute,#,
		
		(* Otherwise, append the initial condition to the profile *)
		True,Prepend[#,{20 Celsius,0 Minute}]
	]&/@roundedFreezingProfilesWithoutInitialCondition;
	
	(* ---------- MISCELLANEOUS OPTION CHECKS ---------- *)
	
	(* ----- Are Instruments Retired/Deprecated? ----- *)
	
	(* Find packets for the input instruments *)
	inputInstrumentPackets=If[
		MatchQ[initialInstruments,Except[{Automatic..}]],
		fetchPacketFromCache[#,cache]&/@(initialInstruments/.Automatic->Null)
	]/.Null-><||>;
	
	(* Check if instruments are specified and that they are not retired or deprecated *)
	validInstrumentsQ=If[
		MatchQ[initialInstruments,Except[{Automatic..}]],
		!MemberQ[Lookup[inputInstrumentPackets,Status,Null],Retired|Deprecated],
		True
	];
	
	(* Find which instruments are retired or deprecated *)
	invalidInstruments=If[
		MatchQ[initialInstruments,Except[{Automatic..}]],
		Pick[initialInstruments,Lookup[inputInstrumentPackets,Status,Null],Retired|Deprecated]
	];
	
	(* If any instruments are retired or deprecated and messages are on, throw an error *)
	If[
		!validInstrumentsQ&&messages,
		Message[Error::FreezeCellsUnsupportedInstruments,invalidInstruments]
	];
	
	(* If gathering tests, create a passing or failing test *)
	validInstrumentTest=Which[
		!gatherTests,Nothing,
		gatherTests&&validInstrumentsQ,Test["Specified instruments are not retired or deprecated:",True,True],
		gatherTests&&!validInstrumentsQ,Test["Specified instruments are not retired or deprecated:",True,False]
	];
	
	(* ----- Are FreezingContainers Discarded/Deprecated? ----- *)
	
	(* Find packets for the input freezing containers *)
	inputFreezingContainersPackets=If[
		MatchQ[initialFreezingContainers,Except[{Automatic..}]],
		fetchPacketFromCache[#,cache]&/@(initialFreezingContainers/.Automatic->Null)
	]/.Null-><||>;
	
	(* Check if freezing containers are specified and that they are not retired or deprecated *)
	validFreezingContainersQ=If[
		MatchQ[initialFreezingContainers,Except[{Automatic..}]],
		!MemberQ[Lookup[inputFreezingContainersPackets,Status,Null],Discarded|Deprecated],
		True
	];
	
	(* Find which freezing containers are retired or deprecated *)
	invalidFreezingContainers=If[
		MatchQ[initialFreezingContainers,Except[{Automatic..}]],
		Pick[initialFreezingContainers,Lookup[inputFreezingContainersPackets,Status,Null],Discarded|Deprecated]
	];
	
	(* If any freezing containers are retired or deprecated and messages are on, throw an error *)
	If[
		!validFreezingContainersQ&&messages,
		Message[Error::FreezeCellsUnsupportedFreezingContainers,invalidFreezingContainers]
	];
	
	(* If gathering tests, create a passing or failing test *)
	validFreezingContainersTest=Which[
		!gatherTests,Nothing,
		gatherTests&&validFreezingContainersQ,Test["Specified freezing containers are not retired or deprecated:",True,True],
		gatherTests&&!validFreezingContainersQ,Test["Specified freezing containers are not retired or deprecated:",True,False]
	];
	
	(* ----- Are there more Batches than Samples? ----- *)
	
	(* Compare the batch length with sample length -- we can do this very simple test here because our options are index matched. So if someone specifies 5 methods but no batches, we should still have 5 Automatics for batches *)
	totalBatchLengthValidQ=Length[initialBatches]<=Length[mySamples];
	
	(* If there are more batches than samples and messages are on, throw an error *)
	If[
		!totalBatchLengthValidQ&&messages,
		Message[Error::FreezeCellsTooManyBatches]
	];
	
	(* If gathering tests, create a passing or failing test *)
	totalBatchLengthValidTest=Which[
		!gatherTests,Nothing,
		gatherTests&&totalBatchLengthValidQ,Test["Number of batches do exceed the number of samples:",True,True],
		gatherTests&&!totalBatchLengthValidQ,Test["Number of batches do exceed the number of samples:",True,False]
	];
	
	(* ----- Do Batches contain any unspecified or duplicate samples? ----- *)
	
	(* Check if any batches contain duplicate items *)
	batchesWithDuplicateSamplesList=If[
		MatchQ[initialBatches,Except[{Automatic..}]],
		DuplicateFreeQ[#]&/@initialBatches,
		ConstantArray[True,Length[initialBatches]]
	];
	
	(* Create a bool for error checking *)
	nonDuplicatedSamplesWithinBatchesQ=!MemberQ[batchesWithDuplicateSamplesList,False];
	
	(* Find which samples are duplicated *)
	samplesDuplicatedInSingleBatch=MapThread[
		If[
			!#1,
			First/@DeleteCases[Tally[#2],{_,1}],
			{}
		]&,
		{batchesWithDuplicateSamplesList,initialBatches}
	];
	
	(* If any samples are duplicated and messages are on, throw an error *)
	If[
		!nonDuplicatedSamplesWithinBatchesQ&&messages,
		Message[Error::FreezeCellsInvalidBatches,"contains duplicates of samples within a batch for",samplesDuplicatedInSingleBatch,"ensure that batches do not contain duplicates"]
	];
	
	(* If gathering tests, create a passing or failing test *)
	nonDuplicatedBatchesTest=Which[
		!gatherTests,Nothing,
		gatherTests&&nonDuplicatedSamplesWithinBatchesQ,Test["Specified batches do not contain duplicate items within a single batch:",True,True],
		gatherTests&&!nonDuplicatedSamplesWithinBatchesQ,Test["Specified batches do not contain duplicate items within a single batch:",True,False]
	];
	
	(* Check if any samples in batches are not specified as samples *)
	unspecifiedBatchSamples=If[
		MatchQ[initialBatches,Except[{Automatic..}]],
		Complement[Flatten[initialBatches],mySamples],
		{}
	];
	
	(* Create a bool for error checking *)
	specifiedBatchSamplesQ=MatchQ[unspecifiedBatchSamples,{}];
	
	(* If any samples are duplicated and messages are on, throw an error *)
	If[
		!specifiedBatchSamplesQ&&messages,
		Message[Error::FreezeCellsInvalidBatches,"contains objects that are not specified as input samples for",unspecifiedBatchSamples,"ensure that all samples in Batches are also specified as a sample"]
	];
	
	(* If gathering tests, create a passing or failing test *)
	specifiedBatchSamplesTest=Which[
		!gatherTests,Nothing,
		gatherTests&&specifiedBatchSamplesQ,Test["Specified batches do not contain objects that are not specified as input samples:",True,True],
		gatherTests&&!specifiedBatchSamplesQ,Test["Specified batches do not contain objects that are not specified as input samples:",True,False]
	];
	
	(* Check if any samples are not specified in batches *)
	unspecifiedSamplesInBatches=If[
		MatchQ[initialBatches,Except[{Automatic..}]],
		Complement[mySamples,Flatten[initialBatches]],
		{}
	];
	
	(* Create a bool for error checking *)
	allSamplesInBatchesQ=MatchQ[unspecifiedSamplesInBatches,{}];
	
	(* If any samples are duplicated and messages are on, throw an error *)
	If[
		!allSamplesInBatchesQ&&messages,
		Message[Error::FreezeCellsInvalidBatches,"does not contain",unspecifiedSamplesInBatches,"ensure that all samples are specified in Batches"]
	];
	
	(* If gathering tests, create a passing or failing test *)
	allSamplesInBatchesTest=Which[
		!gatherTests,Nothing,
		gatherTests&&allSamplesInBatchesQ,Test["Specified batches contain all input samples:",True,True],
		gatherTests&&!allSamplesInBatchesQ,Test["Specified batches contain all input samples:",True,False]
	];
	
	(* Check if any samples are duplicated across batches *)
	samplesDuplicatedAcrossBatches=Which[
		
		(* If Batches are not specified, carry on *)
		MatchQ[initialBatches,{Automatic..}],{},
		
		(* If we don't have any duplicates in the batches, any duplicates in batches must come from samples duplicated across batches *)
		nonDuplicatedSamplesWithinBatchesQ,First/@DeleteCases[Tally[Flatten[initialBatches]],{_,1}],
		
		(* Otherwise, check each sample in Batches to see if it is more than one batch *)
		True,DeleteDuplicates[Function[
			sample,
			Module[{sampleInBatchList},
				
				(* Compare sample against all batches *)
				sampleInBatchList=MemberQ[#,sample]&/@initialBatches;
				
				(* Check if the sample is in more than one batch *)
				If[
					Count[sampleInBatchList,True]!=1,
					sample,
					Nothing
				]
			]
		]/@Flatten[initialBatches]]
	];
	
	(* Create a bool for error checking *)
	nonDuplicatedSamplesAcrossBatchesQ=MatchQ[samplesDuplicatedAcrossBatches,{}];
	
	(* If any samples are duplicated and messages are on, throw an error *)
	If[
		!nonDuplicatedSamplesAcrossBatchesQ&&messages,
		Message[Error::FreezeCellsInvalidBatches,"contains samples that are specified in multiple batches for",samplesDuplicatedAcrossBatches,"ensure that samples are not specified in more than a single batch"]
	];
	
	(* If gathering tests, create a passing or failing test *)
	nonDuplicatedSamplesAcrossBatchesTest=Which[
		!gatherTests,Nothing,
		gatherTests&&nonDuplicatedSamplesAcrossBatchesQ,Test["Each sample is specified in only a single batch:",True,True],
		gatherTests&&!nonDuplicatedSamplesAcrossBatchesQ,Test["Each sample is specified in only a single batch:",True,False]
	];
	
	(* ---------- CONFLICTING OPTIONS CHECKS ---------- *)
	
	(* ----- Are FreezingMethods copacetic with other options? ----- *)
	
	(* Find if any options are specified that are not consistent with the specified method *)
	specifiedOptionAssociation=If[
		
		(* If methods are specified *)
		MatchQ[initialFreezingMethods,Except[{Automatic..}]],
		MapThread[
			Function[
				{method,freezingProfile,freezingRate,duration,residualTemperature,freezingContainer,freezingCondition,coolant,coolantVolume},
				Which[
					
					(* If Method is ControlledRateFreezer, check FreezingContainer, FreezingCondition, Coolant and CoolantVolume *)
					MatchQ[method,ControlledRateFreezer],<|
						FreezingContainers->MatchQ[freezingContainer,Except[Automatic|Null]],
						FreezingConditions->MatchQ[freezingCondition,Except[Automatic|Null]],
						Coolants->MatchQ[coolant,Except[Automatic|Null]],
						CoolantVolumes->MatchQ[coolantVolume,Except[Automatic|Null]]
					|>,
					
					(* If Method is InsulatedCooler, check FreezingProfile, FreezingRate, Duration and ResidualTemperature *)
					MatchQ[method,InsulatedCooler],<|
						FreezingProfiles->MatchQ[freezingProfile,Except[Automatic|Null]],
						FreezingRates->MatchQ[freezingRate,Except[Automatic|Null]],
						Durations->MatchQ[duration,Except[Automatic|Null]],
						ResidualTemperatures->MatchQ[residualTemperature,Except[Automatic|Null]]
					|>,
					
					(* Otherwise, carry on *)
					True,<|IgnoredOptions->False|>
				]
			],
			{initialFreezingMethods,roundedFreezingProfiles,roundedFreezingRates,roundedDurations,roundedResidualTemperatures,initialFreezingContainers,initialFreezingConditions,initialCoolants,roundedCoolantVolumes}
		],
		
		(* Otherwise, return default association *)
		{<|IgnoredOptions->False|>}
	];
	
	(* Check if any batches have inconsistent options *)
	ignoredOptionsSpecifiedList=Or@@#&/@Values[specifiedOptionAssociation];
	
	(* Find if any options are specified for the wrong method *)
	ignoredOptionsSpecified=Or@@ignoredOptionsSpecifiedList;
	
	(* Find which options were incorrectly specified *)
	ignoredOptions=((PositionIndex[#][True])&/@specifiedOptionAssociation/._Missing->{})/.{}->Nothing;
	
	(* Find which batches have invalid options *)
	ignoredBatchIndices=Flatten[Position[ignoredOptionsSpecifiedList,True]];
	
	(* If we have any invalid options, display a warning *)
	If[
		ignoredOptionsSpecified&&messages&&!MatchQ[$ECLApplication,Engine],
		Message[Warning::FreezeCellsIgnoredOptions,ignoredOptions,ignoredBatchIndices]
	];
	
	(* ----- Are InsulatedCooler and ControlledRateFreezer options copacetic with each other? ----- *)
	
	(* Find if any options are specified for both option types *)
	incompatibleOptionsList=MapThread[
		Function[
			{instrument,freezingProfile,freezingRate,duration,residualTemperature,freezingContainer,freezingCondition,coolant,coolantVolume},
			Which[
				
				(* If a ControlledRateFreezer instrument was specified with FreezingProfiles, check that all other options are either Automatic or Null *)
				MatchQ[instrument,ObjectP[{Model[Instrument,ControlledRateFreezer],Object[Instrument,ControlledRateFreezer]}]]&&MatchQ[freezingProfile,Except[Automatic|Null]],{
					"Variable Rate ControlledRateFreezer options",
					And[
						MatchQ[freezingRate,Automatic|Null],
						MatchQ[duration,Automatic|Null],
						MatchQ[residualTemperature,Automatic|Null],
						MatchQ[freezingContainer,Automatic|Null],
						MatchQ[freezingCondition,Automatic|Null],
						MatchQ[coolant,Automatic|Null],
						MatchQ[coolantVolume,Automatic|Null]
					]
				},
				
				(* If a ControlledRateFreezer instrument was specified with FreezingRate, Durations or ResidualTemperature, check that the FreezingProfiles and InsulatedCooler options are either Automatic or Null *)
				MatchQ[instrument,ObjectP[{Model[Instrument,ControlledRateFreezer],Object[Instrument,ControlledRateFreezer]}]]&&Or[
					MatchQ[freezingRate,Except[Automatic|Null]],
					MatchQ[duration,Except[Automatic|Null]],
					MatchQ[residualTemperature,Except[Automatic|Null]]
				],{
					"Constant Rate ControlledRateFreezer options",
					And[
						MatchQ[freezingContainer,Automatic|Null],
						MatchQ[freezingCondition,Automatic|Null],
						MatchQ[coolant,Automatic|Null],
						MatchQ[coolantVolume,Automatic|Null]
					]
				},
				
				(* If a ControlledRateFreezer instrument was specified without any other options, check that InsulatedCooler options are either Automatic or Null *)
				MatchQ[instrument,ObjectP[{Model[Instrument,ControlledRateFreezer],Object[Instrument,ControlledRateFreezer]}]],{
					"ControlledRateFreezer options",
					And[
						MatchQ[freezingContainer,Automatic|Null],
						MatchQ[freezingCondition,Automatic|Null],
						MatchQ[coolant,Automatic|Null],
						MatchQ[coolantVolume,Automatic|Null]
					]
				},
				
				(* If an InsulatedCooler instrument was specified, check that ControlledRateFreezer options are either Automatic or Null *)
				MatchQ[instrument,ObjectP[{Model[Instrument,Freezer],Object[Instrument,Freezer]}]],{
					"InsulatedCooler options",
					And[
						MatchQ[freezingProfile,Automatic|Null],
						MatchQ[freezingRate,Automatic|Null],
						MatchQ[duration,Automatic|Null],
						MatchQ[residualTemperature,Automatic|Null]
					]
				},
				
				(* If FreezingProfiles were specified, check that the other options are either Automatic or Null *)
				MatchQ[freezingProfile,Except[Automatic|Null]],{
					"Variable Rate ControlledRateFreezer options",
					And[
						MatchQ[freezingRate,Automatic|Null],
						MatchQ[duration,Automatic|Null],
						MatchQ[residualTemperature,Automatic|Null],
						MatchQ[freezingContainer,Automatic|Null],
						MatchQ[freezingCondition,Automatic|Null],
						MatchQ[coolant,Automatic|Null],
						MatchQ[coolantVolume,Automatic|Null]
					]
				},
				
				(* If any constant rate ControlledRateFreezer options were specified, check that the FreezingProfiles and InsulatedCooler options are either Automatic or Null *)
				Or[
					MatchQ[freezingRate,Except[Automatic|Null]],
					MatchQ[duration,Except[Automatic|Null]],
					MatchQ[residualTemperature,Except[Automatic|Null]]
				],{
					"Constant Rate ControlledRateFreezer options",
					And[
						MatchQ[freezingContainer,Automatic|Null],
						MatchQ[freezingCondition,Automatic|Null],
						MatchQ[coolant,Automatic|Null],
						MatchQ[coolantVolume,Automatic|Null]
					]
				},
				
				(* Otherwise, carry on *)
				True,{Null,True}
			]
		],
		{initialInstruments,roundedFreezingProfiles,roundedFreezingRates,roundedDurations,roundedResidualTemperatures,initialFreezingContainers,initialFreezingConditions,initialCoolants,roundedCoolantVolumes}
	];
	
	(* Create a bool for error checking *)
	incompatibleOptionsQ=And@@(Last/@incompatibleOptionsList);
	
	(* Find which indices have invalid options *)
	incompatibleOptionIndices=Flatten[Position[Last/@incompatibleOptionsList,False]];
	
	(* Find which option group failed *)
	incompatibleOptions=Pick[First/@incompatibleOptionsList,Last/@incompatibleOptionsList,False];
	
	(* If any batches have invalid options and messages are on, throw an error *)
	If[
		!incompatibleOptionsQ&&messages,
		Message[Error::FreezeCellsIncompatibleOptions,incompatibleOptions,incompatibleOptionIndices]
	];
	
	(* If gathering tests, create a passing or failing test *)
	incompatibleOptionsTest=Which[
		!gatherTests,Nothing,
		gatherTests&&incompatibleOptionsQ,Test["A mixture of variable rate ControlledRateFreezer, constant rate ControlledRateFreezer and InsulatedCooler options were not specified for a batch:",True,True],
		gatherTests&&!incompatibleOptionsQ,Test["A mixture of variable rate ControlledRateFreezer, constant rate ControlledRateFreezer and InsulatedCooler options were not specified for a batch:",True,False]
	];
	
	(* ----- Are InsulatedCooler and ControlledRateFreezer options copacetic amongst themselves? ----- *)
	
	(* Find if any options are specified as Null when required *)
	groupedInvalidOptionsList=MapThread[
		Function[
			{instrument,freezingProfile,freezingRate,duration,residualTemperature,freezingContainer,freezingCondition,coolant,coolantVolume},
			Which[
				
				(* If a ControlledRateFreezer instrument was specified with FreezingProfiles, there are no other options to check so skip this error *)
				MatchQ[instrument,ObjectP[{Model[Instrument,ControlledRateFreezer],Object[Instrument,ControlledRateFreezer]}]]&&MatchQ[freezingProfile,Except[Automatic|Null]],{Null,True},
				
				(* If a ControlledRateFreezer instrument was specified with a constant rate option, check that the constant rate options are not Null -- we are not checking for Nulls here because since we already eliminated any cases where FreezingProfiles were specified, if a ControlledRateFreezer instrument was specified, it must have these options *)
				MatchQ[instrument,ObjectP[{Model[Instrument,ControlledRateFreezer],Object[Instrument,ControlledRateFreezer]}]]&&Or[
					MatchQ[freezingRate,Except[Automatic]],
					MatchQ[duration,Except[Automatic]],
					MatchQ[residualTemperature,Except[Automatic]]
				],{
					"Constant Rate ControlledRateFreezer options",
					And[
						MatchQ[freezingRate,Except[Null]],
						MatchQ[duration,Except[Null]],
						MatchQ[residualTemperature,Except[Null]]
					]
				},
				
				(* If a ControlledRateFreezer instrument was specified without any other options, we are good *)
				MatchQ[instrument,ObjectP[{Model[Instrument,ControlledRateFreezer],Object[Instrument,ControlledRateFreezer]}]],{Null,True},
				
				(* If an InsulatedCooler instrument was specified, check that InsulatedCooler options are Null *)
				MatchQ[instrument,ObjectP[{Model[Instrument,Freezer],Object[Instrument,Freezer]}]],{
					"InsulatedCooler options",
					And[
						MatchQ[freezingContainer,Except[Null]],
						MatchQ[freezingCondition,Except[Null]],
						MatchQ[coolant,Except[Null]],
						MatchQ[coolantVolume,Except[Null]]
					]
				},
				
				(* If FreezingProfiles was specified, there are no other options to check so skip this error *)
				MatchQ[freezingProfile,Except[Automatic|Null]],{Null,True},
				
				(* If constant rate ControlledRateFreezer options were specified, check that the constant rate options are not Null *)
				Or[
					MatchQ[freezingRate,Except[Automatic|Null]],
					MatchQ[duration,Except[Automatic|Null]],
					MatchQ[residualTemperature,Except[Automatic|Null]]
				],{
					"Constant Rate ControlledRateFreezer options",
					And[
						MatchQ[freezingRate,Except[Null]],
						MatchQ[duration,Except[Null]],
						MatchQ[residualTemperature,Except[Null]]
					]
				},
				
				(* If any InsulatedCooler options were specified, check that nothing is Null *)
				Or[
					MatchQ[freezingContainer,Except[Automatic|Null]],
					MatchQ[freezingCondition,Except[Automatic|Null]],
					MatchQ[coolant,Except[Automatic|Null]],
					MatchQ[coolantVolume,Except[Automatic|Null]]
				],{
					"InsulatedCooler options",
					And[
						MatchQ[freezingContainer,Except[Null]],
						MatchQ[freezingCondition,Except[Null]],
						MatchQ[coolant,Except[Null]],
						MatchQ[coolantVolume,Except[Null]]
					]
				},
				
				(* Otherwise, we are good *)
				True,{Null,True}
			]
		],
		{initialInstruments,roundedFreezingProfiles,roundedFreezingRates,roundedDurations,roundedResidualTemperatures,initialFreezingContainers,initialFreezingConditions,initialCoolants,roundedCoolantVolumes}
	];
	
	(* Create a bool for error checking *)
	groupedInvalidOptionsQ=And@@(Last/@groupedInvalidOptionsList);
	
	(* Find which indices have invalid options *)
	groupedInvalidOptionsIndices=Flatten[Position[Last/@groupedInvalidOptionsList,False]];
	
	(* Find which option group failed *)
	groupedInvalidOptions=Pick[First/@groupedInvalidOptionsList,Last/@groupedInvalidOptionsList,False];
	
	(* If any batches have invalid options and messages are on, throw an error *)
	If[
		!groupedInvalidOptionsQ&&messages,
		Message[Error::FreezeCellsInvalidOptions,groupedInvalidOptions,groupedInvalidOptionsIndices]
	];
	
	(* If gathering tests, create a passing or failing test *)
	groupedInvalidOptionsTest=Which[
		!gatherTests,Nothing,
		gatherTests&&groupedInvalidOptionsQ,Test["Specified ControlledRateFreezer or InsulatedCooler options do not contain Null values when required:",True,True],
		gatherTests&&!groupedInvalidOptionsQ,Test["Specified ControlledRateFreezer or InsulatedCooler options do not contain Null values when required:",True,False]
	];
	
	(* Find the types of methods that were implicitly or explicitly specified *)
	preResolvedMethods=If[
		
		(* If no method-defining options were specified, then return Automatic *)
		MatchQ[MatchQ[#,{(Automatic|Null)..}]&/@{initialFreezingMethods,initialInstruments,roundedFreezingProfiles,roundedFreezingRates,roundedDurations,roundedResidualTemperatures,initialFreezingContainers,initialFreezingConditions,initialCoolants,roundedCoolantVolumes,initialTransportConditions},{True..}],
		Automatic,
		
		(* Otherwise, a batch-defining option was specified *)
		MapThread[
			Function[
				{method,instrument,freezingProfile,freezingRate,duration,residualTemperature,freezingContainer,freezingCondition,coolant,coolantVolume,transportConditions},
				Which[
					
					(* If all method-defining options are automatic, return Automatic -- we will use this variable later so we are using Automatic here *)
					MatchQ[MatchQ[#,(Automatic|Null)]&/@{method,instrument,freezingProfile,freezingRate,duration,residualTemperature,freezingContainer,freezingCondition,coolant,coolantVolume,transportConditions},{True..}],Automatic,
					
					(* If ControlledRateFreezer was specified as the method *)
					MatchQ[method,ControlledRateFreezer],ControlledRateFreezer,
					
					(* If InsulatedCooler was specified as the method *)
					MatchQ[method,InsulatedCooler],InsulatedCooler,
					
					(* If instrument was specified as ControlledRateFreezer *)
					MatchQ[instrument,ObjectP[{Model[Instrument,ControlledRateFreezer],Object[Instrument,ControlledRateFreezer]}]],ControlledRateFreezer,
					
					(* If instrument was specified as Freezer *)
					MatchQ[instrument,ObjectP[{Model[Instrument,Freezer],Object[Instrument,Freezer]}]],InsulatedCooler,
					
					(* If freezing profile is not Null or Automatic *)
					MatchQ[freezingProfile,Except[Null|Automatic]],ControlledRateFreezer,
					
					(* If constant rate ControlledRateFreezer options are not Null or Automatic *)
					Or[MatchQ[freezingRate,Except[Null|Automatic]],MatchQ[duration,Except[Null|Automatic]],MatchQ[residualTemperature,Except[Null|Automatic]]],ControlledRateFreezer,
					
					(* If insulated cooler options are not Null or Automatic *)
					Or[
						MatchQ[freezingContainer,Except[Null|Automatic]],
						MatchQ[freezingCondition,Except[Null|Automatic]],
						MatchQ[coolant,Except[Null|Automatic]],
						MatchQ[coolantVolume,Except[Null|Automatic]]
					],InsulatedCooler,
					
					(* If transport conditions are not Null or Automatic *)
					MatchQ[transportConditions,Except[Null|Automatic]],ControlledRateFreezer
				]
			],
			{initialFreezingMethods,initialInstruments,roundedFreezingProfiles,roundedFreezingRates,roundedDurations,roundedResidualTemperatures,initialFreezingContainers,initialFreezingConditions,initialCoolants,roundedCoolantVolumes,initialTransportConditions}
		]
	];
	
	(* Skip a bunch of Batches-related checks if we already had errors related to batches *)
	If[
		nonDuplicatedSamplesWithinBatchesQ&&specifiedBatchSamplesQ,
		Module[{},
			
			(* ----- Are Batches copacetic with sample containers? ----- *)
			
			(* Do a compatibility check for all of our containers *)
			{controlledRateFreezerCompatibleContainers,insulatedCoolerCompatibleContainers}=Module[{containerCheck,compatibleContainerList},
				
				(* Run a container check so that we can group compatible containers together -- this is a nested list where inner lists are the Booleans for containers, and the outer lists are the racks we have *)
				containerCheck=Transpose[MapThread[
					Function[
						{containerHeight,compatibleContainerFPBool},
						Apply[And,#]&/@Transpose[{
							
							(* Does the container fit into the rack? *)
							compatibleContainerFPBool,
							
							(* Is the container dramatically shorter than the container? -- CompatibleFootprintQ only checks that the rack height is above the container so basically any container will fit into 5mL Mr Frosty even though that is not what we want in general because the liquid height in Mr Frosty has to be above the liquid in the container for effective freezing *)
							(#-containerTolerance<=containerHeight<=#+containerTolerance)&/@allowedRackHeights
						}]
					],
					{containerHeights,compatibleContainerFPBoolList}
				]];
				
				(* Group compatible containers together for each rack based on the container check *)
				compatibleContainerList=(First/@DeleteCases[Transpose[{containerModels,#}],{_,False}])&/@containerCheck;
				
				(* Separate containers based on controlled rate freezers and insulated coolers *)
				{
					DeleteDuplicates[DeleteDuplicates/@Part[compatibleContainerList,1;;Length[allowedRacks]-Length[insulatedCoolerModelPackets]]],
					DeleteDuplicates[DeleteDuplicates/@Part[compatibleContainerList,Length[allowedRacks]-Length[insulatedCoolerModelPackets]+1;;Length[allowedRacks]]]
				}
			];
			
			(* Fetch sample packets grouped by batches *)
			batchedSamplePackets=If[
				MatchQ[initialBatches,Except[{Automatic..}]],
				Function[innerList,fetchPacketFromCache[#,cache]&/@innerList]/@initialBatches
			];
			
			(* Find the containers for each sample grouped by batches *)
			batchedContainers=If[
				MatchQ[initialBatches,Except[{Automatic..}]],
				Function[innerList,Download[Lookup[#,Container]&/@innerList,Object]]/@batchedSamplePackets
			];
			
			(* Find the sample container models *)
			batchedContainerModels=Function[
				innerList,
				DeleteDuplicates[Download[Lookup[fetchPacketFromCache[#,cache]&/@innerList,Model],Object]]
			]/@batchedContainers;
			
			(* Check if each container type is a member of at least one rack in either method of freezing *)
			validBatchContainersList=If[
				MatchQ[initialBatches,Except[{Automatic..}]],
				Function[
					batchContainers,
					Module[{containerCheck},
						
						(* Take the intersection of our batch containers and each rack list from above *)
						containerCheck=Intersection[batchContainers,#]&/@Join[controlledRateFreezerCompatibleContainers,insulatedCoolerCompatibleContainers];
						
						(* Check if there is at least one rack that contains all of the containers for the batch *)
						MemberQ[Sort/@containerCheck,Sort[batchContainers]]
					]
				]/@batchedContainerModels,
				
				(* Otherwise, return True *)
				{True}
			];
			
			(* Check if any batches failed *)
			validBatchContainersQ=And@@validBatchContainersList;
			
			(* Find which batches have mixed containers *)
			mixedBatchIndices=Flatten[Position[validBatchContainersList,False]];
			
			(* If any batches have mixed containers and messages are on, throw an error -- do not throw this error if there is a sample in batches that is missing from input samples *)
			If[
				!validBatchContainersQ&&specifiedBatchSamplesQ&&messages,
				Message[Error::FreezeCellsInconsistentBatchContainers,mixedBatchIndices]
			];
			
			(* If gathering tests, create a passing or failing test *)
			validBatchContainersTest=Which[
				!gatherTests,Nothing,
				gatherTests&&validBatchContainersQ,Test["Specified batches do not have containers that are inconsistent with each other:",True,True],
				gatherTests&&!validBatchContainersQ,Test["Specified batches do not have containers that are inconsistent with each other:",True,False]
			];
			
			(* ----- Do Batches contain sample containers that are incompatible with the specified FreezingMethods? ----- *)
			
			(* Check if we have any containers that are compatible with both methods *)
			universallyCompatibleContainers=Function[
				container,
				Module[{compatibilityCheck},
					
					(* Check if the container is in a list in both compatible *)
					compatibilityCheck=And[
						MemberQ[Flatten[controlledRateFreezerCompatibleContainers],container],
						MemberQ[Flatten[insulatedCoolerCompatibleContainers],container]
					];
					
					(* If the container is compatible with both methods, return it *)
					If[
						compatibilityCheck,
						container,
						Nothing
					]
				]
			]/@containerModels;
			
			(* Make a list of ControlledRateFreezer only containers *)
			controlledRateFreezerOnlyContainers=If[
				MemberQ[Flatten[controlledRateFreezerCompatibleContainers],#],
				#,
				Nothing
			]&/@Complement[containerModels,universallyCompatibleContainers];
			
			(* Make a list of InsulatedCooler only containers *)
			insulatedCoolerOnlyContainers=If[
				MemberQ[Flatten[insulatedCoolerCompatibleContainers],#],
				#,
				Nothing
			]&/@Complement[containerModels,universallyCompatibleContainers];
			
			(* Categorize the containers *)
			categorizedContainers=If[
				MatchQ[initialBatches,Except[{Automatic..}]],
				Function[
					batchContainers,
					Which[
						MemberQ[universallyCompatibleContainers,#],"Universal",
						MemberQ[controlledRateFreezerOnlyContainers,#],"ControlledRateFreezer",
						MemberQ[insulatedCoolerOnlyContainers,#],"InsulatedCooler"
					]&/@batchContainers
				]/@batchedContainerModels
			];
			
			(* Check if any batches contain incompatible containers *)
			validMethodContainersList=If[
				MatchQ[initialBatches,Except[{Automatic..}]]&&MatchQ[preResolvedMethods,Except[Automatic]],
				MapThread[
					Function[
						{method,containerCategories},
						Which[
							
							(* If method is ControlledRateFreezer, check that we only have universal and controlled rate freezer containers *)
							MatchQ[method,ControlledRateFreezer],!MemberQ[containerCategories,"InsulatedCooler"],
							
							(* If method is InsulatedCooler, check that we only have universal and insulated cooler freezer containers *)
							MatchQ[method,InsulatedCooler],!MemberQ[containerCategories,"ControlledRateFreezer"],
							
							(* If method is Automatic, check that we only have universal and controlled rate freezer containers *)
							MatchQ[method,Automatic],!MemberQ[containerCategories,"InsulatedCooler"]
						]
					],
					{preResolvedMethods,categorizedContainers}
				],
				{True}
			];
			
			(* Check if any batches failed *)
			validMethodContainersQ=And@@validMethodContainersList;
			
			(* Find which batches have mixed containers *)
			invalidMethodContainerIndices=Flatten[Position[validMethodContainersList,False]];
			
			(* If any batches have mixed containers and messages are on, throw an error -- do not throw this error if there is a sample in batches that is missing from input samples *)
			If[
				!validMethodContainersQ&&messages,
				Message[Error::FreezeCellsBatchesMethodInconsistent,invalidMethodContainerIndices]
			];
			
			(* If gathering tests, create a passing or failing test *)
			validMethodContainersTest=Which[
				!gatherTests,Nothing,
				gatherTests&&validMethodContainersQ,Test["Specified batches do not have containers inconsistent with the specified freezing methods:",True,True],
				gatherTests&&!validMethodContainersQ,Test["Specified batches do not have containers inconsistent with the specified freezing methods:",True,False]
			];
			
			(* ----- Are Batches copacetic with FreezingContainers and Instruments? ----- *)
			
			(* Find the container heights *)
			batchedContainerHeights=Function[
				innerList,
				Last/@Lookup[fetchPacketFromCache[#,cache]&/@innerList,Dimensions]
			]/@batchedContainerModels;
			
			(* Find the types of tubes we can accommodate for each batch *)
			batchRackValidList=Which[
				
				(* If samples are duplicated across batches or have non-valid containers, skip this error since we already have to fix batches *)
				Or[!validBatchContainersQ,!nonDuplicatedSamplesAcrossBatchesQ],{True},
				
				(* If Batches are not specified, carry on *)
				MatchQ[initialBatches,{Automatic..}],{True},
				
				(* If Batches are specified without FreezingContainers or Instruments, carry on *)
				MatchQ[initialBatches,Except[{Automatic..}]]&&MatchQ[initialFreezingContainers,{Automatic..}]&&MatchQ[initialInstruments,{Automatic..}],{True},
				
				(* Otherwise, check that everything is copacetic *)
				True,MapThread[
					Function[
						{instrument,freezingContainer,containerModelList,ContainerHeightList},
						
						(* Check that the container models fit in the specified instrument or freezing container *)
						Which[
							
							(* If the user specified an instrument object *)
							MatchQ[instrument,ObjectP[Object[Instrument,ControlledRateFreezer]]],Module[{rackHeights,controlledRFRackFPBools},
								
								(* Find the heights of the racks *)
								rackHeights=Max[Lookup[#,MaxHeight]]&/@Lookup[(fetchPacketFromCache[#,cache]&/@controlledRateFreezerRacks),Positions];
								
								(* Generate a boolean list for compatible footprint for freezerRack*)
								controlledRFRackFPBools=CompatibleFootprintQ[ConstantArray[ToList[controlledRateFreezerRacks],Length[containerModelList]],containerModelList,Tolerance->ConstantArray[containerTolerance,Length[containerModelList]],Cache->cache,FlattenOutput->False];
								
								(* Check if they are compatible *)
								And@@MapThread[
									Function[
										{containerHeight,compatibleControlledRFRackFPBBool},
										MemberQ[
											Apply[And,#]&/@Transpose[{
												
												(* Does the container fit into the rack? *)
												ToList[compatibleControlledRFRackFPBBool],
												
												(* Is the container dramatically shorter than the container? -- CompatibleFootprintQ only checks that the rack height is above the container so basically any container will fit into 5mL Mr Frosty even though that is not what we want in general because the liquid height in Mr Frosty has to be above the liquid in the container for effective freezing *)
												(#-containerTolerance<=containerHeight<=#+containerTolerance)&/@rackHeights
											}],
											True
										]
									],
									{ContainerHeightList,controlledRFRackFPBools}
								]
							],
							
							(* If the user specified an instrument model *)
							MatchQ[instrument,ObjectP[Model[Instrument,ControlledRateFreezer]]],Module[{rackHeights,controlledRFRackFPBools},
								
								(* Find the heights of the racks *)
								rackHeights=Max[Lookup[#,MaxHeight]]&/@Lookup[(fetchPacketFromCache[#,cache]&/@controlledRateFreezerRacks),Positions];
								
								(* Generate a boolean list for compatible footprint for freezerRack*)
								controlledRFRackFPBools=CompatibleFootprintQ[ConstantArray[ToList[controlledRateFreezerRacks],Length[containerModelList]],containerModelList,Tolerance->ConstantArray[containerTolerance,Length[containerModelList]],Cache->cache,FlattenOutput->False];
								
								(* Check if they are compatible *)
								And@@MapThread[
									Function[
										{containerHeight,compatibleControlledRFRackFPBBool},
										MemberQ[
											Apply[And,#]&/@Transpose[{
												
												(* Does the container fit into the rack? *)
												ToList[compatibleControlledRFRackFPBBool],
												
												(* Is the container dramatically shorter than the container? -- CompatibleFootprintQ only checks that the rack height is above the container so basically any container will fit into 5mL Mr Frosty even though that is not what we want in general because the liquid height in Mr Frosty has to be above the liquid in the container for effective freezing *)
												(#-containerTolerance<=containerHeight<=#+containerTolerance)&/@rackHeights
											}],
											True
										]
									],
									{ContainerHeightList,controlledRFRackFPBools}
								]
							],
							
							(* If the user specified an insulated rack object *)
							MatchQ[freezingContainer,ObjectP[Object[Container,Rack,InsulatedCooler]]],Module[{insulatedCoolerModel,insulatedCoolerHeight,controlledInsulatedCoolerFPBools},
							
								(* Find the rack's model *)
								insulatedCoolerModel=Download[Lookup[fetchPacketFromCache[freezingContainer,cache],Model],Object];
								
								(* Find the heights of the insulated cooler *)
								insulatedCoolerHeight=Max[Lookup[Lookup[fetchPacketFromCache[insulatedCoolerModel,cache],Positions],MaxHeight]];
								
								(* Generate a boolean list for compatible footprint for insulateCooler*)
								controlledInsulatedCoolerFPBools=CompatibleFootprintQ[ConstantArray[ToList[insulatedCoolerModel],Length[containerModelList]],containerModelList,Tolerance->ConstantArray[containerTolerance,Length[containerModelList]],Cache->cache,FlattenOutput->False];
								
								(* Check if they are compatible *)
								And@@MapThread[
									Function[
										{containerHeight,insulatedCoolerRackFPBool},
										And[
											(* Does the container fit into the rack? *)
											insulatedCoolerRackFPBool,
											
											(* Is the container dramatically shorter than the container? -- CompatibleFootprintQ only checks that the rack height is above the container so basically any container will fit into 5mL Mr Frosty even though that is not what we want in general because the liquid height in Mr Frosty has to be above the liquid in the container for effective freezing *)
											(insulatedCoolerHeight-containerTolerance<=containerHeight<=insulatedCoolerHeight+containerTolerance)
										]
									],
									{ContainerHeightList,controlledInsulatedCoolerFPBools}
								]
							],
							
							(* If the user specified an insulated rack model *)
							MatchQ[freezingContainer,ObjectP[Model[Container,Rack,InsulatedCooler]]],Module[{insulatedCoolerHeight,controlledInsulatedCoolerFPBools},
								
								(* Find the heights of the insulated cooler *)
								insulatedCoolerHeight=Max[Lookup[Lookup[fetchPacketFromCache[freezingContainer,cache],Positions],MaxHeight]];
								
								(* Generate a boolean list for compatible footprint for insulateCooler*)
								controlledInsulatedCoolerFPBools=CompatibleFootprintQ[ConstantArray[freezingContainer,Length[containerModelList]],containerModelList,Tolerance->ConstantArray[containerTolerance,Length[containerModelList]],Cache->cache,FlattenOutput->False];
								
								(* Check if they are compatible *)
								And@@MapThread[
									Function[
										{containerHeight,insulatedCoolerRackFPBool},
										And[
											(* Does the container fit into the rack? *)
											insulatedCoolerRackFPBool,
											
											(* Is the container dramatically shorter than the container? -- CompatibleFootprintQ only checks that the rack height is above the container so basically any container will fit into 5mL Mr Frosty even though that is not what we want in general because the liquid height in Mr Frosty has to be above the liquid in the container for effective freezing *)
											(insulatedCoolerHeight-containerTolerance<=containerHeight<=insulatedCoolerHeight+containerTolerance)
										]
									],
									{ContainerHeightList,controlledInsulatedCoolerFPBools}
								]
							],
							
							(* Otherwise, we are good *)
							True,True
						]
					],
					{initialInstruments,initialFreezingContainers,batchedContainerModels,batchedContainerHeights}
				]
			];
			
			(* Create a bool for error checking *)
			batchRackValidQ=And@@Flatten[batchRackValidList];
			
			(* Find the batches that failed *)
			invalidBatchRackIndices=If[
				!batchRackValidQ,
				Flatten[Position[batchRackValidList,False]]
			];
			
			(* Find the options that were specified *)
			invalidBatchRackOptions=Which[
				
				(* If we didn't fail, carry on *)
				batchRackValidQ,{},
				
				(* If only freezing containers were specified *)
				MatchQ[initialInstruments,Except[{Automatic..}]]&&MatchQ[initialFreezingContainers,{Automatic..}],{Instruments},
				
				(* If only freezing containers were specified *)
				MatchQ[initialInstruments,{Automatic..}]&&MatchQ[initialFreezingContainers,Except[{Automatic..}]],{FreezingContainers},
				
				(* Otherwise, both options were specified *)
				True,Module[{optionsAtFailedIndices},
					
					(* Make a list of the options at the failed indices *)
					optionsAtFailedIndices=Part[Transpose[{initialInstruments,initialFreezingContainers}],invalidBatchRackIndices];
					
					(* Return which one failed *)
					Which[
						
						(* If both steps failed *)
						MatchQ[Cases[optionsAtFailedIndices,{Null,_}],Except[{}]]&&MatchQ[Cases[optionsAtFailedIndices,{_,Null}],Except[{}]],{FreezingContainers,Instruments},
						
						(* If only instruments failed *)
						MatchQ[Cases[optionsAtFailedIndices,{_,Null}],Except[{}]],{Instruments},
						
						(* If only freezing containers failed *)
						MatchQ[Cases[optionsAtFailedIndices,{Null,_}],Except[{}]],{FreezingContainers}
					]
				]
			];
			
			(* If any batches has containers that don't fit into the specified rack and messages are on, throw an error *)
			If[
				!batchRackValidQ&&messages,
				Message[Error::FreezeCellsBatchesRackInconsistent,invalidBatchRackOptions,invalidBatchRackIndices]
			];
			
			(* If gathering tests, create a passing or failing test *)
			batchRackValidTest=Which[
				!gatherTests,Nothing,
				gatherTests&&batchRackValidQ,Test["Specified batches are not inconsistent with the racks on specified Instruments or FreezingContainers:",True,True],
				gatherTests&&!batchRackValidQ,Test["Specified batches are not inconsistent with the racks on specified Instruments or FreezingContainers:",True,False]
			];
			
			(* ----- Are batch lengths copacetic with FreezingMethods and Instruments? ----- *)
			
			(* Find the number of positions we have on each allowed rack *)
			allowedRackMaxPositions=Lookup[fetchPacketFromCache[#,cache]&/@allowedRacks,NumberOfPositions];
			
			(*we are only checking against the first container model because if the container models don't all fit into the same rack, we already threw an error with validBatchContainersQ*)
			batchedContainerModelList=First/@batchedContainerModels;
			
			(* Build boolean for the compatible foot*)
			controlledRFRackFPBoolList=CompatibleFootprintQ[ConstantArray[ToList[controlledRateFreezerRacks],Length[batchedContainerModelList]],batchedContainerModelList,Tolerance->ConstantArray[containerTolerance,Length[batchedContainerModelList]],Cache->cache,FlattenOutput->False];
			
			(* Find all the rack models for insulated coolers *)
			racks=Lookup[insulatedCoolerModelPackets,Object];
			
			(* Check the compatibleFootPrintQ for every allowed racks here *)
			rackFPBoolList=CompatibleFootprintQ[ConstantArray[racks,Length[batchedContainerModelList]],batchedContainerModelList,Tolerance->ConstantArray[containerTolerance,Length[batchedContainerModelList]],Cache->cache,FlattenOutput->False];
			
			(* Find the max number of positions we can accommodate for each batch *)
			maxBatchLengths=If[
				
				(* If batch is specified, and we don't have any errors from above, figure out how many tubes we can have per batch -- if samples are duplicated across batches or have non-valid containers, we shouldn't also throw this error as having any inconsistencies in the containers will cause issues in this error check *)
				MatchQ[initialBatches,Except[{Automatic..}]]&&validBatchContainersQ&&nonDuplicatedSamplesAcrossBatchesQ,
				MapThread[
					Function[
						{method,instrument,freezingContainer,ContainerHeightList,controlledRFRackFPBool,rackFPBool},
						
						Which[
							
							(* If the user specified an instrument object, find the model's possible racks and their max number of spots *)
							MatchQ[instrument,ObjectP[Object[Instrument,ControlledRateFreezer]]],Module[{rackHeights,rackCheck,compatibleRacks},
								
								(* Find the heights of the racks *)
								rackHeights=Max[Lookup[#,MaxHeight]]&/@Lookup[fetchPacketFromCache[#,cache]&/@controlledRateFreezerRacks,Positions];
								
								(* Check if our containers fit into the racks -- we are only checking against the first container model because if the container models don't all fit into the same rack, we already threw an error with validBatchContainersQ *)
								rackCheck=Apply[And,#]&/@Transpose[{
									
									(* Does the container fit into the rack? *)
									ToList[controlledRFRackFPBool],
									
									(* Is the container dramatically shorter than the container? -- CompatibleFootprintQ only checks that the rack height is above the container so basically any container will fit into 5mL Mr Frosty even though that is not what we want in general because the liquid height in Mr Frosty has to be above the liquid in the container for effective freezing *)
									(#-containerTolerance<=First[ContainerHeightList]<=#+containerTolerance)&/@rackHeights
								}];
								
								(* Find the racks that are compatible with the sample containers *)
								compatibleRacks=Pick[controlledRateFreezerRacks,rackCheck,True];
								
								(* Return the max number of spots in compatible racks *)
								Max[Lookup[fetchPacketFromCache[#,cache]&/@compatibleRacks,NumberOfPositions]]
							],
							
							(* If the user specified an instrument model, find the max number of spots for the compatible racks for that model *)
							MatchQ[instrument,ObjectP[Model[Instrument,ControlledRateFreezer]]],Module[{rackHeights,rackCheck,compatibleRacks},
								
								(* Find the heights of the racks *)
								rackHeights=Max[Lookup[#,MaxHeight]]&/@Lookup[fetchPacketFromCache[#,cache]&/@controlledRateFreezerRacks,Positions];
								
								(* Check if our containers fit into the racks -- we are only checking against the first container model because if the container models don't all fit into the same rack, we already threw an error with validBatchContainersQ *)
								rackCheck=Apply[And,#]&/@Transpose[{
									
									(* Does the container fit into the rack? *)
									ToList[controlledRFRackFPBool],
									
									(* Is the container dramatically shorter than the container? -- CompatibleFootprintQ only checks that the rack height is above the container so basically any container will fit into 5mL Mr Frosty even though that is not what we want in general because the liquid height in Mr Frosty has to be above the liquid in the container for effective freezing *)
									(#-containerTolerance<=First[ContainerHeightList]<=#+containerTolerance)&/@rackHeights
								}];
								
								(* Find the racks that are compatible with the sample containers *)
								compatibleRacks=Pick[controlledRateFreezerRacks,rackCheck,True];
								
								(* Return the max number of spots in compatible racks *)
								Max[Lookup[fetchPacketFromCache[#,cache]&/@compatibleRacks,NumberOfPositions]]
							],
							
							(* If the user specified an insulated rack object, find its max number of spots *)
							MatchQ[freezingContainer,ObjectP[Object[Container,Rack,InsulatedCooler]]],Lookup[fetchPacketFromCache[freezingContainer,cache],NumberOfPositions],
							
							(* If the user specified an insulated rack model, find its max number of spots *)
							MatchQ[freezingContainer,ObjectP[Model[Container,Rack,InsulatedCooler]]],Lookup[fetchPacketFromCache[freezingContainer,cache],NumberOfPositions],
							
							(* If the user specified a ControlledRateFreezer method, find the max number of spots the method can accommodate *)
							MatchQ[method,ControlledRateFreezer],Module[{rackHeights,rackCheck,compatibleRacks},
								
								(* Find the heights of the racks *)
								rackHeights=Max[Lookup[#,MaxHeight]]&/@Lookup[fetchPacketFromCache[#,cache]&/@controlledRateFreezerRacks,Positions];
								
								(* Check if our containers fit into the racks -- we are only checking against the first container model because if the container models don't all fit into the same rack, we already threw an error with validBatchContainersQ *)
								rackCheck=Apply[And,#]&/@Transpose[{
									
									(* Does the container fit into the rack? *)
									ToList[controlledRFRackFPBool],
									
									(* Is the container dramatically shorter than the container? -- CompatibleFootprintQ only checks that the rack height is above the container so basically any container will fit into 5mL Mr Frosty even though that is not what we want in general because the liquid height in Mr Frosty has to be above the liquid in the container for effective freezing *)
									(#-containerTolerance<=First[ContainerHeightList]<=#+containerTolerance)&/@rackHeights
								}];
								
								(* Find the racks that are compatible with the sample containers *)
								compatibleRacks=Pick[controlledRateFreezerRacks,rackCheck,True];
								
								(* Return the max number of spots in compatible racks *)
								Max[Lookup[fetchPacketFromCache[#,cache]&/@compatibleRacks,NumberOfPositions]]
							],
							
							(* If the user specified a InsulatedCooler method, find the max number of spots the method can accommodate *)
							MatchQ[method,InsulatedCooler],Module[{racks,rackHeights,rackCheck,compatibleRacks},
								
								(* Find all the rack models for insulated coolers *)
								racks=Lookup[insulatedCoolerModelPackets,Object];
								
								(* Find the heights of the racks *)
								rackHeights=Max[Lookup[#,MaxHeight]]&/@Lookup[fetchPacketFromCache[#,cache]&/@racks,Positions];
								
								(* Check if our containers fit into the racks -- we are only checking against the first container model because if the container models don't all fit into the same rack, we already threw an error with validBatchContainersQ *)
								rackCheck=Apply[And,#]&/@Transpose[{
									
									(* Does the container fit into the rack? *)
									ToList[rackFPBool],
									
									(* Is the container dramatically shorter than the container? -- CompatibleFootprintQ only checks that the rack height is above the container so basically any container will fit into 5mL Mr Frosty even though that is not what we want in general because the liquid height in Mr Frosty has to be above the liquid in the container for effective freezing *)
									(#-containerTolerance<=First[ContainerHeightList]<=#+containerTolerance)&/@rackHeights
								}];
								
								(* Find the racks that are compatible with the sample containers *)
								compatibleRacks=Pick[racks,rackCheck,True];
								
								(* Return the max number of spots in compatible racks *)
								Max[Lookup[fetchPacketFromCache[#,cache]&/@compatibleRacks,NumberOfPositions]]
							],
							
							(* Otherwise, user only specified batches without instruments, methods or freezing container so the experiment will default to Method->ControlledRateFreezer. Therefore, we need to do the same check as that *)
							True,Module[{rackHeights,rackCheck,compatibleRacks},
								
								(* Find the heights of the racks *)
								rackHeights=Max[Lookup[#,MaxHeight]]&/@Lookup[fetchPacketFromCache[#,cache]&/@controlledRateFreezerRacks,Positions];
								
								(* Check if our containers fit into the racks -- we are only checking against the first container model because if the container models don't all fit into the same rack, we already threw an error with validBatchContainersQ *)
								rackCheck=Apply[And,#]&/@Transpose[{
									
									(* Does the container fit into the rack? *)
									ToList[controlledRFRackFPBool],
									
									(* Is the container dramatically shorter than the container? -- CompatibleFootprintQ only checks that the rack height is above the container so basically any container will fit into 5mL Mr Frosty even though that is not what we want in general because the liquid height in Mr Frosty has to be above the liquid in the container for effective freezing *)
									(#-containerTolerance<=First[ContainerHeightList]<=#+containerTolerance)&/@rackHeights
								}];
								
								(* Find the racks that are compatible with the sample containers *)
								compatibleRacks=Pick[controlledRateFreezerRacks,rackCheck,True];
								
								(* Return the max number of spots in compatible racks *)
								Max[Lookup[fetchPacketFromCache[#,cache]&/@compatibleRacks,NumberOfPositions]]
							]
						]
					],
					{initialFreezingMethods,initialInstruments,initialFreezingContainers,batchedContainerHeights,controlledRFRackFPBoolList,rackFPBoolList}
				]
			];
			
			(* Check if the batch size is less than max allowed *)
			batchLengthsValidList=If[
				MatchQ[initialBatches,Except[{Automatic..}]]&&validBatchContainersQ&&nonDuplicatedSamplesAcrossBatchesQ,
				MapThread[Length[#1]<=#2&,{initialBatches,maxBatchLengths}],
				{True}
			];
			
			(* Create a bool for error checking *)
			batchLengthsValidQ=And@@batchLengthsValidList;
			
			(* Find the batches that failed *)
			excessiveBatchIndices=Flatten[Position[batchLengthsValidList,False]];
			
			(* Find the batches that failed *)
			excessiveBatchMaxLengths=Pick[maxBatchLengths,batchLengthsValidList,False];
			
			(* If any batches are too big and messages are on, throw an error *)
			If[
				!batchLengthsValidQ&&messages,
				Message[Error::FreezeCellsExcessiveBatchLengths,excessiveBatchIndices,excessiveBatchMaxLengths]
			];
			
			(* If gathering tests, create a passing or failing test *)
			batchLengthsValidTest=Which[
				!gatherTests,Nothing,
				gatherTests&&batchLengthsValidQ,Test["Specified batches do not exceed the maximum possible batch size based on specified or default options:",True,True],
				gatherTests&&!batchLengthsValidQ,Test["Specified batches do not exceed the maximum possible batch size based on specified or default options:",True,False]
			];
		]
	];
	
	(* ----- Are FreezingMethods specified with mixed types without Batches? ----- *)
	
	(* Find if mixed methods are specified without Batches -- we are removing the Automatic steps, since the user did not specify anything *)
	methodTypesValidQ=If[
		MatchQ[initialBatches,{Automatic..}]&&!MatchQ[preResolvedMethods,Automatic],
		Length[DeleteDuplicates[preResolvedMethods/.Automatic->Nothing]]==1,
		True
	];
	
	If[
		!methodTypesValidQ&&messages&&!MatchQ[$ECLApplication,Engine],
		Message[Warning::FreezeCellsMixedMethodTypes]
	];
	
	(* ----- Are Instruments copacetic with FreezingMethods? ----- *)
	
	(* Check if the instrument and methods are copacetic *)
	instrumentCompatibleList=If[
		
		(* If both instruments and methods are specified, compare the two *)
		MatchQ[initialInstruments,Except[{Automatic..}]]&&MatchQ[initialFreezingMethods,Except[{Automatic..}]],
		MapThread[
			Function[
				{instrument,method},
				Which[
					MatchQ[method,ControlledRateFreezer],MatchQ[instrument,Automatic|ObjectP[{Model[Instrument,ControlledRateFreezer],Object[Instrument,ControlledRateFreezer]}]],
					MatchQ[method,InsulatedCooler],MatchQ[instrument,Automatic|ObjectP[{Model[Instrument,Freezer],Object[Instrument,Freezer]}]]
				]
			],
			{initialInstruments,initialFreezingMethods}
		],
		
		(* Otherwise, we are good *)
		{True}
	];
	
	(* Create a bool for error checking *)
	instrumentCompatibleQ=And@@instrumentCompatibleList;
	
	(* Find which instruments are inconsistent *)
	incompatibleInstruments=If[
		!instrumentCompatibleQ,
		Pick[initialInstruments,instrumentCompatibleList,False]
	];
	
	(* Find the indices of inconsistent instruments *)
	incompatibleInstrumentIndices=If[
		!instrumentCompatibleQ,
		Flatten[Position[instrumentCompatibleList,False]]
	];
	
	(* If we have any invalid options and messages are on, throw an error *)
	If[
		!instrumentCompatibleQ&&messages,
		Message[Error::FreezeCellsInstrumentIncompatibleWithMethod,incompatibleInstruments,incompatibleInstrumentIndices]
	];
	
	(* If gathering tests, create a passing or failing test *)
	instrumentCompatibleTest=Which[
		!gatherTests,Nothing,
		gatherTests&&instrumentCompatibleQ,Test["If Instruments and FreezingMethods are not specified, the specified instrument is compatible with the specified method:",True,True],
		gatherTests&&!instrumentCompatibleQ,Test["If Instruments and FreezingMethods are not specified, the specified instrument is compatible with the specified method:",True,False]
	];
	
	(* ----- Do Instruments contain Object[Instrument,Freezer]? ----- *)
	
	(* Check if any freezer objects were specified *)
	freezerObjectSpecifiedQ=MemberQ[initialInstruments,ObjectP[Object[Instrument,Freezer]]];
	
	(* Find the freezer objects *)
	freezerObjects=If[
		freezerObjectSpecifiedQ,
		Cases[initialInstruments,ObjectP[Object[Instrument,Freezer]]]
	];
	
	(* If we have any warming steps, display a warning *)
	If[
		freezerObjectSpecifiedQ&&messages&&!MatchQ[$ECLApplication,Engine],
		Message[Warning::FreezeCellsIgnoredFreezerObject,freezerObjects]
	];
	
	(* ----- Are FreezingRates, Durations and ResidualTemperatures copacetic? ----- *)
	
	(* Check if constant rate options fit their patterns and make mathematical sense *)
	constantRateOptionsValidList=MapThread[
		Function[
			{freezingRate,duration,residualTemperature},
			Which[
				
				(* If none or a single one are specified, we are good *)
				Or[
					MatchQ[freezingRate,Null|Automatic]&&MatchQ[duration,Null|Automatic]&&MatchQ[residualTemperature,Null|Automatic],
					MatchQ[freezingRate,Except[Null|Automatic]]&&MatchQ[duration,Automatic]&&MatchQ[residualTemperature,Automatic],
					MatchQ[freezingRate,Automatic]&&MatchQ[duration,Except[Null|Automatic]]&&MatchQ[residualTemperature,Automatic],
					MatchQ[freezingRate,Automatic]&&MatchQ[duration,Automatic]&&MatchQ[residualTemperature,Except[Null|Automatic]]
				],{{},True},
				
				(* If all three are specified, make sure they are copacetic *)
				MatchQ[freezingRate,Except[Null|Automatic]]&&MatchQ[duration,Except[Null|Automatic]]&&MatchQ[residualTemperature,Except[Null|Automatic]],{
					{FreezingRates,Durations,ResidualTemperatures},
					20 Celsius-(freezingRate*duration)==residualTemperature
				},
				
				(* If FreezingRates and Durations are specified, make sure ResidualTemperatures fits its pattern *)
				MatchQ[freezingRate,Except[Null|Automatic]]&&MatchQ[duration,Except[Null|Automatic]],{
					{FreezingRates,Durations},
					-100 Celsius<=(20 Celsius-(freezingRate*duration))<=22Celsius
				},
				
				(* If FreezingRates and ResidualTemperatures are specified, make sure Durations fits its pattern *)
				MatchQ[freezingRate,Except[Null|Automatic]]&&MatchQ[residualTemperature,Except[Null|Automatic]],{
					{FreezingRates,ResidualTemperatures},
					0 Minute<((20 Celsius-residualTemperature)/freezingRate)<=$MaxExperimentTime
				},
				
				(* If ResidualTemperatures and Durations are specified, make sure FreezingRates fits its pattern *)
				MatchQ[residualTemperature,Except[Null|Automatic]]&&MatchQ[duration,Except[Null|Automatic]],{
					{Durations,ResidualTemperatures},
					0.01 Celsius/Minute<=((20 Celsius-residualTemperature)/duration)<=2 Celsius/Minute
				}
			]
		],
		{roundedFreezingRates,roundedDurations,roundedResidualTemperatures}
	];
	
	(* Check if we have any options that do not match its pattern *)
	constantRateOptionsValidQ=If[
		MatchQ[Cases[constantRateOptionsValidList,{Except[{FreezingRates,Durations,ResidualTemperatures}],False}],Except[{}]],
		And@@(Last/@Cases[constantRateOptionsValidList,{Except[{FreezingRates,Durations,ResidualTemperatures}],False}]),
		True
	];
	
	(* Find which batches have values that do not fit their pattern *)
	invalidConstantRateIndices=If[
		!constantRateOptionsValidQ,
		Flatten[Position[constantRateOptionsValidList,{Except[{FreezingRates,Durations,ResidualTemperatures}],False}]]
	];
	
	(* Find the specified options for invalid batches *)
	invalidConstantRateOptions=If[
		!constantRateOptionsValidQ,
		First/@Part[constantRateOptionsValidList,invalidConstantRateIndices],
		{}
	];
	
	(* Find the third option whose pattern is invalid *)
	missingInvalidConstantRateOption=If[
		!constantRateOptionsValidQ,
		Complement[{FreezingRates,Durations,ResidualTemperatures},#]
	]&/@invalidConstantRateOptions;
	
	(* If we have any invalid options and messages are on, throw an error *)
	If[
		!constantRateOptionsValidQ&&messages,
		Message[Error::FreezeCellsInvalidConstantRateOptions,invalidConstantRateOptions,missingInvalidConstantRateOption,invalidConstantRateIndices]
	];
	
	(* If gathering tests, create a passing or failing test *)
	constantRateOptionsValidTest=Which[
		!gatherTests,Nothing,
		gatherTests&&constantRateOptionsValidQ,Test["If two or more options amongst FreezingRates, Durations and ResidualTemperatures are specified, the third option generates values that matches their pattern:",True,True],
		gatherTests&&!constantRateOptionsValidQ,Test["If two or more options amongst FreezingRates, Durations and ResidualTemperatures are specified, the third option generates values that matches their pattern:",True,False]
	];
	
	(* Check if we have mathematically inconsistent options *)
	constantRateOptionsConsistentQ=If[
		MatchQ[Cases[constantRateOptionsValidList,{{FreezingRates,Durations,ResidualTemperatures},False}],Except[{}]],
		And@@(Last/@Cases[constantRateOptionsValidList,{{FreezingRates,Durations,ResidualTemperatures},False}]),
		True
	];
	
	(* Find which batches have mathematically inconsistent values *)
	incompatibleConstantRateOptionsIndices=If[
		!constantRateOptionsConsistentQ,
		Flatten[Position[constantRateOptionsValidList,{{FreezingRates,Durations,ResidualTemperatures},False}]]
	];
	
	(* If we have mathematically inconsistent options and messages are on, throw an error *)
	If[
		!constantRateOptionsConsistentQ&&messages,
		Message[Error::FreezeCellsInconsistentConstantRateOptions,incompatibleConstantRateOptionsIndices]
	];
	
	(* If gathering tests, create a passing or failing test *)
	constantRateOptionsConsistentTest=Which[
		!gatherTests,Nothing,
		gatherTests&&constantRateOptionsValidQ,Test["If FreezingRates, Durations and ResidualTemperatures are specified, their values are mathematically consistent:",True,True],
		gatherTests&&!constantRateOptionsValidQ,Test["If FreezingRates, Durations and ResidualTemperatures are specified, their values are mathematically consistent:",True,False]
	];
	
	(* ----- Do FreezingProfiles have increasing time steps? ----- *)
	
	(* Find if freezing profiles have increasing time steps *)
	freezingProfilesIncreasingTimeStepList=If[
		
		(* If FreezingProfiles is specified *)
		MatchQ[roundedFreezingProfiles,Except[{Automatic..}]],
		Function[
			freezingProfile,
			If[
				MatchQ[freezingProfile,Except[Automatic|Null]],
				Module[{timeDifferences},
					
					(* Extract the differences between each step *)
					timeDifferences=Differences[Last[Transpose[freezingProfile]]];
					
					(* Check if any steps have a negative or zero time difference *)
					And@@(#>0 Minute&/@timeDifferences)
				],
				True
			]
		]/@roundedFreezingProfiles,
		
		(* Otherwise, we are good *)
		{True}
	];
	
	(* Create a bool for error checking *)
	freezingProfilesIncreasingTimeStepQ=And@@freezingProfilesIncreasingTimeStepList;
	
	(* Find which batches have warming steps *)
	failedTimeStepIndices=If[
		!freezingProfilesIncreasingTimeStepQ,
		Flatten[Position[freezingProfilesIncreasingTimeStepList,False]]
	];
	
	(* If we have any invalid rates and messages are on, throw an error *)
	If[
		!freezingProfilesIncreasingTimeStepQ&&messages,
		Message[Error::FreezeCellsInvalidTimeSpecification,failedTimeStepIndices]
	];
	
	(* If gathering tests, create a passing or failing test *)
	freezingProfilesIncreasingTimeStepTest=Which[
		!gatherTests,Nothing,
		gatherTests&&freezingProfilesIncreasingTimeStepQ,Test["FreezingProfiles do not contain any steps where the specified time is decreasing:",True,True],
		gatherTests&&!freezingProfilesIncreasingTimeStepQ,Test["FreezingProfiles do not contain any steps where the specified time is decreasing:",True,False]
	];
	
	(* ----- Do FreezingProfiles include heating steps? ----- *)
	
	(* Find if freezing profiles have any heating steps *)
	freezingProfilesWarmingStepList=If[
		
		(* If FreezingProfiles is specified *)
		MatchQ[roundedFreezingProfiles,Except[{Automatic..}]],
		Function[
			freezingProfile,
			If[
				MatchQ[freezingProfile,Except[Automatic|Null]],
				Module[{temperatureDifferences},
					
					(* Extract the differences between each step *)
					temperatureDifferences=Differences[First[Transpose[freezingProfile]]];
					
					(* Check if any steps have a positive temperature difference *)
					Or@@(#>0 Celsius&/@temperatureDifferences)
				],
				False
			]
		]/@roundedFreezingProfiles,
		
		(* Otherwise, we are good *)
		{False}
	];
	
	(* Create a bool for error checking *)
	freezingProfilesWarmingStepQ=Or@@freezingProfilesWarmingStepList;
	
	(* Find which batches have warming steps *)
	freezingProfilesWarmingStepIndices=If[
		freezingProfilesWarmingStepQ,
		Flatten[Position[freezingProfilesWarmingStepList,True]]
	];
	
	(* If we have any warming steps, display a warning *)
	If[
		freezingProfilesWarmingStepQ&&messages&&!MatchQ[$ECLApplication,Engine],
		Message[Warning::FreezeCellsProfileContainsWarmingStep,freezingProfilesWarmingStepIndices]
	];
	
	(* ----- Are FreezingProfiles copacetic with Instruments? ----- *)
	
	(* Check if the instruments and freezing profiles are copacetic *)
	validProfileCoolingRateList=Which[
		
		(* If both instruments and freezing profiles are specified *)
		MatchQ[initialInstruments,Except[{Automatic..}]]&&MatchQ[roundedFreezingProfiles,Except[{Automatic..}]],MapThread[
			Function[
				{instrument,freezingProfile},
				If[
					MatchQ[freezingProfile,Except[Automatic|Null]],
					Module[{instrumentMaxCoolingRate,temperatures,times,coolingRates},
						
						(* Fetch the instrument cooling rates *)
						instrumentMaxCoolingRate=Lookup[fetchPacketFromCache[instrument,cache],MaxCoolingRate];

						(* Make a list of times and temperatures *)
						{temperatures,times}=Transpose[freezingProfile];
						
						(* Calculate the cooling rates -- since the actual rates are negative and we made the decision to put the negative into the word "cooling" in MaxCoolingRate field, we need to flip the sign of the rate *)
						coolingRates=MapThread[-#1/#2&,{Differences[temperatures],Differences[times]}];

						(* Make sure that the cooling rate are properly bounded -- we have this weird lower bound since a negative rate indicates a heating step, for which we threw a warning above. So as long as the instrument can do it, heat your cells to your heart's content *)
						{instrumentMaxCoolingRate,And@@((-instrumentMaxCoolingRate<=#<=instrumentMaxCoolingRate)&/@coolingRates)}
					],
					{Null,True}
				]
			],
			{initialInstruments,roundedFreezingProfiles}
		],
		
		(* If only freezing profiles are specified *)
		MatchQ[roundedFreezingProfiles,Except[{Automatic..}]],Function[
			freezingProfile,
			If[
				MatchQ[freezingProfile,Except[Automatic|Null]],
				Module[{instrumentMaxCoolingRate,temperatures,times,coolingRates},
					
					(* Fetch the instrument cooling rates from our default instrument *)
					instrumentMaxCoolingRate=If[
						
						(* If we only have one model for instrument, get its max rate *)
						Length[controlledRateFreezerModelPackets]==1,
						Lookup[First[controlledRateFreezerModelPackets],MaxCoolingRate],
						
						(* Otherwise, check against the max of all the rates *)
						Max[Lookup[controlledRateFreezerModelPackets,MaxCoolingRate]]
					];
					
					(* Make a list of times and temperatures *)
					{temperatures,times}=Transpose[freezingProfile];
					
					(* Calculate the cooling rates -- since the actual rates are negative and we made the decision to put the negative into the word "cooling" in MaxCoolingRate field, we need to flip the sign of the rate *)
					coolingRates=MapThread[-#1/#2&,{Differences[temperatures],Differences[times]}];
					
					(* Make sure that the cooling rate are properly bounded -- we have this weird lower bound since a negative rate indicates a heating step, for which we threw a warning above. So as long as the instrument can do it, heat your cells to your heart's content *)
					{instrumentMaxCoolingRate,And@@((-instrumentMaxCoolingRate<=#<=instrumentMaxCoolingRate)&/@coolingRates)}
				],
				{Null,True}
			]
		]/@roundedFreezingProfiles,
		
		(* Otherwise, we are good *)
		True,{{Null,True}}
	];
	
	(* Create a bool for error checking *)
	validProfileCoolingRateQ=And@@Last[Transpose[validProfileCoolingRateList]];
	
	(* Find which batches have rates that are too high *)
	invalidProfileCoolingRateIndices=If[
		!validProfileCoolingRateQ,
		Flatten[Position[validProfileCoolingRateList,{_,False}]]
	];
	
	(* Find the max rates for the failed indices *)
	invalidMaxCoolingRates=If[
		!validProfileCoolingRateQ,
		First/@Cases[validProfileCoolingRateList,{_,False}]
	];
	
	(* If we have any invalid rates and messages are on, throw an error *)
	If[
		!validProfileCoolingRateQ&&messages,
		Message[Error::FreezeCellsExcessiveCoolingRate,invalidProfileCoolingRateIndices,invalidMaxCoolingRates]
	];
	
	(* If gathering tests, create a passing or failing test *)
	validProfileCoolingRateTest=Which[
		!gatherTests,Nothing,
		gatherTests&&validProfileCoolingRateQ,Test["FreezingProfiles do not contain any steps that would require a cooling rate above what can be achieved by the specified or default instrument:",True,True],
		gatherTests&&!validProfileCoolingRateQ,Test["FreezingProfiles do not contain any steps that would require a cooling rate above what can be achieved by the specified or default instrument:",True,False]
	];
	
	(* ----- Are FreezingContainers copacetic with sample containers? ----- *)
	
	(* Get the specified freezing containers *)
	specifiedFreezingContainerModels=If[
		MatchQ[initialFreezingContainers,Except[{Automatic..}]],
		DeleteDuplicates[Map[
			If[
				MatchQ[#,ObjectP[Model[Container,Rack,InsulatedCooler]]],
				#,
				Download[Lookup[fetchPacketFromCache[#,cache],Model],Object]
			]&,
			initialFreezingContainers/.{Null->Nothing,Automatic->Nothing}
		]]
	];
	
	(* Get the heights of our specified containers *)
	specifiedFreezingContainerHeights=If[
		MatchQ[initialFreezingContainers,Except[{Automatic..}]],
		Max[Lookup[#,MaxHeight]]&/@Lookup[fetchPacketFromCache[#,cache]&/@specifiedFreezingContainerModels,Positions]
	];
	
	(* generate compatibleFootprintQ for all allowed containers *)
	specifiedFreezingContainerFPBoolList=CompatibleFootprintQ[ConstantArray[specifiedFreezingContainerModels,Length[containerModels]],containerModels,Tolerance->ConstantArray[containerTolerance,Length[containerModels]],Cache->cache,FlattenOutput->False];
	
	(* Do a compatibility check for all of our containers -- this is an additional check for sample containers in cases where batches are not specified. We already errored out in cases where batches were specified with incompatible sample containers, and we will error out below for cases where we cannot resolve incompatible containers for ControlledRateFreezer methods. However, we still need to error check cases where FreezingContainers were specified with incompatible samples, e.g. only 5 mL FreezingContainers with 2 mL vials *)
	freezingContainerSampleCompatibleQList=If[
		MatchQ[initialBatches,{Automatic..}]&&MatchQ[initialFreezingContainers,Except[{Automatic..}]],
		MemberQ[#,True]&/@MapThread[
			Function[
				{containerHeight,specifiedFreezingContainerFPBool},
				Apply[And,#]&/@Transpose[{
					
					(* Does the container fit into the rack? *)
					ToList[specifiedFreezingContainerFPBool],
					
					(* Is the container dramatically shorter than the container? -- CompatibleFootprintQ only checks that the rack height is above the container so basically any container will fit into 5mL Mr Frosty even though that is not what we want in general because the liquid height in Mr Frosty has to be above the liquid in the container for effective freezing *)
					(#-containerTolerance<=containerHeight<=#+containerTolerance)&/@specifiedFreezingContainerHeights
				}]
			],
			{containerHeights,ToList[specifiedFreezingContainerFPBoolList]}
		],
		{True}
	];
	
	(* Check if any samples containers are incompatible *)
	freezingContainerSampleCompatibleQ=And@@freezingContainerSampleCompatibleQList;
	
	(* If there are incompatible containers, find their samples *)
	freezingContainerIncompatibleSamples=If[
		!freezingContainerSampleCompatibleQ,
		Module[{failedSampleIndices},
			
			(* Find which samples have the failed models *)
			failedSampleIndices=Flatten[Position[sampleContainerModels,#]&/@Pick[containerModels,freezingContainerSampleCompatibleQList,False]];
			
			(* Find the failed samples *)
			Part[mySamples,Sort[failedSampleIndices]]
		]
	];
	
	(* If any sample containers are incompatible with freezing containers and messages are on, throw an error *)
	If[
		!freezingContainerSampleCompatibleQ&&messages,
		Message[Error::FreezeCellsIncompatibleFreezingContainers,freezingContainerIncompatibleSamples]
	];
	
	(* If gathering tests, create a passing or failing test *)
	freezingContainerSampleCompatibleTest=Which[
		!gatherTests,Nothing,
		gatherTests&&freezingContainerSampleCompatibleQ,Test["Specified FreezingContainers and input sample containers are compatible:",True,True],
		gatherTests&&!freezingContainerSampleCompatibleQ,Test["Specified FreezingContainers and input sample containers are compatible:",True,False]
	];
	
	(* ----- Are CoolantVolumes specified without Batches or FreezingContainers? ----- *)
	
	(* Find if CoolantVolumes are specified without Batches or FreezingContainer *)
	coolantVolumeSpecificationValidQ=If[
		MatchQ[roundedCoolantVolumes,Except[{Automatic..}]],
		Or[
			MatchQ[initialFreezingContainers,Except[{Automatic..}]],
			MatchQ[initialBatches,Except[{Automatic..}]]
		],
		True
	];
	
	(* If we have any invalid options and messages are on, throw an error *)
	If[
		!coolantVolumeSpecificationValidQ&&messages,
		Message[Error::FreezeCellsInvalidCoolantVolumeSpecification]
	];
	
	(* If gathering tests, create a passing or failing test *)
	coolantVolumeSpecificationValidTest=Which[
		!gatherTests,Nothing,
		gatherTests&&coolantVolumeSpecificationValidQ,Test["CoolantVolumes are not specified without Batches or FreezingContainers:",True,True],
		gatherTests&&!coolantVolumeSpecificationValidQ,Test["CoolantVolumes are not specified without Batches or FreezingContainers:",True,False]
	];
	
	(* ----- Are Coolants non-liquid? ----- *)
	
	(* Find if Coolants are solid *)
	coolantStateValidQList=If[
		MatchQ[initialCoolants,{Automatic..}],
		{True},
		If[
			MatchQ[#,Null|Automatic],
			True,
			MatchQ[Lookup[fetchPacketFromCache[#,cache],State],Liquid]
		]&/@initialCoolants
	];
	
	(* Create a bool for error checking *)
	coolantStateValidQ=And@@coolantStateValidQList;
	
	(* Check which coolants are not liquid *)
	invalidCoolants=If[
		!coolantStateValidQ,
		Pick[initialCoolants,coolantStateValidQList,False]
	];
	
	(* If we have any invalid options and messages are on, throw an error *)
	If[
		!coolantStateValidQ&&messages,
		Message[Error::FreezeCellsInvalidCoolantState,invalidCoolants]
	];
	
	(* If gathering tests, create a passing or failing test *)
	coolantStateValidTest=Which[
		!gatherTests,Nothing,
		gatherTests&&coolantStateValidQ,Test["Specified Coolants are in liquid form:",True,True],
		gatherTests&&!coolantStateValidQ,Test["Specified Coolants are in liquid form:",True,False]
	];
	
	(* ----- Do any Coolants have melting points below the freezing temperature? ----- *)
	
	(* Find the melting point of Coolants *)
	coolantMeltingPoints=If[
		MatchQ[initialCoolants,{Automatic..}],
		{},
		Which[
			
			(* If Automatic or Null, skip *)
			MatchQ[#,Null|Automatic],Null,
			
			(* If model, get the melting point *)
			MatchQ[#,ObjectP[Model[Sample]]],Lookup[fetchPacketFromCache[#,cache],MeltingPoint,Null],
			
			(* Otherwise, it must be an object so download model first and check its state *)
			True,Module[{model},
				
				(* Find the model *)
				model=Download[Lookup[fetchPacketFromCache[#,cache],Model],Object];
				
				(* Fetch its melting point *)
				Lookup[fetchPacketFromCache[model,cache],MeltingPoint,Null]
			]
		]&/@initialCoolants
	];
	
	(* Convert freezing conditions to a temperature *)
	freezingTemperatures=Switch[#,
		Null,Null,
		Automatic,Lookup[Lookup[$StorageConditions,DeepFreezer],Temperature],
		Freezer,Lookup[Lookup[$StorageConditions,Freezer],Temperature],
		DeepFreezer,Lookup[Lookup[$StorageConditions,DeepFreezer],Temperature]
	]&/@initialFreezingConditions;
	
	(* Check if the melting temperatures are above the freezing condition temperatures *)
	coolantTemperatureValidQList=If[
		MatchQ[initialCoolants,{Automatic..}],
		{True},
		MapThread[
			Function[
				{meltingPoint,freezingConditionTemperature},
				If[
					
					(* If either is Null, we can't check, so return true *)
					NullQ[meltingPoint]||NullQ[freezingConditionTemperature],
					True,
					
					(* Otherwise, compare temperatures *)
					meltingPoint<freezingConditionTemperature
				]
			],
			{coolantMeltingPoints,freezingTemperatures}
		]
	];
	
	(* Create a bool for error checking *)
	coolantTemperatureValidQ=And@@coolantTemperatureValidQList;
	
	(* Check which coolants are not liquid *)
	lowMeltingCoolants=If[
		!coolantTemperatureValidQ,
		Pick[initialCoolants,coolantTemperatureValidQList,False]
	];
	
	(* If we have any invalid options and messages are on, throw an error *)
	If[
		!coolantTemperatureValidQ&&messages,
		Message[Warning::FreezeCellsLowMeltingCoolant,lowMeltingCoolants]
	];
	
	(* ----- Are FreezingContainers copacetic with CoolantVolumes? ----- *)
	
	
	(* We are only checking against the first container model because if the container models don't all fit into the same insulated cooler, we already threw an error with validBatchContainersQ *)
	(* batchedContainerModelList=First/@batchedContainerModels;*)
	insulatedCoolerFPBoolList=CompatibleFootprintQ[ConstantArray[Lookup[insulatedCoolerModelPackets,Object],Length[batchedContainerModelList]],(First/@batchedContainerModels),Tolerance->ConstantArray[containerTolerance,Length[batchedContainerModelList]],Cache->cache,FlattenOutput->False];
	
	(* Check if FreezingContainers and CoolantVolumes are copacetic for each step *)
	validCoolantVolumesList=Which[
		
		(* If both FreezingContainers and CoolantVolumes are specified *)
		MatchQ[initialFreezingContainers,Except[{Automatic..}]]&&MatchQ[roundedCoolantVolumes,Except[{Automatic..}]],MapThread[
			Function[
				{freezingContainer,coolantVolume},
				If[
					MatchQ[freezingContainer,Except[Automatic|Null]]&&MatchQ[coolantVolume,Except[Automatic|Null]],
					Module[{freezingContainerPacket,freezingContainerMaxVolume},
						
						(* Find the container we will put the insulated cooler in *)
						freezingContainerPacket=fetchPacketFromCache[Download[Lookup[fetchPacketFromCache[freezingContainer,cache],DefaultContainer],Object],cache];
						
						(* Find the max volume of the container *)
						freezingContainerMaxVolume=Lookup[fetchPacketFromCache[freezingContainerPacket,cache],MaxVolume];
						
						(* Check that the coolant volume fits in the container *)
						{freezingContainerMaxVolume,coolantVolume<=freezingContainerMaxVolume}
					],
					{Null,True}
				]
			],
			{initialFreezingContainers,roundedCoolantVolumes}
		],
		
		(* If CoolantVolumes and Batches are specified *)
		MatchQ[roundedCoolantVolumes,Except[{Automatic..}]]&&MatchQ[initialBatches,Except[{Automatic..}]],MapThread[
			Function[
				{containerHeightList,coolantVolume,insulatedCoolerFPBool},
				If[
					MatchQ[coolantVolume,Except[Automatic|Null]],
					Module[{insulatedCoolerHeights,insulatedCoolerCheck,compatibleInsulatedCoolers,freezingContainerPackets,freezingContainerMaxVolumes},
						
						(* Find the heights of the insulated coolers *)
						insulatedCoolerHeights=Max[Lookup[#,MaxHeight]]&/@Lookup[fetchPacketFromCache[#,cache]&/@insulatedCoolerModelPackets,Positions];
						
						(* Check if our containers fit into the insulated coolers -- we are only checking against the first container model because if the container models don't all fit into the same insulated cooler, we already threw an error with validBatchContainersQ *)
						insulatedCoolerCheck=Apply[And,#]&/@Transpose[{
							
							(* Does the container fit into the rack? *)
							ToList[insulatedCoolerFPBool],
							
							(* Is the container dramatically shorter than the container? -- CompatibleFootprintQ only checks that the rack height is above the container so basically any container will fit into 5mL Mr Frosty even though that is not what we want in general because the liquid height in Mr Frosty has to be above the liquid in the container for effective freezing *)
							(#-containerTolerance<=First[containerHeightList]<=#+containerTolerance)&/@insulatedCoolerHeights
						}];
						
						(* Find the insulated coolers that are compatible with the sample containers -- we are only checking against the first container model because if the container models are not all the same type, we already threw an error with validBatchContainersQ *)
						compatibleInsulatedCoolers=Pick[insulatedCoolerModelPackets,insulatedCoolerCheck,True];
						
						(* Find the containers we will put the insulated coolers in *)
						freezingContainerPackets=fetchPacketFromCache[#,cache]&/@Download[Lookup[compatibleInsulatedCoolers,DefaultContainer],Object];
						
						(* Find the max volumes of the containers *)
						freezingContainerMaxVolumes=Lookup[freezingContainerPackets,MaxVolume];
						
						(* Check that the coolant volume fits in the biggest container *)
						{Max[freezingContainerMaxVolumes],coolantVolume<=Max[freezingContainerMaxVolumes]}
					],
					{Null,True}
				]
			],
			{batchedContainerHeights,roundedCoolantVolumes,insulatedCoolerFPBoolList}
		],
		
		(* Otherwise, we are good *)
		True,{{Null,True}}
	];
	
	(* Create a bool for error checking *)
	validCoolantVolumesQ=And@@Last[Transpose[validCoolantVolumesList]];
	
	(* Find which volumes are too high *)
	invalidCoolantVolumesIndices=If[
		!validCoolantVolumesQ,
		Flatten[Position[validCoolantVolumesList,{_,False}]]
	];
	
	(* Find the max volumes for the failed indices *)
	invalidCoolantVolumesMax=If[
		!validCoolantVolumesQ,
		First/@Cases[validCoolantVolumesList,{_,False}]
	];
	
	(* If we have any invalid volumes and messages are on, throw an error *)
	If[
		!validCoolantVolumesQ&&messages,
		Message[Error::FreezeCellsCoolantVolumeInvalid,invalidCoolantVolumesIndices,invalidCoolantVolumesMax]
	];
	
	(* If gathering tests, create a passing or failing test *)
	validCoolantVolumesTest=Which[
		!gatherTests,Nothing,
		gatherTests&&validCoolantVolumesQ,Test["CoolantVolumes do not exceed the maximum volume of the specified or default FreezingContainers:",True,True],
		gatherTests&&!validCoolantVolumesQ,Test["CoolantVolumes do not exceed the maximum volume of the specified or default FreezingContainers:",True,False]
	];
	
	(* ----- Are FreezingConditions copacetic with Instruments? ----- *)
	
	(* Check if the instruments and freezing conditions are copacetic *)
	validFreezingConditionList=If[
		MatchQ[initialInstruments,Except[{Automatic..}]]&&MatchQ[initialFreezingConditions,Except[{Automatic..}]],
		MapThread[
			Function[
				{instrument,freezingCondition},
				Which[
					
					(* If freezing condition is Automatic or Null, carry on *)
					MatchQ[freezingCondition,Automatic|Null],True,
					
					(* If instrument is specified as a Model *)
					MatchQ[instrument,ObjectP[Model[Instrument,Freezer]]],Module[{instrumentTemperature,freezingConditionTemperature},
						
						(* Find the instrument temperature *)
						instrumentTemperature=Lookup[fetchPacketFromCache[instrument,cache],DefaultTemperature];
						
						(* Find the freezing condition temperature *)
						freezingConditionTemperature=Lookup[SelectFirst[storageConditionPackets,MatchQ[Lookup[#,StorageCondition],freezingCondition]&],Temperature];
						
						(* Check if the temperatures are within 5C of each other -- we are allowing this tolerance here because some -80C freezers are actually at -78C *)
						instrumentTemperature-5 Celsius<=freezingConditionTemperature<=instrumentTemperature+5 Celsius
					],
					
					(* If instrument is specified as a Object *)
					MatchQ[instrument,ObjectP[Object[Instrument,Freezer]]],Module[{instrumentStorageCondition},
						
						(* Find the instrument storage condition *)
						instrumentStorageCondition=Lookup[fetchPacketFromCache[instrument,cache],ProvidedStorageCondition];
						
						(* Check if they are the same *)
						MatchQ[instrumentStorageCondition,freezingCondition]
					],
					
					(* Otherwise, we are good *)
					True,True
				]
			],
			{initialInstruments,initialFreezingConditions}
		],
		
		(* Otherwise, we are good *)
		{True}
	];
	
	(* Create a bool for error checking *)
	validFreezingConditionQ=And@@validFreezingConditionList;
	
	(* Find which indices are mismatched *)
	validFreezingConditionIndices=If[
		!validFreezingConditionQ,
		Flatten[Position[validFreezingConditionList,False]]
	];
	
	(* If we have any mismatches and messages are on, throw an error *)
	If[
		!validFreezingConditionQ&&messages,
		Message[Error::FreezeCellsIncompatibleFreezer,validFreezingConditionIndices]
	];
	
	(* If gathering tests, create a passing or failing test *)
	validFreezingConditionTest=Which[
		!gatherTests,Nothing,
		gatherTests&&validFreezingConditionQ,Test["FreezingConditions and Instruments have the same temperature or storage condition:",True,True],
		gatherTests&&!validFreezingConditionQ,Test["FreezingConditions and Instruments have the same temperature or storage condition:",True,False]
	];
	
	(* ----- Are TransportConditions copacetic? ----- *)
	
	(* Find if any TransportConditions are not -40C or -80C *)
	transportConditionsValidList=If[
		MatchQ[initialTransportConditions,{Automatic..}],
		{True},
		Function[
			transportCondition,
			If[
				MatchQ[transportCondition,Automatic],
				True,
				MatchQ[transportCondition,Minus40|Minus80]
			]
		]/@initialTransportConditions
	];
	
	(* Create a bool for error checking *)
	transportConditionsValidQ=And@@transportConditionsValidList;
	
	(* Find which batches have warming steps *)
	invalidTransportConditionsIndices=If[
		!transportConditionsValidQ,
		Flatten[Position[transportConditionsValidList,False]]
	];
	
	(* If we have any warming steps, display a warning *)
	If[
		!transportConditionsValidQ&&messages&&!MatchQ[$ECLApplication,Engine],
		Message[Warning::FreezeCellsInvalidTransportConditions,invalidTransportConditionsIndices]
	];
	
	(* ----- Are TransportConditions copacetic with other options? ----- *)
	
	(* Find if any FreezingConditions are warmer than our final temperature *)
	transportConditionsCoolingList=If[
		MatchQ[initialTransportConditions,Except[{Automatic..}]],
		MapThread[
			Function[
				{transportCondition,freezingProfile,residualTemperature,freezingRate,duration,freezingCondition,instrument,method},
				If[
					MatchQ[transportCondition,Except[Automatic]],
					Module[{transportConditionTemperature,finalCellTemperature},
						
						(* Find the temperature of the transport condition *)
						transportConditionTemperature=Lookup[SelectFirst[transportConditionPackets,MatchQ[Lookup[#,TransportCondition],transportCondition]&],TransportTemperature];
						
						(* Find the last temperature the cells will be at before transport *)
						finalCellTemperature=Which[
							
							(* If we are doing a variable rate ControlledRateFreezer experiment *)
							MatchQ[freezingProfile,Except[Automatic|Null]],First[Last[freezingProfile]],
							
							(* If we are doing a constant rate ControlledRateFreezer experiment with ResidualTemperatures specified *)
							MatchQ[residualTemperature,Except[Automatic|Null]],residualTemperature,
							
							(* If we are doing a constant rate ControlledRateFreezer experiment with both FreezingConditions and Durations specified *)
							MatchQ[freezingRate,Except[Automatic|Null]]&&MatchQ[duration,Except[Automatic|Null]],20 Celsius-(freezingRate*duration),
							
							(* If we are doing an InsulatedCooler experiment with FreezingConditions specified *)
							MatchQ[freezingCondition,Except[Automatic|Null]],Lookup[SelectFirst[storageConditionPackets,MatchQ[Lookup[#,StorageCondition],freezingCondition]&],Temperature],
							
							(* If a freezer instrument was specified *)
							MatchQ[instrument,ObjectP[Model[Instrument,Freezer]]],Lookup[fetchPacketFromCache[instrument,cache],DefaultTemperature],
							
							(* If a freezer instrument was specified *)
							MatchQ[instrument,ObjectP[Object[Instrument,Freezer]]],Lookup[fetchPacketFromCache[Download[Lookup[fetchPacketFromCache[instrument,cache],Model],Object],cache],DefaultTemperature],
							
							(* If none of the above was specified but the method is insulated cooler, then we are going to put the cells into a -80C freezer, so return -80C *)
							MatchQ[method,InsulatedCooler],-80 Celsius,
							
							(* Otherwise, we are good *)
							True,True
						];
						
						(* Compare the transport condition temperature to the cell temperature *)
						transportConditionTemperature<=finalCellTemperature
					],
					True
				]
			],
			{initialTransportConditions,roundedFreezingProfiles,roundedResidualTemperatures,roundedFreezingRates,roundedDurations,initialFreezingConditions,initialInstruments,initialFreezingMethods}
		],
		{True}
	];
	
	(* Create a bool for error checking *)
	transportConditionsCoolingQ=And@@transportConditionsCoolingList;
	
	(* Find which batches have warming steps *)
	coolingTransportConditionsIndices=If[
		!transportConditionsCoolingQ,
		Flatten[Position[transportConditionsCoolingList,False]]
	];
	
	(* If we have any warming steps, display a warning *)
	If[
		!transportConditionsCoolingQ&&messages&&!MatchQ[$ECLApplication,Engine],
		Message[Warning::FreezeCellsWarmingDuringTransport,coolingTransportConditionsIndices]
	];
	
	(* ---------- RESOLVE EXPERIMENT OPTIONS ---------- *)
	
	(* ----- Resolve Batches ----- *)
	
	(* If we are erroring out above in a way that would prevent us from resolving the options, skip the rest of this. At best we are going to get unnecessary errors, so we are not even going to attempt to get through all this code, since these errors will return $Failed for the entire function anyways *)
	If[
		!nonDuplicatedSamplesWithinBatchesQ||!specifiedBatchSamplesQ||!groupedInvalidOptionsQ||!batchRackValidQ||!validMethodContainersQ||!freezingContainerSampleCompatibleQ,
		Module[{},
			
			(* Assign the two variables for error checking we are going to assess in the actual resolver -- we are assigning true because something more fundamental has failed and we cannot actually test for these errors. As such, we can't throw them so we are just going to skip them *)
			{insulatedCoolerRestrictedBatchesValidQ,rackReplacementsValidQ}={True,True};
			
			(* Create a passing test for the errors *)
			batchesResolvableTest=If[
				!gatherTests,
				Nothing,
				Test["Specified samples can be separated into the specified number of freezing methods based on container specificity:",True,True]
			];
			
			(* Return Null for everything *)
			{resolvedBatches,resolvedFreezingMethods,resolvedInstruments,resolvedFreezingProfiles,resolvedFreezingRates,resolvedDurations,resolvedResidualTemperatures,resolvedFreezingContainers,resolvedFreezingConditions,resolvedCoolants,resolvedCoolantVolumes,resolvedTransportConditions}=ConstantArray[Null,12]
		],
		
		(* If no errors, resolve the options *)
		Module[{},
			
			(* Make a list of minimum racks we need for this experiments *)
			minRacksNeeded=If[
				MatchQ[initialBatches,{Automatic..}],
				Module[{containerCompatibilityCheck,allowedRacksForContainerModels,numberOfNeededRacks,allowedContainerFPList},
					
					(* Generate a list of booleans from the compatibleFootprintQ *)
					allowedContainerFPList=CompatibleFootprintQ[ConstantArray[ToList[allowedRacks],Length[containerModels]],containerModels,Tolerance->ConstantArray[containerTolerance,Length[containerModels]],Cache->cache,FlattenOutput->False];
					
					(* Run a container check for each sample's container type with our allowed racks -- this is a nested list where inner lists are the Booleans for containers, and the outer lists are the racks we have *)
					containerCompatibilityCheck=MapThread[
						Function[
							{containerHeight,allowedContainerFP},
							Apply[And,#]&/@Transpose[{
								
								(* Does the container fit into the rack? *)
								allowedContainerFP,
								
								(* Is the container dramatically shorter than the container? -- CompatibleFootprintQ only checks that the rack height is above the container so basically any container will fit into 5mL Mr Frosty even though that is not what we want in general because the liquid height in Mr Frosty has to be above the liquid in the container for effective freezing *)
								(#-containerTolerance<=containerHeight<=#+containerTolerance)&/@allowedRackHeights
							}]
						],
						{containerHeights,allowedContainerFPList}
					];
					
					(* Make a list of allowed racks for each container model *)
					allowedRacksForContainerModels=Pick[allowedRacks,#,True]&/@containerCompatibilityCheck;
					
					(* Convert the allowed racks from container model to each sample *)
					sampleCompatibleRacks=Flatten[PickList[allowedRacksForContainerModels,containerModels,#]&/@sampleContainerModels,1];
					
					(* Count how many samples we have for each rack type *)
					rackSampleCount=Count[Flatten[sampleCompatibleRacks],#]&/@allowedRacks;
					
					(* Get the max number of samples we can put into each of our allowed racks *)
					allowedRacksMaxBatchSize=Lookup[fetchPacketFromCache[#,cache]&/@allowedRacks,NumberOfPositions];
					
					(* Calculate the minimum number of each rack we would need *)
					numberOfNeededRacks=MapThread[Ceiling[#1/#2]&,{rackSampleCount,allowedRacksMaxBatchSize}];
					
					(* Create a list of racks we need at a minimum and return the result *)
					Transpose[{
						DeleteDuplicates[allowedRacksForContainerModels],
						Flatten/@Function[compatibleRacks,Pick[numberOfNeededRacks,allowedRacks,#]&/@compatibleRacks]/@DeleteDuplicates[allowedRacksForContainerModels]
					}]
				]
			];
			
			(* Grab the 5 mL Mr. Frosty rack group -- we are just flattening here because we currently only have one Mr. Frosty that is restricted to 5 mL containers, and other containers are universal in terms of method, so this should only ever return one group *)
			insulatedCoolerOnlyGroup=If[
				MatchQ[initialBatches,{Automatic..}],
				Flatten[Cases[minRacksNeeded,{{ObjectP[Model[Container,Rack,InsulatedCooler]]},_}]]
			];
			
			(* Grab the insulated cooler rack group for 1.2 mL and 2 mL containers -- again there is only case of this since we only have 3 racks with two of them being compatible with 1.2 mL and 2 mL containers, and one being only compatible with 5 mL containers. We already eliminated the 5 mL container above so once that is removed, there should only be one group left containing a controlled rate freezer rack and an insulated cooler rack *)
			universalRackGroup=Which[
				
				(* If batches are specified, carry on *)
				MatchQ[initialBatches,Except[{Automatic..}]],{},
				
				(* If we only have insulated coolers, return empty list *)
				Length[minRacksNeeded]==1&&MatchQ[insulatedCoolerOnlyGroup,Except[{}]],{},
				
				(* Otherwise, there must be a universal rack group so grab it *)
				True,First[DeleteCases[minRacksNeeded,{{ObjectP[Model[Container,Rack,InsulatedCooler]]},_}]]
			];
			
			(* Prepare a list of samples based on which racks we can put them in *)
			{universalSamples,restrictedSamples}=Which[
				
				(* If batches are specified, carry on *)
				MatchQ[initialBatches,Except[{Automatic..}]],{{},{}},
				
				(* If we only have a universal rack group *)
				MatchQ[universalRackGroup,Except[{}]]&&MatchQ[insulatedCoolerOnlyGroup,{}],{PickList[mySamples,sampleCompatibleRacks,First[universalRackGroup]],{}},
				
				(* If we only have an insulated cooler only group *)
				MatchQ[insulatedCoolerOnlyGroup,Except[{}]]&&MatchQ[universalRackGroup,{}],{{},PickList[mySamples,sampleCompatibleRacks,{First[insulatedCoolerOnlyGroup]}]},
				
				(* Otherwise, we must have both *)
				True,PickList[mySamples,sampleCompatibleRacks,#]&/@{First[universalRackGroup],{First[insulatedCoolerOnlyGroup]}}
			];
			
			(* Resolve the batches *)
			resolvedBatches=Which[
				
				(* If specified, use it *)
				MatchQ[initialBatches,Except[{Automatic..}]],Module[{},
					
					(* Assign True to the error checking variables since nothing was specified *)
					{insulatedCoolerRestrictedBatchesValidQ,rackReplacementsValidQ}={True,True};
					
					(* Return the initial batches *)
					initialBatches
				],
				
				(* If a method-defining option was specified *)
				MatchQ[preResolvedMethods,Except[Automatic]],Module[{insulatedCoolerOnlyRackReplacement,restrictedBatchReplacement},
					
					(* Find out the how many batches of each method we need to prepare *)
					numberOfBatches=Count[preResolvedMethods,#]&/@{ControlledRateFreezer,InsulatedCooler,Automatic};
					
					(* First, check if we have 5mL Mr. Frosty only groups and assign their rack to the appropriate methods *)
					insulatedCoolerOnlyRackReplacement=Which[
						
						(* If there are no insulated cooler restricted racks, leave the methods alone *)
						MatchQ[insulatedCoolerOnlyGroup,{}],preResolvedMethods,
						
						(* If we have enough insulated cooler methods, replace them with our rack *)
						numberOfBatches[[2]]>=Last[insulatedCoolerOnlyGroup],Module[{replacementPositions,replacementRules},
							
							(* Find the positions of insulated cooler methods we need to replace *)
							replacementPositions=If[
								
								(* If there are no universal samples, spread out to all batches *)
								MatchQ[universalRackGroup,{}],
								Flatten[Position[preResolvedMethods,#]&/@{InsulatedCooler,Automatic}],
								
								(* Otherwise, take as many as needed *)
								Take[Flatten[Position[preResolvedMethods,InsulatedCooler]],Last[insulatedCoolerOnlyGroup]]
							];
							
							(* Create a list of replacement rules *)
							replacementRules=Rule[#,First[insulatedCoolerOnlyGroup]]&/@replacementPositions;
							
							(* Replace the positions with the rack and return the result *)
							ReplacePart[preResolvedMethods,replacementRules]
						],
						
						(* If we don't have enough insulated cooler methods, but have Automatics we can use, replace a mixture of InsulatedCooler and Automatic methods with our rack *)
						numberOfBatches[[2]]+Last[numberOfBatches]>=Last[insulatedCoolerOnlyGroup],Module[{replacementPositions,replacementRules},
							
							(* Find the positions of insulated cooler methods we need to replace *)
							replacementPositions=If[
								
								(* If there are no universal samples, spread out to all batches *)
								MatchQ[universalRackGroup,{}],
								Flatten[Position[preResolvedMethods,#]&/@{InsulatedCooler,Automatic}],
								
								(* Otherwise, take as many as needed *)
								Take[Flatten[Position[preResolvedMethods,#]&/@{InsulatedCooler,Automatic}],Last[insulatedCoolerOnlyGroup]]
							];
							
							(* Create a list of replacement rules *)
							replacementRules=Rule[#,First[insulatedCoolerOnlyGroup]]&/@replacementPositions;
							
							(* Replace the positions with the rack and return the result *)
							ReplacePart[preResolvedMethods,replacementRules]
						],
						
						(* Otherwise, we don't have enough InsulatedCooler or Automatic methods, and therefore, we can't resolve batches *)
						True,"Not enough batches for insulated cooler restricted samples"
					];
					
					(* Create a bool for error checking for insulated cooler restricted samples *)
					insulatedCoolerRestrictedBatchesValidQ=!MatchQ[insulatedCoolerOnlyRackReplacement,"Not enough batches for insulated cooler restricted samples"];
					
					(* Replace any remaining methods with their corresponding racks and return the result *)
					finalAssignedRacks=Which[
						
						(* If we didn't have enough room for insulated cooler only samples, carry on *)
						!insulatedCoolerRestrictedBatchesValidQ,insulatedCoolerOnlyRackReplacement,
						
						(* If we don't have any universal samples, we already replaced all racks, so return insulated cooler only racks *)
						MatchQ[universalRackGroup,{}],insulatedCoolerOnlyRackReplacement,
						
						(* Otherwise, we didn't error out and we have universal samples so replace the remaining racks *)
						True,Module[{insulatedCoolerRack,insulatedCoolerReplacementPositions,insulatedCoolerReplacementRules,insulatedCoolerReplacement,freezerRack,freezerReplacementPositions,freezerReplacementRules},
							
							(* Find the model for the insulated cooler rack *)
							insulatedCoolerRack=FirstCase[First[universalRackGroup],ObjectP[Model[Container,Rack,InsulatedCooler]]];
							
							(* Find the positions of insulated cooler methods we need to replace *)
							insulatedCoolerReplacementPositions=Flatten[Position[insulatedCoolerOnlyRackReplacement,InsulatedCooler,1]];
							
							(* Create a list of replacement rules *)
							insulatedCoolerReplacementRules=Rule[#,insulatedCoolerRack]&/@insulatedCoolerReplacementPositions;
							
							(* Replace the positions with the rack *)
							insulatedCoolerReplacement=ReplacePart[insulatedCoolerOnlyRackReplacement,insulatedCoolerReplacementRules];
							
							(* Find the model for the controlled rate freezer rack *)
							freezerRack=First[DeleteCases[First[universalRackGroup],insulatedCoolerRack]];
							
							(* Find the positions of controlled rate freezer methods we need to replace *)
							freezerReplacementPositions=Flatten[Position[insulatedCoolerReplacement,#]&/@{ControlledRateFreezer,Automatic}];
							
							(* Create a list of replacement rules *)
							freezerReplacementRules=Rule[#,freezerRack]&/@freezerReplacementPositions;
							
							(* Replace the positions with the rack and return the result *)
							ReplacePart[insulatedCoolerReplacement,freezerReplacementRules]
						]
					];
					
					(* Figure out if we have enough room for all the samples *)
					rackReplacementsValidQ=Which[
						
						(* If we failed insulated cooler restricted batch requirement, return false *)
						!insulatedCoolerRestrictedBatchesValidQ,False,
						
						(* If we don't have any non-restricted samples, then we are good since we already passed that check *)
						MatchQ[universalRackGroup,{}],True,
						
						(* Otherwise, check that the other batches are also good *)
						True,Module[{assignedRacksWithoutRestrictedRacks,replacedRackSizes,numberOfUniversalSamples},
							
							(* Since we already passed the restricted batch requirement, remove those racks from the list of racks we prepared *)
							assignedRacksWithoutRestrictedRacks=If[
								MatchQ[insulatedCoolerOnlyGroup,{}],
								finalAssignedRacks,
								DeleteCases[finalAssignedRacks,First[insulatedCoolerOnlyGroup]]
							];
							
							(* Find out how many samples we can put into each rack *)
							replacedRackSizes=Flatten[Pick[allowedRacksMaxBatchSize,allowedRacks,#]&/@assignedRacksWithoutRestrictedRacks];
							
							(* Find out how many samples we have to put in the racks *)
							numberOfUniversalSamples=First[Pick[rackSampleCount,allowedRacks,First[assignedRacksWithoutRestrictedRacks]]];
							
							(* Check if we have enough samples *)
							Total[replacedRackSizes]>=numberOfUniversalSamples
						]
					];
					
					(* Create the batches for restricted groups and replace them *)
					restrictedBatchReplacement=Which[
						
						(* If we errored out, carry on *)
						!rackReplacementsValidQ,finalAssignedRacks,
						
						(* If we don't have any racks to replace, carry on *)
						MatchQ[insulatedCoolerOnlyGroup,{}],finalAssignedRacks,
						
						(* Otherwise, replace the racks with the samples *)
						True,Module[{numberOfRestrictedBatches,leftoverNumberOfSamples,batchSizes,splitSamples,replacementPositions,replacementRules},
							
							(* Find the number of batches we need *)
							numberOfRestrictedBatches=Count[finalAssignedRacks,First[insulatedCoolerOnlyGroup]];
							
							(* Find the number of samples leftover *)
							leftoverNumberOfSamples=Mod[Length[restrictedSamples],numberOfRestrictedBatches];
							
							(* Calculate the batch sizes -- our "normal" batch size is the floor of number of samples we have divided by the number of batches. We then add one sample to some of the batches at the beginning until we have no more leftover samples, then we use the normal batch size *)
							batchSizes=Flatten[{ConstantArray[Floor[Length[restrictedSamples]/numberOfRestrictedBatches]+1,leftoverNumberOfSamples],ConstantArray[Floor[Length[restrictedSamples]/numberOfRestrictedBatches],numberOfRestrictedBatches-leftoverNumberOfSamples]}];
							
							(* Split the samples according to batch sizes *)
							splitSamples=TakeList[restrictedSamples,batchSizes];
							
							(* Find the positions of racks we need to replace with samples *)
							replacementPositions=Flatten[Position[finalAssignedRacks,First[insulatedCoolerOnlyGroup]]];
							
							(* Create a list of replacement rules *)
							replacementRules=MapThread[Rule[#1,#2]&,{replacementPositions,splitSamples}];
							
							(* Replace the positions with the batches and return the result *)
							ReplacePart[finalAssignedRacks,replacementRules]
						]
					];
					
					(* Split the remaining samples into the remaining batches and return the result *)
					Which[
						
						(* If we errored out, fail *)
						!rackReplacementsValidQ,Null,
						
						(* If we don't have any racks to replace, carry on *)
						!MemberQ[restrictedBatchReplacement,ObjectP[Model[Container,Rack]]],restrictedBatchReplacement,
						
						(* Otherwise, replace the racks with the samples *)
						True,Module[{remainingRacks,maxBatchSizes,leftoverNumberOfSamples,batchSizes,batchSizesValidList,adjustedBatchSizes,splitSamples,replacementPositions,replacementRules},
							
							(* Find the racks we need to replace *)
							remainingRacks=Cases[restrictedBatchReplacement,ObjectP[Model[Container,Rack]]];
							
							(* Find the max batch sizes *)
							maxBatchSizes=Flatten[Pick[allowedRacksMaxBatchSize,allowedRacks,#]&/@remainingRacks];
							
							(* Find the number of samples leftover if we split the samples amongst the remaining batches *)
							leftoverNumberOfSamples=Mod[Length[universalSamples],Length[maxBatchSizes]];
							
							(* Calculate the batch sizes -- our "normal" batch size is the floor of number of samples we have divided by the number of batches. We then add one sample to some of the batches at the beginning until we have no more leftover samples, then we use the normal batch size *)
							batchSizes=Flatten[{ConstantArray[Floor[Length[universalSamples]/Length[maxBatchSizes]]+1,leftoverNumberOfSamples],ConstantArray[Floor[Length[universalSamples]/Length[maxBatchSizes]],Length[maxBatchSizes]-leftoverNumberOfSamples]}];
							
							(* Check if we exceed any max batch sizes with our calculation *)
							batchSizesValidList=MapThread[#1<=#2&,{batchSizes,maxBatchSizes}];
							
							(* Adjust the batch sizes if needed *)
							adjustedBatchSizes=If[
								!MemberQ[batchSizesValidList,False],
								batchSizes,
								Module[{extraSampleCount,numberOfAvailableBatches,leftoverNumberOfSamples,newBatchSizes},
									
									(* Cap the invalid batches at the their max and find out how many extra samples we would have *)
									extraSampleCount=Length[universalSamples]-Total[PickList[maxBatchSizes,batchSizesValidList,False]];
									
									(* Find out how many available batches we have *)
									numberOfAvailableBatches=Count[batchSizesValidList,True];
									
									(* Find the number of samples leftover if we split the samples amongst the remaining batches *)
									leftoverNumberOfSamples=Mod[extraSampleCount,numberOfAvailableBatches];
									
									(* Calculate the new batch sizes for the valid batches -- our "normal" batch size is the floor of number of samples we have divided by the number of batches. We then add one sample to some of the batches at the beginning until we have no more leftover samples, then we use the normal batch size *)
									newBatchSizes=Flatten[{ConstantArray[Floor[extraSampleCount/numberOfAvailableBatches]+1,leftoverNumberOfSamples],ConstantArray[Floor[extraSampleCount/numberOfAvailableBatches],numberOfAvailableBatches-leftoverNumberOfSamples]}];
									
									(* Expand the batch additions by adding the capped values for the invalid batches and return *)
									ReplacePart[
										batchSizesValidList,
										Flatten[{
											MapThread[Rule[#1,#2]&,{Flatten[Position[batchSizesValidList,True]],newBatchSizes}],
											MapThread[Rule[#1,#2]&,{Flatten[Position[batchSizesValidList,False]],PickList[maxBatchSizes,batchSizesValidList,False]}]
										}]
									]
								]
							];
							
							(* Split the samples according to batch sizes *)
							splitSamples=TakeList[universalSamples,adjustedBatchSizes];
							
							(* Find the positions of racks we need to replace with samples *)
							replacementPositions=Flatten[Position[restrictedBatchReplacement,ObjectP[Model[Container,Rack]]]];
							
							(* Create a list of replacement rules *)
							replacementRules=MapThread[Rule[#1,#2]&,{replacementPositions,splitSamples}];
							
							(* Return the result *)
							ReplacePart[restrictedBatchReplacement,replacementRules]
						]
					]
				],
				
				(* Otherwise, no method defining option was specified and we are free to create batches as we see fit *)
				True,Module[{freezerGroup,restrictedBatchReplacement},
					
					(* Assign True to the error checking variables since nothing was specified *)
					{insulatedCoolerRestrictedBatchesValidQ,rackReplacementsValidQ}={True,True};
					
					(* Find the freezer group and its required number of batches *)
					freezerGroup=If[
						MatchQ[universalRackGroup,{}],
						{},
						FirstCase[Transpose[universalRackGroup],Except[{ObjectP[Model[Container,Rack,InsulatedCooler]],_}]]
					];
					
					(* Create a list of racks based on how many of each rack we need *)
					requiredRacks=Which[
						
						(* If we only have a freezer group *)
						MatchQ[freezerGroup,Except[{}]]&&MatchQ[insulatedCoolerOnlyGroup,{}],ConstantArray[First[freezerGroup],Last[freezerGroup]],
						
						(* If we only have an insulated cooler only group *)
						MatchQ[insulatedCoolerOnlyGroup,Except[{}]]&&MatchQ[freezerGroup,{}],ConstantArray[First[insulatedCoolerOnlyGroup],Last[insulatedCoolerOnlyGroup]],
						
						(* Otherwise, we must have both *)
						True,Flatten[{ConstantArray[First[freezerGroup],Last[freezerGroup]],ConstantArray[First[insulatedCoolerOnlyGroup],Last[insulatedCoolerOnlyGroup]]}]
					];
					
					(* Create the batches for restricted groups and replace them *)
					restrictedBatchReplacement=If[
						MatchQ[insulatedCoolerOnlyGroup,{}],
						requiredRacks,
						Module[{numberOfRestrictedBatches,leftoverNumberOfSamples,batchSizes,splitSamples,replacementPositions,replacementRules},
							
							(* Find the number of batches we need *)
							numberOfRestrictedBatches=Last[insulatedCoolerOnlyGroup];
							
							(* Find the number of samples leftover *)
							leftoverNumberOfSamples=Mod[Length[restrictedSamples],numberOfRestrictedBatches];
							
							(* Calculate the batch sizes -- our "normal" batch size is the floor of number of samples we have divided by the number of batches. We then add one sample to some of the batches at the beginning until we have no more leftover samples, then we use the normal batch size *)
							batchSizes=Flatten[{ConstantArray[Floor[Length[restrictedSamples]/numberOfRestrictedBatches]+1,leftoverNumberOfSamples],ConstantArray[Floor[Length[restrictedSamples]/numberOfRestrictedBatches],numberOfRestrictedBatches-leftoverNumberOfSamples]}];
							
							(* Split the samples according to batch sizes *)
							splitSamples=TakeList[restrictedSamples,batchSizes];
							
							(* Find the positions of racks we need to replace with samples *)
							replacementPositions=Flatten[Position[requiredRacks,First[insulatedCoolerOnlyGroup]]];
							
							(* Create a list of replacement rules *)
							replacementRules=MapThread[Rule[#1,#2]&,{replacementPositions,splitSamples}];
							
							(* Replace the positions with the batches and return the result *)
							ReplacePart[requiredRacks,replacementRules]
						]
					];
					
					(* Replace remaining racks, if any *)
					If[
						MatchQ[freezerGroup,{}],
						restrictedBatchReplacement,
						Module[{leftoverNumberOfSamples,batchSizes,splitSamples,replacementPositions,replacementRules},
							
							(* Find the number of samples leftover if we split the samples amongst the remaining batches *)
							leftoverNumberOfSamples=Mod[Length[universalSamples],Last[freezerGroup]];
							
							(* Calculate the batch sizes -- our "normal" batch size is the floor of number of samples we have divided by the number of batches. We then add one sample to some of the batches at the beginning until we have no more leftover samples, then we use the normal batch size *)
							batchSizes=Flatten[{ConstantArray[Floor[Length[universalSamples]/Last[freezerGroup]]+1,leftoverNumberOfSamples],ConstantArray[Floor[Length[universalSamples]/Last[freezerGroup]],Last[freezerGroup]-leftoverNumberOfSamples]}];
							
							(* Split the samples according to batch sizes *)
							splitSamples=TakeList[universalSamples,batchSizes];
							
							(* Find the positions of racks we need to replace with samples *)
							replacementPositions=Flatten[Position[restrictedBatchReplacement,First[freezerGroup]]];
							
							(* Create a list of replacement rules *)
							replacementRules=MapThread[Rule[#1,#2]&,{replacementPositions,splitSamples}];
							
							(* Return the result *)
							ReplacePart[restrictedBatchReplacement,replacementRules]
						]
					]
				]
			];
			
			(* ----- Error Check Batches ----- *)
			
			(* If we have any mismatches and messages are on, throw an error *)
			Which[
				
				(* If we don't have enough room for 5 mL Mr. Frosty Containers *)
				!insulatedCoolerRestrictedBatchesValidQ&&messages,Message[Error::FreezeCellsCannotResolveBatches,restrictedSamples,"these samples require more 5 mL Mr. Frosty containers than allocated"],
				
				(* If we don't have enough room left after allocating the 5 mL Mr. Frosty Containers *)
				!rackReplacementsValidQ&&messages,Message[Error::FreezeCellsCannotResolveBatches,universalSamples,"these samples require more space after accounting for 5 mL containers"]
			];
			
			(* If gathering tests, create a passing or failing test *)
			batchesResolvableTest=Which[
				!gatherTests,Nothing,
				MatchQ[initialBatches,Except[{Automatic..}]],Nothing,
				gatherTests&&insulatedCoolerRestrictedBatchesValidQ,Test["Specified samples can be successfully batched based on sample container size:",True,True],
				gatherTests&&!insulatedCoolerRestrictedBatchesValidQ,Test["Specified samples can be successfully batched based on sample container size:",True,False]
			];
			
			(* ----- MapThread Batch Options ----- *)
			(* If we cannot resolve batches due to errors, skip the rest of this. None of this gonna resolve without batches since everything is index matched to it we will skip it as we are already returning $Failed for the function call at this point *)
			{
				(*1*)resolvedFreezingMethods,
				(*2*)resolvedInstruments,
				(*3*)resolvedFreezingProfiles,
				(*4*)resolvedFreezingRates,
				(*5*)resolvedDurations,
				(*6*)resolvedResidualTemperatures,
				(*7*)resolvedFreezingContainers,
				(*8*)resolvedFreezingConditions,
				(*9*)resolvedCoolants,
				(*10*)resolvedCoolantVolumes,
				(*11*)resolvedTransportConditions
			}=If[
				!rackReplacementsValidQ,
				ConstantArray[Null,11],
				Module[{},
					
					(* Expand the options that are index matched to Batches *)
					{
						(*1*)expandedFreezingMethods,
						(*2*)expandedInstruments,
						(*3*)expandedFreezingProfiles,
						(*4*)expandedFreezingRates,
						(*5*)expandedDurations,
						(*6*)expandedResidualTemperatures,
						(*7*)expandedFreezingContainers,
						(*8*)expandedFreezingConditions,
						(*9*)expandedCoolants,
						(*10*)expandedCoolantVolumes,
						(*11*)expandedTransportConditions
					}=If[
						
						(* If something was specified, return everything as is since they were all expanded already *)
						MatchQ[preResolvedMethods,Except[Automatic]],
						{initialFreezingMethods,initialInstruments,roundedFreezingProfiles,roundedFreezingRates,roundedDurations,roundedResidualTemperatures,initialFreezingContainers,initialFreezingConditions,initialCoolants,roundedCoolantVolumes,initialTransportConditions},
						
						(* Otherwise, expand the options *)
						ConstantArray[First[#],Length[resolvedBatches]]&/@{initialFreezingMethods,initialInstruments,roundedFreezingProfiles,roundedFreezingRates,roundedDurations,roundedResidualTemperatures,initialFreezingContainers,initialFreezingConditions,initialCoolants,roundedCoolantVolumes,initialTransportConditions}
					];
					
					(* Make a list of the racks we are using *)
					resolvedRacks=Which[
						
						(* If something was specified and we resolved the racks based on that, return those racks *)
						MatchQ[initialBatches,{Automatic..}]&&MatchQ[preResolvedMethods,Except[Automatic]],finalAssignedRacks,
						
						(* If nothing was specified, and we figured it out based on that *)
						MatchQ[initialBatches,{Automatic..}]&&MatchQ[preResolvedMethods,Automatic],requiredRacks,
						
						(* Otherwise, Batches were specified, we need to figure it out here *)
						True,Module[{expandedPreResolvedMethods,racks,firstBatchContainerList,batchedRackFPBoolList,batchedAllowedRackFPBoolList},
							
							(* Expand pre-resolved methods if needed *)
							expandedPreResolvedMethods=If[
								MatchQ[preResolvedMethods,Except[Automatic]],
								preResolvedMethods,
								ConstantArray[preResolvedMethods,Length[initialBatches]]
							];
							
							(* Get the models of the insulated cooler racks *)
							racks=Lookup[insulatedCoolerModelPackets,Object];
							
							(* since every container in the loop used First[containerModelList], we take a list of them*)
							firstBatchContainerList=First/@batchedContainerModels;
							
							(* Does the container fit into the rack? *)
							batchedRackFPBoolList=CompatibleFootprintQ[ConstantArray[ToList[racks],Length[firstBatchContainerList]],firstBatchContainerList,Tolerance->ConstantArray[containerTolerance,Length[firstBatchContainerList]],Cache->cache,FlattenOutput->False];
							
							(*Extract the CFQ we gonna use in the mapthread and change the input as the list*)
							batchedAllowedRackFPBoolList=CompatibleFootprintQ[ConstantArray[ToList[allowedRacks],Length[firstBatchContainerList]],firstBatchContainerList,Tolerance->ConstantArray[containerTolerance,Length[firstBatchContainerList]],Cache->cache,FlattenOutput->False];
							
							(* Find the racks and return *)
							MapThread[
								Function[
									{preResolvedMethod,containerHeights,freezingContainer,controlledRFRackFPBool,batchedRackFPBool,batchedAllowedRackFPBool},
									Which[
										
										(* If all batch-defining options are automatic, find a ControlledRateFreezer rack that fits the sample containers *)
										MatchQ[preResolvedMethod,ControlledRateFreezer],Module[{rackHeights,containerCompatibilityCheck,allowedRacksForContainerModels},
										
											(* Get the heights for the controlled rate freezer racks *)
											rackHeights=Take[allowedRackHeights,Length[controlledRateFreezerRacks]];
											
											(* Run a compatibility check for the first container type with our allowed racks -- we are only checking the first guy since if all container models are not compatible we threw an error already *)
											containerCompatibilityCheck=Apply[And,#]&/@Transpose[{
												
												(* Does the container fit into the rack? *)
												ToList[controlledRFRackFPBool],
												
												(* Is the container dramatically shorter than the container? -- CompatibleFootprintQ only checks that the rack height is above the container so basically any container will fit into 5mL Mr Frosty even though that is not what we want in general because the liquid height in Mr Frosty has to be above the liquid in the container for effective freezing *)
												(#-containerTolerance<=First[containerHeights]<=#+containerTolerance)&/@rackHeights
											}];
											
											(* Make a list of allowed racks for each container model *)
											allowedRacksForContainerModels=Pick[controlledRateFreezerRacks,containerCompatibilityCheck,True];
											
											(* Return the first allowed rack, which is the only one we currently have *)
											First[allowedRacksForContainerModels]
										],
										
										(* If we are doing an insulated cooler method with a specified freezing container, return the specified container as the rack *)
										MatchQ[preResolvedMethod,InsulatedCooler]&&MatchQ[freezingContainer,Except[Automatic]],freezingContainer,
										
										(* If we are doing an insulated cooler method without a specified freezing container, find a rack based on compatibility *)
										MatchQ[preResolvedMethod,InsulatedCooler]&&MatchQ[freezingContainer,Automatic],Module[{rackHeights,containerCompatibilityCheck,allowedRacksForContainerModels},
											
											(* Get the heights for the insulated cooler racks -- we are taking from the end since that's the way allowed racks are arranged *)
											rackHeights=Take[allowedRackHeights,-Length[racks]];
											
											(* Run a compatibility check for the first container type with our allowed racks -- we are only checking the first guy since if all container models are not compatible we threw an error already *)
											containerCompatibilityCheck=Apply[And,#]&/@Transpose[{
												
												(* Does the container fit into the rack? *)
												batchedRackFPBool,
												
												(* Is the container dramatically shorter than the container? -- CompatibleFootprintQ only checks that the rack height is above the container so basically any container will fit into 5mL Mr Frosty even though that is not what we want in general because the liquid height in Mr Frosty has to be above the liquid in the container for effective freezing *)
												(#-containerTolerance<=First[containerHeights]<=#+containerTolerance)&/@rackHeights
											}];
											
											(* Make a list of allowed racks *)
											allowedRacksForContainerModels=Pick[racks,containerCompatibilityCheck,True];
											
											(* Return the first allowed rack, which will be one of the two Mr. Frosty's we currently have *)
											First[allowedRacksForContainerModels]
										],
										
										(* Otherwise, we have an Automatic method, so we need to find a rack based on what fits *)
										True,Module[{containerCompatibilityCheck,allowedRacksForContainerModels},
											
											(* Run a compatibility check for the first container type with our allowed racks -- we are only checking the first guy since if all container models are not compatible we threw an error already *)
											containerCompatibilityCheck=Apply[And,#]&/@Transpose[{
												
												(* Does the container fit into the rack? *)
												batchedAllowedRackFPBool,
												
												(* Is the container dramatically shorter than the container? -- CompatibleFootprintQ only checks that the rack height is above the container so basically any container will fit into 5mL Mr Frosty even though that is not what we want in general because the liquid height in Mr Frosty has to be above the liquid in the container for effective freezing *)
												(#-containerTolerance<=First[containerHeights]<=#+containerTolerance)&/@allowedRackHeights
											}];
											
											(* Make a list of allowed racks for each container model *)
											allowedRacksForContainerModels=Pick[allowedRacks,containerCompatibilityCheck,True];
											
											(* If we only have a 5 mL Mr. Frosty, return that, otherwise, return the controlled rate freezer rack *)
											If[
												MatchQ[allowedRacksForContainerModels,{ObjectP[Model[Container,Rack,InsulatedCooler]]}],
												First[allowedRacksForContainerModels],
												First[DeleteCases[allowedRacksForContainerModels,ObjectP[Model[Container,Rack,InsulatedCooler]]]]
											]
										]
									]
								],
								{expandedPreResolvedMethods,batchedContainerHeights,initialFreezingContainers,controlledRFRackFPBoolList,batchedRackFPBoolList,batchedAllowedRackFPBoolList}
							]
						]
					];
					
					(* Mapthread the options and return *)
					Transpose[MapThread[
						Function[
							{
								(*1*)rack,
								(*2*)method,
								(*3*)instrument,
								(*4*)freezingProfile,
								(*5*)freezingRate,
								(*6*)duration,
								(*7*)residualTemperature,
								(*8*)freezingContainer,
								(*9*)freezingCondition,
								(*10*)coolant,
								(*11*)coolantVolume,
								(*12*)transportCondition
							},
							Module[{resolvedFreezingMethod,resolvedInstrument,resolvedFreezingProfile,resolvedFreezingRate,resolvedDuration,resolvedResidualTemperature,resolvedFreezingContainer,resolvedFreezingCondition,resolvedCoolant,resolvedCoolantVolume,resolvedTransportCondition},
								
								(* ----- Resolve FreezingMethods ----- *)
								
								resolvedFreezingMethod=Which[
									
									(* If specified, use it *)
									MatchQ[method,Except[Automatic]],method,
									
									(* If we resolved to an insulated cooler rack above, then go with InsulatedCooler *)
									MatchQ[rack,ObjectP[Model[Container,Rack,InsulatedCooler]]],InsulatedCooler,
									
									(* Otherwise, it must be ControlledRateFreezer *)
									True,ControlledRateFreezer
								];
								
								(* ----- Resolve FreezingProfiles ----- *)
								
								resolvedFreezingProfile=Which[
									
									(* If specified, use it -- we already appended the initial condition to the profile above so we can use it as is *)
									MatchQ[freezingProfile,Except[Automatic]],freezingProfile,
									
									(* If we resolved the method to InsulatedCooler, resolve to Null *)
									MatchQ[resolvedFreezingMethod,InsulatedCooler],Null,
									
									(* If any of the constant rate options were specified, resolve to Null *)
									Or[
										MatchQ[freezingRate,Except[Automatic|Null]],
										MatchQ[duration,Except[Automatic|Null]],
										MatchQ[residualTemperature,Except[Automatic|Null]]
									],Null,
									
									(* Otherwise, resolve to our default freezingProfile *)
									True,{{20 Celsius,0 Minute},{-2 Celsius,24 Minute},{-2 Celsius,34 Minute},{-30 Celsius,62 Minute},{-30 Celsius,92 Minute},{-80 Celsius,159 Minute}}
								];
								
								(* ----- Resolve ResidualTemperatures ----- *)
								
								resolvedResidualTemperature=Which[
									
									(* If specified, use it *)
									MatchQ[residualTemperature,Except[Automatic]],residualTemperature,
									
									(* If we resolved the method to InsulatedCooler, resolve to Null *)
									MatchQ[resolvedFreezingMethod,InsulatedCooler],Null,
									
									(* If we resolved freezing profile above, return Null *)
									!NullQ[resolvedFreezingProfile],Null,
									
									(* If both freezing rate and duration are specified, calculate from them *)
									MatchQ[freezingRate,Except[Automatic]]&&MatchQ[duration,Except[Automatic]],Round[20 Celsius-(freezingRate*duration),0.01],
									
									(* If only freezing rate is specified, and it is really slow such that we cannot reach -80C, return the min temp we can reach *)
									MatchQ[freezingRate,Except[Automatic]]&&20 Celsius-(freezingRate*$MaxExperimentTime)>=-80 Celsius,Round[20 Celsius-(freezingRate*$MaxExperimentTime),0.01],
									
									(* If only freezing rate is specified, and we can reach -80C, return -80C *)
									MatchQ[freezingRate,Except[Automatic]],-80 Celsius,
									
									(* If only duration is specified, and we don't have enough time to reach -80C, return the min temp we can reach *)
									MatchQ[duration,Except[Automatic]]&&20 Celsius-(2 Celsius/Minute*duration)>=-80 Celsius,Round[20 Celsius-(2 Celsius/Minute*duration),0.01],
									
									(* If only duration is specified, and we can reach -80C, return -80C *)
									MatchQ[duration,Except[Automatic]],-80 Celsius,
									
									(* Otherwise, resolve to -80 Celsius *)
									True,-80 Celsius
								];
								
								(* ----- Resolve FreezingRates ----- *)
								
								resolvedFreezingRate=Which[
									
									(* If specified, use it *)
									MatchQ[freezingRate,Except[Automatic]],freezingRate,
									
									(* If we resolved the method to InsulatedCooler, resolve to Null *)
									MatchQ[resolvedFreezingMethod,InsulatedCooler],Null,
									
									(* If we resolved freezing profile above, return Null *)
									!NullQ[resolvedFreezingProfile],Null,
									
									(* If we resolved residual temperature to Null above, return Null *)
									NullQ[resolvedResidualTemperature],Null,
									
									(* If duration is specified, calculate from that *)
									MatchQ[duration,Except[Automatic]],Round[(20 Celsius-resolvedResidualTemperature)/duration,0.01],
									
									(* Otherwise, return 1 C/minute *)
									True,1 Celsius/Minute
								];
								
								(* ----- Resolve Durations ----- *)
								
								resolvedDuration=Which[
									
									(* If specified, use it *)
									MatchQ[duration,Except[Automatic]],duration,
									
									(* If we resolved the method to InsulatedCooler, resolve to Null *)
									MatchQ[resolvedFreezingMethod,InsulatedCooler],Null,
									
									(* If we resolved freezing profile above, return Null *)
									!NullQ[resolvedFreezingProfile],Null,
									
									(* If we resolved residual temperature to Null above, return Null *)
									NullQ[resolvedResidualTemperature],Null,
									
									(* Otherwise, calculate from the resolved values *)
									True,Round[(20 Celsius-resolvedResidualTemperature)/resolvedFreezingRate,0.01]
								];
								
								(* ----- Resolve FreezingContainer ----- *)
								
								resolvedFreezingContainer=Which[
									
									(* If specified, use it *)
									MatchQ[freezingContainer,Except[Automatic]],freezingContainer,
									
									(* If we resolved the method to ControlledRateFreezer, resolve to Null *)
									MatchQ[resolvedFreezingMethod,ControlledRateFreezer],Null,
									
									(* Otherwise, return the rack we already resolved *)
									True,rack
								];
								
								(* ----- Resolve FreezingCondition ----- *)
								
								resolvedFreezingCondition=Which[
									
									(* If specified, use it *)
									MatchQ[freezingCondition,Except[Automatic]],freezingCondition,
									
									(* If we resolved the method to ControlledRateFreezer, resolve to Null *)
									MatchQ[resolvedFreezingMethod,ControlledRateFreezer],Null,
									
									(* If instrument was specified as an object, grab from there *)
									MatchQ[instrument,ObjectP[Object[Instrument,Freezer]]],Lookup[fetchPacketFromCache[instrument,cache],ProvidedStorageCondition],
									
									(* If instrument was specified as a model, find its storage condition and use that *)
									MatchQ[instrument,ObjectP[Model[Instrument,Freezer]]],Module[{instrumentTemperature},
										
										(* Find the instrument temperature *)
										instrumentTemperature=Lookup[fetchPacketFromCache[instrument,cache],DefaultTemperature];
										
										(* Return the corresponding storage condition *)
										Which[
											
											(* If instrument temp is between -70C and -90C, return deep freezer *)
											-90 Celsius<=instrumentTemperature<=-70 Celsius,DeepFreezer,
											
											(* If instrument temp is between -30C and -10C, return freezer *)
											-30 Celsius<=instrumentTemperature<=-10 Celsius,Freezer
										]
									],
									
									(* Otherwise, resolve to a Deep Freezer storage condition *)
									True,DeepFreezer
								];
								
								(* ----- Resolve Coolant ----- *)
								
								resolvedCoolant=Which[
									
									(* If specified, use it *)
									MatchQ[coolant,Except[Automatic]],coolant,
									
									(* If we resolved the method to ControlledRateFreezer, resolve to Null *)
									MatchQ[resolvedFreezingMethod,ControlledRateFreezer],Null,
									
									(* Otherwise, return DeepFreezer *)
									True,Model[Sample,"Isopropanol"]
								
								];
								
								(* ----- Resolve CoolantVolume ----- *)
								
								resolvedCoolantVolume=Which[
									
									(* If specified, use it *)
									MatchQ[coolantVolume,Except[Automatic]],coolantVolume,
									
									(* If we resolved the method to ControlledRateFreezer, resolve to Null *)
									MatchQ[resolvedFreezingMethod,ControlledRateFreezer],Null,
									
									(* Otherwise, calculate from the freezer container max volume *)
									True,Module[{rackContainer},
										
										(* Find the we will put our rack in *)
										rackContainer=Download[Lookup[fetchPacketFromCache[resolvedFreezingContainer,cache],DefaultContainer],Object];
										
										(* Return its max volume *)
										Lookup[fetchPacketFromCache[rackContainer,cache],MaxVolume]
									]
								];
								
								(* ----- Resolve Instruments ----- *)
								
								resolvedInstrument=Which[
									
									(* If specified as a freezer object, convert to its model *)
									MatchQ[instrument,ObjectP[Object[Instrument,Freezer]]],Download[Lookup[fetchPacketFromCache[instrument,cache],Model],Object],
									
									(* If specified in any other way, use it *)
									MatchQ[instrument,Except[Automatic]],instrument,
									
									(* If we resolved to an insulated cooler method, resolve the instrument to one that matches the freezing condition *)
									MatchQ[resolvedFreezingMethod,InsulatedCooler],Module[{freezingConditionPacket,freezingConditionTemperature},
										
										(* Get the packet for the freezing condition *)
										freezingConditionPacket=SelectFirst[storageConditionPackets,MatchQ[Lookup[#,StorageCondition],resolvedFreezingCondition]&];
										
										(* Get the temperature for the storage condition *)
										freezingConditionTemperature=Lookup[freezingConditionPacket,Temperature];
										
										(* Find a freezer whose temperature is within 5C of the freezing condition temperature *)
										Lookup[SelectFirst[nonPortableFreezerPackets,freezingConditionTemperature-5 Celsius<=Lookup[#,DefaultTemperature]<=freezingConditionTemperature+5 Celsius&],Object]
									],
									
									(* Otherwise, return the one and only ControlledRateFreezer model *)
									True,Model[Instrument,ControlledRateFreezer,"VIA Freeze Research"]
								];
								
								(* ----- Resolve TransportConditions ----- *)
								
								resolvedTransportCondition=If[
									
									(* If specified, use it *)
									MatchQ[transportCondition,Except[Automatic]],
									transportCondition,
									
									(* Otherwise *)
									Module[{finalCellTemperature,colderTransportConditions,transportConditionPacket},
										
										(* Find the last temperature at which the cells will be at the end of the experiment *)
										finalCellTemperature=Which[
											
											(* If we are doing a variable rate freezer batch, get the last temperature from the freezing profile *)
											!NullQ[resolvedFreezingProfile],First[Last[resolvedFreezingProfile]],
											
											(* If we doing a constant rate freezer batch, return the residual temperature *)
											!NullQ[resolvedResidualTemperature],resolvedResidualTemperature,
											
											(* Otherwise, we are doing an insulated cooler batch so get the temperature of the freezer *)
											True,Lookup[fetchPacketFromCache[resolvedInstrument,cache],DefaultTemperature]
										];
										
										(* Find the transport conditions that are colder than our last temperature *)
										colderTransportConditions=Select[transportConditionPackets,Lookup[#,TransportTemperature]<=finalCellTemperature&];
										
										(* Find the transport condition that is the closest to our cell temperature, but colder *)
										transportConditionPacket=If[
											
											(* If we don't have colder storage conditions, find the coldest one -- this is an edge case where the cell temperature is lower than -80C so we have to account for it here *)
											MatchQ[colderTransportConditions,{}],
											SelectFirst[transportConditionPackets,Lookup[#,TransportTemperature]==Min[Lookup[transportConditionPackets,TransportTemperature]]&],
											
											(* Otherwise, return the highest temperature transport condition amongst the colder one *)
											SelectFirst[colderTransportConditions,Lookup[#,TransportTemperature]==Max[Lookup[colderTransportConditions,TransportTemperature]]&]
										];
										
										(* Find the object for the transport condition and return *)
										Lookup[transportConditionPacket,TransportCondition]
									]
								];
								
								(* Return the result *)
								{
									(*1*)resolvedFreezingMethod,
									(*2*)resolvedInstrument,
									(*3*)resolvedFreezingProfile,
									(*4*)resolvedFreezingRate,
									(*5*)resolvedDuration,
									(*6*)resolvedResidualTemperature,
									(*7*)resolvedFreezingContainer,
									(*8*)resolvedFreezingCondition,
									(*9*)resolvedCoolant,
									(*10*)resolvedCoolantVolume,
									(*11*)resolvedTransportCondition
								}
							]
						],
						{
							(*1*)resolvedRacks,
							(*2*)expandedFreezingMethods,
							(*3*)expandedInstruments,
							(*4*)expandedFreezingProfiles,
							(*5*)expandedFreezingRates,
							(*6*)expandedDurations,
							(*7*)expandedResidualTemperatures,
							(*8*)expandedFreezingContainers,
							(*9*)expandedFreezingConditions,
							(*10*)expandedCoolants,
							(*11*)expandedCoolantVolumes,
							(*12*)expandedTransportConditions
						}
					]]
				]
			]
		]
	];
	
	(* ----- Resolve StorageConditions ----- *)
	resolvedStorageConditions=If[
		MatchQ[#,Except[Automatic]],
		#,
		CryogenicStorage
	]&/@initialStorageConditions;
	
	(* ----- Resolve FastTrack ----- *)
	resolvedFastTrack=If[
		MatchQ[initialFastTrack,Except[Automatic|Null]],
		initialFastTrack,
		False
	];
	
	(* ---------- COMPATIBILITY CHECKS ----------*)
	
	(* Check if we have any coolants *)
	coolantsExistQ=MatchQ[resolvedCoolants,Except[Null|{Null..}]];
	
	(* Get the incompatible materials for the coolants *)
	coolantIncompatibleMaterials=If[
		!coolantsExistQ,
		{},
		Function[
			coolant,
			Which[
				
				(* If coolant is Null, skip *)
				NullQ[coolant],{},
				
				(* If the coolant is a model, grab the packet *)
				MatchQ[coolant,ObjectP[Model[Sample]]],Lookup[fetchPacketFromCache[coolant,cache],IncompatibleMaterials],
				
				(* Otherwise, the coolant must be an object, so find its composition, then grab the packet for its models *)
				True,Module[{composition},
					
					(* Find the composition *)
					composition=Last/@Lookup[fetchPacketFromCache[coolant,cache],Composition];
					
					(* Lookup the incompatible materials for all the models in the composition *)
					Flatten[Lookup[fetchPacketFromCache[#,cache]&/@composition,IncompatibleMaterials]]
				]
			]
		]/@resolvedCoolants
	];
	
	(* Find the container materials *)
	insulatedRackContainerMaterials=If[
		!coolantsExistQ,
		{},
		Function[
			freezingContainer,
			Module[{freezingContainerModelPacket},
				
				(* Get the freezing container's model packet*)
				freezingContainerModelPacket=Which[
					
					(* If freezing container is Null, skip *)
					NullQ[freezingContainer],<||>,
					
					(* If the freezing container is a model, grab the packet for its default container *)
					MatchQ[freezingContainer,ObjectP[Model[Container,Rack,InsulatedCooler]]],fetchPacketFromCache[Download[Lookup[fetchPacketFromCache[freezingContainer,cache],DefaultContainer],Object],cache],
					
					(* Otherwise, the freezing container must be an object, so find its model, then grab the packet for its default container *)
					True,Module[{rackModel},
						
						(* Find the model for the rack *)
						rackModel=fetchPacketFromCache[Download[Lookup[fetchPacketFromCache[freezingContainer,cache],Model],Object],cache];
						
						(* Grab the packet for its default container *)
						fetchPacketFromCache[Download[Lookup[fetchPacketFromCache[rackModel,cache],DefaultContainer],Object],cache]
					]
				];
				
				(* Return the container materials for the coolant model *)
				Lookup[freezingContainerModelPacket,ContainerMaterials,{}]
			]
		]/@resolvedFreezingContainers
	];
	
	(* Check for incompatibilities for each coolant *)
	coolantsCompatibleList=If[
		!coolantsExistQ,
		{True},
		MapThread[MatchQ[Intersection[#1,#2],{}]&,{coolantIncompatibleMaterials,insulatedRackContainerMaterials}]
	];
	
	(* Make a Boolean for error checking *)
	coolantsCompatibleQ=And@@coolantsCompatibleList;
	
	(* Make a list of failing coolants *)
	incompatibleCoolants=If[
		!coolantsCompatibleQ,
		Pick[resolvedCoolants,coolantsCompatibleList,False]
	];
	
	(* If we have any incompatibilities and messages are on, throw an error -- we are throwing this error without checking user specification because the only possible automatic resolution is always compatible so any incompatible coolants must be specified *)
	If[
		!coolantsCompatibleQ&&messages,
		Message[Error::FreezeCellsIncompatibleCoolants,incompatibleCoolants]
	];
	
	(* If gathering tests, create a passing or failing test *)
	coolantsCompatibleTest=Which[
		!gatherTests,Nothing,
		gatherTests&&coolantsCompatibleQ,Test["Specified coolants are chemically compatible with specified or default freezing containers:",True,True],
		gatherTests&&!coolantsCompatibleQ,Test["Specified coolants are chemically compatible with specified or default freezing containers:",True,False]
	];
	
	(* ---------- OTHER CHECKS ---------- *)
	
	(* ----- Do specified Coolants have enough volume? ----- *)
	
	(* Check if the specified coolants are repeated *)
	{nonRepeatedCoolants,nonRepeatedCoolantVolumes}=Which[
		
		(* If no coolants, carry on *)
		!coolantsExistQ,{{},{}},
		
		(* If no object coolants, carry on *)
		!MemberQ[resolvedCoolants,ObjectP[Object[Sample]]],{{},{}},
		
		(* Otherwise, coolants exist and we have objects in there so check if they are repeated *)
		True,Module[{objectCoolants},
			
			(* Make a list of all object coolants *)
			objectCoolants=Cases[resolvedCoolants,ObjectP[Object[Sample]]];
			
			(* Return lists without repeated coolants and their total volumes *)
			Which[
				
				(* If no object coolants, return the original lists *)
				MatchQ[objectCoolants,{}],{resolvedCoolants,resolvedCoolantVolumes},
				
				(* If no duplicates, return the original lists *)
				DuplicateFreeQ[objectCoolants],{resolvedCoolants,resolvedCoolantVolumes},
				
				(* Otherwise, remove duplicates *)
				True,Module[{repeatedCoolantPositions,totalCoolantVolumes,replacementRules,coolantsWithoutRepeatingElements,coolantVolumesWithoutRepeatingElements},
					
					(* Find the positions of the repeated coolants *)
					repeatedCoolantPositions=Flatten[Position[resolvedCoolants,#]]&/@DeleteDuplicates[objectCoolants];
					
					(* Find the coolant volume totals for each repeated coolant *)
					totalCoolantVolumes=Total[Part[resolvedCoolantVolumes,#]]&/@repeatedCoolantPositions;
					
					(* Make replacement rules for the indices we are removing *)
					replacementRules=Rule[#,Nothing]&/@Flatten[repeatedCoolantPositions];
					
					(* Remove the repeated indices from the original lists *)
					{coolantsWithoutRepeatingElements,coolantVolumesWithoutRepeatingElements}=ReplacePart[#,replacementRules]&/@{resolvedCoolants,resolvedCoolantVolumes};
					
					(* Add the repeated elements without actually repeating them and return *)
					{Join[coolantsWithoutRepeatingElements,DeleteDuplicates[objectCoolants]],Join[coolantVolumesWithoutRepeatingElements,totalCoolantVolumes]}
				]
			]
		]
	];
	
	(* Check if the coolant has enough volume *)
	coolantVolumeValidList=If[
		!coolantsExistQ,
		{True},
		MapThread[
			Function[
				{coolant,coolantVolume},
				If[
					MatchQ[coolant,ObjectP[Object[Sample]]],
					Lookup[fetchPacketFromCache[coolant,cache],Volume]>=coolantVolume,
					True
				]
			],
			{nonRepeatedCoolants,nonRepeatedCoolantVolumes}
		]
	];
	
	(* Make a Boolean for error checking *)
	coolantVolumeValidQ=And@@coolantVolumeValidList;
	
	(* Make a list of failing coolants *)
	insufficientCoolants=If[
		!coolantVolumeValidQ,
		Pick[nonRepeatedCoolants,coolantVolumeValidList,False]
	];
	
	(* If we have any incompatibilities and messages are on, throw an error -- we are throwing this error without checking user specification because the only possible automatic resolution is always compatible so any incompatible coolants must be specified. Also skip this if the coolant is not liquid *)
	If[
		!coolantVolumeValidQ&&coolantStateValidQ&&messages,
		Message[Error::FreezeCellsInsufficientCoolants,insufficientCoolants]
	];
	
	(* If gathering tests, create a passing or failing test *)
	coolantVolumeValidTest=Which[
		!gatherTests,Nothing,
		gatherTests&&coolantVolumeValidQ,Test["Specified coolants have enough volume for the experiment:",True,True],
		gatherTests&&!coolantVolumeValidQ,Test["Specified coolants have enough volume for the experiment:",True,False]
	];
	
	(* ----- Are StorageConditions warmer than the final freezing temperature? ----- *)
	(* We are doing this check here because StorageConditions are index-matches to samples and not batches. So there is no good way to figure out which batch a sample may end without actually going through the resolver. If the sample ends up in a batch that has a colder final temperature than the final storage, we still want to show a warning to the user *)
	
	(* Find the final temperature of all the batches *)
	finalBatchTemperature=If[
		MatchQ[initialStorageConditions,{Automatic..}],
		{},
		MapThread[
			Function[
				{freezingProfile,residualTemperature,freezingCondition},
				Which[
					
					(* If we are doing a variable rate ControlledRateFreezer experiment *)
					MatchQ[freezingProfile,Except[Null]],First[Last[freezingProfile]],
					
					(* If we are doing a constant rate ControlledRateFreezer experiment with ResidualTemperatures specified *)
					MatchQ[residualTemperature,Except[Null]],residualTemperature,
					
					(* If we are doing an InsulatedCooler experiment with FreezingConditions specified as SampleStorageTypeP *)
					MatchQ[freezingCondition,Except[Null]],Lookup[SelectFirst[storageConditionPackets,MatchQ[Lookup[#,StorageCondition],freezingCondition]&],Temperature]
				]
			],
			{resolvedFreezingProfiles,resolvedResidualTemperatures,resolvedFreezingConditions}
		]
	];
	
	(* Create a list of storage condition samples grouped by batches *)
	batchedStorageConditionTemperatures=If[
		MatchQ[initialStorageConditions,{Automatic..}],
		{},
		Module[{storageConditionTemperature},
			
			(* Find storage condition temperatures *)
			storageConditionTemperature=Function[storageCondition,Lookup[SelectFirst[storageConditionPackets,MatchQ[Lookup[#,StorageCondition],storageCondition]&],Temperature]]/@resolvedStorageConditions;
			
			(* Group the temperatures by batches -- since samples are unique pick always returns a list of one item, so we are taking the first element *)
			Function[batch,First[PickList[storageConditionTemperature,mySamples,#]]&/@batch]/@resolvedBatches
		]
	];
	
	(* Check the storage condition temp of each sample in the batches *)
	storageWarmedSamplesList=If[
		MatchQ[initialStorageConditions,{Automatic..}],
		{},
		Flatten[MapThread[
			Function[
				{batchTemperature,storageTemperatureList,batchSampleList},
				MapThread[
					Function[
						{storageTemperature,batchSample},
						If[
							storageTemperature>batchTemperature,
							batchSample,
							Nothing
						]
					],
					{storageTemperatureList,batchSampleList}
				]
			],
			{finalBatchTemperature,batchedStorageConditionTemperatures,resolvedBatches}
		]]
	];
	
	(* Create a bool for error checking *)
	storageWarmedSamplesQ=MatchQ[storageWarmedSamplesList,{}];
	
	(* If we have any warming steps, display a warning *)
	If[
		!storageWarmedSamplesQ&&messages&&!MatchQ[$ECLApplication,Engine],
		Message[Warning::FreezeCellsWarmingDuringTransport,storageWarmedSamplesList]
	];
	
	(* ----- Is specified name unique? ----- *)
	
	(* Check if the name is in use *)
	nameUniqueQ=!TrueQ[DatabaseMemberQ[Append[Object[Protocol,FreezeCells],initialName]]];
	
	(* If the name is a duplicate, throw an error *)
	If[
		!nameUniqueQ,
		Message[Error::DuplicateName,Object[Protocol,FreezeCells]]
	];
	
	(* If gathering tests, create a passing or failing test *)
	duplicateNameTest=Which[
		!gatherTests,Nothing,
		gatherTests&&!nameUniqueQ,Test["If name is specified it does not already exist in the database for an Object[Protocol,FreezeCells]:",True,False],
		gatherTests&&nameUniqueQ,Test["If name is specified it does not already exist in the database for an Object[Protocol,FreezeCells]:",True,True]
	];
	
	(* ----- Check for invalid input and option variables ----- *)
	
	(* Check if any errors have been thrown *)
	invalidInputs=Nand[uniqueInputsQ,validInputsQ,liquidInputsQ,compatibleContainersQ];
	
	(* Make a list of all variables for error tracking *)
	invalidOptionsList={
		(*1*)validInstrumentsQ,
		(*2*)totalBatchLengthValidQ,
		(*3*)validFreezingContainersQ,
		(*4*)nonDuplicatedSamplesWithinBatchesQ,
		(*5*)specifiedBatchSamplesQ,
		(*6*)allSamplesInBatchesQ,
		(*7*)nonDuplicatedSamplesAcrossBatchesQ,
		(*8*)incompatibleOptionsQ,
		(*9*)groupedInvalidOptionsQ,
		(*10*)validBatchContainersQ,
		(*11*)validMethodContainersQ,
		(*12*)batchRackValidQ,
		(*13*)batchLengthsValidQ,
		(*14*)instrumentCompatibleQ,
		(*15*)constantRateOptionsValidQ,
		(*16*)constantRateOptionsConsistentQ,
		(*17*)freezingProfilesIncreasingTimeStepQ,
		(*18*)validProfileCoolingRateQ,
		(*19*)freezingContainerSampleCompatibleQ,
		(*20*)coolantVolumeSpecificationValidQ,
		(*21*)coolantStateValidQ,
		(*22*)validCoolantVolumesQ,
		(*23*)validFreezingConditionQ,
		(*24*)rackReplacementsValidQ,
		(*25*)coolantsCompatibleQ,
		(*26*)coolantVolumeValidQ,
		(*27*)nameUniqueQ
	};
	
	(* Prepare a list of which options are failing for each error *)
	invalidOptionErrors={
		(*1*)Instruments,
		(*2*)Batches,
		(*3*)FreezingContainers,
		(*4*)Batches,
		(*5*)Batches,
		(*6*)Batches,
		(*7*)Batches,
		(*8*)incompatibleOptions,
		(*9*)groupedInvalidOptions,
		(*10*)Batches,
		(*11*){Batches,FreezingMethods},
		(*12*)Flatten[{Batches,invalidBatchRackOptions}],
		(*13*)Batches,
		(*14*){Instruments,FreezingMethods},
		(*15*)DeleteDuplicates[Flatten[invalidConstantRateOptions]],
		(*16*){FreezingRates,Durations,ResidualTemperatures},
		(*17*)FreezingProfiles,
		(*18*)FreezingProfiles,
		(*19*)FreezingContainers,
		(*20*)CoolantVolumes,
		(*21*)Coolants,
		(*22*)CoolantVolumes,
		(*23*){FreezingConditions,Instruments},
		(*24*)FreezingMethods,
		(*25*)Coolants,
		(*26*)Coolants,
		(*27*)Name
	};
	
	(* Check if anything failed *)
	invalidOptions=Nand@@invalidOptionsList;
	
	(* Prepare a list of which options failed *)
	errors=DeleteDuplicates[Flatten[Pick[invalidOptionErrors,invalidOptionsList,False]]];
	
	(* If there are invalid inputs, throw error *)
	If[
		invalidInputs,
		Message[Error::InvalidInput,DeleteDuplicates[Flatten[{duplicatedSamples,discardedSamples,solidSamples,incompatibleSamples}]]]
	];
	
	(* If there are invalid options, throw error *)
	If[
		invalidOptions,
		Message[Error::InvalidOption,errors]
	];
	
	(* ----- RETURN RESULTS ----- *)
	
	(* Combine all options *)
	allOptions={
		Batches->resolvedBatches,
		FreezingMethods->resolvedFreezingMethods,
		Instruments->resolvedInstruments,
		FreezingProfiles->resolvedFreezingProfiles,
		FreezingRates->resolvedFreezingRates,
		Durations->resolvedDurations,
		ResidualTemperatures->resolvedResidualTemperatures,
		FreezingContainers->resolvedFreezingContainers,
		FreezingConditions->resolvedFreezingConditions,
		Coolants->resolvedCoolants,
		CoolantVolumes->resolvedCoolantVolumes,
		TransportConditions->resolvedTransportConditions,
		StorageConditions->resolvedStorageConditions,
		Name->initialName,
		Template->Lookup[myOptions,Template],
		FastTrack->resolvedFastTrack,
		ReturnPrimitives->Lookup[myOptions,ReturnPrimitives],
		UploadResources->Lookup[myOptions,UploadResources]
	};
	
	(* Return the specified output *)
	outputSpecification/.{
		Result->allOptions,
		Tests->Flatten[{uniqueInputsTest,validInputTest,liquidInputsTest,compatibleContainersTest,precisionTests,validInstrumentTest,totalBatchLengthValidTest,validFreezingContainersTest,nonDuplicatedBatchesTest,specifiedBatchSamplesTest,allSamplesInBatchesTest,nonDuplicatedSamplesAcrossBatchesTest,incompatibleOptionsTest,groupedInvalidOptionsTest,validBatchContainersTest,validMethodContainersTest,batchRackValidTest,batchLengthsValidTest,instrumentCompatibleTest,constantRateOptionsValidTest,constantRateOptionsConsistentTest,freezingProfilesIncreasingTimeStepTest,freezingContainerSampleCompatibleTest,validProfileCoolingRateTest,validCoolantVolumesTest,validCoolantVolumesTest,validFreezingConditionTest,batchesResolvableTest,coolantsCompatibleTest,coolantVolumeValidTest,duplicateNameTest}]
	}
];


(* ::Subsection:: *)
(*Resource Packets*)


DefineOptions[freezeCellsResourcePackets,
	Options:>{
		CacheOption,
		HelperOutputOption
	}
];

Error::FreezeCellsMaxTimeExceeded="The experiment as specified takes `1`, which exceeds the maximum allowed time for experiments (`2`). Please specify a shorter experiment.";

freezeCellsResourcePackets[mySamples:ListableP[ObjectP[Object[Sample]]],myUnresolvedOptions:{___Rule},myResolvedOptions:{___Rule},myOptions:OptionsPattern[freezeCellsResourcePackets]]:=Module[
	{
		(* Framework variables *)
		outputSpecification,output,gatherTests,messages,cache,unresolvedOptionsNoHidden,resolvedOptionsNoHidden,protocolPacket,allResourceBlobs,fulfillableQ,frqTests,
		
		(* Resolved options *)
		resolvedBatches,resolvedFreezingMethods,resolvedInstruments,resolvedFreezingProfiles,resolvedFreezingRates,resolvedDurations,resolvedResidualTemperatures,resolvedFreezingContainers,resolvedFreezingConditions,resolvedCoolants,resolvedCoolantVolumes,resolvedTransportConditions,resolvedStorageConditions,resolvedName,resolvedFastTrack,
		
		(* Resource generation variables *)
		samplePackets,sampleContainers,sampleResources,sampleContainerResources,experimentRunTimes,instrument,instrumentResource,freezingContainerResources,defaultContainers,coolantResources,transportConditionPackets,transportConditionModels,transportConditionTemperatures,portableFreezerPackets,transportCoolers,tweezerResource,controlledRateFreezerBatches,controlledRateFreezerBatchLengths,controlledRateFreezerInstrument,controlledRateFreezerTransportCoolerResources,controlledRateFreezerTransportTemperatures,controlledRateFreezerStorageConditions,insulatedCoolerBatches,insulatedCoolerBatchLengths,insulatedCoolerFreezingConditions,insulatedCoolerTransportCoolerResources,insulatedCoolerTransportTemperatures,insulatedCoolerStorageConditions,totalExperimentRunTime,totalExperimentTimeValidQ,totalExperimentTimeValidTest,additionalProcessingStageTime
	},
	
	(* Determine the requested output format *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];
	
	(* Determine if we should keep a running list of tests to return to the user *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;
	
	(* Get the inherited cache *)
	cache=Lookup[ToList[myOptions],Cache,{}];
	
	(* Get the resolved option values *)
	{resolvedBatches,resolvedFreezingMethods,resolvedInstruments,resolvedFreezingProfiles,resolvedFreezingRates,resolvedDurations,resolvedResidualTemperatures,resolvedFreezingContainers,resolvedFreezingConditions,resolvedCoolants,resolvedCoolantVolumes,resolvedTransportConditions,resolvedStorageConditions,resolvedName,resolvedFastTrack}=Lookup[myResolvedOptions,{Batches,FreezingMethods,Instruments,FreezingProfiles,FreezingRates,Durations,ResidualTemperatures,FreezingContainers,FreezingConditions,Coolants,CoolantVolumes,TransportConditions,StorageConditions,Name,FastTrack}];
	
	(* ---------- Generate Resources ---------- *)
	
	(* ----- Generate the sample resources ----- *)
	
	(* Fetch the packets for the samples *)
	samplePackets=fetchPacketFromCache[#,cache]&/@mySamples;
	
	(* Find the containers for the samples *)
	sampleContainers=Download[Lookup[samplePackets,Container],Object];
	
	(* Prepare the sample resources *)
	sampleResources=Resource[Sample->#]&/@mySamples;
	
	(* Prepare the container resources *)
	sampleContainerResources=Resource[Sample->#]&/@sampleContainers;
	
	(* ----- Generate the instrument resources ----- *)
	
	(* Calculate run times for each batch *)
	experimentRunTimes=MapThread[
		Function[
			{instrument,freezingProfile,duration},
			Which[
				
				(* If we are doing a variable rate controlled rate freezer method, get the last time from the profile *)
				MatchQ[instrument,ObjectP[{Model[Instrument,ControlledRateFreezer],Object[Instrument,ControlledRateFreezer]}]]&&!NullQ[freezingProfile],Last[Last[freezingProfile]],
				
				(* If we are doing a constant rate controlled rate freezer method, get the duration *)
				MatchQ[instrument,ObjectP[{Model[Instrument,ControlledRateFreezer],Object[Instrument,ControlledRateFreezer]}]]&&!NullQ[duration],duration,
				
				(* Otherwise, we are doing an insulated cooler method so we are not using an instrument *)
				True,Nothing
			]
		],
		{resolvedInstruments,resolvedFreezingProfiles,resolvedDurations}
	];
	
	(* Find the instrument we are using -- since we only have one instrument here, we are finding the first one and using that *)
	instrument=FirstCase[resolvedInstruments,ObjectP[{Model[Instrument,ControlledRateFreezer],Object[Instrument,ControlledRateFreezer]}],Null];
	
	(* Create the instrument resource -- 60 minutes is the time it takes for all other steps *)
	instrumentResource=If[
		!NullQ[instrument],
		Resource[Instrument->instrument,Name->ToString[Unique[]],Time->Total[experimentRunTimes]+60 Minute]
	];
	
	(* ----- Generate the freezing container resources ----- *)
	
	freezingContainerResources=If[
		NullQ[#],
		Nothing,
		Resource[Sample->#,Name->ToString[Unique[]],Rent->True]
	]&/@resolvedFreezingContainers;
	
	(* ----- Generate the coolant resources ----- *)
	
	(* Find the default containers for our cooling racks *)
	defaultContainers=If[
		NullQ[#],
		Null,
		Download[Lookup[fetchPacketFromCache[#,cache],DefaultContainer],Object]
	]&/@resolvedFreezingContainers;
	
	(* Prepare the resources *)
	coolantResources=MapThread[
		Function[
			{coolant,coolantVolume,container},
			If[
				NullQ[coolant],
				Nothing,
				Resource[Sample->coolant,Amount->coolantVolume,Container->container,RentContainer->True]
			]
		],
		{resolvedCoolants,resolvedCoolantVolumes,defaultContainers}
	];
	
	(* ----- Generate the transport freezer resources ----- *)
	
	(* Fetch the transport condition packets *)
	transportConditionPackets=Select[cache,MatchQ[Lookup[#,Type],Model[TransportCondition]]&];
	
	(* Convert the transport conditions to models *)
	transportConditionModels=Function[transportCondition,SelectFirst[transportConditionPackets,MatchQ[Lookup[#,TransportCondition],transportCondition]&]]/@resolvedTransportConditions;
	
	(* Find the temperature for our transport conditions *)
	transportConditionTemperatures=Lookup[fetchPacketFromCache[#,cache]&/@transportConditionModels,TransportTemperature];
	
	(* Prepare packets for the portable freezers *)
	portableFreezerPackets=Select[cache,MatchQ[Lookup[#,Type],Model[Instrument,PortableCooler]]&];
	
	(* Find the coolers we will use for transport *)
	transportCoolers=Function[
		temperature,
		Lookup[SelectFirst[portableFreezerPackets,Lookup[#,MinTemperature]<=temperature&],Object]
	]/@transportConditionTemperatures;
	
	(* ----- Generate miscellaneous resources ----- *)
	
	(* Prepare the tweezer resource *)
	tweezerResource=Resource[Sample->Model[Item,Tweezer,"Cryogenic Vial Grippers"],Name->ToString[Unique[]],Rent->True];
	
	(* ---------- Group Batches by Method ---------- *)
	
	(* Prepare the controlled rate freezer batches *)
	controlledRateFreezerBatches=MapThread[
		Function[
			{method,batch},
			If[
				MatchQ[method,ControlledRateFreezer],
				Link[#]&/@batch,
				Nothing
			]
		],
		{resolvedFreezingMethods,resolvedBatches}
	];
	
	(* Find the lengths controlled rate freezer batches *)
	controlledRateFreezerBatchLengths=Length/@controlledRateFreezerBatches;
	
	(* Prepare controlled rate freezer instruments *)
	controlledRateFreezerInstrument=If[
		!NullQ[instrumentResource],
		instrumentResource
	];
	
	(* Prepare controlled rate freezer transport cooler resources -- these will each be an individual resource as we will move them one at a time *)
	controlledRateFreezerTransportCoolerResources=MapThread[
		Function[
			{method,cooler},
			If[
				MatchQ[method,ControlledRateFreezer],
				Resource[Instrument->cooler,Name->ToString[Unique[]],Time->15 Minute],
				Nothing
			]
		],
		{resolvedFreezingMethods,transportCoolers}
	];
	
	(* Prepare controlled rate freezer transport cooler temperatures *)
	controlledRateFreezerTransportTemperatures=MapThread[
		Function[
			{method,temperature},
			If[
				MatchQ[method,ControlledRateFreezer],
				temperature,
				Nothing
			]
		],
		{resolvedFreezingMethods,transportConditionTemperatures}
	];
	
	(* Prepare controlled rate freezer storage conditions *)
	controlledRateFreezerStorageConditions=Module[{replacementRules},
		
		(* Create replacement rules for the samples and their storage conditions *)
		replacementRules=Rule[LinkP[First[#]],Last[#]]&/@Transpose[{mySamples,resolvedStorageConditions}];
		
		(* Replace the samples in each batch with their storage condition *)
		ReplaceAll[#,replacementRules]&/@controlledRateFreezerBatches
	];
	
	(* Prepare the insulated cooler batches *)
	insulatedCoolerBatches=MapThread[
		Function[
			{method,batch},
			If[
				MatchQ[method,InsulatedCooler],
				Link[#]&/@batch,
				Nothing
			]
		],
		{resolvedFreezingMethods,resolvedBatches}
	];
	
	(* Find the lengths controlled rate freezer batches *)
	insulatedCoolerBatchLengths=Length/@insulatedCoolerBatches;
	
	(* Prepare the storage conditions for the insulated cooler racks *)
	insulatedCoolerFreezingConditions=If[
		
		(* If Null, return nothing *)
		NullQ[#],
		Nothing,
		#
	]&/@resolvedFreezingConditions;
	
	(* Prepare insulated cooler transport coolers -- we will shrink these into the smallest possible set as we are moving them all at once *)
	insulatedCoolerTransportCoolerResources=Module[{coolers,resources,replacementRules},
		
		(* Grab the transport coolers for the insulated cooler methods *)
		coolers=MapThread[
			Function[
				{method,cooler},
				If[
					MatchQ[method,InsulatedCooler],
					cooler,
					Nothing
				]
			],
			{resolvedFreezingMethods,transportCoolers}
		];
		
		(* Generate resources for all unique coolers with an index for the instrument *)
		resources={#,Resource[Instrument->#,Name->ToString[Unique[]],Time->15 Minute]}&/@DeleteDuplicates[coolers];
		
		(* Make replacement rules from the resources *)
		replacementRules=If[
			!MatchQ[resources,{}],
			Rule[First[#],Last[#]]&/@resources,
			{}
		];
		
		(* Replace the coolers with the correct resources and return *)
		coolers/.replacementRules
	];
	
	(* Prepare the transport temperatures for the insulated cooler methods *)
	insulatedCoolerTransportTemperatures=MapThread[
		Function[
			{method,temperature},
			If[
				MatchQ[method,InsulatedCooler],
				temperature,
				Nothing
			]
		],
		{resolvedFreezingMethods,transportConditionTemperatures}
	];
	
	(* Prepare insulated cooler storage conditions *)
	insulatedCoolerStorageConditions=Module[{replacementRules},
		
		(* Create replacement rules for the samples and their storage conditions *)
		replacementRules=Rule[LinkP[First[#]],Last[#]]&/@Transpose[{mySamples,resolvedStorageConditions}];
		
		(* Replace the samples in each batch with their storage condition *)
		ReplaceAll[#,replacementRules]&/@insulatedCoolerBatches
	];
	
	(* ---------- Calculate Run Time For Cell Freezing Checkpoint ---------- *)
	
	totalExperimentRunTime=Which[
		
		(* If we only have controlled rate freezer steps, then the total time is the sum of all the times we have for those steps *)
		MatchQ[resolvedFreezingMethods,{ControlledRateFreezer..}],Total[experimentRunTimes],
		
		(* If we only have insulated cooler steps, then the total time is 4 hours for freezing, plus 10 minutes of setup for each container -- since Mr. Frosty decreases the temperature by 1C/min, it would only take about 1 hour and 45 minutes to freeze insulated cooler batches from room temperature to -80C. However, there are a lot of assumptions in that calculation to be making with other people's cells so we are going to bump that up to 4 hours to ensure we are doing a proper job *)
		MatchQ[resolvedFreezingMethods,{InsulatedCooler..}],4 Hour+(10 Minute*Length[resolvedFreezingMethods]),
		
		(* Otherwise, we have a mix of methods so we need to calculate the total time -- we are setting up all the insulated cooler batches, putting them into the freezer, and then running the controlled rate freezer methods. If the time it takes to run the controlled rate freezer method is shorter than the 4 hour freezing time for insulated coolers, we need to wait more before we can store the insulated cooler samples. On the flip side, if the controlled rate freezer takes longer than 4 hours, then we waited 4 hours already so we just go with the time it takes to run the controlled rate freezer batches *)
		True,Max[4 Hour+(10 Minute*Length[resolvedFreezingMethods]),Total[experimentRunTimes]+(10 Minute*Length[resolvedFreezingMethods])]
	];
	
	(* Check if the total time for the experiment is valid *)
	totalExperimentTimeValidQ=totalExperimentRunTime+60 Minute<=$MaxExperimentTime;
	
	(* If we exceed the total time and messages are on, throw an error *)
	If[
		!totalExperimentTimeValidQ&&messages,
		Message[Error::FreezeCellsMaxTimeExceeded,UnitConvert[totalExperimentRunTime+60 Minute,Hour],$MaxExperimentTime]
	];
	
	(* If gathering tests, create a passing or failing test *)
	totalExperimentTimeValidTest=Which[
		!gatherTests,Nothing,
		gatherTests&&totalExperimentTimeValidQ,Test["The experiment as specified does not exceed maximum allowed experiment time:",True,True],
		gatherTests&&!totalExperimentTimeValidQ,Test["The experiment as specified does not exceed maximum allowed experiment time:",True,False]
	];
	
	(* ---------- Additional Processing Stage ---------- *)
	
	(* Calculate the time for the extra processing stage for the insulated cooler batches -- we are setting up all the insulated cooler batches, putting them into the freezer, and then running the controlled rate freezer methods. If the time it takes to run the controlled rate freezer method is shorter than the 4 hour freezing time for insulated coolers, we need to wait more before we can store the insulated cooler samples. So in that case, we need an additional processing stage for the insulated cooler batches to fully freeze *)
	additionalProcessingStageTime=If[
		
		(* If we have a mixture of methods, and time it takes to run the controlled rate freezer batches is less than 4 hours, add more time to make it 4 hours -- we only need to worry about the mixed method case here because if only one type of method is specified, there is an appropriate processing stage. So the only case we need to check for is when we prepare the insulated cooler batches, put them in the freezer, and run all the controlled rate freezer methods before the insulated cooler batches are done freezing *)
		MemberQ[resolvedFreezingMethods,ControlledRateFreezer]&&MemberQ[resolvedFreezingMethods,InsulatedCooler]&&Total[experimentRunTimes]<4 Hour,
		4 Hour-Total[experimentRunTimes],
		
		(* Otherwise, we are good so return Null *)
		Null
	];
	
	(* ---------- Prepare the Packets ---------- *)
	
	(* Collapse options and remove hidden ones *)
	unresolvedOptionsNoHidden=RemoveHiddenOptions[ExperimentFreezeCells,CollapseIndexMatchedOptions[ExperimentFreezeCells,myUnresolvedOptions,Messages->False]];
	resolvedOptionsNoHidden=RemoveHiddenOptions[ExperimentFreezeCells,CollapseIndexMatchedOptions[ExperimentFreezeCells,myResolvedOptions,Messages->False]];
	
	(* ----- Make the protocol packet ----- *)
	protocolPacket=If[MatchQ[Lookup[myResolvedOptions,ReturnPrimitives],True],
		MapThread[
			Function[
				{batch,freezingMethod,freezingProfile,freezingRate,duration,residualTemperature,freezingContainer,coolant,coolantVolume,coolantContainer,transportCooler,transportTemperature,freezingCondition,runTime},
				<|
					Type->Object[Primitive,FreezeCells],
					
					(* Samples *)
					Replace[SamplesIn]->(Link[#,Protocols]&/@batch),
					
					FreezingMethod->freezingMethod,
					(* NOTE: This is called Freezer in the primitive but called Instrument for the protocol object. *)
					Freezer->If[MatchQ[freezingMethod,ControlledRateFreezer],
						Link[controlledRateFreezerInstrument],
						Null
					],
					FreezingProfile->freezingProfile,
					FreezingRate->freezingRate,
					FreezingCondition->freezingCondition,
					Duration->duration,
					ResidualTemperature->residualTemperature,
					FreezingContainer->If[!MatchQ[freezingContainer,Null],
						Resource[Sample->freezingContainer,Name->ToString[Unique[]],Rent->True],
						Null
					],
					Coolant->If[!MatchQ[coolant,Null],
						Resource[Sample->coolant,Amount->coolantVolume,Container->coolantContainer,RentContainer->True],
						Null
					],
					TransportFreezer->If[!MatchQ[transportCooler,Null],
						Resource[Instrument->transportCooler,Name->ToString[Unique[]],Time->15 Minute],
						Null
					],
					TransportTemperature->transportTemperature,
					
					(* Miscellaneous *)
					Tweezer->tweezerResource,
					RunTime->runTime,
					AdditionalProcessingTime->additionalProcessingStageTime
				|>
			],
			{
				resolvedBatches,
				resolvedFreezingMethods,
				resolvedFreezingProfiles,
				resolvedFreezingRates,
				resolvedDurations,
				resolvedResidualTemperatures,
				resolvedFreezingContainers,
				resolvedCoolants,resolvedCoolantVolumes,defaultContainers,
				transportCoolers,
				transportConditionTemperatures,
				resolvedFreezingConditions,
				experimentRunTimes
			}
		],
		<|
			
			(* Organizational information *)
			Object->CreateID[Object[Protocol,FreezeCells]],
			Type->Object[Protocol,FreezeCells],
			Name->resolvedName,
			Template->Link[Lookup[myUnresolvedOptions,Template],ProtocolsTemplated],
			ParentProtocol->Lookup[myUnresolvedOptions,ParentProtocol],
			
			(* Options handling *)
			UnresolvedOptions->unresolvedOptionsNoHidden,
			ResolvedOptions->resolvedOptionsNoHidden,
			
			(* Checkpoints *)
			Replace[Checkpoints]->{
				{"Picking Resources",20 Minute,"Samples and equipment required to execute this protocol are gathered from storage.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->20 Minute]]},
				{"Equipment Setup",20 Minute,"Instruments and cooling racks are set up and if necessary, software setup is performed.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->20 Minute]]},
				{"Cell Freezing",totalExperimentRunTime,"Sample are frozen.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->totalExperimentRunTime]]},
				{"Equipment Clean-up",20 Minute,"Sample are removed from the instrument and placed in final storage. Equipment is returned to a ready state for the next user.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->20 Minute]]}
			},
			
			(* Samples *)
			Replace[SamplesIn]->(Link[#,Protocols]&/@sampleResources),
			Replace[ContainersIn]->(Link[#,Protocols]&/@sampleContainerResources),
			Replace[SamplesInStorage]->resolvedStorageConditions,
			
			(* Experiment options *)
			Replace[Batches]->resolvedBatches,
			Replace[FreezingMethods]->resolvedFreezingMethods,
			Replace[Instruments]->(Link[#]&/@resolvedInstruments),
			Replace[FreezingProfiles]->resolvedFreezingProfiles,
			Replace[FreezingRates]->resolvedFreezingRates,
			Replace[Durations]->resolvedDurations,
			Replace[ResidualTemperatures]->resolvedResidualTemperatures,
			Replace[FreezingContainers]->(Link[#]&/@resolvedFreezingContainers),
			Replace[Coolants]->(Link[#]&/@resolvedCoolants),
			Replace[TransportFreezers]->(Link[#]&/@transportCoolers),
			
			(* Batching fields *)
			Replace[ControlledRateFreezerBatches]->(Link[#]&/@Flatten[controlledRateFreezerBatches]),
			Replace[ControlledRateFreezerBatchLengths]->controlledRateFreezerBatchLengths,
			ControlledRateFreezerInstrument->Link[controlledRateFreezerInstrument],
			Replace[ControlledRateFreezerTransportCoolers]->(Link[#]&/@controlledRateFreezerTransportCoolerResources),
			Replace[ControlledRateFreezerTransportTemperatures]->controlledRateFreezerTransportTemperatures,
			Replace[ControlledRateFreezerStorageConditions]->Flatten[controlledRateFreezerStorageConditions],
			Replace[InsulatedCoolerBatches]->(Link[#]&/@Flatten[insulatedCoolerBatches]),
			Replace[InsulatedCoolerBatchLengths]->insulatedCoolerBatchLengths,
			Replace[InsulatedCoolerFreezingContainers]->(Link[#]&/@freezingContainerResources),
			Replace[InsulatedCoolerCoolants]->(Link[#]&/@coolantResources),
			Replace[InsulatedCoolerFreezingConditions]->insulatedCoolerFreezingConditions,
			Replace[InsulatedCoolerTransportCoolers]->(Link[#]&/@insulatedCoolerTransportCoolerResources),
			Replace[InsulatedCoolerTransportTemperatures]->insulatedCoolerTransportTemperatures,
			Replace[InsulatedCoolerStorageConditions]->Flatten[insulatedCoolerStorageConditions],
			
			(* Miscellaneous *)
			Tweezer->tweezerResource,
			Replace[RunTimes]->experimentRunTimes,
			AdditionalProcessingTime->additionalProcessingStageTime
		|>
	];
	
	(* ----- Check resources ----- *)
	
	(* Gather all the resource symbolic representations -- infinite depth is necessary to grab the resources from inside the heads *)
	allResourceBlobs=DeleteDuplicates[Cases[Flatten[Values[protocolPacket]],_Resource,Infinity]];
	
	(* Check if the resources can be fulfilled *)
	{fulfillableQ,frqTests}=Which[
		
		(* If on engine, return True *)
		MatchQ[$ECLApplication,Engine],{True,{}},
		
		(* If the experiment is too long, skip *)
		!totalExperimentTimeValidQ,{False,{}},
		
		(* If gathering tests, return the tests *)
		gatherTests,Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->resolvedFastTrack,Site->Lookup[myResolvedOptions,Site],Cache->cache],
		
		(* Otherwise, return without tests *)
		True,{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->resolvedFastTrack,Site->Lookup[myResolvedOptions,Site],Messages->messages,Cache->cache],{}}
	];
	
	(* ---------- Return The Packets ---------- *)
	
	(* Return the output *)
	outputSpecification/.{
		Result->If[
			fulfillableQ&&totalExperimentTimeValidQ,
			protocolPacket,
			$Failed
		],
		Tests->If[
			gatherTests,
			Prepend[frqTests,totalExperimentTimeValidTest],
			{}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentFreezeCellsOptions*)


DefineOptions[ExperimentFreezeCellsOptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
			Description->"Determines whether the function returns a table or a list of the options."
		}
		
	},
	SharedOptions:>{ExperimentFreezeCells}
];

ExperimentFreezeCellsOptions[myInputs:{ObjectP[{Object[Container],Object[Sample]}]..},myOptions:OptionsPattern[]]:=Module[{listedOptions,noOutputOptions,options},
	
	(* Get the options as a list *)
	listedOptions=ToList[myOptions];
	
	(* Remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_,OutputFormat->_]];
	
	(* Get only the options for ExperimentCrossFlowFiltration *)
	options=ExperimentFreezeCells[myInputs,Append[noOutputOptions,Output->Options]];
	
	(* Return the option as a list or table *)
	If[
		MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentFreezeCells],
		options
	]
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentFreezeCellsQ*)


DefineOptions[ValidExperimentFreezeCellsQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions:>{ExperimentFreezeCells}
];


ValidExperimentFreezeCellsQ[myInputs:{ObjectP[{Object[Container],Object[Sample]}]..},myOptions:OptionsPattern[]]:=Module[{listedOptions,preparedOptions,experimentFreezeCellsTests,initialTestDescription,allTests,verbose,outputFormat},
	
	(* Get the options as a list *)
	listedOptions=ToList[myOptions];
	
	(* Remove the ValidQ specific options and Output before passing to the core function -- we want the output to be Tests in the call below *)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];
	
	(* Return only the tests for ExperimentFreezeCells *)
	experimentFreezeCellsTests=ExperimentFreezeCells[myInputs,Append[preparedOptions,Output->Tests]];
	
	(* Define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";
	
	(* Make a list of all the tests, including the blanket test *)
	allTests=If[
		MatchQ[experimentFreezeCellsTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[{initialTest,validObjectBooleans,voqWarnings},
			
			(* Generate the initial test, which we know will pass if we got this far *)
			initialTest=Test[initialTestDescription,True,True];
			
			(* Check if objects are valid *)
			validObjectBooleans=ValidObjectQ[myInputs,OutputFormat->Boolean];
			
			(* Create warnings for invalid objects *)
			voqWarnings=MapThread[
				Warning[
					StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
					validObjectBoolean,
					True
				]&,
				{myInputs,validObjectBooleans}
			];
			
			(* Get all the tests/warnings *)
			Flatten[{initialTest,voqWarnings,experimentFreezeCellsTests}]
		]
	];
	
	(* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];
	
	(* Run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentFreezeCellsQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidExperimentFreezeCellsQ"]
];


(* ::Subsubsection::Closed:: *)
(*freezeCellsPreviewGenerator*)


DefineOptions[freezeCellsPreviewGenerator,
	Options:>{
		CacheOption
	}
];

Authors[freezeCellsPreviewGenerator]:={"eunbin.go", "jihan.kim", "gokay.yamankurt"};

freezeCellsPreviewGenerator[myInput:{_Rule..},myOptions:OptionsPattern[freezeCellsPreviewGenerator]]:=Module[
	{
		safeOps,cache,freezingMethods,freezingProfiles,durations,residualTemperatures,freezingConditions,freezingTemperatures,batchNames,points,axisEndpoints
	},
	
	(* Get our cache *)
	safeOps=SafeOptions[freezeCellsPreviewGenerator,ToList[myOptions]];
	cache=Lookup[safeOps,Cache];
	
	(* Get the relevant options for plotting *)
	{freezingMethods,freezingProfiles,durations,residualTemperatures,freezingConditions}=Lookup[myInput,{FreezingMethods,FreezingProfiles,Durations,ResidualTemperatures,FreezingConditions}];
	
	(* Convert freezing conditions to a temperature *)
	freezingTemperatures=Switch[#,
		Null,Null,
		Freezer,Unitless[Lookup[Lookup[$StorageConditions,Freezer],Temperature]],
		DeepFreezer,Unitless[Lookup[Lookup[$StorageConditions,DeepFreezer],Temperature]]
	]&/@freezingConditions;
	
	(* Create batch names *)
	batchNames=Table["Batch "<>ToString[i],{i,1,Length[freezingMethods]}];
	
	(* Calculate the important points for each batch *)
	points=MapThread[
		Function[
			{method,freezingProfile,duration,residualTemperature,freezingTemperature},
			Which[
				
				(* If method is controlled rate freezer and we have a freezing profile, remove the units from the freezing profile and flip the order from {temperature,time} to {time,temperature} *)
				MatchQ[method,ControlledRateFreezer]&&!NullQ[freezingProfile],{Unitless[Last[#]],Unitless[First[#]]}&/@freezingProfile,
				
				(* If method is controlled rate freezer without a freezing profile, it's a constant rate method so calculate points based on residual temperature,and duration*)
				MatchQ[method,ControlledRateFreezer],{{0,20},{Unitless[duration],Unitless[residualTemperature]}},
				
				(* If method is insulated cooler, calculate based on a rate is 1 Celsius/minute and the freezing temperature *)
				MatchQ[method,InsulatedCooler],{{0,20},{20-freezingTemperature,freezingTemperature}}
			]
		],
		{freezingMethods,freezingProfiles,durations,residualTemperatures,freezingTemperatures}
	];
	
	(* Calculate axis endpoint *)
	axisEndpoints={Max[First/@#],Min[Last/@#]}&/@points;
	
	(* Create plots *)
	MapThread[
		Function[
			{data,name,endpoints},
			ListLinePlot[
				data,
				PlotLabel->name,
				AxesLabel->{"Time (Minute)","Temperature (Celsius)"},
				PlotRange->{{0,First[endpoints]},{Last[endpoints],20}},
				ImageSize->Large
			]
		],
		{points,batchNames,axisEndpoints}
	]
];


(* ::Subsubsection::Closed:: *)
(*ExperimentFreezeCellsPreview*)


DefineOptions[ExperimentFreezeCellsPreview,
	SharedOptions:>{ExperimentFreezeCells}
];

ExperimentFreezeCellsPreview[myInputs:{ObjectP[{Object[Container],Object[Sample]}]..},myOptions:OptionsPattern[]]:=Module[{listedOptions,noOutputOptions},
	
	(* Get the options as a list *)
	listedOptions=ToList[myOptions];
	
	(* Remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptions,Output->_];
	
	(* Return only the options for ExperimentCrossFlowFiltration *)
	ExperimentFreezeCells[myInputs,Append[noOutputOptions,Output->Preview]]

];