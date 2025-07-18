(* ::Subsubsection:: *)
(* Setup Global Simulation *)

(* NOTE: This is able to track multiple simulations from multiple notebooks. *)
clearSimulations[]:=(
	Unset[$CurrentSimulationNotebook]; (* ObjectReferenceP[Object[Notebook]] *)
	Unset[$CurrentSimulation]; (* SimulationP *)
	Set[$AllSimulations, Association[]]; (* <|(ObjectReferenceP[Object[Notebook]] -> SimulationP)..|> *)
	Set[$Simulation, False]; (* BooleanP *)
);

OnLoad[clearSimulations[]];

(* ::Subsubsection:: *)
(* Simulation *)

SimulationP=Simulation[KeyValuePattern[{
  Packets -> _List,
  Labels -> _List,
  LabelFields -> _List,
  Updated -> BooleanP,
  SimulatedObjects -> _List,
  NativeSimulationID -> Alternatives[_String, None]
}]];

(* NOTE: This is stolen from the cloud file images. *)
simulationSymbol[]:=simulationSymbol[]=Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "File_mathematica.png"}], "PNG"];

installSimulationMakeBoxes[]:=Simulation/:MakeBoxes[spec:(Simulation[KeyValuePattern[{Packets -> _List, Labels -> _List, LabelFields -> _List}]]), StandardForm]:=BoxForm`ArrangeSummaryBox[Simulation, spec,
	simulationSymbol[],
	{
		"Number of Packets" -> Length[Lookup[spec[[1]], Packets]],
		"Number of Labels" -> Length[Lookup[spec[[1]], Labels]]
	},
	{},
	StandardForm
];

OnLoad[installSimulationMakeBoxes[]];

Error::InvalidSimulation="The only keys allowed for the Simulation[...] function are Packets, Labels, LabelFields. The Packets key must match {PacketP[]..} and the Labels key must match {(_String->ObjectP[])..}. Please check your input in order to generate a valid Simulation.";

(* Overload for an empty simulation. *)
Simulation[]:=Simulation[<|
	Packets -> {},
	Labels -> {},
	LabelFields -> {},
	SimulatedObjects -> {},
	Updated -> True,
	NativeSimulationID -> None
|>];

Simulation[rules:(ListableP[_Rule] | __Rule)]:=Module[{listedRules},
	listedRules=ToList[rules];

	If[Or[
		!MatchQ[Lookup[listedRules, Packets, {}], {PacketP[]..} | {}],
		!MatchQ[Lookup[listedRules, Labels, {}], {(_String -> ObjectP[])..} | {}],
		!MatchQ[Lookup[listedRules, LabelFields, {}], {(_String -> (_Symbol | _Field | _String))..} | {}],
		!MatchQ[Lookup[listedRules, SimulatedObjects, {}], {ObjectP[]..} | {}],
        !MatchQ[Lookup[listedRules, Updated,False],_?BooleanQ],
        !MatchQ[Lookup[listedRules, NativeSimulationID,None],_String | None],
		MemberQ[listedRules[[All, 1]], Except[Packets | Labels | LabelFields | SimulatedObjects | Updated | NativeSimulationID]]
	],
		Message[Error::InvalidSimulation];
	];

	Simulation[<|
		Packets -> Lookup[listedRules, Packets, {}],
		Labels -> Lookup[listedRules, Labels, {}],
		LabelFields -> Lookup[listedRules, LabelFields, {}],
		SimulatedObjects -> Lookup[listedRules, SimulatedObjects, {}],
		Updated -> Lookup[listedRules, Updated, False],
		NativeSimulationID -> Lookup[listedRules, NativeSimulationID, None]
	|>]
];

Simulation[packets:ListableP[(PacketP[] | Null)]]:=Simulation[<|
	Packets -> Cases[ToList[packets], Except[Null]],
	Labels -> {},
	LabelFields -> {},
	SimulatedObjects -> {},
	Updated -> False,
	NativeSimulationID -> None
|>];

Simulation[{}]:=Simulation[<|
	Packets -> {},
	Labels -> {},
	LabelFields -> {},
	SimulatedObjects -> {},
	Updated -> True,
	NativeSimulationID -> None
|>];

(* ::Subsubsection:: *)
(* LookupObjectLabel *)

LookupObjectLabel[mySimulation:SimulationP, myObject:ObjectP[]]:=Lookup[Reverse /@ Lookup[mySimulation[[1]], Labels], Download[myObject, Object], Null];
LookupObjectLabel[___]:=Null;

(* ::Subsubsection:: *)
(* CreateUniqueLabel *)

(* NOTE: This is so that we can have ExperimentSamplePreparation calls within ExperimentSamplePreparation. *)
$UniqueLabelLookupStack={};

$UniqueLabelLookup=<||>;

StartUniqueLabelsSession[]:=Module[{},
	If[!MatchQ[$UniqueLabelLookup, <||>],
		PrependTo[$UniqueLabelLookupStack, $UniqueLabelLookup];
	];

	$UniqueLabelLookup=<||>;
];

EndUniqueLabelsSession[]:=If[Length[$UniqueLabelLookupStack] > 0,
    (
      $UniqueLabelLookup=First[$UniqueLabelLookupStack];
      $UniqueLabelLookupStack=Rest[$UniqueLabelLookupStack];
    ),
    $UniqueLabelLookup=<||>;
];

DefineOptions[
  CreateUniqueLabel,
  Options :> {
    {Simulation -> Null, Null|SimulationP, "The current simulation that includes all of the labels that have been currently assigned."},
    {UserSpecifiedLabels -> {}, {_String...}, "The user specified labels to this experiment function that CreateUniqueLabel should make sure not to conflict with."}
  }
];

CreateUniqueLabel[myLabelPrefix_String, myOptions:OptionsPattern[]]:=Module[
  {simulation, userSpecifiedLabels, currentLabels, currentCounter, potentialLabel},

  (* Get our Simulation and UserSpecifiedLabels options. *)
  simulation=Lookup[ToList[myOptions], Simulation, Null];
  userSpecifiedLabels=Lookup[ToList[myOptions], UserSpecifiedLabels, {}];

  (* Get the current labels in our simulation and UserSpecifiedLabels option. *)
  currentLabels=Flatten[{
    If[MatchQ[simulation, _Simulation],
      Lookup[simulation[[1]], Labels][[All,1]],
      {}
    ],
    userSpecifiedLabels
  }];

  (* Keep looping until we find a new label to use. The user could unintentionally have used the same *)
  (* prefix that our function is trying to use. *)
  While[True,
    currentCounter=If[!KeyExistsQ[$UniqueLabelLookup, myLabelPrefix],
      (
        $UniqueLabelLookup[myLabelPrefix]=1;
        1
      ),
      $UniqueLabelLookup[myLabelPrefix]
    ];

    $UniqueLabelLookup[myLabelPrefix]=currentCounter + 1;

    potentialLabel=myLabelPrefix<>" "<>ToString[currentCounter];

    If[!MemberQ[currentLabels, potentialLabel],
      Break[];
    ];
  ];

  potentialLabel
];


(* ::Subsection::Closed:: *)
(*SimulateCreateID*)

(* Simulate the creation of an id. *)


(* Authors definition for SimulateCreateID *)
Authors[SimulateCreateID]:={"lige.tonggu", "tim.pierpont"};

SimulateCreateID[]:=Module[{dictionary},
	(* Create our dictionary of characters to choose from. *)
	(* We can choose from 0-9, A-Z, and a-z. *)
	dictionary=Join[CharacterRange["0", "9"], CharacterRange["A", "Z"], CharacterRange["a", "z"]];

	(* Randomly choose 12 of these characters and join them together as a string. *)
    (* importantly, putting Simulated after id: will let sciops et al. more readily tell that this is a fake simmulated id *)
	"id:Simulated"<>StringJoin[RandomChoice[dictionary, 12]]
];

(* Overload that takes in a list of types. *)
SimulateCreateID[myTypes:{(TypeP[]|Null)...}]:=SimulateCreateID /@ myTypes;
SimulateCreateID[Null]:=Null;


(* Main function that, for a Type, will simulate the creation of a database ID. *)
(* We need this because the actual CreateID function will talk to the database and create a new unique ID. *)
(* AKA: It inserts a new ID for the type and hashes that to get the 12 digit hashid ID. *)
SimulateCreateID[myType:TypeP[]]:=Module[{simulatedID},
	(* Create a simulated ID. *)
	simulatedID=SimulateCreateID[];

	(* Insert the ID into the type and return the new object. *)
	myType /. (head:(Object | Model))[contents___] :> head[contents, simulatedID]
];


(* ::Subsubsection:: *)
(* EnterSimulation *)
EnterSimulation[myNotebook:ObjectP[Object[Notebook]]]:=Module[{existingSimulation},
	(* Short circuit if the simulation notebook we're told to enter is already our current simulation notebook. *)
	If[MatchQ[$CurrentSimulationNotebook, ObjectP[myNotebook]],
		Return[True];
	];

	(* Otherwise, we have to enter this simulation. *)

	(* If we have a previous simulation already going, save our progress to $AllSimulations. *)
	If[MatchQ[$Simulation, True],
		$AllSimulations[Download[$CurrentSimulationNotebook, Object]]=$CurrentSimulation;
	];

	(* Do we already have a simulation for the notebook we were told to switch to? *)
	existingSimulation=If[KeyExistsQ[$AllSimulations, Download[myNotebook, Object]],
		Lookup[$AllSimulations, Download[myNotebook, Object]],
    (* Create fresh new simulation *)
    Quiet[
      With[{id=CreateNativeSimulation[]},
        If[MatchQ[id,_String],
          Simulation[NativeSimulationID->id],
          Simulation[]
        ]
      ]
    ]
	];

	(* Set the $Simulation, $CurrentSimulation, and $CurrentSimulationNotebook. *)
	$Simulation=True;
	$CurrentSimulationNotebook=Download[myNotebook, Object];
	$CurrentSimulation=existingSimulation;

	(* Success. *)
	True
];

(* Simulation without a notebook for internal testing use. *)
(* Usage in Command Center should ALWAYS be tied to a notebook. *)
EnterSimulation[]:=Module[{},
	(* Set the $Simulation, $CurrentSimulation, and $CurrentSimulationNotebook. *)
	$Simulation=True;
	$CurrentSimulationNotebook=Null;
  $CurrentSimulation=Quiet[With[{id=CreateNativeSimulation[]},
    If[MatchQ[id,_String],
      Simulation[NativeSimulationID->id],
      Simulation[]
    ]
  ]];

	(* Success. *)
	True
];

(* ::Subsubsection:: *)
(* ExitSimulation *)
ExitSimulation[myNotebook:ObjectP[Object[Notebook]]]:=Module[{},
	(* KeyDrop from $AllSimulations. *)
	KeyDropFrom[$AllSimulation, Download[myNotebook, Object]];

	(* Set the $Simulation, $CurrentSimulation, and $CurrentSimulationNotebook. *)
	$Simulation=False;
	Unset[$CurrentSimulationNotebook];
  If[
    And[
      MatchQ[$CurrentSimulation,SimulationP],
      MatchQ[Lookup[First[$CurrentSimulation],NativeSimulationID,None],_String]
    ],
    Quiet[DeleteNativeSimulation[Lookup[First[$CurrentSimulation],NativeSimulationID]]]
  ];
  Unset[$CurrentSimulation];

	(* Success. *)
	True
];

(* Simulation without a notebook for internal testing use. *)
(* Usage in Command Center should ALWAYS be tied to a notebook. *)
ExitSimulation[]:=Module[{},
	(* Set the $Simulation, $CurrentSimulation, and $CurrentSimulationNotebook. *)
	$Simulation=False;
	Unset[$CurrentSimulationNotebook];
  If[
    And[
      MatchQ[$CurrentSimulation,SimulationP],
      MatchQ[Lookup[First[$CurrentSimulation],NativeSimulationID,None],_String]
    ],
    Quiet[DeleteNativeSimulation[Lookup[First[$CurrentSimulation],NativeSimulationID]]]
  ];
  Unset[$CurrentSimulation];

	(* Success. *)
	True
];

(* Helper function to create a "default packet" for a given type. *)
defaultPacket[packetType_]:=defaultPacket[packetType]=Association@KeyValueMap[
  Function[{field, fieldDefinition},
    Which[
      (* Or if the field is a special field, don't add anything. This is because the packet we're merging this with is *)
      (* guarenteed to have these fields already. *)
      MatchQ[field, Type|Object|ID|Name],
      Nothing,
      (* Field is a single. *)
      MatchQ[Lookup[fieldDefinition, Format], Single],
      field->Null,
      (* Field is a multiple. *)
      MatchQ[Lookup[fieldDefinition, Format], Multiple],
      field-> {},
      (* Catch all. *)
      True,
      Nothing
    ]
  ],
  Association@Lookup[LookupTypeDefinition[packetType], Fields]
];

(* ::Subsubsection:: *)
(* UpdateSimulation *)


(* helper function that evaluates an association.  The problem here is that if you have a packet like the following, the RemoveLinkID call will just remain in the Association and mess up the simulation:*)
(* <|Object -> Object[Protocol, ImageSample, "id:7X104v1dbr5p"], Replace[BatchedImagingParameters] -> {<|Imager -> RemoveLinkID[Link[Object[Instrument, SampleImager, "id:R8e1Pjp4DD7p"], "llkjlkjlkj"]], ImageContainer -> False, ImagingDirection -> {Side}, IlluminationDirection -> {Side}, SecondaryRack -> Null, ImageFilePrefix -> "mnk9j_okaz0al_sampleimager", BatchNumber -> 1, Wells -> Null, PlateMethodFileName -> Null, RunTime -> Null, FieldOfView -> Null, ImagingDistance -> Quantity[38.5, "Centimeters"], Pedestals -> SmallAndLarge, ExposureTime -> Quantity[33, "Milliseconds"], FocalLength -> Quantity[55, "Millimeters"]|>}|> *)
(* if we evalaute all the association values inside here, then we make sure the RemoveLinkID (or whatever function operations) disappear *)
(* note that Upload already does this de-facto, so this causes us to actually behave like Upload *)
evaluateAssociations[packet_Association]:=With[{packetNoComputables = removeComputables[packet]},

  Association[KeyValueMap[
    Function[{field, value},
      field -> Which[
        MatchQ[value, _Association], AssociationThread[Keys[value], Values[value]],
        MatchQ[value, {__Association}], AssociationThread[Keys[#], Values[#]]& /@ value,
        True, value
      ]
    ],
    packetNoComputables
  ]]

];

UpdateSimulation[currentSimulation_Simulation, newSimulation_Simulation]:=Module[
  {cloneSimulationID, currentSimulationNoChangePackets, simulationChangePackets, packetsWithObjectKey,
    packetsWithNoObjectsWithName, changeAndBacklinkPackets, newSimulationSimulatedObjects,
    simulatedObjectPacketsWithFullFields, currentSimulationWithNewSimulatedObjects, currentObjectPackets,
    currentObjectPacketsLookup, objectsExistInDatabaseDatabaseMemberQ, currentSimulationFieldsPerObject, combinedLabels,
    combinedLabelFields, currentSimulatedObjects, inputSimulationObjects, knownSimulatedPackets, knownRealPackets,
    unknownChangeAndBacklinkPackets, unknownObjectsExistInDatabaseDatabaseMemberQ, objectsExistInDatabaseReplaceRules,
    deFactoRealPattern},

  (* NOTE: This is a little dangerous because we are basically mocking how the server is going to handle the upload of *)
  (* change packets. We need to make sure that our client side mock mirrors what the server will do as closely as possible. *)

  (* NOTE: We may receive multiple change packets for the same object and field. We need to make sure that the change packets *)
  (* are processed in the order that they're given to us. *)

  (* From our new simulation, figure out if we have any "change packet syntax". The change packet wrapper syntax includes: *)
  (* - Append[_Symbol] - fetch the value of the multiple field and append to it *)
  (* - Prepend[_Symbol] - fetch the value of the multiple field and prepend to it *)
  (* - Replace[_Symbol] - just overwrite the multiple field, don't care about the current value *)
  (* - Erase[_Symbol] - there are multiple things Erase can do:  *)
  (*  "A row can be deleted from a Multiple field:",
			Download[Upload[<|Object->Object[Container, Rack, "Test Erase IndexedMultiple"],Erase[Contents]->2|>],Contents[[All, 1]]] => {"A1", "A3"},

		  "A row can be deleted from a named multiple field:",
      Download[Upload[<|Object->Object[Example, Data, "Test Erase NamedMultiple"],Erase[NamedMultiple]->2|>],NamedMultiple[[All, 1]]]] => {1. Nanometer, 3. Nanometer},


		  "Multiple rows can be deleted from a Multiple field:"
			Download[Upload[<|Object->Object[Container, Rack, "Test Erase IndexedMultiple"],Erase[Contents]->{{1},{3}}|>],Contents[[All,1]]] => {"A2"},


		  "Multiple rows can be deleted from a named multiple field:"
			Download[Upload[<|Object->Object[Example, Data, "Test Erase NamedMultiple"],Erase[NamedMultiple]->{{1},{3}}|>],NamedMultiple[[All, 1]]] => {2. Nanometer},


		  "Delete a column from all rows in an IndexedMultiple field:"
			Download[Upload[<|Object->Object[Container, Rack, "Test Erase IndexedMultiple"],Erase[Contents]->{All, 1}|>],Contents[[All, 1]]] => {Null, Null, Null},


		  "Delete a column from all rows in a named multiple field:"
			Download[Upload[<|Object->Object[Example,Data,"Test Erase NamedMultiple"],Erase[NamedMultiple] -> {All, SingleLink}|>],NamedMultiple] => {
				<|UnitColumn -> 1. Nanometer, SingleLink -> Null|>,
				<|UnitColumn -> 2. Nanometer, SingleLink -> Null|>,
				<|UnitColumn -> 3. Nanometer, SingleLink -> Null|>
			}

		  "Delete from an IndexedMultiple a specific row and column:"
			Download[Upload[<|Object->Object[Container,Rack,"Test Erase IndexedMultiple"],Erase[Contents]->{2, 1}|>],Contents[[All, 1]]] => {"A1", Null, "A3"},
  *)
  (* - EraseCases[_Symbol] - This is as simple as doing a Cases[multipleFieldValue, Except[rightSideOfEraseCases] *)
  (* - Transfer[_Symbol] - This is special syntax that only applies to the Notebook field and is basically the same as a regular replace *)

  (* For the Append[...], Prepend[...], Erase[...], and EraseCases[...] changes, we need to call Download[...] to see what the current value of the *)
  (* field is so that we know how to modify it. If we're doing a Replace[...] or Transfer[...] we don't call Download[...] at all *)
  (* because we don't care what the previous value was since we're going to overwrite it. *)

  (* Short circuit and return if the  *)
  (* Pull out our new change packets. *)
  (* need to call evaluateAssociations on all the packets so that we don't accidentally have erroneous stuff in named field associations because they're not evaluated (think how <|a -> 4|> /. {x_?EvenQ :> x+x} will give you <|a -> 4 + 4|>, NOT <|a -> 8|> which you would actually want *)
  simulationChangePackets=evaluateAssociations /@ Lookup[newSimulation[[1]], Packets];

  (* 0) Make sure that our current simulation is free of change packets and fully updated with all fields for each packet. If it is not, merge it in with a blank simulation. *)
  currentSimulationNoChangePackets=If[MatchQ[Lookup[currentSimulation[[1]], Updated],False],
    (* TODO This will create a whole new Simulation in Telescope! Can we get rid of this? *)
    UpdateSimulation[Simulation[Updated->True,NativeSimulationID->Lookup[currentSimulation[[1]],NativeSimulationID]],currentSimulation],
    currentSimulation
  ];

  (* Create a clone of the currentSimulation in Telescope. *)
  cloneSimulationID=
      Quiet[Check[
        If[MatchQ[Lookup[currentSimulationNoChangePackets[[1]],NativeSimulationID],_String],
          (* If there is a NativeSimulation ID clone the simulation to a new id *)
          CloneNativeSimulation[Lookup[currentSimulationNoChangePackets[[1]],NativeSimulationID]],
          (* If not create a new simulation *)
          id=CreateNativeSimulation[];
          UpdateNativeSimulation[id,Lookup[currentSimulationNoChangePackets[[1]],Packets]];
          id
        ],
        None
      ]];

  (* 1) Make sure that all of our change packets have the Object key. This is to catch the case of change packets that are creating *)
  (* new objects by just specifying the Type key. *)
  packetsWithObjectKey=Map[
    Function[changePacket,
      If[KeyExistsQ[changePacket, Type] && !KeyExistsQ[changePacket, Object],
        Append[changePacket, Object->SimulateCreateID[Lookup[changePacket, Type]]],
        changePacket
      ]
    ],
    simulationChangePackets
  ];

  (* 2) Convert all objects in the form of Object[___, Name] to Object[___, ID]. *)
  packetsWithNoObjectsWithName=Module[
    {uniqueObjectsWithName, allSimulations, simulationObjectsWithNameToID, remainingObjectsWithName, downloadObjectsWithNameToID,
      allObjectsWithNameToID},

    (* Get all object references that are using a name in our new simulation. *)
    uniqueObjectsWithName=DeleteDuplicates[
      Cases[simulationChangePackets, (Object|Model)[___, _String?(!StringMatchQ[#1,"id:"~~__]&)], Infinity]
    ];

    (* Combine our current local simulation and global simulation (if applicable). *)
    allSimulations=If[MatchQ[$Simulation, True],
      Flatten[{Lookup[currentSimulationNoChangePackets[[1]], Packets], Lookup[$CurrentSimulation[[1]], Packets]}],
      Lookup[currentSimulationNoChangePackets[[1]], Packets]
    ];

    (* Try to get the ID of our object with name from the simulations first. *)
    simulationObjectsWithNameToID=Map[
      Function[objectWithName,
        Module[{objectWithNamePacket},
          (* Try to find the packet in our simulation packets. *)
          objectWithNamePacket=FirstCase[
            allSimulations,
            KeyValuePattern[{Name->Last[objectWithName], Object->Append[Most[objectWithName], _String]}],
            Null
          ];

          (* If we were able to find a packet, then that means that we were able to find the objectWithName in regular object ID format. *)
          If[MatchQ[objectWithNamePacket, _Association],
            objectWithName->Lookup[objectWithNamePacket, Object],
            Nothing
          ]
        ]
      ],
      uniqueObjectsWithName
    ];

    (* Get the rest of the object ID from Download. If they're not in our simulations, they must be in the server. *)
    remainingObjectsWithName=Complement[uniqueObjectsWithName, simulationObjectsWithNameToID[[All,1]]];

    downloadObjectsWithNameToID=If[Length[remainingObjectsWithName]==0,
      {},
      MapThread[(#1->#2&), {remainingObjectsWithName, Download[remainingObjectsWithName, Object]}]
    ];

    (* Combine the object in name form -> object in ID form rules. *)
    allObjectsWithNameToID=Flatten[{simulationObjectsWithNameToID, downloadObjectsWithNameToID}];

    (* Replace all in the simulation change packet. *)
    ReplaceAll[packetsWithObjectKey, allObjectsWithNameToID]
  ];

  (* 3) For each change packet, see if we have any backlinks. If so, we will make an extra packet to make sure that the *)
  (* backlink gets created -- unless that link value is already in the field. *)
  changeAndBacklinkPackets=Map[
    Function[changePacket,
      Module[{backlinks, backlinksWithIDs, backlinkChangePackets, changePacketTypes},
        (* Get all backlinks from this change packet. *)
        (* NOTE: It's important for this to NOT match on links that already have a link ID. *)
        backlinks=DeleteDuplicates[Cases[changePacket, (Link[_, _Symbol]|Link[_, _Symbol, _Symbol]|Link[_, _Symbol, _Integer]), Infinity]];

        (* Give all of these backlinks IDs so we don't keep adding change packets. *)
        backlinksWithIDs=(Append[#, SimulateCreateID[]]&)/@backlinks;


        (* get the type and all parent types of the change packet *)
        (* so if you are an Object[Container, Plate, Filter], this will give you {Object[Container], Object[Container, Plate], Object[Container, Plate, Filter]} *)
        changePacketTypes = With[{type = Download[Lookup[changePacket, Object], Type]},
          Table[
            Take[type, i],
            {i, Length[type]}
          ]
        ];

            (* If we have backlinks, make change packets to append these values on the other side. *)
        backlinkChangePackets=Map[
          Function[backlink,
            Module[{backlinkSpec, backlinkObject, backlinkObjectType, typeDefinition, othersideBacklinkSpec, othersideBacklink, backlinkPacket, backlinkPacketWithoutChangeHeads},
              (* Get the field that we're backlinking to. *)
              backlinkSpec=Rest[List@@backlink];

              (* Get the object form of the backlink. *)
              {backlinkObject,backlinkObjectType}=Download[backlink, {Object, Type}];

              (* Get the type definition information. *)
              typeDefinition=LookupTypeDefinition[backlinkObjectType, First[backlinkSpec]];

              (* Get the backlink format. *)
              (* need to do this for all the types (because sometimes the field exists in Object[Container], not Object[Container, Vessel] *)
              othersideBacklinkSpec=FirstCase[
                ToList[Lookup[typeDefinition, Relation]/.{Alternatives->List}],
                (Alternatives @@ Map[
                  #[spec___]&,
                  changePacketTypes
                ]) :> {spec},
                {}
              ];

              (* Get the format of the otherside backlink. *)
              othersideBacklink=Link@@{Lookup[changePacket, Object], Sequence@@othersideBacklinkSpec, SimulateCreateID[]};

              (* Try to get the object that we're backlinking to. *)
              (* NOTE: We're only looking up from packetsWithNoObjectsWithName which is derived from our new simulation's *)
              (* change packets because we will indeed make a backlink if it wasn't included in the new simulation's change packets. *)
              backlinkPacket=FirstCase[packetsWithNoObjectsWithName, KeyValuePattern[Object->backlinkObject], <||>];

              backlinkPacketWithoutChangeHeads=Normal[backlinkPacket]/.{(Append|Replace|Prepend)[sym_Symbol]:>sym};

              (* Create a packet to make the backlink. *)
              Which[
                (* Multiple field *)
                MatchQ[backlinkSpec, {_Symbol}] && MatchQ[Lookup[typeDefinition, Format], Multiple],
                  (* If we've already provided the backlink value, don't double append. *)
                  If[MemberQ[ToList[Lookup[backlinkPacketWithoutChangeHeads, First[backlinkSpec], {}]], LinkP[Lookup[changePacket, Object]]],
                    Nothing,
                    <|
                      Object->backlinkObject,
                      Type -> backlinkObjectType,
                      Append[First[backlinkSpec]]->othersideBacklink
                    |>
                  ],
                (* Single field *)
                MatchQ[backlinkSpec, {_Symbol}] && MatchQ[Lookup[typeDefinition, Format], Single],
                  (* If we left this out it would just overwrite and be equivalent but check for the existing backlink anyways. *)
                  If[MatchQ[Lookup[backlinkPacketWithoutChangeHeads, First[backlinkSpec], Null], LinkP[Lookup[changePacket, Object]]],
                    Nothing,
                    <|
                      Object->backlinkObject,
                      Type -> backlinkObjectType,
                      First[backlinkSpec]->othersideBacklink
                    |>
                  ],

                (* NOTE: Past here, we don't check for an existing backlink -- should we? *)
                (* Indexed Multiple field *)
                MatchQ[backlinkSpec, {_Symbol, _Integer}] && MatchQ[Lookup[typeDefinition, Format], Multiple],
                  <|
                    Object->backlinkObject,
                    Type -> backlinkObjectType,
                    Append[First[backlinkSpec]]->Join[
                      ConstantArray[Null, backlinkSpec[[2]]-1],
                      {othersideBacklink},
                      ConstantArray[
                        Null,
                        Length[Lookup[typeDefinition, Class]]-backlinkSpec[[2]]
                      ]
                    ]
                  |>,
                (* Indexed Single field *)
                MatchQ[backlinkSpec, {_Symbol, _Integer}] && MatchQ[Lookup[typeDefinition, Format], Single],
                  <|
                    Object->backlinkObject,
                    Type -> backlinkObjectType,
                    First[backlinkSpec]->Join[
                      ConstantArray[Null, backlinkSpec[[2]]-1],
                      {othersideBacklink},
                      ConstantArray[
                        Null,
                        Length[Lookup[typeDefinition, Class]]-backlinkSpec[[2]]
                      ]
                    ]
                  |>,
                (* Named Multiple field *)
                MatchQ[backlinkSpec, {_Symbol, _Symbol}] && MatchQ[Lookup[typeDefinition, Format], Multiple],
                  Module[{namedFieldPostion},
                    (* Get the position of our named field. *)
                    namedFieldPostion=FirstPosition[Lookup[typeDefinition, Class][[All,1]], backlinkSpec[[2]]][[1]];

                    <|
                      Object->backlinkObject,
                      Type -> backlinkObjectType,
                      Append[First[backlinkSpec]]->Join[
                        ConstantArray[Null, namedFieldPostion-1],
                        {othersideBacklink},
                        ConstantArray[
                          Null,
                          Length[Lookup[typeDefinition, Class]]-namedFieldPostion
                        ]
                      ]
                    |>
                  ],
                (* Named Single field *)
                MatchQ[backlinkSpec, {_Symbol, _Symbol}] && MatchQ[Lookup[typeDefinition, Format], Single],
                  Module[{namedFieldPostion},
                    (* Get the position of our named field. *)
                    namedFieldPostion=FirstPosition[Lookup[typeDefinition, Class][[All,1]], backlinkSpec[[2]]][[1]];

                    <|
                      Object->backlinkObject,
                      Type -> backlinkObjectType,
                      First[backlinkSpec]->Join[
                        ConstantArray[Null, namedFieldPostion-1],
                        {othersideBacklink},
                        ConstantArray[
                          Null,
                          Length[Lookup[typeDefinition, Class]]-namedFieldPostion
                        ]
                      ]
                    |>
                  ],
                True,
                  Nothing
              ]
            ]
          ],
          backlinks
        ];

        (* Return our original packet along with any backlink packets. *)
        Sequence@@Join[
          {Association@(Normal[changePacket]/.MapThread[#1->#2&,{backlinks,backlinksWithIDs}])},
          backlinkChangePackets
        ]
      ]
    ],
    packetsWithNoObjectsWithName
  ];

  (* 4) Determine which objects are in the database and which are simulated and update the SimulatedObjects field accordingly *)
  (* Also, for the simulated objects, make sure they have all fields either set to Null/{} depending on single/multiple *)
  (* Do a DatabaseMemberQ call, to determine which objects are actually in the database, so we can download from them *)

  (* note that this DatabaseMemberQ call is actually rather slow in the context of UpdateSimulation--we call this function a ton and also frequently don't need to call it *)
  (* thus, we do the following heuristics to determine if we need to *)
  (* a.) If the ID is one that came from SimulateCreateID (i.e., it has an ID that has 13 characters instead of the conventional 12), then we know DatabaseMemberQ would return False so we don't have to try it *)
  (* b.) If the ID is already in the SimulatedObjects key, then we know it is Simulated and don't have to check again *)
  (* c.) If the ID is for an object that was already in the existing simulation AND it was not in the existing SimulatedObjects key, then we know DatabaseMemberQ would return True so we also don't have to try it *)

  (* first get what we currently already have in the SimulatedObjects and Packets *)
  currentSimulatedObjects = Lookup[currentSimulationNoChangePackets[[1]], SimulatedObjects];
  inputSimulationObjects = DeleteCases[Lookup[Lookup[currentSimulationNoChangePackets[[1]], Packets], Object, {}], _Missing];

  (* now get the ones we know are simulated*)
  knownSimulatedPackets = Map[
    With[{id = Last[Lookup[#, Object]]},
      (* 15 here means 12 characters for the IDs + the three for "id:"*)
      (* if we are not equal to that, then we have an ID from SimulateCreateID *)
      (* also if we already have this as a simulated object, then don't need to check again *)
      Which[
        StringLength[id] != 15, #,
        MemberQ[currentSimulatedObjects, Lookup[#, Object]], #,
        True, Nothing
      ]
    ]&,
    changeAndBacklinkPackets
  ];

  (* decide which packet types we don't need to call DatabaseMemberQ on (and we can just assume they're real) *)
  (* Something being marked as "real" here doesn't really mean anything except that we will NOT backfill the default value (i.e., Null or {}) for all the unstated fields *)
  (* 1.) If we're only updating the backlink of the Model field of a simulated object.  We almost definitely do not want to fill the rest of those in and also this is relatively common with UploadSample calls *)
  (* 2.) Protocols where the only thing being updated is ReadyCheckLastUpdated *)
  (* 3.) The following types: Object[Team, Financing], Object[User], Object[LaboratoryNotebook], and Object[Resource] *)
  (* this is because for teams, users, and notebooks, we really should not be making fake ones of thoese and then using them, so we can safely assume they're real if they make it this far *)
  (* for resources, we will have lots of fake ones, but they should all be using SimulateCreateID in SimulateResources etc, and so we can assume they're real if they make it through that filter *)
  (* NOTE FINALLY that this is not comprehensive; there are going to be more things that we can probably ID as being part of a Simulation or being Real without calling DatabaseMemberQ, but I feel like this is already too complicated here *)
  (* so this does give a modest speedup in certain cases, and since UpdateSimulation is called so widely, it is still worth it, but I wish it were more comprehensive and/or less ugly*)
  deFactoRealPattern = Alternatives[
    KeyValuePattern[{Object -> Model[___], (Objects|Append[Objects]) -> Link[Alternatives @@ Lookup[knownSimulatedPackets, Object], ___]}],
    (* this allows me to guarantee that we will ONLY be checking for these two fields *)
    <|Object -> _, ReadyCheckLastUpdated -> _|>,
    KeyValuePattern[{Object -> Object[Team, Financing, ___]}],
    KeyValuePattern[{Object -> Object[User, ___]}],
    KeyValuePattern[{Object -> Object[LaboratoryNotebook, ___]}],
    KeyValuePattern[{Object -> Object[Resource, ___]}]
  ];

  (* now get the ones we know are real *)
  knownRealPackets = Select[
    changeAndBacklinkPackets,
    (* this is especially goofy.  two cases we "know" it's a real object (see corresponding lines below) *)
    Or[
      (* 1.) if we know the object is included in the packets of currentSimulation, and NOT in the SimulatedObjects of the currentSimulation *)
      MemberQ[inputSimulationObjects, Lookup[#, Object]] && Not[MemberQ[currentSimulatedObjects, Lookup[#, Object]]],
      (* 2.) the object is not a known simulated sample and it matches any of the above criteria *)
      And[
        Not[MemberQ[knownSimulatedPackets, #]],
        MatchQ[#, deFactoRealPattern]
      ]
    ]&
  ];

  (* get the ones that are still undetermined; these ones we do need to call DatabaseMemberQ on *)
  (* note that DMQ is more or less an all-or-nothing thing.  If we can make it necessary to call DMQ on NOTHING then we go a lot faster.  If we have to call it on some things then it's the same as just calling it on everything*)
  (* note also that Verbatim is important here because for conditional branch functions this can be messed up because those have _? functions inside and this DeleteCases can fuck with them *)
  (* ultimately, it's because if you try to do something like this, it returns False and throws a message (incorrectly) *)
  (* MatchQ[Hold[{_?(StringContainsQ[#1, "4.3."] &) -> "NMR TopSpin 4.3 Setup", _ -> "NMR TopSpin 3.6 Setup"}], Hold[{_?(StringContainsQ[#1, "4.3."] &) -> "NMR TopSpin 4.3 Setup", _ -> "NMR TopSpin 3.6 Setup"}]]*)
  (* you would think the Hold would prevent the shenanigans, but Hold is _only_ shenanigans so you would be wrong *)
  (* instead, if we did this, it correctly just returns True: *)
  (* MatchQ[Hold[{_?(StringContainsQ[#1, "4.3."] &) -> "NMR TopSpin 4.3 Setup", _ -> "NMR TopSpin 3.6 Setup"}], Verbatim[Hold[{_?(StringContainsQ[#1, "4.3."] &) -> "NMR TopSpin 4.3 Setup", _ -> "NMR TopSpin 3.6 Setup"}]]]*)
  unknownChangeAndBacklinkPackets = DeleteCases[changeAndBacklinkPackets, Alternatives @@ (Verbatim /@ Join[knownSimulatedPackets, knownRealPackets])];

  (* NOTE: Including these full field packets for objects we already have in the existing simulation is ok because if we already have them in the existing simulation but they don't actually exist and we don't have the field in question, then it must be the default value anyway and there's nothing to overwrite*)
  (* we won't overwrite actual values *)
  unknownObjectsExistInDatabaseDatabaseMemberQ=If[MatchQ[unknownChangeAndBacklinkPackets, {}],
    {},
    Block[{$Simulation=False, $CurrentSimulation=Null, enableIdCasAssoc=False},
      DatabaseMemberQ[Lookup[unknownChangeAndBacklinkPackets, Object, {}]]
    ]
  ];

  (* make replace rules indicating whether a given packet actually exists or not, and use that to get the final value *)
  objectsExistInDatabaseReplaceRules = Join[
    AssociationThread[knownSimulatedPackets, ConstantArray[False, Length[knownSimulatedPackets]]],
    AssociationThread[knownRealPackets, ConstantArray[True, Length[knownRealPackets]]],
    AssociationThread[unknownChangeAndBacklinkPackets, unknownObjectsExistInDatabaseDatabaseMemberQ]
  ];
  (* important to use Replace and not /. because I don't to accidentally change things inside the packets themselves *)
  objectsExistInDatabaseDatabaseMemberQ = Replace[changeAndBacklinkPackets, objectsExistInDatabaseReplaceRules, {1}];

  newSimulationSimulatedObjects = ECL`PickList[
    Lookup[changeAndBacklinkPackets, Object, {}],
    objectsExistInDatabaseDatabaseMemberQ,
    False
  ];

  (* For the simulated objects which are not in the database, add all fields that are not in the simulation packets *)
  simulatedObjectPacketsWithFullFields=Map[
    Function[{packet},
      (* Get the fields for the type and fill them out. *)
      Module[{packetType, newPacket},
        (* Get the type of this packet. *)
        packetType=Lookup[packet, Object][Type];

        (* Detect and remove change fields as we are simulating downloading them, which would return {} or Null based on the field type *)
        newPacket = KeySelect[packet,!(MatchQ[#,(Append|Prepend|Erase|EraseCases|Transfer|Replace)[_Symbol]])&];

        (* Merge this packet into a "default packet" that has all of the single fields filled out as Null and *)
        (* all of the multiple fields filled out as {}, if they're not already in the packet. *)
        (* NOTE: Based on speed testing, this is the fastest way to do this. *)
        Join[
          defaultPacket[packetType],
          newPacket
        ]
      ]
    ],
    ECL`PickList[changeAndBacklinkPackets, objectsExistInDatabaseDatabaseMemberQ, False]
  ];

  (* update the current simulation to include the packets for new simulated objects *)
  currentSimulationWithNewSimulatedObjects=Simulation[<|
    Packets->DeleteDuplicates[Flatten[{
      Lookup[currentSimulationNoChangePackets[[1]], Packets],
      simulatedObjectPacketsWithFullFields
    }]],
    Labels->Lookup[currentSimulationNoChangePackets[[1]], Labels],
    LabelFields->Lookup[currentSimulationNoChangePackets[[1]], LabelFields],
    SimulatedObjects->DeleteDuplicates[
      Flatten[{Lookup[currentSimulationNoChangePackets[[1]], SimulatedObjects], newSimulationSimulatedObjects}]
    ],
    Updated->True,
    NativeSimulationID -> None
  |>];

  (* make an association (i.e., a dictionary) with the objects as the keys and the lists of fields in their packets as the values *)
  currentSimulationFieldsPerObject = With[{simPackets = Lookup[currentSimulationWithNewSimulatedObjects[[1]], Packets]},
    AssociationThread[Lookup[simPackets, Object, {}], Keys[simPackets]]
  ];

  (* 5) Fetch values that we need due to Append[...], Prepend[...], Erase[...], or EraseCases[...] heads. Do this all at once so that *)
  (* if we are reaching out to the server (in the case that we're simulating a change to a real object) we will bundle our *)
  (* call and only make one round trip. *)

  (* Merge this in with the information we have from our current simulation to a "local constellation store" that we will *)
  (* map over and modify later. *)

  (* NOTE: By passing the Simulation->currentSimulation option to Download, Download will make sure to respect our rule of *)
  (* local simulation > global simulation > server. *)

  (* NOTE: If we try to download from an object that's in a simulation that doesn't exist in the database, download will return Null/{} if *)
  (* we haven't changed the field at all -- it won't reach out to the server. *)

  (* NOTE: This variable will always be in full packet form (no change packets). *)
  currentObjectPackets=Module[{objectsAndChangeFields, packetsWithoutChangeFields, downloadedPackets},
    (* Get the objects and fields that have Append[...], Prepend[...], Erase[...], or EraseCases[...] heads. *)
    objectsAndChangeFields={};
    packetsWithoutChangeFields={};

    Map[
      Function[changePacket,
        Module[{changePacketObject, existingFields, changeFields,packetWithoutChangeFields, existingFieldsAlternatives},

          (* get the keys for this change packet that we already have; if we have them then we won't Download below *)
          changePacketObject = Lookup[changePacket, Object];
          existingFields = Lookup[currentSimulationFieldsPerObject, changePacketObject, {}];
          existingFieldsAlternatives = Alternatives @@ existingFields;

          (* NOTE: we are explicitly choosing not to Download from fields that already exist in the current simulation. This has huge performance implications and presumably is redundant anyway *)
          (* the only case where this would make a difference is if the value in the current simulation is not the same as the actual "current" value in the object itself *)
          (* in those cases though I think we already prefer the simulation value to the real value anyway *)

          (* NOTE: DANGER -- her we are explicitly choosing not to download the Objects field from any Model[Samples] *)
          (* (and items etc.) that we have. This is because it takes forever to download the Objects field in order to *)
          (* PROPERLY update the Objects field if we get an Append[Objects]. This can only really be fixed by moving *)
          (* this simulation logic to the server side. If we wanted to be a little more careful, we could only match on *)
          (* common Model[Sample]s. *)

          (* NOTE: This is ESPECIALLY true for notebooks. Object[LaboratoryNotebook, "id:8qZ1VW0EDBPP"] has 3.7 million *)
          (* objects and can crash Constellation if you try to download the Objects field. *)

          (* NOTE: Also do not download the Samples field from Object[Product]. *)

          (* NOTE: Also do not download the StatusLog or ContentsLog from Object[Instrument] or Object[Container] or Object[Item] *)

          (* NOTE: Also do not download the Data field from Object[Sensor] *)

          (* NOTE: We don't include Replace[...] here because we don't need to download to get any values for Replace. *)
          changeFields=Which[
            MatchQ[
              changePacketObject,
              ObjectReferenceP[{Object[ECL`LaboratoryNotebook], Model[Sample], Model[Item], Model[ECL`Container], Model[Part]}]
            ],
            Cases[Keys[changePacket], (Append|Prepend|Erase|EraseCases)[Except[Objects|existingFieldsAlternatives]]],
            MatchQ[
              changePacketObject,
              ObjectReferenceP[Object[Product]]
            ],
              Cases[Keys[changePacket], (Append|Prepend|Erase|EraseCases)[Except[ECL`Samples|existingFieldsAlternatives]]],
            MatchQ[
              changePacketObject,
              ObjectReferenceP[{Object[Container], Object[ECL`Instrument], Object[Item]}]
            ],
              Cases[Keys[changePacket], (Append|Prepend|Erase|EraseCases)[Except[ECL`StatusLog|ECL`ContentsLog|existingFieldsAlternatives]]],
            MatchQ[
              changePacketObject,
              ObjectReferenceP[Object[ECL`Sensor]]
            ],
              Cases[Keys[changePacket], (Append|Prepend|Erase|EraseCases)[Except[ECL`Data|existingFieldsAlternatives]]],
            MatchQ[changePacketObject, ObjectP[Object[ECL`Sample]]] && Not[MatchQ[ECL`WasteType, existingFieldsAlternatives]],
              (* note that we're Downloading WasteType specifically here because if we're dealing with chemical waste, we want to not include the huge fields that cause lots of problems *)
              (* even though WasteType is a single field, we need to put one of these heads around it so that the [[All, 1]] call later will work *)
              (* we only need to add WasteType if it wasn't already in the original simulation *)
              Append[Cases[Keys[changePacket], (Append|Prepend|Erase|EraseCases)[Except[existingFieldsAlternatives]]], Replace[ECL`WasteType]],
            True,
              Cases[Keys[changePacket], (Append|Prepend|Erase|EraseCases)[Except[existingFieldsAlternatives]]]
          ];

          (* Get the packet without change keys. *)
          packetWithoutChangeFields=Which[
            MatchQ[
              changePacketObject,
              ObjectReferenceP[{Object[ECL`LaboratoryNotebook], Model[Sample], Model[Item], Model[ECL`Container], Model[Part]}]
            ],
              Association[KeyDrop[Normal[changePacket]/.{Replace[sym_]:>sym}, Append[changeFields, Append[Objects]]]],
            MatchQ[
              changePacketObject,
              ObjectReferenceP[Object[Product]]
            ],
              Association[KeyDrop[Normal[changePacket]/.{Replace[sym_]:>sym}, Append[changeFields, Append[ECL`Samples]]]],
            MatchQ[
              changePacketObject,
              ObjectReferenceP[{Object[Container], Object[ECL`Instrument], Object[Item]}]
            ],
              (* this makes sure we don't have the old values for StatusLog if we're Appending, but also we drop them if they are just there in a non-append-or-replace-or-whatever way *)
              Association[KeyDrop[Normal[changePacket]/.{Replace[sym_]:>sym}, Join[changeFields, {Append[ECL`StatusLog], Append[ECL`ContentsLog], ECL`StatusLog, ECL`ContentsLog}]]],
            MatchQ[
              changePacketObject,
              ObjectReferenceP[Object[ECL`Sensor]]
            ],
              (* this makes sure we don't have the old values for StatusLog if we're Appending, but also we drop them if they are just there in a non-append-or-replace-or-whatever way *)
              Association[KeyDrop[Normal[changePacket]/.{Replace[sym_]:>sym}, Join[changeFields, {Append[ECL`Data], ECL`Data}]]],
            True,
              Association[KeyDrop[Normal[changePacket]/.{Replace[sym_]:>sym}, changeFields]]
          ];

          If[Length[Keys[packetWithoutChangeFields]]>0,
            packetsWithoutChangeFields=Append[packetsWithoutChangeFields, packetWithoutChangeFields];
          ];

          If[Length[changeFields]>0,
            objectsAndChangeFields=Append[objectsAndChangeFields, changePacketObject->(changeFields[[All,1]])];
          ];
        ]
      ],
      changeAndBacklinkPackets
    ];

    (* Download the current values from our change fields, if we have any. *)
    downloadedPackets=If[Length[objectsAndChangeFields]==0,
      {},
      (* NOTE: We quiet this for race conditions where the object used to exist but now doesn't due to erasing. This should *)
      (* happen during unit testing since we don't erase objects on the production database. *)
      (* IMPORTANTLY: do not pass the Simulation in here at all if we can avoid it.  This seems weird but there's a good reason for this: *)
      (* 1.) If the thing we're Downloading from does not exist (and so is a simulated object), then we would never have gotten to this point because *)
      (* defaultPacket is called for all simulated objects such that all fields are already in the packet.  Thus, the logic above with existingFieldsAlternatives will have already made us not Download from those objects *)
      (* 2.) If the thing we're Downloading from DOES exist, then we don't actually need the simulation at all and can just go to the database.  In that case, we explicitly do NOT want to use the simulation because it will just slow us down and we don't need to pull from that anyway *)
      (* IMPORTANTLY 2: We can't get away with this if we have an object that DOES exist but also has a packet in the current simulation or $CurrentSimulation *)
      (* I think this will still save us some time net, but it is an unfortunate failure to remove passing in Simulation to the Download *)
      (* If we can come up with something here then we should try to change it up *)
      Module[
        {allSimPackets, passSimInQ},

        (* determine if one of these objects is already in the simulations we started with; if it is, we need to incorporate these *)
        allSimPackets = Flatten[{
          Lookup[currentSimulation[[1]], Packets, {}],
          If[$Simulation,
            Lookup[$CurrentSimulation[[1]], Packets, {}],
            {}
          ]
        }];
        passSimInQ = MemberQ[Lookup[allSimPackets, Object, {}], Alternatives @@ objectsAndChangeFields[[All, 1]]];

        Quiet[
          With[
            {
              insertMe1 = objectsAndChangeFields[[All, 1]],
              insertMe2 = ({Packet @@ #}&) /@ objectsAndChangeFields[[All, 2]],
              insertMe3 = currentSimulationWithNewSimulatedObjects
            },
            If[passSimInQ,
              Flatten@Download[insertMe1, insertMe2, Simulation -> insertMe3],
              Block[{$Simulation = False, $CurrentSimulation = Null},
                Flatten@Download[insertMe1, insertMe2]
              ]
            ]
          ],
          {Download::ObjectDoesNotExist}
        ]
      ]
    ];

    (* Merge this in with our current simulation. *)

    (* NOTE: This will combine the fields together for packets with the same Object key value. It will prioritize the last key *)
    (* if the key shows up in multiple packets. That shouldn't affect things though since Download is looking at our local *)
    (* current simulation first so the values should be the same. *)
    (Merge[#, Last]&)/@GatherBy[Flatten[{Lookup[currentSimulationNoChangePackets[[1]], Packets], packetsWithoutChangeFields, downloadedPackets}], (Lookup[#, Object]&)]
  ];

  (* Create a hashed lookup of our object (in object reference form) to the packet that corresponds to it. *)
  (* We do this because when we have large simulations, doing a FirstCase/fetchPacketFromCache inside of our Map below is *)
  (* O(N^2). *)
  currentObjectPacketsLookup=Association[(Lookup[#, Object]->#&)/@currentObjectPackets];

  (* 5) Map over our change packets, in the order that we got them, and change the "local constellation store", mimicking what *)
  (* the constellation server would really do on upload. *)

  (* After this map, currentObjectPackets will contain full packets (no change packets) with the updated values for our updated *)
  (* simulation. *)
  Map[
    Function[changePacket,
      Module[{currentPacket, wasteQ},
        (* Get the packet that relates to the object in this change packet. *)
        currentPacket=Lookup[currentObjectPacketsLookup, Lookup[changePacket, Object]];
        wasteQ = MatchQ[Lookup[currentPacket, {Object, WasteType}], {ObjectReferenceP[Object[ECL`Sample]],ECL`WasteTypeP}];

        (* For each of the change packet fields, propagate the change into the current packet. *)
        (* Exclude TransfersIn/TransfersOut/SampleHistory if we're dealing with a waste sample *)
        Map[
          Function[changeFieldAndValue,
            If[MatchQ[changeFieldAndValue, _RuleDelayed],
              Nothing,
              With[
                {
                  changeField=changeFieldAndValue[[1]],
                  changeValue=changeFieldAndValue[[2]],
                  type = Lookup[currentPacket, Type, Download[Lookup[currentPacket, Object], Type]]
                },
                Switch[{changeField, type, wasteQ},
                  (* Just replace the value in currentPacket (unless it's StatusLog/ContentsLog for Instruments/Containers/Items, in which case we set it to {}. *)
                  {ECL`StatusLog | ECL`ContentsLog | Append[ECL`StatusLog] | Append[ECL`ContentsLog], TypeP[{Object[ECL`Instrument], Object[Container], Object[Item]}], _},
                  (* doing the FirstOrDefault trick so that we remove the Append if we need to *)
                    currentPacket[FirstOrDefault[changeField, changeField]] = {},
                  (* Just replace the value in currentPacket (unless it's StatusLog/ContentsLog for Instruments/Containers/Items, in which case we set it to {}. *)
                  {ECL`LocationLog | Append[ECL`LocationLog], TypeP[{Object[ECL`Instrument], Object[Item]}], _},
                    (* doing the FirstOrDefault trick so that we remove the Append if we need to *)
                    currentPacket[FirstOrDefault[changeField, changeField]] = {},
                  (* same behavior for Data in Sensors *)
                  {ECL`Data | Append[ECL`Data], TypeP[Object[Sensor]], _},
                  (* doing the FirstOrDefault trick so that we remove the Append if we need to *)
                    currentPacket[FirstOrDefault[changeField, changeField]] = {},
                  (* same behavior for SampleHistory, TransfersIn, and TransfersOut for waste samples *)
                  {ECL`SampleHistory | Append[ECL`SampleHistory] | ECL`TransfersIn | Append[ECL`TransfersIn] | ECL`TransfersOut | Append[ECL`TransfersOut], TypeP[Object[ECL`Sample]], True},
                  (* doing the FirstOrDefault trick so that we remove the Append if we need to *)
                    currentPacket[FirstOrDefault[changeField, changeField]] = {},
                  {_Symbol, _, _},
                    currentPacket[changeField] = changeValue,
                  (* Just replace the value in currentPacket. *)
                  (* if it's a single field then don't add a list, but if it's a multiple field you have to*)
                  {Replace[_Symbol] | Transfer[_Symbol], _, _},
                    With[{multipleFieldQ = MultipleFieldQ[type[First[changeField]]], indexedFieldQ = IndexedFieldQ[type[First[changeField]]]},
                      Which[
                        (* Null is a special case here; a multiple field -> Null will always populate {} *)
                        multipleFieldQ && MatchQ[changeValue, Null], currentPacket[changeField[[1]]] = {},
                        (* for indexed multiple fields if the list we're using is only one list (nonempty) and not a list of lists, then we need to add the extra list *)
                        multipleFieldQ && indexedFieldQ && Not[MatchQ[changeValue, {___List}]], currentPacket[changeField[[1]]] = {changeValue},
                        (* for other multiple fields, ToList is fine *)
                        multipleFieldQ, currentPacket[changeField[[1]]] = ToList[changeValue],
                        True, currentPacket[changeField[[1]]] = changeValue
                      ]
                    ],
                  (* Append to the current value. *)
                  (* NOTE: Append[...]/Prepend[...] of a list actually does a join, not an append/prepend. *)
                  {Append[_Symbol] | Prepend[_Symbol], _, _},
                    Module[{defaultedChangeFieldValue, patternWithNull},
                      (* Default the value of the change field to be {} if we exempted it from our download in our previous step. *)
                      defaultedChangeFieldValue=Lookup[currentPacket, changeField[[1]], {}];

                      (* Get the pattern for the field, account for the fact that Null matches everything when uploading to constellation. *)
                      (* If we have a named or indexed field, we must add Null to each index (this is tricky and different depending on which we have). Otherwise, just add Null to the whole pattern. *)
                      patternWithNull = Which[
                        NamedFieldQ[type[First[changeField]]],
                          Association[Map[
                            #[[1]] -> (#[[2]] | Null)&,
                            Lookup[LookupTypeDefinition[type, changeField[[1]]], Pattern]
                          ]],
                        IndexedFieldQ[type[First[changeField]]],
                          (# | Null&) /@ Lookup[LookupTypeDefinition[type, changeField[[1]]], Pattern],
                        True, Null | Lookup[LookupTypeDefinition[type, changeField[[1]]], Pattern]
                      ];

                      Which[
                        (* NOTE: If we failed to download from the object, there is a race condition due to unit testing. *)
                        MatchQ[defaultedChangeFieldValue, $Failed],
                          Null,
                        MatchQ[changeField, Append[_Symbol]] && MatchQ[changeValue, patternWithNull],
                          currentPacket[changeField[[1]]] = Append[defaultedChangeFieldValue, changeValue],
                        MatchQ[changeField, Prepend[_Symbol]] && MatchQ[changeValue, patternWithNull],
                          currentPacket[changeField[[1]]] = Prepend[defaultedChangeFieldValue, changeValue],
                        MatchQ[changeField, Append[_Symbol]],
                          currentPacket[changeField[[1]]] = Join[defaultedChangeFieldValue, changeValue],
                        True,
                        currentPacket[changeField[[1]]] = Join[changeValue, defaultedChangeFieldValue]
                      ]
                    ],
                  (* Erase any cases of the given value in the field. *)
                  {EraseCases[_Symbol], _, _},
                    currentPacket[changeField[[1]]] = Cases[currentPacket[changeField[[1]]], Except[changeValue]],
                  (* Erase from the field *)
                  {Erase[_Symbol], _, _},
                    (* If we have the All symbol, we're doing something with an indexed or named multiple. *)
                    (* Otherwise, we just have a regular flat multiple field and can use Delete[...]. *)
                    If[MemberQ[changeValue, All],
                      Module[{currentValue, changeValueWithKey},
                        (* Wrap Key[...] around any symbols (not the All symbol) so we can use it to lookup. *)
                        changeValueWithKey=changeValue/.{sym_Symbol?(!MatchQ[#, All]&) :> Key[sym]};

                        (* Store the current value so that we can overwrite it. *)
                        currentValue=currentPacket[changeField[[1]]];

                        (* Set the given spec to Null. *)
                        currentValue[[Sequence@@changeValueWithKey]]=ConstantArray[Null, Length[currentValue[[Sequence@@changeValueWithKey]]]];

                        (* Set the erased field value. *)
                        currentPacket[changeField[[1]]]=currentValue;
                      ],
                      currentPacket[changeField[[1]]]=Delete[currentPacket[changeField[[1]]], changeValue]
                    ],
                  {_, _, _},
                    Null
                ]
              ]
            ];
          ],
          Normal@changePacket
        ];

        (* We now have an updated packet. Get rid of the old packet in our simulation and use this new one. *)
        currentObjectPacketsLookup[Lookup[changePacket, Object]]=currentPacket;
      ]
    ],
    changeAndBacklinkPackets
  ];

  (* 6) Combine our labels. *)
  (* This part happens within one unit operation - meaining one subprotocol for manual preparation *)
  (* If there happens to be a label conflict, pick the label from our new simulation. *)
  (* NOTE: GatherBy will preserve the original order of our labels, if they show up in a new order in the new simulation. *)
  (* This is important because the order of SamplesOut in MSP/RSP is determined by the order of the Labels in the simulation. *)
  (* If there happens to be a label field conflict, pick the latest LabelField (not string). If not found, default to the last string labeled object's relation *)
  combinedLabels=Last/@GatherBy[Flatten[{Lookup[currentSimulationNoChangePackets[[1]], Labels], Lookup[newSimulation[[1]], Labels]}], (#[[1]]&)];
  combinedLabelFields=Map[
    LastOrDefault[Cases[#,Verbatim[Rule][_,Except[_String]]],Last[#]]&,
    GatherBy[Flatten[{Lookup[currentSimulationNoChangePackets[[1]], LabelFields], Lookup[newSimulation[[1]], LabelFields]}], (#[[1]]&)]
    ];

  (* 7) Return our new simulation. *)

  (* Update NativeSimulation to match updatedSimulation *)
  If[MatchQ[cloneSimulationID,_String],
    Check[
      If[$VersionNumber>=13.0,
        UpdateNativeSimulation[cloneSimulationID,Complement[Values[currentObjectPacketsLookup],Lookup[currentSimulation[[1]],Packets]]],
        UpdateNativeSimulation[cloneSimulationID,Values[currentObjectPacketsLookup]]
      ],
      (* If something went wrong with the update our best bet is to invalidate the clone simulation *)
      Quiet[DeleteNativeSimulation[cloneSimulationID]];
      cloneSimulationID=None
    ]
  ];

  Simulation[<|
    Packets->Values[currentObjectPacketsLookup],
    Labels->combinedLabels/.{obj:LinkP[]:>Download[obj, Object]},
    LabelFields->combinedLabelFields/.{obj:LinkP[]:>Download[obj, Object]},
    SimulatedObjects->DeleteDuplicates[
      Flatten[{Lookup[currentSimulationNoChangePackets[[1]], SimulatedObjects], newSimulationSimulatedObjects}]
    ],
    Updated->True,
    NativeSimulationID -> If[MatchQ[cloneSimulationID,_String|None],cloneSimulationID,None]
  |>]
];