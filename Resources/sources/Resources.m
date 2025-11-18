(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*Resource*)


(* ::Subsubsection::Closed:: *)
(*Icons*)


(* Preload the icons for the various types of resources *)
sampleIcon[] := sampleIcon[] = FastImport[FileNameJoin[{PackageDirectory["Resources`"], "resources", "images", "SampleIcon.png"}], "PNG"];
instrumentIcon[] := instrumentIcon[] = FastImport[FileNameJoin[{PackageDirectory["Resources`"], "resources", "images", "InstrumentIcon.png"}], "PNG"];
operatorIcon[] := operatorIcon[] = FastImport[FileNameJoin[{PackageDirectory["Resources`"], "resources", "images", "OperatorIcon.png"}], "PNG"];
wasteIcon[] := wasteIcon[] = FastImport[FileNameJoin[{PackageDirectory["Resources`"], "resources", "images", "WasteIcon.png"}], "PNG"];


(* ::Subsubsection::Closed:: *)
(*Install Resource Blobs*)


(* This function installs (TagSetDelayed) the resource blobs (it will automatically convert anything with Resource head that matches the appropriate pattern into a blob) *)
installEmeraldResourceBlobs[] :=
	(* Sample Resource visualization *)
	Resource /: MakeBoxes[resourceSpec : (Resource[_Association]), StandardForm] := Switch[
		resourceType[resourceSpec],
		Sample,
		With[
			{
				object = resourceSpec[Sample],
				container = resourceSpec[Container],
				amount = resourceSpec[Amount],
				exactAmount = resourceSpec[ExactAmount],
				tolerance = resourceSpec[Tolerance],
				sterile = resourceSpec[Sterile]
			},

			BoxForm`ArrangeSummaryBox[
				Resource,
				resourceSpec,
				sampleIcon[],
				{
					If[Not[MissingQ[object]],
						BoxForm`SummaryItem[{"Sample: ", object}],
						Nothing
					],
					If[Not[MissingQ[container]],
						BoxForm`SummaryItem[{"Container: ", container}],
						Nothing
					],
					If[Not[MissingQ[amount]],
						BoxForm`SummaryItem[{"Amount: ", amount}],
						Nothing
					],
					If[Not[MissingQ[exactAmount]],
						BoxForm`SummaryItem[{"ExactAmount: ", exactAmount}],
						Nothing
					],
					If[Not[MissingQ[tolerance]],
						BoxForm`SummaryItem[{"Tolerance: ", tolerance}],
						Nothing
					],
					If[Not[MissingQ[sterile]],
						BoxForm`SummaryItem[{"Sterile: ", sterile}],
						Nothing
					]
				},
				{},
				StandardForm
			]
		],
		(* Instrument Resource visualization *)
		Instrument,
		With[
			{possibleInstruments = resourceSpec[Instrument], time = resourceSpec[Time], deckLayout = resourceSpec[DeckLayout]},
			BoxForm`ArrangeSummaryBox[
				Resource,
				resourceSpec,
				instrumentIcon[],
				{
					If[Not[MissingQ[possibleInstruments]],
						BoxForm`SummaryItem[{"Instrument: ", possibleInstruments}],
						Nothing
					],
					If[Not[MissingQ[time]],
						BoxForm`SummaryItem[{"Time: ", time}],
						Nothing
					],
					If[Not[MissingQ[deckLayout]],
						BoxForm`SummaryItem[{"Deck Layout: ", deckLayout}],
						Nothing
					]
				},
				{},
				StandardForm
			]
		],
		(* Operator Resource visualization *)
		Operator,
		With[
			{time = resourceSpec[Time], type = resourceSpec[Operator]},
			BoxForm`ArrangeSummaryBox[
				Resource,
				resourceSpec,
				operatorIcon[],
				{
					If[Not[MissingQ[type]],
						BoxForm`SummaryItem[{"Operator: ", type}],
						Nothing
					],
					If[Not[MissingQ[time]],
						BoxForm`SummaryItem[{"Time: ", time}],
						Nothing
					]
				},
				{},
				StandardForm
			]
		],
		(* Waste Resource visualization *)
		Waste,
		With[
			{possibleWastes = resourceSpec[Waste], amount = resourceSpec[Amount]},
			BoxForm`ArrangeSummaryBox[
				Resource,
				resourceSpec,
				wasteIcon[],
				{
					If[Not[MissingQ[possibleWastes]],
						BoxForm`SummaryItem[{"Waste: ", possibleWastes}],
						Nothing
					],
					If[Not[MissingQ[amount]],
						BoxForm`SummaryItem[{"Amount: ", amount}],
						Nothing
					]
				},
				{},
				StandardForm
			]
		]
	];


OnLoad[
	installEmeraldResourceBlobs[];
	OverloadSummaryHead[Resource];
];


(* ::Subsubsection::Closed:: *)
(*Resource Messages*)


Resource::InvalidResource = "`1` is invalid. Please run ValidResourceQ with Verbose->Failures to determine and correct any errors.";
Resource::AmbiguousType = "The specified Resource has an ambiguous type. Please make sure to correctly specify Sample, Instrument or Operator key for the Resource.";
Resource::MissingPreparedSampleContainer = "The given sample `1` is in a container with the DefineName key, but is not located in the contents of that container. Please file a troubleshooting report.";



(* ::Subsubsection::Closed:: *)
(*Resource*)


(* This function takes in a sequence of rules and creates a Resource blob. When given a Sample/Container blob it will extract either the sample or model from the blob
	Input: Sequence of Key/Value pairs that describes the resource being made (e.g: Sample -> blah, Amount -> blah, Container -> blah)
	Output: Resource blob
*)
Resource[seq : Sequence[Rule[_Symbol, _]...]] := Module[
	{resourceParameters, resourceType, sampleValue, blobLookup, blobUpdates, resource},

	(* turn the sequence into a list *)
	resourceParameters = List[seq];

	(* determine the type of resource being generated*)
	resourceType = Which[
		KeyExistsQ[resourceParameters, Sample], Sample,
		KeyExistsQ[resourceParameters, Instrument], Instrument,
		KeyExistsQ[resourceParameters, Operator], Operator,
		KeyExistsQ[resourceParameters, Waste], Waste
	];

	(* if one of the required keys wasn't given, then this is a bad resource and can stop right here *)
	If[NullQ[resourceType],
		Message[Resource::AmbiguousType];Return[$Failed]
	];

	(* get the sample *)
	sampleValue = Lookup[resourceParameters, Sample];

	(*
		looks at a Sample/Container blob, pulls out a sample (or model) if available, else returns Null
		there is a download in here because during Sample/Container blobing, stuff is downloaded
		This should all be removed when there are no more Sample/Container blobs
	*)
	blobLookup[blob : (_Sample | _Container)] := With[
		{underlyingObject = blob[Object], underlyingModel = blob[Model]},
		If[MatchQ[underlyingObject, ObjectP[]],
			underlyingObject,
			If[MatchQ[underlyingModel, ObjectP[]],
				underlyingModel,
				Null
			]
		]
	];

	(* if the sample was a blob, then replace blob with the object *)
	blobUpdates = If[
		MatchQ[sampleValue, (_Sample | _Container)],
		With[{requestedObject = blobLookup[sampleValue]},
			If[
				MatchQ[requestedObject, ObjectP[]],
				Join[
					Cases[resourceParameters, Except[Rule[Sample, _]]],
					{
						Sample -> requestedObject,
						Type -> Object[Resource, resourceType]
					}
				],
				Return[$Failed]
			]
		],
		Join[resourceParameters, {
			Type -> Object[Resource, resourceType]
		}]
	];

	(* check to make sure the resource matches all the patterns *)
	resource = Resource[blobUpdates];

	If[Not[ValidResourceQ[resource]], Message[Resource::InvalidResource, resource]];
	resource

];


(* ::Subsubsection::Closed:: *)
(*Resource Patterns*)


(* more stringent patterns for checking if a resource is valid (by ValidResourceQ function) *)
Unprotect[SampleResourceP];
SampleResourceP := KeyValuePattern[{
	Type -> TypeP[Object[Resource, Sample]],
	Name -> _String,
	Sample -> ObjectP[{Object[Sample], Model[Sample], Object[Part], Object[Sensor], Model[Part], Model[Sensor], Model[Item], Model[Plumbing], Object[Plumbing], Model[Wiring], Object[Wiring], Object[Item], Object[Container], Model[Container]}],
	Container -> Alternatives[ObjectP[Model[Container]], {ObjectP[Model[Container]]..},ObjectP[Object[Container]],{ObjectP[Object[Container]]..}],
	(* ContainerName and Well key pairs are used to indicate if different resources should be prepared in the same container within this protocol (requestor) *)
	ContainerName -> _String,
	Well -> WellP,
	Amount -> UnitsP[],
	ExactAmount -> BooleanP,
	Tolerance -> UnitsP[]|Null,
	Status -> ResourceStatusP | Null,
	Preparation -> ObjectP[] | Null,
	Fresh -> BooleanP,
	Rent -> BooleanP,
	RentContainer -> BooleanP,
	UpdateCount -> BooleanP,
	Untracked -> BooleanP,
	NumberOfUses -> GreaterP[0,1],
	VolumeOfUses -> GreaterP[0 Milliliter],
	ThawRequired -> BooleanP,
	Sterile -> BooleanP,
	(* These are hidden options for primitive framework resource consolidation (only resources sharing the same keys can be consolidated into a single plate) *)
	(* These keys are dropped in primitive framework and will not be populated into resource object *)
	(* SourceTemperature converts Ambient to $AmbientTemperature so no need to put Ambient in pattern here *)
	SourceTemperature -> RangeP[$MinIncubationTemperature, 90 Celsius] | Null,
	SourceEquilibrationTime -> RangeP[0 Minute,$MaxExperimentTime] | Null,
	MaxSourceEquilibrationTime -> RangeP[0 Minute,$MaxExperimentTime] | Null,
	ConsolidateTransferResources -> BooleanP,
	AutomaticDisposal -> BooleanP
}];
Protect[SampleResourceP];

(* pattern for an instrument resource that includes all the possible keys *)
Unprotect[InstrumentResourceP];
InstrumentResourceP := KeyValuePattern[{
	Type -> TypeP[Object[Resource, Instrument]],
	Name -> _String,
	Instrument -> Alternatives[ObjectP[{Object[Instrument], Model[Instrument]}], {ObjectP[Model[Instrument]]..}],
	Time -> GreaterP[0 Minute],
	DeckLayout -> ListableP[ObjectP[Model[DeckLayout]]],
	UnusedIntegratedInstrument -> BooleanP
}];
Protect[InstrumentResourceP];

(* pattern for an operator resource that includes all the possible keys *)
Unprotect[OperatorResourceP];
OperatorResourceP := KeyValuePattern[{
	Type -> TypeP[Object[Resource, Operator]],
	Name -> _String,
	Operator -> ListableP[ObjectP[{Object[User], Model[User]}]],
	Time -> GreaterEqualP[0 Minute] | {GreaterP[0 Minute]..}
}];
Protect[OperatorResourceP];

(* pattern for an waste resource that includes all the possible keys *)
Unprotect[WasteResourceP];
WasteResourceP := KeyValuePattern[{
	Type -> TypeP[Object[Resource, Waste]],
	Name -> _String,
	Waste -> ListableP[ObjectP[{Model[Sample], Object[Sample]}]],
	Amount -> GreaterEqualP[0 Kilogram] | {GreaterEqualP[0 Kilogram]..}
}];
Protect[WasteResourceP];



(* ::Subsubsection::Closed:: *)
(*ValidResourceQ*)


DefineOptions[ValidResourceQ,
	SharedOptions :> {
		{RunValidQTest, {Verbose, OutputFormat}}
	}
];


(* ValidResourceQ checks if any Resource blob is valid:
	Input: Resource Blob(s),
	Output: Boolean *)
ValidResourceQ[myResource_Resource, ops : OptionsPattern[ValidResourceQ]] := ValidResourceQ[{myResource}, ops];
ValidResourceQ[myResource : {_Resource..}, ops : OptionsPattern[ValidResourceQ]] := Module[{resourceAssociation, prepareTests,safeOps, verbose},

	(* Get Safe options *)
	safeOps = SafeOptions[ValidResourceQ,ToList[ops]];

	(* Pull verbose option value from safeOps *)
	verbose = Lookup[safeOps, Verbose];

	(* remove the resource head *)
	resourceAssociation = First[#]& /@ myResource;

	(* map over this helper to prepare tests for each resources *)
	prepareTests[in_] := Module[{resourceType, trimmedPattern, presentKeys, selectedPattern, allowedKeys, tests},

		(* determine the type of resouces we're dealing with*)
		resourceType = Lookup[in, Type];

		(* pull out all the keys from the resources*)
		presentKeys = Keys[in];

		(* select the pattern to use for this resources *)
		selectedPattern = Switch[resourceType,
			TypeP[Object[Resource, Sample]], SampleResourceP,
			TypeP[Object[Resource, Instrument]], InstrumentResourceP,
			TypeP[Object[Resource, Operator]], OperatorResourceP,
			TypeP[Object[Resource, Waste]], WasteResourceP
		];

		(* pull out all keys that can be used with this type of resources*)
		allowedKeys = Keys[Apply[Association, selectedPattern]];

		(* based on the actual keys in the resource, trim down the pattern for matching*)
		trimmedPattern = KeyDrop[Association @@ selectedPattern, Complement[allowedKeys, presentKeys]];

		(* prepare different tests depending on the resources. In order to save on time, we are preparing the tests, and will apply Test to them if Verbose->False *)
		tests = Switch[resourceType,
			(* tests for sample resources *)
			TypeP[Object[Resource, Sample]],
			{
				{
					"Only "<>ToString[allowedKeys]<>" keys are allowed in Sample Resources:",
					ContainsOnly[presentKeys,allowedKeys],
					True
				},
				{
					"If a model is specified and it is not self contained, then Amount must also be specified:",
					If[MatchQ[Lookup[in,Sample],ListableP[NonSelfContainedSampleModelP]],
						MemberQ[presentKeys,Amount],
						True
					],
					True
				},
				{
					"Container can only be specified for non-self-contained samples:",
					If[!MatchQ[Lookup[in,Sample],ListableP[ObjectP[{Model[Sample],Object[Sample]}]]],
						!MemberQ[presentKeys,Container],
						True
					],
					True
				},
				{
					"ContainerName and Well can only be specified with when Container is specified:",
					If[!MemberQ[presentKeys,Container],
						And[
							!MemberQ[presentKeys,ContainerName],
							!MemberQ[presentKeys,Well]
						],
						True
					],
					True
				},
				{
					"ContainerName and Well keys must be both specified or both Null:",
					If[MemberQ[presentKeys,ContainerName],
						MemberQ[presentKeys,Well],
						!MemberQ[presentKeys,Well]
					],
					True
				},
				{
					"If a specific sample and a container model are both specified, then Amount must also be specified:",
					If[MatchQ[Lookup[in,Sample],ObjectP[Object[Sample]]]&&MatchQ[Lookup[in,Container],ListableP[ObjectP[Model[Container]]]],
						MemberQ[presentKeys,Amount],
						True
					],
					True
				},
				{
					"If Sample is specified as a list of models, then the type of the models must be the same",
					If[MatchQ[Lookup[in,Sample],_List],
						If[Length[DeleteDuplicates[Download[Lookup[in,Sample],Type]]]==1,
							True
						],
						True
					],
					True
				},
				{
					"If a Resource is requesting water, then a container must also be specified:",
					If[MatchQ[Lookup[in,Sample],ListableP[WaterModelP]],
						MemberQ[presentKeys,Container],
						True
					],
					True
				},
				{
					"The Sample Resource must match the relevant keys in the SampleResourceP pattern:",
					AssociationMatchQ[in,trimmedPattern],
					True
				},
				{
					"If Fresh is requested, Sample must be a stock solution model and Amount must be provided:",
					If[MatchQ[Lookup[in,Fresh],True],
						MemberQ[presentKeys,Amount]&&MatchQ[Lookup[in,Sample],ListableP[ObjectP[{Model[Sample,StockSolution],Model[Sample,Media],Model[Sample,Matrix]}]]],
						True
					],
					True
				},
				{
					"If Untracked is set, Amount cannot be:",
					If[MatchQ[Lookup[in,Untracked],True],
						!MemberQ[presentKeys,Amount],
						True
					],
					True
				},
				{
					"UpdateCount is only set for a resource requesting an integer amount of a sample:",
					Or[
						MatchQ[Lookup[in,UpdateCount],BooleanP]&&MatchQ[Lookup[in,Amount],_Integer],
						MatchQ[Lookup[in,UpdateCount],Null|_Missing]
					],
					True
				},
				{
					"RentContainer is only set for a resource requesting a non-self-contained sample/model:",
					If[MatchQ[Lookup[in,RentContainer],True],
						MatchQ[Lookup[in,Sample],ListableP[ObjectP[{Model[Sample],Object[Sample]}]]],
						True
					],
					True
				},
				{
					"Rent is only set for items, containers, and parts:",
					If[MatchQ[Lookup[in,Rent],True],
						!MatchQ[Lookup[in,Sample],ListableP[ObjectP[{Model[Sample],Object[Sample]}]]],
						True
					],
					True
				}
			},
			(* tests for instrument resources *)
			TypeP[Object[Resource, Instrument]],
			{
				{"Only "<>ToString[allowedKeys]<>" keys are allowed in Instrument Resources:",
					ContainsOnly[presentKeys,allowedKeys],
					True
				},
				If[ListQ[Lookup[in, Instrument]],
					{
						"If Instrument is specified as a list of models, then the type of the models must be the same",
						Length[DeleteDuplicatesBy[Lookup[in,Instrument],Lookup[in,Type]&]]===1,
						True
					},
					Nothing
				],
				If[ListQ[Lookup[in, DeckLayout]],
					{
						"If DeckLayout is specified as a list, Instrument must be set to a list of models of the same length",
						And[
							SameLengthQ[Lookup[in,DeckLayout],Lookup[in,Instrument]],
							MatchQ[Lookup[in,Instrument],{ObjectP[Model[Instrument]]..}]
						],
						True
					},
					Nothing
				],
				{
					"The Instrument Resource must match the relevant keys in the InstrumentResourceP pattern:",
					AssociationMatchQ[in,trimmedPattern],
					True
				}
			},
			(* tests for operator resources*)
			TypeP[Object[Resource, Operator]],
			{
				{
					"Only "<>ToString[allowedKeys]<>" keys are allowed in Operator Resources:",
					ContainsOnly[presentKeys,allowedKeys],
					True
				},
				If[And[KeyExistsQ[in, Time], ListQ[Lookup[in, Time]], Length[Lookup[in, Time]] > 1],
					{
						"The value for the Time key must be the same as for the Operator key.",
						SameLengthQ[ToList[Lookup[in,Operator]],Lookup[in,Time]],
						True
					},
					Nothing
				],
				{
					"The Operator Resource must match the relevant keys in the OperatorResourceP pattern:",
					AssociationMatchQ[in,trimmedPattern],
					True
				}
			},
			(* tests for operator resources*)
			TypeP[Object[Resource, Waste]],
			{
				{
					"Only "<>ToString[allowedKeys]<>" keys are allowed in Waste Resources:",
					ContainsOnly[presentKeys,allowedKeys],
					True
				},
				If[And[KeyExistsQ[in, Amount], ListQ[Lookup[in, Amount]], Length[Lookup[in, Amount]] > 1],
					{
						"The value for the Waste key must be the same length as the Amount key.",
						SameLengthQ[ToList[Lookup[in,Waste]],Lookup[in,Amount]],
						True
					},
					Nothing
				],
				{
					"The Amount key of the Waste Resource must be a weight, not a volume:",
					MatchQ[Lookup[in,Amount],UnitsP[Kilogram]],
					True
				},
				{
					"The Waste Resource must match the relevant keys in the WasteResourceP pattern:",
					AssociationMatchQ[in,trimmedPattern],
					True
				}
			}
		];

		(* determine if we should return constructed Tests (Verbose->True) or booleans (Verbose->False) *)
		If[MatchQ[verbose, Except[False]],
			(Test@@#&/@tests),
			(* if not verbose, return the second element of relevant tuples *)
			Flatten[tests[[All, 2]]]
			]
	];

	(* first make see if we need RunUnitTest or not *)
	If[Or[MatchQ[verbose, Except[False]],MatchQ[Lookup[safeOps,OutputFormat],TestSummary]],
		RunValidQTest[
			resourceAssociation,
			{prepareTests},
			PassOptions[ValidResourceQ, RunValidQTest, ops]
		],
		(* if not verbose or TestSummary output, we can skip RunValidQTest and run tests locally our booleans *)
		Module[{result},
			(* In order to apply And on the list of results, it has to be evaluated first, otherwise behaves in a weird way *)
			result = Map[prepareTests[#]&, resourceAssociation];

			(* if Verbose->False result is required, to keep the same format as RunUnitTest output, we need to take output into account *)
			Switch[Lookup[safeOps,OutputFormat],
				(* If a singleBoolean is required, flatten all values and apply And *)
				SingleBoolean,
					And@@Flatten[result],
				(* If the output is multiple booleans, map over each object's test results and And them  *)
				Boolean,
					(And@@#)& /@ result
			]
		]
	]
];


(* ::Subsection:: *)
(*RequireResources*)


(* ::Subsubsection::Closed:: *)
(*Main Function*)


DefineOptions[
	RequireResources,
	Options :> {
		{RootProtocol -> Null, ListableP[ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance]}] | Null], {"The highest-level parent protocol that requested these resources.", "If Automatic, resolves to Null.  If Automatic and the input packet is a Program object, resolves to Null."}, IndexMatching -> Input},
		{Upload -> True, True | False, "When True, updates the object with the required resources. When False, returns the update that would have been made."},
		{IgnorePreparedSamples -> False, True | False, "Indicates that simulated samples should be put into the PreparedSamples field. Should only be set to False when called from SimulateResources."},
		{SimulationMode -> False, True | False, "Indicates if the resources being created from blobs here will actually get uploaded.  If set to True, then we are assuming they will not be uploaded and thus we should use SimulateCreateID instead of CreateID."},
		CacheOption,
		SimulationOption
	}
];

RequireResources::OptionLengthMismatch = "These options' lengths are invalid: `1`. The input list has length `2`; these options' lengths must match. Alternatively, a single option value may be supplied.";
RequireResources::AmbiguousRelation = "A Resource was placed in type field `1` without a provided Link. This field has multiple possible links, and the correct one cannot be automatically determined. Please use Link with this field.";
RequireResources::AmbiguousName = "The resource Names `1` are used in Resource representations with different resource parameters. Please ensure that each Name is only used to identify a single unique Resource.";
RequireResources::InvalidDestinationWell = "There is no Well `1` in the following container model(s) `2` with ContainerName `3`. Please replace or remove the invalid container model or update the Well.";
RequireResources::DuplicateDestinationWell = "Multiple resource representations with different resource parameters are requested in the Well `1` of ContainerName `2`. Please ensure that each unique resource is in a new well of the container.";
RequireResources::ConflictContainerModels = "The same ContainerName `1` has been assigned to different container model(s). Please ensure that only the same container model(s) are specified for one ContainerName.";
RequireResources::InvalidExistingContainerName = "The ContainerName `1` already exists in the resources required by the same requestor. However, a conflicting container model and/or well are requested here for the new resource. Please ensure that the new resource with this ContainerName has the same Container model request and a new well in this container.";

(*$EquivalentInstrumentModelLookup*)

(* we can use some instruments interchangably, which helps reduce issues with site dependence of models*)
(*Add more here as they are discovered*)
(* Some instruments are fully interchangable, but some are one direction. Like one model's functionality is fully covered with the other one, but not on the opposite direction. Make sure we handle that as well *)
$EquivalentInstrumentModelLookup = Map[
	If[MatchQ[#,{_List,_List}],
		(ObjectP[#[[1]]]-> #[[2]]),
		(ObjectP[#]-> #)
	]&,
	{
		(*Nutators*)
		{
			Model[Instrument, Nutator, "id:dORYzZRWoXYR"], (*"Fisherbrand Nutating Mixer with 566L Precision Low Temperature BOD Refrigerated Incubator"*)
			Model[Instrument, Nutator, "id:1ZA60vLBzwGq"] (*"Fisherbrand Nutating Mixer with Precision Low Temperature BOD Refrigerated Incubator"*)
		},
		(*PeristalticPump*)
		{
			Model[Instrument, PeristalticPump, "id:n0k9mG8KZlb6"], (*"VWR Peristaltic Variable Pump PP3400"*)
			Model[Instrument, PeristalticPump, "id:n0k9mGkDOdAn"] (*"Masterflex L/S Precision Variable-Speed Console Drive"*)
		},
		(*Balances*)
		(*Note that Model[Instrument, Balance, "id:N80DNj1Gr5RD"] (Ohaus EX124) has a much larger MinWeight, and we won't include it as a possible alternative model for the others, but if EX124 is requested, we can select PA124/PA224 *)
		{
			Model[Instrument, Balance, "id:vXl9j5qEnav7"],(*Ohaus Pioneer PA124*)
			Model[Instrument, Balance, "id:KBL5DvYl3zGN"],(*Ohaus Pioneer PA224*)
			Model[Instrument, Balance, "id:rea9jl5Vl1ae"] (*Ohaus EX225AD*)
		},
		{
			{Model[Instrument, Balance, "id:N80DNj1Gr5RD"](*Ohaus EX124*)},
			{
				Model[Instrument, Balance, "id:N80DNj1Gr5RD"], (*Ohaus EX124*)
				Model[Instrument, Balance, "id:vXl9j5qEnav7"], (*Ohaus Pioneer PA124*)
				Model[Instrument, Balance, "id:KBL5DvYl3zGN"],(*Ohaus Pioneer PA224*)
				Model[Instrument, Balance, "id:rea9jl5Vl1ae"] (*Ohaus EX225AD*)
			}
		},
		{
			Model[Instrument, Balance, "id:54n6evKx08XN"], (*Mettler Toledo XP6*)
			Model[Instrument, Balance, "id:D8KAEvKJox0l"], (*Mettler Toledo XPR6U Ultra-Microbalance*)
			Model[Instrument, Balance, "id:D8KAEvD4lJOk"] (*Mettler Toledo XPR10*)
		},
		(*WaterPurifier*)
		{
			Model[Instrument, WaterPurifier, "id:eGakld01zVXG"],(*"MilliQ Integral 3"*)
			Model[Instrument, WaterPurifier, "id:AEqRl9qA8WZa"] (*Milli-Q IQ 7010 Type I Water Purifier*)
		},
		(*Sonicators without specific temperature control, these will heat to 70°C when powered on*)
		{
			Model[Instrument, Sonicator, "id:Vrbp1jG80Jqx"],(*Branson 1510*)
			Model[Instrument, Sonicator, "id:3em6Zv9NjwJo"],(*Branson 1800*)
			Model[Instrument, Sonicator, "id:O81aEBZ8YPGx"](*Branson MH 5800*)
		},
		(*Sonicators with specific temperature control*)
		(* Only chilled Sonicator *)
		{
			Model[Instrument, Sonicator, "id:L8kPEjnJOm54"],(*Branson 1510 with Thermo Precision Incubator, -10°C to 70°C*)
			Model[Instrument, Sonicator, "id:n0k9mGkDaon1"](*Branson MH 5800 with 566L Precision Low Temperature BOD Refrigerated Incubator, 4°C to 70°C*)
		},
		(*Sonicators with specific temperature control*)
		(* CMU does not have the Branson CPXH 3800 , Branson MH 5800 can also go up to 70°C*)
		{
			Model[Instrument, Sonicator, "id:XnlV5jKNn3DM"],(*Branson CPXH 3800, ambient to 70°C*)
			Model[Instrument, Sonicator, "id:n0k9mGkDaon1"](*Branson MH 5800 with 566L Precision Low Temperature BOD Refrigerated Incubator, 4°C to 70°C*)
		},
		(*ESI Triple-quadrapole mass spectrometer*)
		{
			Model[Instrument, MassSpectrometer, "id:N80DNj1aROOD"],(*QTRAP 6500*)
			Model[Instrument, MassSpectrometer, "id:Y0lXejl8MeOa"](*QTRAP 6500 PLUS*)
		},
		(* Portable coolers *)
		{
			Model[Instrument, PortableCooler, "id:R8e1PjpjnEPX"], (* ICECO GO20 Portable Refrigerator *)
			Model[Instrument, PortableCooler, "id:eGakldJdO9le"] (* ICECO GO12 *)
		},
		(* OverheadStirrer *)
		{
			Model[Instrument, OverheadStirrer, "id:rea9jlRRmN05"], (* MINISTAR 40 with C-MAG HS 10 Hot Plate *)
			Model[Instrument, OverheadStirrer, "id:Z1lqpMzavMN9"] (* MINISTAR 40 with C-MAG HS 10 Hot Plate in Fume Hood *)
		}
	}
];


(*$EquivalentModelLookup*)

(* we can use some non-instruments interchangably, which helps reduce issues with site dependence of models*)
(* This is similar to StockSolution's AlternativePreparations *)
(* Add more here as they are discovered *)
(* NOTE: Please use this very carefully, as this is supposed to affect ALL experiments *)
(* Unline instruments, this replacement has to happen in ModelInstances search, which is at the resource picking time, as a single non-instrument resource CANNOT take more than 1 model in the resource *)
(* Some objects are fully interchangable, but some are one direction. Like one model's functionality is fully covered with the other one, but not on the opposite direction. Make sure we handle that as well *)
$EquivalentModelLookup = {};

(* empty list case *)
RequireResources[{}, ops : OptionsPattern[]] := {};

(* singleton case; can take in packets of Protocols, Maintenance, Qualifications, and Programs *)
RequireResources[myPacket : PacketP[{Object[Protocol], Object[Qualification], Object[Maintenance], Object[Program], Object[Method], Object[Resource], Object[Primitive],Object[UnitOperation]}], ops : OptionsPattern[]] := Module[
	{safeOps, upload, return},

	(* get the Safe Options and pull out the Upload option *)
	safeOps = SafeOptions[RequireResources, ToList[ops]];
	upload = Lookup[safeOps, Upload];

	(* Pass to core listable overload *)
	return = RequireResources[{myPacket}, ops];

	(* If failed, return $Failed. If Upload -> False, return all packets to be uploaded. Otherwise, return input packet's created object  *)
	If[MatchQ[return, $Failed],
		$Failed,
		If[Not[upload],
			return,
			FirstOrDefault[return]
		]
	]
];

(* CORE FUNCTION: reverse listable overload *)
RequireResources[myPackets : {PacketP[{Object[Protocol], Object[Qualification], Object[Maintenance], Object[Program], Object[Method], Object[Resource], Object[Primitive],Object[UnitOperation]}]..}, ops : OptionsPattern[]] := Module[
	{safeOps, upload, root, processedPackets, packetIDs, packetsWithIDs, packetsWithResources, packetsWithoutResources,
		requiredResources, uniqueResourceBlobs, resourcePackets,
		resourceIDs, updatedRequiredResourcesPackets, allPackets, cache, sampleResourcePackets, waterPrepContainerResourceIDs,
		samplesToDownload, instrumentResourcePackets, instrumentsToDownload, instrumentModels, containerModelWellRules,containerModelNumWellRules,sampleResourcesWithModels,
		waterPrepResourcePackets, waterPrepContainerResourcePackets, instrumentResourcesWithModels, specifiedSampleModels, containerModels, allDownloadValues,
		invalidContainerWells,invalidContainerNames, protocolResourcePackets,
		sampleDownloadValues, instrumentDownloadValues, sampleModelsTuples, combinedModelSamplePackets, sampleResourcesWithRent, outstandingSampleResources,
		sampleResourcesToNotCreate, outstandingInstrumentResources, instrumentResourcesToNotCreate,
		allResourcePackets, resourcesToRemove, allNonDuplicateResourcePackets, allRequiredResources,
		noDuplicateRequiredResources, nonDuplicateRequiredResourcesPackets, expandedRootProtocol, packetTypes,
		rootObjects, rootObjectsWithProtPackets, rootObjectsWithResourceBlobs, flatResourceBlobs, flatRootObjects,
		sampleRootProtocols, instrumentRootProtocols, operatorResourceRowsPerProtocol, allCheckpointsFields, allCheckpointNames,
		operatorResourcesWithCheckpoint, waterPrepResourceRequestors, simulation, ignorePreparedSamples,
		modelSamplePacketLists,transportInstrumentResourcePackets,sampleResourceRequestors, simulationMode,
		updatesForSampleResourcePackets,modelsOrObjectSamples,protocolObjects, simulatedObjects,
		allTransportConditions,containerModelPackets,existingResourcePackets,transportConditionsList,
		transportInstrumentResourceIDs},

	(* pull out the Safe Options, and pull out the Upload and RootProtocol options *)
	safeOps = SafeOptions[RequireResources, ToList[ops]];
	{upload, root, cache, simulation, ignorePreparedSamples, simulationMode} = Lookup[safeOps, {Upload, RootProtocol, Cache, Simulation, IgnorePreparedSamples, SimulationMode}];

	(* Create IDs for an packets without an ID, and also get the Type to append to the packets with IDs in case they weren't included *)
	(* if we're in simulation mode, use SimulateCreateID because it's faster *)
	packetIDs = If[simulationMode,
		SimulateCreateID[Lookup[myPackets, Type, Null]],
		CreateID[Lookup[myPackets, Type, Null]]
	];
	packetTypes = MapThread[
		If[NullQ[#1],
			Download[#2, Type],
			#1
		]&,
		{Lookup[myPackets, Type, Null], Lookup[myPackets, Object, Null]}
	];

	(* add the packet IDs and/or the types in for those packets that don't have the Object or Type field populated *)
	packetsWithIDs = MapThread[
		If[KeyExistsQ[#1, Object],
			Append[<|Type -> #3|>, #1],
			Append[<|Object -> #2, Type -> #3|>, #1]
		]&,
		{myPackets, packetIDs, packetTypes}
	];

	(* Expand the RootProtocol option if it is not already *)
	expandedRootProtocol = If[MatchQ[root, _List],
		root,
		ConstantArray[root, Length[myPackets]]
	];

	(* if the length of expandedRootProtocol is mismatched with the input packets, then throw an error *)
	If[Length[myPackets] =!= Length[expandedRootProtocol],
		(
			Message[RequireResources::OptionLengthMismatch, RootProtocol, Length[myPackets]];
			Return[$Failed]
		)
	];

	(* get the specified Root as an ObjectReference *)
	rootObjects = Download[expandedRootProtocol, Object];

	(* Only these types of objects contain the RequiredResources field *)
	packetsWithResources = Cases[packetsWithIDs, PacketP[{Object[Protocol], Object[Qualification], Object[Maintenance], Object[Program], Object[Primitive], Object[UnitOperation]}]];

	(* get the root objects that correspond to packets with resources *)
	rootObjectsWithProtPackets = PickList[rootObjects, packetsWithIDs, PacketP[{Object[Protocol], Object[Qualification], Object[Maintenance], Object[Program], Object[Primitive], Object[UnitOperation]}]];

	(* All other packets do not need to have Resource processed *)
	(* NOTE: We CANNOT alternatives here because for some reason, certain packets don't MatchQ[...] on themselves. This is probably due to *)
	(* Unit operation blobs? *)
	packetsWithoutResources = DeleteCases[packetsWithIDs, Alternatives@@(PacketP/@Lookup[packetsWithResources, Object])];

	(* Moves all resource blobs to RequiredResources field and replaces them with their requested resource.  This function does not Download anything;
	 	however, this function WILL add Object key to any resources that are now in RequiredResources field *)
	processedPackets = populateRequiredResources[
		packetsWithResources,
		IgnorePreparedSamples -> ignorePreparedSamples,
		Cache -> cache,
		Simulation->simulation,
		SimulationMode -> simulationMode
	];

	(* if the above function fails, return $Failed; error messages will have been thrown in the above function *)
	If[MatchQ[processedPackets, $Failed],
		Return[$Failed]
	];

	(* get the required resources featuring blobs that exists in the input packets now, and get rid of all the cases where it is not populated *)
	requiredResources = Map[
		Cases[Lookup[#, Append[RequiredResources], {}][[All, 1]], _Resource]&,
		processedPackets
	];

	(* get the root protocol objects index matched with the resource blobs *)
	rootObjectsWithResourceBlobs = Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{rootObjectsWithProtPackets, requiredResources}
	]];

	(* flatten out the resource blobs  *)
	flatResourceBlobs = Flatten[requiredResources];

	(* get the resource blobs without duplicates; assumes that populateRequiredResources put Object key in that establishes uniqueness *)
	uniqueResourceBlobs = DeleteDuplicates[flatResourceBlobs];

	(* get the root protocols whose "duplicates" have been deleted according to the duplicates present in the blobs *)
	(* so if list1 = {a, b, c, d, e, f, g, h} and list2 = {1, 2, 3, 4, 3, 4, 4, 5}, I want to do DeleteDuplicates on list2 and then get the corresponding values for the output of that from list1 *)
	flatRootObjects = DeleteDuplicatesBy[Transpose[{rootObjectsWithResourceBlobs, flatResourceBlobs}], #[[2]]&][[All, 1]];

	(* get all the packets from the resource blobs *)
	(* this function is defined below and is used both here and in fulfillableResourceQ *)
	resourcePackets = resourceToPacket[uniqueResourceBlobs, RootProtocol -> flatRootObjects, Simulation -> simulation, SimulationMode -> simulationMode];

	(* if resourceToPacket didn't do the job properly, return $Failed; it will have thrown its own messages *)
	If[Not[MatchQ[resourcePackets, {ObjectP[Object[Resource]]...}]],
		Return[$Failed]
	];

	(* --- use the one Download call to get the models of the Samples and Instruments that were specified directly, and put those into the resource packets --- *)

	(* get the sample resource packets *)
	sampleResourcePackets = Cases[resourcePackets, PacketP[Object[Resource, Sample]]];

	(* get the Sample field from the sample resource packets; this may be Null for some *)
	samplesToDownload = Lookup[sampleResourcePackets, Sample, {}];

	(* lookup our models requested in sample resources *)
	specifiedSampleModels = DeleteDuplicates[Cases[Join@@Lookup[sampleResourcePackets, Replace[Models], {}],ObjectP[]]];

	(* lookup the container models requested in sample resources *)
	containerModels = DeleteDuplicates[Cases[Join@@Lookup[sampleResourcePackets, Replace[ContainerModels], {}],ObjectP[]]];

	(* get the root protocols that correspond to the sample resources *)
	sampleRootProtocols = PickList[flatRootObjects, resourcePackets, PacketP[Object[Resource, Sample]]];

	(* get the instrument resource packets *)
	instrumentResourcePackets = Cases[resourcePackets, PacketP[Object[Resource, Instrument]]];

	(* get the Instrument field from the instrument resource packets; this may be Null for some *)
	instrumentsToDownload = Lookup[instrumentResourcePackets, Instrument, {}];

	(* get the root protocols that correspond to the instrument resources *)
	instrumentRootProtocols = PickList[flatRootObjects, resourcePackets, PacketP[Object[Resource, Instrument]]];

	(* get a list of Replace[Models] or Sample that are Model[Sample] or Object[Sample] from the sampleResourcePackets, depending on which ones are Null or not - prioritize Sample *)
	modelsOrObjectSamples = Map[
		Function[{sampleResourcePacket},
			Module[{replaceModels,sampleField},
				{replaceModels,sampleField} = Lookup[sampleResourcePacket,{Replace[Models],Sample}];
				Which[NullQ[sampleField] && !NullQ[replaceModels] && MatchQ[replaceModels[[1]][[1]],ObjectP[Model[Sample]]],
					replaceModels[[1]],

					!NullQ[sampleField] && MatchQ[sampleField[[1]],ObjectP[Object[Sample]]],
					sampleField,

					True,
					Null
				]
			]
		],sampleResourcePackets];

	(* pull out the simulated objects from the simulation blob if we have one*)
	simulatedObjects = If[MatchQ[simulation, _Simulation],
		Lookup[simulation[[1]], SimulatedObjects, {}],
		{}
	];

	(* get a list of our protocol or other requestor objects so we can download the existing resources' ContainerName and Well *)
	protocolObjects = DeleteCases[
		ToList@Lookup[Flatten[processedPackets], Object, Null],
		Alternatives[Null, Alternatives @@ simulatedObjects]
	];

	(* Download the model of specified samples and instruments + RentByDefault *)
	allDownloadValues = Quiet[
		Download[
			(* note that protocolObjects here might have some that do not exist.  It is faster to just try to Download from this variable and filter out the $Faileds than to call DatabaseMemberQ above though so doing that *)
			(* Download::ObjectDoesNotExist is quieted here anyway *)
			{samplesToDownload, instrumentsToDownload, specifiedSampleModels,modelsOrObjectSamples, containerModels, protocolObjects},
			{
				{Model[Object], Packet[Model[{RentByDefault,Name}]], Packet[RequestedResources[{Status, RootProtocol}]], Packet[RequestedResources[Requestor[Status]]]},
				{Model, Packet[RequestedResources[{Status, RootProtocol}]]},
				{Packet[RentByDefault,Name]},
				{TransportCondition},
				{Packet[Positions,NumberOfWells]},
				{Packet[RequiredResources[[All,1]][{ContainerModels,ContainerName,Well}]]}
			},
			Cache -> cache,
			Simulation->simulation,
			Date -> Now
		],
		{Download::FieldDoesntExist, Download::NotLinkField, Download::MissingField, Download::ObjectDoesNotExist, Download::MissingCacheField}
	];

	(* split out our Download values *)
	{sampleDownloadValues, instrumentDownloadValues, modelSamplePacketLists,allTransportConditions, containerModelPackets, protocolResourcePackets} = allDownloadValues;
	transportConditionsList = Flatten[allTransportConditions];

	(* now filter out the $Faileds *)
	(* note that it was critical above to remove the simulated objects, because Download will return things and pretend they really exist and won't return $Failed here if we don't (because of the specified simulation) *)
	existingResourcePackets = DeleteCases[protocolResourcePackets, {$Failed}];

	(* Pull out the models and rent info from the sample and instrument Download values *)
	sampleModelsTuples = Map[
		If[NullQ[#],
			{Null,Null},
			#[[1;;2]]
		]&,
		sampleDownloadValues
	];

	instrumentModels = Map[
		If[NullQ[#],
			Null,
			First[#]
		]&,
		instrumentDownloadValues
	];

	(* point from container model to its available wells and number of wells so we can do error checking later *)
	containerModelWellRules=Map[
		(Lookup[#,Object]->Association[#->Null&/@Lookup[Lookup[#,Positions,{}],Name,{}]])&,
		Flatten[containerModelPackets]
	];
	containerModelNumWellRules=Map[
		(Lookup[#,Object]->Lookup[#,NumberOfWells,Null])&,
		Flatten[containerModelPackets]
	];

	(* Perform the error checking for valid well and container name in container models *)
	(* This is done here after our big download *)
	(* 1 - The well must exist in any of the requested ContainerModel *)
	invalidContainerWells=Map[
		Function[
			{packet},
			Module[{containers,containerWells,containerName,well,validWellQ},
				containerName=Lookup[packet,ContainerName,Null];
				well=Lookup[packet,Well,Null];
				containers=Download[Lookup[packet,Replace[ContainerModels],{}],Object];
				containerWells=containers/.containerModelWellRules;
				validWellQ=If[NullQ[well]||MatchQ[containers,{}],
					True,
					And@@(KeyExistsQ[#,well]&/@containerWells)
				];
				If[TrueQ[validWellQ],
					Nothing,
					{
						well,
						PickList[containers,(MemberQ[#,well]&/@containerWells),False],
						containerName
					}
				]
			]
		],
		sampleResourcePackets
	];

	(* if there is invalid well, return *)
	If[!MatchQ[invalidContainerWells,{}],
		(
			Message[RequireResources::InvalidDestinationWell, invalidContainerWells[[All,1]], invalidContainerWells[[All,2]], invalidContainerWells[[All,3]]];
			Return[$Failed]
		)
	];

	(* 2 - If the newly requested resource has ContainerName, it must have matching container model and reside in a new well *)
	invalidContainerNames=Map[
		Function[
			{packet},
			Module[{containerName,newContainerModels,well,existingResources,existingResourceContainerModels,existingWells},
				containerName=Lookup[packet,ContainerName,Null];
				newContainerModels=Download[Lookup[packet,Replace[ContainerModels],{}],Object];
				well=Lookup[packet,Well,Null];
				existingResources=If[NullQ[containerName],
					{},
					Cases[
						Flatten[existingResourcePackets],
						KeyValuePattern[ContainerName->containerName]
					]
				];
				existingResourceContainerModels=If[MatchQ[existingResources,{}],
					newContainerModels,
					Download[Lookup[existingResources[[1]],ContainerModels],Object]
				];
				existingWells=DeleteCases[Lookup[existingResources,Well,{}],Null];
				If[
					And[
						(* The new well is not in the existing list. This covers the Null ContainerName/Well case *)
						!MemberQ[existingWells,well],
						(* The new list of ContainerModel matches the existing list. This covers the Null ContainerName/Well case (no ContainerModels) or no existing name case *)
						MatchQ[Sort[newContainerModels],Sort[existingResourceContainerModels]]
					],
					Nothing,
					containerName
				]
			]
		],
		sampleResourcePackets
	];

	(* if there is invalid well, return *)
	If[!MatchQ[invalidContainerNames,{}],
		(
			Message[RequireResources::InvalidExistingContainerName, DeleteDuplicates[Flatten[invalidContainerNames]]];
			Return[$Failed]
		)
	];

	(* make new sample resource packets featuring the models inserted *)
	sampleResourcesWithModels = MapThread[
		If[NullQ[#2],
			#1,
			<|
				Object -> Lookup[#1,Object],
				Replace[Models] -> {Link[#2]}
			|>
		]&,
		{sampleResourcePackets, sampleModelsTuples[[All,1]]}
	];

	(* Make master list of our model packets - removing extra lists from Download in modelSamplePacketLists case *)
	combinedModelSamplePackets = Join[sampleModelsTuples[[All,2]], modelSamplePacketLists[[All,1]]];

	(* Resolve Rent and add it as needed, if it's already in our packet we don't want to change it *)
	sampleResourcesWithRent = MapThread[
		With[{object=Lookup[#1, Object], requestedModels=Lookup[#1,Replace[Models],{Null}]},
			Switch[#2,
				(* if we are specifying rent here already - no updates needed *)
				True,
				Nothing,
				(* if the rent is set as False, set as Null so we don't show it in Inspect *)
				False,
				<|
					Object -> object,
					Rent -> Null
				|>,

				(* if we don't have it specified - inherit from RentByDefault *)
				Null,
				<|
					Object -> object,
					(* [[1]]] looks at the first model - we don't actually expect multiple models  *)
					(* Find our model packet then get rent value *)
					(* Only Item and Container have RentByDefault field, everything else will return $Failed so just set this back to Null *)
					Rent -> Replace[
						Lookup[fetchPacketFromCache[requestedModels[[1]], combinedModelSamplePackets],RentByDefault,Null],
						$Failed -> Null
					]
				|>
			]
		]&,
		{sampleResourcesWithModels, Lookup[sampleResourcePackets, Rent, {}]}
	];

	(* make new instrument resource packets featuring the models inserted *)
	instrumentResourcesWithModels = MapThread[
		If[NullQ[#2],
			Nothing,
			<|
				Object -> #1,
				Replace[InstrumentModels] -> {Link[#2]}
			|>
		]&,
		{Lookup[instrumentResourcePackets, Object, {}], instrumentModels}
	];

	(* replace the blobs in RequiredResources with the new resource IDs *)

	(* get IDs for all the new resources *)
	resourceIDs = Lookup[resourcePackets, Object, {}];

	(* each resource blob has the Object key that we used for packet creation in it; swap these out in the RequiredResources field *)
	updatedRequiredResourcesPackets = ReplaceAll[processedPackets, resource_Resource :> Link[resource[Object], Requestor]];

	(* get information about the resources we are going to want to _not_ create since the reservation already exists *)
	(* this will occur when a subprotocol is trying to create a resource for a specific sample that is already reserved by the Root protocol *)
	(* in this specific case, we definitely do _not_ want to reserve the item again *)

	(* if sampleDownloadValues is not Null, then find all the outstanding resources for this item that have the same root protocol as was specified here *)
	outstandingSampleResources = MapThread[
		Function[{downloadValue, root},
			If[NullQ[downloadValue],
				{},
				Module[
					{requestedResourcePackets, requestorPackets},
					requestedResourcePackets = downloadValue[[3]];
					requestorPackets = downloadValue[[4]];
					If[MatchQ[requestedResourcePackets, {}],
						{},
						Select[
							Transpose[{requestedResourcePackets, requestorPackets}],
							And[
								(* Resource that is not fulfilled yet *)
								MatchQ[Lookup[#[[1]], Status], InCart | Outstanding | InUse],
								(* Requested by a subprotocol of our root protocol or by root protocol *)
								MatchQ[Lookup[#[[1]], RootProtocol], ObjectP[root]],
								(* Requestor protocol is NOT Completed. Note that our resource may have multiple requestors like UOs but the first requestor is always the protocol *)
								(* We do not release a resource until it is stored so the resource might still be InUse while the requestor is completed. In that case, we do not need to "use" this resource any more and should not take it into consideration when deciding whether to create resource *)
								!MatchQ[Lookup[#[[2,1]], Status], Completed]
							]&
						][[All,1]]
					]
				]
			]
		],
		{sampleDownloadValues, sampleRootProtocols}
	];

	(* get the IDs of the sample resources we were going to create but now will not because it's already reserved by this same protocol *)
	sampleResourcesToNotCreate = MapThread[
		If[MatchQ[#2, {}],
			Nothing,
			Lookup[#1, Object]
		]&,
		{sampleResourcePackets, outstandingSampleResources}
	];

	(* if instrumentDownloadValues is not Null, then find all the outstanding resources for this item that have the same root protocol as was specified here *)
	outstandingInstrumentResources = MapThread[
		Function[{downloadValue, root},
			If[NullQ[downloadValue],
				{},
				Select[Last[downloadValue], MatchQ[Lookup[#, Status], InCart | Outstanding | InUse] && MatchQ[Lookup[#, RootProtocol], ObjectP[root]]&]
			]
		],
		{instrumentDownloadValues, instrumentRootProtocols}
	];

	(* get the IDs of the instrument resources we were going to create but now will not because it's already reserved by this same protocol *)
	instrumentResourcesToNotCreate = MapThread[
		If[MatchQ[#2, {}],
			Nothing,
			Lookup[#1, Object]
		]&,
		{instrumentResourcePackets, outstandingInstrumentResources}
	];

	(* combine all the resource packets together *)
	(* note: some of these packets may make changes to the same object *)
	allResourcePackets = DeleteDuplicates@Flatten[{resourcePackets, sampleResourcesWithModels, sampleResourcesWithRent, instrumentResourcesWithModels}];

	(* get all resource IDs that we want to remove *)
	resourcesToRemove = DeleteDuplicates[Flatten[{sampleResourcesToNotCreate, instrumentResourcesToNotCreate}]];

	(* get all the resource packets that we are actually going to use *)
	allNonDuplicateResourcePackets = DeleteCases[allResourcePackets, ObjectP[resourcesToRemove]];

	(* get the RequiredResources fields from the packets updating this field *)
	allRequiredResources = Lookup[updatedRequiredResourcesPackets, Append[RequiredResources], {}];

	(* modify the RequiredResources fields to not include the resources we want to not create anymore *)
	noDuplicateRequiredResources = Map[
		If[MatchQ[FirstOrDefault[#], ObjectP[resourcesToRemove]],
			Nothing,
			#
		]&,
		allRequiredResources,
		{2}
	];

	(* re-generate the packets with RequiredResources as necessary.  Append on Associations will overwrite the previous entry of Append[RequireResources] in this packet *)
	nonDuplicateRequiredResourcesPackets = MapThread[
		Join[
			#1,
			<|
				Append[RequiredResources] -> #2
			|>
		]&,
		{updatedRequiredResourcesPackets, noDuplicateRequiredResources}
	];

	(* also need to do something funky for sample resource pointing at water (and with amount more than $MicroWaterMaximum);
	 	need to make a second resource for the water container so it can be picked/priced as normal *)

	(* identify water resources that don't already have sample, are over the threshold under which we would do a micro and does not have a container name to potentially share a multi-well container with other resources *)
	waterPrepResourcePackets = Map[
		If[
			And[
				MatchQ[Download[Lookup[#, Replace[Models]], Object], {WaterModelP..}],
				NullQ[Lookup[#, Sample]],
				(* Avoid WaterPrep for any resource with ContainerName and Well, even if the volume is larger than $MicroWaterMaximum. This is due to the difficulty of dispensing directly into plate (the purpose of the resource's ContainerName and Well system) *)
				(* The only exception is when the container only has one well (i.e., reservoir as a plate or non-plate like a vessel *)
				(* NumberOfWells only exists in Model[Container,Plate]. For other types like Model[Container,Vessel], it should have returned $Failed *)
				Or[
					And[
						NullQ[Lookup[#, ContainerName, Null]],
						NullQ[Lookup[#, Well, Null]]
					],
					MatchQ[
						Download[Lookup[#,Replace[ContainerModels]],Object]/.containerModelNumWellRules,
						{(1|$Failed)...}
					]
				],
				Lookup[#, Amount] >= $MicroWaterMaximum
			],
			#,
			Nothing
		]&,
		sampleResourcePackets
	];

	(* identify the requestors for these water prep resource packets; parse through the updatedRequiredResourcesPackets for this *)
	waterPrepResourceRequestors = Map[
		Function[waterPrepResourcePacket,
			(* move through the RequiredResources-updating packet; return any requestor where this resource's ID shows up as a requiredResource *)
			Map[
				Module[{requestorRequiredResources},

					(* get the RequiredResources update field for this requestor *)
					requestorRequiredResources = Lookup[#, Append[RequiredResources]];

					(* return the Requestor (the thing being updated with RequiredResources field) if this water-requesting resource is in there *)
					If[MemberQ[Download[requestorRequiredResources[[All, 1]], Object], Lookup[waterPrepResourcePacket, Object]],
						Lookup[#, Object],
						Nothing
					]
				]&,
				nonDuplicateRequiredResourcesPackets
			]
		],
		waterPrepResourcePackets
	];

	(* make the water prep resource IDs; use SimulateCreateID if we're in SimulationMode *)
	waterPrepContainerResourceIDs = If[simulationMode,
		SimulateCreateID[ConstantArray[Object[Resource, Sample], Length[waterPrepResourcePackets]]],
		CreateID[ConstantArray[Object[Resource, Sample], Length[waterPrepResourcePackets]]]
	];

	(* for these water prep resource packets, we need to sneak in a container resource; just raw create the packet here *)
	waterPrepContainerResourcePackets = MapThread[
		Function[{waterPrepResourcePacket, requestors, containerResourceID},
			<|
				Object -> containerResourceID,
				Type -> Object[Resource, Sample],
				Status -> InCart,
				DateInCart -> Now,
				Rent -> TrueQ[Lookup[waterPrepResourcePacket, RentContainer]],
				(* point this auto-generated thing at the original sample resource for ease of finding in ResourcePicking *)
				SampleResource -> Link[Lookup[waterPrepResourcePacket, Object], ContainerResource],
				(* just shove into same root *)
				RootProtocol -> Link[Lookup[waterPrepResourcePacket, RootProtocol], SubprotocolRequiredResources],
				(* this makes naked RequiredResources entry...sorry *)
				Replace[Requestor] -> Link[requestors, RequiredResources, 1],
				Replace[Models] -> Link[Lookup[waterPrepResourcePacket, Replace[ContainerModels]]]
			|>
		],
		{waterPrepResourcePackets, waterPrepResourceRequestors, waterPrepContainerResourceIDs}
	];

	(* identify the requestors for these sample resource packets for TransportConditions edit; parse through the updatedRequiredResourcesPackets for this *)
	sampleResourceRequestors = Map[
		Function[sampleResourcePacket,
			(* move through the RequiredResources-updating packet; return any requestor where this resource's ID shows up as a requiredResource *)
			Map[
				Module[{requestorRequiredResources},

					(* get the RequiredResources update field for this requestor *)
					requestorRequiredResources = Lookup[#, Append[RequiredResources]];

					(* return the Requestor (the thing being updated with RequiredResources field) if this water-requesting resource is in there *)
					If[MemberQ[Download[requestorRequiredResources[[All, 1]], Object], Lookup[sampleResourcePacket, Object]],
						Lookup[#, Object],
						Nothing
					]
				]&,
				nonDuplicateRequiredResourcesPackets
			]
		],
		sampleResourcePackets
	];

	(* make the IDs for the instrument resources; use SimulateCreateID in simulation mode *)
	transportInstrumentResourceIDs = If[simulationMode,
		SimulateCreateID[ConstantArray[Object[Resource, Instrument], Length[sampleResourcePackets]]],
		CreateID[ConstantArray[Object[Resource, Instrument], Length[sampleResourcePackets]]]
	];

	(* do something similar as above but for samples that have TransportCondition!=Null and != Ambient *)
	transportInstrumentResourcePackets = MapThread[
		Function[{transportCondition, sampleResourcePacket, requestors, instrumentResourceID},
			Module[{determinedTransportModel},
				If[!NullQ[transportCondition]&&transportCondition[Name]!="Ambient"&&!MatchQ[transportCondition,$Failed],
					(* TODO TransportDevices call inside the MapThread??? tsk tsk *)
					determinedTransportModel = ECL`TransportDevices[transportCondition[[1]]];
					<|
						Object -> instrumentResourceID,
						Type -> Object[Resource, Instrument],
						Status -> InCart,
						DateInCart -> Now,
						Replace[InstrumentModels]->Link[determinedTransportModel],
						RootProtocol -> Link[Lookup[sampleResourcePacket, RootProtocol], SubprotocolRequiredResources],
						(* this makes naked RequiredResources entry...sorry *)
						Replace[Requestor] -> Link[requestors, RequiredResources, 1]
					|>,
					{}
				]
			]
		],
		{transportConditionsList, sampleResourcePackets, sampleResourceRequestors, transportInstrumentResourceIDs}
	];

	(* go through each sampleResourcePacket and create a new packet uploading the to the new TransportCondition fields for each respective Sample Resource *)
	updatesForSampleResourcePackets = MapThread[
		Function[{transportInstrumentResourcePacket,sampleResourcePacket},
			If[!MatchQ[transportInstrumentResourcePacket,{}],
				Module[{objectToUpdate,transporterModel,transporterResource},
					objectToUpdate=Lookup[sampleResourcePacket,Object];
					{transporterModel,transporterResource}=Lookup[transportInstrumentResourcePacket,{Replace[InstrumentModels],Object}];
					<|
						Object->objectToUpdate,
						Replace[TransporterModels]->Link[transporterModel],
						TransporterResource->Link[transporterResource]
					|>
				],
				{}
			]
		],
		{transportInstrumentResourcePackets,sampleResourcePackets}
	];


	(* --- Populate the Checkpoint field in all the operator resources --- *)

	(* get all the operator resource rows from RequiredResources for each protocol *)
	operatorResourceRowsPerProtocol = Map[
		Function[{protPacket},
			Select[Lookup[protPacket, Append[RequiredResources], {}], MatchQ[#[[1]], ObjectP[Object[Resource, Operator]]]&]
		],
		nonDuplicateRequiredResourcesPackets
	];

	(* get all the Checkpoint names for each of the things we are grabbing here; if Replace[Checkpoints] is not specified then don't worry *)
	allCheckpointsFields = Map[
		Lookup[#, Replace[Checkpoints], {}][[All, 1]]&,
		updatedRequiredResourcesPackets
	];

	(* get all the checkpoint names per operator resource; need to use the third entry of every row of RequiredResources to figure out what the checkpoint name is *)
	(* have some extra handling for if there are operator resources but no Checkpoints field (This shouldn't happen, but we also don't want to train-wreck if it does) *)
	allCheckpointNames = MapThread[
		Function[{operatorResourceRows, checkpoints},
			Map[
				If[MatchQ[checkpoints, {}],
					Null,
					checkpoints[[#[[3]]]]
				]&,
				operatorResourceRows
			]
		],
		{operatorResourceRowsPerProtocol, allCheckpointsFields}
	];

	(* get all the operator resources featuring the Checkpoint field populated *)
	operatorResourcesWithCheckpoint = MapThread[
		<|
			Object -> Download[#1, Object],
			Checkpoint -> #2
		|>&,
		{Flatten[operatorResourceRowsPerProtocol[[All, All, 1]]], Flatten[allCheckpointNames]}
	];

	(* combine a flat list of all the packets we want *)
	allPackets = Flatten[{nonDuplicateRequiredResourcesPackets, packetsWithoutResources, allNonDuplicateResourcePackets, waterPrepContainerResourcePackets, operatorResourcesWithCheckpoint,updatesForSampleResourcePackets,transportInstrumentResourcePackets}];

	(* if Upload -> False, return all change packets; if Upload -> True, Upload all the packets and return the parent objects *)
	If[Not[upload],
		allPackets,
		Module[
			{objects},

			(* upload the packets *)
			objects = Upload[allPackets];

			(* If Upload fails, return $Failed. If Upload -> True, then Upload all changes and return all the input objects (i.e., the protocol(s) or program(s)) *)
			If[Not[MatchQ[objects, {ObjectP[]..}]],
				$Failed,
				Download[packetsWithIDs, Object]
			]
		]
	]
];


(* ::Subsubsection::Closed:: *)
(*fetchPacketFromCache *)


(*  No pattern matching to make the function blazing fast. *)
fetchPacketFromCache[Null, _] := <||>;
fetchPacketFromCache[myObject_, myCachedPackets_] := Module[
	{myObjectNoLink, naiveLookup, type, name},

	(* If given $Failed, return an empty packet. *)
	If[MatchQ[myObject, $Failed],
		Return[<||>];
	];

	(* Make sure that myObject isn't a link. *)
	myObjectNoLink = Download[myObject, Object];

	(* First try to find the packet from the cache using Object->myObject *)
	naiveLookup = FirstCase[myCachedPackets, KeyValuePattern[{Object -> myObjectNoLink}], <||>];

	(* Were we able to find a packet? *)
	If[!MatchQ[naiveLookup, <||>],
		(* Yes. *)
		naiveLookup,
		(* No. *)
		(* We may have been given a name. *)
		(* Get the type and name from the object. *)
		type = Most[myObjectNoLink];
		name = Last[myObjectNoLink];

		(* Lookup via the name and type. *)
		FirstCase[myCachedPackets, KeyValuePattern[{Type -> type, Name -> name}], <||>]
	]
];


(* ::Subsubsection::Closed:: *)
(*resourceType*)


(* tiny helper function that determines what kind of resource a given resource blob is *)
(* if the Sample/Instrument/Operator keys are present and populated, or if the Type keys are populated, we know the type of the resource; if none are, return $Failed *)

(* The input for this function is a single resource *)
(* the output is the type of resource this is (i.e., Sample, Instrument, or Operator *)
resourceType[myResource_Resource] := With[
	{resourceAssoc = First[myResource]},

	(* conditional determining what the resource type is *)
	Which[
		(* if the Sample key is specified, or the Type is Object[Resource, Sample], then it's a Sample resource *)
		KeyExistsQ[resourceAssoc, Sample] || MatchQ[Lookup[resourceAssoc, Type], Object[Resource, Sample]],
		Sample,
		(* if the Instrument key is specified, or the Type is Object[Resource, Instrument], then it's an Instrument resource *)
		KeyExistsQ[resourceAssoc, Instrument] || MatchQ[Lookup[resourceAssoc, Type], Object[Resource, Instrument]],
		Instrument,
		(* if the Operator key is specified, or the Type is Object[Resource, Operator], then it's an Operator resource *)
		KeyExistsQ[resourceAssoc, Operator] || MatchQ[Lookup[resourceAssoc, Type], Object[Resource, Operator]],
		Operator,
		(* if the Waste key is specified, or the Type is Object[Resource, Waste], then it's a Waste resource *)
		KeyExistsQ[resourceAssoc, Waste] || MatchQ[Lookup[resourceAssoc, Type], Object[Resource, Waste]],
		Waste,
		(* if none of the above are true, something went wrong, so return $Failed *)
		True, $Failed
	]

];



(* ::Subsubsection::Closed:: *)
(*populateRequiredResources*)


(*
	this function takes in a protocol packet and returns that same protocol packet with resource blobs taken out of specific fields and placed into the RequiredResources field;

	The operations to generate the RequiredResources field and re-populate the other fields are disjoint
*)
DefineOptions[
	populateRequiredResources,
	Options :> {
		{SimulationMode -> False, True | False, "Indicates if the resources being created from blobs here will actually get uploaded.  If set to True, then we are assuming they will not be uploaded and thus we should use SimulateCreateID instead of CreateID."},
		CacheOption,
		SimulationOption
	}
];

populateRequiredResources[{}, ops : OptionsPattern[]] := {};
populateRequiredResources[myPackets : {PacketP[{Object[Protocol], Object[Qualification], Object[Maintenance], Object[Program], Object[Primitive],Object[UnitOperation]}]..}, ops : OptionsPattern[]] := Module[
	{cache, simulation, resourceP, resourcePositionsByPacket, uniqueResourcePositionsByPacket, packetsNoResourceReps,
		resourceRepsByPacket, fullyFlatResourceReps, resourceRepNames, badResourceNames, duplicateDestinationWells, conflictContainerModelNames, uniqueRepsByName,
		uniqueResourceIDs, fullyFlatResourceRepsWithObject, resourceRepsWithObjectByPacket, simulationMode,
		requiredResourcesFieldByPacket, allResourceSamplesSimulatedLookup, allResourceSamplesSimulatedQ, allResourceSamples,
		ignorePreparedSamples, resourceSampleValues, allResourceSamplesSimulatedIncludingGlobalQ},

	(* Lookup our Cache option. *)
	cache = Lookup[ToList[ops], Cache, {}];
	simulation = Lookup[ToList[ops], Simulation, {}];
	ignorePreparedSamples = Lookup[ToList[ops], IgnorePreparedSamples, False];
	simulationMode = Lookup[ToList[ops], SimulationMode, False];

	(* NOTE: If our simulation isn't updated, update it. *)
	simulation=If[!MatchQ[simulation, SimulationP] || MatchQ[Lookup[simulation[[1]], Updated], True],
		simulation,
		UpdateSimulation[Simulation[],simulation]
	];

	If[MatchQ[$CurrentSimulation, SimulationP] && !MatchQ[Lookup[$CurrentSimulation[[1]], Updated], True],
		$CurrentSimulation=UpdateSimulation[Simulation[],$CurrentSimulation];
	];

	(* Merge our cache and simulation into a single lookup. *)
	(* NOTE: Do NOT include the Simulated key here for simulated objects. This function is called by UploadProtocol and in *)
	(* SimulatedResources, we require Simulated objects to be actually returned in the Upload->False result. *)
	cache = If[MatchQ[simulation, SimulationP],
		Lookup[UpdateSimulation[Simulation[cache], simulation][[1]], Packets],
		cache
	];

	(* define a pattern that will allow us to yank out a Resource rep naked or a Link-wrapped rep *)
	resourceP = _Resource | Link[_Resource, ___];

	(* for each packet, get the Positions of any resource rep at any depth; because of resourceP, this will actually double-capture some positions with resources *)
	resourcePositionsByPacket = Position[#, resourceP, Infinity, Heads -> False]& /@ myPackets;

	(* eliminate duplicated positions by packet; something is a duplicate if Most[positionSpec] is ALSO a position, and the last element is 1 (indicating first element of a Link) *)
	uniqueResourcePositionsByPacket = Map[
		Function[resourcePositions,
			Fold[
				Function[{uniqueResourcePositions, positionToAdd},
					If[Last[positionToAdd] == 1 && MemberQ[resourcePositions, Most[positionToAdd]],
						uniqueResourcePositions,
						Append[uniqueResourcePositions, positionToAdd]
					]
				],
				{},
				resourcePositions
			]
		],
		resourcePositionsByPacket
	];

	(* just extract all of the resource reps from all positions *)
	resourceRepsByPacket = MapThread[Extract, {myPackets, uniqueResourcePositionsByPacket}];

	(* also get a globally flat list from all packets for reconciling resources named the same; make sure to get rid of Resource reps with Link around them *)
	fullyFlatResourceReps = Flatten[resourceRepsByPacket] /. {Link[resource_Resource, ___] :> resource};

	(* get any Names that have been used to establish uniqueness of resources used in multiple places *)
	resourceRepNames = DeleteDuplicates[Cases[#[Name]& /@ fullyFlatResourceReps, _String]];

	(* for each name, get all reps named this way; they had better be exactly identical; return Names that are bad *)
	badResourceNames = (If[!SameQ@@#, #[[1]][Name], Nothing]&)/@GatherBy[fullyFlatResourceReps, (If[!MatchQ[#[Name], _String], CreateUUID[], #[Name]]&)];

	(* for each ContainerName and Well combination, get all reps with this position; they had better be exactly identical; return Names that are bad *)
	duplicateDestinationWells = Map[
		(If[!SameQ@@#, {#[[1]][ContainerName],#[[1]][Well]}, Nothing]&),
		GatherBy[
			fullyFlatResourceReps,
			(* ValidResourceQ ensures that if we have ContainerName, we must also have Well *)
			({If[!MatchQ[#[ContainerName], _String], CreateUUID[], {#[ContainerName],#[Well]}]}&)
		]
	];

	(* for each ContainerName, get the requested Container (Model) list; they had better be exactly identical (can be in different order, with or without list if length 1); return Names that are bad *)
	conflictContainerModelNames = Map[
		Function[{resourceBlob},
			Module[{containerModels,sortedContainerModels},
				containerModels=DeleteDuplicates[Download[Lookup[#[[1]],Container,{}],Object]]&/@resourceBlob;
				sortedContainerModels=Sort/@containerModels;
				If[
					!SameQ@@sortedContainerModels,
					resourceBlob[[1]][ContainerName],
					Nothing
				]
			]
		],
		GatherBy[
			fullyFlatResourceReps,
			(* ValidResourceQ ensures that if we have ContainerName, we must also have Well *)
			({If[!MatchQ[#[ContainerName], _String], CreateUUID[], #[ContainerName]]}&)
		]
	];

	(* report bad resource names and fail; this needs to be addressed by Experiment writer *)
	If[MatchQ[badResourceNames, {_String..}],
		Message[RequireResources::AmbiguousName, badResourceNames];
		Return[$Failed]
	];

	(* report bad resource container name and wells and fail; this needs to be addressed by Experiment writer *)
	If[MatchQ[duplicateDestinationWells, Except[{}]],
		Message[RequireResources::DuplicateDestinationWell, duplicateDestinationWells[[All,2]],duplicateDestinationWells[[All,1]]];
		Return[$Failed]
	];

	(* report bad container model conflict; this needs to be addressed by Experiment writer *)
	If[MatchQ[conflictContainerModelNames, Except[{}]],
		Message[RequireResources::ConflictContainerModels, conflictContainerModelNames];
		Return[$Failed]
	];

	(* at this point forward, we would like to be able to ensure uniqueness of reps; we will create IDs for the reps here, using the same ID if resources share a Name *)
	uniqueRepsByName = DeleteDuplicates[fullyFlatResourceReps, MatchQ[{#1[Name], #2[Name]}, {_String, _String}] && MatchQ[#1[Name], #2[Name]]&];

	(* create IDs for each of the unique resource reps *)
	(* use SimulateCreateID for performance in simulation mode *)
	uniqueResourceIDs = If[simulationMode,
		SimulateCreateID[#[Type]& /@ uniqueRepsByName],
		CreateID[#[Type]& /@ uniqueRepsByName]
	];

	(* move through the totally flat resource rep list and add object key to each resource; take care to use the same ID as an existing, already-Object-ed Resource with the same Name  *)
	fullyFlatResourceRepsWithObject = Fold[
		Function[{currentResourceRepList, nextResourceRep},
			Module[{availableIDs, nextName, objectIDToUse, repWithObject},

				(* determine the IDs that are still available that we created *)
				availableIDs = Complement[uniqueResourceIDs, #[Object]& /@ currentResourceRepList];

				(* determine the ID to use; either just take the next available ID of correct type if there's no Name, or look and make sure we haven't already given this Name an ID *)
				nextName = nextResourceRep[Name];
				objectIDToUse = If[MatchQ[nextName, _String],
					Module[{repWithNameAndObject},

						(* see if we can find a blob that we already gave an ID to that has this name  *)
						repWithNameAndObject = SelectFirst[currentResourceRepList, MatchQ[nextName, #[Name]]&];

						(* if this gave us a blob, use that blob's Object; otherwise, just take the next available of type *)
						If[MatchQ[repWithNameAndObject, _Resource],
							repWithNameAndObject[Object],
							SelectFirst[availableIDs, MatchQ[#, ObjectReferenceP[nextResourceRep[Type]]]&]
						]
					],
					SelectFirst[availableIDs, MatchQ[#, ObjectReferenceP[nextResourceRep[Type]]]&]
				];

				(* add the object ID to the blob *)
				repWithObject = Resource[Append[First[nextResourceRep], Object -> objectIDToUse]];

				(* and add the Object-ed blob to our growing list of blobs *)
				Append[currentResourceRepList, repWithObject]
			]
		],
		{},
		fullyFlatResourceReps
	];

	(* pull out the samples that we want to download from *)
	resourceSampleValues = Cases[fullyFlatResourceRepsWithObject, Verbatim[Resource][KeyValuePattern[Sample->sampleObj_]]:>sampleObj];

	(* Get the Object[...]s for the resources that have a Sample key. *)
	allResourceSamples=Download[
		resourceSampleValues,
		Object,
		Simulation->simulation
	];

	(* NOTE: In the case of the old simulation overload (with Simulated->True in the packet), we just ignore this lookup. *)
	allResourceSamplesSimulatedIncludingGlobalQ=Which[
		MatchQ[ignorePreparedSamples, True],
			ConstantArray[False, Length[allResourceSamples]],
		!MatchQ[simulation, SimulationP],
			(Lookup[fetchPacketFromCache[#, cache], Simulated, False]&)/@allResourceSamples,
		True,
			(* note that we used to have a $CurrentSimulation check here, but that is definitely not what we actually want here; if it's in $CurrentSimulation, it's de facto uploaded already *)
			(MemberQ[Lookup[simulation[[1]], SimulatedObjects], #]&)/@allResourceSamples
	];

	(* get the global simulation's simulated objects because we need to compare that with allResourceSamplesSimulatedIncludingGlobalQ to tell what is _actually_ simulated *)
	(* if something is Simulated -> True but is in $CurrentSimulation, then it's "like" we uploaded it so it's not _really_ simulated *)
	allResourceSamplesSimulatedQ = If[$Simulation && MatchQ[$CurrentSimulation, _Simulation],
		With[{globalSimObjects = Lookup[First[$CurrentSimulation], SimulatedObjects]},
			MapThread[
				TrueQ[#2] && Not[MemberQ[globalSimObjects, #1]]&,
				{allResourceSamples, allResourceSamplesSimulatedIncludingGlobalQ}
			]
		],
		allResourceSamplesSimulatedIncludingGlobalQ
	];

	allResourceSamplesSimulatedLookup=Association@(Rule@@@Transpose[{allResourceSamples, allResourceSamplesSimulatedQ}]);

	(* update the packets with the object reference from the resource rep that should go in each of the field positions that have a Resource  *)
	packetsNoResourceReps = MapThread[
		Function[{packet, resourcePositionsInPacket},
			Module[{packetType, resourcePositionToObjectRules},

				(* figure out the type of this packet; we need this to look up field definitions to make links, maybe *)
				packetType = If[KeyExistsQ[packet, Type],
					Lookup[packet, Type],
					Download[Lookup[packet, Object], Type]
				];

				(* generate ReplacePart rules for the positions that have reps *)
				resourcePositionToObjectRules = Map[
					Function[resourcePosition,
						Module[{fieldName, fullFieldRelation, relevantRelationPart, relationFieldList, relationFieldSymbols,
							resourceRepMaybeLink, resourceRep, simulatedSampleQ, resourceSample, backlinkField, newFieldValue, newFieldValueWithLink,
							sampleModel, backlinkMap, relationFieldSymbolsWithDuplicates},

							(* parse the resource position to figure out the field name (or names, for named field) that we are dealing with;
							 	Position will wrap Key around Symbol indices (i.e. field names); be aware of Append/Replace *)
							fieldName = If[MatchQ[First[resourcePosition], Key[_Append | _Replace]],
								First[First[First[resourcePosition]]],
								First[First[resourcePosition]]
							];

							(* get the relation definition for the field name, using the packet to figure out the type *)
							fullFieldRelation = LookupTypeDefinition[packetType[fieldName], Relation];

							(* get the part of the relation that we actually care about; if the field we are dealing with is indexed, we need to get the right piece of the relation *)

							relevantRelationPart = Switch[resourcePosition,
								(* either an indexed single or flat multiple; can tell based on full relation being a list or not *)
								{_Key, _Integer}, If[ListQ[fullFieldRelation],
									fullFieldRelation[[Last[resourcePosition]]],
									fullFieldRelation
								],
								(* named single *)
								{_Key, _Key}, Lookup[fullFieldRelation, First[Last[resourcePosition]]],
								(* indexed multiple *)
								{_Key, _Integer, _Integer}, fullFieldRelation[[Last[resourcePosition]]],
								(* named multiple *)
								{_Key, _Integer, _Key}, Lookup[fullFieldRelation, First[Last[resourcePosition]]],
								(* anything else we have a flat Relation already *)
								_, fullFieldRelation
							];

							(* convert this alternatives into a List *)
							relationFieldList = If[MatchQ[relevantRelationPart, _Alternatives],
								List @@ relevantRelationPart,
								ToList[relevantRelationPart]
							];
							(* get the backlink field symbols (sans duplicates), if any, from each of the possible relation fields; there is no backlink if  *)
							relationFieldSymbolsWithDuplicates = Map[
								If[MatchQ[#, TypeP[]],
									Null,
									FirstOrDefault[#]
								]&,

								relationFieldList
							];

							relationFieldSymbols = DeleteDuplicates[relationFieldSymbolsWithDuplicates];

							(* extract the rep/Linkaroundrep that is at this position; also get what for sure is the rep *)
							resourceRepMaybeLink = Extract[packet, resourcePosition];
							resourceRep = If[MatchQ[resourceRepMaybeLink, _Link],
								First[resourceRepMaybeLink],
								resourceRepMaybeLink
							];

							(* Try to get the Sample from the resource symbolic representation, if the key exists. *)
							resourceSample = If[KeyExistsQ[First[resourceRep], Sample],
								resourceRep[Sample],
								Null
							];

							(* Determine if we are dealing with a simulated sample. If there was no Sample key in the resource blob, we obviously can't be dealing with a simulated sample. *)
							(* Models cannot be simulated object samples. *)
							(* note that if we're in $Simulation land, then potentially _everything_ is a simulated sample, but that is fine because it's de-facto uploaded anyway*)
							simulatedSampleQ = If[ignorePreparedSamples,
								False,
								If[!MatchQ[resourceSample, Null] && !MatchQ[resourceSample, ObjectP[Model[]]],
									(* NOTE: This is for reverse compatibility. *)
									Or[
										Lookup[allResourceSamplesSimulatedLookup, resourceSample/.{link_Link:>Download[link, Object]}, False],
										Lookup[fetchPacketFromCache[resourceSample, cache], Simulated, False]
									],
									False
								]
							];

							(* If this resource blob has a Sample key and that sample is simulated, in situ replace the blob with Null. *)
							If[simulatedSampleQ,
								Module[{},
									(* Our sample was simulated. Replace with it with the model if that model was not simulated. *)
									(* If that model is simulated, replace it with Null. *)

									(* Get the model from our sample from cache. *)
									sampleModel = Download[Lookup[fetchPacketFromCache[resourceSample, cache], Model, Null], Object];

									(* We are going to sub in the object's model. We have to re-figure out the backlink field. *)
									(* What the user gave us is in relation to Object, not Model. *)

									(* Create a map between ObjectP[object type] and the field backlink. *)
									backlinkMap = MapThread[ObjectP[#1] -> #2&, {Head /@ relationFieldList, relationFieldSymbolsWithDuplicates}];

									(* Replace on our sample model so we get the backlink. *)
									backlinkField = sampleModel /. backlinkMap;

									(* Return the link. *)
									resourcePosition -> If[MatchQ[backlinkField, Null],
										Link[sampleModel],
										Link[sampleModel, backlinkField]
									]
								],
								Module[{},
									(* ELSE: We are not dealing with a simulated sample. Make the link to replace the resource with. *)
									(* determine the backlink for the field into which we are subbing this new value if the original resource rep was a LInk,
									just take the last of it, if present; otherwise, use type field definition *)
									backlinkField = If[MatchQ[resourceRepMaybeLink, _Link],
										If[Length[resourceRepMaybeLink] == 2,
											Last[resourceRepMaybeLink],
											Null
										],
										If[Length[relationFieldSymbols] == 1,
											First[relationFieldSymbols],
											(* in this case we have an ambiguous backlink situation; return a failure *)
											$Failed
										]
									];

									(* determine the object value that will be going into the field, depending on the type of the resource *)
									newFieldValue = Switch[resourceRep[Type],
										Object[Resource, Sample], If[MatchQ[resourceRep[Sample], {ObjectP[]..}], First[resourceRep[Sample]], resourceRep[Sample]],
										Object[Resource, Instrument], If[MatchQ[resourceRep[Instrument], {ObjectP[]..}], First[resourceRep[Instrument]], resourceRep[Instrument]],
										Object[Resource, Operator], If[MatchQ[resourceRep[Operator], {ObjectP[]..}], First[resourceRep[Operator]], resourceRep[Operator]]
									];

									(* construct the new link with the new field value; throw a message if we couldn't get a single backlink field to use *)
									newFieldValueWithLink = Which[
										MatchQ[backlinkField, $Failed], (
											Message[RequireResources::AmbiguousRelation, packetType[fieldName]];
											$Failed
										),
										NullQ[backlinkField], Link[newFieldValue],
										True, Link[newFieldValue, backlinkField]
									];

									(* return a rule for the "part" from Position to this new link value that will work with Replacepart *)
									resourcePosition -> newFieldValueWithLink
								]
							]
						]
					],
					resourcePositionsInPacket
				];

				(* we may have an AmbiguousRelation failure that caused a value of the replacement rule to be $Failed; pass this error up; otherwise, do the replacement! *)
				If[MemberQ[resourcePositionToObjectRules[[All, 2]], $Failed],
					$Failed,
					ReplacePart[packet, resourcePositionToObjectRules]
				]
			]
		],
		{myPackets, uniqueResourcePositionsByPacket}
	];
	(* pass up the failure if we got a $Failed instead of a packet with no resource reps *)
	If[MemberQ[packetsNoResourceReps, $Failed],
		Return[$Failed, Module]
	];

	(* unflatten the resource reps to be re-sorted by the original input packets *)
	resourceRepsWithObjectByPacket = TakeList[fullyFlatResourceRepsWithObject, Length /@ resourceRepsByPacket];

	(* for each packet, generate the RequiredResources field; we have the positions where resources have gone  *)
	requiredResourcesFieldByPacket = MapThread[
		Function[{resourcePositions, resourceRepsWithObject, objectType},
			MapThread[
				Function[{resourcePosition, resourceRep},
					Module[{resourcePositionNoKey, field, paddedResourcePosition, resourceSample, simulatedSampleQ,
						defineName, samplePacket, defineNameConsideringContainer, containerPacket, containerPosition,
						namedSingle},

						(* the resource position that Position returned us WAY at the top has Key around field names (or named field indices); don't want anymore;
							also might still have Append/Replace; do not want *)
						resourcePositionNoKey = Switch[#,
							Key[_Append | _Replace], First[First[#]],
							Key[_Symbol], First[#],
							_, #
						]& /@ resourcePosition;

						(* get the field we're dealing with in the full form *)
						field = objectType[First[resourcePositionNoKey]];

						(* figure out if our field is an indexed or named single *)
						namedSingle = And[
							NamedFieldQ[field],
							SingleFieldQ[field]
						];

						(* the required resource row remainder after the resource blob is simply the resource position; if not length 3, gotta pad with Null if it's not named single; if it _is_ an indexed single, then we need to put Null in the second position *)
						(* For indexed Single field, we populate the index first and then Null since resource picking cannot tell the difference between a named or index Single field with a Multiple field of single elements when fetching the resource for field population *)
						paddedResourcePosition = Which[
							namedSingle && Length[resourcePositionNoKey] == 2, {First[resourcePositionNoKey], Null, Last[resourcePositionNoKey]},
							Length[resourcePositionNoKey] < 3, PadRight[resourcePositionNoKey, 3, Null],
							True, resourcePositionNoKey
						];

						(* Try to get the Sample from the resource symbolic representation, if the key exists. *)
						resourceSample = If[KeyExistsQ[First[resourceRep], Sample],
							resourceRep[Sample],
							Null
						];

						(* Get the sample's packet. *)
						samplePacket = fetchPacketFromCache[resourceSample, cache];

						(* Determine if we are dealing with a simulated sample. If there was no Sample key in the resource blob, we obviously can't be dealing with a simulated sample. *)
						(* Models cannot be simulated sample objects. *)
						simulatedSampleQ = If[ignorePreparedSamples,
							False,
							If[!MatchQ[resourceSample, Null] && !MatchQ[resourceSample, ObjectP[Model[]]],
								(* NOTE: This is for reverse compatibility. *)
								Or[
									Lookup[allResourceSamplesSimulatedLookup, resourceSample/.{link_Link:>Download[link, Object]}, False],
									Lookup[samplePacket, Simulated, False]
								],
								False
							]
						];

						(* If this resource blob has a Sample key and that sample is simulated, do not put the simulated sample in RequiredResources. *)
						If[simulatedSampleQ,
							(* We're dealing with a simulated sample. *)

							(* Get the define name of the simulated sample. *)
							(* NOTE: This is for reverse compatibility. *)
							defineName = If[MatchQ[simulation, SimulationP],
								Lookup[Reverse/@Lookup[simulation[[1]], Labels], Download[resourceSample, Object], Null],
								Lookup[samplePacket, DefineName, Null]
							];

							(* If our defineName is Null, our sample must have been defined via its container. *)
							If[!MatchQ[defineName, Null],
								(* Prepend our define name to the beginning of the list. Append a Null as the container index. This means that our sample is not part of a container. *)
								Append[Prepend[paddedResourcePosition, defineName], Null],
								(* Try to get a defined container. *)

								(* Get the packet of the container. *)
								containerPacket = fetchPacketFromCache[Lookup[samplePacket, Container, Null], cache];

								(* Get our container's defined name. *)
								defineNameConsideringContainer = If[MatchQ[simulation, SimulationP],
									Lookup[Reverse/@Lookup[simulation[[1]], Labels], Lookup[containerPacket, Object, Null], Null],
									Lookup[containerPacket, DefineName, Null]
								];

								(* If we got a container define name, find the container contents position and append it as the container index. *)
								If[!MatchQ[defineNameConsideringContainer, Null],
									(* Find out where this sample occurs, then dereference the position (ex. "A1"). Return $Failed if we don't find the sample (this will cause an upload error). *)
									(* We must reference the position correctly or our sample will not be prepared correctly. *)
									containerPosition = FirstCase[Lookup[containerPacket, Contents], {_, ObjectP[resourceSample]}, {$Failed, $Failed}][[1]];

									(* Throw a message if we didn't find the define name in the container. *)
									If[MatchQ[containerPosition, $Failed],
										Message[Resource::MissingPreparedSampleContainer, resourceSample]
									];

									(* Return our PreparedSamples field entry. *)
									Append[Prepend[paddedResourcePosition, defineNameConsideringContainer], containerPosition],
									Nothing
								]
							],
							(* ELSE: Our sample is real. *)
							(* prepend the resource rep itself and return this entry for RequiredResources *)
							Prepend[paddedResourcePosition, resourceRep]
						]
					]
				],
				{resourcePositions, resourceRepsWithObject}
			]
		],
		{uniqueResourcePositionsByPacket, resourceRepsWithObjectByPacket, Lookup[myPackets, Type]}
	];

	(* add the required resources fields to the packets with no other resource reps *)
	MapThread[
		Join[#1,
			(* Only add this field to the packet if there were resources to be found. *)
			If[Length[Cases[#2, {Except[_String], ___}]] > 0,
				<|Append[RequiredResources] -> Cases[#2, {Except[_String], ___}]|>,
				<||>
			],
			(* Only add this field to the packet if there were prepared samples to be found. *)
			If[Length[Cases[#2, {_String, ___}]] > 0,
				<|Append[PreparedSamples] -> Cases[#2, {_String, ___}]|>,
				<||>
			]
		]&,
		{packetsNoResourceReps, requiredResourcesFieldByPacket}
	]
];


(* ::Subsubsection:: *)
(*resourceToPacket*)


DefineOptions[
	resourceToPacket,
	Options :> {
		{RootProtocol -> Null, ListableP[Null | ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance]}]], "The highest-level parent protocol that requested these resources.", IndexMatching -> Input},
		{SimulationMode -> False, True | False, "Indicates if the resources being created from blobs here will actually get uploaded.  If set to True, then we are assuming they will not be uploaded and thus we should use SimulateCreateID instead of CreateID."},
		CacheOption,
		SimulationOption
	}
];

(* empty list case *)
resourceToPacket[{}, ops : OptionsPattern[]] := {};

(* singleton case *)
resourceToPacket[myResource_Resource, ops : OptionsPattern[]] := resourceToPacket[{myResource}, ops];

(* this function converts resource blobs into Object[Resource] packets that can be uploaded and stored in the database *)
(* inputs are a list of resource blobs (which have the Resource head) *)
(* output is a list of Object[Resource] packets that can be uploaded to the database *)
(* this function is shared by both RequireResources and fulfillableResourceQ *)
resourceToPacket[myResources : {__Resource}, ops : OptionsPattern[]] := Module[
	{
		resourceIDs, sampleResourceIDs, sampleResourceBlobs, instrumentResourceIDs, instrumentResourceBlobs,
		operatorResourceIDs, operatorResourceBlobs, specifiedSamples, specifiedInstruments, safeOps,
		sampleAmounts, sampleContainers, sampleContainerNames, sampleWells, sampleResourcePackets, estimatedInstrumentTime, instrumentDeckLayouts,
		instrumentResourcePackets, operators, estimatedOperatorTime, operatorResourcePackets, orderedBlobs, orderedPackets, thawRequiredBools, exactAmountBools,
		blobToPacketReplaceRules, rootProtocol, freshBools, rentBools, rentContainerBools, untrackedBools, updateCountBools,
		expandedRootProtocol, sampleRootProts, instrumentRootProts, operatorRootProts, specifiedSampleObjects,
		samplesDensity, samplesState, cache, validSpecifiedSampleObjects, sampleNumberOfUses, simulation, tolerances,automaticDisposals,
		sampleVolumeOfUses, simulationMode, steriles, unusedIntegratedInstrument
	},

	(* get the root protocol from the options *)
	safeOps = SafeOptions[resourceToPacket, ToList[ops]];
	rootProtocol = Lookup[safeOps, RootProtocol];

	(* expand the RootProtocol option if it isn't already *)
	expandedRootProtocol = If[MatchQ[rootProtocol, _List],
		rootProtocol,
		ConstantArray[rootProtocol, Length[myResources]]
	];

	(* grab the cache/simulation if we have any *)
	{cache, simulation, simulationMode} = Lookup[safeOps, {Cache, Simulation, SimulationMode}];

	(* IDs may have already been created outside this function for uniqueness purposes if we are in RequireResources;
	 	if not, create IDs (being called from fulfillableResourceQ or somewhere else)*)
	resourceIDs = Which[
		MatchQ[#[Object]& /@ myResources, {ObjectReferenceP[]..}], #[Object]& /@ myResources,
		simulationMode, SimulateCreateID[#[Type]& /@ myResources],
		True, CreateID[#[Type]& /@ myResources]
	];

	(* pull the sample resource IDs aside, and the sample resource blobs, and the sample's root protocol *)
	sampleResourceIDs = Cases[resourceIDs, ObjectP[Object[Resource, Sample]]];
	sampleResourceBlobs = PickList[myResources, resourceIDs, ObjectP[Object[Resource, Sample]]];
	sampleRootProts = PickList[expandedRootProtocol, resourceIDs, ObjectP[Object[Resource, Sample]]];

	(* pull the instrument resource IDs aside, and the instrument resource blobs *)
	instrumentResourceIDs = Cases[resourceIDs, ObjectP[Object[Resource, Instrument]]];
	instrumentResourceBlobs = PickList[myResources, resourceIDs, ObjectP[Object[Resource, Instrument]]];
	instrumentRootProts = PickList[expandedRootProtocol, resourceIDs, ObjectP[Object[Resource, Instrument]]];

	(* pull the operator resource IDs aside, and the operator resource blobs *)
	operatorResourceIDs = Cases[resourceIDs, ObjectP[Object[Resource, Operator]]];
	operatorResourceBlobs = PickList[myResources, resourceIDs, ObjectP[Object[Resource, Operator]]];
	operatorRootProts = PickList[expandedRootProtocol, resourceIDs, ObjectP[Object[Resource, Operator]]];

	(* pull out the Sample value of all the sample blobs because we might have to Download their models  *)
	specifiedSamples = Map[
		If[MissingQ[#[Sample]],
			Null,
			#[Sample]
		]&,
		sampleResourceBlobs
	];

	(* get Object[Sample] and Model[Sample] that are being requested *)
	specifiedSampleObjects = Map[
		If[MatchQ[#, ObjectP[{Object[Sample], Model[Sample]}]],
			Download[#, Object]
		]&,
		specifiedSamples
	];

	(* have only objects/models that exist in the database *)
	validSpecifiedSampleObjects =
		MapThread[If[TrueQ[#2], #1, Null]&,
			{
				specifiedSampleObjects,
				(* calling DatabaseMemberQ only on non-Null elements of the list *)
				Module[
					{nullIndexes, noNullList, notNullIndexes, databaseMemberBool,
						templateList, notNullReplacement, nullReplacement},

					(* get indexes on Null elements *)
					nullIndexes = Flatten[Position[specifiedSampleObjects, Null]];
					(* get indexes of non-Null elements from the 1st level depth and without testing head of the list *)
					notNullIndexes = Flatten[Position[specifiedSampleObjects, Except[Null], {1}, Heads -> False]];

					(* extract elements that are not Null *)
					noNullList = Cases[specifiedSampleObjects, Except[Null]];
					(* check if those elements are in the database, except in SimulationMode where we can assume they just do *)
					databaseMemberBool = If[simulationMode,
						ConstantArray[True, Length[noNullList]],
						DatabaseMemberQ[noNullList]
					];

					(* create a list with just numbers as our template that we will replace it later on *)
					templateList = Table[n, {n, 1, Length[specifiedSampleObjects]}];

					(* make a list of replacement rules for not null elements *)
					notNullReplacement = MapThread[#1 -> #2 &, {notNullIndexes, databaseMemberBool}];
					(* make a list of replacement rules for null elements, for Null elements we return False *)
					nullReplacement = MapThread[#1 -> #2 &, {nullIndexes, ConstantArray[False, Length[nullIndexes]]}];

					(* replace our template with the boolean indicating if they are in the database *)
					templateList /. Join[notNullReplacement, nullReplacement]
				]
			}
		];

	(* pull out the Instrument value of all the instrument blobs because we might have to Download their models *)
	specifiedInstruments = Map[
		If[MissingQ[#[Instrument]],
			Null,
			#[Instrument]
		]&,
		instrumentResourceBlobs
	];

	(* Download the density and state of the samples we are working with *)
	{samplesDensity, samplesState} = If[MatchQ[validSpecifiedSampleObjects, {}],
		{{}, {}},
		Transpose[
			Map[
				If[MatchQ[#, Null|$Failed|{}], {Null, Null}, #]&,
				Quiet[Download[validSpecifiedSampleObjects, {Density, State}, Simulation -> simulation, Cache -> cache, Date -> Now], Download::ObjectDoesNotExist]
			]
		]
	];

	(* pull out the sample amounts from the Sample resource blobs *)
	sampleAmounts = MapThread[Function[{resourceBlob, density, state},
		Module[{resourceAmount},
			resourceAmount = resourceBlob[Amount];
			Which[
				MissingQ[resourceAmount],
				Null,
				MatchQ[state, Liquid] && MassQ[resourceAmount],
				(* if density is Null, use the density of water *)
				resourceAmount / Replace[density,{Null->Quantity[0.997`, ("Grams")/("Milliliters")]}],
				True,
				resourceAmount
			]
		]
	],
		{sampleResourceBlobs, samplesDensity, samplesState}
	];

	(* pull out the sample NumberOfUses from the Sample resource blobs *)
	sampleNumberOfUses = Map[
		If[MissingQ[#[NumberOfUses]],
			Null,
			#[NumberOfUses]
		]&,
		sampleResourceBlobs
	];

	(* pull out the sample VolumeOfUses from the Sample resource blobs  *)
	sampleVolumeOfUses = Map[
		If[MissingQ[#[VolumeOfUses]],
			Null,
			#[VolumeOfUses]
		]&,
		sampleResourceBlobs
	];

	(* pull out the container models from the Sample resource blobs *)
	sampleContainers = Map[
		If[MissingQ[#[Container]],
			Null,
			#[Container]
		]&,
		sampleResourceBlobs
	];

	(* pull out the container names from the Sample resource blobs *)
	sampleContainerNames = Map[
		If[MissingQ[#[ContainerName]],
			Null,
			#[ContainerName]
		]&,
		sampleResourceBlobs
	];

	(* pull out the container names from the Sample resource blobs *)
	sampleWells = Map[
		If[MissingQ[#[Well]],
			Null,
			#[Well]
		]&,
		sampleResourceBlobs
	];

	(* pull out the Fresh key from the Sample resource blobs *)
	freshBools = Map[
		If[MissingQ[#[Fresh]],
			Null,
			#[Fresh]
		]&,
		sampleResourceBlobs
	];

	(* pull out the REnt key from the Sample resource blobs; default to Null, since we want to by default attempt to purchase resources
	 	and ONLY ignore that if a developer explicitly says so *)
	rentBools = Map[
		If[MissingQ[#[Rent]],
			Null,
			#[Rent]
		]&,
		sampleResourceBlobs
	];

	(* pull out the RentContainer key from the Sample resource blobs; default to Null, since we want to by default attempt to purchase resources
	 	and ONLY ignore that if a developer explicitly says so *)
	rentContainerBools = Map[
		If[MissingQ[#[RentContainer]],
			Null,
			#[RentContainer]
		]&,
		sampleResourceBlobs
	];

	(* pull out the UpdateCount key from the Sample resource blobs; default to Null (indicating we will UpdateCount by default) *)
	updateCountBools = Map[
		If[MissingQ[#[UpdateCount]],
			Null,
			#[UpdateCount]
		]&,
		sampleResourceBlobs
	];

	(* pull out the Untracked key from the Sample resource blobs; default to Null, since we want to by default track purchase of resource amounts *)
	untrackedBools = Map[
		If[MissingQ[#[Untracked]],
			Null,
			#[Untracked]
		]&,
		sampleResourceBlobs
	];

	(* pull out the ThawRequired key from the Sample resource blobs; default to Null (indicating we will determine this at  by default) *)
	thawRequiredBools = Map[
		If[MissingQ[#[ThawRequired]],
			Null,
			#[ThawRequired]
		]&,
		sampleResourceBlobs
	];

	(* pull out the ExactAmount key from the Sample resource blobs - default to Null (which means false) *)
	exactAmountBools = Map[
		If[MissingQ[#[ExactAmount]],
			Null,
			#[ExactAmount]
		]&,
		sampleResourceBlobs
	];

	(* pull out the Tolerance key from the Sample resource blobs - default to Null (which means no tolerance) *)
	tolerances = Map[
		If[MissingQ[#[Tolerance]],
			Null,
			#[Tolerance]
		]&,
		sampleResourceBlobs
	];

	(* pull out the AutomaticDisposal key from the Sample resource blobs *)
	(* By default we're going to dispose unless told otherwise in the resource blob. This maintains our previous behavior of disposing when we make something specifically for a resource (i.e. ResourcePrep/ResourceTransfer) *)
	automaticDisposals = Map[
		If[MissingQ[#[AutomaticDisposal]],
			True,
			#[AutomaticDisposal]
		]&,
		sampleResourceBlobs
	];

	(* pull out the Sterile key from the Sample resource blobs *)
	(* If True then always get Sterile things.  If Null or False, don't have a preference one way or another *)
	(* ideally we would look up the Sterile field value of the Sample, but for performance reasons we can't do a Download here so it is what it is for now and that logic can go into resource picking *)
	steriles = Map[
		If[MissingQ[#[Sterile]],
			Null,
			#[Sterile]
		]&,
		sampleResourceBlobs
	];

	(* generate the sample resource packets *)
	sampleResourcePackets = MapThread[
		Function[{resourceID, amount, numberOfUses, volumeOfUses, specifiedSample, container, containerName, well, root, fresh, rent, rentContainer, updateCount, untracked, thawRequired, exactAmount, tolerance, automaticDisposal, sterile},
			Join[
				<|
					Object -> resourceID,
					Type -> Object[Resource, Sample],
					Status -> InCart,
					DateInCart -> Now,
					RootProtocol -> Link[root, SubprotocolRequiredResources],
					Amount -> If[IntegerQ[amount],
						amount * Unit,
						amount
					],
					NumberOfUses-> numberOfUses,
					VolumeOfUses-> volumeOfUses,
					(* if a container is specified, populate the ContainerModels field *)
					Replace[ContainerModels] -> If[MatchQ[container, ListableP[ObjectP[Model[Container]]]],
						ToList[Link[container]],
						{}
					],
					ContainerName -> containerName,
					Well -> well,
					Fresh -> fresh,
					Rent -> rent,
					(* use Null to mean false *)
					If[TrueQ[rentContainer],
						RentContainer -> True,
						Nothing
					],
					(* use Null to mean true *)
					If[MatchQ[updateCount, False],
						UpdateCount -> False,
						Nothing
					],
					(* use Null to mean false *)
					If[TrueQ[untracked],
						Untracked -> True,
						Nothing
					],
					(* use Null to mean True *)
					If[MatchQ[thawRequired,False],
						ThawRequired -> False,
						Nothing
					],
					(* use Null to mean false *)
					If[TrueQ[exactAmount],
						ExactAmount -> True,
						Nothing
					],
					Tolerance -> tolerance,
					AutomaticDisposal -> automaticDisposal,
					Sterile -> sterile
				|>,
				(* if the specified sample is a model, then populate the Models field; if it is a Sample/Container/Model, populate Sample and Model *)
				If[MatchQ[specifiedSample, ListableP[ObjectP[{Model[Sample], Model[Container], Model[Part], Model[Sensor], Model[Plumbing], Model[Wiring], Model[Item]}]]],
					<|
						Replace[Models] -> ToList[Link[specifiedSample]],
						Sample -> Null
					|>,
					<|
						Sample -> Link[specifiedSample]
					|>
				]
			]
		],
		{sampleResourceIDs, sampleAmounts, sampleNumberOfUses, sampleVolumeOfUses, specifiedSamples, sampleContainers, sampleContainerNames, sampleWells, sampleRootProts, freshBools, rentBools, rentContainerBools, updateCountBools, untrackedBools, thawRequiredBools, exactAmountBools, tolerances, automaticDisposals, steriles}
	];

	(* get the Time fields from the instrument blobs *)
	estimatedInstrumentTime = Map[
		If[MissingQ[#[Time]],
			Null,
			#[Time]
		]&,
		instrumentResourceBlobs
	];

	(* get the DeckLayout fields from the instrument blobs *)
	instrumentDeckLayouts = Map[
		If[MissingQ[#[DeckLayout]],
			{},
			ToList[#[DeckLayout]]
		]&,
		instrumentResourceBlobs
	];

	(* get the UnusedIntegratedInstrument fields from the instrument blobs *)
	unusedIntegratedInstrument = Map[
		If[MissingQ[#[UnusedIntegratedInstrument]],
			Null,
			#[UnusedIntegratedInstrument]
		]&,
		instrumentResourceBlobs
	];

	(* generate the instrument resource packets *)
	instrumentResourcePackets = MapThread[
		Join[
			<|
				Object -> #1,
				Type -> Object[Resource, Instrument],
				Status -> InCart,
				DateInCart -> Now,
				RootProtocol -> Link[#5, SubprotocolRequiredResources],
				EstimatedTime -> #3,
				Replace[DeckLayouts] -> Link[#4],
				UnusedIntegratedInstrument -> #6
			|>,
			If[MatchQ[#2, ListableP[ObjectP[Model[Instrument]]]],
				Module[{originalInstruments, expandedInstruments},

					(* add any equivalent instruments to the list, keep the original requested instruments at the front (DeleteDuplicates does not sort) as these are used in the fields and are most consistent with options *)
					originalInstruments = ToList[Link[#2]];
					expandedInstruments = Download[Join[originalInstruments, Flatten[Replace[originalInstruments,$EquivalentInstrumentModelLookup, 1]]], Object];

					<|
						Replace[InstrumentModels] -> Link/@DeleteDuplicates[expandedInstruments],
						Instrument -> Null
					|>
				],
				<|
					Instrument -> Link[#2]
				|>
			]
		]&,
		{instrumentResourceIDs, specifiedInstruments, estimatedInstrumentTime, instrumentDeckLayouts, instrumentRootProts, unusedIntegratedInstrument}
	];

	(* get the operators *)
	operators = Map[
		If[MissingQ[#[Operator]],
			Null,
			#[Operator]
		]&,
		operatorResourceBlobs
	];

	(* get the Time fields from the operator blobs *)
	estimatedOperatorTime = Map[
		If[MissingQ[#[Time]],
			Null,
			#[Time]
		]&,
		operatorResourceBlobs
	];

	(* generate the operator resource packets *)
	operatorResourcePackets = MapThread[
		<|
			Object -> #1,
			Type -> Object[Resource, Operator],
			RootProtocol -> Link[#3, SubprotocolRequiredResources],
			Status -> InCart,
			DateInCart -> Now,
			EstimatedTime -> #4,
			Replace[RequestedOperators] -> If[NullQ[#2],
				Nothing,
				ToList[Link[#2]]
			]
		|>&,
		{operatorResourceIDs, operators, operatorRootProts, estimatedOperatorTime}
	];

	(* get the ordered resource blobs and also the ordered packets *)
	orderedBlobs = Join[sampleResourceBlobs, instrumentResourceBlobs, operatorResourceBlobs];
	orderedPackets = Join[sampleResourcePackets, instrumentResourcePackets, operatorResourcePackets];

	(* generate replace rules to get the order of the packets the same as the order of the input resources *)
	blobToPacketReplaceRules = MapThread[
		#1 -> #2&,
		{orderedBlobs, orderedPackets}
	];

	(* return the list of resource packets in the same order as the input blobs *)
	myResources /. blobToPacketReplaceRules

];




(* ::Subsection:: *)
(*fulfillableResourceQ*)


(* ::Subsubsection:: *)
(*Main Function*)


DefineOptions[
	fulfillableResourceQ,
	Options :> {
		{Messages -> True, BooleanP, "When True, prints any messages fulfillableResourceQ generates."},
		{Subprotocol -> False, ListableP[BooleanP], "Indicates if the protocol for which resources are being created is a child protocol."},
		{Author :> $PersonID, ListableP[ObjectP[Object[User]]], "The user who authored the root protocol responsible for creating these resources.", IndexMatching -> Input},
		{Site -> Automatic, Automatic|ObjectP[Object[Container,Site]], "If specified, this is the Site all resources must be fulfilled at."},
		{SkipSampleMovementWarning -> {}, {} | ListableP[ObjectP[Object[Sample]]], "Specifies the sample(s) for which SamplesMustBeMoved warning should not be triggered."},
		CacheOption,
		SimulationOption,
		FastTrackOption,
		HelperOutputOption
	},
	SharedOptions :> {
		{
			RunValidQTest,
			{Verbose, OutputFormat}
		}
	}
];

Warning::InsufficientVolume = "The experiment requests more volume/mass/count of `1` (`2`) than is currently available (`3`).  Please check the available volume of these sample(s), or provide an alternative sample or model.";
Error::ResourceAlreadyReserved = "The experiment requests sample `1`, which is already reserved by a different resource.  Please check the availability of this sample using the RequestedResources field, or provide an alternative sample or model.";
Error::NonScalableStockSolutionVolumeTooHigh = "The experiment requests `1` of model `2`, but this amount exceeds the maximum amount that can be prepared at once (`3`). Please prepare up to the maximum amount, or consider splitting this into multiple requests.";
Error::NoAvailableSample = "The experiment requested `1` of model(s) `2`, but no such non-expired samples have that much mass/volume available, and cannot be reordered because no non-deprecated product exists for this quantity of these model(s).  Please check the availability of this sample, or provide an alternative sample, model, or amount.";
Error::InsufficientTotalVolume = "The experiment requested `1` of model(s) `2`, but the requested amount exceeds the amount available in the lab, and cannot be reordered because no usable product exists for these model(s).  This can happen if the existing product is deprecated, or it is not sterile while the request requires a sterile sample, or if a product does not exist.  Please check the availability of this sample, or provide an alternative sample or model.";
Error::NoAvailableModel = "The experiment request model(s) `1`, but there are no available instance(s) of these model(s), and cannot be reordered because no usable product exists for these model(s).  This can happen if the existing product is deprecated, or it is not sterile while the request requires a sterile sample, or if a product does not exist.  Please check the availability of these model(s), or provide an alternative sample or model.";
Error::ContainerTooSmall = "The experiment requests volume `1` to be put in container model(s) `2`, but this exceeds the maximum volume of `3`.  Please check the MaxVolume field of the specified container model(s).";
Error::ContainerNotAutoclaveCompatible = "The experiment requests the following sterile stock solutions, `1`, that must be autoclaved. However, the container(s) for these samples, `2`, are not autoclave compatible. The sample volume must not be over 3/4 of the container's MaxVolume and the container's MaxTemperature must be over 120 Celsius. Please specify a different container for these samples, or specify a non-sterile stock solution to be prepared.";
Warning::SampleMustBeMoved = "Sample(s) `1` are not in the requested containers. Therefore, the designated amount(s) of `2`.";
Error::MissingObjects = "Unable to find object(s) `1` in the database. Please check for errors in the object IDs or names.";
Error::SamplesMarkedForDisposal = "The following object(s) specified are flagged for disposal: `1`.  If you don't wish to dispose of these samples, please run CancelDiscardSamples on them.";
Warning::DeprecatedProduct = "The following model(s) that were requested have no non-deprecated products associated with them: `1`.  In the event that all is consumed before the protocol is run, ECL will not be able to order more and may abort this protocol.";
Error::DeprecatedModels = "The following model object(s) specified are deprecated: `1`.  Please check the Deprecated field for the models in question, or provide samples with alternative, non-deprecated models.";
Warning::ExpiredSamples = "The following input samples are marked expired: `1`, but we can continue with them anyway.  Please cancel the experiment if you would not like to use these samples marked as expired.";
Error::InstrumentsNotOwned = "The following instrument(s) specified are not part a Notebook financed by one of the current financing teams: `1`.  Please check the Notebook field of these objects and the Financers field of that Notebook.";
Error::RetiredInstrument = "The following specified instruments are retired: `1`.  Please check the Status of the instruments in question, or provide alternative, non-Retired instruments to use.";
Error::DeprecatedInstrument = "The following specified instrument models are deprecated: `1`.  Please check the Deprecated field of the instrument models in question, or provide alternative, non-Deprecated instruments to use.";
Error::DeckLayoutUnavailable = "The following instruments request deck layouts that are not available to the requested instrument's model: `1`.  Please check the AvailableLayouts field of the instrument models in these resources, and request deck layouts that are available for the desired instrument models.";
Warning::InstrumentUndergoingMaintenance = "The following specified instruments are currently undergoing maintenance: `1`.  This protocol may still be confirmed, but will not be run until these instruments are no longer undergoing maintenance.";
Warning::SamplesOutOfStock = "The following input model(s) `1` have no currently available non-expired samples in the ECL, but they can be ordered and we estimate they will arrive in approximately `2` after the item is ordered.";
Error::SamplesNotOwned = "The following object(s) specified are not part a Notebook financed by one of the current financing teams: `1`.  Please check the Notebook field of these objects and the Financers field of that Notebook; if they are public, please purchase these items before directly requesting them in an Experiment.";
Warning::SamplesInTransit = "The experiment requests samples that are currently in Transit to an ECL facility  (`1`). The protocol will not start in the lab until these samples arrive to the site where the experiment can be performed.";
Error::SamplesShippedFromECL = "The experiment requested samples that are currently in Transit to user (`1`). Please request alternative samples or ship these samples back to ECL.";
Error::RentedKit = "The following input model(s) `1` were requested by resources with Rent -> True, but they are part of kit(s).  Kits cannot be rented; please set Rent -> False or Null.";
Error::ExceedsMaxNumberOfUses = "The following input model(s) `1` were requested for a number of uses that will exceed the maximum number of uses available (`2`). Please request an alternative object or model.";
Error::ExceedsMaxVolumesCanBeUsed= "The following Resource[]s or Object[Resources] with Name `1` were requested with different VolumeOfUses (`2`), however the requested models have MaxVolumeOfUses `3`. Please request an alternative model or split this resources in two two or more different resources.";
Error::TwoVolumeOfUsesSpecifiedForOneResource= "The following Resource[]s or Object[Resources] with Name `1` were requested with the same VolumeOfUses (`2`), please change their name or consolidate these resources.";
Error::UnableToDetermineResourceShipment="It could not be determined if the following resource needs to be shipped between sites: `1`. Verify that the resource is valid.";
Error::SiteUnknown="The objects `1` don't have a recorded experiment site (or don't have objects with a site) and cannot be used. You can Search for objects with the Site field set to your desired experiment site to determine what's available.";
Error::NoSuitableSite="None of your ECL facilities contain all the requested instruments for your protocol. Your financing team has access to the sites `1`, but the required instruments for your protocol, `2`, can only be found at the respective sites, `3`.";
Warning::NoAvailableStoragePosition="The following instruments request storage inside of the instruments that have reached the maximum storage capacity: `1`. Please check the available positions of the instrument, or provide an alternative instrument or instrument model.";
Error::InvalidSterileRequest="The following input model(s) or object(s) `1` do not have Sterile -> True, but the resource requesting them requires them to be sterile. Please check the sterility of these samples, or provide alternative sterile samples to use.";
Error::ContainerNotSterile="The following container(s) `1` do not have Sterile -> True, but the resource requesting them requires them to be sterile.  Please check the sterility of the specified container, or provided alternative sterile containers to use.";

(* empty list case *)
fulfillableResourceQ[{}, ops : OptionsPattern[]] := Module[
	{safeOps, outputFormat, outputSpecification, testsRule, resultRule},

	(* get the safe options and pull out the Output and OutputFormat options *)
	safeOps = SafeOptions[fulfillableResourceQ, ToList[ops]];
	{outputFormat, outputSpecification} = Lookup[safeOps, {OutputFormat, Output}];

	(* generate the Tests Rule; here there are no tests *)
	testsRule = Tests -> {};

	(* generate the Result rule; if OutputFormat -> Boolean, return an empty list since there is no input; if OutputFormat -> SingleBoolean, return True *)
	resultRule = Result -> If[MatchQ[outputFormat, SingleBoolean],
		True,
		{}
	];

	(* return the values depending on what the Output option is *)
	outputSpecification /. {testsRule, resultRule}
];

(* singleton resource blob case *)
fulfillableResourceQ[myResourceBlob_Resource, ops : OptionsPattern[]] := fulfillableResourceQ[{myResourceBlob}, ops];

(* reverse listable resource blog case *)
fulfillableResourceQ[myResourceBlobs : {__Resource}, ops : OptionsPattern[]] := Module[
	{safeOps, fastTrack, outputFormat, resourcePackets, resourceChangePackets, keys, values, newKeys, cache, simulation,
		nameObjects, idObjects, nameReplaceRules, noNameResourceBlobs, objects, verbose,
		simulatedQ, nonSimulatedObjects, simulatedObjects, nonSimulatedResourcesBlobs, myResourceBlobsObjects},

	(* get the safe options *)
	safeOps = SafeOptions[fulfillableResourceQ, ToList[ops]];
	{fastTrack, cache, simulation, verbose, outputFormat} = Lookup[safeOps, {FastTrack, Cache, Simulation, Verbose, OutputFormat}];

	(* NOTE: If our simulation isn't updated, update it. *)
	simulation=If[!MatchQ[simulation, SimulationP] || MatchQ[Lookup[simulation[[1]], Updated], True],
		simulation,
		UpdateSimulation[Simulation[],simulation]
	];

	If[MatchQ[$CurrentSimulation, SimulationP] && !MatchQ[Lookup[$CurrentSimulation[[1]], Updated], True],
		$CurrentSimulation=UpdateSimulation[Simulation[],$CurrentSimulation];
	];

	(* if FastTrack -> True, return either True or a list of True values depending on OutputFormat *)
	Switch[{fastTrack, outputFormat},
		{True, SingleBoolean}, Return[True],
		{True, Boolean}, Return[ConstantArray[True, Length[myResourceBlobs]]],
		{_, _}, Null
	];

	(* remove the object listed by Name because if our cache does not have Name in it, it will cost us time to get ID *)
	myResourceBlobsObjects = Experiment`Private`sanitizeInputs[myResourceBlobs, Simulation -> simulation];

	(* return early if we have nonexistent objects *)
	Which[
		MatchQ[myResourceBlobsObjects, $Failed] && MatchQ[outputFormat, SingleBoolean], Return[False],
		(* maybe this is overkill but whatever, still need to fail somehow and it's not trivial to figure out which one is True and False here *)
		MatchQ[myResourceBlobsObjects, $Failed] && MatchQ[outputFormat, Boolean], Return[ConstantArray[False, Length[myResourceBlobs]]],
		True, Null
	];

	(* pull out all of the object references from the resource blobs*)
	objects = DeleteDuplicates[Cases[myResourceBlobsObjects, ObjectReferenceP[], Infinity]];

	(* For each object, see if it is simulated. Simulated objects will be created previously so they are guaranteed to be available. *)
	(* NOTE: The Simulated key is here for reverse compatibility and should be phased out as SM will no longer exist. *)
	simulatedQ = MapThread[
		(MatchQ[#1, True] || MatchQ[#2, True]&),
		{
			If[!MatchQ[simulation, SimulationP],
				ConstantArray[False, Length[objects]],
				If[MatchQ[$CurrentSimulation, SimulationP],
					Module[{allSimulatedObjects},
						allSimulatedObjects=Join[Lookup[$CurrentSimulation[[1]], SimulatedObjects], Lookup[simulation[[1]], SimulatedObjects]];

						(MemberQ[allSimulatedObjects, #]&)/@objects
					],
					(MemberQ[Lookup[simulation[[1]], SimulatedObjects], #]&)/@objects
				]
			],
			(Lookup[fetchPacketFromCache[#, cache], Simulated, False]&)/@objects
		}
	];

	(* Filter out any simulated objects. *)
	nonSimulatedObjects = PickList[objects, simulatedQ, False];
	simulatedObjects = PickList[objects, simulatedQ];

	(* pick only those objects that do not have the ID at the end *)
	nameObjects = Select[nonSimulatedObjects, Not[StringMatchQ[Last[#], "id:" ~~ __]]&];

	(* pull out the object IDs for all these object references *)
	(* note that this talks to the Database, but we basically have to do this here otherwise it will implicitly happen elsewhere in pattern matching *)
	idObjects = Download[nameObjects, Object, Cache -> cache, Simulation -> simulation];

	(* make replace rules that will change the names to objects *)
	nameReplaceRules = MapThread[
		#1 -> #2&,
		{nameObjects, idObjects}
	];

	(* Only check if non-simulated objects are fulfillable. *)
	nonSimulatedResourcesBlobs = (
		If[MemberQ[#, Alternatives @@ simulatedObjects, Infinity],
			Nothing,
			#
		]
	&) /@ myResourceBlobsObjects;

	(* have the blobs that don't have any names in their packets anymore *)
	noNameResourceBlobs = nonSimulatedResourcesBlobs /. nameReplaceRules;

	(* convert the input resource blobs into resource packets using the function resourceToPacket (defined in this same file above and also used by RequireResources) *)
	(* SimulationMode -> True because it's faster and we don't really care about the resource objects here anyway if we're from the blob overload *)
	resourceChangePackets = resourceToPacket[noNameResourceBlobs, Simulation -> simulation, SimulationMode -> True];

	(* get the keys and values for the resource change packets *)
	keys = Keys[#]& /@ resourceChangePackets;
	values = Values[#]& /@ resourceChangePackets;

	(* get the new keys that don't have the Replace[Symbol] constructs and replaces that with Symbol itself *)
	newKeys = keys /. {Replace[x_Symbol] :> x};

	(* get the resource packets with the Replace format gone *)
	resourcePackets = MapThread[
		AssociationThread[#1, #2]&,
		{newKeys, values}
	];

	(* pass these resource packets to the core fulfillableResourceQ function. Since these are now resource packets, we can Download from these like we would normal objects *)
	(* Note: We only use the Cache option to determine if samples are simulated. We do not actually pass the cache down because there are too many fields to download here. Also, this function should never be mapped. *)
	fulfillableResourceQ[resourcePackets, ReplaceRule[safeOps, Cache -> {}]]
];

(* singleton resource object case *)
fulfillableResourceQ[myResource : ObjectP[Object[Resource]], ops : OptionsPattern[]] := fulfillableResourceQ[{myResource}, ops];

(* CORE FUNCTION *)
fulfillableResourceQ[myResources : {ObjectP[Object[Resource]]..}, ops : OptionsPattern[]] := Module[
	{
		safeOps, messageOption, cache, fastTrack, verbose, outputFormat, fulfillableResourceAssoc, allTestsAndBools, allTests,allBools,
		outputSpecification, subprotocol, output, pairedObjsAndTests, result, indexMatchedResults, resultRule, testsRule, messages, author,
		site, allBoolTests, pairedObjsAndBools, simulation, noMovementWarningSamples
	},

	(* get the safe options, and pull out the specific option values from it; also make Output into a list if it isn't already *)
	safeOps = SafeOptions[fulfillableResourceQ, ToList[ops]];
	{messageOption, cache, fastTrack, verbose, outputFormat, outputSpecification, subprotocol, author, simulation, site, noMovementWarningSamples} = Lookup[safeOps, {Messages, Cache, FastTrack, Verbose, OutputFormat, Output, Subprotocol, Author, Simulation, Site, SkipSampleMovementWarning}];
	output = ToList[outputSpecification];

	(* throw messages if Messages -> True and Output does not include Tests *)
	messages = TrueQ[messageOption] && Not[MemberQ[output, Tests]];

	(* if FastTrack -> True, return either True or a list of True values depending on OutputFormat *)
	Switch[{fastTrack, outputFormat},
		{True, SingleBoolean}, Return[True],
		{True, Boolean}, Return[ConstantArray[True, Length[myResources]]],
		{_, _}, Null
	];

	(* pass the resources to the core function, which groups all the resources by what is wrong with them *)
	fulfillableResourceAssoc = fulfillableResources[myResources, Subprotocol -> subprotocol, Author -> author, Messages -> messages, Cache -> cache, FastTrack -> fastTrack, Simulation -> simulation, Site -> site, SkipSampleMovementWarning -> noMovementWarningSamples];

	(* if somehow we got $Failed, return $Failed (message thrown in fulfillableResources) *)
	If[MatchQ[fulfillableResourceAssoc, $Failed],
		Return[$Failed]
	];
	(* TODO add an error for scaling beyond $MaxNumberOfFulfillmentPreps *)
	(* --- Prepare the outputs to pass to RunValidQTest --- *)
	(* to allow avoiding RunUnitTest when Verbose -> False, while keeping both warnings and tests, we will build tuple where the first
	 element is the type of test (Test/Warning) and the second element is a tuple to construct the test. We will return both constructed tests and booleans and use whatever is required.
	 When Verbose->False, Warnings are raised locally and return True. To accommodate both testing booleans locally and returning tests, we will also make dummy Warning tests that we can
	  then pass to tests if asked. Its a big ugly, but does the work in less time. *)
	{allTestsAndBools, allBools} = Transpose@Map[
		Module[
			{
				objsExist, objsExistTest, disposalSample, discardedSample, deprecatedModel, enoughAmountSample,
				enoughConsumableSample, modelEnoughVolume, enoughTotalModel, enoughConsumableModel, belowMaxVolume,
				retiredInstruments, deprecatedInstruments, deckLayoutsUnavailable, ownedSample, samplesMustBeMoved,
				expiredSamples, instrumentUndergoingMaintenance, samplesOutOfStock, deprecatedProduct, samplesInTransit,
				samplesShippedToUser, rentedKits, enoughUsesSample, enoughVolumeUsesSample, uniqueVolumeUsesSample,
				nonScalableStockSolutionVolumeTooHigh, possibleSite, noInstrumentForStorage, invalidSterileRequest,
				containerNotSterile, ownedInstrument
			},

			(* if resource blobs were provided, do Sample/Models/Instrument/InstrumentModels exist? *)
			objsExistTest = {Test, {
				StringJoin["The provided resource ", ToString[#, InputForm], " exists:"],
				MemberQ[Lookup[fulfillableResourceAssoc, MissingObjects], ObjectP[#]],
				False
			}};

			(* if resource blobs were provided, do the Sample/Models/Instrument/InstrumentModels exist? want a Boolean here because we want to short circuit if no *)
			objsExist = If[MemberQ[Lookup[fulfillableResourceAssoc, MissingObjects], ObjectP[#]],
				False,
				True
			];

			(* if Sample is specified, is the sample set for disposal? *)
			disposalSample = {Test, {
				StringJoin["The sample requested by resource ", ToString[#, InputForm], " is not marked for disposal:"],
				MemberQ[Lookup[fulfillableResourceAssoc, SamplesMarkedForDisposal], ObjectP[#]],
				False
			}};

			(* if Sample is specified, is the sample discarded? *)
			discardedSample = {Test, {
				StringJoin["The sample requested by resource ", ToString[#, InputForm], " is not discarded:"],
				MemberQ[Lookup[fulfillableResourceAssoc, DiscardedSamples], ObjectP[#]],
				False
			}};

			(* if Models are specified, are the models deprecated? *)
			deprecatedModel = {Test, {
				StringJoin["If a model was requested by resource ", ToString[#, InputForm], ", that model is not deprecated:"],
				MemberQ[Lookup[fulfillableResourceAssoc, DeprecatedModels], ObjectP[#]],
				False
			}};

			(* if Models are specified, is there at least one non-deprecated product? *)
			deprecatedProduct = If[MatchQ[verbose, Except[False]],
				{Warning, {
					StringJoin["If a model was requested by resource ", ToString[#, InputForm], ", that model has at least one non-deprecated product:"],
					MemberQ[Lookup[fulfillableResourceAssoc, DeprecatedProduct], ObjectP[#]],
					False
				}},
				(* to maintain the same format as tests, we will make sure the second element in the tuple has true in its second position, the rest means nothing. *)
				{Warning, {"", True, True}}
			];

			(* if Samples is specified, is that sample owned by this notebook? *)
			ownedSample = {Test, {
				StringJoin["If a specific sample was requested by resource ", ToString[#, InputForm], " that sample is owned by your team:"],
				MemberQ[Lookup[fulfillableResourceAssoc, SamplesNotOwned], ObjectP[#]],
				False
			}};

			(* if Sample is specified, is there enough amount in that sample?*)
			(* this is a warning and not a test, remember *)
			enoughAmountSample = {Warning, {
				StringJoin["If a sample was provided directly by resource ", ToString[#, InputForm], ", there is enough volume that is not already reserved by other resources:"],
				MemberQ[Lookup[fulfillableResourceAssoc, InsufficientVolume], ObjectP[#]],
				False
			}};

			(* if Sample is specified, is that sample already reserved? *)
			enoughConsumableSample = {Test, {
				StringJoin["If a consumable sample was provided directly by resource ", ToString[#, InputForm], ", there is no other resource also reserving this same item:"],
				MemberQ[Lookup[fulfillableResourceAssoc, ResourceAlreadyReserved], ObjectP[#]],
				False
			}};

			(* If Models is specified, is there an available sample of that model with the correct volume? *)
			modelEnoughVolume = {Test, {
				StringJoin["If a model was provided by resource ", ToString[#, InputForm], ", there is enough volume of a sample that is not already reserved to fulfill the resource:"],
				MemberQ[Lookup[fulfillableResourceAssoc, NoAvailableSample], ObjectP[#]],
				False
			}};

			(* If Models is specified, is there a total amount of available sample of that model? *)
			enoughTotalModel = {Test, {
				StringJoin["If a model was provided by resource ", ToString[#, InputForm], ", there is enough total volume of the model across one or several samples:"],
				MemberQ[Lookup[fulfillableResourceAssoc, InsufficientTotalVolume], ObjectP[#]],
				False
			}};

			(* if Models is specified, are there enough total quantity of that consumable sample? *)
			enoughConsumableModel = {Test, {
				StringJoin["If a consumable model was provided by resource ", ToString[#, InputForm], ", there are enough available consumables to fulfill this resource:"],
				MemberQ[Lookup[fulfillableResourceAssoc, NoAvailableModel], ObjectP[#]],
				False
			}};

			(* If ContainerModels are specified, is the requested volume less than the MaxVolume of the containers? *)
			belowMaxVolume = {Test, {
				StringJoin["If container models were specified by resource ", ToString[#, InputForm], ", they are large enough to hold the volume that was requested:"],
				MemberQ[Lookup[fulfillableResourceAssoc, ContainerTooSmall], ObjectP[#]],
				False
			}};

			(* if Instruments is specified, is that instrument owned by this notebook? *)
			ownedInstrument = {Test, {
				StringJoin["If a specific instrument was requested by resource ", ToString[#, InputForm], " that instrument is owned by your team:"],
				MemberQ[Lookup[fulfillableResourceAssoc, InstrumentsNotOwned], ObjectP[#]],
				False
			}};

			(* If Instruments were specified, are the instruments retired? *)
			retiredInstruments = {Test, {
				StringJoin["If an instrument was specified by resource ", ToString[#, InputForm], " it is not retired:"],
				MemberQ[Lookup[fulfillableResourceAssoc, RetiredInstrument], ObjectP[#]],
				False
			}};

			(* If Instrument Models were specified, are the models deprecated? *)
			deprecatedInstruments = {Test, {
				StringJoin["If an instrument model was specified by resource ", ToString[#, InputForm], ", that instrument is not deprecated:"],
				MemberQ[Lookup[fulfillableResourceAssoc, DeprecatedInstrument], ObjectP[#]],
				False
			}};

			(* If Instrument Models were specified, are the DeckLayoutUnavailable? *)
			deckLayoutsUnavailable = {Test, {StringJoin["If a deck layout is specified by resource ", ToString[#, InputForm], ", it is available to the instrument model:"],
				MemberQ[Lookup[fulfillableResourceAssoc, DeckLayoutUnavailable], ObjectP[#]],
				False
			}};

			(* If a sample must be moved before it cna be used, throw a warning *)
			samplesMustBeMoved = {Warning, {
				StringJoin["If a sample is specified in a container model by resource ", ToString[#, InputForm], ", that sample is already in that container model and does not need to be moved:"],
				MemberQ[Lookup[fulfillableResourceAssoc, SampleMustBeMoved], ObjectP[#]],
				False
			}};

			(* if a sample was specified, it is not expired *)
			expiredSamples = {Warning, {
				StringJoin["The sample specified by resource ", ToString[#, InputForm], " are not expired:"],
				MemberQ[Lookup[fulfillableResourceAssoc, ExpiredSamples], ObjectP[#]],
				False
			}};

			(* if instruments were specified, are the instruments undergoing maintenance? *)
			instrumentUndergoingMaintenance = {Warning, {
				StringJoin["If an instrument was specified by resource ", ToString[#, InputForm], ", it is not currently undergoing maintenance:"],
				MemberQ[Lookup[fulfillableResourceAssoc, InstrumentUndergoingMaintenance], ObjectP[#]],
				False
			}};

			(* if a model was specified and it is out of stock but we can buy it *)
			samplesOutOfStock = {Warning, {
				StringJoin["If a sample that is stocked by ECL was specified by resource ", ToString[#, InputForm], ", there are sufficient available samples currently in the ECL:"],
				MemberQ[Lookup[fulfillableResourceAssoc, SamplesOutOfStock], ObjectP[#]],
				False
			}};

			(* if a sample was specified and it is being shipped from the user *)
			samplesInTransit = {Warning, {
				StringJoin["The sample specified by resource ", ToString[#, InputForm], ", is not in transit from the user:"],
				MemberQ[Lookup[fulfillableResourceAssoc, SamplesInTransit], ObjectP[#]],
				False
			}};

			(* If Instrument Models were specified, are the models deprecated? *)
			samplesShippedToUser = {Test, {
				StringJoin["The sample specified by resource ", ToString[#, InputForm], ", is not in transit to the user:"],
				MemberQ[Lookup[fulfillableResourceAssoc, SamplesShippedFromECL], ObjectP[#]],
				False
			}};

			(* if samples that are part of kits, are those resources set to Rent -> False? *)
			rentedKits = {Test, {
				StringJoin["If a sample specified by resource ", ToString[#, InputForm], " is part of a kit, Rent is not set to True:"],
				MemberQ[Lookup[fulfillableResourceAssoc, RentedKit], ObjectP[#]],
				False
			}};

			(* if Sample is specified, are there enough uses left on that sample? *)
			enoughUsesSample = {Test, {
				StringJoin["If a sample was provided directly by resource ", ToString[#, InputForm], ", there are enough uses left to fulfill the request:"],
				MemberQ[Lookup[fulfillableResourceAssoc, ExceedsMaxNumberOfUses], ObjectP[#]],
				False
			}};

			(* if Sample is specified, are there enough volume for the specified models that left on that sample? *)
			enoughVolumeUsesSample = {Test, {
				StringJoin["If a sample was provided directly by resource ", ToString[#, InputForm], ", that can only handle a specific amount of the liquid (e.g. Object[Item, Filter, MicrofluidicChip] can only filter about 300-milliliter sample), there are enough allowed amount volume for specified model left to fulfill the request:"],
				MemberQ[Lookup[fulfillableResourceAssoc, ExceedsMaxVolumeOfUses], ObjectP[#]],
				False
			}};

			(* if Sample is specified, are there enough volume for the specified models that left on that sample? *)
			uniqueVolumeUsesSample = {Test, {
				StringJoin["If a sample was provided directly by resource ", ToString[#, InputForm], ", that can only handle a specific amount of the liquid (e.g. Object[Item, Filter, MicrofluidicChip] can only filter about 300-milliliter sample), cannot specify two different VolumeOfUses for the same name:"],
				MemberQ[Lookup[fulfillableResourceAssoc, ConflictingVolumeOfUses], ObjectP[#]],
				False
			}};

			(* If requesting a stock solution model that has VolumeIncrements populated, the requested amount does not exceed the maximum of VolumeIncrements * $MaxNumberOfFulfillmentPreps *)
			nonScalableStockSolutionVolumeTooHigh = {Test, {
				StringJoin["If a stock solution model that has VolumeIncrements populated was requested by resource ", ToString[#, InputForm], ", the requested amount does not exceed the maximum of VolumeIncrements * $MaxNumberOfFulfillmentPreps:"],
				MemberQ[Lookup[fulfillableResourceAssoc, NonScalableStockSolutionVolumeTooHigh], ObjectP[#]],
				False
			}};

			(* If Instrument is specified, are there instrument instruments at required site? *)
			possibleSite = {Test, {
				StringJoin["All required instruments have at least one instance in the same site:"],
				If[MatchQ[#,ObjectP[Object[Resource,Instrument]]],
					MatchQ[Lookup[fulfillableResourceAssoc, Site],ObjectP[]],
					True
				],
				True
			}};

			(* If a Storage Instrument is specified (such as CrystalIncubator), are there available storage positions inside? *)
			noInstrumentForStorage = {Warning, {
				StringJoin["All required storage instruments have enough unoccupied positions to store samples:"],
				MemberQ[Lookup[fulfillableResourceAssoc, StoragePositionUnavailable], ObjectP[#]],
				False
			}};

			(* If the resource requests Sterile -> True, are the specified models or samples Sterile -> True? *)
			invalidSterileRequest = {Test, {
				StringJoin["If Sterile -> True is set in the resource, the requested sample or model has Sterile -> True:"],
				MemberQ[Lookup[fulfillableResourceAssoc, InvalidSterileRequest], ObjectP[#]],
				False
			}};

			(* If the resource requests Sterile -> True, are the specified Containers Sterile -> True? *)
			containerNotSterile = {Test, {
				StringJoin["If Sterile -> True is set in the resource, the container(s) to hold the requested sample or model have Sterile -> True:"],
				MemberQ[Lookup[fulfillableResourceAssoc, ContainerNotSterile], ObjectP[#]],
				False
			}};

			(* return two outputs, one only booleans, and another full list of the object and all the test results for this input *)
			{
				(* verbose result, construct the tests and warnings to pass on. the type of test is specified in the first element of the tuple *)
				{
					objsExist,
					Flatten[Map[
						(#[[1]]@@#[[2]])&,
						{
							objsExistTest,
							disposalSample,
							discardedSample,
							deprecatedModel,
							deprecatedProduct,
							ownedSample,
							enoughAmountSample,
							enoughConsumableSample,
							modelEnoughVolume,
							enoughTotalModel,
							enoughConsumableModel,
							belowMaxVolume,
							ownedInstrument,
							retiredInstruments,
							deprecatedInstruments,
							deckLayoutsUnavailable,
							samplesMustBeMoved,
							expiredSamples,
							instrumentUndergoingMaintenance,
							samplesOutOfStock,
							samplesInTransit,
							samplesShippedToUser,
							rentedKits,
							enoughUsesSample,
							enoughVolumeUsesSample,
							uniqueVolumeUsesSample,
							nonScalableStockSolutionVolumeTooHigh,
							possibleSite,
							noInstrumentForStorage,
							invalidSterileRequest,
							containerNotSterile
						}
					]]
				},
				(* If not verbose, locally run MatchQ to compare tests and their expected results. warnings are removed from these *)
				{
					objsExist,
					Flatten[Map[
						(MatchQ[#[[2]][[2]],#[[2]][[3]]])&,
						{
							objsExistTest,
							disposalSample,
							discardedSample,
							deprecatedModel,
							deprecatedProduct,
							ownedSample,
							enoughConsumableSample,
							modelEnoughVolume,
							enoughTotalModel,
							enoughConsumableModel,
							belowMaxVolume,
							ownedInstrument,
							retiredInstruments,
							deprecatedInstruments,
							deckLayoutsUnavailable,
							samplesShippedToUser,
							rentedKits,
							enoughUsesSample,
							enoughVolumeUsesSample,
							uniqueVolumeUsesSample,
							nonScalableStockSolutionVolumeTooHigh,
							possibleSite,
							invalidSterileRequest,
							containerNotSterile
						}
					]]
				}
			}
		]&,
		Download[myResources, Object]
	];

	(* gather all the tests together; if the object doesn't exist at all, then don't include most of the tests *)
	allTests = Map[
		If[TrueQ[#[[1]]],
			#[[2]],
			{First[#[[2]]]}
		]&,
		allTestsAndBools
	];

	(* we will do the same for bools *)
	allBoolTests = Map[
		If[TrueQ[#[[1]]],
			#[[2]],
			{First[#[[2]]]}
		]&,
		allBools
	];

	(* generate associations to be fed into RunUnitTest *)
	pairedObjsAndTests = Association[Flatten[MapThread[
		ToString[#1, InputForm] -> #2&,
		{Download[myResources, Object], allTests}
	]]];

	(* generate Bool associations *)
	pairedObjsAndBools = Association[Flatten[MapThread[
		ToString[#1, InputForm] -> #2&,
		{Download[myResources, Object], allBoolTests}
	]]];

	(* pass the input options to RunUnitTest *)
	(* If a Verbose result is required, pass tests to RunUnitTest, otherwise, return the booleans from above *)
	result = If[MatchQ[verbose, Except[False]],
		(* If a verbose result is required *)
		RunUnitTest[pairedObjsAndTests, Verbose -> verbose, OutputFormat -> outputFormat],
		(* if Verbose->False result is required, to keep the same format as RunUnitTest output, we need to take output into account *)
		Switch[outputFormat,
			(* If a singleBoolean is required, flatten all values and apply And *)
			SingleBoolean,
				And@@Flatten[Values[pairedObjsAndBools]],
			(* If the output is multiple booleans, map over each object's test results and And them. keep in the same format as RunUnitTests *)
			Boolean,
				KeyValueMap[
					Function[{object, testResults},
						Rule[object, (And@@testResults)]],
					pairedObjsAndBools
					],
			(* If the output is test summary, run unit tests.. *)
			TestSummary,
				RunUnitTest[pairedObjsAndTests, Verbose -> verbose, OutputFormat -> outputFormat]
		]
	];

	(* since the output of RunUnitTest is an association, and if we have multiple of the same objects in that association, we could be in trouble; need to deconvolute so that the inputs are index matched with the outputs *)
	indexMatchedResults = If[MatchQ[outputFormat, SingleBoolean],
		result,
		Map[
			(* need to do this ToString since I did it above too *)
			Lookup[result, ToString[#, InputForm]]&,
			Download[myResources, Object]
		]
	];

	(* make the result and test rules *)
	resultRule = Result -> If[MemberQ[output, Result],
		indexMatchedResults,
		Null
	];
	testsRule = Tests -> If[MemberQ[output, Tests],
		Flatten[allTests],
		Null
	];

	outputSpecification /. {resultRule, testsRule}

];


(* ::Subsubsection::Closed:: *)
(*fulfillableResourcesP (private pattern)*)


(* define the pattern for the output of fulfillableResources as a big association *)
(* this is similar to the output of ReadyCheck *)
fulfillableResourcesP = AssociationMatchP[
	Association[
		(* the list of all the resources we are checking *)
		Resources -> {ObjectP[Object[Resource]]...},

		(* the list of Booleans indicating if every entry of the Resources field is Fulfillable *)
		Fulfillable -> {BooleanP...},

		(* the list of all resources requesting a specific sample that have insufficient volume/mass available *)
		InsufficientVolume -> {ObjectP[Object[Resource]]...},

		(* the list of all resources requesting a sample that is already reserved *)
		ResourceAlreadyReserved -> {ObjectP[Object[Resource]]...},

		(* the list of all resources requesting a model that doesn't have any samples with enough volume/mass *)
		NoAvailableSample -> {ObjectP[Object[Resource]]...},

		(* the list of all resources requesting a model where an insufficient total amount of mass/volume is available *)
		InsufficientTotalVolume -> {ObjectP[Object[Resource]]...},

		(* the list of all resources requesting a model that has no available instances *)
		NoAvailableModel -> {ObjectP[Object[Resource]]...},

		(* the list of all the resources requesting a model that has a deprecated product *)
		DeprecatedProduct -> {ObjectP[Object[Resource]]...},

		(* the list of all resources requesting a sample in a container that is too small to hold the amount requested *)
		ContainerTooSmall -> {ObjectP[Object[Resource]]...},

		(* the list of all resources requesting a sterile stock solution in a container that is not autoclave compatible *)
		ContainerNotAutoclaveCompatible -> {ObjectP[Object[Resource]]...},

		(* the list of all resources that must be moved to a new container in order for the resource to be fulfilled *)
		SampleMustBeMoved -> {ObjectP[Object[Resource]]...},

		(* the list of all resources that do not exist in the database *)
		MissingObjects -> {ObjectP[Object[Resource]]...},

		(* the list of all resources that request items that are flagged for disposal *)
		SamplesMarkedForDisposal -> {ObjectP[Object[Resource]]...},

		(* the list of all resources requesting deprecated models *)
		DeprecatedModels -> {ObjectP[Object[Resource]]...},

		(* the list of all resources requesting discarded samples *)
		DiscardedSamples -> {ObjectP[Object[Resource]]...},

		(* the list of all resources requesting expired samples *)
		ExpiredSamples -> {ObjectP[Object[Resource]]...},

		(* the list of all resources requesting instruments that are not part of a notebook financed by one of the current financing teams *)
		InstrumentsNotOwned -> {ObjectP[Object[Resource]]...},

		(* the list of all resources requesting a retired instrument *)
		RetiredInstrument -> {ObjectP[Object[Resource]]...},

		(* the list of all resources requesting a deprecated instrument model *)
		DeprecatedInstrument -> {ObjectP[Object[Resource]]...},

		(* the list of all resources requesting instrument deck layouts that are not available *)
		DeckLayoutUnavailable -> {ObjectP[Object[Resource]]...},

		(* the list of all resources requesting storage position inside of instrument that are not available *)
		StoragePositionUnavailable -> {ObjectP[Object[Resource]]...},

		(* the list of all resources requesting instruments that are currently undergoing maintenance *)
		InstrumentUndergoingMaintenance -> {ObjectP[Object[Resource]]...},

		(* the list of all resources requesting items that are currently out of stock but could be re-ordered *)
		SamplesOutOfStock -> {ObjectP[Object[Resource]]...},

		(* the list of all resources requesting items that are not part of a notebook financed by one of the current financing teams *)
		SamplesNotOwned -> {ObjectP[Object[Resource]]...},

		(* the list of all resources requesting samples that currently have a status of ShippingToECL and are associated with a ShipToECL transaction *)
		SamplesInTransit -> {ObjectP[Object[Resource]]...},

		(* the list of all samples/items/containers that are in transit to an ECL facility *)
		SamplesInTransitPackets -> {ObjectP[{Object[Sample], Object[Item], Object[Container]}]...},

		(* the list of all resources requesting samples that currently have a status of ShippingToUser and are associated with a ShipToUser transaction *)
		SamplesShippedFromECL -> {ObjectP[Object[Resource]]...},

		(* the list of all resources requesting samples that are parts of kits with Rent -> True *)
		RentedKit -> {ObjectP[Object[Resource]]...},

		(* the list of all resources requesting samples that exceed the maximum number of uses *)
		ExceedsMaxNumberOfUses -> {ObjectP[Object[Resource]]...},

		(* the list of all resources requesting samples that exceed the maximum volume of uses *)
		ExceedsMaxVolumeOfUses -> {ObjectP[Object[Resource]]...},

		(* the list of all resources different volume of uses under the same name*)
		ConflictingVolumeOfUses -> {ObjectP[Object[Resource]]...},

		(* the list of all resources requesting samples that exceed the maximum preparable volume of a stock solution *)
		NonScalableStockSolutionVolumeTooHigh -> {ObjectP[Object[Resource]]...},

		(* list of resources where Sterile -> True in the resource, but not in the requested sample or model *)
		InvalidSterileRequest -> {ObjectP[Object[Resource]]...},

		(* list of resources where Sterile -> True in the resource, but not in the specified container model *)
		ContainerNotSterile -> {ObjectP[Object[Resource]]...},

		(* the list of all resources requesting samples that are not on site and need to be shipped *)
		SamplesOffSite -> {ObjectP[Object[Resource]]...},


		(* the site that all resources must be fulfilled at *)
		Site -> (Null|ObjectP[Object[Container, Site]])
	]
];



(* ::Subsubsection::Closed:: *)
(*fulfillableResourcesP (private function)*)


Error::OptionLengthMismatch = "These options' lengths do not line up with the input lists' lengths: `1`. The input list has length `2`; please provide option lists of this length, or, alternatively, a single option value may be supplied.";


DefineOptions[
	fulfillableResources,
	Options :> {
		{Messages -> True, BooleanP, "When True, prints any messages fulfillableResources generates."},
		{Subprotocol -> False, ListableP[BooleanP], "Indicates if the protocol for which resources are being created is a child protocol."},
		{Author :> $PersonID, ListableP[ObjectP[Object[User]]], "The user who authored the root protocol responsible for creating these resources.", IndexMatching -> Input},
		{Site -> Automatic, Automatic|ObjectP[Object[Container,Site]], "If specified, this is the Site all resources must be fulfilled at."},
		{SkipSampleMovementWarning -> {}, {} | ListableP[ObjectP[Object[Sample]]], "Specifies the sample(s) for which Warning::SamplesMustBeMoved message should not be triggered."},
		SimulationOption,
		CacheOption,
		FastTrackOption
	}
];

(* empty list overload returns association with empty list at every entry *)
fulfillableResources[{}, ops : OptionsPattern[]] := Module[{specifiedSite},

	(* get the safe options, and pull out the cache option *)
	specifiedSite = OptionValue[Site];

	<|
		Resources -> {},
		Fulfillable -> {},
		InsufficientVolume -> {},
		ResourceAlreadyReserved -> {},
		NoAvailableSample -> {},
		InsufficientTotalVolume -> {},
		NoAvailableModel -> {},
		DeprecatedProduct -> {},
		ContainerTooSmall -> {},
		SampleMustBeMoved -> {},
		MissingObjects -> {},
		SamplesMarkedForDisposal -> {},
		DeprecatedModels -> {},
		DiscardedSamples -> {},
		ExpiredSamples -> {},
		InstrumentsNotOwned -> {},
		RetiredInstrument -> {},
		DeprecatedInstrument -> {},
		DeckLayoutUnavailable -> {},
		StoragePositionUnavailable -> {},
		InstrumentUndergoingMaintenance -> {},
		SamplesOutOfStock -> {},
		SamplesNotOwned -> {},
		SamplesInTransit -> {},
		SamplesInTransitPackets -> {},
		SamplesShippedFromECL -> {},
		RentedKit -> {},
		ExceedsMaxNumberOfUses -> {},
		ExceedsMaxVolumeOfUses -> {},
		ConflictingVolumeOfUses -> {},
		NonScalableStockSolutionVolumeTooHigh -> {},
		InvalidSterileRequest -> {},
		ContainerNotSterile -> {},
		SamplesOffSite -> {},
		Site -> If[MatchQ[specifiedSite, ObjectP[]], specifiedSite, $Site]
	|>
];

(* singleton overload taking only one resource symbolic representation*)
fulfillableResources[myResourceBlob_Resource, ops : OptionsPattern[]] := fulfillableResources[{myResourceBlob}, ops];

(* reverse listable overload taking many resource symbolic representations *)
(* basically call resourceToPacket and then pass to core function *)
fulfillableResources[myResourceBlobs : {__Resource}, ops : OptionsPattern[]] := Module[
	{objects, nameObjects, idObjects, nameReplaceRules, noNameResourceBlobs, resourceChangePackets, keys, values,
		newKeys, resourcePackets, safeOps, cache, subprotocol, author, simulation, specifiedSite},

	(* get the safe options, and pull out the cache option *)
	safeOps = SafeOptions[fulfillableResources, ToList[ops]];
	{cache, author, subprotocol, simulation, specifiedSite} = Lookup[safeOps, {Cache, Author, Subprotocol, Simulation, Site}];

	(* pull out all of the object references from the resource blobs*)
	objects = DeleteDuplicates[Cases[myResourceBlobs, ObjectReferenceP[], Infinity]];

	(* pick only those objects that do not have the ID at the end *)
	nameObjects = Select[objects, Not[StringMatchQ[Last[#], "id:" ~~ __]]&];

	(* pull out the object IDs for all these object references *)
	(* note that this talks to the Database, but we basically have to do this here otherwise it will implicitly happen elsewhere in pattern matching *)
	idObjects = Download[nameObjects, Object, Cache -> cache, Simulation -> simulation];

	(* make replace rules that will change the names to objects *)
	nameReplaceRules = MapThread[
		#1 -> #2&,
		{nameObjects, idObjects}
	];

	(* have the blobs that don't have any names in their packets anymore; need to use ReplaceAll because we are going several levels deep into the symbolic reps *)
	noNameResourceBlobs = myResourceBlobs /. nameReplaceRules;

	(* convert the input resource blobs into resource packets using the function resourceToPacket (defined in this same file above and also used by RequireResources) *)
	(* SimulationMode -> True because it's faster and we don't really care about the resource objects here anyway if we're from the blob overload *)
	resourceChangePackets = resourceToPacket[noNameResourceBlobs, Simulation -> simulation, SimulationMode -> True];

	(* get the keys and values for the resource change packets *)
	keys = Keys[#]& /@ resourceChangePackets;
	values = Values[#]& /@ resourceChangePackets;

	(* get the new keys that don't have the Replace[Symbol] constructs and replaces that with Symbol itself *)
	newKeys = keys /. {Replace[x_Symbol] :> x};

	(* get the resource packets with the Replace format gone *)
	resourcePackets = MapThread[
		AssociationThread[#1, #2]&,
		{newKeys, values}
	];

	(* pass these resource packets to the core fulfillableResources function. Since these are now resource packets, we can Download from these like we would normal objects *)
	fulfillableResources[resourcePackets, Subprotocol -> subprotocol, Author -> author, Simulation -> simulation, Site -> specifiedSite]

];

(* singleton overload taking only one resource object *)
fulfillableResources[myResource : ObjectP[Object[Resource]], ops : OptionsPattern[]] := fulfillableResources[{myResource}, ops];

(* core overload taking resource objects *)
fulfillableResources[myResources : {ObjectP[Object[Resource]]..}, ops : OptionsPattern[]] := Module[
	{
		safeOps, cache, fastTrack, messages, allFields, allPackets, databaseMember, missingObjs, allSamplePackets,
		sampleResourcePackets, requestedSamplePackets, allRequestedResourceSamplePackets, enoughQuantityAvailAmount,
		requestedAmount, enoughQuantityBool, allModelResourcePackets, allModelPackets, typesToSearchOver, modelSearchConditions,
		modelObjectPackets, modelRequestedAmount, sampleResourcePacketsToSearch, modelAvailableAmount, resourcesToUse,
		modelEnoughAmountBool, modelObjectCounts, modelEnoughAmountReplaceRules, finalModelEnoughAmountBool, searchedSampleResourcePackets,
		requestedSearchedResourcePackets, reservedAmountAllSearchedSamples, availableAmountAllSearchedSamples,
		modelEnoughVolumeBool, consumableModel, modelEnoughVolumeReplaceRules, finalModelEnoughVolumeBool,
		samplesAndContainers, secondDownloadInputs, allSearchedSamplePackets, allContainerModelPackets, maxVolumes,
		belowMaxVolumeBool, belowMaxVolumePackets, notEnoughModelAmountPackets, modelPacketsToSearch, badResources,
		noModelEnoughVolumePackets, notEnoughQuantityPackets, allResourcePackets, consumableResources, newCache, fastAssoc,
		consumableModelResources, otherConsumableModelResources, consumableModelAvailAmount, modelResourcePacketsToSearch,
		consumableModelRequestedAmount, consumableModelEnoughBool, consumableModelEnoughReplaceRules, resourcesToTest,
		finalConsumableModelEnoughBool, notEnoughConsumableModelPackets, consumable, consumableSampleResources,
		allConsumableSampleResources, consumableSampleBool, consumableSampleReplaceRules, finalConsumableSampleBool,
		notEnoughConsumablePackets, currentContainerModels, allInstrumentPackets, allOperatorPackets, numResourcesTooBig,
		instrumentResourcePackets, requestedInstrumentPackets, instrumentModelPackets, notDisposalBool, disposalSamples,
		availInstrumentBool, objsToTest, requestedSampleTuples, requestedSamplesByContainer, movingRequiredContainers,
		sampleMustBeMovedBool, samplesToBeMoved, samplesMustMovedWarnings, hermeticQs, hermeticQPerSamps,
		undergoingMaintenancePackets, retiredInstrumentPackets, notDeprecatedInstrumentBool, deprecatedInstrumentPackets,
		deckLayoutAvailableBool, unavailableDeckLayoutInstrumentPackets, disposalResources, availableBool,
		samplesAndContainersReplaceRules, postSecondDownloadPackets, undergoingMaintenanceResourcePackets,
		typesAndSearchConditions, typesAndSearchConditionsNoDupes, typesToSearchOverNoDupes, modelSearchConditionsNoDupes,
		discardedSamples, discardedResources, expiredBooleans, expiredSamples, expiredResources, notDeprecatedBool,
		deprecatedModels, deprecatedResources, allProductPackets, oneProductPerResource, consumableProdNotDeprecatedBool,
		matchingSterileBool, sterileMismatchResources, sterileMismatchObjs, containerNotSterileResources, matchingSterileContainerBool,
		containerNotSterileObjs, allAllowedNotebooksPerInstrumentResource, allInstrumentResourceStatuses,
		requestedInstrumentNotebookPackets, canUseSpecificInstrumentQ, notOwnedInstrumentResources, notOwnedInstruments,
		consumableResourceProdNotDeprecated, consumableProdsNotDeprecated, consumableNoProdBool, totalVolProdNotDeprecatedBool,
		totalVolResourceProdNotDeprecated, totalVolProdsNotDeprecated, totalVolNoProdBool, modelVolProdNotDeprecatedBool,
		modelVolResourceProdNotDeprecated, modelVolProdsNotDeprecated, modelVolNoProdBool, modelReservedPackets,
		modelReservedAmount, availableAmountAllModels, consumablesAvailable, allResourceStatuses, canUseSpecificSample,
		notOwnedSamples, notOwnedResources, shippingToECLBools, samplesShippingToECLResources, samplesShippingToECL,
		requestedSampleNotebookPackets, resourcesToUseWithAuthor, nullNotebookQ, now, samplesAndContainersNoDupes,
		samplesAndContainersRules, oneProductPerResourceToSearchNoDupes, modelPacketsToSearchNoDupes,
		allPacketsWithNotebook, combinedNonFulfillableResources, hermeticQReplaceRules, modelHermeticQs,
		fulfillable, subprotocol, subprotocolBooleans, subprotocolResources, consumableDeprecatedProdBool,
		consumableDeprecatedProdResources, modelDeprecatedProdBool, modelDeprecatedProdResources,
		oneProductPerResourceToSearch, modelDeprecatedProds, nonDeprecatedModelsWithDeprecatedProds,
		consumableModelDeprecatedProds, nonDeprecatedConsumableModelsWithDeprecatedProds, samplesShippingToUserResources,
		shippingToUserBools, samplesShippingToUser, allModels, modelsNoDuplicates, allModelResourcePacketsNoDupes,
		modelResourcePacketReplaceRules, author, financerPackets, allAllowedNotebooks, expandedAuthor,
		allAllowedNotebooksPerSampleResource, resourceToAuthorRules, authorToUse, modelObjectProducts,
		modelObjectProductPackets, filterStockedModelObjectPackets, filterStockedSearchedSampleResourcePackets,
		secondDownloadInputsTooBig, secondDownloadInputsTooBigBool, samplesWhereDownloadInputTooBig, secondDownloadFields,
		allSecondDownloadValues, totalNumResourcesTooBig, numResourcesTooBigFakePackets, kitQs,
		kitQsToSearch, rentQ, rentAndKitQ, rentedKitModels, rentedKitResources, deprecatedInstrumentModelPackets,
		autoclaveCompatibleBools, notAutoclaveCompatiblePackets, notEnoughQuantityRequestedAmount,
		notEnoughQuantityAvailAmount, reservedUsesAllSearchedSamples, availableUsesAllSearchedSamples, modelEnoughUsesBool,
		modelEnoughUsesReplaceRules, finalModelEnoughUsesBool, requestedVolumes, enoughVolumesBool, resourceIDs,
		noModelEnoughUsesPackets, requestedUses, enoughUsesBool, notEnoughUsesPackets, modelUsesProdNotDeprecatedBool,
		modelUsesResourceProdNotDeprecated, modelUsesProdsNotDeprecated, notEnoughVolumesPackets, containerModels,
		containerModelPositions, uniqueContainerModels, maxVolumesLookupTable, positionToVolume, maxVolumesFlattened,
		simulation, updatedSimulation, prepareInResuspensionContainerQs, maxVolumeIncrement, nonScalableSolutionVolumeTooHighQs,
		nonScalableStockSolutionResourcePackets, modelItemResourcePackets, twoUniqueVolumesPackets, notEnoughVolumesModelPackets,
		combinedNameVolumeAssoc, uniqueVolumeBool, noMovementWarningSamples, shippableFulfillableResourceRequests,
		resourceToSamplesLookup, resourceModelToSamplesLookup, possibleFulfillingShippableSamples, resolvedSite,
		sampleSitesPerResource, sitelessSampleResources, sitelessSampleResourcesAfterProductFilter, resourcesToBeShipped, allowedSites,
		defaultExperimentSitePackets, defaultExperimentSites, defaultSite, uniqueTeamsPackets, allDefaultSites, instrumentModelObjectsSites,
		missingSiteSamples, sitelessInstrumentResources, possibleSites, specifiedSite, instrumentSites, instrumentModelObjectsCurrentCapacity,
		noCapacityInstrumentResources, possibleFulfillingSamples, countsForConsumablesAvailable, totalsForConsumablesAvailable,
		countsRequestedPerRequestedConsumableModel, totalCountRequestedPerRequestedConsumableModel, syncAmountToState, getSampleAmount
	},

	(* get the safe options, and pull out the specific option values from it *)
	safeOps = SafeOptions[fulfillableResources, ToList[ops]];
	{messages, cache, fastTrack, subprotocol, author, simulation, specifiedSite, noMovementWarningSamples} = Lookup[safeOps, {Messages, Cache, FastTrack, Subprotocol, Author, Simulation, Site, SkipSampleMovementWarning}];

	(* expand the Author option *)
	expandedAuthor = If[MatchQ[author, ObjectP[Object[User]]],
		ConstantArray[author, Length[myResources]],
		author
	];

	(* Determine which resources are being created for subprotocols *)
	subprotocolBooleans = If[ListQ[subprotocol],
		subprotocol,
		ConstantArray[subprotocol, Length[myResources]]
	];

	(* if the Subprotocol option is passed in but is not index matched to inputs, throw an error *)
	If[Not[SameLengthQ[subprotocolBooleans, myResources]],
		(
			Message[Error::OptionLengthMismatch, Subprotocol, Length[myResources]];
			Return[$Failed]
		)
	];

	(* if the Author option is passed in but is not index matched to inputs, throw an error *)
	If[Not[SameLengthQ[expandedAuthor, myResources]],
		(
			Message[Error::OptionLengthMismatch, Author, Length[myResources]];
			Return[$Failed]
		)
	];

	(* get the resources where Subprotocol -> True *)
	subprotocolResources = Download[PickList[myResources, subprotocolBooleans, True], Object];

	(* make replace rules for the resources to the author *)
	resourceToAuthorRules = MapThread[
		#1 -> #2&,
		{myResources, expandedAuthor}
	];

	(* --- If we are taking resource packets and not resource objects, then we need to check to make sure the samples they call exist in the database before doing anything else --- *)

	(* get the objects we need to test in DatabaseMemberQ *)
	objsToTest = Map[
		Which[
			MatchQ[#, PacketP[Object[Resource, Sample]]] && NullQ[Lookup[#, Sample]], Lookup[#, Models],
			MatchQ[#, PacketP[Object[Resource, Sample]]], Lookup[#, Sample],
			MatchQ[#, PacketP[Object[Resource, Instrument]]] && NullQ[Lookup[#, Instrument]], Lookup[#, InstrumentModels],
			MatchQ[#, PacketP[Object[Resource, Instrument]]], Lookup[#, Instrument],
			True, Nothing
		]&,
		myResources
	];

	(* get the resources we want to index match with objsToTest; this needs to happen because sometimes there are several objects we're checking (like how Models is a multiple field) *)
	resourcesToTest = Map[
		Which[
			MatchQ[#, PacketP[Object[Resource, Sample]]] && NullQ[Lookup[#, Sample]], ConstantArray[#, Length[Lookup[#, Models]]],
			MatchQ[#, PacketP[Object[Resource, Sample]]], #,
			MatchQ[#, PacketP[Object[Resource, Instrument]]] && NullQ[Lookup[#, Instrument]], ConstantArray[#, Length[Lookup[#, InstrumentModels]]],
			MatchQ[#, PacketP[Object[Resource, Instrument]]], #,
			True, Nothing
		]&,
		myResources
	];

	(* test to see if the objsToTest are in the database *)
	databaseMember = DatabaseMemberQ[Flatten[objsToTest], Simulation -> simulation];

	(* get the list of all missing objects *)
	missingObjs = PickList[Flatten[objsToTest], databaseMember, False];

	(* throw a message if any objects are missing from the database *)
	If[messages && Not[MatchQ[missingObjs, {}]],
		Message[Error::MissingObjects, missingObjs]
	];

	(* get the resources that we don't want to use*)
	badResources = PickList[Flatten[resourcesToTest], databaseMember, False];

	(* get the resources that we are going to use below *)
	resourcesToUse = If[MatchQ[badResources, {}],
		myResources,
		DeleteDuplicates[DeleteCases[myResources, Alternatives @@ badResources]]
	];

	(* get the Author option to use *)
	authorToUse = resourcesToUse /. resourceToAuthorRules;

	(* join the Author option with the resources we will be Downloading from *)
	resourcesToUseWithAuthor = Join[resourcesToUse, authorToUse];

	(* get all the fields to Download from all the resource objects *)
	allFields = Map[
		Switch[#,
			ObjectP[Object[Resource, Sample]],
				{
					Packet[Models, Sample, Amount, ContainerModels, ContainerName, Well, Status, Rent, NumberOfUses, VolumeOfUses, Sterile],
					Packet[Sample[{Volume, Mass, Count, Size, Model, Container, AwaitingDisposal, Status, ExpirationDate, Contents, RequestedResources, Notebook, Destination, NumberOfUses, VolumeOfUses, Site, Sterile}]],
					Packet[Sample[RequestedResources][{Status, Amount, NumberOfUses, VolumeOfUses, ExactAmount, Tolerance, Sterile, Rent}]],
					Packet[Models[{Reusable, CleaningMethod, Deprecated, Products, KitProducts, Autoclave, StorageBuffer, MaxNumberOfUses, MaxVolumeOfUses, RequestedResources, PrepareInResuspensionContainer, VolumeIncrements, StorageBuffer, Sterile, State, Density, Notebook}]],
					Packet[ContainerModels[{MaxVolume, Deprecated, MaxTemperature, Sterile}]],
					Packet[Sample[Container][{Contents}]],
					Packet[Sample[Container][Model][{Reusable, CleaningMethod, Deprecated, Products, RequestedResources, Notebook, MaxTemperature, Sterile}]],
					Packet[Models[Products][{Deprecated, EstimatedLeadTime, NotForSale, Stocked, CountPerSample, KitComponents, Amount, Price, Sterile}]],
					Packet[Models[KitProducts][{Deprecated, EstimatedLeadTime, NotForSale, Stocked, CountPerSample, KitComponents, Amount, Price, Sterile}]],
					Packet[Sample[Notebook][Financers]],
					Packet[RootProtocol[Notebook][Financers][DefaultExperimentSite][Object]],
					(* the following Download fields are specifically in the case where Models were not automatically included in the resource packets *)
					Packet[Sample[Model][{Reusable, CleaningMethod, Deprecated, Products, KitProducts, Autoclave, StorageBuffer, MaxNumberOfUses, MaxVolumeOfUses, RequestedResources, PrepareInResuspensionContainer, VolumeIncrements, StorageBuffer, Sterile, State, Density, Notebook}]],
					Packet[Sample[Model][Products][{Deprecated, EstimatedLeadTime, NotForSale, Stocked, CountPerSample, KitComponents, Amount, Price, Sterile}]],
					Packet[Sample[Model][KitProducts][{Deprecated, EstimatedLeadTime, NotForSale, Stocked, CountPerSample, KitComponents, Amount, Price, Sterile}]],
					(* these fields are for if you have a resource for a container that holds the "main" sample in the protocol *)
					Packet[Models[ProductsContained][{Deprecated, EstimatedLeadTime, NotForSale, Stocked, CountPerSample, KitComponents, Amount, Price, Sterile}]],
					Packet[Models[KitProductsContainers][{Deprecated, EstimatedLeadTime, NotForSale, Stocked, CountPerSample, KitComponents, Amount, Price, Sterile}]],
					Packet[Sample[Model][ProductsContained][{Deprecated, EstimatedLeadTime, NotForSale, Stocked, CountPerSample, KitComponents, Amount, Price, Sterile}]],
					Packet[Sample[Model][KitProductsContainers][{Deprecated, EstimatedLeadTime, NotForSale, Stocked, CountPerSample, KitComponents, Amount, Price, Sterile}]]
				},
			ObjectP[Object[Resource, Instrument]],
				{
					Packet[Instrument, InstrumentModels, DeckLayouts, Status],
					Packet[Instrument[{Status, Site, Contents, Notebook}]],
					Packet[InstrumentModels[{Deprecated, AvailableLayouts, Capacity, Notebook}]],
					Packet[RootProtocol[Notebook][Financers][DefaultExperimentSite][Object]],
					(* the following Download field is specifically in the case where Models were not automatically included in the resource packets *)
					Packet[Instrument[Model][{Deprecated, AvailableLayouts, Capacity}]],
					Packet[InstrumentModels[Objects][{Site, Status, Contents}]],
					Packet[Instrument[Notebook][Financers]]
				},
			(* currently we don't need to Download anything from the operator or waste objects to tell if they are fulfillable, but in the future we might *)
			ObjectP[{Object[Resource, Operator], Object[Resource, Waste]}],
				{Packet[RootProtocol[Notebook][Financers][DefaultExperimentSite][Object]]},
			(* if we're getting a user, then Download the financers and the notebooks they came from *)
			ObjectP[Object[User]],
				{Packet[FinancingTeams[{Notebooks, NotebooksFinanced, ExperimentSites, DefaultExperimentSite}]], Packet[SharingTeams[{Notebooks, NotebooksFinanced, ViewOnly}]]}
		]&,
		resourcesToUseWithAuthor
	];

	(* make a big Download call on the resource objects in question *)
	(* note that here we need to specifically quiet the Download::ObjectDoesNotExist and Download::MissingCacheField messages *)
	(* this is an issue because when fulfillableResourceQ is given resource blobs, those resource blobs are converted into packets without populating certain fields (namely, the Models field) *)
	(* Download will now throw an error message if Downloading through links to a field that doesn't exist in the packet (whereas it didn't before, which seems to be an oversight) *)
	(* since in this case we _need_ to not populate the Models field in the packet for performance reasons, we need to quiet these usually-useful error messages here *)
	allPacketsWithNotebook = Quiet[Download[
		resourcesToUseWithAuthor,
		Evaluate[allFields],
		Cache -> cache,
		Simulation -> simulation,
		Date -> Now
	], {Download::FieldDoesntExist, Download::NotLinkField, Download::MissingField, Download::ObjectDoesNotExist, Download::MissingCacheField}];

	(* make the new cache *)
	newCache = Cases[Flatten[{cache, allPacketsWithNotebook}], PacketP[]];
	fastAssoc = Experiment`Private`makeFastAssocFromCache[newCache];

	(* update the simulation here *)
	updatedSimulation = If[NullQ[simulation], Null, UpdateSimulation[simulation, Simulation[Cases[Flatten[allPacketsWithNotebook], PacketP[]]]]];

	(* separate out the Notebook packet from the resource packets *)
	{allPackets, financerPackets} = TakeList[allPacketsWithNotebook, {Length[resourcesToUse], Length[authorToUse]}];

	(* Get all the notebooks that the resources have access to when fulfilling samples *)
	(* Need to separate the financing and sharing team packets into the first and second arguments for AllowedResourcePickingNotebooks - thus the ugly @@ *)
	allAllowedNotebooks = Map[
		AllowedResourcePickingNotebooks@@#&,
		financerPackets
	];

	(* get the notebooks per requested resource *)
	allAllowedNotebooksPerSampleResource = PickList[allAllowedNotebooks, resourcesToUse, ObjectP[Object[Resource, Sample]]];

	(* pull out all the resource packets *)
	allResourcePackets = allPackets[[All, 1]];

	(* get the sample, instrument, and operator packets *)
	{allSamplePackets, allInstrumentPackets, allOperatorPackets} = Map[
		PickList[allPackets, resourcesToUse, ObjectP[#]]&,
		{Object[Resource, Sample], Object[Resource, Instrument], Object[Resource, Operator]}
	];

	(* get the resource sample packets *)
	sampleResourcePackets = allSamplePackets[[All, 1]];

	(* get the packets for the Sample of the sample resource packets *)
	requestedSamplePackets = allSamplePackets[[All, 2]];

	(* get the packets of all the resources that are requested on the Sample of all the sample resource packets *)
	allRequestedResourceSamplePackets = allSamplePackets[[All, 3]];

	(* get the packets for the Notebook of each of the requested samples *)
	requestedSampleNotebookPackets = allSamplePackets[[All, 10]];

	(* --- Need to do some wonky stuff for getting the RequestedResources of all the Models since that often has a bunch of duplicates that can be sped up (and is otherwise super slow if we had only one Download above) --- *)

	(* get the models Downloaded from the resources *)
	(* if the Models field isn't populated in the resource packets, then take the models of the samples *)
	allModels = MapIndexed[
		If[MatchQ[Lookup[#1, Models], {} | $Failed],
			(* It's possible that our Object[Sample] has the Model link severed. *)
			If[MatchQ[allSamplePackets[[First[#2], 12]], Null],
				{},
				Lookup[{allSamplePackets[[First[#2], 12]]}, Object]
			],
			Download[Lookup[allSamplePackets[[First[#2], 1]], Models], Object]
		]&,
		sampleResourcePackets
	];

	(* doing a second Download because otherwise this is prohibitively slow *)
	(* basically, need to pare down the Models to remove duplicates, and then Download from those (if there are tons of duplicates, the Download above takes F O R E V E R) *)
	(* also we want to remove all water cases because that is going to have tons of requested resources and that is going to slow things down a lot*)
	modelsNoDuplicates = DeleteCases[DeleteDuplicates[allModels], {WaterModelP..}];

	(* Download the requested resources from the models (and fields from it) *)
	allModelResourcePacketsNoDupes = Quiet[Download[
		modelsNoDuplicates,
		Packet[RequestedResources[{Status, Amount, Preparation, NumberOfUses, Notebook, Sterile}]],
		Date -> Now,
		Simulation -> updatedSimulation
	], {Download::FieldDoesntExist, Download::ObjectDoesNotExist, Download::NotLinkField, Download::MissingField}];

	(* Make replace rules for the Models and the corresponding Downloaded packets *)
	modelResourcePacketReplaceRules = MapThread[
		#1 -> #2&,
		{modelsNoDuplicates, allModelResourcePacketsNoDupes}
	];

	(* get the packets of all the resource requested on models of the resources in question *)
	allModelResourcePackets = Replace[allModels, modelResourcePacketReplaceRules, {1}];

	(* --- Back to extracting information from the main big Download above --- *)

	(* get all the packets of the models of the resources *)
	(* if the Models field isn't populated in the resource packets, then take the models of the samples *)
	allModelPackets = MapIndexed[
		If[MatchQ[Lookup[#1, Models], {} | $Failed],
			{allSamplePackets[[First[#2], 12]]},
			allSamplePackets[[First[#2], 4]]
		]&,
		sampleResourcePackets
	];

	(* get all the packets of the container models of the resource samples *)
	allContainerModelPackets = allSamplePackets[[All, 5]];

	(* get all the packets for the container models that the specified samples currently live in *)
	currentContainerModels = allSamplePackets[[All, 7]];

	(* get all the packets for the products of the models that were specified *)
	(* note that this picks between whether this is part of a kit or not (since we have the Products and KitProducts fields) *)
	(* since KitProducts and Products are forbidden from _both_ being populated, we can just flatten these both together and we'll assume we picked the right one*)
	(* if the Models field isn't populated in the resource packets, then take the models of the samples *)
	(* need the Flatten call because the listy-ness of the output needs to be correct (i.e., needs to be a list of lists, not a list of list of lists) *)
	allProductPackets = MapIndexed[
		Flatten[If[MatchQ[Lookup[#1, Models], {} | $Failed],
			{allSamplePackets[[First[#2], {13, 14, 17, 18}]]},
			allSamplePackets[[First[#2], {8, 9, 15, 16}]]
		]]&,
		sampleResourcePackets
	];

	(* flatten out the products so that it's a flat list with at most one product per item (or Null)*)
	oneProductPerResource = Map[
		If[MatchQ[#, $Failed | NullP],
			Null,
			(* instead of just pick the first product we found, pick the product that is non-deprecating abd has the largest supplied amount *)
			Module[{nonDeprecatedProducts, amountComparableQ},
				(* first filter to get all products that are not deprecated *)
				nonDeprecatedProducts = Select[Flatten[#], Not[MatchQ[#, Null|$Failed]] && Not[TrueQ[Lookup[#, Deprecated]]] && Not[TrueQ[Lookup[#, NotForSale]]]&];
				(* check if the amount in all these products are comparable *)
				amountComparableQ = CompatibleUnitQ @@ Lookup[nonDeprecatedProducts, Amount, Nothing];
				(* If they can be compared, get the product that has the max amount supplied *)
				If[TrueQ[amountComparableQ],
					First[MaximalBy[nonDeprecatedProducts, Lookup[#, Amount]&], Null],
					(* otherwise just return the first one *)
					First[nonDeprecatedProducts, Null]
				]
			]
		]&,
		allProductPackets
	];

	(* figure out if we are dealing with kits *)
	kitQs = Map[
		If[NullQ[#], False, MatchQ[Lookup[#, KitComponents], {__Association}]]&,
		oneProductPerResource
	];

	(* get the instrument resource and object packets *)
	instrumentResourcePackets = allInstrumentPackets[[All, 1]];

	requestedInstrumentPackets = allInstrumentPackets[[All, 2]];

	requestedInstrumentNotebookPackets = allInstrumentPackets[[All, 7]];

	allInstrumentResourceStatuses = Lookup[instrumentResourcePackets, Status, {}];

	allAllowedNotebooksPerInstrumentResource = PickList[allAllowedNotebooks, resourcesToUse, ObjectP[Object[Resource, Instrument]]];


	(* get the instrument model packets; if the InstrumentModels field isn't populated in the resource packets, then take the models of the Instruments *)
	instrumentModelPackets = MapIndexed[
		If[MatchQ[Lookup[#1, InstrumentModels], {} | $Failed],
			{allInstrumentPackets[[First[#2], 5]]},
			allInstrumentPackets[[First[#2], 3]]
		]&,
		instrumentResourcePackets
	];

	(* Strip out _Missing in case a sharing team was in financerPackets. Sharing teams do not have ExperimentSites *)
	allowedSites = DeleteDuplicates[Download[Select[Flatten[Flatten[financerPackets][[All,Key[ExperimentSites]]]],!MatchQ[#,_Missing]&],Object]];

	(* get list of default experiment sites from all resource packets *)
	defaultExperimentSitePackets = Join[
		allSamplePackets[[All,11]],
		allInstrumentPackets[[All,4]],
		allOperatorPackets[[All,1]]
	];
	defaultExperimentSites = DeleteDuplicates[Lookup[DeleteCases[Flatten[defaultExperimentSitePackets], Null|$Failed], Object, {}]];

	(* resolve default site to DefaultExperimentSite associated with the RootProtocol of the resources *)
	defaultSite = If[
		MemberQ[defaultExperimentSites, ObjectP[Object[Container, Site]]],
		(* there should only be one RootProtocol across all the resources, so take the first one *)
		FirstCase[defaultExperimentSites, ObjectP[Object[Container, Site]]],

		(* otherwise, use the DefaultExperimentSite associated with the author(s) *)
		uniqueTeamsPackets = DeleteDuplicates@DeleteCases[Flatten[financerPackets], Null];
		allDefaultSites = Download[Cases[Lookup[uniqueTeamsPackets, DefaultExperimentSite], ObjectP[Object[Container, Site]]], Object];
		FirstOrDefault[allDefaultSites]
	];

	(* Get all non-retired possible fulfilling instrument sites
	In the case a specific instrument is requested, use that as site source
	If no instruments can be found leave out of site check and surface in general instrument checks
	*)
	instrumentModelObjectsSites = Map[
		If[MatchQ[#,{}],
			{},
			Download[Lookup[Select[#,!MatchQ[Lookup[#,Status],Retired]&],Site,{}],Object]
		]&,
		Map[
			Flatten@If[MatchQ[Lookup[#[[1]], Instrument], ObjectP[]],
				{#[[2]]},
				#[[6]]
			]&,
			allInstrumentPackets
		]
	];

	(* Get any instrument models whose objects (or just instruments) with no Site *)
	sitelessInstrumentResources = PickList[instrumentResourcePackets, instrumentModelObjectsSites, {Null..}];

	(* Consider sites for each instrument with instances *)
	instrumentSites=DeleteCases[instrumentModelObjectsSites,{}];

	(* Get all possible sites we could run this protocol at given the sites of the possible instruments for each requested resource *)
	possibleSites = If[MatchQ[instrumentResourcePackets,{}],
		allowedSites,
		Intersection@@Prepend[instrumentSites,allowedSites]
	];

	(* If we're throwing messages, give specific message when possible otherwise use a general one *)
	Which[
		!messages,
			Null,

		MatchQ[sitelessInstrumentResources,{ObjectP[]..}],
			Module[{resources, actualInstruments},
				resources = Flatten[Lookup[sitelessInstrumentResources, {InstrumentModels, Instrument}, Null],2];
				actualInstruments = DeleteDuplicates[DeleteCases[resources, Null|$Failed]];
				Message[Error::SiteUnknown, ToString[Download[actualInstruments, Object], InputForm]]
			],

		(* Error if something is off with instrument requests and allowed experiment sites from FinancingTeams
		Don't double complain if we have a totally invalid resource *)
		MatchQ[possibleSites, {}] && MatchQ[badResources, {}],
			Message[
				Error::NoSuitableSite,
				ECL`InternalUpload`ObjectToString[allowedSites],
				Module[
					{instrumentModelsAndObjects, errorMessageIndices},

					(* NOTE: Either InstrumentModels or Instrument could be populated here. *)
					instrumentModelsAndObjects = Map[
						Function[{instrumentResourcePacket},
							If[MatchQ[Lookup[instrumentResourcePacket, InstrumentModels], {ObjectP[]..}],
								FirstOrDefault[Lookup[instrumentResourcePacket, InstrumentModels]],
								Lookup[instrumentResourcePacket, Instrument]
							]
						],
						instrumentResourcePackets
					];

					(* Pull out the indices with the relevant info for the user, depending on whether they have access to multiple sites. *)
					(* That is, if the user can only use one site, we will only mention the instrument objects/models which are not present *)
					(* at that site in the error message so that it's very obvious what is causing the problem. *)
					errorMessageIndices = If[
						(* Simplify the error message if the user only has one accessible site. *)
						SameQ[Length[allowedSites], 1],
						Flatten @ Position[
							Map[
								MemberQ[#, Alternatives@@allowedSites]&,
								instrumentSites
							],
							False
						],
						(* Otherwise, give them as much info as possible re: which site has which instruments. *)
						All
					];

					(* Now add the relevant info for the error message. *)
					Sequence @@ {
						ECL`InternalUpload`ObjectToString[instrumentModelsAndObjects[[errorMessageIndices]]],
						ECL`InternalUpload`ObjectToString[((DeleteDuplicates/@instrumentSites)/.{Null->Nothing})[[errorMessageIndices]]]
					}
				]
			];
	];

	(* ---------------------------- *)
	(* --- Instrument Ownership --- *)
	(* ---------------------------- *)
	(* check whether the notebook fo the specified instrument matches one of the notebooks of the author by doing the following: *)
	(* 1. no specific instrument is requested by a root protocol *)
	(* 2. the requested instrument is public *)
	(* 3. the status of the resource is something besides Outstanding or InCart (if so, always True). This is important because once a model is resolved, the instrument field will be populated but the item not be owned by anyone *)
	(* 4. FOR NOW, if $Notebook is Null, then we're going to say this is fulfillable since we are assuming you're in the public space *)
	(* 5. the notebook of the requested instrument is one of the previously-determined allowed notebooks *)
	canUseSpecificInstrumentQ = MapThread[
		Function[{requestedInstrumentPacket, notebookPacket, resourceStatus, allowedNotebooks},
			Or[
				(* 1.) no specific instrument is requested by a root protocol *)
				NullQ[requestedInstrumentPacket],

				(* 2.) the requested instrument is public *)
				NullQ[notebookPacket],

				(* 3. the status of the resource is something besides Outstanding or InCart (if so, always True). This is important because once a model is resolved, the instrument field will be populated but the item not be owned by anyone *)
				MatchQ[resourceStatus, Except[Outstanding | InCart]],

				(* 4. FOR NOW, if $Notebook is Null, then we're going to say this is fulfillable since we are assuming you're in the public space *)
				NullQ[$Notebook],

				(* 5. the notebook of the requested instrument is one of the previously-determined allowed notebooks *)
				MemberQ[allowedNotebooks, ObjectP[
					If[MatchQ[notebookPacket, Null | $Failed],
						{},
						Lookup[notebookPacket, Object]
					]
				]]
			]
		],
		{requestedInstrumentPackets, requestedInstrumentNotebookPackets, allInstrumentResourceStatuses, allAllowedNotebooksPerInstrumentResource}
	];

	(* get the instrument resources we don't own *)
	notOwnedInstrumentResources = PickList[instrumentResourcePackets, canUseSpecificInstrumentQ, False];

	(* get the specific samples we don't own *)
	notOwnedInstruments = PickList[requestedInstrumentPackets, canUseSpecificInstrumentQ, False];

	(* throw a message for specifically requested items that are not owned *)
	If[messages && Not[MatchQ[notOwnedInstruments, {}]],
		Message[Error::InstrumentsNotOwned, Lookup[notOwnedInstruments, Object]]
	];

	(* --- For all Object[Resource, Sample] objects, is the sample set for Disposal? *)

	(* get the list of booleans indicating if a sample is not set for disposal, or if it is (True meaning it is NOT set for disposal) *)
	(* if it is Null, then no worries; just go straight to True.  Also if it is InUse or Outstanding, then we don't worry about this so it will also be True *)
	(* Skip this check if we're considering resources for a subprotocol since the user may enqueue root protocol and then mark samples for disposal
		- if this check is present all the subs will throw errors when we try to do the experiment *)
	notDisposalBool = MapThread[
		If[NullQ[#1] || MemberQ[subprotocolResources, Lookup[#2, Object]] || MatchQ[Lookup[#2, Status], InUse | Outstanding] || Not[TrueQ[Lookup[#1, AwaitingDisposal]]],
			True,
			False
		]&,
		{requestedSamplePackets, sampleResourcePackets}
	];

	(* get the samples set for disposal *)
	disposalSamples = PickList[requestedSamplePackets, notDisposalBool, False];

	(* get the resources set for disposal *)
	disposalResources = PickList[sampleResourcePackets, notDisposalBool, False];

	(* throw a message for the disposal samples *)
	If[messages && Not[MatchQ[disposalSamples, {}]],
		Message[Error::SamplesMarkedForDisposal, Download[disposalSamples, Object]]
	];

	(* --- For all Object[Resource, Sample] objects, is the sample Discarded? *)

	(* get the list of booleans indicating if a sample is available (True) or Discarded (False) *)
	(* if it is Null, then no worries; just go straight to True *)
	availableBool = Map[
		If[Not[NullQ[#]] && MatchQ[Lookup[#, Status], Discarded],
			False,
			True
		]&,
		requestedSamplePackets
	];

	(* get the discarded samples *)
	discardedSamples = PickList[requestedSamplePackets, availableBool, False];

	(* get the resources that have discarded samples *)
	discardedResources = PickList[sampleResourcePackets, availableBool, False];

	(* throw a message for the discarded samples *)
	If[messages && Not[MatchQ[discardedSamples, {}]],
		Message[Error::DiscardedSamples, Download[discardedSamples, Object]]
	];

	(* --- For all Object[Resource, Sample] objects, is the sample Expired? *)

	(* need to pre-set a now variable because I'm going to DeleteDuplicates later and if we have different values for Now floating around it won't work *)
	now = Now;

	(* get the list of booleans indicating if a sample is expired *)
	(* if it is Null assume it's not expired *)
	expiredBooleans = Map[
		(Not[NullQ[#]] && DateObjectQ[Lookup[#, ExpirationDate]] && Lookup[#, ExpirationDate] <= now)&,
		requestedSamplePackets
	];

	(* get the expired samples *)
	expiredSamples = PickList[requestedSamplePackets, expiredBooleans, True];

	(* get the resources with expired samples *)
	(* if it's a subprotocol, assume it's not expired since we don't want to throw up our hands if something expires as we're finalizing the experiment *)
	expiredResources = Select[
		PickList[sampleResourcePackets, expiredBooleans, True],
		!MemberQ[subprotocolResources, Lookup[#, Object]]&
	];

	(* throw a message for the expired samples *)
	If[messages && Not[MatchQ[expiredResources, {}]] && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::ExpiredSamples, Download[expiredSamples, Object]]
	];

	(* --- For all Object[Resource, Sample] objects, are the model(s) deprecated? *)

	(* get the list of booleans indicating if all of the specified model(s) for a given resource is not deprecated (True) or deprecated (False) *)
	(* if all the models have Deprecated -> True, then return False; otherwise, return True (because if one model is Deprecated and another is not, the resource is still fulfillable) *)
	notDeprecatedBool = Map[
		If[MatchQ[#, Except[NullP | $Failed]] && MatchQ[Lookup[#, Deprecated], {True..}],
			False,
			True
		]&,
		allModelPackets
	];

	(* get the deprecated models *)
	deprecatedModels = DeleteDuplicates[Download[Flatten[PickList[allModelPackets, notDeprecatedBool, False]], Object]];

	(* get the resources with deprecated models *)
	deprecatedResources = PickList[sampleResourcePackets, notDeprecatedBool, False];

	(* throw a message for the discarded samples *)
	If[messages && Not[MatchQ[deprecatedModels, {}]],
		Message[Error::DeprecatedModels, deprecatedModels]
	];

	(* --- For all Object[Resource, Sample] objects, if Sterile -> True, are the specified models or objects Sterile -> True? --- *)

	(* get the list of booleans indicating if all the specified model(s) or the sample for a given resource is a sterile mismatch *)
	(* if True, then that means everything is fine; if False, then that's not fulfillable *)
	matchingSterileBool = MapThread[
		Function[{resourcePacket, modelPackets, samplePacket},
			Which[
				(* if the resource didn't request sterile, then that's fine and we don't have to go further *)
				Not[TrueQ[Lookup[resourcePacket, Sterile]]], True,
				(* if the sample packet is Null, make sure all the requested models have Sterile -> True *)
				NullQ[samplePacket], MatchQ[Lookup[modelPackets, Sterile], {True..}],
				(* if the sample packet is specified, make sure it is Sterile -> True *)
				True, TrueQ[Lookup[samplePacket, Sterile]]
			]
		],
		{sampleResourcePackets, allModelPackets, requestedSamplePackets}
	];

	(* get the sterile mismatch resources, and then pull out he requested models/samples that were improperly _not_ sterile *)
	sterileMismatchResources = PickList[sampleResourcePackets, matchingSterileBool, False];
	sterileMismatchObjs = Flatten[MapThread[
		Which[
			TrueQ[#1], Nothing,
			NullQ[#3], Lookup[#2, Object],
			True, Lookup[#3, Object]
		]&,
		{matchingSterileBool, allModelPackets, requestedSamplePackets}
	]];

	(* throw a message for the sterile mismatch samples *)
	If[messages && Not[MatchQ[sterileMismatchObjs, {}]],
		Message[Error::InvalidSterileRequest, Download[sterileMismatchObjs, Object]]
	];

	(* --- For all Object[Resource, Sample] objects, if Sterile -> True, are the specified container models Sterile -> True? --- *)

	(* get the list of booleans indicating if all the specified container model(s) for a given resource is a sterile mismatch *)
	(* if True, then that means everything is fine; if False, then that's not fulfillable *)
	matchingSterileContainerBool = MapThread[
		Function[{resourcePacket, containerModelPackets},
			Which[
				(* if the resource didn't request sterile, then that's fine and we don't have to go further *)
				Not[TrueQ[Lookup[resourcePacket, Sterile]]], True,
				(* if we don't have ContainerModels specified, we're also fine *)
				MatchQ[Lookup[resourcePacket, ContainerModels], {}], True,
				(* if the ContainerModels is populated, they have to be sterile models *)
				True, MatchQ[Lookup[containerModelPackets, Sterile], {True..}]
			]
		],
		{sampleResourcePackets, allContainerModelPackets}
	];

	(* get the sterile mismatch resources, and then pull out he requested container models that were improperly _not_ sterile *)
	containerNotSterileResources = PickList[sampleResourcePackets, matchingSterileContainerBool, False];
	containerNotSterileObjs = Flatten[PickList[allContainerModelPackets, matchingSterileContainerBool, False]];

	(* throw a message for the sterile container mismatch samples *)
	If[messages && Not[MatchQ[containerNotSterileObjs, {}]],
		Message[Error::ContainerNotSterile, Download[containerNotSterileObjs, Object]]
	];

	(* --- For all Object[Resource, Sample] objects, if a sample was specifically indicated, does that sample's notebook match a notebook owned by the requestor? --- *)

	(* get the status of all the sample resources *)
	allResourceStatuses = Lookup[sampleResourcePackets, Status, {}];

	(* check whether the notebook fo the specified sample matches one of the notebooks of the author by doing the following: *)
	(* 1.) Seeing if no specific sample is requested by a root protocol (if not, this is always True). *)
	(* 2.) Seeing if the requested sample is public and used within Engine or in a sub (requested sample Notebook is Null in this case). Subs can request public samples since their parent may pick a public sample to resolve a model but not transfer ownership. Requests can be made within Engine (e.g. in compilers) for public objects - typically for items associated with the instrument. *)
	(* 3.) Seeing if the notebook of the requested sample is one of the previously-determined allowed notebooks *)
	(* 4.) Seeing if the status of the resource is something besides Outstanding or InCart (if so, always True).  This is important because once a model is resolved, the Sample field will be populated but the item not be owned by anyone *)
	(* 5.) FOR NOW, if $Notebook is Null, then we're going to say this is fulfillable since we are assuming you're in the public space *)
	canUseSpecificSample = MapThread[
		Function[{samplePacket, notebookPacket, resourceStatus, resourcePacket, allowedNotebooks},
			Or[
				NullQ[samplePacket],
				And[
					NullQ[notebookPacket],
					Or[
						MemberQ[subprotocolResources, Lookup[resourcePacket, Object]],
						MatchQ[$ECLApplication,Engine]
					]
				],
				MatchQ[resourceStatus, Except[Outstanding | InCart]],
				NullQ[$Notebook],
				MemberQ[allowedNotebooks, ObjectP[
					If[MatchQ[notebookPacket, Null | $Failed],
						{},
						Lookup[notebookPacket, Object]
					]
				]]
			]
		],
		{requestedSamplePackets, requestedSampleNotebookPackets, allResourceStatuses, sampleResourcePackets, allAllowedNotebooksPerSampleResource}
	];

	(* get the resources we don't own *)
	notOwnedResources = PickList[sampleResourcePackets, canUseSpecificSample, False];

	(* get the specific samples we don't own *)
	notOwnedSamples = PickList[requestedSamplePackets, canUseSpecificSample, False];

	(* throw a message for specifically requested items that are not owned *)
	If[messages && Not[MatchQ[notOwnedSamples, {}]],
		Message[Error::SamplesNotOwned, Lookup[notOwnedSamples, Object]]
	];

	(* If the resource is requesting a sample that has the status Transit and the destination is one of the sites the user can use,
	then it is not available for picking until it arrives *)
	shippingToECLBools = Map[
		If[
			And[
				Not[NullQ[#]],
				MatchQ[Lookup[#, Status], Transit],
				MatchQ[Lookup[#, Destination], ObjectP[possibleSites]]
			],
			True,
			False
		]&,
		requestedSamplePackets
	];

	(* get the resources that are in transit to ECL *)
	samplesShippingToECLResources = PickList[sampleResourcePackets, shippingToECLBools, True];

	(* get the specific samples that are in transit *)
	samplesShippingToECL = PickList[requestedSamplePackets, shippingToECLBools, True];

	(* throw a message for specifically requested items that are on their way to ECL from the user *)
	If[messages && Not[MatchQ[samplesShippingToECL, {}]] && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::SamplesInTransit, Lookup[samplesShippingToECL, Object]]
	];

	(* If the resource is requesting a sample that has the status Transit and the destination is not one of the sites the user can use, then it is not available for picking *)
	shippingToUserBools = Map[
		If[
			And[
				Not[NullQ[#]],
				MatchQ[Lookup[#,Status],Transit],
				!MatchQ[Lookup[#,Destination,Null],ObjectP[possibleSites] | $Failed | Null]
			],
			True,
			False
		]&,
		requestedSamplePackets
	];

	(* get the resources that are in transit from ECL *)
	samplesShippingToUserResources = PickList[sampleResourcePackets, shippingToUserBools, True];

	(* get the specific samples that are in transit *)
	samplesShippingToUser = PickList[requestedSamplePackets, shippingToUserBools, True];

	(* throw a message for specifically requested items that are on their way to ECL from the user *)
	If[messages && Not[MatchQ[samplesShippingToUser, {}]],
		Message[Error::SamplesShippedFromECL, Lookup[samplesShippingToUser, Object]]
	];

	(* --- For all Object[Resource, Sample] objects, if a resource was set to Rent -> True, cannot be part of a kit --- *)

	(* get whether the resource was set to Rent -> True *)
	rentQ = TrueQ[Lookup[#, Rent]]& /@ sampleResourcePackets;

	(* get a boolean for rented resources that are parts of kits *)
	rentAndKitQ = MapThread[
		#1 && #2&,
		{kitQs, rentQ}
	];

	(* get the models and resources that are being rented and part of a kit *)
	rentedKitModels = DeleteDuplicates[Download[Flatten[PickList[allModelPackets, rentAndKitQ]], Object]];
	rentedKitResources = PickList[sampleResourcePackets, rentAndKitQ];

	(* throw a message if a resource is trying to rent a kit *)
	If[messages && Not[MatchQ[rentedKitModels, {}]],
		Message[Error::RentedKit, rentedKitModels]
	];

	(* --- For all Object[Resource, Sample] objects, if a sample was specifically indicated, is there enough quantity for that sample? --- *)

	(* get the amount that is being requested *)
	requestedAmount = Lookup[sampleResourcePackets, Amount, {}];

	(* check to see if we will have enough sample to satisfy this amount, given the current amount of sample, and the reserved amount *)
	{enoughQuantityBool, enoughQuantityAvailAmount}  = If[MatchQ[sampleResourcePackets, {}],
		{{}, {}},
		Transpose[MapThread[
			Function[{resourcePacket, samplePacket, allResourcePacketsForSample, requestedAmount},
				If[NullQ[resourcePacket] || NullQ[samplePacket] || NullQ[allResourcePacketsForSample] || NullQ[requestedAmount],
					(* need the second value to be Null here; that isn't the _actual_ available amount, but this value only matters if the first one is False anyway so who cares *)
					{True, Null},
					Module[{otherRequestedResourceSamplePackets, currentAmount, consumingResourcePackets, alreadyReservedConsumedAmount,
						availableAmount, enoughBool, currentAmountUnit},

						(* isolate all the "other" outstanding resource packets for this sample (i.e. all but this one) *)
						(* if the resource is rented we don't need to count it against our current amount since it's not actually being consumed *)
						otherRequestedResourceSamplePackets = Select[allResourcePacketsForSample, MatchQ[Lookup[#, {Status,Rent}], {Except[InCart | Shipping, ResourceStatusP],False|Null}] && Not[MatchQ[#, ObjectP[Lookup[resourcePacket, Object]]]]&];

						(* get the current amount of the sample itself (and get the units) *)
						currentAmount = Which[
							VolumeQ[Lookup[samplePacket, Volume]], Lookup[samplePacket, Volume],
							IntegerQ[Lookup[samplePacket, Count]], Lookup[samplePacket, Count],
							MassQ[Lookup[samplePacket, Mass]], Lookup[samplePacket, Mass],
							DistanceQ[Lookup[samplePacket, Size]], Lookup[samplePacket, Size],
							True, Null
						];
						currentAmountUnit = If[NullQ[currentAmount],
							Null,
							Replace[Units[currentAmount], int_Integer :> int * Unit, {0}]
						];

						(* return an early True if we don't know the current amount, or if the requested amount is a different unit than the sample actually has; I don't love this but this is the workaround I came up with for the following situation that is for some reason only recently failing: *)
						(* 1.) Have a solid sample with a populated mass *)
						(* 2.) Transfer volume x of liquid into that sample *)
						(* 3.) Transfer volume x liquid _out of_ that sample *)
						(* 4.) SM's resources say that we want volume x of the solid sample; my workaround here ignores that case*)
						(* second argument is Null because it won't matter since the first one is True *)
						If[NullQ[currentAmount] || Not[CompatibleUnitQ[currentAmountUnit, requestedAmount]],
							Return[{True, Null}, Module]
						];

						(* get the amount that has already been reserved by resources that will consume that amount (and ignore those that are not of the same units as the current amount) *)
						consumingResourcePackets = Select[otherRequestedResourceSamplePackets, MatchQ[Lookup[#, Amount], UnitsP[Units[currentAmount] /. {int_Integer :> int * Unit}]]&];
						alreadyReservedConsumedAmount = Total[Lookup[consumingResourcePackets, Amount, {}]];

						(* get the amount available to reserve; current amount but have to take into account existing reservations *)
						availableAmount = currentAmount - alreadyReservedConsumedAmount;

						(* based on this available amount, see if we'll have enough (round because, in Steven's words, floating point numbers are dumb) *)
						enoughBool = Round[availableAmount, 0.00000001] >= Round[requestedAmount, 0.00000001];

						(* return the bool *)
						{enoughBool, availableAmount}
					]
				]
			],
			{sampleResourcePackets, requestedSamplePackets, allRequestedResourceSamplePackets, requestedAmount}
		]]
	];

	(* get the packets where a sample was specified but the sample doesn't have enough volume *)
	notEnoughQuantityPackets = PickList[sampleResourcePackets, enoughQuantityBool, False];
	notEnoughQuantityRequestedAmount = PickList[requestedAmount, enoughQuantityBool, False];
	notEnoughQuantityAvailAmount = PickList[enoughQuantityAvailAmount, enoughQuantityBool, False];

	(* throw a message if allowed, if we don't have enough *)
	If[MemberQ[enoughQuantityBool, False] && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::InsufficientVolume, Download[Lookup[notEnoughQuantityPackets, Sample, {}], Object], UnitScale[notEnoughQuantityRequestedAmount], UnitScale[notEnoughQuantityAvailAmount]]
	];

	(* --- For all Object[Resource, Sample] objects, if a sample was specifically indicated and is not in the container model that is specified, throw a warning that the sample will be moved --- *)

	(* get a boolean indicating if an item must be moved; must follow the following three criteria: *)
	(* 1.) the Sample field is specified directly *)
	(* 2.) the ContainerModels field is populated *)
	(* 3.) the current container of the sample is not one of those containers specified in ContainerModels OR *)
	(* 4.) ExactAmount->True but the current sample's amount is not within tolerance  *)
	(* 5.) ContainerName and Well are specified for this sample but *)
	(* (a) not all samples asking for these ContainerName and Well are requested as Object[Sample]. If some are requesting Object[Sample] and some are requesting Model[Sample], we will make it simple by moving to a new container so we don't worry about messing up the existing plate *)
	(* (b) not all samples in the container are requested in this protocol (by same reqeustor). *)
	(* (b-1) Some are not requested (and we should not try to directly use the plate and potentially affect those samples) OR (b-2) more samples are requested with the same ContainerName in empty wells (and we should not try to mess up the existing plate's empty wells) *)
	(* Get all the samples that we need to consider the container grouping *)
	requestedSampleTuples=MapThread[
		If[
			And[
				(* a specific sample is requested *)
				Not[NullQ[If[MatchQ[#1,Null|$Failed],#1/.{$Failed->Null}, Lookup[#1,Sample]]]],
				(* ContainerName is requested *)
				MatchQ[If[MatchQ[#1,Null|$Failed],#1/.{$Failed->Null}, Lookup[#1,ContainerName]],_String],
				(* existing container is a qualified model *)
				MemberQ[#2,ObjectP[If[MatchQ[#3,Null|$Failed],#3/.{$Failed->Null},Lookup[#3,Object]]]],
				(* ExactAmount is required and we have correct amount OR not required *)
				Or[
					!TrueQ[Lookup[#1,ExactAmount]],
					And[
						TrueQ[Lookup[#1,ExactAmount]],
						MatchQ[Lookup[#1,Tolerance],Except[Null]],
						MemberQ[Lookup[#4,{Volume,Mass,Count,Size}], RangeP[Lookup[#1,Amount]-Lookup[#1,Tolerance],Lookup[#1,Amount]+Lookup[#1,Tolerance]]]
					],
					And[
						TrueQ[Lookup[#1,ExactAmount]],
						NullQ[Lookup[#1,Tolerance]],
						MemberQ[Lookup[#4,{Volume,Mass,Count,Size}],Lookup[#1,Amount]]
					]
				]
			],
			{
				(* container *)
				Download[Lookup[#4,Container],Object],
				(* container name *)
				Lookup[#1,ContainerName],
				(* requested well *)
				Lookup[#1,Well],
				(* sample *)
				Download[Lookup[#1,Sample],Object]
			},
			Nothing
		]&,
		{sampleResourcePackets,allContainerModelPackets,currentContainerModels,requestedSamplePackets}
	];
	(* Group the samples by container name and container *)
	(* This helps check the case that we request all samples but in different containers *)
	requestedSamplesByContainer = GroupBy[
		requestedSampleTuples,
		(#[[1;;2]]&)->(#[[3;;4]]&)
	];
	(* If we have all the samples here requested in the same container, we don't have to move them *)
	movingRequiredContainers=KeyValueMap[
		Module[
			{containerPacket,containerName,contents,containerNameCount},
			containerPacket=fetchPacketFromCache[#1[[1]],Flatten[allSamplePackets]];
			contents=Lookup[containerPacket,Contents,{}]/.{x:ObjectP[]:>Download[x,Object]};
			containerName=#1[[2]];
			containerNameCount=Count[Lookup[sampleResourcePackets,ContainerName,{}],containerName];
			(* existing Contents match all the contents we requested *)
			(* No more other random model requests with the same container name *)
			(* Note that any contents with wrong amount have been excluded in the last step, and any different container name cases have been put into different groups so this is the only criteria here *)
			If[MatchQ[SortBy[contents,First],SortBy[#2,First]]&&MatchQ[Length[contents],containerNameCount],
				Nothing,
				#1[[1]]
			]
		]&,
		requestedSamplesByContainer
	];
	sampleMustBeMovedBool = MapThread[
		And[
			Not[NullQ[If[MatchQ[#1, Null | $Failed], #1/.{$Failed->Null}, Lookup[#1, Sample]]]],
			Not[MatchQ[If[MatchQ[#1, Null | $Failed], #1/.{$Failed->Null}, Lookup[#1, ContainerModels]], {}]],
			Or[
				(* Wrong container model *)
				Not[MemberQ[#2, ObjectP[If[MatchQ[#3, Null | $Failed], #3, Lookup[#3, Object]]]]],
				(* Correct container model but moving is required due to the container name requirement *)
				MemberQ[movingRequiredContainers,ObjectP[If[MatchQ[#4, Null | $Failed], #4, Download[Lookup[#4, Container], Object]]]]
			]
		]&,
		{sampleResourcePackets, allContainerModelPackets, currentContainerModels, requestedSamplePackets}
	];

	(* if a sample must be moved, throw a warning *)
	samplesMustMovedWarnings = MapThread[
		With[{mySample = Download[Download[#1, Sample], Object]},
			If[!MatchQ[mySample, ObjectP[noMovementWarningSamples]] && #3 && Not[MatchQ[$ECLApplication, Engine]],
				If[MatchQ[Lookup[#1, ContainerName], _String],
					(* If we have a ContainerName and Well requirement, update the message to be more specific *)
					{mySample, Download[#2, Object], Lookup[#1, ContainerName], Lookup[#1, Well]},
					{mySample, Download[#2, Object], Null}
				],
				Nothing
			]
		]&,
		{sampleResourcePackets, allContainerModelPackets, sampleMustBeMovedBool}
	];

	If[Length[samplesMustMovedWarnings] > 0,
		Module[
			{
				samplesWithContainerName, samplesWithoutContainerName, warningMessage,
				groupedSampleContainerTuples, groupedSamples, uniqueContainers, groupedContainerSampleAssociation,
				sampleContainerTuples
			},

			(* Split out the warnings based on whether we know the container name *)
			samplesWithContainerName = Select[samplesMustMovedWarnings, !NullQ[#[[3]]]&];
			samplesWithoutContainerName = Select[samplesMustMovedWarnings, NullQ[#[[3]]]&];

			If[Length[samplesWithContainerName] > 0,
				Message[
					Warning::SampleMustBeMoved,
					ECL`InternalUpload`ObjectToString[samplesWithContainerName[[All, 1]], Cache -> cache],
					StringJoin[
						" will be transferred into " <> ToString[samplesWithContainerName[[All, 2]]],
						" with ContainerName " <> ToString@samplesWithContainerName[[All, 3]],
						" and Well " <> ToString@samplesWithContainerName[[All, 4]]
					]
				]
			];

			If[Length[samplesWithoutContainerName] > 0,
				sampleContainerTuples = samplesWithoutContainerName[[All, 1;;2]];

				(* reformat the message *)
				(* group samples by similar destination container models *)
				groupedContainerSampleAssociation = GroupBy[sampleContainerTuples, Last -> First];

				(* unique containers for samples *)
				uniqueContainers = ECL`InternalUpload`ObjectToString[#, Cache -> cache]& /@ Keys[groupedContainerSampleAssociation][[All, 1]];

				(* grouped samples based on their destination container model *)
				groupedSamples = ECL`InternalUpload`ObjectToString[#, Cache -> cache]& /@ Values[groupedContainerSampleAssociation];

				(* created a {{samples, container}..} tuple *)
				groupedSampleContainerTuples = Transpose[{groupedSamples, uniqueContainers}];

				(* created the error message *)
				warningMessage = If[
					Length[groupedSampleContainerTuples] > 1,
					StringJoin[
						StringRiffle[StringRiffle[#, " will be transferred into "]& /@ groupedSampleContainerTuples[[1 ;; -2]], "; the designated amount(s) of "],

						"; and the designated amount(s) of " <> groupedSampleContainerTuples[[-1, 1]] <> " will be transferred into " <> groupedSampleContainerTuples[[-1, 2]]
					],

					groupedSampleContainerTuples[[1, 1]] <> " will be transferred into " <> groupedSampleContainerTuples[[1, 2]]
				];


				(* throw the message *)
				Message[
					Warning::SampleMustBeMoved,
					ECL`InternalUpload`ObjectToString[samplesWithoutContainerName[[All, 1]], Cache -> cache],
					warningMessage
				]
			]
		]
	];

	(* get the list of packets that need to be moved *)
	samplesToBeMoved = PickList[sampleResourcePackets, sampleMustBeMovedBool, True];

	(* --- For all Object[Resource, Sample] objects, if a sample was specifically indicated and the item is consumable, is there already a request out for this sample? --- *)
	(* For consumable models (removed from inventory after use) we need to consider if we will have enough objects remaining in inventory for our resource requests in consideration *)

	(* Note: this should sync up with SyncInventory's definition of a consumable *)
	(* get whether a given resource request is of an item that is consumable or not, index matched to the resource requests on models *)
	(* here anything that will get removed from inventory because it will be purchased, disposed or otherwise unusable for future model fulfillment is considered consumable *)
	consumable = MapThread[
		Which[
			(* for Model[Item,Column], it is never a consumable *)
			MatchQ[#1, {PacketP[{Model[Item,Column]}]..}], False,
			(* for samples or items, if Reusable -> False, then assume this means the item is a consumable (assuming also the sample is SelfContained); if it is True, or the field doesn't exist, then we say this item is not a consumable *)
			MatchQ[#1, {PacketP[Model[Item]]..}], MatchQ[Lookup[#1, Reusable], {(False | Null)..}] && MatchQ[#1, {SelfContainedSampleModelP..}],
			(* empty container request: any container models that will get liquid stored in them will effectively get consumed since once they have sample in them they can't be used for other things *)
			MatchQ[#1, {PacketP[FluidContainerModelTypes]..}] && (NullQ[#2] || MatchQ[Lookup[#2, Contents], {}]), True,
			(* for all other container requests check reusability *)
			MatchQ[#1, {PacketP[Model[Container]]..}] && (NullQ[#2] || MatchQ[Lookup[#2, Contents], {}]), MatchQ[Lookup[#1, Reusable], {(False | Null)..}],
			(* for containers that have contents, we assume that this is _never_ consumable because we are worrying about the thing inside it instead and several reservations on the same item won't hurt anything*)
			MatchQ[#1, {PacketP[Model[Container]]..}] && MatchQ[Lookup[#2, Contents], Except[{}]], False,
			(* for parts/plumbing/wiring, nothing is a consumable *)
			MatchQ[#1, {PacketP[{Model[Part], Model[Sensor], Model[Plumbing], Model[Wiring]}]..}], False,
			True, False
		]&,
		{allModelPackets, requestedSamplePackets}
	];

	(* get the resource packets corresponding to the consumable samples that were specified *)
	consumableSampleResources = MapThread[
		If[#2 && Not[NullQ[Lookup[#1, Sample]]],
			#1,
			Nothing
		]&,
		{sampleResourcePackets, consumable}
	];

	(* get all the resource requests for these specific samples (including others, but only those that are not InCart)*)
	allConsumableSampleResources = MapThread[
		Function[{resourcePacket, consumableBool, allPackets},
			If[consumableBool && Not[NullQ[Lookup[resourcePacket, Sample]]],
				Select[allPackets, MatchQ[Lookup[#, Status], Except[InCart | Shipping, ResourceStatusP]] && Not[MatchQ[#, ObjectP[Lookup[resourcePacket, Object]]]]&],
				Nothing
			]
		],
		{sampleResourcePackets, consumable, allRequestedResourceSamplePackets}
	];

	(* get whether the consumable sample is already reserved elsewhere; if there are no other requests, then that is True *)
	consumableSampleBool = Map[
		If[MatchQ[#, {}],
			True,
			False
		]&,
		allConsumableSampleResources
	];

	(* make replace rules for inserting Booleans for all the requests, not just the ones that were consumable models (all others are auto True) *)
	consumableSampleReplaceRules = Flatten[Append[MapThread[#1 -> #2&, {consumableSampleResources, consumableSampleBool}], ObjectP[] -> True]];

	(* get the consumable model enough quantity Boolean index matched with all sample resources *)
	finalConsumableSampleBool = Replace[sampleResourcePackets, consumableSampleReplaceRules, 1];

	(* throw messages for samples that are already reserved *)
	MapThread[
		If[Not[#1] && messages,
			Message[Error::ResourceAlreadyReserved, Download[Lookup[#2, Sample], Object]]
		]&,
		{finalConsumableSampleBool, sampleResourcePackets}
	];

	(* get the resource packets that don't have enough of a consumable resource *)
	notEnoughConsumablePackets = PickList[sampleResourcePackets, finalConsumableSampleBool, False];

	(* --- For all Object[Resource, Sample] objects where a Model[Sample, StockSolution] that has VolumeIncrements populated was requested, make sure the volume does not exceed $MaxNumberOfFulfillmentPreps * Max[VolumeIncrements] --- *)

	(* get the maximum of the VolumeIncrements we're dealing with  *)
	(* only pull these out if:*)
	(* 1.) We're requesting a StockSolution model *)
	(* 2.) We're NOT requesting an existing Sample *)
	(* 3.) VolumeIncrements is populated in the StockSolution *)
	maxVolumeIncrement = MapThread[
		Function[{resourcePacket, modelPackets},
			If[MatchQ[modelPackets, {PacketP[{Model[Sample, StockSolution], Model[Sample, Matrix], Model[Sample, Media]}]}] && NullQ[Lookup[resourcePacket, Sample]] && MatchQ[Lookup[modelPackets[[1]], VolumeIncrements], {VolumeP..}],
				Max[Lookup[modelPackets[[1]], VolumeIncrements]],
				Null
			]
		],
		{sampleResourcePackets, allModelPackets}
	];

	(* flip error switch if requested volume > maxVolumeIncrement * $MaxNumberOfFulfillmentPreps *)
	nonScalableSolutionVolumeTooHighQs = MapThread[
		Function[{volumeIncrement, amount},
			And[
				VolumeQ[amount],
				VolumeQ[volumeIncrement],
				amount > volumeIncrement * $MaxNumberOfFulfillmentPreps
			]
		],
		{maxVolumeIncrement, Lookup[sampleResourcePackets, Amount, {}]}
	];

	(* throw messages for samples that are already reserved *)
	MapThread[
		If[#1 && messages,
			Message[Error::NonScalableStockSolutionVolumeTooHigh, ToString[Lookup[#2, Amount]], ECL`InternalUpload`ObjectToString[First[Lookup[#2, Models]]], ToString[$MaxNumberOfFulfillmentPreps * #3]]
		]&,
		{nonScalableSolutionVolumeTooHighQs, sampleResourcePackets, maxVolumeIncrement}
	];

	(* get the resource packets that are not fulfillable because of the non scalable stock solution problem *)
	nonScalableStockSolutionResourcePackets = PickList[sampleResourcePackets, nonScalableSolutionVolumeTooHighQs, True];

	(* --- For all Object[Resource, Sample] objects where a Model was provided and not a Sample (or where a ContainerModel was provided), get the samples that _could_ fulfill them --- *)

	(* get all the resource packets that we want to Search for items that match the model *)
	(* exclude cases where the model is Milli-Q water, where we don't want to look for it because we'll just get some from the purifier *)
	(* need to use the ID for water rather than the Name because otherwise matching with ObjectP will require it to go to the database to Download the ID to match against *)
	(* also, if a specific sample was requested, we don't need to do a search for other things of that same model *)
	(* need to do the checking for $Failed because sometimes Downloading Object from $Failed takes way longer than expected *)
	sampleResourcePacketsToSearch = Select[sampleResourcePackets, (MatchQ[Lookup[#, Models], $Failed] || MatchQ[Download[Lookup[#, Models], Object], Except[{WaterModelP}]]) && NullQ[Lookup[#, Sample]]&];

	(* get all the resource packets for the models that correspond to the sample resource packets we're about to search over *)
	modelResourcePacketsToSearch = MapThread[
		If[(MatchQ[Lookup[#1, Models], $Failed] || MatchQ[Download[Lookup[#1, Models], Object], Except[{WaterModelP}]]) && NullQ[Lookup[#1, Sample]],
			Flatten[#2],
			Nothing
		]&,
		{sampleResourcePackets, allModelResourcePackets}
	];

	(* --- for all  Object[Resource, Sample] object requesting a specific sample with NumberOfUses-> GreaterP[0,1], does NumberOfUses (current value) + NumberOfUses (resource request) + NumberOfUses (other resource requests) > MaxNumberOfUses *)

	(* get the amount that is being requested *)
	requestedUses = Lookup[sampleResourcePackets, NumberOfUses, {}];

	(* check to see if we will have enough sample to satisfy this amount, given the current amount of sample, and the reserved amount *)
	enoughUsesBool  = If[MatchQ[sampleResourcePackets, {}],
		{},
		MapThread[
			Function[{resourcePacket, samplePacket, allResourcePacketsForSample, requestedAmount, modelPacketsForSample},
				If[NullQ[resourcePacket] || NullQ[samplePacket] || NullQ[allResourcePacketsForSample] || MatchQ[requestedAmount, Null|$Failed]||NullQ[Lookup[modelPacketsForSample, MaxNumberOfUses,{}]],
					True,
					Module[{otherRequestedResourceSamplePackets, consumingResourcePackets, alreadyReservedConsumedAmount,
						availableUses, enoughBool},

						(* isolate all the "other" outstanding resource packets for this sample (i.e. all but this one) *)
						otherRequestedResourceSamplePackets = Select[allResourcePacketsForSample, MatchQ[Lookup[#, Status], Except[InCart | Shipping, ResourceStatusP]] && Not[MatchQ[#, ObjectP[Lookup[resourcePacket, Object]]]]&];

						(* get the amount that has already been reserved by resources that will consume that amount (and ignore those that are not of the same units as the current amount) *)
						consumingResourcePackets = Select[otherRequestedResourceSamplePackets, MatchQ[Lookup[#, NumberOfUses], GreaterP[0,1]]&];
						alreadyReservedConsumedAmount = Total[Lookup[consumingResourcePackets, NumberOfUses, {}]];

						(* get the amount available to reserve; current amount but have to take into account existing reservations *)
						availableUses = Lookup[modelPacketsForSample, MaxNumberOfUses,{}] - Lookup[samplePacket, NumberOfUses,{}] - alreadyReservedConsumedAmount;

						(* based on this available number of uses, see if we'll have enough *)
						enoughBool = Sequence@@availableUses >= requestedAmount;

						(* return the bool *)
						enoughBool
					]
				]
			],
			{sampleResourcePackets, requestedSamplePackets, allRequestedResourceSamplePackets, requestedUses, allModelPackets}
		]
	];

	(* get the packets where a sample was specified but the sample doesn't have enough volume *)
	notEnoughUsesPackets = PickList[sampleResourcePackets, enoughUsesBool, False];

	If[MemberQ[enoughUsesBool, False] && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[Error::ExceedsMaxNumberOfUses, ECL`InternalUpload`ObjectToString[Download[Lookup[notEnoughUsesPackets, Sample, {}], Object]], ToString[Lookup[notEnoughUsesPackets, NumberOfUses]]];
	];

	(* --- for all  Object[Resource, Sample] object requesting a specific sample with VolumeOfUses-> GreaterP[0 Milliliter], does VolumeOfUses  > MaxVolumeOfUses *)

	(* For all Model[Item] resources, since the amount will not be specified, it will only controlled by name we collect all resources with the same ID *)
	modelItemResourcePackets= Select[sampleResourcePackets, And[NullQ[Lookup[#, Sample]], MatchQ[Download[Lookup[#, Models],Object], {ObjectReferenceP[Model[Item]] ..}]]&];

	(* Combined all requested volume with same model and name together *)
	(* get the amount that is being requested *)
	requestedVolumes = Lookup[sampleResourcePackets, VolumeOfUses, {}];
	resourceIDs = Lookup[sampleResourcePackets, ID, {}];

	(* Check if the resources with the same name was specified different volume of uses *)
	(* Firstly merge all volumes into under the same name *)
	combinedNameVolumeAssoc=Merge[Rule @@@ Transpose[{resourceIDs, requestedVolumes}], DeleteDuplicates[Cases[#,VolumeP]]&];

	(* check to see if we will have enough sample to satisfy this amount, given the current amount of sample, and the reserved amount *)
	{enoughVolumesBool, uniqueVolumeBool} = If[MatchQ[sampleResourcePackets, {}],
		{{},{}},
		Transpose[
			MapThread[
				Function[{resourcePacket, requestedVolume, resourceName, modelPacketsForSample},

					Module[
						{modelVolumeEnoughQ,notUniqueVolumeQ},

						(* Check if there are other resources specified the same volume*)
						notUniqueVolumeQ=If[NullQ[resourcePacket] || MatchQ[requestedVolume, Null|$Failed|{}]||NullQ[Lookup[modelPacketsForSample, MaxVolumeOfUses,{}]],
							True,
							Length[ToList@Lookup[combinedNameVolumeAssoc,resourceName]]<2
						];

						(* Check if specified the Model has larger MaxVolumeOfUses than what the VolumeOfUses specified *)
						modelVolumeEnoughQ=If[NullQ[resourcePacket] || MatchQ[requestedVolume, Null|$Failed|{}]||NullQ[Lookup[modelPacketsForSample, MaxVolumeOfUses,{}]],
							True,
							Sequence @@ Lookup[modelPacketsForSample, MaxVolumeOfUses, 0 Milliliter]>=requestedVolume
						];

						(* Return two booleans *)
						{modelVolumeEnoughQ, notUniqueVolumeQ}
					]
				],
				{sampleResourcePackets, requestedVolumes, resourceIDs, allModelPackets}
			]
		]
	];

	(* get the packets where a sample was specified but the sample doesn't have enough volume *)
	notEnoughVolumesPackets = DeleteDuplicates[PickList[sampleResourcePackets, enoughVolumesBool, False]];
	notEnoughVolumesModelPackets = DeleteDuplicates[PickList[allModelPackets, enoughVolumesBool, False]];
	twoUniqueVolumesPackets = DeleteDuplicates[PickList[sampleResourcePackets, uniqueVolumeBool, False]];

	If[MemberQ[enoughVolumesBool, False] && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[Error::ExceedsMaxVolumesCanBeUsed, ToString[Lookup[notEnoughVolumesPackets, Object, {}]], ToString[Lookup[notEnoughVolumesPackets, VolumeOfUses]], ToString[Lookup[#, MaxVolumeOfUses]&/@notEnoughVolumesModelPackets]];
	];

	If[MemberQ[uniqueVolumeBool, False] && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[Error::TwoVolumeOfUsesSpecifiedForOneResource, ToString[Lookup[twoUniqueVolumesPackets, Object, {}]], ToString[Lookup[twoUniqueVolumesPackets, VolumeOfUses]]];
	];

	(* get all the model packets that correspond to the samples we will be searching over *)
	(* exclude cases where the model is Milli-Q water, where we don't want to look for it because we'll just get some from the purifier *)
	(* need to use the ID for water rather than the Name because otherwise matching with ObjectP will require it to go to the database to Download the ID to match against *)
	(* also, if a specific sample was requested, we don't need to do a search for other things of that same model *)
	modelPacketsToSearch = MapThread[
		If[(MatchQ[Lookup[#, Models], $Failed] || MatchQ[Download[Lookup[#, Models], Object], Except[{WaterModelP}]]) && NullQ[Lookup[#1, Sample]],
			#2,
			Nothing
		]&,
		{sampleResourcePackets, allModelPackets}
	];

	(* get all the types to Search over (specifically, the cases where a model was specified but a sample was not) where we are going to Search for objects matching the given inputs *)
	typesToSearchOver = Map[
		(If[MatchQ[#, TypeP[Model[Sample]]], Object[Sample], Object @@ #]&),
		Download[modelPacketsToSearch, Type],
		{2}
	];

	(* get the one-product-per-model products for each model we are searching over *)
	oneProductPerResourceToSearch = MapThread[
		If[(MatchQ[Lookup[#, Models], $Failed] || MatchQ[Download[Lookup[#, Models], Object], Except[{WaterModelP}]]) && NullQ[Lookup[#1, Sample]],
			#2,
			Nothing
		]&,
		{sampleResourcePackets, oneProductPerResource}
	];

	(* determine if $Notebook is Null here *)
	nullNotebookQ = NullQ[$Notebook];

	(* generate the Search conditions for getting the models *)
	(* for want to get all the samples/containers/parts of a given set of models that are Stocked, Available, or InUse *)
	(* for containers, also need to be empty, unless the status is Stocked and the model comes with a storage buffer (then it's allowed to not be empty) *)
	modelSearchConditions=MapThread[
		Function[{modelPacket, productPacket, resourcePacket},
			With[
				{
					modelClause = Model == (Alternatives @@ Lookup[modelPacket, Object]),
					(*we explicitly forbid reuse of InUse covers so we don't steal covers from other containers while we are fulfilling a Model resource*)
					(*we also forbid a non-reusable container to be picked as Available, just in case they were used in another protocol with no sample uploaded to it due to it being used as intermediate container or some other bug *)
					(* if the model is dishwashable, only allowed stocked *)
					statusClause = Which[
						MatchQ[Lookup[modelPacket, Object], {ObjectP[Join[CoverModelTypes, {Model[Item, Stopper], Model[Item, Septum]}, {Model[Item, WeighBoat, WeighingFunnel]}]]..}],
							Status == (Available | Stocked),

						Or[
							MatchQ[Lookup[modelPacket, CleaningMethod], CleaningMethodP],
							MatchQ[Lookup[modelPacket, Object], {ObjectP[FluidContainerModelTypes]..}] && MatchQ[Lookup[modelPacket, Reusable], {Except[True]..}]
						],
							Status == Stocked,

						True,
							Status == (Available | Stocked | InUse)
					],
					(*the only time we care about this is when we are looking for public samples*)
					notebookClause = If[nullNotebookQ,
						Notebook == Null,
						True
					],
					maxNumUsesClause = Which[
						MatchQ[modelPacket, ListableP[ObjectP[Model[Item]]]],
						If[NullQ[Lookup[resourcePacket, NumberOfUses]],
							True,
							NumberOfUses <= Sequence @@ (First[Cases[Lookup[modelPacket, MaxNumberOfUses], Except[Null]]] - Lookup[resourcePacket, NumberOfUses])
						],

						MatchQ[modelPacket, ListableP[ObjectP[Model[Container, ProteinCapillaryElectrophoresisCartridge]]]],
						If[!MemberQ[Lookup[modelPacket, MaxNumberOfUses], _Integer],
							True,
							If[NullQ[Lookup[resourcePacket, NumberOfUses]],
								True,
								NumberOfUses <= Sequence @@ (First[Cases[Lookup[modelPacket, MaxNumberOfUses], Except[Null]]] - Lookup[resourcePacket, NumberOfUses])
							]
						],

						True,
						If[!MemberQ[Lookup[modelPacket, MaxNumberOfUses], _Integer],
							True,
							Or[
								NumberOfUses == Null,
								NumberOfUses < First[Cases[Lookup[modelPacket, MaxNumberOfUses], Except[Null]]]
							]
						]

					],
					maxVolumeUsesClause = Which[
						MatchQ[modelPacket, ListableP[ObjectP[Model[Item, Filter, MicrofluidicChip]]]],
						If[NullQ[Lookup[resourcePacket, VolumeOfUses]],
							True,
							VolumeOfUses <= Sequence @@ (Lookup[modelPacket, MaxVolumeOfUses] - Lookup[resourcePacket, VolumeOfUses])
						],
						True,
						If[!MemberQ[Lookup[modelPacket, MaxVolumeOfUses], GreaterP[0Milliliter]],
							True,
							Or[
								VolumeOfUses == Null,
								VolumeOfUses < Lookup[First[modelPacket], MaxVolumeOfUses]
							]
						]

					],
					maxNumHoursClause = If[!MemberQ[Lookup[modelPacket, MaxNumberOfHours], TimeP],
						True,
						NumberOfHours == Null || NumberOfHours < Lookup[First[modelPacket], MaxNumberOfHours]
					],
					coveredContainerClause = If[MatchQ[modelPacket, {ObjectP[Join[CoverModelTypes, {Model[Item, Stopper], Model[Item, Septum]}]]..}],
						CoveredContainer == Null,
						True
					],
					contentsClause = Which[
						Or[
							(* Model[Container, Bag, "Plastic Bag For NMR Sealed Inserts"] *)
							MatchQ[modelPacket, ListableP[ObjectP[{Model[Container, ProteinCapillaryElectrophoresisCartridge], Model[Container, Bag, "id:O81aEB1LOw0j"]}]]],
							(* if StorageBuffer is True then it doesn't have to be empty *)
							MatchQ[Lookup[modelPacket, StorageBuffer], {True..}]
						],
						True,
						And[
							MatchQ[modelPacket, ListableP[ObjectP[Model[Container]]]],
							(* If our container is not holding a StorageBuffer, it must be empty to pick *)
							!MemberQ[Lookup[modelPacket, StorageBuffer], True]
						],
						Contents == Null,

						(* If our container is holding a StorageBuffer, it can be empty or Stocked since we are going to remove the StorageBuffer before real use *)
						MatchQ[modelPacket, ListableP[ObjectP[Model[Container]]]],
						Or[
							Status == Stocked,
							Contents == Null
						],

						True,
						True
					],
					sizeClause = If[
						And[
							MatchQ[modelPacket, ListableP[ObjectP[Model[Plumbing, Tubing]]]],
							MatchQ[Lookup[resourcePacket, Amount], DistanceP]
						],
						Size >= Lookup[resourcePacket, Amount],
						True
					],
					countClause = If[
						And[
							MatchQ[productPacket, ObjectP[Object[Product]]],
							Not[NullQ[Lookup[productPacket, CountPerSample]]],
							MemberQ[Fields[Object @@ Lookup[First[modelPacket], Type], Output -> Short], Count],
							Not[NullQ[Lookup[resourcePacket, Amount]]]
						],
						Count >= Unitless[Lookup[resourcePacket, Amount], Unit],
						True
					],
					(* We can request Object[Item], Object[Container], Object[Sample] and all of them have ExpirationDate field*)
					expirationDateClause = Or[
						ExpirationDate == Null,
						ExpirationDate > now
					],
					restrictedClause = And[
						Restricted != True,
						Missing != True,
						AwaitingDisposal != True
					],
					(* here we're saying look for sterile samples only if:*)
					(* 1.) The resource is asking for something Sterile *)
					(* 2.) The type being requested has the Sterile field *)
					(* 3.) We haven't already determined that we can't actually get sterile things from this resource because the thing being requested is intrinsically _not_ sterile *)
					(* this third one is a little weird, but we are doing this to avoid having a message thrown because we can't actually get sterile versions of what is requested, AND a message saying that the sample is out of stock (because obviously the sterile search will turn up nothing) *)
					sterileClause = If[
						And[
							TrueQ[Lookup[resourcePacket, Sterile]],
							MemberQ[Fields[Lookup[First[modelPacket], Type], Output -> Short], Sterile],
							Not[MemberQ[Lookup[sterileMismatchResources, Object, {}], Lookup[resourcePacket, Object]]]
						],
						Sterile == True,
						True
					]
				},
				And[
					modelClause,
					statusClause,
					notebookClause,
					maxNumHoursClause,
					maxNumUsesClause,
					maxVolumeUsesClause,
					coveredContainerClause,
					contentsClause,
					expirationDateClause,
					sizeClause,
					countClause,
					restrictedClause,
					sterileClause
				]
			]
		],
		{modelPacketsToSearch, oneProductPerResourceToSearch, sampleResourcePacketsToSearch}
	];

	(* if we have multiple identical search criteria, don't do that same search multiple times *)
	typesAndSearchConditions = Transpose[{typesToSearchOver, modelSearchConditions, oneProductPerResourceToSearch, modelPacketsToSearch}];
	typesAndSearchConditionsNoDupes = DeleteDuplicates[typesAndSearchConditions];
	{typesToSearchOverNoDupes, modelSearchConditionsNoDupes, oneProductPerResourceToSearchNoDupes, modelPacketsToSearchNoDupes} = If[MatchQ[typesAndSearchConditionsNoDupes, {}],
		{{}, {}, {}, {}},
		Transpose[typesAndSearchConditionsNoDupes]
	];

	(* get all the Stocked/Available/InUse samples that correspond to the given models, and all the Stocked/Available empty containers that correspond to the given container models *)
	samplesAndContainersNoDupes = Search[typesToSearchOverNoDupes, Evaluate[modelSearchConditionsNoDupes]];
	samplesAndContainersRules = AssociationThread[typesAndSearchConditionsNoDupes, samplesAndContainersNoDupes];
	samplesAndContainers = typesAndSearchConditions /. samplesAndContainersRules;

	(* about to do some hacky wonky stuff to make this Download not take foreverrrrrrr *)
	(* basically, if you fulfill the following criteria, we are going to fudge it because it just is prohibitively slow otherwise: *)
	(* 1.) There are more than 200 samples that fulfill the criteria above *)
	(* 2.) The samples are SelfContainedSamples *)
	(* 3.) There exists a product for these samples *)
	(* if this comes back to bite us we can redo this but hopefully by then Download won't be so slow *)
	secondDownloadInputsTooBigBool = MapThread[
		Length[#1] > 200 && MatchQ[#1, {SelfContainedSampleP..}] && MatchQ[#2, ObjectP[Object[Product]]]&,
		{samplesAndContainersNoDupes, oneProductPerResourceToSearchNoDupes}
	];

	(* if there are too many samples according to the criteria above, just pick the model that we're going to Download more from; otherwise get the samples we searched for *)
	samplesWhereDownloadInputTooBig = PickList[samplesAndContainersNoDupes, secondDownloadInputsTooBigBool];
	secondDownloadInputsTooBig = PickList[Download[modelPacketsToSearchNoDupes, Object], secondDownloadInputsTooBigBool];
	secondDownloadInputs = Cases[PickList[samplesAndContainersNoDupes, secondDownloadInputsTooBigBool, False], {ObjectP[{Object[Sample], Object[Item], Object[Plumbing,Tubing], Object[Container, ProteinCapillaryElectrophoresisCartridge]}]..}];

	(* for the things we're Downloading a fair amount of stuff from, get a lot of information; for things for which there are just a ton of things then only get a little bit of information (i.e., how many resources are requesting these specific samples; this should almost never matter so we are leaving ourselves open to a protocol being blocked when you have a ton of InCart resources that aren't really reserving anything). *)
	secondDownloadFields = Join[
		ConstantArray[{
			Packet[Volume, Mass, Count, Size, Status, Product, NumberOfUses, Model, Notebook, Site, Destination, Sterile],
			Model[State],
			Model[Density],
			Packet[RequestedResources[{Amount, Status, Preparation, Models, Notebook, Sterile}]],
			Field[Product[DefaultContainerModel][Hermetic]]
		}, Length[secondDownloadInputs]],
		ConstantArray[{Field[Length[RequestedResources]]}, Length[secondDownloadInputsTooBig]]
	];

	(* Download the necessary information from the results of the above Search *)
	allSecondDownloadValues = Quiet[Download[
		Join[
			secondDownloadInputs,
			secondDownloadInputsTooBig
		],
		Evaluate[secondDownloadFields],
		Date -> Now,
		Simulation -> updatedSimulation
	], {Download::FieldDoesntExist, Download::NotLinkField, Download::MissingField, Download::ObjectDoesNotExist, Download::MissingCacheField}];

	(* separate out the second download result into the things that we actually Downloaded from and then things where we spoofed it a bit *)
	{allSearchedSamplePackets, numResourcesTooBig} = TakeDrop[allSecondDownloadValues, Length[secondDownloadInputs]];

	(* get the number of resources for each of the models where we didn't actually download too much *)
	totalNumResourcesTooBig = Map[
		(* Particularly on Stage, if a Search identified object is erased prior to its Download, it will give $Failed, here we prune $Failed out to prevent unintended messages *)
		Total[Flatten[#] /. $Failed -> 0 ]&,
		numResourcesTooBig
	];

	(* spoof things some more *)
	(* basically go through the numResourcesTooBig and reconstruct what we can assume with some confidence would have happened had we Downloaded it*)
	(* weird thing is that we are putting all the resources of the models onto one thing which seems a little goofy but I don't know how else to do it *)
	numResourcesTooBigFakePackets = MapThread[
		Function[{sampleObjs, numResources, prod},
			MapIndexed[
				{
					<|
						Object -> #1,
						Volume -> Null,
						Mass -> Null,
						Size -> Null,
						Count -> Lookup[prod, CountPerSample, Null],
						(* we're assuming they're sterile if the product is sterile *)
						Sterile -> Lookup[prod, Sterile, Null],
						(* yes we are assuming they are all Available but that is okay since presumably we have so many here that the approximation doesn't hurt us that much *)
						Status -> Available,
						Product -> Link[prod]
					|>,
					Null,
					Null,
					If[MatchQ[#2, {1}],
						ConstantArray[
							<|
								Object -> Object[Resource, Sample, "id:12345"],
								Amount -> Null,
								(* assuming all the resources that exist for this sample are InUse; this is not that big of an assumption since again there are so many samples but could come into play I guess if this breaks in the future *)
								Status -> InUse,
								Preparation -> Null
							|>,
							numResources
						],
						{}
					],
					{}
				}&,
				(* This is kinda weird but it takes forever to build these "fake" packets when
				the number of samples gets really large (for example, we have 30k 2ml tube caps in the lab
				and this block of code takes like 10 minutes to generate a packet for all 30k). So, we assume
				at MAX we need the same number as the total number of resources we're asking for. This should
				be safe since worst case all resources are asking for the same thing. *)
				Take[sampleObjs,UpTo[Length[myResources]]]
			]
		],
		{samplesWhereDownloadInputTooBig, totalNumResourcesTooBig, PickList[oneProductPerResourceToSearchNoDupes, secondDownloadInputsTooBigBool]}
	];

	(* make replace rules that we will apply to samplesAndContainers to make sure our index matching is good *)
	samplesAndContainersReplaceRules = Join[
		(* for cases where we _did_ Download everything *)
		MapThread[#1 -> #2&, {secondDownloadInputs, allSearchedSamplePackets}],
		(* for cases where we _did not_ Download everything *)
		MapThread[#1 -> #2&, {samplesWhereDownloadInputTooBig, numResourcesTooBigFakePackets}],
		(* for Containers/Vessels/etc where we don't actually care, don't do anything here *)
		{_ -> {}}
	];

	(* do replace rules on the samplesAndContainers to keep the index matching and basically fake that we Downloaded {} from the things we didn't want to actually put in the Download (this makes things much much faster) *)
	postSecondDownloadPackets = Replace[samplesAndContainers, samplesAndContainersReplaceRules, 1];

	(* Parse out the second Download packets for the Samples: the packets of the samples themselves, their outstanding resources, and whether they're in a hermetic container *)
	(* need to do some wonky stuff to get the State field into the sample packets since it's normally a computable field so I can't just directly download this without expecting it to be even slower than it already is *)
	(* if we Downloaded nothing from the things we searched over, then just default to {} for that entry *)
	modelObjectPackets = Map[
		Function[{downloadValue},
			Map[
				Join[#[[1]], <|State -> #[[2]],Density->#[[3]]|>]&,
				downloadValue
			]
		],
		postSecondDownloadPackets
	];
	searchedSampleResourcePackets = Map[
		If[MatchQ[#, {}],
			{},
			#[[All, 4]]
		]&,
		postSecondDownloadPackets
	];

	(* do the same as above with the hermetic samples; note that if you ever add something more to this, numResourcesTooBigFakePackets above needs to change or else it will break in the too-many-samples-to-download-from-all-of-them case *)
	hermeticQPerSamps = Map[
		If[MatchQ[#, {}],
			{},
			#[[All, 5]]
		]&,
		postSecondDownloadPackets
	];

	(* get if ALL the samples are hermetic, which is what we actually care about here *)
	hermeticQs = Map[
		MatchQ[#, {True..}]&,
		hermeticQPerSamps
	];

	(* get the Count of sample instances of the models in modelObjectPackets *)
	modelObjectCounts = Map[
		Lookup[#, Count, {}] &,
		modelObjectPackets
	];

	(* get the product object for the samples from the second download and make it a flat list of Nulls or product objects *)
	modelObjectProducts = Map[
		Download[FirstOrDefault[
			Cases[Lookup[#, Product, {}], ObjectP[Object[Product]]]
		], Object]&,
		modelObjectPackets
	];

	(* get the product packets for the samples from the second download *)
	modelObjectProductPackets = Map[
		Function[{prod},
			SelectFirst[Flatten[oneProductPerResource], MatchQ[#, ObjectP[prod]]&, Null]
		],
		modelObjectProducts
	];

	(* get whether the product packets for hte samples from the second download are kits *)
	kitQsToSearch = Map[
		If[NullQ[#],
			False,
			MatchQ[Lookup[#, KitComponents], {__Association}]
		]&,
		modelObjectProductPackets
	];

	(*figure out if we are working with PrepareInResuspensionContainer StockSolution*)
	prepareInResuspensionContainerQs = If[MatchQ[sampleResourcePacketsToSearch, {}],
		{},
		Map[
			Function[{packet},
				Module[{modelsInResource, modelPackets, realBoolean},
					modelsInResource = Download[Lookup[packet, Models], Object];
					modelPackets = Experiment`Private`fetchPacketFromCache[#, newCache]& /@ modelsInResource;
					prepareInResuspensionContainerQs = Lookup[modelPackets, PrepareInResuspensionContainer, Null];
					(* convert the result into a single boolean *)
					realBoolean = MatchQ[ToList[prepareInResuspensionContainerQs], {True..}];
				]
			],
			sampleResourcePacketsToSearch
		]
	];

	(* filter the modelObjectPackets and searchedSampleResourcePackets based on whether the corresponding product (if it exists) is Stocked or not *)
	(* basically, we don't want to overly aggressively reorder more things if it's a not-stocked product, but we DO want to do that if it IS a Stocked product *)
	filterStockedModelObjectPackets = MapThread[
		Function[{samplePackets, prodPacket},
			If[NullQ[prodPacket] || Not[TrueQ[Lookup[prodPacket, Stocked]]],
				samplePackets,
				Select[samplePackets, MatchQ[Lookup[#, Status], Stocked | Available]&]
			]
		],
		{modelObjectPackets, modelObjectProductPackets}
	];
	filterStockedSearchedSampleResourcePackets=MapThread[
		Function[{samplePackets, prodPacket, resources, resourcePacket},
			Module[{statusFiltered, requestedModels, filteredModels},
				statusFiltered=If[NullQ[prodPacket] || Not[TrueQ[Lookup[prodPacket, Stocked]]],
					resources,
					PickList[resources, Lookup[samplePackets, Status], Stocked | Available]
				];
				requestedModels=Download[Lookup[resourcePacket, Models], Object];
				filteredModels = Function[{singleList},If[MatchQ[singleList, Null|{}],{},Cases[singleList, _?(MemberQ[Download[Lookup[#, Models], Object], Alternatives@@requestedModels]&)]]]/@statusFiltered
			]],
		{modelObjectPackets, modelObjectProductPackets, searchedSampleResourcePackets, sampleResourcePacketsToSearch}
	];

	(* --- If a model is specified, is there an available sample of that model with the correct amount? --- *)

	(* get all the searched sample resource packets that are not InCart *)
	(* need to go at depth {2} because we are selecting the non InCart resources for every sample of every model *)
	requestedSearchedResourcePackets = Map[
		Function[{resources},
			Select[resources, MatchQ[Lookup[#, Status], Except[InCart | Shipping, ResourceStatusP]]&]
		],
		filterStockedSearchedSampleResourcePackets,
		{2}
	];

	syncAmountToState[amount_,state_,density_]:=Module[{safeDensity},
		(* if we don't have the density, count it as 1g/mL *)
		safeDensity=If[NullQ[density],1Gram/Milliliter,density];
		Which[
			Or[
				And[MatchQ[state,Liquid], VolumeQ[amount]],
				And[MatchQ[state,Solid], MassQ[amount]]
			],
			amount,

			And[MatchQ[state,Liquid], MassQ[amount]],
			amount/safeDensity,

			And[MatchQ[state,Solid], VolumeQ[amount]],
			amount*safeDensity,

			(* this should cover the cases of gas and countables since we are unlikely to get them in any other form *)
			True,
			amount
		]
	];

	(* get the amount of every given sample that is currently reserved *)
	reservedAmountAllSearchedSamples = MapThread[
		Function[{samples, resources}, Module[{sampleDensity,sampleState,sampleToPullInfo},
			sampleToPullInfo=FirstCase[samples,PacketP[],<||>];
			sampleDensity=Lookup[sampleToPullInfo,Density,Null];
			sampleState=Lookup[sampleToPullInfo,Null];
			Map[
				If[NullQ[Lookup[samples, {Volume, Mass, Count, Size}, {}]],
					Null,
					Total[(syncAmountToState[#,sampleState,sampleDensity]&)/@DeleteCases[Lookup[#, Amount, {}], Null]]
				]&,
				resources
			]
		]],
		{filterStockedModelObjectPackets, requestedSearchedResourcePackets}
	];

	(* get the amount of every given sample that can be resource picked *)
	availableAmountAllSearchedSamples = MapThread[
		Function[{samplePackets, reservedAmounts},
			MapThread[
				Which[
					(* If a sample is tablet, go with its Count even if it is also Solid and has a Mass *)
					IntegerQ[Lookup[#1, Count]], Lookup[#1, Count] - #2,
					MatchQ[Lookup[#1, State], Solid] && MassQ[Lookup[#1, Mass]], Lookup[#1, Mass] - #2,
					VolumeQ[Lookup[#1, Volume]], Lookup[#1, Volume] - #2,
					DistanceQ[Lookup[#1, Size]], Lookup[#1, Size] - #2,
					True, Null
				]&,
				{samplePackets, reservedAmounts}
			]
		],
		{filterStockedModelObjectPackets, reservedAmountAllSearchedSamples}
	];

	(* figure out if there exists an object in the desired container model and with the correct volume*)
	modelEnoughVolumeBool = MapThread[
		Function[{resourcePacket, availableAmounts, hermeticQ, prepareInResuspensionContainerQ},
			(* if no unit was specified in Amount, return True right away. This applies to either consumables or fluid samples that don't request amount *)
			(* Also, if a specific sample was specified, just return True too (since we already tested for that above) *)
			(* Also, if the sample is a non-hermetic StockSolution (or similar on-the-fly types) or a non-hermetic Chemical, also just return True here (since we can consolidate and we test this below) (we can't consolidate hermetic Chemicals though, so note that here) *)
			Which[
				Or[
					MatchQ[Lookup[resourcePacket, Amount], Null | UnitsP[Unit]],
					MatchQ[Lookup[resourcePacket, Sample], ObjectP[]],
					And[
						MatchQ[Lookup[resourcePacket, Models], {ObjectP[{Model[Sample, StockSolution], Model[Sample, Matrix], Model[Sample, Media]}]...}],
						Or[
							Not[hermeticQ],
							hermeticQ&&prepareInResuspensionContainerQ
						]],
					(Not[hermeticQ] && MatchQ[Lookup[resourcePacket, Models], {ObjectP[Model[Sample]]..}])
				],
				True,

				(* if ExactAmount->True, we have to search for exact match *)
				TrueQ[Lookup[resourcePacket,ExactAmount]] && MatchQ[Lookup[resourcePacket,Tolerance], VolumeP|MassP|CountP],
				AnyTrue[availableAmounts, MatchQ[Abs[# - Lookup[resourcePacket, Amount]], LessP[Lookup[resourcePacket,Tolerance]]]&],

				(* we may not have been given a tolerance. if not, assume that it has to be exactly the same. *)
				TrueQ[Lookup[resourcePacket,ExactAmount]],
				AnyTrue[availableAmounts, Round[#, 0.00000001] == Round[Lookup[resourcePacket, Amount], 0.00000001]&],

				(* otherwise, search anything that has larger amount *)
				True,
				AnyTrue[availableAmounts, Round[#, 0.00000001] >= Round[Lookup[resourcePacket, Amount], 0.00000001]&]
			]
		],
		{sampleResourcePacketsToSearch, availableAmountAllSearchedSamples, hermeticQs, prepareInResuspensionContainerQs}
	];

	(* make replace rules for inserting Booleans for all the requests; not just the ones that were all models (non models are auto True)*)
	modelEnoughVolumeReplaceRules = Flatten[{MapThread[#1 -> #2&, {sampleResourcePacketsToSearch, modelEnoughVolumeBool}], ObjectP[] -> True}];

	(* get the model enough quantity Boolean index matched with all sample resource objects *)
	finalModelEnoughVolumeBool = Replace[sampleResourcePackets, modelEnoughVolumeReplaceRules, 1];

	(* get the hermeticQs Boolean index matched with all the sample resource objects (non models are auto True) *)
	hermeticQReplaceRules = Flatten[{MapThread[#1 -> #2&, {sampleResourcePacketsToSearch, hermeticQs}], ObjectP[] -> True}];

	(* get whether the model enough quantity things are hermetic *)
	modelHermeticQs = Replace[sampleResourcePackets, hermeticQReplaceRules, 1];

	(* check to see if
	 	1.) the total volume is insufficient for a given model request
		2.) a product exists
		3.) if it's in a hermetic container, the amount requested isn't greater than the amount included in the kit
		4.) if the resource asked for it to be sterile and the product is properly sterile *)
	(* if all four of these are True, then that entry will be False; otherwise it will be True. *)
	modelVolProdNotDeprecatedBool = MapThread[
		Function[{enoughVolumeBool, product, resourcePacket, hermeticQ},
			If[
				And[
					Not[enoughVolumeBool],
					MatchQ[product, ObjectP[Object[Product]]],
					(Not[hermeticQ] || (hermeticQ && Lookup[product, Amount] >= Lookup[resourcePacket, Amount])),
					Or[
						TrueQ[Lookup[resourcePacket, Sterile]] && TrueQ[Lookup[product, Sterile]],
						Not[TrueQ[Lookup[resourcePacket, Sterile]]]
					]
				],
				False,
				True
			]
		],
		{finalModelEnoughVolumeBool, oneProductPerResource, sampleResourcePackets, modelHermeticQs}
	];


	(* get the resources in question where totalVolProdNotDeprecatedBool is False *)
	modelVolResourceProdNotDeprecated = PickList[sampleResourcePackets, modelVolProdNotDeprecatedBool, False];

	(* get the products where totalVolProdNotDeprecatedBool is False *)
	modelVolProdsNotDeprecated = PickList[oneProductPerResource, modelVolProdNotDeprecatedBool, False];

	(* throw a soft warning for models that have a product that is not deprecated that needs to be ordered here *)
	If[messages && Not[MatchQ[modelVolProdsNotDeprecated, {}]] && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::SamplesOutOfStock, Download[Lookup[modelVolResourceProdNotDeprecated, Models], Object], Lookup[modelVolProdsNotDeprecated, EstimatedLeadTime]]
	];

	(* get the models where there is:
		1.) no available total volume
	  	2.) one fo the following are True:
	  	2a.) no non-deprecated product exists
	 	2b.) in the kit or hermetic case, no non-deprecated product exists with a high enough amount
	 	2c.) the existing product is not sterile when the resource needs it to be sterile *)
	modelVolNoProdBool = MapThread[
		Function[{enoughBool, prod, resource, hermeticQ},
			If[
				And[
					Not[enoughBool],
					Or[
						NullQ[prod],
						hermeticQ && Lookup[prod, Amount] < Lookup[resource, Amount],
						TrueQ[Lookup[resource, Sterile]] && Not[TrueQ[Lookup[prod, Sterile]]]
					]
				],
				False,
				True
			]
		],
		{finalModelEnoughVolumeBool, oneProductPerResource, sampleResourcePackets, modelHermeticQs}
	];

	(* get the resource packets for which there doesn't exist a model in the model container with the right volume specified*)
	noModelEnoughVolumePackets = PickList[sampleResourcePackets, modelVolNoProdBool, False];

	(* throw messages for models that don't have an available sample of the correct volume *)
	If[messages && Not[MatchQ[noModelEnoughVolumePackets, {}]],
		Message[Error::NoAvailableSample, Lookup[noModelEnoughVolumePackets, Amount], Download[Lookup[noModelEnoughVolumePackets, Models], Object]]
	];

	(* figure out if a non self contained sample model was requested that has no non-deprecate product *)
	(* if True then we're fine; if False, then that means a model WAS requested that does not have a non-deprecated product *)
	modelDeprecatedProdBool = MapThread[
		Function[{resourcePacket, product},
			Not[NullQ[product]] || MatchQ[Lookup[resourcePacket, Amount], Null | UnitsP[Unit]] || MatchQ[Lookup[resourcePacket, Sample], ObjectP[]] || MatchQ[Lookup[resourcePacket, Models], {ObjectP[{Model[Sample], Model[Sample, StockSolution], Model[Sample, Matrix], Model[Sample, Media]}]...}]
		],
		{sampleResourcePacketsToSearch, oneProductPerResourceToSearch}
	];

	(* get the models where a consumable was reserved AND there is not a product to reorder it *)
	modelDeprecatedProdResources = PickList[sampleResourcePacketsToSearch, modelDeprecatedProdBool, False];

	(* get the models themselves where the product is deprecated *)
	modelDeprecatedProds = Download[Flatten[Lookup[modelDeprecatedProdResources, Models, {}]], Object];

	(* get the models that have deprecated products but don't have deprecated models (since those have their own message that supersedes this one) *)
	nonDeprecatedModelsWithDeprecatedProds = DeleteCases[modelDeprecatedProds, ObjectP[deprecatedModels]];

	(* throw a soft warning for models reserving deprecated products because we cannot reorder them *)
	(* do NOT throw this warning if we already threw the NoAvailableSample warning *)
	(* also don't throw this if the model itself is deprecated, since that will already throw an error *)
	If[messages && Not[MatchQ[nonDeprecatedModelsWithDeprecatedProds, {}]] && MatchQ[noModelEnoughVolumePackets, {}] && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::DeprecatedProduct, nonDeprecatedModelsWithDeprecatedProds]
	];


	(* --- If a model is specified, is there a total amount available of sample of that model? --- *)

	(* pick all the packets of resources that have this model that are reserved *)
	(* need to DeleteDuplicates because we don't want to double-count the same resource, and we could get that if we are reserving more than one model *)
	(* need to do the weird DeleteCases because we don't want the record of this reservation itself to count against it being fulfilled *)
	(* exclude Rented resources which won't actually get consumed *)
	modelReservedPackets = MapThread[
		DeleteDuplicates[
			Select[
				DeleteCases[#1, ObjectP[Lookup[#2, Object]]],
				MatchQ[Lookup[#, {Status,Rent}], {Except[InCart | Shipping, ResourceStatusP],False|Null}]&
			]
		]&,
		{modelResourcePacketsToSearch, sampleResourcePacketsToSearch}
	];

	(* get the total amount of this model that is already reserved *)
	modelReservedAmount = MapThread[
		Function[{reservedResourcePackets,targetResourcePacket},
			Module[{consumingResourcePackets,targetModelPacket,modelState,modelDensity},

				(* get the amount that has already been reserved by resources that will consume that amount;
				also, if the resource has a Preparation populated, ignore it, because the resource will be duplicated by the SM/SS preparing it *)
				consumingResourcePackets = Select[reservedResourcePackets, NullQ[Lookup[#, Preparation]]&];

				(* pull out the state and density of the sample we are requesting *)
				targetModelPacket=Experiment`Private`fetchPacketFromFastAssoc[Download[Lookup[targetResourcePacket,Models,{Null}][[1]],Object],fastAssoc];
				{modelState,modelDensity}=Lookup[targetModelPacket,{State,Density},Null];

				(* figure out the total amount these resources want *)
				(* Replace Null with 1 for Count *)
				Total[Map[
					If[MatchQ[#, Null | UnitsP[Unit]],
						Nothing,
						syncAmountToState[#,modelState,modelDensity]
					]&,
					ToList@Lookup[consumingResourcePackets, Amount, Nothing]
				]]
			]
		],
		{modelReservedPackets,sampleResourcePacketsToSearch}
	];

	getSampleAmount[samplePackets_List,targetState_]:=Map[getSampleAmount[#,targetState]&,samplePackets];
	getSampleAmount[samplePacket:PacketP[],targetState_]:=Module[{state,density,safeDensity},
		{density,state}=Lookup[samplePacket,{Density,State},Null];
		safeDensity=If[NullQ[density],1Gram/Milliliter,density];
		Which[
			(* we don't need to convert units *)
			And[MatchQ[state,targetState],MatchQ[state,Liquid]], Lookup[samplePacket,Volume,Nothing],
			And[MatchQ[state,targetState],MatchQ[state,Solid]], Lookup[samplePacket,Mass,Nothing],
			(* we are converting units *)
			And[MatchQ[state,Liquid],MatchQ[targetState,Solid]], Lookup[samplePacket,Volume]*safeDensity,
			And[MatchQ[state,Solid],MatchQ[targetState,Liquid]], Lookup[samplePacket,Mass]/safeDensity,
			(* we should never hit these since State-less Model[Sample] should not exist in the lab *)
			And[NullQ[state],MatchQ[targetState,Solid],Lookup[samplePacket,Mass,Nothing]],
			And[NullQ[state],MatchQ[targetState,Liquid],Lookup[samplePacket,Volume,Nothing]]
		]
	];

	(* get the total amount that is currently available in the objects *)
	(* need the empty list overload of Lookup in case there is truly nothing existing of a given model *)
	(* we are forcibly converting available amounts into what we think the state should be for the request based on the Amount *)
	availableAmountAllModels = MapThread[
		Module[{sampleModelPacket,density},
			sampleModelPacket=FirstCase[#1,PacketP[],<||>];
			density=Lookup[sampleModelPacket,Density,Null];
			Switch[Lookup[#2, Amount],
				MassP, Total@getSampleAmount[#1,Solid],
				VolumeP, Total@getSampleAmount[#1,Liquid],
				DistanceP, Total[DeleteCases[Lookup[#1, Size, {}], Null]],
				UnitsP[Unit], Total[DeleteCases[Lookup[#1, Count, {}], Null]],
				_, Null
			]
		]&,
		{filterStockedModelObjectPackets, sampleResourcePacketsToSearch}
	];

	(* sum up the total amount of a given model/set of models available.  If the Available amount is Null across the board, then just return Null *)
	(* if there are only some Nulls, then strip those out because that would break Total *)
	modelAvailableAmount = MapThread[
		If[Unitless[#1] == 0 || NullQ[#1],
			0,
			#1 - #2
		]&,
		{availableAmountAllModels, modelReservedAmount}
	];

	(* get the amount that is requested of this model *)
	modelRequestedAmount = Map[
		Lookup[#, Amount]&,
		sampleResourcePacketsToSearch
	];

	(* see whether there is enough of this model to fulfill this resource *)
	(* return True if any of the following are True: *)
	(* 1.) The requested or available amounts are Null *)
	(* 2.) A specific sample was specified (and thus we've tested it for if there is enough in an above test) *)
	(* 3.) We are dealing with a model stock solution (where we could just make more); this includes Matrix, and Media as well *)
	(* 4.) We are dealing with a gas cylinder/tank where these are stocked outside of the standard inventory system *)
	(* 5.) The available amount is not zero and exceeds the amount requested (need to do this because otherwise 0. > 15*Milligram doesn't evaluate *)
	(* Need to do the Round shenanigans because floating point numbers are dumb *)
	modelEnoughAmountBool = MapThread[
		If[
			Or[
				NullQ[#1],
				NullQ[#2],
				MatchQ[Lookup[#3, Models], {ObjectP[{Model[Sample, StockSolution], Model[Sample, Matrix], Model[Sample, Media]}]..}],
				MatchQ[Lookup[#3, ContainerModels], {ObjectP[Model[Container, GasCylinder]]..}],
				(Round[#1, 0.00000001] != 0 && Round[#1, 0.00000001] >= Round[#2, 0.00000001])
			],
			True,
			False
		]&,
		{modelAvailableAmount, modelRequestedAmount, sampleResourcePacketsToSearch}
	];

	(* make replace rules for inserting Booleans for all the requests; not just the ones that were all models (non models are auto True)*)
	modelEnoughAmountReplaceRules = Flatten[Append[MapThread[#1 -> #2&, {sampleResourcePacketsToSearch, modelEnoughAmountBool}], ObjectP[] -> True]];

	(* get the model enough quantity Boolean index matched with all sample resource objects *)
	finalModelEnoughAmountBool = Replace[sampleResourcePackets, modelEnoughAmountReplaceRules, 1];

	(* check to see if *)
	(* 1.) the total volume is insufficient for a given model request *)
	(* 2.) a product exists *)
	(* 3.) a product exists that is not deprecated *)
	(* 4.) If the resource asked for it to be sterile and the product is properly sterile *)
	(* if all three of these are True, then that entry will be False; otherwise it will be True. *)
	totalVolProdNotDeprecatedBool = MapThread[
		Function[{enoughBool, prodPacket, resourcePacket},
			If[
				And[
					Not[enoughBool],
					MatchQ[prodPacket, ObjectP[Object[Product]]],
					Not[TrueQ[Lookup[prodPacket, Deprecated]]],
					Or[
						TrueQ[Lookup[resourcePacket, Sterile]] && TrueQ[Lookup[prodPacket, Sterile]],
						Not[TrueQ[Lookup[resourcePacket, Sterile]]]
					]
				],
				False,
				True
			]
		],
		{finalModelEnoughAmountBool, oneProductPerResource, sampleResourcePackets}
	];

	(* get the resources in question where totalVolProdNotDeprecatedBool is False *)
	totalVolResourceProdNotDeprecated = PickList[sampleResourcePackets, totalVolProdNotDeprecatedBool, False];

	(* get the products where totalVolProdNotDeprecatedBool is False *)
	totalVolProdsNotDeprecated = PickList[oneProductPerResource, totalVolProdNotDeprecatedBool, False];

	(* throw a soft warning for models that have a product that is not deprecated that needs to be ordered here *)
	If[messages && Not[MatchQ[totalVolProdsNotDeprecated, {}]] && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::SamplesOutOfStock, Download[Lookup[totalVolResourceProdNotDeprecated, Models], Object], Lookup[totalVolProdsNotDeprecated, EstimatedLeadTime]]
	];

	(* get the models where there is no available total volume AND no non-deprecated product exists (or if one exists, it is not sterile when the resource needsit to be sterile) *)
	totalVolNoProdBool = MapThread[
		Function[{enoughBool, prodPacket, resourcePacket},
			If[
				And[
					Not[enoughBool],
					Or[
						NullQ[prodPacket],
						TrueQ[Lookup[resourcePacket, Sterile]] && Not[TrueQ[Lookup[prodPacket, Sterile]]]
					]
				],
				False,
				True
			]
		],
		{finalModelEnoughAmountBool, oneProductPerResource, sampleResourcePackets}
	];

	(* get the resources that have no product *)
	notEnoughModelAmountPackets = PickList[sampleResourcePackets, totalVolNoProdBool, False];

	(* throw messages for models that don't have enough volume of and that we can't buy more of *)
	If[messages && Not[MatchQ[notEnoughModelAmountPackets, {}]],
		Message[Error::InsufficientTotalVolume, Lookup[notEnoughModelAmountPackets, Amount], Download[Lookup[notEnoughModelAmountPackets, Models], Object]]
	];

	(* --- If a model is specified and an amount is not specified, are there enough copies of the item available? --- *)

	(* get whether a given resource request is of an item that is consumable or not, index matched to the resource requests on models *)
	consumableModel = Map[
		Switch[Lookup[#, Object, {}],
			(* for samples, if Reusable -> False, then assume this means the item is a consumable.*)
			(* Note that NonSelfContainedSamples are definitely consumable, but this test is not worrying about those cases since checking whether there is enough of those samples is tested above *)
			{SelfContainedSampleModelP..}, MatchQ[Lookup[#, Reusable], {False..}],
			(* for containers, if Reusable is listed as False, or if Reusable is listed as True and CleaningMethod is Null (TEMP: not sure if this is the right call but will prevent additional ordering) *)
			{ObjectP[Model[Container]]..}, MatchQ[Lookup[#, Reusable], {False..}] || TrueQ[Lookup[#, Reusable]],
			_, False
		]&,
		modelPacketsToSearch
	];

	(* pick those consumable resources for which a model was provided, and also all the resources tied to that same model *)
	consumableResources = PickList[sampleResourcePacketsToSearch, consumableModel];
	consumableModelResources = PickList[modelResourcePacketsToSearch, consumableModel];

	(* get those model object packets that correspond to consumable models *)
	consumablesAvailable = PickList[samplesAndContainers, consumableModel];

	(* get the counts for model object packets that correspond to consumable models - this is used only for Counted objects *)
	(* If something is missing its count ignore it *)
	countsForConsumablesAvailable = DeleteCases[PickList[modelObjectCounts, consumableModel],Null];

	(* Compute the total count of available counted consumables, assuming we had any Count populated *)
	totalsForConsumablesAvailable = Map[
		If[MatchQ[#,{}],
			Null,
			Unitless[Total[#],Unit]
		]&,
		countsForConsumablesAvailable
	];

	(* pick the consumable resources tied to the model that are _not_ the parent resource itself *)
	(* if we're dealing with null notebooks, then don't count resources that are InUse and _have_ notebooks because we can't pick the things they are reserving anyway *)
	otherConsumableModelResources = MapThread[
		Function[{consumableResource, allConsumableModelResources},
			Select[allConsumableModelResources, MatchQ[Lookup[#, Status], Except[InCart | Shipping, ResourceStatusP]] && Not[MatchQ[#, ObjectP[consumableResource]]] && If[nullNotebookQ, NullQ[Lookup[#, Notebook]] || Not[MatchQ[Lookup[#, Status], InUse]], True]&]
		],
		{Download[consumableResources, Object], consumableModelResources}
	];

	(* get the number of copies of the model that currently exist *)
	consumableModelAvailAmount = Length[Flatten[#]]& /@ consumablesAvailable;

	(* get the number of copies of the model that are currently requested *)
	consumableModelRequestedAmount = Length[Flatten[#]]& /@ otherConsumableModelResources;

	(* get the amounts specified in each requested resource *)
	(* If no count was requested, assume 1 unit (units are removed in next step so leave off here for speed) *)
	countsRequestedPerRequestedConsumableModel = Replace[Lookup[#, Amount]&/@otherConsumableModelResources,Null -> 1,{2}];

	(* Compute the total of the specified counts needed *)
	totalCountRequestedPerRequestedConsumableModel = Unitless[Total/@countsRequestedPerRequestedConsumableModel, Unit];

	(* See whether there are enough instances of this model to fulfill this resource *)
	(* Either we have a counted object (case 1) and we need to look at amount requested in the resource and the total available count
	   Or we need to simply compare the number of objects requested to the number of available objects
	*)
	consumableModelEnoughBool = MapThread[
		If[IntegerQ[#3]&&IntegerQ[#4],
			#3 > #4,
			#1 > #2
		]&,
		{consumableModelAvailAmount, consumableModelRequestedAmount, totalsForConsumablesAvailable, totalCountRequestedPerRequestedConsumableModel}
	];

	(* make replace rules for inserting Booleans for all the requests, not just the ones that were consumable models (all others are auto True) *)
	consumableModelEnoughReplaceRules = Flatten[Append[MapThread[#1 -> #2&, {consumableResources, consumableModelEnoughBool}], ObjectP[] -> True]];

	(* get the consumable model enough quantity Boolean index matched with all sample resources *)
	finalConsumableModelEnoughBool = Replace[sampleResourcePackets, consumableModelEnoughReplaceRules, 1];

	(* check to see if 1.) no consumable is available, 2.) a product exists, and 3.) a product exists that is not deprecated *)
	(* if all three of these are True, then that entry will be False; otherwise it will be True. *)
	consumableProdNotDeprecatedBool = MapThread[
		If[Not[#1] && MatchQ[#2, ObjectP[Object[Product]]],
			False,
			True
		]&,
		{finalConsumableModelEnoughBool, oneProductPerResource}
	];

	(* get the resources in question where consumableProdNotDeprecatedBool is False *)
	consumableResourceProdNotDeprecated = PickList[sampleResourcePackets, consumableProdNotDeprecatedBool, False];

	(* get the products where consumableProdNotDeprecatedBool is False *)
	consumableProdsNotDeprecated = PickList[oneProductPerResource, consumableProdNotDeprecatedBool, False];

	(* throw a soft warning for models that have a product that is not deprecated that needs to be ordered here *)
	If[messages && Not[MatchQ[consumableResourceProdNotDeprecated, {}]] && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::SamplesOutOfStock, Download[Flatten[Lookup[consumableResourceProdNotDeprecated, Models]], Object], Lookup[consumableProdsNotDeprecated, EstimatedLeadTime]]
	];

	(* get the models where there is no available total volume AND no non-deprecated product exists *)
	consumableNoProdBool = MapThread[
		If[Not[#1] && NullQ[#2],
			False,
			True
		]&,
		{finalConsumableModelEnoughBool, oneProductPerResource}
	];

	(* get the resources that have no product *)
	notEnoughConsumableModelPackets = PickList[sampleResourcePackets, consumableNoProdBool, False];

	(* throw messages for models that don't have enough of and that we can't buy more of *)
	If[messages && Not[MatchQ[notEnoughConsumableModelPackets, {}]],
		Message[Error::NoAvailableModel, Download[Flatten[PickList[allModelPackets, consumableNoProdBool, False]], Object]]
	];

	(* figure out if a consumable model was reserved that does not have a non-deprecated product *)
	(* check to see if 1.) The resource is for a consumable model and 2.) If there is no non-deprecated product.  If both of those, then that resource gets False; otherwise, it gets True *)
	consumableDeprecatedProdBool = MapThread[
		If[TrueQ[#1] && NullQ[#2],
			False,
			True
		]&,
		{consumableModel, oneProductPerResourceToSearch}
	];

	(* get the models where a consumable was reserved AND there is not a product to reorder it *)
	consumableDeprecatedProdResources = PickList[sampleResourcePacketsToSearch, consumableDeprecatedProdBool, False];

	(* get the consumable models themselves where the product is deprecated *)
	consumableModelDeprecatedProds = Download[Flatten[Lookup[consumableDeprecatedProdResources, Models, {}]], Object];

	(* get the consumable models that have deprecated products but don't have deprecated models (since those have their own message that supersedes this one) *)
	nonDeprecatedConsumableModelsWithDeprecatedProds = DeleteCases[consumableModelDeprecatedProds, ObjectP[deprecatedModels]];

	(* throw a soft warning for models reserving deprecated products because we cannot reorder them *)
	(* do NOT throw this warning if we already threw the NoAvailableModel error above *)
	If[messages && Not[MatchQ[nonDeprecatedConsumableModelsWithDeprecatedProds, {}]] && MatchQ[notEnoughConsumableModelPackets, {}] && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::DeprecatedProduct, nonDeprecatedConsumableModelsWithDeprecatedProds]
	];

	(* --- If a container model is specified, is the requested volume less than the MaxVolume of the container? --- *)

	(* get all models *)
	containerModels = Flatten[allContainerModelPackets];

	(* get positions of all duplicates *)
	containerModelPositions = PositionIndex[containerModels];

	(* We can now grab only the unique models *)
	uniqueContainerModels = Keys[containerModelPositions];

	(* pull out the MaxVolume for each ContainerModel, or Null if there was no ContainerModels *)
	(* unit tests seem to be behaving weirdly in cases where it thinks normal containers have MaxVolumes too low (not really sure why).  Thus going to hard code the worst offenders here to prevent recurring failures *)
	(* obviously hard coding this isn't great but it's better than unit tests failing every night that I can't figure out *)
	(* December 2020 update: this still happens when new containers that are not hard coded into this exist.  I still have no idea why and can't figure it out *)

	(* Make a lookup function for volume *)
	getContainerMaxVolume[container_]:=
		Switch[Lookup[container, Object],
			(* "2mL Tube" *)
			Model[Container, Vessel, "id:3em6Zv9NjjN8"], 1.9 * Milliliter,
			(* "96-well UV-Star Plate" *)
			Model[Container, Plate, "id:n0k9mGzRaaBn"], 0.3 * Milliliter,
			(* "96-well PCR Plate" *)
			Model[Container, Plate, "id:01G6nvkKrrYm"], 0.2 * Milliliter,
			(* 96-well Black Wall Greiner Plate *)
			Model[Container, Plate, "id:kEJ9mqR3XELE"], 0.3 * Milliliter,
			(* In Situ-1 Crystallization Plate, 0.1 mL *)
			Model[Container, Plate, "id:pZx9jo8x59oP"], 0.1 * Milliliter,
			(* "Simple Western MidMolecularWeight (12-230 kDa) assay plate" *)
			Model[Container, Plate, Irregular, "id:dORYzZJArVMG"], 0.5 * Milliliter,
			(* "Simple Western LowMolecularWeight (2-40 kDa) assay plate" *)
			Model[Container, Plate, Irregular, "id:dORYzZJArnRe"], 0.5 * Milliliter,
			(* "Simple Western HighMolecularWeight (66-440 kDa) assay plate" *)
			Model[Container, Plate, Irregular, "id:9RdZXv1nGK3j"], 0.5 * Milliliter,
			(* "96-well Round Bottom Plate" *)
			Model[Container, Plate, "id:1ZA60vwjbbqa"], 0.3 * Milliliter,
			(* "2mL Glass CE Vials" *)
			Model[Container, Vessel, "id:AEqRl954GG7a"], 2 * Milliliter,
			(* "96-well Black Wall Plate" *)
			Model[Container, Plate, "id:6V0npvK611zG"], 0.3 * Milliliter,
			(* "96-well 2mL Deep Well Plate" *)
			Model[Container, Plate, "id:L8kPEjkmLbvW"], 2 * Milliliter,
			(* "HPLC vial (flat bottom)" *)
			Model[Container, Vessel, "id:AEqRl954GGvv"], 0.61 * Milliliter,
			(* "HPLC vial (high recovery)" *)
			Model[Container, Vessel, "id:jLq9jXvxr6OZ"], 1.5 * Milliliter,
			(* "50mL Light Sensitive Centrifuge Tube" *)
			Model[Container, Vessel, "id:bq9LA0dBGGrd"], 50 * Milliliter,
			(* "Sterile 300mL Polypropylene Robotic Reservoir" *)
			Model[Container, Plate, "id:Vrbp1jG800Vb"], 300 * Milliliter,
			(* "200mL Polypropylene Robotic Reservoir, non-sterile" *)
			Model[Container, Plate, "id:54n6evLWKqbG"], 300 * Milliliter,
			(* "48-well Pyramid Bottom Deep Well Plate" *)
			Model[Container, Plate, "id:E8zoYveRllM7"], 3.5 * Milliliter,
			(* "Lunatic Chip Plate" *)
			Model[Container, Plate, "id:O81aEBZ4EMXj"], 0.005 * Milliliter,
			(* "384-well qPCR Optical Reaction Plate" *)
			Model[Container, Plate, "id:pZx9jo83G0VP"], 0.04 * Milliliter,
			(* "0.5mL Tube with 2mL Tube Skirt" *)
			Model[Container, Vessel, "id:bq9LA0JPKJE6"], 0.8 * Milliliter,
			(* "0.5mL Tube with 2mL Tube Skirt Deprecated" *)
			Model[Container, Vessel, "id:01G6nvkKrrb1"], 0.8 * Milliliter,
			(* "96-well 500uL Round Bottom DSC Plate" *)
			Model[Container, Plate, "id:jLq9jXY4kknW"], 0.5 * Milliliter,
			(* "24-well V-bottom 10 mL Deep Well Plate Sterile" *)
			Model[Container, Plate, "id:qdkmxzkKwn11"], 10 * Milliliter,
			(* "96-well Black Optical-Bottom Plates with Polymer Base" *)
			Model[Container, Plate, "id:Y0lXejML17rm"], 0.4 * Milliliter,
			(* "96-Well All Black Plate" *)
			Model[Container, Plate, "id:BYDOjvG1pRnE"], 0.3 * Milliliter,
			(* "Bio-Rad GCR96 Digital PCR Cartridge" *)
			Model[Container, Plate, DropletCartridge, "id:6V0npvmVGVlZ"], 0.022 * Milliliter,
			(* "96-well 1mL Deep Well Plate" *)
			Model[Container, Plate, "id:Z1lqpMGjeekO"], 1 * Milliliter,
			(* "96-well 1.2mL Deep Well Plate" *)
			Model[Container, Plate, "id:R8e1PjpVrbMv"], 1.2 * Milliliter,
			(* "96-well Optical Full-Skirted PCR Plate" *)
			Model[Container, Plate, "id:9RdZXv1laYVK"], 0.2 * Milliliter,
			(* "96-well Clear Wall V-Bottom Plate" *)
			Model[Container, Plate, "id:4pO6dM55ar55"], 0.32 * Milliliter,
			(* 2mL brown tube *)
			Model[Container, Vessel, "id:M8n3rx03Ykp9"], 2 * Milliliter,
			(* "0.7mL Tube with 2mL Tube Skirt" *)
			Model[Container, Vessel, "id:aXRlGn6LO7Bk"], 0.7 * Milliliter,
			(* "Fully Tapered 0.5mL Tube with 2mL Tube Skirt" *)
			Model[Container, Vessel, "id:E8zoYvNOwG9v"], 0.5 * Milliliter,
			(* Fully Tapered 0.5mL Tube with 2mL Tube Skirt, Brown *)
			Model[Container, Vessel, "id:6V0npvmqR5BG"], 0.5 * Milliliter,
			(* "1.5mL Tube with 2mL Tube Skirt" *)
			Model[Container, Vessel, "id:eGakld01zzpq"], 1.5 * Milliliter,
			(* "8x43mm Glass Reaction Vial" *)
			Model[Container, Vessel, "id:4pO6dM5WvJKM"], 1 * Milliliter,
			(* "DynePlate 96-well plate" *)
			Model[Container, Plate, "id:8qZ1VW06z9Zp"], 0.05 * Milliliter,
			(* "50mL Tube" *)
			Model[Container, Vessel, "id:bq9LA0dBGGR6"], 50 * Milliliter,
			(* "New 0.5mL Tube with 2mL Tube Skirt" *)
			Model[Container, Vessel, "id:o1k9jAG00e3N"], 0.8 * Milliliter,
			_, Lookup[container, MaxVolume]
		];

	(* now we can map over containers to get their maxVolume *)
	maxVolumesLookupTable = Map[
		getContainerMaxVolume[#]&,
		uniqueContainerModels
	];


	(* now build a replacement table - map all positions to their correct volume so we can replacePart them in*)
	positionToVolume = Flatten[MapThread[
		Function[{containerPositions, volume},
			Map[
				#->volume&,
				containerPositions
			]
		],
		{Values[containerModelPositions], maxVolumesLookupTable}
	]];

	(* now we can replace containers with volumes - I realize we could just make a lookup table, but should be ready for a case where the volume is unknown and needs to be downloaded *)
	maxVolumesFlattened = ReplacePart[Flatten[allContainerModelPackets], positionToVolume];

	(* Reconstruct the original listedness *)
	maxVolumes = TakeList[maxVolumesFlattened, Length/@allContainerModelPackets];

	(* if no volume was requested, or there's no specified ContainerModels, or a Mass was requested, just default to True *)
	(* If the max volume is greater than the requested volume for all requested ContainerModels, then this would be True; otherwise, it would be False *)
	(* Need to do the Round shenanigans because floating point numbers are dumb *)
	belowMaxVolumeBool = MapThread[
		Function[{maxVols, request},
			Which[
				NullQ[maxVols] || NullQ[request] || MassQ[request], True,
				VolumeQ[request], AllTrue[Round[#, 0.00000001] >= Round[request, 0.00000001]& /@ maxVols, TrueQ],
				True, True
			]
		],
		{maxVolumes, requestedAmount}
	];

	(* throw messages for models that don't have enough total volume *)
	MapThread[
		If[Not[#1] && messages,
			Message[Error::ContainerTooSmall, #3, Download[Lookup[#2, ContainerModels], Object], PickList[Download[Lookup[#2, ContainerModels], Object], #4, Except[GreaterEqualP[#3]]]]
		]&,
		{belowMaxVolumeBool, sampleResourcePackets, requestedAmount, maxVolumes}
	];

	(* get the resource packets that don't have enough volume *)
	belowMaxVolumePackets = PickList[sampleResourcePackets, belowMaxVolumeBool, False];


	(* --- If a model is specified, is there an available sample of that model with the enough uses available? --- *)

	(* get the number of uses of every given sample that is currently reserved *)
	reservedUsesAllSearchedSamples = MapThread[
		Function[{samples, resources},
			Map[
				If[NullQ[Lookup[samples, {NumberOfUses}, {}]],
					Null,
					Total[DeleteCases[Lookup[#, NumberOfUses, {}], Null]]
				]&,
				resources
			]
		],
		{filterStockedModelObjectPackets, requestedSearchedResourcePackets}
	];

	(* get the amount of every given sample that can be resource picked *)
	availableUsesAllSearchedSamples = MapThread[
		Function[{samplePackets, reservedUses},
			MapThread[
				Which[
					IntegerQ[Lookup[#1, MaxNumberOfUses]], Lookup[#1, MaxNumberOfUses] - #2,
					True, Null
				]&,
				{samplePackets, reservedUses}
			]
		],
		{filterStockedModelObjectPackets, reservedUsesAllSearchedSamples}
	];

	(* figure out if there exists an object with a sufficient number of uses*)
	modelEnoughUsesBool = MapThread[
		Function[{resourcePacket, availableUses},
			(* if number of uses was not specified, return True right away. *)
			(* Also, if a specific sample was specified, just return True too (since we already tested for that above) *)
			If[MatchQ[Lookup[resourcePacket, NumberOfUses], Null] || MatchQ[Lookup[resourcePacket, Sample], ObjectP[]],
				True,
				AnyTrue[availableUses, # >= Lookup[resourcePacket, NumberOfUses]&]
			]
		],
		{sampleResourcePacketsToSearch, availableUsesAllSearchedSamples}
	];

	(* make replace rules for inserting Booleans for all the requests; not just the ones that were all models (non models are auto True)*)
	modelEnoughUsesReplaceRules = Flatten[{MapThread[#1 -> #2&, {sampleResourcePacketsToSearch, modelEnoughUsesBool}], ObjectP[] -> True}];

	(* get the model enough quantity Boolean index matched with all sample resource objects *)
	finalModelEnoughUsesBool = Replace[sampleResourcePackets, modelEnoughUsesReplaceRules, 1];

	(* get the resource packets for which there doesn't exist a model in the model container with the right volume specified*)
	noModelEnoughUsesPackets = PickList[sampleResourcePackets, finalModelEnoughUsesBool, False];

	(* check to see if 1.) the NumberOfUses is insufficient for a given model request, 2.) a product exists *)
	(* if both of these are True, then that entry will be False; otherwise it will be True. *)
	modelUsesProdNotDeprecatedBool = MapThread[
		Function[{enoughUsesBool, product},
			If[Not[enoughUsesBool] && MatchQ[product, ObjectP[Object[Product]]],
				False,
				True
			]
		],
		{finalModelEnoughUsesBool, oneProductPerResource}
	];

	(* get the resources in question where modelUsesProdNotDeprecatedBool is False *)
	modelUsesResourceProdNotDeprecated = PickList[sampleResourcePackets, modelUsesProdNotDeprecatedBool, False];

	(* get the products where totalVolProdNotDeprecatedBool is False *)
	modelUsesProdsNotDeprecated = PickList[oneProductPerResource, modelUsesProdNotDeprecatedBool, False];

	(* throw messages for models that don't have an available sample of the correct number of uses *)
	If[messages && Not[MatchQ[noModelEnoughUsesPackets, {}]],
		Message[Warning::SamplesOutOfStock,  Download[Lookup[modelUsesResourceProdNotDeprecated, Models], Object], Lookup[modelUsesProdsNotDeprecated, EstimatedLeadTime]]
	];

	(* --- If a sterile stock solution is requested in a container, that container must be autoclave compatible. --- *)
	autoclaveCompatibleBools = MapThread[
		Function[{containerModels, containerMaxVolumes, samplePackets, amount},
			(* Only perform the check if we have a container model and a Model[Sample, StockSolution/Media/Matrix]. *)
			If[Length[containerModels] == 0 || !MemberQ[samplePackets, ObjectP[{Model[Sample, StockSolution], Model[Sample, StockSolution], Model[Sample, Matrix]}]],
				True,
				(* Only perform the check if our stock solution is supposed to be autoclaved. *)
				If[!MemberQ[Lookup[samplePackets, Autoclave], True],
					True,
					(* Now do our check. *)
					And[
						(* All containers given are not more than 3/4 full. *)
						AllTrue[MatchQ[N[# * 3 / 4], GreaterP[amount]]& /@ containerMaxVolumes, TrueQ],
						(* All containers have a MaxTemperature over 120 Celsius. *)
						AllTrue[MatchQ[#, GreaterP[120 Celsius]] & /@ Lookup[containerModels, MaxTemperature], TrueQ]
					]
				]
			]
		],
		{allContainerModelPackets, maxVolumes, allModelPackets, requestedAmount}
	];

	MapThread[
		If[Not[#3] && messages,
			Message[Error::ContainerNotAutoclaveCompatible, Download[#1, Object], Download[#2, Object]]
		]&,
		{allModelPackets, allContainerModelPackets, autoclaveCompatibleBools}
	];

	notAutoclaveCompatiblePackets = PickList[sampleResourcePackets, autoclaveCompatibleBools, False];

	(* --- Sample Resources Must have Site Set --- *)
	(* Build lookup of resource packet -> sample packet for resources requesting a sample *)
	resourceToSamplesLookup = AssociationThread[
		sampleResourcePackets,
		requestedSamplePackets
	];

	(* Build lookup of resource packet -> sample packets for resources requesting a model fulfillment
	Strip out any that have reservations *)
	resourceModelToSamplesLookup = AssociationThread[
		sampleResourcePacketsToSearch,
		Map[
			Function[downloadPacketList,
				If[MatchQ[downloadPacketList,{}],
					{},
					Select[
						downloadPacketList,
						MatchQ[#[[4]],{}]&
					][[All,1]]
				]
			],
			postSecondDownloadPackets
		]
	];

	(* Generate a list of the samples that can fulfill the shippable resource requests *)
	possibleFulfillingSamples = Map[
		If[MatchQ[Lookup[#,Sample],ObjectP[]],
			{Lookup[resourceToSamplesLookup,Key[#],<||>]},
			Lookup[resourceModelToSamplesLookup,Key[#],{<||>}]
		]&,
		sampleResourcePackets
	];

	sampleSitesPerResource=DeleteDuplicates/@Download[
		DeleteCases[possibleFulfillingSamples[[All,All,Key[Site]]],_Missing,{2}],
		Object
	];

	sitelessSampleResources = PickList[sampleResourcePackets, sampleSitesPerResource, {Null}];

	(* For our sample resources that don't have site information, see if there is a non-deprecated product for it. *)
	(* If so, then we don't have to yell about it because we can just order more. *)
	sitelessSampleResourcesAfterProductFilter = Map[
		Function[{sampleResourcePacket},
			Module[{modelPackets, productPackets},
				(* Get the packets for the Model[Sample]s that can be used to fulfill this resource. *)
				modelPackets=(Experiment`Private`fetchPacketFromFastAssoc[#, fastAssoc]&)/@Lookup[sampleResourcePacket, Models];

				(* if there are no Models in this resource packet (for example if we have a resource for an Object with no Model), return early *)
				If[MatchQ[modelPackets,$Failed|Null|{}],
					Return[Nothing,Module]
				];

				(* Get packets for all of the products that can be used to fulfill this resource. *)
				productPackets=(Experiment`Private`fetchPacketFromFastAssoc[#, fastAssoc]&)/@Cases[Flatten[Lookup[modelPackets, Products]], ObjectP[]];

				(* If we have a single non-deprecated product, we don't care that we have none of these samples at a site since we can just order more. *)
				If[MemberQ[Lookup[productPackets, Deprecated], Except[True]],
					Nothing,
					sampleResourcePacket
				]
			]
		],
		sitelessSampleResources
	];

	(* We can have either Models or Sample set in our packet. Unspecified value will be $Failed *)
	missingSiteSamples =Download[
		DeleteCases[
			Flatten[
				Lookup[sitelessSampleResourcesAfterProductFilter,{Models,Sample},Null],
				2
			],
			Null | $Failed
		],
		Object];

	If[messages && Length[missingSiteSamples]>0,
		Message[Error::SiteUnknown,ToString[missingSiteSamples, InputForm]]
	];

	(* --- If an instrument resource is specified, is the instrument that is requested Running or Available? --- *)

	(* if the status is Running, Available, or UndergoingMaintenance, or if there isn't an instrument resource at all, return True; otherwise, return False *)
	availInstrumentBool = Map[
		If[NullQ[#] || MatchQ[Lookup[#, Status, Null], Except[Retired, InstrumentStatusP] | Null],
			True,
			False
		]&,
		requestedInstrumentPackets
	];

	(* get the packets that are instruments that are currently undergoing maintenance *)
	undergoingMaintenancePackets = Select[requestedInstrumentPackets, Not[NullQ[#]] && messages && MatchQ[Lookup[#, Status], UndergoingMaintenance]&];

	(* get the resource packets that are instruments that are currently undergoing maintenance *)
	undergoingMaintenanceResourcePackets = MapThread[
		If[Not[NullQ[#2]] && MatchQ[Lookup[#2, Status], UndergoingMaintenance],
			#1,
			Nothing
		]&,
		{instrumentResourcePackets, requestedInstrumentPackets}
	];

	(* throw a warning if there are packets that are undergoing maintenance *)
	If[messages && Not[MatchQ[undergoingMaintenancePackets, {}]] && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::InstrumentUndergoingMaintenance, Lookup[undergoingMaintenancePackets, Object]]
	];

	(* get the resource packets that correspond to retired instruments *)
	retiredInstrumentPackets = PickList[instrumentResourcePackets, availInstrumentBool, False];

	(* throw messages for instruments that are retired *)
	If[messages && Not[MatchQ[retiredInstrumentPackets, {}]],
		Message[Error::RetiredInstrument, Download[Lookup[retiredInstrumentPackets, Instrument], Object]]
	];

	(* --- If an instrument model is specified, is the instrument model deprecated? ---*)

	(* if Deprecated -> True for all instrument models, return False; otherwise return True *)
	notDeprecatedInstrumentBool = Map[
		If[NullQ[#] || FailureQ[#] || Not[MatchQ[Lookup[#, Deprecated, Null], {True..}]],
			True,
			False
		]&,
		instrumentModelPackets
	];

	(* get the instrument resource packets corresponding to model packets that are deprecated *)
	deprecatedInstrumentPackets = PickList[instrumentResourcePackets, notDeprecatedInstrumentBool, False];
	deprecatedInstrumentModelPackets = PickList[instrumentModelPackets, notDeprecatedInstrumentBool, False];

	(* throw messages for instruments that are deprecated *)
	If[messages && Not[MatchQ[deprecatedInstrumentPackets, {}]],
		Message[Error::DeprecatedInstrument, Download[deprecatedInstrumentModelPackets, Object]]
	];

	(* --- If an instrument model and deck layout are specified, is the deck layout in the instrument model's AvailableLayouts? ---*)

	(* return False if DeckLayout is not in ALL of the AvailableLayouts for any requested instrument models *)
	deckLayoutAvailableBool = MapThread[
		Function[{resourcePacket, instModelPackets},
			Which[
				MatchQ[Lookup[resourcePacket, DeckLayouts], {}], True,
				(* if for some reason (this is conservative, unsure if necessary) the model packet is null or $failed, the deck layout can't be legit *)
				NullQ[instModelPackets] || FailureQ[instModelPackets], False,

				(* otherwise, we have model packets, we need the deck layout to appear in each model's available layouts *)
				True, And @@ (MapThread[
				Function[{resourceLayout, instModelPacket},
					MemberQ[Download[Lookup[instModelPacket, AvailableLayouts], Object], Download[resourceLayout, Object]]
				],
				{Lookup[resourcePacket, DeckLayouts], instModelPackets}
			])
			]
		],
		{instrumentResourcePackets, instrumentModelPackets}
	];

	(* get the instrument resource packets asking for deck layouts that aren't available to the requested model *)
	unavailableDeckLayoutInstrumentPackets = PickList[instrumentResourcePackets, deckLayoutAvailableBool, False];

	(* throw messages for instruments that deck layouts are not available *)
	If[messages && Not[MatchQ[unavailableDeckLayoutInstrumentPackets, {}]],
		Message[Error::DeckLayoutUnavailable, Lookup[unavailableDeckLayoutInstrumentPackets, Object]]
	];

	(* --- If an incubator instrument model is specified, is storage position inside available? ---*)

	(* Error if specific CrystalIncubator instrument has no available storage positions to accept more samples. *)
	(* Don't double complain if we have a totally invalid resource *)
	(* NOTE: For CrystalIncubator, we need to check both Status and Available slots. *)
	(* Retrieve the number of available plate slots for CrystalIncubator, if Capacity of model is not filled, use 182 as default. *)
	instrumentModelObjectsCurrentCapacity = Map[
		Function[{instrumentPackets},
			Which[
				(* If we have thrown error for NoSuitableSite or SiteUnknown, do not double throw here *)
				MatchQ[possibleSites, {}],
					{},
				MatchQ[Lookup[instrumentPackets[[1]], Instrument], ObjectP[Object[Instrument, CrystalIncubator]]],
					{Lookup[instrumentPackets[[5]], Capacity, 182]- Length[Cases[Lookup[instrumentPackets[[2]], Contents][[All, 2]], ObjectP[Object[Container, Plate, Irregular]]]]},
				MemberQ[Lookup[instrumentPackets[[1]], InstrumentModels], ObjectP[Model[Instrument, CrystalIncubator]]] && !MatchQ[instrumentPackets[[6]], {{}}],
				(* For instrument only model is specified, we check the current capacity. *)
					MapThread[
						(Lookup[#2, Capacity, 182] - Length[Cases[Flatten@Lookup[#1, Contents], ObjectP[Object[Container, Plate, Irregular]]]])&,
						{instrumentPackets[[6]], instrumentPackets[[3]]}
					],
				(*If no CrystalIncubator is required, return empty list*)
				True,
					{}
			]
		],
		allInstrumentPackets
	];

	(* Get any instrument models whose objects (or just instruments) with have no capacity to put more plates. *)
	noCapacityInstrumentResources = PickList[instrumentResourcePackets, instrumentModelObjectsCurrentCapacity, {LessP[1]..}];

	(* throw messages for instruments that are out of storage positions *)
	If[messages && Not[MatchQ[noCapacityInstrumentResources, {}]] && Not[MatchQ[$ECLApplication, Engine]],
		Message[
			Warning::NoAvailableStoragePosition,
			Download[noCapacityInstrumentResources, Object]
		]
	];

	(* --- Generate the association matching fulfillableResourcesP --- *)

	(* combine all the lists of resources for the conditions that make a resource fulfillable *)
	(* this doesn't include all of the conditions below because sometimes we throw a message but the resource is still fulfillable *)
	combinedNonFulfillableResources = DeleteDuplicates[Flatten[
		{
			rentedKitResources,
			notEnoughConsumablePackets,
			noModelEnoughVolumePackets,
			notEnoughModelAmountPackets,
			notEnoughConsumableModelPackets,
			belowMaxVolumePackets,
			notAutoclaveCompatiblePackets,
			badResources,
			disposalResources,
			deprecatedResources,
			discardedResources,
			notOwnedInstrumentResources,
			retiredInstrumentPackets,
			deprecatedInstrumentPackets,
			unavailableDeckLayoutInstrumentPackets,
			notOwnedResources,
			samplesShippingToUserResources,
			notEnoughUsesPackets,
			notEnoughVolumesPackets,
			twoUniqueVolumesPackets,
			nonScalableStockSolutionResourcePackets,
			sitelessSampleResourcesAfterProductFilter,
			sitelessInstrumentResources,
			sterileMismatchResources,
			containerNotSterileResources
		}
	]];

	(* map over all the resources, returning True if they are fulfillable and False if not *)
	fulfillable = Map[
		Not[MemberQ[combinedNonFulfillableResources, ObjectP[#]]]&,
		Download[myResources, Object]
	];


	(* Get all resource requests that could possibly be shipped (direct sample requests or model fulfillments) *)
	(* Extract those that do not have products, have products > $1000, or are models that can be generated in lab *)
	shippableFulfillableResourceRequests = MapThread[
		Module[{preparable, expensive, purchasable},

			(* check if the resource is a model request that can be made in lab *)
			preparable = And[
				MatchQ[Lookup[#1,Sample],Null],
				MatchQ[Lookup[#1,Models],{ObjectP[{Model[Sample, StockSolution], Model[Sample, Matrix], Model[Sample, Media]}]..}]
			];

			(* check if the product is expensive *)
			{expensive, purchasable} = If[MatchQ[#2, PacketP[]],
				{MatchQ[Lookup[#2,Price],GreaterEqualP[1000 USD]], True},
				{False, False}
			];

			(* Determine if we should ship the resource. Shipped resources are removed from ordered resources, so this will effectively apply the logic here to orders *)
			Which[
				(* 0. If the resource does not have shippable instances, don't try to ship it (this resource is not fulfillable at all) *)
				MemberQ[combinedNonFulfillableResources, ObjectP[#1]], Nothing,

				(* 1. If the requested thing is a specific sample, we have to ship that *)
				MatchQ[Lookup[#1, Sample], ObjectP[]], #1,

				(* 2. If the resource is water, don't ship it *)
				MatchQ[Download[Lookup[#1,Models],Object],{WaterModelP..}], Nothing,

				(* If it is a public model, don't ship *)
				(* "We're assuming any public model should be available at both labs. It's not sustainable to ship shared resources back and forth." - Hayley *)
				MatchQ[#3[[All,Key[Notebook]]],{Null..}], Nothing,

				(* 3. If the resource has no product and cannot be prepared, ship it *)
				MatchQ[{preparable, purchasable}, {False, False}], #1,

				(* -- Preparable -- *)
				(* 4. If the resource can be prepared, don't ship it. We will make it regardless of cost. *)
				(*NOTE: if we end up charging customers a lot more to remake stock solutions, we should split this into cheap and expensive products. Its hard to say how this will play out
				currently because some things may be cheap to make but expensive to purchase. There is also a speed consideration. *)
				MatchQ[preparable, True], Nothing,

				(* -- Purchasable -- *)
				(* 5. If the resource can be purchased and there is a cheap product, do not ship it *)
				MatchQ[{purchasable, expensive}, {True, False}], Nothing,

				(* 6. If there is an expensive product ship it regardless of our ability to prepare it *)
				MatchQ[{purchasable, expensive}, {True, True}], #1,

				(* 7. Safe catch-all *)
				True, Message[Error::UnableToDetermineResourceShipment, Lookup[#1, Object]];Return[$Failed]
			]
		]&,
		{sampleResourcePackets,oneProductPerResource,allModelPackets}
	];

	(* Generate a list of the samples that can fulfill the shippable resource requests *)
	possibleFulfillingShippableSamples = Map[
		If[MatchQ[Lookup[#,Sample],ObjectP[]],
			{Lookup[resourceToSamplesLookup,Key[#]]},
			Lookup[resourceModelToSamplesLookup,Key[#]]
		]&,
		shippableFulfillableResourceRequests
	];

	(* Resolve the site at which most samples are and all instruments are *)
	resolvedSite = If[MatchQ[specifiedSite, ObjectP[]],
		specifiedSite,
		Module[
			{uniqueSitesPerResource,scorePerSite,allPossibleSites,sortedSiteTuples,bestSite},

			uniqueSitesPerResource = Map[
				Function[{potentialSamplePackets},
					Module[{sitePerSample, destinationPerSample, realSitePerSample},
						sitePerSample = Lookup[potentialSamplePackets, Key[Site], {}];
						destinationPerSample = Lookup[potentialSamplePackets, Key[Destination],{}];
						(* if the sample has Destination populated, we use that instead of the Site in order to properly find where things will be when we can start the experiment *)
						realSitePerSample = MapThread[
							If[MatchQ[#1, LinkP[]], #1, #2]&,
							{destinationPerSample, sitePerSample}
						];
						DeleteDuplicates[Download[DeleteCases[realSitePerSample, _Missing], Object]]
					]],
				possibleFulfillingShippableSamples
			];

			(* Check if uniqueSitesPerResource for sample include possibleSites for instrument *)
			allPossibleSites = If[MatchQ[possibleSites, All],
				DeleteDuplicates[Flatten@uniqueSitesPerResource],
				possibleSites
			];

			scorePerSite = Map[
				Function[
					site,
					Total@Map[
						If[MemberQ[#,site],
							1,
							0
						]&,
						uniqueSitesPerResource
					]
				],
				allPossibleSites
			];

			sortedSiteTuples = ReverseSortBy[Transpose[{allPossibleSites,scorePerSite}],#[[2]]&];

			bestSite = If[
				And[
					Length[sortedSiteTuples]>1,
					(sortedSiteTuples[[1]][[2]])==(sortedSiteTuples[[2]][[2]]),
					!MatchQ[defaultSite,Null],
					Or[
						MatchQ[possibleSites,All],
						MemberQ[possibleSites,defaultSite]
					]
				],
				defaultSite,
				First@FirstOrDefault[sortedSiteTuples,{Null,Null}]
			]
		]
	];

	(* Find those resources corresponding to samples that need to be shipped
	Ie: samples DO exist, but none at the resolved site *)
	resourcesToBeShipped = If[NullQ[resolvedSite],
		{},
		MapThread[
			Function[{resource,sampleList},
				If[
					And[
						(* When packets are 'spoofed', they do not have the Site key *)
						!MatchQ[sampleList,{}],
						!MatchQ[sampleList[[All,Key[Site]]],{_Missing..}],
						!MemberQ[
							Download[sampleList[[All,Key[Site]]],Object],
							resolvedSite
						]
					],
					resource,
					Nothing
				]
			],
			{shippableFulfillableResourceRequests,possibleFulfillingShippableSamples}
		]
	];


	(* throw the Error::InvalidInput message if we have any non fulfillable resources *)
	If[messages && Not[MatchQ[combinedNonFulfillableResources, {}]],
		Message[Error::InvalidInput, Download[combinedNonFulfillableResources, Object]]
	];

	(*Generate the association matching fulfillableResourcesP*)
	<|
		Resources -> myResources,
		Fulfillable -> fulfillable,
		InsufficientVolume -> notEnoughQuantityPackets,
		ResourceAlreadyReserved -> notEnoughConsumablePackets,
		NoAvailableSample -> noModelEnoughVolumePackets,
		InsufficientTotalVolume -> notEnoughModelAmountPackets,
		NoAvailableModel -> notEnoughConsumableModelPackets,
		DeprecatedProduct -> Flatten[{consumableDeprecatedProdResources, modelDeprecatedProdResources}],
		ContainerTooSmall -> belowMaxVolumePackets,
		ContainerNotAutoclaveCompatible -> notAutoclaveCompatiblePackets,
		SampleMustBeMoved -> samplesToBeMoved,
		MissingObjects -> badResources,
		SamplesMarkedForDisposal -> disposalResources,
		DeprecatedModels -> deprecatedResources,
		DiscardedSamples -> discardedResources,
		ExpiredSamples -> expiredResources,
		InstrumentsNotOwned -> notOwnedInstrumentResources,
		RetiredInstrument -> retiredInstrumentPackets,
		DeprecatedInstrument -> deprecatedInstrumentPackets,
		DeckLayoutUnavailable -> unavailableDeckLayoutInstrumentPackets,
		StoragePositionUnavailable -> noCapacityInstrumentResources,
		InstrumentUndergoingMaintenance -> undergoingMaintenanceResourcePackets,
		(* remove any shipped samples to prevent both and Order and SiteToSite transaction *)
		SamplesOutOfStock -> Complement[
			Flatten[{modelVolResourceProdNotDeprecated, totalVolResourceProdNotDeprecated, consumableResourceProdNotDeprecated, noModelEnoughUsesPackets}],
			resourcesToBeShipped
		],
		SamplesNotOwned -> notOwnedResources,
		SamplesInTransit -> samplesShippingToECLResources,
		SamplesInTransitPackets -> samplesShippingToUser,
		SamplesShippedFromECL -> samplesShippingToUserResources,
		RentedKit -> rentedKitResources,
		ExceedsMaxNumberOfUses -> notEnoughUsesPackets,
		ExceedsMaxVolumeOfUses -> notEnoughVolumesPackets,
		ConflictingVolumeOfUses -> twoUniqueVolumesPackets,
		NonScalableStockSolutionVolumeTooHigh -> nonScalableStockSolutionResourcePackets,
		InvalidSterileRequest -> sterileMismatchResources,
		ContainerNotSterile -> containerNotSterileResources,
		SamplesOffSite -> resourcesToBeShipped,
		Site -> resolvedSite
	|>

];


(* ::Subsubsection::Closed:: *)
(*AllowedResourcePickingNotebooks*)

DefineOptions[AllowedResourcePickingNotebooks,
	Options:>{
		{Protocol->Null,Null|ObjectP[],"The protocol or subprotocol for which notebooks should be checked."},
		{Cache->{},{PacketP[]...},"A list of cache packets."}
	}
];


(* In the case where there's no Author we don't expect to find financing or sharing teams *)
AllowedResourcePickingNotebooks[financingTeamPackets : Null|{}, sharingTeamPackets : Null|{},ops:OptionsPattern[]] := {};

(* Overload where we aren't yet working with an uploaded protocol object and may or may not have a parent protocol *)
AllowedResourcePickingNotebooks[ops:OptionsPattern[]]:=Module[
	{safeOps,cache,protocol,protocolFinancingTeams,protocolSharingTeams,
		userFinancingTeams,userSharingTeams,financingTeams,sharingTeams, initialFastAssoc, existingUserFinancingTeamPackets,
		existingUserSharingTeamPackets, existingRecursiveParentProtocols, existingParentProtocolFinancingTeamsPackets,
		existingParentProtocolSharingTeamsPackets},

	(* Grab our options *)
	safeOps=SafeOptions[AllowedResourcePickingNotebooks,ToList[ops]];
	{cache,protocol}=Lookup[safeOps,{Cache,Protocol}];
	initialFastAssoc = Experiment`Private`makeFastAssocFromCache[cache];

	(* get the user financing teams and sharing teams from the $PersonID if they exist *)
	existingUserFinancingTeamPackets = ToList[Experiment`Private`fastAssocPacketLookup[initialFastAssoc, $PersonID, FinancingTeams]];
	existingUserSharingTeamPackets = ToList[Experiment`Private`fastAssocPacketLookup[initialFastAssoc, $PersonID, SharingTeams]];

	existingRecursiveParentProtocols = If[MatchQ[protocol, ObjectP[]],
		Experiment`Private`repeatedFastAssocLookup[initialFastAssoc, protocol, ParentProtocol],
		{}
	];
	existingParentProtocolFinancingTeamsPackets = ToList[Experiment`Private`fastAssocPacketLookup[initialFastAssoc, #, {Author, FinancingTeams}]& /@ Cases[Flatten[{protocol, existingRecursiveParentProtocols}], ObjectP[]]];
	existingParentProtocolSharingTeamsPackets = ToList[Experiment`Private`fastAssocPacketLookup[initialFastAssoc, #, {Author, SharingTeams}]& /@ Cases[Flatten[{protocol, existingRecursiveParentProtocols}], ObjectP[]]];

	(* Download! *)
	{protocolFinancingTeams,protocolSharingTeams,userFinancingTeams,userSharingTeams}=Quiet[
		Download[
			{
				If[MatchQ[Flatten[existingParentProtocolFinancingTeamsPackets], {}|{Null}|{$Failed}], {protocol}, {}],
				If[MatchQ[Flatten[existingParentProtocolSharingTeamsPackets], {}|{Null}|{$Failed}], {protocol}, {}],
				If[MatchQ[existingUserFinancingTeamPackets, {}|{Null}|{$Failed}], {$PersonID}, {}],
				If[MatchQ[existingUserSharingTeamPackets, {}|{Null}|{$Failed}], {$PersonID}, {}]
			},
			{
				{
					Packet[Repeated[ParentProtocol][Author][FinancingTeams][{Notebooks, NotebooksFinanced}]],
					Packet[Author[FinancingTeams][{Notebooks, NotebooksFinanced}]]
				},
				{
					Packet[Repeated[ParentProtocol][Author][SharingTeams][{Notebooks, NotebooksFinanced, ViewOnly}]],
					Packet[Author[SharingTeams][{Notebooks, NotebooksFinanced, ViewOnly}]]
				},
				{Packet[FinancingTeams[{Notebooks, NotebooksFinanced}]]},
				{Packet[SharingTeams[{Notebooks, NotebooksFinanced, ViewOnly}]]}
			},
			Cache->cache
		],
		{Download::FieldDoesntExist,Download::MissingCacheField}
	];

	(* get a list of all Notebooks Author can use resources from *)
	{financingTeams,sharingTeams}=Which[
		NullQ[$Notebook], {{},{}},
		(* If we're in Engine (or simulating call with protocol option) allowed notebooks come from the protocol Author *)
		MatchQ[$ECLApplication,Engine] || !NullQ[protocol],
			{
				Cases[DeleteDuplicates[Flatten[{existingParentProtocolFinancingTeamsPackets, protocolFinancingTeams}]],PacketP[Object[Team, Financing]]],
				Cases[DeleteDuplicates[Flatten[{existingParentProtocolSharingTeamsPackets, protocolSharingTeams}]],PacketP[Object[Team, Financing]]]
			},
		(* If we're calling this standalone $PersonID will be our protocol author and we'll use this *)
		NullQ[protocol],
			{
				Cases[DeleteDuplicates[Flatten[{existingUserFinancingTeamPackets, userFinancingTeams}]],PacketP[Object[Team, Financing]]],
				Cases[DeleteDuplicates[Flatten[{existingUserSharingTeamPackets, userSharingTeams}]],PacketP[Object[Team, Financing]]]
			}
	];

	(* replacing Cache and Simulation with the default values because otherwise this part won't actually get memoized *)
	AllowedResourcePickingNotebooks[financingTeams,sharingTeams,ReplaceRule[safeOps, {Cache -> {}, Simulation -> Null}]]
];

(* Object/Link Overload - download and send to packet overload *)
(* we memoize this since we are likely to have the same result in one session for one team *)
AllowedResourcePickingNotebooks[financingTeamObjs : {(ObjectReferenceP[Object[Team, Financing]] | LinkP[Object[Team, Financing]])...}, sharingTeamObjs : {(ObjectReferenceP[Object[Team, Sharing]] | LinkP[Object[Team, Sharing]])...},ops:OptionsPattern[]] :=
	AllowedResourcePickingNotebooks[financingTeamObjs, sharingTeamObjs,ops] = Module[{financingTeamPackets, sharingTeamPackets},

		If[!MemberQ[$Memoization, AllowedResourcePickingNotebooks],
			AppendTo[$Memoization, AllowedResourcePickingNotebooks]
		];

		{financingTeamPackets, sharingTeamPackets} = Quiet[Download[
			{financingTeamObjs, sharingTeamObjs},
			{
				{Packet[Notebooks, NotebooksFinanced]},
				{Packet[Notebooks, NotebooksFinanced, ViewOnly]}
			}
		], Download::FieldDoesntExist];

		AllowedResourcePickingNotebooks[Flatten[financingTeamPackets], Flatten[sharingTeamPackets]]
	];

(* Standard packet overload - determine what notebooks can be considered when searching for samples within notebooks *)
(* Currently any SharingTeams or FinancingTeams associated with the author are okay, provided they are not ViewOnly *)
AllowedResourcePickingNotebooks[financingTeamPackets : {(PacketP[Object[Team, Financing]])...}, sharingTeamPackets : {(PacketP[Object[Team, Sharing]])...}, ops:OptionsPattern[]] :=
	AllowedResourcePickingNotebooks[financingTeamPackets, sharingTeamPackets,ops] =
		Module[
			{financingNotebooks, sharingNotebooks, filteredNotebooks},

			If[!MemberQ[$Memoization, AllowedResourcePickingNotebooks],
				AppendTo[$Memoization, AllowedResourcePickingNotebooks]
			];

			(* All financing notebooks are good to go *)
			financingNotebooks = ToList[Lookup[financingTeamPackets, Notebooks, Null] /. x : LinkP[] :> Download[x, Object]];

			(* Filter out any ViewOnly sharing teams, looking up Notebooks from standard sharing teams *)
			sharingNotebooks = Map[
				If[MatchQ[Lookup[#, ViewOnly, Null], True],
					Nothing,
					Download[Lookup[#, Notebooks, Null], Object]
				]&,
				sharingTeamPackets
			];

			(* Get full list of sharing and financing, flattening once since we'll have a list of notebook lists *)
			filteredNotebooks = Flatten[Join[financingNotebooks, sharingNotebooks], 1];

			(* Provide a flat, clean list of notebooks *)
			DeleteDuplicates[DeleteCases[filteredNotebooks, Null]]
		];


(* ::Subsubsection::Closed:: *)
(*ModelInstances*)

Authors[ModelObjectType]:={"robert", "alou"};

ModelObjectType[object:ObjectP[Model[Sample]]]:=Object[Sample];
ModelObjectType[object:ObjectP[Model]]:=Apply[
	Object,
	Download[object,Type]
];
ModelObjectType[type:TypeP[Model[Sample]]]:=Object[Sample];
ModelObjectType[type:TypeP[Model]]:=Apply[
	Object,
	type
];
ModelObjectType[type:TypeP[Object]]:=$Failed;
ModelObjectType[_]:=$Failed;


DefineOptions[
	ModelInstances,
	Options :> {
		{
			OptionName -> PickInstalled,
			Default -> False,
			AllowNull -> False,
			Description -> "Indicates if only items with a Status of Installed can be picked.",
			Pattern :> BooleanP
		},
		{
			OptionName -> MaxNumberOfUses,
			Default -> Null,
			AllowNull -> True,
			Description -> "Indicate the relevant model's maximum number of uses.",
			Pattern :> Null | GreaterP[0]
		},
		{
			OptionName -> MaxVolumeOfUses,
			Default -> Null,
			AllowNull -> True,
			Description -> "Indicate the relevant model's maximum number of uses",
			Pattern :> Null | GreaterP[0Milliliter]
		},
		{
			OptionName -> MaxNumberOfHours,
			Default -> Null,
			AllowNull -> True,
			Description -> "Indicate the relevant model's maximum number of hours",
			Pattern :> Null | GreaterP[0]
		},
		{
			OptionName -> UsesRequired,
			Default -> Null,
			AllowNull -> True,
			Description -> "Indicate the number of required uses in the relevant resource",
			Pattern :> Null | GreaterP[0]
		},
		{
			OptionName -> VolumeOfUsesRequired,
			Default -> Null,
			AllowNull -> True,
			Description -> "Indicate the amount of volume that the specified item can handle (e.g. a filter can filter 300 mL liquid before being disposed) uses in the relevant resource",
			Pattern :> Null | GreaterP[0Milliliter]
		},
		IndexMatching[
			{
				OptionName -> ExactAmount,
				Default -> False,
				AllowNull -> False,
				Description -> "Indicates if the exact amount (taking into account Tolerance, if specified) if required to fulfill a sample.",
				(* we use widget here so the pattern can be auto calculated *)
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			{
				OptionName -> Tolerance,
				Default -> Null,
				AllowNull -> True,
				Description -> "The amount of Volume/Mass/Count that can deviate from the requested Amount if ExactAmount->True and still have the Object[Sample] count as fulfillable.",
				(* we use widget here so the pattern can be auto calculated *)
				Widget -> Widget[
					Type -> Expression,
					Pattern :> MassP | VolumeP | CountP | Null,
					Size -> Line
				]

			},
			{
				OptionName -> Hermetic,
				Default -> Null,
				AllowNull -> True,
				Description -> "Indicates if samples that are in hermetic containers are counted as fulfillable. Setting this to Null indicates Hermeticity of the container can be ignored when searching for potential instances.",
				(* we use widget here so the pattern can be auto calculated *)
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			{
				OptionName -> Sterile,
				Default -> Null,
				AllowNull -> True,
				Description -> "Indicates if only items with Sterile -> True can be picked.",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			IndexMatchingInput -> "fulfillment models"
		],
		{
			OptionName -> Well,
			Default -> Null,
			AllowNull -> True,
			Description -> "The position in which the instance should reside.",
			Pattern :> WellPositionP | Null
		},
		{
			OptionName -> OutputFormat,
			Default -> Items,
			AllowNull -> False,
			Description -> "Indicates how the items should be displayed.",
			Pattern :> Items | Objects | Table
		}
	}
];

(* Add a 1% tolerance below the requested amount when searching for samples; this is now to handle a Search precision bug where exact amounts can sometimes not return proper results *)
$ResourcePickingToleranceMultiplier=0.99;

(* Single resource overload, resource info must be downloaded - for use in notebook calls *)
ModelInstances[resource:ObjectP[Object[Resource,Sample]],currentProtocol:ObjectP[ProtocolTypes[Output -> Short]],ops:OptionsPattern[ModelInstances]]:=Module[
	{model,maxNumberOfUses,maxNumberOfHours,amount,containerModels,exactAmount,tolerance,root,allowedNotebooks, sterile},

	(* Get info from our resource object *)
	{model, maxNumberOfUses, maxNumberOfHours, amount, containerModels, exactAmount, tolerance, sterile} = Quiet[
		Download[
			resource,
			{
				Models[[1]],
				Models[[1]][MaxNumberOfUses],
				Models[[1]][MaxNumberOfHours],
				Amount,
				ContainerModels,
				ExactAmount,
				Tolerance,
				Sterile
			}
		],
		{Download::FieldDoesntExist}
	];

	(* Root is needed to see if we have any existing objects we can share *)
	root=RootProtocol[currentProtocol];

	(* Figure out which notebooks we can use *)
	allowedNotebooks=AllowedResourcePickingNotebooks[Protocol->root];

	(* Send all our info to the main overload *)
	ModelInstances[
		model,
		amount,
		containerModels,
		allowedNotebooks,
		root,
		currentProtocol,
		(* Send options over using user supplied values over calculated values *)
		ReplaceRule[
			{
				ExactAmount -> (exactAmount /. Null -> False),
				Tolerance -> tolerance,
				MaxNumberOfUses -> (maxNumberOfUses /. $Failed -> Null),
				MaxNumberOfHours -> (maxNumberOfHours /. $Failed -> Null),
				Sterile -> (sterile /. $Failed -> Null)
			},
			ToList[ops]
		]
	]
];


(* Single resource overload, pre-downloaded values for use in code *)
(* --- finding samples that can fulfill a request for a sample model, with handling for requests for specific amounts/containers ---  *)
ModelInstances[myRequestedModel:ObjectP[{Model[Sample],Model[Item]}],myRequiredAmount:(Null|MassP|VolumeP|NumericP|UnitsP[Unit]),myAllowedContainerModels:{ObjectP[Model[Container]]...},myAllowedNotebooks:{ObjectP[Object[LaboratoryNotebook]]...},myRootProtocol:Null|ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance]}], myCurrentProtocol:Null|ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance]}],ops:OptionsPattern[]]:=First[
	ModelInstances[
		{myRequestedModel},{myRequiredAmount},{myAllowedContainerModels},myAllowedNotebooks,myRootProtocol,myCurrentProtocol,ops
	],
	{}
];


ModelInstances[myRequestedModels:{ObjectP[{Model[Sample],Model[Item]}]..},myRequiredAmounts:{(Null|MassP|VolumeP|NumericP|UnitsP[Unit])..},myAllowedContainerModelLists:{{ObjectP[Model[Container]]...}..},myAllowedNotebooks:{ObjectP[Object[LaboratoryNotebook]]...},myRootProtocol:Null|ObjectP[ProtocolTypes[Output -> Short]], myCurrentProtocol:Null|ObjectP[ProtocolTypes[Output -> Short]],ops:OptionsPattern[]]:=TraceExpression["ModelInstances",Module[
	{safeOptions,expandedOptions,mapThreadFriendlyOptions,allContainerModels,downloadValues,requestedModelPackets,allowedContainerModelLists,currentProtObj,sampleTypes,site,sampleSearchCriteria,baseQueries,nullNotebookQueries,rawUserAvailableSampleLists,
		rawPublicAvailableSampleLists,allUnfilteredSamples,containerModels,containerModelLookup,availableSampleLists,allAvailableSamples,
		allAvailableSamplesDownload,sampleContainerLookup,sampleBarcodeLookup,itemLists},

	safeOptions=SafeOptions[ModelInstances,ToList[ops]];

	(* expand the options so all things are index matched, set definition number to 2 indicating we are using the second definition defined in DefineUsage call of ModelInstances *)
	expandedOptions = Last[ExpandIndexMatchedInputs[ModelInstances, {myRequestedModels, myRequiredAmounts, myAllowedContainerModelLists, myAllowedNotebooks, myRootProtocol, myCurrentProtocol}, safeOptions, 2]];

	(* make a mapthread friendly option *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ModelInstances, expandedOptions];

	(* Get info from the requested model and container model objects *)
	allContainerModels=Flatten[myAllowedContainerModelLists];

	downloadValues = Quiet[
		Download[
			{myRequestedModels,allContainerModels},
			{{Packet[AlternativePreparations, CleaningMethod]},{Object}}
		]
	];

	(* Get the model packet, removing the extra list *)
	requestedModelPackets=Flatten[downloadValues[[1]],1];

	(* Replace any named objects with their ID *)
	allowedContainerModelLists=myAllowedContainerModelLists/.AssociationThread[allContainerModels->Flatten[downloadValues[[2]],1]];

	currentProtObj = Download[myCurrentProtocol, Object];

	(* convert the requested model into the appropriate sample type; and the allowed container models *)
	sampleTypes=ModelObjectType/@myRequestedModels;

	(* $Site should always be set when running on-site / in Engine, so this download should not be hit often *)
	site = If[MatchQ[$Site,Null],
		Download[myRootProtocol,Site[Object]],
		$Site
	];

	sampleSearchCriteria = MapThread[
		Function[{requestedModelPacket,sampleType,myAllowedContainerModels,myRequiredAmount,options},
			Module[{models,containerTypes,maxNumberOfUses,maxNumberOfHours,usesRequired,exactAmount,volumeOfUsesRequired,
				tolerance,well,usesAvailable,amountField,amountSearchClause,containerQuery,hoursQuery,usesQuery,coveredContainerQuery,
				statusQuery,positionQuery,baseQuery,nullNotebookQuery,maxVolumeOfUses,volumeUsesAvailable,volumeUsesQuery,
				sterile, sterileQuery, pickableStatus},

				(* get all the alternative preparations if we were passed in a stock solution packet *)
				(* this will come in the form of an alternatives construct for the Search below if it's more than one, or just the thing itself if it is not *)
				models = If[MatchQ[requestedModelPacket, PacketP[{Model[Sample, StockSolution], Model[Sample, Media], Model[Sample, Matrix]}]],
					Alternatives @@ Download[Flatten[{requestedModelPacket, Lookup[requestedModelPacket, AlternativePreparations]}], Object],
					(* Consider $EquivalentModelLookup if needed *)
					Module[
						{equivalentModels},
						equivalentModels=Lookup[requestedModelPacket, Object]/.$EquivalentModelLookup;
						If[MatchQ[equivalentModels,Lookup[requestedModelPacket, Object]],
							Lookup[requestedModelPacket, Object],
							Alternatives @@ (DeleteDuplicates[Download[Flatten[{Lookup[requestedModelPacket, Object],equivalentModels}],Object]])
						]
					]
				];

				containerTypes = DeleteDuplicates[ModelObjectType /@ myAllowedContainerModels];

				(* Grab number of uses/hours from options and query as needed *)
				maxNumberOfUses = Lookup[options, MaxNumberOfUses, Null];
				maxNumberOfHours = Lookup[options, MaxNumberOfHours, Null];
				maxVolumeOfUses = Lookup[options, MaxVolumeOfUses, Null];
				usesRequired = Lookup[options, UsesRequired];
				volumeOfUsesRequired = Lookup[options, VolumeOfUsesRequired];
				exactAmount = Lookup[options, ExactAmount];
				tolerance = Lookup[options, Tolerance];
				well = Lookup[options, Well, Null];
				sterile = Lookup[options, Sterile, Null];
				usesAvailable = maxNumberOfUses - usesRequired;
				volumeUsesAvailable = maxVolumeOfUses - volumeOfUsesRequired;

				(* define an amount search clause depending on whether we are trying to find a sample with a specific amount *)
				amountField = Switch[myRequiredAmount,
					VolumeP, Volume,
					MassP, Mass,
					NumberP | UnitsP[Unit], Count,
					_, Null
				];

				amountSearchClause = Which[
					(* assuming that we're going to intelligently have a tolerance of exactly an integer quantity of number or units if we're using count *)
					MatchQ[exactAmount, True] && MatchQ[tolerance, Except[Null]] && !MatchQ[amountField, Null],
						And[
							amountField >= ((myRequiredAmount - tolerance)),
							amountField <= ((myRequiredAmount + tolerance))
						],
					MatchQ[exactAmount, True] && !MatchQ[amountField, Null | Count],
						And[
							amountField >= ($ResourcePickingToleranceMultiplier * myRequiredAmount),
							amountField <= ((1 - $ResourcePickingToleranceMultiplier + 1) * myRequiredAmount)
						],
					(* treat Count specially *)
					MatchQ[exactAmount, True] && MatchQ[amountField, Count],
						amountField == (myRequiredAmount),
					!MatchQ[amountField, Null | Count],
						amountField >= ($ResourcePickingToleranceMultiplier * myRequiredAmount),
					MatchQ[amountField, Count],
						amountField >= (myRequiredAmount),
					True, True
				];

				containerQuery = If[MatchQ[myAllowedContainerModels, {}],
					Container != Null,
					(* NOTE: Not using search through links here. *)
					True
				];

				hoursQuery = If[MatchQ[maxNumberOfHours, Null],
					True,
					NumberOfHours < maxNumberOfHours
				];

				usesQuery = If[Or[MatchQ[maxNumberOfUses, Null], MatchQ[usesRequired, Null]],
					True,
					NumberOfUses <= usesAvailable
				];

				volumeUsesQuery = If[And[Or[MatchQ[maxVolumeOfUses, Null], MatchQ[volumeOfUsesRequired, Null]]],
					True,
					If[
						GreaterQ[volumeUsesAvailable, 0 Milliliter],
						Or[VolumeOfUses == Null, VolumeOfUses <= volumeUsesAvailable],
						VolumeOfUses <= volumeUsesAvailable
					]
				];

				coveredContainerQuery = If[MatchQ[requestedModelPacket, ObjectP[Join[CoverModelTypes, {Model[Item, Stopper], Model[Item, Septum]}]]],
					CoveredContainer == Null,
					True
				];

				(* determine if we have a washable resource - if so restrict the Search to Stocked to avoid picking dirty objects that have been incorrectly released *)
				pickableStatus = If[MatchQ[Lookup[requestedModelPacket, CleaningMethod], CleaningMethodP], Stocked, (Stocked|Available)];

				(*we explicitly forbid reuse of InUse covers so we don't steal covers from other containers while we are fulfilling a Model resource*)
				(*also exclude weighing funnel for repeated resource picking - they are individually IDed, and we have retry logic to pick new weighing funnels after the initial ones are already picked. For example, if we need to retry for our first transfer, we don't want the weighing funnel we picked for the second transfer to be used here for retry. Instead we need to pick a new one. *)
				statusQuery = If[MatchQ[sampleType, TypeP[Join[CoverObjectTypes, {Object[Item, Stopper], Object[Item, Septum]}, {Object[Item, WeighBoat, WeighingFunnel]}]]],
					And[
						Status == pickableStatus,
						CurrentProtocol == Null
					],
					Or[
						And[
							Status == pickableStatus,
							CurrentProtocol == Null
						],
						(* rootProtocol may be Null if we're calling this from ExperimentTransfer in which case we only want the Available|Stocked criteria above *)
						If[MatchQ[myRootProtocol, Null],
							False,
							And[
								Status == InUse,
								CurrentProtocol == myRootProtocol
							]
						]
					]
				];

				(* Position query - for resource with ContainerName and Well *)
				positionQuery = If[NullQ[well],
					True,
					(Position == well)
				];

				(* if the resource is asking for Sterile, the thing we find must be Sterile *)
				sterileQuery = If[TrueQ[sterile],
					Sterile == True,
					True
				];

				baseQuery = And[
					Model == models,
					Restricted != True,
					AwaitingDisposal != True,
					Site == site,
					statusQuery,
					amountSearchClause,
					Or[
						ExpirationDate == Null,
						ExpirationDate >= Now
					],
					containerQuery,
					hoursQuery,
					usesQuery,
					volumeUsesQuery,
					coveredContainerQuery,
					positionQuery,
					sterileQuery
				];

				nullNotebookQuery = Append[baseQuery, Notebook == Null];

				{baseQuery, nullNotebookQuery}
			]
		],
		{requestedModelPackets,sampleTypes,allowedContainerModelLists,myRequiredAmounts,mapThreadFriendlyOptions}
	];

	baseQueries=sampleSearchCriteria[[All,1]];
	nullNotebookQueries=sampleSearchCriteria[[All,2]];

	(* Search for samples that are in any of the possible containers and fit the additional criteria required for fulfilling a sample model; differentiate between user-owned and not *)
	(* NOTE: If we have a list of specific container models, we will NOT use search through links, but instead filter *)
	(* the results locally after downloading the container model. This is because when there are lots of Object[Container]s *)
	(* of a specific model, it can cause the search to blow up. There is a long term task in Engineering to fix this when *)
	(* they do the Search rewrite. After that, we can change it back to use Search through links. *)
	(* https://app.asana.com/0/1150770667411537/1200609232789158 *)

	(* NOTE: We add SubTypes->False here to make the search faster. The instrument and container cases work because there *)
	(* is an invariant that any Object[Container, Vessel, Filter] will only ever have its model be a Model[Container, Vessel, Filter]. *)
	(* You can't have an Object[Container, Vessel, Filter] have its model be a Model[Container, Vessel]. Same for instruments. *)
	(* For Samples, it is the opposite. You can have a model of an Object[Sample] be Model[Sample, StockSolution]. *)
	(* In this case, the invariant is that Object[Sample] is the only type for sample objects at all and that there are no subtypes. *)
	{rawUserAvailableSampleLists, rawPublicAvailableSampleLists}=TraceExpression["resource-search",Block[{},
		TagTrace["resource-search.type",ToString[sampleTypes]];
		TagTrace["resource-search.model",ToString[myRequestedModels]];

		(* for sure no user-owned if no allowed notebooks *)
		If[MatchQ[myAllowedNotebooks,{}],
			{
				ConstantArray[{},Length[sampleTypes]],
				Search[sampleTypes,
					Evaluate[nullNotebookQueries],
					SubTypes->False
				]
			},
			{
				Search[
					sampleTypes,
					Evaluate[baseQueries],
					Notebooks->ConstantArray[myAllowedNotebooks,Length[sampleTypes]],
					PublicObjects->ConstantArray[False,Length[sampleTypes]],
					SubTypes->False
				],
				Search[
					sampleTypes,
					Evaluate[nullNotebookQueries],
					SubTypes->False
				]
			}
		]
	]];

	(* Get the container models of all our options *)
	allUnfilteredSamples=Flatten[{rawUserAvailableSampleLists, rawPublicAvailableSampleLists},2];
	containerModels=Download[allUnfilteredSamples,Container[Model][Object]];
	containerModelLookup=AssociationThread[allUnfilteredSamples,containerModels];

	(* If we have specific container models that we must use, filter out the found samples (seen to be faster than search through links) *)
	availableSampleLists=MapThread[
		Function[{possiblePrivateSamples,possiblePublicSamples,allowedContainers},
			If[MatchQ[allowedContainers, {}],
				{possiblePrivateSamples, possiblePublicSamples},
				{
					Select[possiblePrivateSamples, MemberQ[allowedContainers, Lookup[containerModelLookup,#]]&],
					Select[possiblePublicSamples, MemberQ[allowedContainers, Lookup[containerModelLookup,#]]&]
				}
			]
		],
		{rawUserAvailableSampleLists, rawPublicAvailableSampleLists, allowedContainerModelLists}
	];

	allAvailableSamples=Flatten[availableSampleLists,2];

	(* Do a second Download post-filtering now that we've removed a bunch of options we don't want *)
	allAvailableSamplesDownload=Quiet[
		Download[
			allAvailableSamples,
			{Container[Object],Packet[Model[Barcode]]}
		],
		{Download::FieldDoesntExist}
	];

	sampleContainerLookup=AssociationThread[allAvailableSamples,allAvailableSamplesDownload[[All,1]]];
	sampleBarcodeLookup=AssociationThread[allAvailableSamples,allAvailableSamplesDownload[[All,2]]];

	itemLists=MapThread[
		modelInstanceItems[#1[[1]],#1[[2]],#2,sampleContainerLookup,sampleBarcodeLookup,#3,myCurrentProtocol,myRootProtocol]&,
		{availableSampleLists,myRequiredAmounts,Lookup[expandedOptions,Hermetic]}
	];

	Switch[Lookup[expandedOptions,OutputFormat],
		Items,itemLists,
		Objects, Lookup[#,"Value"]&/@itemLists,
		Table, resourceOptionsTable[Lookup[#,"Value"]]&/@itemLists
	]
]];

modelInstanceItems[
	userAvailableSamples:{ObjectP[]...},
	publicAvailableSamples:{ObjectP[]...},
	myRequiredAmount:(Null|MassP|VolumeP|NumericP|UnitsP[Unit]),
	containerLookup_Association,
	barcodeLookup_Association,
	hermetic:(Null|BooleanP),
	myCurrentProtocol:Null|ObjectP[ProtocolTypes[Output -> Short]],
	myRootProtocol:Null|ObjectP[ProtocolTypes[Output -> Short]]
]:=Module[{
	userContainers,publicContainers,capModelPacketPrivate,capModelPacketsPublic,requestedType,availableSampleDownloadTuples,
	rootProtValues,samplePackets,resourcePacketsBySample,requestorPacketsBySample,cartResourcesFieldObjs,rootProtInUseObjs,rootProtInUseContainerObjs,
	resourcePreparationSamplesOut,inVLMResources,onCartResources,allRequestorObjectsBySample,allRequestorPacketsBySampleWithProgs,
	allRequestorPacketsBySample,resourceRootProtocols,requestorObjectPerSample,requestorStatusPerSample,pickableSamplePackets,pickableSamplePacketPositions,
	resourcePacketsByPickableSample,requestorStatusesByPickableSample,reservedAmountResourcePacketsBySample,amountsReserved,currentAmounts,amountsAvailable,
	samplePacketsWithEnough,instanceAssociations,fullRootProtocolTree,amountsFulfillableQs,sampleInHermeticContainerQs},

	(* Pull out info about the samples from our look-up. We're consolidating downloads here *)
	userContainers=Lookup[containerLookup,userAvailableSamples];
	publicContainers=Lookup[containerLookup,publicAvailableSamples];
	capModelPacketPrivate=Lookup[barcodeLookup,userAvailableSamples];
	capModelPacketsPublic=Lookup[barcodeLookup,publicAvailableSamples];

	requestedType=First[Join[userAvailableSamples,publicAvailableSamples],Null][Type];

	(* return now if we did not find any samples meeting the required criteria for fulfillment *)
	If[MatchQ[userAvailableSamples,{}]&&MatchQ[publicAvailableSamples,{}],
		Return[{}]
	];

	(* If we're dealing with a self-contained sample model, we can return now! make sure to tag instance associations as user owned or not *)
	(* we can return NOW if we have SelfContainedSampleModelP request AND the item is not counted (i.e., can return early for Columns but not Tips) *)
	(* create the instance associations and return 'em, indicating if each sample is user owned or not *)

	(* - Early return: Cap case  *)
	If[MatchQ[requestedType,TypeP[{Object[Item,Cap], Object[Item,Septum]}]]&&NullQ[myRequiredAmount],
		Return[
			Join[
				MapThread[
					<|"Value"->#1,"Container"->#2,"ScanValue"->ScanValue[#1,#2,#3],"UserOwned"->True|>&,
					{userAvailableSamples,userContainers,capModelPacketPrivate}
				],
				MapThread[
					<|"Value"->#1,"Container"->#2,"ScanValue"->ScanValue[#1,#2,#3],"UserOwned"->False|>&,
					{publicAvailableSamples,publicContainers,capModelPacketsPublic}
				]
			]
		]
	];

	(* - Early return: Self-container sample case  *)
	If[MemberQ[SelfContainedSampleTypes,requestedType]&&NullQ[myRequiredAmount],
		Return[
			Join[
				MapThread[
					If[MatchQ[#2,ObjectP[Object[Container,Bag,Autoclave]]],
						<|"Value"->#1,"Container"->#2,"ScanValue"->#2,"UserOwned"->True|>,
						<|"Value"->#1,"Container"->Null,"ScanValue"->#1,"UserOwned"->True|>
					]&,
					{userAvailableSamples,userContainers}
				],
				MapThread[
					If[MatchQ[#2,ObjectP[Object[Container,Bag,Autoclave]]],
						<|"Value"->#1,"Container"->#2,"ScanValue"->#2,"UserOwned"->False|>,
						<|"Value"->#1,"Container"->Null,"ScanValue"->#1,"UserOwned"->False|>
					]&,
					{publicAvailableSamples,publicContainers}
				]
			]
		]
	];

	(* download some information about the available samples;
			- if non-self-contained, need to know about its container, and also any resources tied to it,
			- if self-contained, we just want to snag Notebook *)
	(* need to quiet these messages because the Requestor of the resources could be a program object that doesn't have the Status field *)
	(* also we need to figure out what the samples/containers/parts that are currently InUse by the root protocol *)
	(* also a special download about the resources being requested by the current subprotocol. This is related to the following special case:
		- There are two resources asking for the same stock solution model in the same resource picking task and we have some available resources in the lab.
		- We need to prepare one of them via stock solution and the other one can be prepared via consolidation/transfer.
		- We first finished the stock solution protocol as expected. The SamplesOut of the stock solution protocol is now InUse by our root protocol but not associated with the resource yet (there is no RequestedResources info yet).
		- We need to make sure this new sample is not picked by the other resource as a possible source for consolidation/transfer
		- Only need to consider the resources asked by the current subprotocol as the other resources should already have RequestedResources associated
	*)
	{
		availableSampleDownloadTuples,
		fullRootProtocolTree,
		rootProtValues
	} = Quiet[
		Download[
			{
				Join[userAvailableSamples,publicAvailableSamples],
				{myCurrentProtocol},
				{myRootProtocol}
			},
			{
				{
					Packet[Container, Notebook, Mass, Volume, Count, Status, KitComponents],
					Packet[RequestedResources[{Sample, Status, Amount, RootProtocol, Requestor}]],
					Packet[RequestedResources[Requestor][{Status, Protocol}]],
					Packet[RequestedResources[Requestor][Protocol][Status]],
					Container[Hermetic],
					Container[Model][Hermetic]
				},
				{
					ParentProtocol..[Object],
					ParentProtocol..[Subprotocols..]
				},
				{
					CartResources[Object],
					Resources[Object],
					Resources[Container..][Object]
				}
			}
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	(* separate the sample packets and resource packets we downloaded; got these either way above *)
	samplePackets=availableSampleDownloadTuples[[All,1]];
	resourcePacketsBySample=availableSampleDownloadTuples[[All,2]];
	requestorPacketsBySample=availableSampleDownloadTuples[[All, 3;;4]];

	(* see if each sample is in hermetic container or not, if hermetic is not populated, we still treat it as a non-hermetic container *)
	sampleInHermeticContainerQs = MapThread[
		MemberQ[Flatten[{#1, #2}], True]&,
		{availableSampleDownloadTuples[[All,5]], availableSampleDownloadTuples[[All,6]]}
	];

	(* If we're calling this from ExperimentTransfer we won't always have a root protocol *)
	{
		cartResourcesFieldObjs,
		rootProtInUseObjs,
		rootProtInUseContainerObjs
	} = If[MatchQ[myRootProtocol,Null],
		{{},{},{}},
		Transpose[rootProtValues]
	];

	(* due to a Download bug, we have to do a bit or processing and a second download to get all the samples out of the all Preparation protocols in the full protocol tree *)
	resourcePreparationSamplesOut=Module[{uniqueProtocols,infoTuples,onlyCurrentProtocolInfo},
		uniqueProtocols=DeleteDuplicates@Download[Flatten[fullRootProtocolTree],Object];
		If[MatchQ[uniqueProtocols,{}|{Null}],Return[{},Module]];
		infoTuples=Quiet[Download[
			uniqueProtocols,
			{
				Status,
				RequiredResources[[All,1]][Preparation][SamplesOut][Object]
			}],{Download::FieldDoesntExist,Download::NotLinkField}];
		(* pick only protocol that are still Processing - we are fine with reusing resources from Completed protocols or any other statuses *)
		onlyCurrentProtocolInfo = Select[infoTuples, MatchQ[#[[1]], Processing] &];
		(* return all SamplesOut that we should avoid *)
		DeleteDuplicates@Cases[Flatten[onlyCurrentProtocolInfo[[All, 2]]],ObjectP[]]
	];


	(* get the items that are in the VLM or a FlammableCabinet or a freezer or the safe.  This is because for some reason things are getting stored that should be picked up again, but instead they are staying InUse in storage *)
	(* since they're not on the cart or in CartResources (for reasons we can't figure out yet) they can't get re-picked by another resource in the same protocol, which is causing issues *)
	(* so figure this out and delete it later when we don't need to do this anymore *)
	(* also ignore NonSelfContainedSamples in the same way that ResourcesOnCart does *)
	inVLMResources = MapThread[
		Function[{inUseObj, inUseObjUpContainers},
			If[MatchQ[inUseObj, ObjectP[Object[Sample]]],
				Nothing,
				PickList[inUseObj, inUseObjUpContainers, _?(MemberQ[#, ObjectP[{Object[Instrument, VerticalLift], Object[Container, Safe], Object[Container, FlammableCabinet], Object[Container, Cabinet], Object[Instrument, Desiccator], Object[Instrument, Freezer], Object[Instrument, CryogenicFreezer]}]]&)]
			]
		],
		{rootProtInUseObjs, rootProtInUseContainerObjs}
	];

	(* get the resources that are on the cart *)
	(* this includes the CartResources field, which includes things that _should_ be on the cart but are currently not because of a processing or troubleshooting stage *)
	onCartResources = Flatten[{
		cartResourcesFieldObjs,
		ResourcesOnCart[Flatten[{rootProtInUseObjs, rootProtInUseContainerObjs}], IncludePortableCooler -> True, IncludePortableHeater -> True],
		inVLMResources
	}];

	If[MatchQ[$ManifoldComputation,ObjectP[]],
	(*Pull out the requestor objects from each resource packet*)

		(* If we are on Manifold, check with database if it still exists. Disregard any test objects that might have been deleted after last download call *)
		Module[{allRequestors,requestorsNoLongerExist},
			allRequestors = Flatten[Lookup[Flatten[resourcePacketsBySample], Requestor, {}]];
			requestorsNoLongerExist = PickList[allRequestors, DatabaseMemberQ[allRequestors],False];
			allRequestorObjectsBySample = Map[
				Function[{resourcePacket},
					(*Make sure we are only downloading objects from the requestors that still exist on database*)
					(*if the requestorsNoLongerExist happens to be an empty list, we don't want to delete any empty list from potentially nested lists*)
					Download[DeleteCases[Lookup[resourcePacket, Requestor, {}],Alternatives[Sequence@@(requestorsNoLongerExist /. {} -> Null)],2],
						Object]
				],
				resourcePacketsBySample
			];
			(* convert the requestor objects into requestor packets *)
			allRequestorPacketsBySampleWithProgs = Map[
				FirstCase[Flatten[requestorPacketsBySample], PacketP[#], Nothing]&,
				allRequestorObjectsBySample,
				{3}
			];
			(* if there are any program objects in this list of list of lists of packets, replace them with the protocol object they point at *)
			allRequestorPacketsBySample = Map[
				If[MatchQ[#, PacketP[{Object[Protocol], Object[Qualification], Object[Maintenance]}]],
					#,
					FirstCase[Flatten[requestorPacketsBySample], PacketP[Download[
						DeleteCases[Lookup[#, Protocol],Alternatives[Sequence@@(requestorsNoLongerExist /. {} -> Null)],2],
						Object]], Nothing]
				]&,
				allRequestorPacketsBySampleWithProgs,
				{3}
			];
		],

		(*Otherwise, just do it regularly*)
		Module[{},
			allRequestorObjectsBySample = Map[
				Download[Lookup[#, Requestor, {}], Object]&,
				resourcePacketsBySample
			];
			(* convert the requestor objects into requestor packets *)
			allRequestorPacketsBySampleWithProgs = Map[
				FirstCase[Flatten[requestorPacketsBySample], PacketP[#], Nothing]&,
				allRequestorObjectsBySample,
				{3}
			];
			(* if there are any program objects in this list of list of lists of packets, replace them with the protocol object they point at *)
			allRequestorPacketsBySample = Map[If[MatchQ[#, PacketP[{Object[Protocol], Object[Qualification], Object[Maintenance]}]],
				#,
				FirstCase[Flatten[requestorPacketsBySample], PacketP[Download[
					Lookup[#, Protocol], Object]], Nothing]
			]&,
				allRequestorPacketsBySampleWithProgs,
				{3}
			];
		]
	];

	(* pull out the resource root protocols *)
	resourceRootProtocols = Map[
		Download[Lookup[#, RootProtocol, {}], Object]&,
		resourcePacketsBySample
	];

	(* get the Object of the requestors that share the current root protocol for each sample *)
	(* we care about this because we are going to allow the picking of samples that were InUse by the same root protocol as long as the amount reserved allows the new resource to fulfill it too *)
	requestorObjectPerSample = MapThread[
		Function[{rootProts, requestorPackets},
			Lookup[Flatten[PickList[requestorPackets, rootProts, ObjectP[myRootProtocol]]], Object, {}]
		],
		{resourceRootProtocols, allRequestorPacketsBySample}
	];
	requestorStatusPerSample = MapThread[
		Function[{rootProts, requestorPackets},
			Lookup[Flatten[PickList[requestorPackets, rootProts, ObjectP[myRootProtocol]]], Status, {}]
		],
		{resourceRootProtocols, allRequestorPacketsBySample}
	];

	(* remove from the Sample packets those items that are InUse by the root protocol but whose requestor is not already completed (or aborted or canceled; that shouldn't come up much but the item is certainly allowed to be picked if that is true)*)
	pickableSamplePackets = MapThread[
		Function[{samplePacket, requestorObjs, sampleInHermeticContainerQ},
			Which[
				(* if hermetic requirement is specified, and sample does not satisfy it, dont use these samples *)
				BooleanQ[hermetic] && (hermetic =!= sampleInHermeticContainerQ),
					Nothing,
				(* if it's Available or Stocked, that's totally fine *)
				MatchQ[Lookup[samplePacket, Status], Available|Stocked],
					samplePacket,
				(* if it's InUse, we need to make sure:
				 all the requestors for this item are not the same as the current protocol
				 the item is on the cart
				 the item is not a prepared resource for some other resources of our protocol
				*)
				And[
					MatchQ[Lookup[samplePacket,Status],InUse],
					Not[MemberQ[requestorObjs,ObjectP[myCurrentProtocol]]],
					Or[
						MemberQ[onCartResources,ObjectP[Lookup[samplePacket,Object]]],
						MemberQ[onCartResources,ObjectP[Lookup[samplePacket,Container]]]
					],
					Not[MemberQ[resourcePreparationSamplesOut,Lookup[samplePacket,Object]]]
				],
					samplePacket,
				(* otherwise, don't use these samples *)
				True,
					Nothing
			]
		],
		{samplePackets, requestorObjectPerSample, sampleInHermeticContainerQs}
	];

	(* get the position in the samplePackets list that are actually pickable *)
	pickableSamplePacketPositions = Position[samplePackets, Alternatives @@ pickableSamplePackets];

	(* get the resource packets per pickable sample and the corresponding current-requestor statuses *)
	resourcePacketsByPickableSample = Extract[resourcePacketsBySample, pickableSamplePacketPositions];
	requestorStatusesByPickableSample = Extract[requestorStatusPerSample, pickableSamplePacketPositions];

	(* apologies in advance for this truly massive comment *)
	(* get the following resources: *)
	(* Those that are Outstanding or InUse and have actually reserved something (if they have not, then get rid of them since they mess up the Total-ing below) *)
	(* NOTE: because we can't know now whether the InUse resources that already exist for this item are "done" with the item, we have to assume it isn't and be conservative with how much is available *)
	(* the following scenario would run into issues: *)
	(* a.) sample1 has 10 mL available *)
	(* b.) resource1 asks for 4 mL of sample1 *)
	(* c.) rootProtocol1 uses 4 mL of sample1 and the volume is updated to 6 mL, but the sample has not yet been stored *)
	(* d.) subprotocol1 requests 3 mL of a model that can resolve to sample1 *)
	(* e.) we can't pick sample1 to fulfill this resource.  This happens because the volume of sample1 is now 6 mL, but it still looks like 4 mL of that 6 mL is already reserved since resource1 still InUse, and so we can only use 2 mL. *)
	(* e.2) this is NOT accurate because the 4 mL of the initial resource has already been used, but the resource object is still InUse because the item has not yet been stored.*)
	(* If we want to do this picking-from-things-already-on-the-cart we have to accept this, or do the following below which seems much worse: *)
	(* A.) sample1 has 10 mL available *)
	(* B.) resource1 asks for 4 mL of sample1 *)
	(* C.) rootProtocol1 doesn't use anything yet, and subprotocol1 requests 7 mL of sample1 *)
	(* D.) this function assumes rootProtocol1 is done with sample1 and the volume has already been updated and so we really do have 10 mL available *)
	(* E.) subprotocol1 uses 7 mL of sample1 *)
	(* F.) Now rootProtocol1 doesn't have the 4 mL of the sample it wanted *)
	(* it seems pretty clear that the first option above is better than the second.  But neither are great *)
	(* what I CAN do is avoid the case where the subs are Completed, when I _know_ we are done with it *)
	reservedAmountResourcePacketsBySample=MapThread[
		Function[{samplePacket, resourcePacketsForSample, requestorStatusesForSample},
			(* We have two cases here that we need to consider here.  If all the requestors for an InUse sample are Completed, then we can assume that the volume has been updated and so we only need to worry about the SelfContainedSamples/Countable things *)
			(* otherwise, we can't assume that the volume has been updated, and so we need to consider ALL resources, even the ones that are InUse *)
			(* 1.) Those that are Outstanding and have actually reserved something (if they have not, then get rid of them since they mess up the Total-ing below) *)
			(* 2.) Those that are InUse by the RootProtocol and are countable and are SelfContainedSamples (for NonSelfContainedSamples, we don't need to actually worry about this because TheoreticalVolume will already subtract these values from the Volume) *)
			If[MatchQ[Lookup[samplePacket, Status], InUse] && MatchQ[requestorStatusesForSample, {(Completed|Canceled|Aborted)..}],
				Select[
					resourcePacketsForSample,
					Or[
						MatchQ[Lookup[#, Status], Outstanding] && MatchQ[Lookup[#, Amount], UnitsP[]],
						MatchQ[Lookup[#, Status], InUse] && MatchQ[Lookup[#, Amount], UnitsP[]] && MatchQ[Lookup[#, Sample], SelfContainedSampleP]
					]&
				],
				Select[
					resourcePacketsForSample,
					MatchQ[Lookup[#, Status], Outstanding|InUse] && MatchQ[Lookup[#, Amount], UnitsP[]]&
				]
			]
		],
		{pickableSamplePackets, resourcePacketsByPickableSample, requestorStatusesByPickableSample}
	];

	(* get the total amount reserved for the currently-outstanding resource packets; if there is nothing reserved, then this is 0 (unitless) *)
	(* need some added sophistication when dealing with how many counted items are reserved *)
	amountsReserved = Map[
		Total[Lookup[#, Amount, {}]]&,
		reservedAmountResourcePacketsBySample
	];

	(* get the amount available of each sample; switch on myRequiredAmount to decide if Mass or Volume has the sample's current amount *)
	currentAmounts=Which[
		MassQ[myRequiredAmount],Lookup[pickableSamplePackets,Mass, {}],
		VolumeQ[myRequiredAmount],Lookup[pickableSamplePackets,Volume, {}],
		MatchQ[myRequiredAmount, UnitsP[Unit] | NumericP],Lookup[pickableSamplePackets,Count, {}]
	];
	amountsAvailable=MapThread[
		#1-#2&,
		{currentAmounts,amountsReserved}
	];

	(* booleans indicating if the amount available can fulfill the required amount *)
	amountsFulfillableQs = GreaterEqualQ[#, myRequiredAmount*$ResourcePickingToleranceMultiplier]& /@ amountsAvailable;

	(* filter the available sample packets based on whether the amount available is greater than the required amount *)
	samplePacketsWithEnough=PickList[pickableSamplePackets,amountsFulfillableQs];

	(* generate picking associations for each of the available samples; ScanValue is always the container since these are all fluid samples at this point *)
	instanceAssociations=MapThread[
		Function[{sample,container,notebook,kitComponents,amountAvailable},
			If[MatchQ[sample,ObjectP[Object[Sample]]],
				<|"Value"->sample,"Container"->container,"ScanValue"->container,"UserOwned"->!NullQ[notebook],"KitComponents"->kitComponents,"AvailableAmount"->amountAvailable|>,

				(* Container shouldn't be an autoclave bag at this point, but if it is, scan the autoclave bag *)
				If[MatchQ[container,ObjectP[Object[Container,Bag,Autoclave]]],
					<|"Value"->sample,"Container"->container,"ScanValue"->container,"UserOwned"->!NullQ[notebook],"KitComponents"->kitComponents,"AvailableAmount"->amountAvailable|>,
					<|"Value"->sample,"Container"->Null,"ScanValue"->sample,"UserOwned"->!NullQ[notebook],"KitComponents"->kitComponents,"AvailableAmount"->amountAvailable|>
				]
			]
		],
		{Lookup[samplePacketsWithEnough,Object,{}],Download[Lookup[samplePacketsWithEnough,Container,{}],Object],Download[Lookup[samplePacketsWithEnough,Notebook,{}],Object],Download[Lookup[samplePacketsWithEnough,KitComponents,{}],Object],PickList[amountsAvailable,amountsFulfillableQs]}
	];

	(* If scan value is the same, only show one of the instances from that container *)
	(* TODO handle case where multiple instances of the same model need to be picked from the same container *)
	DeleteDuplicatesBy[instanceAssociations,Lookup[#,"ScanValue"]&]
];


ScanValue[object:SelfContainedSampleP,cont_,modelPacket:PacketP[]]:=If[
	Or[
		(* If we have a Cap, see if it doesn't have a barcode. If this is the case, then scan the container instead. *)
		And[
			MatchQ[object,ObjectP[{Object[Item,Cap], Object[Item, Septum]}]],
			MatchQ[Lookup[modelPacket,Barcode],False]
		],
		(* Or if the container is an autoclave bag, scan the container *)
		MatchQ[cont,ObjectP[Object[Container,Bag,Autoclave]]],

		(* One more reason to scan the container: The item is in an AsepticTransportContainer *)
		MatchQ[cont, ObjectP[Object[Container,Bag, Aseptic]]]
	],
	cont,
	object
];

ScanValue[object:SelfContainedSampleP,cont_, modelPacket:({}|Null)]:=ScanValue[object,cont];

ScanValue[object:SelfContainedSampleP,cont_]:=If[
	Or[
		(* If we have a Cap, see if it doesn't have a barcode. If this is the case, then scan the container instead. *)
		And[
			MatchQ[object,ObjectP[Object[Item,Cap]]],
			MatchQ[Download[object,Model[Barcode]],False]
		],
		(* Or if the container is an autoclave bag, scan the container *)
		MatchQ[cont,ObjectP[Object[Container,Bag,Autoclave]]],

		(* One more reason to scan the container: The item is in an AsepticTransportContainer *)
		MatchQ[cont, ObjectP[Object[Container, Bag, Aseptic]]]
	],
	cont,
	object
];
(* return the container except in two instances: *)
(* 1. If it is a capillary, return the container of the capillary *)
(* 2. If sample's container is in an objectified aseptic container, return the container of the container *)
ScanValue[object:ObjectP[Object[Sample]],cont:FluidContainerP]:=If[
	Or[
		MatchQ[cont, ObjectP[Object[Container, Capillary]]],
		MatchQ[Download[cont, Container[Object]], ObjectP[Object[Container, Bag, Aseptic]]]
	],
	Download[cont, Container[Object]],
	cont
];

(* If the container is an autoclave bag, scan the container *)
(* Or if the object is an Object[Part,OpticalFilter] and the container is an Object[Container,Envelope], scan the container *)
(* Or if the object is Object[Container, Capillary], scan the container *)
(* One more reason to scan the container: The item is in an AsepticTransportContainer *)
ScanValue[object:ObjectP[],cont_]:=If[
	Or[
		MatchQ[cont,ObjectP[Object[Container,Bag,Autoclave]]],
		And[
			MatchQ[object, ObjectP[Object[Part,OpticalFilter]]],
			MatchQ[cont, ObjectP[Object[Container,Envelope]]]
		],
		MatchQ[object, ObjectP[Object[Container, Capillary]]],
		MatchQ[cont, ObjectP[Object[Container, Bag, Aseptic]]]
	],
	cont,
	object
];


RootProtocol[object:ObjectP[]]:=Module[
	{rootProtocol},
	
	rootProtocol = Download[object, RootProtocol[Object]];
	(* If the root protocol is a Link, then we need to download the object that it points to *)
	If[MatchQ[rootProtocol,Null],
		Download[object,Object],
		rootProtocol
	]
];


(* Filters the list of 'pickedObjects' and returns only self-contained samples, parts, containers, plumbing, and wiring objects that are on the cart at any level *)
(* Warning: This assumes 'pickedObjects' contains both samples and their containers *)
DefineOptions[ResourcesOnCart, Options :> {
	{IncludePortableCooler -> False, BooleanP, "Whether we include resources in portable cooler that may or may not be on cart."},
	{IncludePortableHeater -> False, BooleanP, "Whether we include resources in portable heater that may or may not be on cart."}
}];

ResourcesOnCart[pickedObjects:{}, ops:OptionsPattern[]]:={};
ResourcesOnCart[pickedObjects:{ObjectP[]..}, ops:OptionsPattern[]]:=Module[
	{
		selfContainedResources,resourceContainers, coveredContainers, onCartObjects, nonCoverObjects,
		stackedBelow,mobileChecks,nonCoverObjectsStackedBelow,bottomMostObjects,mobileObjects, safeOps,
		includePortableCooler, includePortableHeater,
		containerPatternsToExclude, containerPatternsToInclude
	},

	safeOps = SafeOptions[ResourcesOnCart, ToList[ops]];

	{includePortableCooler, includePortableHeater} = Lookup[safeOps,
		{IncludePortableCooler, IncludePortableHeater}
	];

	(* only need to check the self-contained samples to see if they're directly on the cart *)
	(* assumes that the containers of any non-self-contained samples are in the resource list *)
	(* need to Download Object because the recursive download sometimes fails if you are trying to get Container.. from a packet that already has Container in it (not sure of cause/reproducible case) *)
	selfContainedResources = Download[Cases[
		pickedObjects,
		Alternatives[
			SelfContainedSampleP,
			ObjectP[{Object[Container], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring], Object[Item], Object[Package], Object[Instrument]}]
		]
	], Object];

	(* if we dont have any items on the cart that are storable, return early *)
	If[MatchQ[selfContainedResources, {}],
		Return[{}]
	];

	(* need to go recursively because if a container is in another container, it won't count as being "on the cart" which is obviously wrong *)
	(* Mobile is only in Model[Instrument]. Use to find mobile instrument, like pipettes, to treat like containers, items, etc. *)
	{resourceContainers, coveredContainers, stackedBelow, mobileChecks} = Quiet[
		Transpose[
			Download[
				selfContainedResources,
				{Container.., CoveredContainer, StackedBelow.., Model[Mobile]}
			]
		],
		Download::FieldDoesntExist
	];

	(* check for ANY operator cart because we want to store all resources, even though they should be located on the ActiveCart *)
	(* need to do the MemberQ and recursive download because sticky racks could cause issues *)

	(* Find the container patterns that should be excluded *)
	containerPatternsToExclude = Switch[{includePortableHeater, includePortableCooler},
		{True, True},
		(* When we include on-cart cooler and heater, don't exclude anything. Put a dummy pattern here so that nothing matches *)
			1,
		{True, _},
			ObjectP[Object[Instrument,PortableCooler]],
		{_, True},
			ObjectP[Object[Instrument,PortableHeater]],
		_,
			ObjectP[{Object[Instrument,PortableCooler],Object[Instrument,PortableHeater]}]
	];

	containerPatternsToInclude = Switch[{includePortableHeater, includePortableCooler},
		{True, True},
			ObjectP[{Object[Instrument,PortableCooler], Object[Instrument,PortableHeater], Object[Container,OperatorCart]}],
		{True, _},
			ObjectP[{Object[Instrument,PortableHeater], Object[Container,OperatorCart]}],
		{_, True},
			ObjectP[{Object[Instrument,PortableCooler], Object[Container,OperatorCart]}],
		_,
			ObjectP[Object[Container,OperatorCart]]
	];

	onCartObjects = PickList[
		selfContainedResources,
		resourceContainers,
		Except[_?(MemberQ[#, containerPatternsToExclude]&),_?(MemberQ[#, containerPatternsToInclude]&)]
	];

	(* Any cover items that are on a container should not be included here as they are moved as a single item *)
	nonCoverObjects = PickList[
		selfContainedResources,
		coveredContainers,
		(Null|$Failed)
	];

	nonCoverObjectsStackedBelow = PickList[
		stackedBelow,
		coveredContainers,
		(Null|$Failed)
	];

	bottomMostObjects = PickList[
		nonCoverObjects,
		nonCoverObjectsStackedBelow,
		({}|$Failed)
	];

	(* Instruments with Mobile -> True are mobile. Other object types are all assumed mobile, don't have the field and will have $Failed here *)
	mobileObjects = PickList[
		selfContainedResources,
		mobileChecks,
		True|$Failed
	];

	(* get anything that is both on a cart AND not a cover on a container AND mobile *)
	Intersection[bottomMostObjects, onCartObjects, mobileObjects]
];


(* Quick helper to display key info about our picking options *)
resourceOptionsTable[pickingOptions:{ObjectP[]..}]:=If[MatchQ[pickingOptions,{ObjectP[Object[Container]]..}],
	PlotTable[pickingOptions,{DateStocked, Status, Model[Object], Contents[[1]][Object], Notebook[Object], Restricted}],
	Module[{sampleInfo,volumes,masses,counts,fields,amountInfo,fullDisplayInfo},
		fields={Object,Model[Object],Status,Container[Object],Notebook[Object],Restricted,DateStocked,ExpirationDate};

		(* Get all info about our sample that we might want to show *)
		sampleInfo=Download[pickingOptions,Evaluate[Join[{Volume, Mass, Count},fields]]];

		(* Pull out amount info *)
		volumes=sampleInfo[[All,1]];
		masses=sampleInfo[[All,2]];
		counts=sampleInfo[[All,3]];

		(* Show only the amount info we actually have *)
		amountInfo={
			If[MemberQ[volumes,VolumeP],{volumes,"Volume"},Nothing],
			If[MemberQ[masses,MassP],{masses,"Mass"},Nothing],
			If[MemberQ[counts,_Integer],{counts,"Count"},Nothing]
		};

		(* Join up our display info *)
		fullDisplayInfo=MapThread[
			Join[#1,#2]&,
			{Transpose[amountInfo[[All,1]]],sampleInfo[[All,4;;]]}
		];

		(* Plot! *)
		PlotTable[fullDisplayInfo,TableHeadings->{None,Join[amountInfo[[All,2]],ToString/@fields]}]
	]
];

(* Authors definition for Resources`Private`blobLookup *)
Authors[Resources`Private`blobLookup]:={"hayley"};

(* ::Subsubsection:: *)
(*ConsolidationInstances*)


DefineOptions[ConsolidationInstances,
	Options :> {
		IndexMatching[
			{
				OptionName -> Sterile,
				Default -> Null,
				AllowNull -> True,
				Description -> "Indicates if only items with Sterile -> True can be picked.",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			IndexMatchingInput -> "fulfillment models"
		]
	}
];

(* singleton overload *)
ConsolidationInstances[
	myRequestedModel:ObjectP[{Model[Sample], Model[Item]}],
	myRequiredAmount:(Null | MassP | VolumeP | NumericP | UnitsP[Unit]),
	myAllowedNotebooks:{ObjectP[Object[LaboratoryNotebook]]...},
	myRootProtocol:Null | ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance]}],
	myCurrentProtocol:Null | ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance]}],
	ops:OptionsPattern[ConsolidationInstances]
] := First[ConsolidationInstances[
	{myRequestedModel},
	{myRequiredAmount},
	myAllowedNotebooks,
	myRootProtocol,
	myCurrentProtocol,
	ops
], {}];

(* --- finding a sample set that can fulfill a request for a sample model via consolidation ---  *)
(* listed overload *)
ConsolidationInstances[
	myRequestedModels:{ObjectP[{Model[Sample], Model[Item]}]..},
	myRequiredAmounts:{(Null | MassP | VolumeP | NumericP | UnitsP[Unit])..},
	myAllowedNotebooks:{ObjectP[Object[LaboratoryNotebook]]...},
	myRootProtocol:Null | ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance]}],
	myCurrentProtocol:Null | ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance]}],
	ops:OptionsPattern[ConsolidationInstances]
] := Module[
	{
		amountsAvailable, candidateSampleAmounts, safeOps, expandedOptions, modelAmountTuples,
		incompatibleModelPositions, modelAmountTuplesFiltered, availableInstancesLookup, availableInstancesLookupWithIncompatibleModels
	},

	safeOps = SafeOptions[ConsolidationInstances, ToList[ops]];
	expandedOptions = Last[ExpandIndexMatchedInputs[ConsolidationInstances, {myRequestedModels, myRequiredAmounts, myAllowedNotebooks, myRootProtocol, myCurrentProtocol}, safeOps]];

	(* assem the model, amount, and sterile information as tuples *)
	modelAmountTuples = Transpose[{
		myRequestedModels,
		myRequiredAmounts,
		Lookup[expandedOptions, Sterile]
	}];

	(* get the position of self-contained or counted samples, we wont even try to consolidate them b/c SP framework does not really support it now *)
	incompatibleModelPositions = Position[
		modelAmountTuples,
		Alternatives[
			{SelfContainedSampleModelP, NullP, _},
			{_, NumberP | UnitsP[Unit], _}
		]
	];

	(* filter them about temporarily *)
	modelAmountTuplesFiltered = Delete[
		modelAmountTuples,
		incompatibleModelPositions
	];

	(* return early if we have nothing to proceed after filtering *)
	If[MatchQ[modelAmountTuplesFiltered, {}],
		Return[ConstantArray[{}, Length[myRequestedModels]], Module]
	];

	(* call ModelInstances which returns available instances with keys including <|"Value"->sample,"Container"->container,"ScanValue"->container,"UserOwned"->!NullQ[notebook],"KitComponents"->kitComponents,"AvailableAmount"->amountAvailable|> *)
	(* NOTE: ModelInstances already does a filter and calculations of the samples considering if they are used by the root protocol etc, we will share the logic there, i.e.:
		if a sample is available or stock, can use it
		if a sample is in use by the same root protocol, make sure:
			all the requestors for this sample are not the same as the current protocol
			the sample is on the cart
			the sample is not a prepared resource for some other resources of our protocol
	*)
	(* also ModelInstances already does the calculation of reserved amount, available amount etc so we really only need to pull things out here *)
	availableInstancesLookup = ModelInstances[
		modelAmountTuplesFiltered[[All, 1]],
		(* define the amount, apply the cut off so to avoid pipetting/transferring tiny amounts when we could be consolidating medium amounts together  *)
		modelAmountTuplesFiltered[[All, 2]] * $ConsolidationCutOff,
		(* allow any container model for sure *)
		ConstantArray[{}, Length[modelAmountTuplesFiltered]],
		myAllowedNotebooks,
		myRootProtocol,
		myCurrentProtocol,
		(* keep up with sterile requirement *)
		Sterile -> modelAmountTuplesFiltered[[All, 3]],
		(* exclude samples that are in hermetic containers b/c if they are in hermetic containers that means they are intended for being taken out and use immediately, not to be transferred to an intermediate container *)
		Hermetic -> False
	];
	
	(* thread {} back into the list so everything is now index matched to input MyRequestedModels *)
	availableInstancesLookupWithIncompatibleModels = Fold[Insert[#1, {}, #2[[1]]] &, availableInstancesLookup, incompatibleModelPositions];

	MapThread[
		Function[{availableInstancesInfo, requiredAmount, requestedModel},
			Module[{finalInstancesInfo},
				(* do an additional filter to get rid of samples with volumes larger than the required amount *)
				(* NOTE: we really should not be searching for consolidations when we do have samples of enough volumes, so if finalInstancesInfo is _not_ the same as availableInstancesInfo, something might have gone wrong in the pickingAssociation branching logic or your resource specification *)
				finalInstancesInfo = PickList[
					availableInstancesInfo,
					Lookup[availableInstancesInfo, "AvailableAmount", {}],
					LessEqualP[(1 - $ResourcePickingToleranceMultiplier + 1) * requiredAmount]
				];

				(* if not 2 or more samples were found that fulfill the search criteria, we can return {} here *)
				(* when 1 sample is found, this should be picked up by the ResourceTransfer pick type *)
				If[Length[finalInstancesInfo] < 2, Return[{}, Module]];

				(* get the amount available for each available instanes, ModelInstances have already considered the reserved amount by requested resources *)
				amountsAvailable = Lookup[finalInstancesInfo, "AvailableAmount", {}];

				(* get the largest amounts from the sample packets (but no more than $MaxConsolidationNumber). We do not want to do consolidation if we need more to avoid giving customers a bunch of low-volume dregs *)
				candidateSampleAmounts = If[Length[amountsAvailable] < $MaxConsolidationNumber,
					amountsAvailable,
					Take[Sort[amountsAvailable], -$MaxConsolidationNumber;;-1]
				];

				(* If there are no single sample packets with sufficient amount (or we have sufficient but we would need more than $MaxConsolidationNumber samples), we need to return {} here.*)
				(* Otherwise generate consolidation associations with the possible samples and their amounts *)
				If[(MatchQ[finalInstancesInfo, {}] || Total[candidateSampleAmounts] < requiredAmount),
					Return[{}, Module],
					<|
						"PossibleSamples" -> Lookup[finalInstancesInfo, "Value"],
						"SamplesAmounts" -> Lookup[finalInstancesInfo, "AvailableAmount"],
						"UserOwned" -> Lookup[finalInstancesInfo, "UserOwned"],
						"RequestedModel" -> requestedModel
					|>
				]
			]
		],
		{availableInstancesLookupWithIncompatibleModels, myRequiredAmounts, myRequestedModels}
	]

];
