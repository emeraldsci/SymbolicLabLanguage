(* ::Package:: *)

(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

(*::Subsection::*)
(*ValidOpenPathsQ and other widget checking*)

allCatalogPackets[fakeString_String]:=allCatalogPackets[fakeString]=Module[{allCatalogs},
  If[!MemberQ[$Memoization, Experiment`Private`allCatalogPackets],
    AppendTo[$Memoization, Experiment`Private`allCatalogPackets]
  ];

  allCatalogs = Search[Object[Catalog]];
  Download[allCatalogs, Packet[Name, Folder, Contents]]

];

(* helper function used in ValidOpenPathsQ below*)
(* for reasons I'm not sure I understand, Widget::ObjectOpenPathsContents in the widgets package is checking this same thing *)
(* that message does get thrown when the DefineOptions call is run in theory (and sometimes in practice), but it does not throw an error on SLL load which I would expect *)
(* so this check is necessary to be here too to catch these cases *)
openPathsExistQ[myOpenPath:{(ObjectP[Object[Catalog]]|_String)..}]:=Module[
  {catalogPackets, catalogPacketsFromInput, resolvedCatalogPackets},

  catalogPackets = allCatalogPackets["Memoization"];

  (* special exception for Object[Catalog, "Root"] because we'll always have that in the named form first and don't want to Download every single time *)
  catalogPacketsFromInput = Map[
    Switch[#,
      Object[Catalog, "Root"], FirstCase[catalogPackets, KeyValuePattern[{Name -> "Root"}], Null],
      (* I think we won't ever actually go down this path, but in case I don't quite know how the OpenPaths works and it does allow objects besides the root *)
      ObjectP[Object[Catalog]], With[{catalogObject = Download[#, Object]}, FirstCase[catalogPackets, ObjectP[catalogObject], Null]],
      (* since multiple catalogs can have the same folter name, need to get _all_ the ones with the given folder name; in our check below, we need to just find if _any_ of the objects are in teh contents *)
      _String, Cases[catalogPackets, KeyValuePattern[{Folder -> #}]],
      _, Null
    ]&,
    myOpenPath
  ];

  (* does each catalog contain its child? *)
  (* if we get a full list of packets here and not any Nulls, then we can say yes with certainty *)
  resolvedCatalogPackets = Fold[
    Function[{runningResolvedPackets, nextPacketOrPackets},
      Which[
        (* if we're the first iteration, just put the packet in and move on *)
        MatchQ[runningResolvedPackets, {}], {First[ToList[nextPacketOrPackets]]},
        (* if the last packet was a Null, or this packet is a Null, just add another Null because we've already failed to find the path in the catalog *)
        NullQ[nextPacketOrPackets] || NullQ[Last[runningResolvedPackets]], Append[runningResolvedPackets, Null],
        True,
          (* otherwise, pick the first packet that we previously determined has the right folder name that is actually in the contents of the parent catalog packet we resolved in the previous iteration *)
          With[{resolvedNextPacket = SelectFirst[nextPacketOrPackets, MemberQ[Lookup[Last[runningResolvedPackets], Contents], ObjectP[Lookup[#, Object]]]&, Null]},
            Append[runningResolvedPackets, resolvedNextPacket]
          ]
      ]
    ],
    {},
    catalogPacketsFromInput
  ];

  MatchQ[resolvedCatalogPackets, {ObjectP[Object[Catalog]]..}]

];

(* any Object widget that takes in a Model[Sample], Identity models, Model[Item], Model[Container], Object[Product], Model[Instrument], and Model[StorageCondition] *)
openPathsTypes := Flatten[{Model[Sample],IdentityModelTypes,Model[Item],Model[Container],Object[Product],Model[Instrument],Model[StorageCondition]}];

DefineOptions[ValidOpenPathsQ,
  Options :> {
    {
      OutputFormat -> Boolean,
      Boolean|Options,
      "Indicates whether the output should be a Boolean for each function, or a list of the options whose OpenPaths are failing."
    },
    VerboseOption
  }
]

ValidOpenPathsQ[myFunction_Symbol, ops:OptionsPattern[ValidOpenPathsQ]]:=First[ValidOpenPathsQ[{myFunction}, ops]];
ValidOpenPathsQ[myFunctions:{__Symbol}, ops:OptionsPattern[ValidOpenPathsQ]]:=Module[
  {safeOps, verbose, optionDefs, openPathsExistTests, testFunctionForRVQT, openPathsExistAndTestsSingleFunction,
    allFailingOptions, outputFormat, testResult, usageDefs},

  safeOps = SafeOptions[ValidOpenPathsQ, ToList[ops]];
  {verbose, outputFormat} = Lookup[safeOps, {Verbose, OutputFormat}];


  optionDefs = OptionDefinition[#]& /@ myFunctions;

  (* note that if we've got any unevaluated usage, just allow <||>*)
  usageDefs = ReplaceAll[
    Usage[#]& /@ myFunctions,
    _Usage :> <||>
  ];

  (* make an internal function that makes the tests for whether a given function has all its OpenPaths correct, and which options are good or bad *)
  openPathsExistAndTestsSingleFunction[optionDefsPerFunction:{___Association}, usageDef_Association, functionName_Symbol]:=Module[
    {optionOrInputOptions},

    (* combine the option and input definitions *)
    optionOrInputOptions = Join[
      optionDefsPerFunction,
      Lookup[usageDef, "Input", {}]
    ];

    If[MatchQ[optionOrInputOptions, {}],
      {{}, {}, {}},
      Transpose[Map[
        Function[{optionOrInputDef},
          Module[{allWidgets, objectWidgetsWithTypes, noOpenPathsWidgets, openPathsPopulatedTests, openPathsWidgets,
            openPaths, openPathsExistQs, openPathsRealTest, optionName, openPathsPopulatedBool, openPathsRealBool,
            optionCategory, nameToUse, inputName},
            (* note that All here goes from levelspec 0 down to infinite depth, whereas Infinity goes from levelspec 1 *)
            (* the consequence is if Lookup[optionOrInputDef, "Widget"] is just a widget instead of an Adder or Alternatives or whatever, we will only get it in this Cases if we're using All; Infinity will NOT work *)
            allWidgets = Flatten[Cases[Lookup[optionOrInputDef, "Widget"], _Widget, All]];

            {optionName, inputName, optionCategory} = Lookup[optionOrInputDef, {"OptionName", "Name", "Category"}];

            (* if it's an option vs if it's an input, need to pick the right string *)
            nameToUse = Which[
              StringQ[optionName], optionName,
              StringQ[inputName], inputName,
              (* null name if we just don't have any usage *)
              True, Null
            ];

            (* if we're a hidden option, we can just end early and not bother checking; these ones don't need to have OpenPaths *)
            (* also if we flat out don't have usage, also return early here *)
            If[MatchQ[optionCategory, "Hidden"] || NullQ[nameToUse],
              Return[{True, {}}, Module]
            ];

            (* get the object widgets that match the relevant pattern for which we want open paths *)
            objectWidgetsWithTypes = Select[allWidgets, MatchQ[First[#], KeyValuePattern[{Type -> Object, ObjectTypes -> _?(MemberQ[#, TypeP[openPathsTypes]]&)}]]&];

            (* determine if we have any widgets that take the relevant types but do NOT have OpenPaths populated *)
            (* also get the ones hwere they do exist too because that's useful below *)
            noOpenPathsWidgets = Select[objectWidgetsWithTypes, MatchQ[First[#],KeyValuePattern[{OpenPaths -> {}}]]&];
            openPathsWidgets = DeleteCases[objectWidgetsWithTypes, Alternatives @@ noOpenPathsWidgets];

            (* make a boolean for the OpenPaths-populated-test *)
            openPathsPopulatedBool = MatchQ[noOpenPathsWidgets, {}];

            (* If we don't have any object widgets to begin with, then don't bother returning anything *)
            openPathsPopulatedTests = If[MatchQ[objectWidgetsWithTypes, {}],
              Nothing,
              (* if we do have Object widgets but they all have OpenPaths, then the test passes *)
              Test[ToString[functionName] <> ": Object widgets for " <> nameToUse <> " have OpenPaths populated:",
                True,
                openPathsPopulatedBool
              ]
            ];

            (* pull out the open paths of all the object widgets we do have *)
            (* Join because OpenPaths is a list of lists for each one widget (so we would otherwise have a list of list of lists) *)
            openPaths = Join @@ Lookup[First /@ openPathsWidgets, OpenPaths, {}];

            (* get whether each open paths exists at all *)
            openPathsExistQs = openPathsExistQ[#]& /@ openPaths;

            (* make a boolean for the OpenPaths-actually-exists-test *)
            openPathsRealBool = MatchQ[openPathsExistQs, {True..}];

            (* only need to bother with this test if we actually have open paths to begin with *)
            openPathsRealTest = If[MatchQ[openPaths, {}],
              Nothing,
              Test[ToString[functionName] <> ": OpenPaths for " <> nameToUse <> " actually exist in the catalog:",
                True,
                openPathsRealBool
              ]
            ];

            (* returning two things *)
            (* first, if the open paths are correct *)
            (* second, test blobs for this in RunValidQTest below *)
            {
              And[
                openPathsPopulatedBool || MatchQ[objectWidgetsWithTypes, {}],
                openPathsRealBool || MatchQ[openPaths, {}]
              ],
              Flatten[{openPathsPopulatedTests, openPathsRealTest}]
            }

          ]
        ],
        optionOrInputOptions
      ]]
    ]

  ];

  (* make tests determining if the OpenPaths should be populated and isn't for each option for each specified object *)
  {allFailingOptions, openPathsExistTests} = Transpose[MapThread[
    Function[{optionDefsPerFunction, usageDef, functionName},
      Module[{optionAndInputBools,optionTests, failingOptions, failingInputs, optionBools, inputBools},
        {optionAndInputBools, optionTests} = openPathsExistAndTestsSingleFunction[optionDefsPerFunction, usageDef, functionName];

        (* split the options and inputs based on how many options went in *)
        {optionBools, inputBools} = TakeDrop[optionAndInputBools, Length[optionDefsPerFunction]];

        (* get the failing option names and make them expressions *)
        failingOptions = ToExpression[PickList[Lookup[optionDefsPerFunction, "OptionName", {}], optionBools, False]];

        (* get the failing input names and append (input value) to it *)
        failingInputs = Map[
          # <> " (input value)" &,
          Lookup[PickList[Lookup[usageDef, "Input", {}], inputBools, False], "Name", {}]
        ];

        {Join[failingOptions, failingInputs], Flatten[optionTests]}
      ]
    ],
    {optionDefs, usageDefs, myFunctions}
  ]];

  (* need to format things right for RunValidQTest.  Which ultimately means it will be very goofy *)
  (* basically this is the clearest way I can figure out (for now at least) how to run only the index matching tests to myFunctions in RVQT below *)
  testFunctionForRVQT = ConstantArray[
    Function[expFunction, openPathsExistTests[[FirstPosition[myFunctions, expFunction][[1]]]]],
    Length[myFunctions]
  ];

  testResult = RunValidQTest[
    myFunctions,
    testFunctionForRVQT,
    Verbose -> verbose,
    SymbolSetUp -> False,
    OutputFormat -> Boolean
  ];

  If[MatchQ[outputFormat, Boolean],
    testResult,
    allFailingOptions
  ]
];

(* ::Subsubsection::Closed:: *)
(*LookupLabeledObject*)


(* ::Code::Initialization:: *)
Authors[LookupLabeledObject]={"dima","thomas"};

Error::LabeledObjectsDoNotExist="The LabeledObjects field does not exist in the following protocol type(s), `1`. Please only give a ManualSamplePreparation, ManualCellPreparation, RoboticSamplePreparation, or RoboticCellPreparation protocol object as input to this function.";
Error::LabelNotFound="The labels, `1`, were not found in the protocol object, `2`. The existing labels in the protocol object(s) (via the LabeledObjects field) are `3`. This means that either the label given was not specified in the protocol object(s) or that the protocol object is still processing and hasn't created the labeled sample/container yet.";
Error::NoProtocolsInScript="The script `1` does not contain any Protocols";
Warning::MultipleLabeledObjects="The labels, `1`, are present in multiple protocols. The output labels are for the last protocol containing this Label.";

(* Public helper function to lookup a labeled object. *)
DefineOptions[LookupLabeledObject,
	Options :> {
		{
			OptionName -> Script,
			Description -> "Indicates if the input is a script.",
			Default -> False,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Category -> "Hidden"
		},
		CacheOption
	}
];

(* script overloads *)
LookupLabeledObject[myScript:ObjectP[Object[Notebook, Script]], myLabel:_String, ops:OptionsPattern[]]:=Check[
	First[LookupLabeledObject[myScript, {myLabel}, ops], Null],
	$Failed,
	{Error::NoProtocolsInScript, Error::LabeledObjectsDoNotExist}
];
LookupLabeledObject[myScript:ObjectP[Object[Notebook, Script]], myLabels:{_String..}, ops:OptionsPattern[]]:=Module[{safeOps, cache, protocols},

	(* get the cache *)
	safeOps = SafeOptions[LookupLabeledObject, ToList[ops]];
	cache = Lookup[safeOps, Cache];

	protocols=Download[myScript, Protocols[Object], Cache -> cache];

	(* if there are no protocols, error out *)
	If[Length[protocols] == 0,
		Message[Error::NoProtocolsInScript, myScript]; Return[$Failed, Module],

		LookupLabeledObject[protocols, myLabels, Script -> True, Cache -> cache]
	]
];

(* protocol overloads *)
LookupLabeledObject[myProtocol:ObjectP[Object[Protocol]], myLabel_String, ops:OptionsPattern[]] := Check[
	First[LookupLabeledObject[{myProtocol}, {myLabel}, ops], Null],
	$Failed,
	{Error::NoProtocolsInScript, Error::LabeledObjectsDoNotExist}
];
LookupLabeledObject[myProtocol:ObjectP[Object[Protocol]], myLabels:{_String..}, ops:OptionsPattern[]] := LookupLabeledObject[{myProtocol}, myLabels, ops];
(* we still expect single output b/c the input label is single *)
LookupLabeledObject[myProtocols:{ObjectP[Object[Protocol]]...}, myLabel_String, ops:OptionsPattern[]] := Check[
	First[LookupLabeledObject[myProtocols, {myLabel}, ops], Null],
	$Failed,
	{Error::NoProtocolsInScript, Error::LabeledObjectsDoNotExist}
];

(* Simulation overload *)
LookupLabeledObject[mySimulation:SimulationP, myLabel_String, ops:OptionsPattern[]] := First[LookupLabeledObject[mySimulation, {myLabel}, ops], Null];
LookupLabeledObject[mySimulation:SimulationP, myLabels:{_String..}, ops:OptionsPattern[]] := Lookup[Lookup[mySimulation[[1]], Labels], myLabels, Null];

(* CORE overload *)
LookupLabeledObject[myProtocols:{ObjectP[Object[Protocol]]...}, myLabels:{_String..}, ops:OptionsPattern[]] := Module[
	{safeOps, scriptQ, cache, types, labeledObjectsRaw, labeledObjectsExistQ, labeledObjects, missingLabels, labeledObjectRulesNested, initialResults, multipleHitsLabels, result},

	(* get safe options *)
	safeOps = SafeOptions[LookupLabeledObject, ToList[ops]];

	(* check if we were given a script *)
	scriptQ = Lookup[safeOps, Script];

	(* get cache *)
	cache = Lookup[safeOps, Cache];

	(* download *)
	{
		types,
		labeledObjectsRaw
	} = Quiet[
		Transpose[
			Download[
				myProtocols,
				{
					Type,
					LabeledObjects
				},
				Cache -> cache
			]
		],
		{Download::FieldDoesntExist, Download::MissingCacheField}
	];

	(* Make sure the LabeledObjects field exists in the protocol type. *)
	labeledObjectsExistQ = MemberQ[Fields[#, Output -> Short], LabeledObjects]& /@ types;

	(* check if protocols might have labeled objects *)
	Which[
		(* all protocols don't have LabeledObjects, error out *)
		!Or @@ labeledObjectsExistQ,
			Message[Error::LabeledObjectsDoNotExist, PickList[myProtocols, labeledObjectsExistQ, False]];
			Return[$Failed, Module],

		(* _some_ protocols don't have LabeledObject, just throw a message and continue *)
		And[
			MemberQ[labeledObjectsExistQ, False],
			!scriptQ
		],
			Message[Error::LabeledObjectsDoNotExist, PickList[myProtocols, labeledObjectsExistQ, False]];
	];

	(* get the actual LabeledObjects field. *)
	labeledObjects = PickList[labeledObjectsRaw, labeledObjectsExistQ];

	missingLabels = UnsortedComplement[myLabels, Flatten[labeledObjects, 1][[All, 1]]];

	(* If we don't find the label, throw an error. The label is in the format of {label string, object} *)
	If[Length[missingLabels] > 0,
		Message[Error::LabelNotFound, missingLabels, myProtocols, DeleteDuplicates[Flatten[labeledObjects, 1][[All, 1]]]];
	];

	(* convert labeled objects to rules so we can lookup, but keep the nested structure for sure *)
	labeledObjectRulesNested = Apply[Rule, labeledObjects, {2}];

	(* Return the corresponding object(s). If not presented, return Null *)
	(* do a first pass *)
	initialResults = Download[Lookup[labeledObjectRulesNested, #, Nothing], Object]& /@ myLabels;

	multipleHitsLabels = {};
	result = MapThread[
		Function[{objects, label},
			Switch[Length[objects],
				0, Null,
				1, First@objects,
				GreaterP[1], AppendTo[multipleHitsLabels, label];Last[objects]
			]],
		{initialResults, myLabels}
	];

	(* if we got a label that was used in multiple protocols, throw a warning *)
	If[Length[multipleHitsLabels] > 0, Message[Warning::MultipleLabeledObjects, multipleHitsLabels]];

	(* return the result *)
	result
];



(* ::Subsubsection::Closed:: *)
(*RestrictLabeledSamples/UnrestrictLabeledSamples*)


(* ::Code::Initialization:: *)
Authors[RestrictLabeledSamples]={"dima"};
Authors[UnrestrictLabeledSamples]={"dima"};


(* ::Code::Initialization:: *)
(* public helpers to restrict/unrestrict all non-public Objects from a given protocol *)
RestrictLabeledSamples[object:ObjectP[{Object[Sample], Object[Container], Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}]]:=RestrictLabeledSamples[{object}];
RestrictLabeledSamples[objects:{ObjectP[{Object[Sample], Object[Container], Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}]..}]:=Module[
	{allLabeledObjectData, nonPublicObjects},

	allLabeledObjectData = Download[objects, {Object, Notebook[Object]}];

	(*Get only non-public Objects*)
	nonPublicObjects = DeleteCases[allLabeledObjectData, {_,Null}][[All,1]];

	(*RestrictSamples*)
	RestrictSamples[nonPublicObjects]
];

UnrestrictLabeledSamples[object:ObjectP[{Object[Sample], Object[Container], Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}]]:=UnrestrictLabeledSamples[{object}];
UnrestrictLabeledSamples[objects:{ObjectP[{Object[Sample], Object[Container], Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}]..}]:=Module[
	{allLabeledObjectData, nonPublicObjects},

	allLabeledObjectData = Download[objects, {Object, Notebook[Object]}];

	(*Get only non-public Objects*)
	nonPublicObjects = DeleteCases[allLabeledObjectData, {_,Null}][[All,1]];

	(*UnrestrictSamples*)
	UnrestrictSamples[nonPublicObjects]
];


(* ::Subsubsection::Closed:: *)
(*SimulateResources*)

(* Private helper for SimulateResources *)
wasteTypeToWasteModelLookup[string_String] := wasteTypeToWasteModelLookup[string] = Module[{allWasteModels, allWasteTypesOfWasteModels},
	(* Memoize this function *)
	If[!MemberQ[$Memoization, Experiment`Private`wasteTypeToWasteModelLookup],
		AppendTo[$Memoization, Experiment`Private`wasteTypeToWasteModelLookup]
	];
	(* Get all waste models *)
	allWasteModels = Search[Model[Container, Waste], DeveloperObject != True];
	(* Get all their waste Types *)
	allWasteTypesOfWasteModels = Download[allWasteModels, WasteType];
	(*Create the look up*)
	AssociationThread[allWasteTypesOfWasteModels, allWasteModels]
];

(* ::Code::Initialization:: *)
(* Helper Functions *)
DefineOptions[
	SimulateResources,
	Options:>{
		{PooledSamplesIn -> Null, ListableP[ListableP[Null|ObjectP[Object[Sample]]]], "The SamplesIn in their pooling form, if the function that's calling SimulateResources is a pooling function. This option MUST be passed for pooling functions since SamplesIn in the protocol object is flattened and we need information about the pooling groups to do aliquot resolving."},
		{IgnoreWaterResources -> False, BooleanP, "Indicates if resources picking water models should NOT be simulated. This is specifically relevant when SimulateProcedure calls SimulateResources, because otherwise simulated resource picking would not properly replicate what happens in the lab."},
		{IgnoreCoverSimulation -> Automatic, Automatic | BooleanP, "Indicates when simulating a container from model if the cover of the container should not be simulated. Automatically set to True if the protocol type is RoboticSamplePreparation or RoboticCellPreparation, because the simulated cover will prevent the operation optimizer to add a cover unit operation, otherwise to False."},
		CacheOption,
		SimulationOption,
		ParentProtocolOption}
];

Warning::AmbiguousNameResources="The following resource names, `1`, were detected in resources with different resource parameters inside of the protocol packet, `2`, when passed down to SimulateResources. Make sure to only pass down resources with unique names for unique sets of resource parameters.";
Error::SimulateResourcesInvalidBacklink="The following link, `1`, was specified for the following field, `2`, in UploadResources, however, this object type is not specified in that field's Relations. Please run ValidUploadQ to find the invalid field before calling SimulateResources.";

(* NOTE: OptionsPattern[] thinks that {} can be part of options, so we have to define the main overload first. *)
(* Do NOT reorder the definitions of SimulateResources here. *)
SimulateResources[
	myProtocolPacket:PacketP[{Object[Protocol], Object[Maintenance], Object[Qualification]}, {Object}],
	myAccessoryPacket:{PacketP[]...}|Null,
	myOptions:OptionsPattern[SimulateResources]
]:=Module[
	{safeOptions, cache, simulation, parentProtocol, finalProtocolPacket, finalProtocolPacketWithoutNameOption, finalAccessoryPacket, uploadResult, currentSimulation, accessoryObjects},

	(* Get our options. *)
	safeOptions=SafeOptions[SimulateResources, ToList[myOptions]];
	cache=Lookup[safeOptions, Cache];
	simulation=Lookup[safeOptions, Simulation];
	parentProtocol=Lookup[safeOptions, ParentProtocol];

	(* We have to detect and replace any resources that had the same name but different resource parameters. This will cause *)
	(* UploadProtocol to fail. *)
	{finalProtocolPacket, finalAccessoryPacket}=Module[{allResources, badResourceNames, badResources, badResourceReplaceRules},
		(* First, detect any resources that have the same name but different resource parameters. This will cause UploadProtocol to fail. *)
		allResources = DeleteDuplicates[Cases[{myProtocolPacket, myAccessoryPacket}, _Resource, Infinity]];
		badResourceNames = (If[!SameQ@@#, #[[1]][Name], Nothing]&)/@GatherBy[allResources, (If[!MatchQ[#[Name], _String], CreateUUID[], #[Name]]&)];
		badResources = Select[allResources, (MatchQ[#[Name], Alternatives@@badResourceNames]&)];

		(* If we found bad resources, we will throw a warning if we're logged in as a developer. *)
		If[Length[badResources] && MatchQ[$PersonID, ObjectP[Object[User, Emerald, Developer]]],
			Message[Warning::AmbiguousNameResources, badResourceNames, Lookup[myProtocolPacket, Object]];
		];

		(* Replace these bad resources in our protocol/accessory packets. *)
		badResourceReplaceRules=(# -> Resource[Append[#[[1]], Name->CreateUUID[]]]&)/@badResources;

		{myProtocolPacket/.badResourceReplaceRules, myAccessoryPacket/.badResourceReplaceRules}
	];

	(* UploadProtocol tries to pull out the name option from the ResolvedOptions field, so drop it because otherwise *)
	(* DuplicateName error is thrown *)
	finalProtocolPacketWithoutNameOption=If[KeyExistsQ[finalProtocolPacket,ResolvedOptions],
		Module[{tempFinalProtocolPacket},
			tempFinalProtocolPacket=finalProtocolPacket;
			tempFinalProtocolPacket[ResolvedOptions]=KeyDrop[Lookup[finalProtocolPacket,ResolvedOptions,{}],Name];
			tempFinalProtocolPacket
		],
		finalProtocolPacket
	];

	(* Upload our protocol object, get back all of the resources etc. *)
	uploadResult=If[MatchQ[finalAccessoryPacket, {}],
		UploadProtocol[
			finalProtocolPacketWithoutNameOption,
			Simulation->simulation,
			ParentProtocol->parentProtocol,
			(* NOTE: This option will make it such that simulated samples are not attempted to be put into the PreparedSamples field. *)
			(* This functionality is intended when preparing samples via the PreparatoryUnitOperations option. *)
			IgnorePreparedSamples->True,
			SkipUploadProtocolStatus->True,
			SimulationMode -> True,
			Upload->False
		],
		UploadProtocol[
			finalProtocolPacketWithoutNameOption,
			finalAccessoryPacket,
			Simulation->simulation,
			ParentProtocol->parentProtocol,
			(* NOTE: This option will make it such that simulated samples are not attempted to be put into the PreparedSamples field. *)
			(* This functionality is intended when preparing samples via the PreparatoryUnitOperations option. *)
			IgnorePreparedSamples->True,
			SkipUploadProtocolStatus->True,
			SimulationMode -> True,
			Upload->False
		]
	];

	(* Make our upload result into a simulation. *)
	currentSimulation=If[MatchQ[simulation, Null],
		UpdateSimulation[Simulation[],Simulation[Packets->ToList[uploadResult]]],
		UpdateSimulation[simulation,Simulation[Packets->ToList[uploadResult]]]
	];

	(* Get the accessory objects. *)
	accessoryObjects=If[MatchQ[finalAccessoryPacket,{PacketP[]..}],
		Lookup[finalAccessoryPacket, Object],
		Null
	];

	(* Call the main overload. *)
	SimulateResources[
		Lookup[finalProtocolPacketWithoutNameOption, Object],
		accessoryObjects,
		IgnoreWaterResources->Lookup[safeOptions,IgnoreWaterResources],
		IgnoreCoverSimulation->Lookup[safeOptions,IgnoreCoverSimulation],
		Simulation->currentSimulation,
		ParentProtocol->parentProtocol,
		Cache->cache,
		PooledSamplesIn->Lookup[ToList[myOptions], PooledSamplesIn, Null]
	]
];

SimulateResources[
	protocol:PacketP[{Object[Protocol], Object[Maintenance], Object[Qualification]}, {Object}],
	myOptions:OptionsPattern[SimulateResources]
]:=Module[{},
	SimulateResources[protocol, Null, myOptions]
];

Error::RequiredPooledSamplesIn="The option PooledSamplesIn MUST be specified to SimulateResources if given a non SP Object[Protocol] that relates to a pooling experiment function. The PooledSamplesIn option should be of the same level of listing as the resolved options specified in the ResolvedOptions field.";
SimulateResources[
	myProtocol:ObjectReferenceP[{Object[Protocol], Object[Maintenance], Object[Qualification]}],
	myAccessoryObjects:{(ObjectReferenceP[]|LinkP[])...}|Null,
	myOptions:OptionsPattern[SimulateResources]
]:=Module[
	{
		currentSimulation,unavailableObjectPackets,availablePackets, fields,targetlabeledObjectsResourceBlobs,okSamplePositions,
		resourceFilteredDownload,fulfilledSamplePositions,unfulfilledSamplePositions,requiredResources,resourceData,resourceSampleData,
		resourceSampleContainerModels,duplicateFreeResourceData,duplicateFreeSampleData, newSampleInputs,samplesNeedNewWaste,samplesWithContainerResources,samplesWithContainerResourcesNoDup,
		samplesWithoutContainerResources,newContainersForSamplesNoDup,newContainersNameRule,newContainersForSamples,newContainersForSamplePackets,allContainers,allWells,allSamples,allAmounts,
		newSampleWithHistoryPackets,newSamplePackets,newSamples,allResources,sampleResourceUpdatePackets,newWasteObjectPackets,wasteBinSamplePositions,duplicateFreeNewWastes,wasteUpdatePackets, resourceToSampleRules,linkReplace,
		typeToBackLinkRules,pickedResourcesPackets,protocolResourceDownload,accessoryPacketObjects,instrumentStatusPackets,
		fieldDownloadCache,protocolNotebook,notebook,updatePackets,fulfilledResourcesToSamples,unfulfilledResourceToSampleRules, targetlabeledObjectsResourcePackets,
		targetInstrumentResources, okInstrumentPositions,instrumentResourceFilteredDownload,fulfilledInstrumentPositions,fulfilledResourcesToInstruments,
		unfulfilledInstrumentPositions,unfulfilledInstrumentResourceModels,unfulfilledInstrumentResources, potentialInstrumentObjectsForModels,
		unfulfilledResourceToInstruments, instrumentResourceUpdatePackets,safeOptions,cache,simulation,parentProtocol,simulatedProtocolPacket,
		experimentFunction, protocolPacket, accessoryPackets, unavailableInstrumentPackets, resourceInstrumentData, wasteBinData, allInstrumentPackets,
		protocolFields, accessoryPacketFields, potentialInstrumentObjectsForModelsPackets, notAvailableInstrumentPackets,
		containerResourcesToFulfill, allResourcePackets, containerResourceUpdatePackets, colonyHandlerHeadCassettePackets,
		targetlabeledObjectsResourcePacketsWithWaters, ignoreWaterResources, ignoreCoverSimulation, resolvedIgnoreCoverSimulation, protocolSite
	},

	(* Get our options. *)
	safeOptions=SafeOptions[SimulateResources, ToList[myOptions]];
	cache=Lookup[safeOptions, Cache];
	simulation=Lookup[safeOptions, Simulation];
	parentProtocol=Lookup[safeOptions, ParentProtocol];
	{ignoreWaterResources, ignoreCoverSimulation} = Lookup[safeOptions, {IgnoreWaterResources, IgnoreCoverSimulation}];

	(* Note: In SimulateResources (in the call of UploadSample), if we are simulating a container from model, the cover of the container will be simulated if IgnoreCoverSimulation->False *)
	(* When RSP/RCP is performed, a Cover unit operation will be added to the end if the input container is not covered *)
	(* In that case, we should skip Cover simulation in UploadSample when SimulationMode is true. *)
	resolvedIgnoreCoverSimulation = Which[
		MatchQ[ignoreCoverSimulation, BooleanP], ignoreCoverSimulation,
		MatchQ[myProtocol, ObjectP[{Object[Protocol, RoboticSamplePreparation], Object[Protocol, RoboticCellPreparation]}]], True,
		True, False
	];

	(* Set our current simulation. *)
	currentSimulation=If[MatchQ[simulation, SimulationP],
		simulation,
		Simulation[]
	];

	(* Figure out our accessory packet objects. *)
	accessoryPacketObjects=If[MatchQ[myAccessoryObjects, {(ObjectP[]|LinkP[])..}],
		Download[myAccessoryObjects, Object],
		{}
	];

	(* get all the protocol object fields because doing Packet[All] doesn't work well *)
	protocolFields = Packet @@ Fields[Download[myProtocol, Type], Output -> Short];

	(* need to get a little more creative with the accessory packets because if they aren't all one type, then you can't do this trick *)
	accessoryPacketFields = If[Not[NullQ[myAccessoryObjects]] && Length[DeleteDuplicates[Download[myAccessoryObjects, Type]]] == 1,
		Packet @@ Fields[Download[myAccessoryObjects[[1]], Type], Output -> Short],
		Packet[All]
	];

	(* download from the protocol's required resources *)
	(* NOTE: We download ALL fields in the protocol object and accessory object since we have to lookup the value of fields in them to *)
	(* replace with resources. The alternative way this used to work is to download RequiredResources first, then only download the backlink *)
	(* fields in the protocol/accessory objects, but since everything is simulated it shouldn't actually hit the database and thus is better *)
	(* to download everything up front. *)
	{protocolResourceDownload, protocolPacket, accessoryPackets}=Quiet[
		Download[
			{
				Join[{myProtocol}, accessoryPacketObjects],
				{myProtocol},
				accessoryPacketObjects
			},
			{
				{
					RequiredResources,
					Packet[RequiredResources[[All,1]][{Sample,Models,ContainerModels,ContainerName,Well,Amount,Instrument,InstrumentModels, ContainerResource}]],
					Packet[RequiredResources[[All,1]][Sample][{Composition,Model,Status,CurrentProtocol}]],
					RequiredResources[[All,1]][Sample][Container][Model][Object],
					Packet[RequiredResources[[All, 1]][Instrument][{Model, Status, CurrentProtocol}]],
					Packet[RequiredResources[[All, 1]][Models][WasteType]]
				},
				{protocolFields},
				{accessoryPacketFields}
			},
			Simulation->currentSimulation
		],
		{Download::NotLinkField,Download::FieldDoesntExist,Download::ObjectDoesNotExist}
	];

	protocolPacket=FirstOrDefault@Flatten[protocolPacket];
	protocolSite = Download[Lookup[protocolPacket, Site], Object];
	accessoryPackets=Flatten[accessoryPackets];
	(* NOTE: We can get some $Failed results in our download, so we need to transform those into empty lists before we can call Join. *)
	protocolResourceDownload=(Join@@(#/.{$Failed->{}})&)/@Transpose[protocolResourceDownload];

	(* NOTE: We have to strip link IDs here because the logic that uses this cache depends on it. *)
	fieldDownloadCache=Flatten[{protocolPacket, accessoryPackets}]/.link_Link:>RemoveLinkID[link];

	(* find the sample packets that are not available and whose currentprotocol isn't the input protocol *)
	unavailableObjectPackets=Cases[protocolResourceDownload[[3]],KeyValuePattern[{Status->Except[Available],CurrentProtocol->Except[LinkP[myProtocol]]}]];
	unavailableInstrumentPackets = Cases[protocolResourceDownload[[5]],KeyValuePattern[{Status->Except[Available],CurrentProtocol->Except[LinkP[myProtocol]]}]];

	(* create packets to set any of the unavailable samples to available *)
	availablePackets=If[!MatchQ[Flatten[{unavailableObjectPackets, unavailableInstrumentPackets}],{}],
		(* NOTE: We should technically be using UploadSampleStatus/UploadInstrumentStatus here, but that function will do a lot of un-necessary things like *)
		(* busing the ReadyCheck cache. We do this for speed. *)
		(
			<|
				Object->#,
				Status->Available,
				CurrentProtocol->Null
			|>
				&)/@Lookup[Flatten[{unavailableObjectPackets, unavailableInstrumentPackets}],Object],
		{}
	];

	(* the list of fields in the second column of RequiredResources *)
	fields=Cases[First[protocolResourceDownload][[All,2]], Except[Null]];

	(* no fields to look at, return early *)
	If[MatchQ[fields,{}],
		Return[currentSimulation];
	];

	(* find any resources pointing to the target fields *)
	targetlabeledObjectsResourceBlobs=Download[
		Cases[First[protocolResourceDownload],{ObjectP[Object[Resource,Sample]],Alternatives@@fields,_,_}][[All,1]],
		Object
	];
	targetInstrumentResources=Download[
		Cases[First[protocolResourceDownload],{ObjectP[Object[Resource,Instrument]],Alternatives@@fields,_,_}][[All,1]],
		Object
	];

	(* get the packets for the resources we're going to fulfill, and pull out the container resources, if applicable *)
	targetlabeledObjectsResourcePacketsWithWaters = fetchPacketFromCache[#, protocolResourceDownload[[2]]]& /@ targetlabeledObjectsResourceBlobs;

	(* if IgnoreWaterResources -> True, filter out the water resources here *)
	(* we do this because SimulateProcedure's use of SimulateResources really does not want us to simulate fulfilling water resources because it doesn't replicate how it ever actually happens in the lab and thus messes with the framework *)
	targetlabeledObjectsResourcePackets = If[TrueQ[ignoreWaterResources],
		DeleteCases[targetlabeledObjectsResourcePacketsWithWaters, KeyValuePattern[{ContainerResource -> ObjectP[]}]],
		targetlabeledObjectsResourcePacketsWithWaters
	];

	containerResourcesToFulfill = Download[
		Cases[Lookup[targetlabeledObjectsResourcePackets, ContainerResource], ObjectP[]],
		Object
	];

	(* Set all of our resources to be picked. *)
	pickedResourcesPackets=(<|Object->#, Status->InUse|>&)/@Flatten[{Lookup[targetlabeledObjectsResourcePackets, Object, {}], containerResourcesToFulfill}];

	(* update our simulation *)
	currentSimulation=UpdateSimulation[currentSimulation, Simulation[Packets->Flatten[{pickedResourcesPackets, availablePackets}]]];

	(* find any resource positions that are of type Object[Resource, Instrument] *)
	okInstrumentPositions=Position[
		Download[First[protocolResourceDownload][[All,1]],Object],
		ObjectP[targetInstrumentResources],
		1,
		Heads->False
	];

	(* extract only the data relating to resources of interest *)
	instrumentResourceFilteredDownload=Extract[#,okInstrumentPositions]&/@protocolResourceDownload;

	(* find the positions of resources that aren't already pointing to an Object so we can skip it, unless that object needs to be in a different container model *)
	fulfilledInstrumentPositions=Position[
		instrumentResourceFilteredDownload[[2]],
		_?(MatchQ[Lookup[#,Instrument],ObjectP[Object[Instrument]]]&),
		1,
		Heads->False
	];

	(* Create rules of existing fulfilled resources to their fulfilled instruments. *)
	fulfilledResourcesToInstruments=(
		Download[Lookup[instrumentResourceFilteredDownload[[2]][[#]], Object], Object]->Download[Lookup[instrumentResourceFilteredDownload[[2]][[#]], Instrument], Object]
			&)/@Flatten[fulfilledInstrumentPositions];

	(* get the positions that remain unfulfilled *)
	unfulfilledInstrumentPositions=DeleteCases[List/@Range[Length[First[instrumentResourceFilteredDownload]]],Alternatives@@fulfilledInstrumentPositions];

	(* Get the instrument resources that still need to be fulfilled and the instrument models that will fulfill them. *)
	{unfulfilledInstrumentResources, unfulfilledInstrumentResourceModels}=If[Length[Flatten[unfulfilledInstrumentPositions]]==0,
		{{},{}},
		Transpose[
			({
				Download[Lookup[instrumentResourceFilteredDownload[[2]][[#]], Object], Object],
				Download[Lookup[instrumentResourceFilteredDownload[[2]][[#]], InstrumentModels], Object]
			}&)/@Flatten[unfulfilledInstrumentPositions]
		]
	];

	(* Search for instrument objects that aren't deprecated that will fulfill these resources. *)
	(* if we don't have any instrument resources then don't bother doing this *)
	allInstrumentPackets = If[MatchQ[unfulfilledInstrumentResourceModels, {}],
		{},
		allActiveInstrumentPackets[DeleteDuplicates[Download[Flatten[unfulfilledInstrumentResourceModels], Type]]]
	];

	(* get the instrument objects specific to our instruments in question; must be the correct site *)
	potentialInstrumentObjectsForModels = Map[
		Function[{instrumentModels},
			(* if we don't actually know the protocol's site, then just pick whatever *)
			ToList[Lookup[SelectFirst[allInstrumentPackets, MatchQ[Lookup[#, Model], ObjectP[instrumentModels]] && (NullQ[protocolSite] || MatchQ[Lookup[#, Site], ObjectP[protocolSite]])&, {}], Object, {}]]
		],
		unfulfilledInstrumentResourceModels
	];

	(* get the instrument packets for the things objects we're going for *)
	potentialInstrumentObjectsForModelsPackets = Download[potentialInstrumentObjectsForModels, Packet[Status]];

	(* Link up these instrument resources to an acceptable instrument. *)
	(* NOTE: If there are no non-retired-or-undergoing maintenance objects, we'll replace with Null here. *)
	{unfulfilledResourceToInstruments, instrumentResourceUpdatePackets}=If[Length[unfulfilledInstrumentResources]==0,
		{{},{}},
		Transpose@MapThread[
			Function[{instrumentResource, instrumentPackets},
				{
					instrumentResource->FirstOrDefault[Lookup[instrumentPackets, Object, {}], Null],
					<|
						Object->instrumentResource,
						Instrument->Link[FirstOrDefault[Lookup[instrumentPackets, Object, {}], Null]],
						Status->InUse
					|>
				}
			],
			{unfulfilledInstrumentResources, potentialInstrumentObjectsForModelsPackets}
		]
	];

	(* NOTE 2: If we only ended up with UndergoingMaintenance ones, we need to set the instrument back to Available manually here; this is only in simulation land so we're not actually messing it up *)
	(* theoretically that can cause problems if the UndergoingMaintenance (or I suppose Running) instrument is not in its base state, but that's better than nothing *)
	notAvailableInstrumentPackets = Select[Flatten[potentialInstrumentObjectsForModelsPackets], MatchQ[Lookup[#, Status], UndergoingMaintenance|Running]&];
	instrumentStatusPackets = UploadInstrumentStatus[
		Lookup[notAvailableInstrumentPackets, Object, {}],
		Available,
		FastTrack -> True,
		SimulationMode -> True,
		Upload -> False,
		(* this is SUPER DUMB but seemingly UploadInstrumentStatus will not allow anything to set UndergoingMaintenance instruments to Available except for quals if they failed the previous qual *)
		(* this means that if the instrument the above Search found is UndergoingMaintenance from a failed qual, we're not going to actually set it to Available which can mess with procedure simulation later *)
		(* to get around this, I need to spoof a qual to do this setting back to Available.  Since UploadInstrumentStatus Downloads the CurrentInstruments field of the UpdatedBy, I need to make a fake packet to get {} so it doesn't throw ObjectDoesNotExist errors *)
		(* again agreed that this is super dumb.  But this allows us to be a little less dependent on the current state of the lab when simulating resources *)
		UpdatedBy -> <|Object -> SimulateCreateID[Object[Qualification, EngineBenchmark]], CurrentInstruments -> {}|>
	];

	(* find any resource positions that are of type Object[Resource, Sample] *)
	(* NOTE: In certain cases, when there are too many resources, Position can error out with a recursion limit when using ObjectP. *)
	(* Since we're downloading objects here, Alterantives should be fine. *)
	okSamplePositions=Position[
		Download[First[protocolResourceDownload][[All,1]],Object],
		Alternatives@@Lookup[targetlabeledObjectsResourcePackets, Object, {}],
		1,
		Heads->False
	];

	(* extract only the data relating to resources of interest *)
	resourceFilteredDownload=Extract[#,okSamplePositions]&/@protocolResourceDownload;

	(* find the positions of resources that aren't already pointing to an Object so we can skip it, unless that object needs to be in a different container model *)
	(* note that index 4 here refers to the container model; this used to be Last, but we added an extra value to Download and that caused issues *)
	fulfilledSamplePositions=Position[
		Transpose[{resourceFilteredDownload[[2]],resourceFilteredDownload[[4]]}],
		_?(
			And[
				MatchQ[Lookup[First[#],Sample],ObjectP[{Object[Sample],Object[Part],Object[Item],Object[Container],Object[Plumbing],Object[Wiring]}]],
				(
					Or[
						MatchQ[Lookup[First[#],ContainerModels],{}],
						MemberQ[Download[Lookup[First[#],ContainerModels],Object],Download[Last[#],Object]]
					]
				)
			]
				&),
		1,
		Heads->False
	];

	(* Create rules of existing fulfilled resources to their fulfilled samples/containers. *)
	fulfilledResourcesToSamples=(
		Download[Lookup[resourceFilteredDownload[[2]][[#]], Object], Object]->Download[Lookup[resourceFilteredDownload[[2]][[#]], Sample], Object]
			&)/@Flatten[fulfilledSamplePositions];

	(* get the positions that remain unfulfilled *)
	unfulfilledSamplePositions=DeleteCases[List/@Range[Length[First[resourceFilteredDownload]]],Alternatives@@fulfilledSamplePositions];

	(* extract the download data that is okay to fake *)
	{requiredResources,resourceData,resourceSampleData,resourceSampleContainerModels,resourceInstrumentData,wasteBinData}=Extract[#,unfulfilledSamplePositions]&/@resourceFilteredDownload;

	(* remove any repeated resources from the resourceData and resourceSampleData so we don't create extra objects *)
	{duplicateFreeResourceData,duplicateFreeSampleData}=If[Length[resourceData]>0,
		Transpose[
			DeleteDuplicatesBy[
				Transpose[{resourceData,resourceSampleData}],
				(Lookup[First[#],Object]&)
			]
		],
		{{}, {}}
	];

	(* create all the information needed to call UploadSample *)
	newSampleInputs=MapThread[
		Function[{resourcePacket,resourceSample},
			Module[{model,initialAmount,newContainerModel,containerName,well,wasteType,wasteModel},

				(* model of thing to create *)
				model = Which[
					!MatchQ[Lookup[resourcePacket, Models], {}],
						(* the first item in models list if there's something there *)
						First[Lookup[resourcePacket, Models]],

					(* the model of the sample, otherwise its composition *)
					!NullQ[Quiet[Lookup[resourceSample, Model]]],
						Quiet[Lookup[resourceSample, Model]],

					!NullQ[Quiet[Lookup[resourceSample, Composition]]],
						Quiet[Lookup[resourceSample, Composition]][[All, 1 ;; 2]]
				];

				(* amount of thing to create *)
				initialAmount = Switch[Lookup[resourcePacket, Amount],
					UnitsP[Unit], Unitless[Floor[Lookup[resourcePacket, Amount]]],
					UnitsP[], Lookup[resourcePacket, Amount],
					_, Null
				];

				(* container of new thing *)
				newContainerModel=Which[

					(* a specific model is requested, pick the first one *)
					Length[Lookup[resourcePacket,ContainerModels]]>0,First[Lookup[resourcePacket,ContainerModels]],

					(* none requested but it's a mass or volume, choose the preferred container *)
					MatchQ[initialAmount,(MassP|VolumeP)],PreferredContainer[initialAmount],

					(* non-self contained sample, stick it in 50 mL tube *)
					MatchQ[model,NonSelfContainedSampleModelP],Model[Container,Vessel,"50mL Tube"],

					(* If the model is a Model[Part,ColonyHandlerHeadCassette], its container needs to be a CassetteHolder *)
					MatchQ[model, ObjectP[Model[Part,ColonyHandlerHeadCassette]]],Model[Container, ColonyHandlerHeadCassetteHolder, "id:jLq9jXqwWKpE"], (* Model[Container, ColonyHandlerHeadCassetteHolder, "QPix Colony Handler Head Cassette Holder"] *)

					(* otherwise put it in the empty simulation room *)
					True, Object[Container, Room, "id:AEqRl9KmEAz5"]
				];

				(* If there is no container name, the container is always unique. *)
				containerName=Lookup[resourcePacket,ContainerName]/.{Null->CreateUUID[]};

				(* If the newContainerModel is Model[Container, ColonyHandlerHeadCassetteHolder, "QPix Colony Handler Head Cassette Holder"] *)
				(* then set the well to  "ColonyHandlerHeadCassette Slot" *)
				well=If[MatchQ[newContainerModel,ObjectP[Model[Container, ColonyHandlerHeadCassetteHolder, "QPix Colony Handler Head Cassette Holder"]]],
					"ColonyHandlerHeadCassette Slot",
					Lookup[resourcePacket,Well]
				];

				(* If the new sample is a Model[Container, WasteBin], and the waste type is one of the WasteNeededBinWasteTypeP, the Model[Container, Waste] corresponding to the waste type is also returned *)
				wasteType = If[MatchQ[model,ObjectP[Model[Container,WasteBin]]],
					Lookup[fetchPacketFromCache[model,Flatten[wasteBinData]],WasteType],
					Null
				];

				(* Determine the Model[Container,Waste] for the type *)
				wasteModel = If[MatchQ[wasteType,WasteNeededBinWasteTypeP],
					Lookup[wasteTypeToWasteModelLookup["Memoized"],wasteType,Null],
					Null
				];
				(* return each resource with its model, amount, and container *)
				{Lookup[resourcePacket,Object],model,initialAmount,newContainerModel,containerName,well, wasteModel}
			]
		],
		{duplicateFreeResourceData,duplicateFreeSampleData}
	];

	(* split the new objects into those that also need a container made and those that do not *)
	(* Only need to create one container for each ContainerName *)
	samplesWithContainerResources=Cases[newSampleInputs,{_,_,_,ObjectP[Model[Container]],_,_,_}];
	samplesWithContainerResourcesNoDup=GatherBy[samplesWithContainerResources,(#[[-3]])&];
	(* ValidResourceQ guarantees that we have ContainerModels if we have ContainerName so no need to consider it here *)
	samplesWithoutContainerResources=Cases[newSampleInputs,{_,_,_,Object[Container, Room, "id:AEqRl9KmEAz5"],_,_,_}]; (* Object[Container, Room, "Empty Room for Simulated Objects"] *)

	(* Determine new samples that are wastebins, and need a new Object[Container, Waste] created to be usable for disposal *)
	samplesNeedNewWaste = Cases[newSampleInputs,{_,_,_,_,_,_,ObjectP[Model[Container,Waste]]}];

	(* get the notebook of our protocol packet. If the protocol packet does not have a notebook, use $Notebook *)
	protocolNotebook=Lookup[fetchPacketFromCache[myProtocol, fieldDownloadCache], Notebook];
	notebook=If[NullQ[protocolNotebook],
		$Notebook,
		protocolNotebook
	];

	(* make containers for those samples that need it *)
	newContainersForSamplePackets=If[Length[samplesWithContainerResources]>0,
		UploadSample[
			samplesWithContainerResourcesNoDup[[All,1,-4]],
			ConstantArray[{"A1",Object[Container, Room, "id:AEqRl9KmEAz5"]}, Length[samplesWithContainerResourcesNoDup]], (* Object[Container,Room,"Empty Room for Simulated Objects"] *)
			Notebook->notebook,
			UpdatedBy->myProtocol,
			SimulationMode->True,
			Cover->If[TrueQ[resolvedIgnoreCoverSimulation],Null,Automatic],
			FastTrack->True,
			Upload->False,
			Simulation->currentSimulation
		],
		{}
	];

	(* update our simulation *)
	currentSimulation=UpdateSimulation[currentSimulation, Simulation[Packets->newContainersForSamplePackets]];

	(* get the new container packets from all the packets *)
	newContainersForSamplesNoDup=If[Length[samplesWithContainerResourcesNoDup]>0,
		Take[newContainersForSamplePackets,Length[samplesWithContainerResourcesNoDup]],
		{}
	];
	(* rule: containerName -> new container object *)
	(* In samplesWithContainerResourcesNoDup, we grouped samplesWithContainerResources with ContainerName (-3) so we only create one unique container object for each container name *)
	(* Now associate the ContainerName (-3) with the new container object *)
	newContainersNameRule=AssociationThread[samplesWithContainerResourcesNoDup[[All,1,-3]],newContainersForSamplesNoDup];

	(* get the new container objects using the ContainerName (-3) so that the new container list matches the original order *)
	newContainersForSamples=samplesWithContainerResources[[All,-3]]/.newContainersNameRule;

	(* rejoin the lists of resources, containers, samples, and amounts *)
	allResources=Join[samplesWithContainerResources[[All,1]],samplesWithoutContainerResources[[All,1]]];
	allResourcePackets = fetchPacketFromCache[#, protocolResourceDownload[[2]]]& /@ allResources;
	allContainers=Join[newContainersForSamples,samplesWithoutContainerResources[[All,-4]]];
	allWells=Join[(samplesWithContainerResources[[All,-2]])/.{Null->"A1"},ConstantArray["A1",Length[samplesWithoutContainerResources]]];
	allSamples=Join[samplesWithContainerResources[[All,2]],samplesWithoutContainerResources[[All,2]]];
	allAmounts=Join[samplesWithContainerResources[[All,3]],samplesWithoutContainerResources[[All,3]]];
	(* upload the new samples into A1 of their corresponding containers with the initial amounts *)
	newSampleWithHistoryPackets=If[Length[allSamples]>0,
		UploadSample[
			allSamples,
			MapThread[
				{#1,#2}&,
				{allWells,allContainers}
			],
			InitialAmount->allAmounts,
			FastTrack->True,
			Notebook->notebook,
			Upload->False,
			UpdatedBy->myProtocol,
			SimulationMode->True,
			Cover->If[TrueQ[resolvedIgnoreCoverSimulation],Null,Automatic],
			Simulation->currentSimulation
		],
		{}
	];

	(* drop the sample history packets because they break ValidUploadQ *)
	newSamplePackets=KeyDrop[#,{Append[SampleHistory],Replace[SampleHistory]}]&/@newSampleWithHistoryPackets;

	(* grab the new samples *)
	newSamples=Download[Take[newSamplePackets,Length[allSamples]],Object];

	(* create packets to update the resources and to relate resources to their samples *)
	{sampleResourceUpdatePackets,unfulfilledResourceToSampleRules}=If[Length[allResources]>0,
		Transpose[
			MapThread[
				{
					<|
						Object->#1,
						Sample->Link[#2],
						Status->InUse
					|>,
					#1->#2
				}&,
				{allResources,newSamples}
			]
		],
		{{}, {}}
	];

	(* create packets to update the container resources (if applicable) with the containers of the corresponding water samples *)
	containerResourceUpdatePackets = MapThread[
		If[MatchQ[Lookup[#1, ContainerResource], ObjectP[Object[Resource, Sample]]],
			<|
				Object -> Download[Lookup[#1, ContainerResource], Object],
				Sample -> Link[#2],
				Status -> InUse
			|>,
			Nothing
		]&,
		{allResourcePackets, allContainers}
	];

	(* Update some special fields for ColonyHandlerHeadCassettes/Holders *)
	colonyHandlerHeadCassettePackets = Flatten@MapThread[
		Function[{sample,container},
			If[MatchQ[sample,ObjectP[Object[Part,ColonyHandlerHeadCassette]]],
				{
					<|
						Object->sample,
						ColonyHandlerHeadCassetteHolder -> Link[container,ColonyHandlerHeadCassette]
					|>
				},
				Nothing
			]
		],
		{
			newSamples,
			allContainers
		}
	];

	(* create packets to of new waste (if applicable) to put into the wastebin resources simulated *)
	newWasteObjectPackets = If[Length[samplesNeedNewWaste]>0,
		UploadSample[
			samplesNeedNewWaste[[All,-1]],
			ConstantArray[{"A1",Object[Container, Room, "id:AEqRl9KmEAz5"]}, Length[samplesNeedNewWaste]], (* Object[Container,Room,"Empty Room for Simulated Objects"] *)
			FastTrack->True,
			Notebook->notebook,
			Upload->False,
			UpdatedBy->myProtocol,
			SimulationMode->True,
			Cover->If[TrueQ[resolvedIgnoreCoverSimulation],Null,Automatic],
			Simulation->currentSimulation
		],
		{}
	];
	(*Get the position of the waste bin resource in the sample list created*)
	wasteBinSamplePositions = Position[allResources,ObjectP[samplesNeedNewWaste[[All,1]]],1,Heads->False];
	duplicateFreeNewWastes = DeleteDuplicates[Cases[Download[newWasteObjectPackets,Object],ObjectP[Object[Container,Waste]]]];
	(*Upload the location of the new waste object into its corresponding waste bin*)
	wasteUpdatePackets = If[Length[newWasteObjectPackets]>0,
		MapThread[
			<|
				Object->#1,
				Append[Contents]->{"Waste Slot",Link[#2,Container]}
			|>&,
			{
				Extract[newSamples,wasteBinSamplePositions],
				duplicateFreeNewWastes
			}
		],
		{}
	];

	(* Join all of our resource to sample rules. *)
	resourceToSampleRules=Join[unfulfilledResourceToSampleRules,fulfilledResourcesToSamples,unfulfilledResourceToInstruments,fulfilledResourcesToInstruments];

	(* function to swap link objects *)
	linkReplace:=Function[
		{backLinkRules,oldLink,newTarget},
		ReplaceAll[
			oldLink,
			Link[_,___]:>DeleteCases[Link[newTarget,Sequence@@(newTarget[Type]/.backLinkRules)],Nothing]
		]
	];

	(* create a list of rules pointing a field position to their expected backlink *)
	typeToBackLinkRules:=Function[
		{fieldRelations},
		Flatten[
			ReplaceAll[
				fieldRelations,
				{
					(type:Object[__])[backLink___] :> (#->{backLink}&/@Types[type]),
					(type:Object[__]) :> (#->Nothing &/@Types[type]),
					(Model[__][__]|Model[__]):>Nothing
				}
			]
		]
	];

	(* For each of our packets, create updates to replace any models with the objects that we created. *)
	updatePackets=MapThread[
		Function[{object, objectRequiredResources},
			Module[{groupedResources, packet, replacedFields},
				(* group resources/samples by the field they are going to *)
				groupedResources=GroupBy[
					(* NOTE: Only include resources here for which we have replace rules. *)
					(* Follows the logic above about how we only replace things visible in the main protocol object. *)
					Cases[objectRequiredResources/.{link:LinkP[]:>Download[link,Object]}, {Alternatives@@resourceToSampleRules[[All,1]], _, _, _}]/.resourceToSampleRules,
					(#[[2]]&)->(DeleteCases[{Download[#[[1]], Object],#[[3]],#[[4]]},Null]&)
				];

				(* fetch the packet for this object. *)
				(* this is so that we can get the current value of the field that we're slotting in our resource value into. *)
				packet=fetchPacketFromCache[object, fieldDownloadCache];

				(* go through every field that is being altered and insert the new sample links *)
				replacedFields=KeyValueMap[
					Function[{field,samplesAndPositions},
						Module[{fieldContents,fieldRelations,listedFieldRelations,newLink,keyedPosition,subFieldRelations,listedSubFieldRelations,replacements,backlinkRules,specificContents,typesInRelations},
							(* see where the links in this field are supposed to go *)
							fieldRelations=LookupTypeDefinition[object[Type][field],Relation];
							listedFieldRelations = If[MatchQ[fieldRelations, _Alternatives],
								List @@ fieldRelations,
								ToList[fieldRelations]
							];

							(* lookup the current contents of the field *)
							fieldContents=Lookup[packet,field];

							(* act based on whether we're working on a single field or any other type of field *)
							Switch[Rest[First[samplesAndPositions]],
								(* single field (not named single) *)
								{},
								(* replace the current link with a link to the new sample *)
								Module[{},
									backlinkRules=typeToBackLinkRules[listedFieldRelations];
									typesInRelations=Cases[
										listedFieldRelations,
										(type : Object[___] | Model[___])|(type : (Object[___] | Model[___]))[___]  :> type,
										Infinity
									];

									(* Make sure that the contents in the upload packet can actually be uploaded. *)
									If[!MatchQ[fieldContents, ObjectP[typesInRelations]],
										Message[Error::SimulateResourcesInvalidBacklink, ToString[fieldContents], field];

										Return[$Failed, Module];
									];

									field->linkReplace[backlinkRules,fieldContents,First[First[samplesAndPositions]]]
								],
								_,
								(* not a single field *)
								replacements=Map[
									Function[{sampleAndPosition},

										(* wrap key around any field names *)
										keyedPosition=Replace[Rest[sampleAndPosition],x_Symbol:>Key[x],{1}];

										subFieldRelations=Switch[keyedPosition,
											{Key[_Symbol]},First[First[keyedPosition]]/.fieldRelations (* Named Single *),
											{_Integer} && Or[MatchQ[fieldRelations, _Alternatives],TypeQ[fieldRelations]],fieldRelations, (* Multiple *)
											{_Integer}, fieldRelations[[Last[keyedPosition]]], (* Indexed Single *)
											{_Integer,_Integer},fieldRelations[[Last[keyedPosition]]] (* Indexed Multiple *),
											{_Integer,Key[_Symbol]},First[Last[keyedPosition]]/.fieldRelations (* Named Multiple *)
										];

										listedSubFieldRelations=If[MatchQ[subFieldRelations,_Alternatives],
											List@@subFieldRelations,
											ToList[subFieldRelations]
										];

										backlinkRules=typeToBackLinkRules[listedSubFieldRelations];
										typesInRelations=Cases[
											Flatten[listedFieldRelations],
											(type : Object[___] | Model[___])|(type : (Object[___] | Model[___]))[___]  :> type,
											Infinity
										];
										specificContents=Extract[fieldContents, keyedPosition];

										(* Make sure that the contents in the upload packet can actually be uploaded. *)
										If[!MatchQ[specificContents, ObjectP[typesInRelations]],
											Message[Error::SimulateResourcesInvalidBacklink, ToString[specificContents], field];

											Return[$Failed, Module];
										];

										(* extract the link currently sitting in the position specified and replace it with the new sample *)
										newLink=linkReplace[
											typeToBackLinkRules[listedSubFieldRelations],
											specificContents,
											First[sampleAndPosition]
										];

										(* point the position to the new link *)
										keyedPosition->newLink
									],
									samplesAndPositions
								];

								(* use replacepart to insert the new links *)
								If[ListQ[fieldContents],
									Replace[field]->ReplacePart[fieldContents,replacements],
									field->ReplacePart[fieldContents,replacements]
								]
							]
						]
					],
					groupedResources
				];

				(* create packet to upload to the protocol object *)
				Join[<|Object->object|>,Association@@replacedFields]
			]
		],
		{
			Join[{Download[myProtocol, Object]}, accessoryPacketObjects],
			Join[{Lookup[protocolPacket, RequiredResources, {}]}, Lookup[accessoryPackets, RequiredResources, {}]]
		}
	];

	(* update our simulation *)
	currentSimulation=UpdateSimulation[
		currentSimulation,
		Simulation[
			Packets->Flatten[{
				sampleResourceUpdatePackets,
				containerResourceUpdatePackets,
				instrumentResourceUpdatePackets,
				newSamplePackets,
				updatePackets,
				instrumentStatusPackets,
				colonyHandlerHeadCassettePackets,
				newWasteObjectPackets,
				wasteUpdatePackets
			}]
		]
	];

	(* Download our protocol packet again. *)
	simulatedProtocolPacket=Quiet[Download[myProtocol, Packet[SamplesIn, ResolvedOptions], Simulation->currentSimulation]];

	(* Get our experiment function we're being called from. *)
	experimentFunction = If[MemberQ[Flatten[Values[If[MatchQ[$ECLApplication,CommandCenter],Experiment`Private`experimentFunctionTypeLookup,ProcedureFramework`Private`experimentFunctionTypeLookup]]], Lookup[simulatedProtocolPacket, Type]],
		FirstCase[
			Normal@If[MatchQ[$ECLApplication,CommandCenter],Experiment`Private`experimentFunctionTypeLookup,ProcedureFramework`Private`experimentFunctionTypeLookup],
			(Verbatim[Rule][function_, Lookup[simulatedProtocolPacket, Type]|{___, Lookup[simulatedProtocolPacket, Type], ___}]:>function)
		],
		Null
	];

	(* Download our SamplesIn again (after resources have been simulated) and update the WorkingSamples if we have sample prep options. *)
	(* Simulate any sample prep that we may have encountered and fill out the WorkingSamples field of the protocol object. *)
	(* NOTE: If we're one of the framework functions, don't bother updating WorkingSamples since they don't get updated in these protocol objects. *)
	(* NOTE: if we're in global simulation $Simulation = True land, then don't do this because that means we're simulating a full procedure and thus will get the _actual_ simulated WorkingSamples later on *)
	(* NOTE: Also, we rely on ProcedureFramework`Private`experimentFunctionTypeLookup to go from our type to experiment function to use,
	unless we're in CC in which case we don't have access to the PF. *)
	(* we check here that the Options for the function include Centrifuge, Filter, Mix and Incubate - presence of all 4 means that we have sample prep options *)
	currentSimulation=Which[
		And[
			!MatchQ[Lookup[simulatedProtocolPacket, Object], ObjectP[{Object[Protocol, ManualSamplePreparation], Object[Protocol, ManualCellPreparation], Object[Protocol, RoboticSamplePreparation], Object[Protocol, RoboticCellPreparation]}]],
			Not[$Simulation],
			!MatchQ[experimentFunction, Null],
			MatchQ[Lookup[simulatedProtocolPacket, SamplesIn], {ObjectP[]..}],
			MatchQ[Lookup[simulatedProtocolPacket, ResolvedOptions], _List],
			Length[
				Intersection[
					Keys[Options[experimentFunction]],
					{"Centrifuge","Filter","Mix","Incubate"}
				]
			]>0
		],
		Module[{samples, options, expandedResolvedOptions, workingSamples, workingSamplesSimulation, validInputLengthQ, numReplicates, expandedAliquotSampleLabelsWithReplicates},

			(* Get our inputs and options and expand resolved options. *)
			{samples, options}=Download[myProtocol, {SamplesIn, ResolvedOptions}, Simulation -> currentSimulation];

			(* If we have the PooledSamplesIn option give, overwrite our samples option. *)
			With[{insertMe=experimentFunction},
				If[MatchQ[Lookup[safeOptions, PooledSamplesIn], Except[Null]] && MatchQ[Lookup[First[Lookup[Usage[insertMe],"Input"]],"NestedIndexMatching"], True],
					samples=Lookup[safeOptions, PooledSamplesIn];
				]
			];

			(* NOTE: If we have a pooling function, we MUST be given this option. If not, throw an error. *)
			With[{insertMe=experimentFunction},
				If[MatchQ[Lookup[First[Lookup[Usage[insertMe],"Input"]],"NestedIndexMatching"], True] && MatchQ[Lookup[safeOptions, PooledSamplesIn], Null],
					Message[Error::RequiredPooledSamplesIn];

					Return[$Failed];
				]
			];


			(* Sanitize the samples used in this function *)
			(* NOTE: ExperimentAdjustpH has two inputs so we have to hard code this. *)
			validInputLengthQ=If[MatchQ[experimentFunction, ExperimentAdjustpH],
				ValidInputLengthsQ[experimentFunction,{samples, ConstantArray[7, Length[samples]]},options,1,Messages->False],
				ValidInputLengthsQ[experimentFunction,{samples},options,1,Messages->False]
			];

			(* get the number of replicates value *)
			numReplicates=Lookup[options,NumberOfReplicates];

			(* Sanitize samples if the validInputLengthQ is not valid and number of replicates in the resolvedOptions is specified*)
			If[
				And[Not[validInputLengthQ],(numReplicates>1)],
				samples=samples[[;;;;numReplicates]];
			];

			(* NOTE: ExperimentAdjustpH has two inputs so we have to hard code this. *)
			expandedResolvedOptions=Which[
				MatchQ[experimentFunction, ExperimentAdjustpH],
				Last[ExpandIndexMatchedInputs[experimentFunction, {samples, ConstantArray[7, Length[samples]]}, options]],
				True,
				Last[ExpandIndexMatchedInputs[experimentFunction, {samples}, options]]
			];

			(* NOTE: It shouldn't actually matter what experiment function we pass down here...but the track record for going that route has been spotty *)
			{workingSamples, workingSamplesSimulation}=simulateSamplesResourcePacketsNew[
				experimentFunction,
				samples,
				expandedResolvedOptions,
				Transfer -> True,
				Cache -> cache,
				Simulation -> currentSimulation
			];

			(* Check if we need to re-expand working samples *)
			If[
				And[Not[validInputLengthQ],(numReplicates>1)],
				workingSamples=Flatten[(ConstantArray[#,numReplicates]&/@workingSamples),1];
			];

			(* Note that we are now doing a manual expansion of the option AliquotSampleLabel. Our options are not expanded with numReplicates because we collapsed "samples" above. However, workingSamples has been expected with replicates. Apply the same expansion to AliquotSampleLabel for our simulation *)
			expandedAliquotSampleLabelsWithReplicates=If[
				And[Not[validInputLengthQ],TrueQ[(numReplicates>1)],!SameLengthQ[Lookup[expandedResolvedOptions, AliquotSampleLabel,{}],workingSamples]],
				Flatten[(ConstantArray[#,numReplicates]&/@Lookup[expandedResolvedOptions, AliquotSampleLabel,{}]),1],
				Lookup[expandedResolvedOptions, AliquotSampleLabel,{}]
			];

			UpdateSimulation[
				UpdateSimulation[currentSimulation, workingSamplesSimulation],
				Simulation[
					Packets->{
						<|
							Object->myProtocol,
							Replace[WorkingSamples]->(Link/@workingSamples),
							Replace[WorkingContainers]->(Link/@DeleteDuplicates@Download[Download[workingSamples, Container, Simulation->workingSamplesSimulation], Object])
						|>
					},
					Labels->If[KeyExistsQ[expandedResolvedOptions, AliquotSampleLabel],
						Rule@@@Cases[
							Transpose[{expandedAliquotSampleLabelsWithReplicates, workingSamples}],
							{_String, ObjectP[]}
						],
						{}
					],
					LabelFields->If[KeyExistsQ[expandedResolvedOptions, AliquotSampleLabel],
						Rule@@@Cases[
							Transpose[{expandedAliquotSampleLabelsWithReplicates, Field[AliquotSamples[[#]]]&/@Range[Length[expandedAliquotSampleLabelsWithReplicates]]}],
							{_String, _Field}
						],
						{}
					]
				]
			]
		],
		(* if we are not doing sample prep but are a Protocol (and not Maintenance or Qualification), just fill in WorkingSamples and WorkingContainers from SamplesIn and ContainersIn of the protocol *)
		MatchQ[myProtocol, ObjectP[Object[Protocol]]],
		Module[{samples, containers},
			(* quieting this because for qualifications and maintenances, these fields don't exist*)
			{samples, containers} = Quiet[Download[myProtocol, {SamplesIn, ContainersIn}, Simulation -> currentSimulation], Download::FieldDoesntExist];
			UpdateSimulation[
				currentSimulation,
				Simulation[<|
					Object -> myProtocol,
					(* this removes any $Failed/Null from samples/containers *)
					Replace[WorkingSamples] -> Cases[(Link /@ ToList[samples]), LinkP[]],
					Replace[WorkingContainers] -> Cases[(Link /@ ToList[containers]), LinkP[]]
				|>]
			]
		],
		True,
		currentSimulation
	];

	(* Return the updated simulation. *)
	currentSimulation
];

SimulateResources[
	myProtocol:ObjectReferenceP[{Object[Protocol], Object[Maintenance], Object[Qualification]}],
	myOptions:OptionsPattern[SimulateResources]
]:=SimulateResources[myProtocol, Null, myOptions];




(* ::Subsubsection::Closed:: *)
(*getAdditionalIntegrations*)
Authors[getAdditionalIntegrations]={"dima"};
DefineOptions[getAdditionalIntegrations,
	Options:>{CacheOption}
];

(* for all cases where we are not using expected liquid handlers, return the resources the way they came in *)
getAdditionalIntegrations[instrument_,requestedInstruments:{_Resource...},protocolType_,positionsUsed_,tipsUsed_,time_,ops:OptionsPattern[]]:=requestedInstruments;

(* object overload *)
getAdditionalIntegrations[liquidHandlerObject:ObjectP[Object[Instrument,LiquidHandler]],requestedInstruments:{_Resource...},protocolType:RoboticCellPreparation,positionsUsed_,tipsUsed_,time_,ops:OptionsPattern[]]:=Module[
	{safeOps, cache, liquidHandlerModel},
	safeOps=SafeOptions[getAdditionalIntegrations,ToList[ops]];
	cache=Lookup[safeOps,Cache];
	(* our cache should have Model in the packet here so there should nto be a trip to the database *)
	liquidHandlerModel=Download[liquidHandlerObject,Model[Object],Cache->cache];
	getAdditionalIntegrations[liquidHandlerModel,requestedInstruments,protocolType,positionsUsed,tipsUsed,time,ops]
];

(* core overload - model *)
getAdditionalIntegrations[liquidHandlerModel:ObjectP[Model[Instrument,LiquidHandler]],requestedInstrumentResources:{_Resource...},protocolType:RoboticCellPreparation,positionsUsed_,tipsUsed_,time_,ops:OptionsPattern[]]:=Module[{requestedInstruments,requestedInstrumentModels,safeOps,cache,liquidHandlerIntegratedInstruments,notUsedInstruments},
	(* if we have not requested any instruments, return early *)
	If[And[
		MatchQ[requestedInstrumentResources,{}],
		MatchQ[positionsUsed,LessP[19]],
		MatchQ[tipsUsed,LessP[7]]
		],
		Return[requestedInstrumentResources,Module]
	];

	safeOps=SafeOptions[getAdditionalIntegrations,ToList[ops]];
	cache=Lookup[safeOps,Cache];
	requestedInstruments=If[MatchQ[requestedInstrumentResources,{}|Null],{},Lookup[requestedInstrumentResources[[All,1]],Instrument]];
	requestedInstrumentModels=Cases[Quiet[Download[requestedInstruments, Model[Object], Cache -> cache]], ObjectP[]];
	liquidHandlerIntegratedInstruments=Download[Lookup[fetchPacketFromCache[liquidHandlerModel,cache],IntegratedInstruments],Object];
	(* we exclude shaker, incubator and tilter from the list because they exist on deck and/or never reserved separately from the Hamilton instrument *)
	notUsedInstruments=DeleteCases[
		(* we have to use UnsortedComplement here because we want to keep duplicate entries in case we ever have multiple of the same instrument in the workcell *)
		UnsortedComplement[liquidHandlerIntegratedInstruments,Join[requestedInstruments,requestedInstrumentModels]],
		ObjectP[{Model[Instrument,PlateTilter],Model[Instrument,Shaker],Model[Instrument,HeatBlock]}]
	];

	(* return a list of resources for everything we need *)
	Join[
		requestedInstrumentResources,
		Map[
			Resource[
				Instrument->#,
				Name->CreateUUID[],
				Time->time,
				UnusedIntegratedInstrument->True
			]&,
			notUsedInstruments
		]
	]
];

Authors[workCellFromLiquidHandler]={"dima"};
DefineOptions[workCellFromLiquidHandler,
	Options:>{CacheOption}
];

workCellFromLiquidHandler[resource:(Null|{Null}),ops:OptionsPattern[]]:="not relevant";
workCellFromLiquidHandler[resource_Resource,ops:OptionsPattern[]]:=workCellFromLiquidHandler[Lookup[resource[[1]],Instrument]];
workCellFromLiquidHandler[{instrumentObject:ObjectP[Object[Instrument,LiquidHandler]]},ops:OptionsPattern]:=workCellFromLiquidHandler[instrumentObject,ops];
workCellFromLiquidHandler[instrumentObject:ObjectP[Object[Instrument,LiquidHandler]],ops:OptionsPattern]:=Module[
	{safeOps,cache,liquidHandlerModel},
	safeOps=SafeOptions[workCellFromLiquidHandler,ToList[ops]];
	cache=Lookup[safeOps,Cache];
	(* our cache should have Model in the packet here so there should nto be a trip to the database *)
	liquidHandlerModel=Download[instrumentObject,Model[Object],Cache->cache];
	workCellFromLiquidHandler[liquidHandlerModel,ops]
];
workCellFromLiquidHandler[{instrumentModel:ObjectP[Model[Instrument,LiquidHandler]]},ops:OptionsPattern[]]:=workCellFromLiquidHandler[instrumentModel,ops];
workCellFromLiquidHandler[instrumentModel:ObjectP[Model[Instrument,LiquidHandler]],ops:OptionsPattern[]]:=Module[{},
	Lookup[$InstrumentsToWorkCells,Download[instrumentModel,Object]]
];

(* ::Subsubsection::Closed:: *)
(*updateLabelFieldReferences*)
DefineOptions[updateLabelFieldReferences,Options:>{DebugOption}];

updateLabelFieldReferences[currentSimulation:Null,referenceField_Symbol,ops:OptionsPattern[]]:=Null;
updateLabelFieldReferences[currentSimulation:SimulationP,referenceField_Symbol,ops:OptionsPattern[]]:=Module[
	{currentLabelFields,linksPositions,linksContents,newLinkContents,newLabelFields,safeOps,debugQ},
	safeOps = SafeOptions[updateLabelFieldReferences,ToList[ops]];
	debugQ = Lookup[safeOps,Debug];

	currentLabelFields=Lookup[currentSimulation[[1]],LabelFields];
	If[debugQ,Echo[currentLabelFields,"currentLabelFields"]];

	(* if LabelFields is empty or we don't have any LabelField[] for Field[] entries - return early *)
	(* anything that is a LabelField[_String,_] can be looked up from LabelObjects field *)
	If[Or[
		Length[Experiment`Private`$PrimitiveFrameworkIndexedLabelCache]==0,
		Length[currentLabelFields]==0,
		!MemberQ[currentLabelFields[[All,2]],Field[_]]
	],
		Return[currentSimulation,Module]
	];

	(*
		Now for the complicated part - we are setting up for ReplaceRule below to update LabelFields
		from Field[ myField[[x]] ] to Field[ referenceField[[y]] [myField][[х]] ] where
		`referenceField` is a part of our input and y is the index of the unit operation that `myField[[x]]` is referencing

		The source of information for the `y` index here is the LabelFields that we construct in the primitive framework function
		as we are doing the simulation

		We DO NOT want to change any members of the LabelFields that are `label1 -> label2`
	*)

	(* pick positions and members of the LabelField in the simulation that we will want to try to update *)
	linksPositions = Flatten@Position[currentLabelFields, Verbatim[Rule][_, Field[_]], {1}];
	linksContents = Cases[currentLabelFields, Verbatim[Rule][_, Field[_]], {1}];

	(* form new versions of the field-referencing labels *)
	newLinkContents = Map[Module[
		{oldFieldReferenceText,newFieldReferenceText,newFieldReference,indexString,label,labelFieldLabel},
		label = #[[1]];
		labelFieldLabel = Lookup[Experiment`Private`$PrimitiveFrameworkIndexedLabelCache,label,Null];

		(* if we somehow don't have this label in the cache (we don't expect to hit this, but let's be defensive for a change),
		return the current value since he don't have a clue where it came from *)
		If[NullQ[labelFieldLabel],Return[#,Module]];

		(*NOTE: labelFieldLabel should contain identical fields to the LabelField in the simulation since we formed it using the info from the simulation we are using here*)

		(* deconstruct LabelField[myFieldReference,index] into field reference and index as strings *)
		oldFieldReferenceText = ToString[labelFieldLabel[[1]]];
		indexString = ToString[labelFieldLabel[[2]]];

		(* add the field name from the parent unit operation that leads to child unit operation level (`referenceField` from the input) and the index *)
		(* I do this with string manipulation because I didn't successfully work with Symbol/expressions without MM getting angry at me *)
		newFieldReferenceText = StringReplace[oldFieldReferenceText,
			"Field["~~firstLink:((LetterCharacter | DigitCharacter)..)~~"["~~rest__~~"]":>
				"Field["<>ToString[referenceField]<>"[["<>indexString<>"]]"<>"["<>firstLink<>"]["<>rest<>"]"
		];

		(* we have to do this separately from StringReplace above because otherwise MM will keep the result as StringExpression *)
		newFieldReference=ToExpression[newFieldReferenceText];

		(* return our new member of the LabelFields *)
		Rule[#[[1]],newFieldReference]
	]&,
		linksContents];

	(* if we are not updating the simulation - just return since we want to preserve NativeSimulationID to not blow out telescope with useless simulation update *)
	If[MatchQ[newLinkContents,linksContents],Return[currentSimulation,Module]];

	newLabelFields=ReplacePart[currentLabelFields,Rule @@@ Transpose@{linksPositions, newLinkContents}];

	If[debugQ,Echo[newLabelFields,"newLabelFields"]];

	UpdateSimulation[currentSimulation,Simulation[LabelFields->newLabelFields]]
];

(* ::Subsubsection::Closed:: *)
(*addLabelFields*)
(* Replace any labels with their label fields *)

addLabelFields[primitiveOptions_,primitiveOptionDefinitions_,labelFieldLookup_]:=KeyValueMap[
	Function[{option, value},
		Module[{optionDefinition},
			(* Lookup information about this option. *)
			optionDefinition=FirstCase[primitiveOptionDefinitions,KeyValuePattern["OptionSymbol"->option],Null];

			(* Does this option allow for PreparedSample or PreparedContainer? *)
			Which[
				(* We don't know about this option. *)
				MatchQ[optionDefinition, Null],
				Nothing,

				(* Nothing to replace. *)
				(* NOTE: We have to convert any associations (widgets automatically evaluate into associations) because *)
				(* Cases will only look inside of lists, not associations. *)
				Length[Cases[Lookup[optionDefinition, "Widget"]/.{w_Widget :> Normal[w[[1]]]}, (PreparedContainer->True)|(PreparedSample->True), Infinity]]==0,
				option->value,

				(* We may potentially have some labels. *)
				True,
				Module[{matchedWidgetInformation,objectWidgetsWithLabels,labelsInOption,replacementRules,newValue},

					(* Match the value of our option to the widget that we have. *)
					(* NOTE: This is the same function that we use in the command builder to match values to widgets. *)
					matchedWidgetInformation=AppHelpers`Private`matchValueToWidget[value,optionDefinition];

					(* Look for matched object widgets that have labels. *)
					(* NOTE: A little wonky here, all of the Data fields from the AppHelpers function gets returned as a string, so we need *)
					(* to separate legit strings from objects that were turned into strings. *)
					objectWidgetsWithLabels=Cases[matchedWidgetInformation, KeyValuePattern[{"Type" -> "Object", "Data" -> _?(!StringStartsQ[#, "Object["] && !StringStartsQ[#, "Model["]&)}], Infinity];

					(* This will give us our labels. *)
					labelsInOption=(StringReplace[#,"\""->""]&)/@Lookup[objectWidgetsWithLabels, "Data", {}];

					(* Replace any other labels that we have with their values from our simulation. *)
					replacementRules = Map[
						(#1 -> Lookup[labelFieldLookup, #1]&),
						Intersection[labelsInOption, labelFieldLookup[[All,1]]]
						];
					newValue = ReplaceAll[value, replacementRules];

					option-> newValue
				]
			]
		]
	],
	Association@primitiveOptions
];
(* ::Subsubsection::Closed:: *)
(*joinClauses*)
DefineOptions[
	joinClauses,
	Options:>{
		{ConjunctionWord -> "and", _String, "The coordination word used to connect the last string of the input and default to \"and\". Other common words are \"or\", \"but\"."},
		{CaseAdjustment -> False, BooleanP, "Indicates whether the combined string should have case adjusted in Title Case style with the first letter capitalized."},
		{DuplicatesRemoval -> True, BooleanP, "Indicates whether any duplicates in the clauses should be removed."}
	}
];

(* joinClauses is a helper function that takes a list of parts(converted to string), then 1)delete duplicates of the strings *)
(* 2)Depends on how many parts, either add "and" or ", and" to connect the parts, and change later parts to lower case if CaseAdjustment is True, *)
(* 3)StringJoin all parts together as a single String starting with a capital letter if CaseAdjustment is True. *)
(* This helper is used for Experiment functions' error message: e.g. we have 3 failing samples 1 and 4 fail for reason A and sample 2 fails for reason C. *)
(* the message is: reasons A And C at the beginning of the error message (no duplicates). sample 1 has a footprint of blah and cover of blah, sample 4..., *)
(* and sample 2.. (no index). Please set option Cover to blah. The error message is calling joinClauses to connect elements in the error lists. *)
joinClauses[nonStringInputs:{___, Except[_String], ___}, ops: OptionsPattern[joinClauses]] := joinClauses[ToString/@nonStringInputs, ops];
joinClauses[inputClauses: {_String..}, ops: OptionsPattern[joinClauses]] := Module[
	{uniqueClauses, numberOfClauses, correctedCasedClauses, conjunction, caseAdjustment, duplicatesRemoval},

	(* Check options *)
	{conjunction, caseAdjustment, duplicatesRemoval} = Lookup[SafeOptions[joinClauses, ToList[ops]], {ConjunctionWord, CaseAdjustment, DuplicatesRemoval}];

	(* Remove duplicates from input *)
	uniqueClauses = If[TrueQ[duplicatesRemoval],
		DeleteDuplicates[inputClauses],
		inputClauses
	];
	numberOfClauses = Length[uniqueClauses];

	(* Adjust cases if CaseAdjustment is True *)
	(* Covert the first letter of the first clause to upper case if they are not Object/Model *)
	(* Covert the first letter of the rest of clauses to lower case if they are not part of a Object/Model *)
	correctedCasedClauses = Which[
		MatchQ[caseAdjustment, False] && EqualQ[numberOfClauses, 1],
			uniqueClauses[[1]],
		MatchQ[caseAdjustment, False],
			uniqueClauses,
		EqualQ[numberOfClauses, 1],
			StringJoin[ToUpperCase@StringTake[uniqueClauses[[1]], 1], StringDrop[uniqueClauses[[1]], 1]],
		True,
			Module[{firstClause, restClauses},
				firstClause = First[uniqueClauses];
				restClauses = Rest[uniqueClauses];
				Join[
					{StringJoin[ToUpperCase@StringTake[firstClause, 1], StringDrop[firstClause, 1]]},
					Map[
						If[StringMatchQ[#, "Model["|"Object[" ~~__],
							#,
							StringJoin[ToLowerCase@StringTake[#, 1], StringDrop[#, 1]]
						]&,
						restClauses
					]
				]
			]
	];

	(* Return the joined string connecting with ConjunctionWord *)
	Which[
		EqualQ[numberOfClauses, 1],
			correctedCasedClauses,
		(* Insert and between 2 clauses. *)
		EqualQ[numberOfClauses, 2],
			StringRiffle[correctedCasedClauses, StringJoin[" " <> conjunction <> " "]],
		(* Insert comma between most of clauses, add add to the last clause. *)
		True,
			StringJoin[
				StringRiffle[Most@correctedCasedClauses, ", "],
				StringJoin[", " <> conjunction <> " "],
				Last@correctedCasedClauses
			]
	]
];

(* ::Subsubsection::Closed:: *)
(*samplesForMessages*)
DefineOptions[
	samplesForMessages,
	Options :> {
		SimulationOption,
		CacheOption,
		{CollapseForDisplay -> Automatic, Automatic | BooleanP, "Whether to display only one example instead of all samples for shorter display."},
		{SkipNameConversion -> Automatic, Automatic | BooleanP, "Whether to lookup the name of input samples."},
		{SkippedObjectPronouns -> Automatic, Automatic | {_String, _String}, "What pronoun to replace objects with if we are not converting to name."}
	}
];

(* samplesForMessages is a helper function that takes a list of Object[Sample]s in 2 cases                                      *)
(* a)if SkipNameConversion is True, check how many non-duplicated samples, and return either \"the sample\" or \"all samples\"  *)
(* b)if SkipNameConversion is False,                                                                                            *)
(*     1)Delete duplicates of the samples and lookup their names from cache/simulation or download from constellation           *)
(*     2)Depends on how many samples and the option CollapseForDisplay                                                          *)
(*      2a) if CollapseForDisplay is True, return <unique number of samples> of the samples (e.g., Object[Sample, name here])   *)
(*      2b) either add "and" or ", and" to connect the sample lists                                                             *)

(* Two inputs overload *)
samplesForMessages[inputSamples: {ObjectP[]..}, allSamples: {ObjectP[]..}, ops: OptionsPattern[samplesForMessages]] := Module[
	{
		skipNameConversion, skippedObjectPronouns, collapseForDisplay, cache, simulation, resolvedSkipNameConversion,
		resolvedCollapseForDisplay
	},

	(* Check option *)
	{
		skipNameConversion,
		skippedObjectPronouns,
		collapseForDisplay,
		cache,
		simulation
	} = Lookup[
		SafeOptions[
			samplesForMessages, ToList[ops]
		],
		{
			SkipNameConversion,
			SkippedObjectPronouns,
			CollapseForDisplay,
			Cache,
			Simulation
		}
	];

	(* Resolve SkipNameConversion based on whether the two inputs match *)
	(* Note:either of them can consist of duplicates, but should have same unique samples *)
	resolvedSkipNameConversion = If[MatchQ[skipNameConversion, BooleanP],
		skipNameConversion,
		And[
			MatchQ[Cases[inputSamples, Except[ObjectP[allSamples]]], {}],
			MatchQ[Cases[allSamples, Except[ObjectP[inputSamples]]], {}]
		]
	];
	(* Resolve CollapseForDisplay based on whether the number of unique inputs is beyond $MaxNumberOfSamplesToDisplay *)
	(* Note: if SkipNameConversion is True, there is no need to collapse for display *)
	resolvedCollapseForDisplay = If[MatchQ[collapseForDisplay, BooleanP],
		collapseForDisplay,
		And[
			!TrueQ[resolvedSkipNameConversion],
			GreaterQ[Length[DeleteDuplicates@inputSamples], $MaxNumberOfSamplesToDisplay]
		]
	];

	(* Convert to main overload *)
	samplesForMessages[
		inputSamples,
		SkipNameConversion -> resolvedSkipNameConversion,
		CollapseForDisplay -> resolvedCollapseForDisplay,
		SkippedObjectPronouns -> skippedObjectPronouns,
		Cache -> cache,
		Simulation -> simulation
	]
];
(* Main overload *)
samplesForMessages[inputSamples: {ObjectP[]..}, ops: OptionsPattern[samplesForMessages]] := Module[
	{
		skipNameConversion, skippedObjectPronouns, collapseForDisplay, cache, simulation, uniqueSamples, resolvedSkipNameConversion,
		resolvedSkippedNamedPronouns, resolvedCollapseForDisplay, subjectType
	},

	(* Check option *)
	{
		skipNameConversion,
		skippedObjectPronouns,
		collapseForDisplay,
		cache,
		simulation
	} = Lookup[
		SafeOptions[
			samplesForMessages, ToList[ops]
		],
		{
			SkipNameConversion,
			SkippedObjectPronouns,
			CollapseForDisplay,
			Cache,
			Simulation
		}
	];

	(* Check how many samples *)
	uniqueSamples = DeleteDuplicates[inputSamples];

	(* Resolve SkipNameConversion based on whether the two inputs match *)
	resolvedSkipNameConversion = If[MatchQ[skipNameConversion, Automatic],
		False,
		skipNameConversion
	];
	resolvedSkippedNamedPronouns = If[MatchQ[skippedObjectPronouns, Automatic],
		{"the", "all"},
		skippedObjectPronouns
	];
	(* Resolve CollapseForDisplay based on whether the number of unique inputs is beyond $MaxNumberOfSamplesToDisplay *)
	(* Note: if SkipNameConversion is True, there is no need to collapse for display *)
	resolvedCollapseForDisplay = If[MatchQ[collapseForDisplay, BooleanP],
		collapseForDisplay,
		And[
			!TrueQ[resolvedSkipNameConversion],
			GreaterQ[Length[uniqueSamples], $MaxNumberOfSamplesToDisplay]
		]
	];
	(* Check the input objects' type (sample, container, item etc) *)
	subjectType = Which[
		MatchQ[inputSamples, {ObjectP[Object[Sample]]..}], " sample",
		MatchQ[inputSamples, {ObjectP[Object[Container]]..}], " container",
		MatchQ[inputSamples, {ObjectP[Object[Item]]..}], " item",
		MatchQ[inputSamples, {ObjectP[Object[Instrument]]..}], " instrument",
		True, " input"
	];

	(* Join objects' name if SkipNameConversion is False, or refer the samples as the sample/all samples *)
	Which[
		TrueQ[resolvedSkipNameConversion],
			pluralize[
				uniqueSamples,
				First[resolvedSkippedNamedPronouns] <> subjectType,
				Last[resolvedSkippedNamedPronouns] <> subjectType <> "s"
			],
		TrueQ[resolvedCollapseForDisplay] && Length[uniqueSamples] > 1,
			StringJoin[
				(* We spell the number out because it might often be used to start a sentence. *)
				(* MM starts to throw non-sense when the number goes to 4 digits *)
				If[Length[uniqueSamples] < 1000,
					IntegerName[Length[uniqueSamples], "English"],
					ToString[Length[uniqueSamples]]
				],
				" of the samples (including ", ObjectToString[uniqueSamples[[1]], Cache -> cache, Simulation -> simulation], ")"],
		True,
			(* Note: although ObjectToString can take a list of string, it converts them to a string with {} which is not what we want *)
			(* So we have to feed individual sample to ObjectToString in a map *)
			joinClauses[Map[ObjectToString[#, Cache -> cache, Simulation -> simulation]&, uniqueSamples], CaseAdjustment -> False]
	]
];
(* ::Subsubsection::Closed:: *)
(*pluralize*)

(* Shortcuts overloads *)
hasOrHave[inputSamples: {ObjectP[]..}] := pluralize[inputSamples, "have"];
isOrAre[inputSamples: {ObjectP[]..}] := pluralize[inputSamples, "be"];

(* Overload for verb takes a list of Object[Sample]s and adjust verb based on hard-coded list accordingly *)
pluralize[inputSamples: {ObjectP[]..}, verb: _String] := Module[
	{verbFormLookup, singularForm, pluralForm},

	(* Common verbs used in error messages *)
	verbFormLookup = <|
		"be" -> {"is", "are"},
		"have" -> {"has", "have"},
		"require" -> {"requires", "require"},
		"reside" -> {"resides", "reside"}
	|>;

	(* Check which verb it is in the lookup *)
	{singularForm, pluralForm} = Which[
		MemberQ[Keys[verbFormLookup], verb],
			(* If the verb input is one of the keys in the lookup, check the value *)
			Lookup[verbFormLookup, verb],
		MemberQ[Flatten@Values[verbFormLookup], verb],
			Last[Select[verbFormLookup, MemberQ[#, verb]&]],
		True,
			(* If we cannot find the verb in the lookup, just use the input as it is *)
			{verb, verb}
	];

	(* Call main overload *)
	pluralize[inputSamples, singularForm, pluralForm]
];
(* Main Overload *)
pluralize[inputSamples: {ObjectP[]..}, singularForm: _String, pluralForm: _String] := Module[{},

	(* Return either singular or plural form based on the length of input samples *)
	If[Length[inputSamples] > 1,
		pluralForm,
		singularForm
	]
];