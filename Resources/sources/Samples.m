(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Sample/Container Blob Set up*)


(* ::Subsection::Closed:: *)
(*Sample Blob Display *)


$DisplayBlobs=True;


sampleIcon[]:=sampleIcon[]=FastImport[FileNameJoin[{PackageDirectory["Resources`"],"resources","images","SampleIcon.png"}],"PNG"];


(* ::Subsubsection::Closed:: *)
(*installEmeraldSampleBlobs*)


installEmeraldSampleBlobs[]:=With[
	{},
	If[TrueQ[$DisplayBlobs],
		Sample /: MakeBoxes[sampleSpec:(Sample[_Association]),StandardForm]:=With[
			{assoc = Resources`Private`toSpecificationAssociation[sampleSpec]},
			With[
				{
					objectModel = Lookup[assoc,Model,Null],
					volume = Lookup[assoc,Volume,Null],
					mass = Lookup[assoc,Mass,Null],
					concentration = Lookup[assoc,Concentration,Null],
					massConcentration = Lookup[assoc,MassConcentration,Null]
				},
				BoxForm`ArrangeSummaryBox[
					Sample,
					sampleSpec,
					sampleIcon[],
					{
						If[Not[NullQ[objectModel]],
							BoxForm`SummaryItem[{"Model: ",objectModel}],
							Nothing
						],
						If[Not[NullQ[volume]],
							BoxForm`SummaryItem[{"Volume: ",volume}],
							Nothing
						],
						If[Not[NullQ[mass]],
							BoxForm`SummaryItem[{"Mass: ",mass}],
							Nothing
						],
						If[Not[NullQ[concentration]],
							BoxForm`SummaryItem[{"Concentration: ",concentration}],
							Nothing
						],
						If[Not[NullQ[massConcentration]],
							BoxForm`SummaryItem[{"MassConcentration: ",massConcentration}],
							Nothing
						]
					},
					{},
					StandardForm
				]
			]
		]
	];
];


installEmeraldSampleBlobs[];
OverloadSummaryHead[Sample];

OnLoad[
	installEmeraldSampleBlobs[];
	OverloadSummaryHead[Sample];
];


(* ::Subsection::Closed:: *)
(*Container Blob Display*)


(* ::Subsubsection::Closed:: *)
(*installEmeraldContainerBlobs*)


installEmeraldContainerBlobs[]:=With[
	{},
	If[TrueQ[$DisplayBlobs],
		Container /: MakeBoxes[containerSpec:(Container[_Association]),StandardForm]:=With[
			{assoc = Resources`Private`toSpecificationAssociation[containerSpec]},
			With[
				{
					objectModel = Lookup[assoc,Model,Null]
				},
				BoxForm`ArrangeSummaryBox[
					Container,
					containerSpec,
					sampleIcon[],
					{
						If[Not[NullQ[objectModel]],
							BoxForm`SummaryItem[{"Model: ",objectModel}],
							Nothing
						]
					},
					{},
					StandardForm
				]
			]
		];
	]
];



installEmeraldContainerBlobs[];
OverloadSummaryHead[Container];

OnLoad[
	installEmeraldContainerBlobs[];
	OverloadSummaryHead[Container];
];


(* ::Subsubsection::Closed:: *)
(*toSpecificAssociation*)

toSpecificationAssociation[head_Symbol[association_Association]]:=association;
toSpecificationAssociation[_]:=$Failed;


(* ::Subsection:: *)
(*Sample*)


Sample[{}]:={};
Sample[Null]:=Null;


Sample[seq:Sequence[Rule[_Symbol,_]...]]:=Module[
	{
		suppliedRules,suppliedType,suppliedModel,type,constructedSample,specifiedAmountValue,
		fullAmountRules,defaults
	},

	suppliedRules = {seq};
	
	If[MatchQ[suppliedRules,{}],
		Message[Sample::InvalidSample,"At least one parameter must be specified."];
		Return[$Failed]
	];

	suppliedType = Lookup[suppliedRules,Type];
	suppliedModel = Lookup[suppliedRules,Model];

	type = If[MatchQ[suppliedType,_Symbol],
		suppliedType,
		If[MatchQ[suppliedModel,ObjectP[]],
			Apply[Object,Download[suppliedModel,Type]],
			Object[Sample]
		]
	];
	If[Not[MatchQ[type,TypeP[Object[Sample]]]],
		Message[Sample::InvalidSample,"The type, "<>ToString[type]<>", must match TypeP[Object[Sample]]. Make sure you've supplied a valid model."];
		Return[$Failed]
	];

	constructedSample = Association[Join[{Type -> type},suppliedRules]];

	If[Not[validSampleSpecQ[constructedSample]],
		Return[$Failed]
	];

	(* -- Get Amount and Volume or Mass key -- *)
	(* One or none will be specified *)
	specifiedAmountValue = SelectFirst[
		Lookup[constructedSample,{Amount,Mass,Volume}],
		Not[MatchQ[#,_Missing|Null]]&
	];

	fullAmountRules = Switch[specifiedAmountValue,
		_Missing,
			{},
		(VolumeP | DistributionP[Liter]),
			{
				Volume -> specifiedAmountValue,
				Amount -> specifiedAmountValue
			},
		(MassP | DistributionP[Gram]),
		{
			Mass -> specifiedAmountValue,
			Amount -> specifiedAmountValue
		}
	];

	defaults = defaultFieldRules[constructedSample];

	Sample[
		Association[
			Join[
				defaults,
				fullAmountRules,
				Normal[constructedSample],
				{ID->CreateUUID[]}
			]
		]
	]
];


defaultFieldRules[currentBlob_] := Module[
	{type, allFields, fieldTypes, nonComputableFields},

	type = Lookup[currentBlob,Type];
	allFields = ECL`Fields[type];

	Map[
		Switch[LookupTypeDefinition[#, Format],
			Multiple,
				Constellation`Private`fieldToSymbol[#] -> {},
			Single,
				Constellation`Private`fieldToSymbol[#] -> Null,
			_,
				Nothing
		] &,
		allFields
	]
];



(* Object/Link Overload *)
Sample[object:(Except[PacketP[Object[Sample]],ObjectReferenceP[Object[Sample]]|LinkP[Object[Sample]]])]:=Module[
	{packet,amountValues,specifiedAmount},

	packet = Download[object];

	If[MatchQ[packet,$Failed],
		Message[Generic::MissingObject,object];
		$Failed,
		With[{specifiedAmount = SelectFirst[Lookup[packet,{Mass,Volume}],Not[NullQ[#]]&,Null]},
			Sample[
			(* Append Amount key if mass/volume is specified *)
				Append[packet,If[
					Not[NullQ[specifiedAmount]],
					Amount -> specifiedAmount,{}
				]
				]
			]
		]
	]
];

(* Object(s)/Link(s) Overload *)
Sample[objects:{(Except[PacketP[Object[Sample]],ObjectReferenceP[Object[Sample]]|LinkP[Object[Sample]]])..}]:=Module[
	{packets,amountValues,specifiedAmount},

	packets = Download[objects];

	If[MemberQ[ToList[packets],$Failed],
		With[
			{missingObjects=PickList[objects,packets,$Failed]},
			Message[Generic::MissingObject,missingObjects];
			$Failed
		],
		Map[
			Sample[Append[#,Amount -> SelectFirst[{#[Mass], #[Volume]}, Not[NullQ[#]] &, Null]]]&,
			packets
		]

	]
];


(* Packet Overload - Core overload when converting objects to sample blobs *)
Sample[packet:ObjectReferenceP[Object[Sample]]]:=Module[
	{download,amountValues,specifiedAmount},
	(* Convert keys to strings now to prevent premature evaulation of rule-delayed by OverloadSummaryHead *)
	download = Download[packet];
	amountValues = Lookup[packet,{Mass,Volume}];
	specifiedAmount = SelectFirst[amountValues,Not[NullQ[#]]&,Null];

	Sample[
		Append[
			download,
			(* Append Amount key if mass/volume is specified *)
			If[Not[NullQ[specifiedAmount]],
				Amount -> specifiedAmount,
				{}
			]
		]
	]
];


(* ::Subsection:: *)
(*Container*)


Container::InvalidContainer="`1`";


Container[rawSeq:Sequence[Rule[_Symbol,_]..]]:=Module[
	{suppliedRules,suppliedType,suppliedModel,type,constructedContainer,defaults},

	suppliedRules = {rawSeq};

	suppliedType = Lookup[suppliedRules,Type];
	suppliedModel = Lookup[suppliedRules,Model];

	type = If[MatchQ[suppliedType,_Symbol],
		suppliedType,
		If[MatchQ[suppliedModel,ObjectP[]],
			Apply[
				Object,
				Download[suppliedModel,Type]
			],
			Object[Container]
		]
	];

	constructedContainer = Association[Join[{Type -> type},suppliedRules]];

	If[Not[validContainerSpecQ[constructedContainer]],
		Return[$Failed]
	];

	defaults = defaultFieldRules[constructedContainer];

	Container[
		Association[
			Join[
				defaults,
				Normal[constructedContainer],
				{ID->CreateUUID[]}
			]
		]
	]
];


(* Object/Link Overload *)
Container[object:(ObjectReferenceP[Object[Container]]|LinkP[Object[Container]])]:=With[
	{packet = Download[object]},
	If[MatchQ[packet,$Failed],
		Message[Generic::MissingObject,object];
		$Failed,

		Container[
			packet
		]
	]
];

(* Object(s)/Link(s) Overload *)
Container[objects:{(ObjectReferenceP[Object[Container]]|LinkP[Object[Container]])..}]:=With[
	{packets = Download[objects]},

	If[MemberQ[ToList[packets],$Failed],
		With[
			{missingObjects=PickList[objects,packets,$Failed]},
			Message[Generic::MissingObject,missingObjects];
			$Failed
		],

		Container[
			packets
		]
	]
];


(* Packets Overload *)
Container[packets:{PacketP[Object[Container]]..}]:=Map[
	Container,
	packets
];


Container[{}]:={};
Container[Null]:=Null;


(* ::Subsection:: *)
(*Sample/Container Keys, Value Patterns*)


(* ::Subsubsection::Closed:: *)
(*sampleConstructMeta*)


sampleConstructMeta:=Association[
	KeyPatterns -> Association[
		Model -> Association[
			Pattern -> ObjectP[Model[Sample]]
		],
		Container -> Association[
			Pattern -> Alternatives[
				_Container
			]
		],
		Volume -> Association[
			Pattern -> Alternatives[
				VolumeP,
				DistributionP[Liter]
			]
		],
		Mass -> Association[
			Pattern -> Alternatives[
				MassP,
				DistributionP[Gram]
			]
		],
		Amount -> Association[
			Pattern -> Alternatives[
				VolumeP | MassP,
				DistributionP[Liter] | DistributionP[Gram]
			]
		],
		Concentration -> Association[
			Pattern -> Alternatives[
				ConcentrationP,
				DistributionP[Mole/Liter]

			]
		],
		MassConcentration -> Association[
			Pattern -> Alternatives[
				MassConcentrationP,
				DistributionP[Gram/Liter]
			]
		]
	],
	ValidationFunction -> Function[
		association,
		True
	]
];


(* ::Subsubsection::Closed:: *)
(*containerConstructMeta*)


containerConstructMeta:=Association[
	KeyPatterns -> Association[
		Model -> Association[
			Pattern -> ObjectP[Model[Container]],
			Optional -> False
		],
		Contents -> Association[
			Pattern -> {{
				WellP,
				_Sample
			}...},
			Optional -> True
		]
	],
	ValidationFunction -> Function[association,True]
];


(* ::Subsubsection::Closed:: *)
(*validSampleSpecQ*)


Sample::InvalidSample="`1`";


validSampleSpecQ[Sample[specifications_Association]]:=validSampleSpecQ[specifications];


validSampleSpecQ[specifications_Association]:=Module[
	{specAssociation,keyPatterns,type,objectKeys,allowedKeys,invalidKey,suppliedKeys,invalidValue,validationFunction},

	specAssociation = KeyDrop[specifications,{ID,Object}];

	keyPatterns = sampleConstructMeta[KeyPatterns];

	(* -- Allow any keys which are fields in the object. -- *)
	type=Lookup[specAssociation,Type,Object[Sample]];

	objectKeys = Map[
		Constellation`Private`fieldToSymbol[#]&,
		ECL`Fields[type]
	];

	allowedKeys = Join[
		objectKeys,
		Keys[keyPatterns]
	];

	invalidKey = SelectFirst[
		Keys[specAssociation],
		Not[MemberQ[allowedKeys,#]]&
	];

	If[Not[MissingQ[invalidKey]],
		Message[
			Sample::InvalidSample,
			StringJoin[
				ToString[invalidKey],
				" is not a valid Sample key"
			]
		];
		Return[False]
	];

	(* -- Check only the blob keys with supplied patterns -- *)
	invalidValue = SelectFirst[
		Keys[KeyTake[specAssociation,Keys[keyPatterns]]],
		Not[
			MatchQ[
				specAssociation[#],
				keyPatterns[#][Pattern]|Null|{}
			]
		]&
	];

	If[Not[MissingQ[invalidValue]],
		Message[
			Sample::InvalidSample,
			StringJoin[
				"The value, ",ToString[specAssociation[invalidValue]],", for ",
				ToString[invalidValue],
				" is invalid"
			]
		];
		Return[False]
	];

	(* -- Can only specify one amount style key -- *)
	If[
		Not[
			Or[
				MatchQ[Lookup[specAssociation,Amount,_Missing]],
				MatchQ[Lookup[specAssociation,Volume,_Missing]],
				MatchQ[Lookup[specAssociation,Mass,_Missing]]
			]
		],
		Message[
			Sample::InvalidSample,
			"Only Amount, Volume OR mass can be specified"
		];
		Return[False]
	];

	validationFunction = sampleConstructMeta[ValidationFunction];

	If[TrueQ[validationFunction[specAssociation]],
		True,
		False
	]
];


(* ::Subsubsection::Closed:: *)
(*validContainerSpecQ*)


validContainerSpecQ[Container[specifications_Association]]:=validContainerSpecQ[specifications];


validContainerSpecQ[specifications_Association]:=Module[
	{
		specAssociation,keyPatterns,mandatoryKeys,missingKey,type,objectKeys,allowedKeys,
		invalidKey,invalidValue,validationFunction
	},

	specAssociation = KeyDrop[specifications,{ID,Object}];

	keyPatterns = containerConstructMeta[KeyPatterns];

	mandatoryKeys = Keys[
		Select[
			keyPatterns,
			Not[#[Optional]]&
		]
	];

	missingKey = SelectFirst[
		mandatoryKeys,
		Not[KeyExistsQ[specAssociation,#]]&,
		{} (* We have all need keys *)
	];

	If[Not[MatchQ[missingKey,{}]],
		Message[
			Container::InvalidContainer,
			StringJoin[
				ToString[missingKey],
				" key must be specified in Container"
			]
		];
		Return[False]
	];

	(* Allow any keys which are fields in the object. *)
	type=Lookup[specAssociation,Type,Object[Container]];

	objectKeys = Map[
		Constellation`Private`fieldToSymbol[#]&,
		Fields[type]
	];

	allowedKeys = Join[
		objectKeys,
		Keys[keyPatterns]
	];

	invalidKey = SelectFirst[
		Keys[specAssociation],
		Not[MemberQ[allowedKeys,#]]&
	];

	If[Not[MissingQ[invalidKey]],
		Message[
			Container::InvalidContainer,
			StringJoin[
				ToString[invalidKey],
				" is not a valid Container key"
			]
		];
		Return[False]
	];

	invalidValue = SelectFirst[
		Keys[KeyTake[specAssociation,Keys[keyPatterns]]],
		Not[
			MatchQ[
				specAssociation[#],
				keyPatterns[#][Pattern]|Null|{}
			]
		]&
	];

	If[Not[MissingQ[invalidValue]],
		Message[
			Container::InvalidContainer,
			StringJoin[
				"The value, ",ToString[specAssociation[invalidValue]],", for ",
				ToString[invalidValue],
				" is invalid"
			]
		];
		Return[False]
	];

	validationFunction = containerConstructMeta[ValidationFunction];

	If[TrueQ[validationFunction[specAssociation]],
		True,
		False
	]
];


(* ::Section:: *)
(*General Helpers*)


(* ::Subsection:: *)
(*Extracting Values from Blobs*)


(* ::Subsubsection::Closed:: *)
(*blobLookup*)


blobLookup[blob:(_Sample|_Container|_Resource),field:_Symbol,default___]:=With[
	{fieldValues = blobLookup[blob,{field},default]},
	FirstOrDefault[fieldValues]
];
blobLookup[blob:(_Sample|_Container|_Resource),fields:{_Symbol..},default___]:=With[
	{fieldValues = blobLookup[{blob},fields,default]},
	FirstOrDefault[fieldValues]
];
blobLookup[blobs:{(_Sample|_Container|_Resource)...},field_Symbol,default___]:=With[
	{fieldValues = blobLookup[blobs,{field},default]},
	Map[
		FirstOrDefault,
		fieldValues
	]
];
blobLookup[blobs:{(_Sample|_Container|_Resource)...},fields:{_Symbol..},default___]:=Map[
	Function[
		currentBlob,
		Map[
			Lookup[constructAssociation[currentBlob],#,default]&,
			fields
		]
	],
	blobs
];


(* ::Subsubsection::Closed:: *)
(*constructAssociation*)


constructAssociation[Container[association_]]:=association;
constructAssociation[Sample[association_]]:=association;
constructAssociation[Resource[association_]]:=association;


constructAssociation[constructs:{(_Container|_Sample|_Resource)...}]:=Map[
	constructAssociation,
	constructs
];


(* ::Subsection:: *)
(*Converting between Blobs, Objects*)


(* ::Subsubsection::Closed:: *)
(*toBlob*)


toBlob[input:(ObjectP[{Object[Sample],Object[Container]}]|_?sampleResourceQ|_Container|_Sample)]:=With[
	{},
	FirstOrDefault[toBlob[{input}]]
];
toBlob[{}]:={};

(* Returns a list of sample/container blobs indexed matched to the original list *)
toBlob[inputList:{(ObjectP[{Object[Sample],Object[Container]}]|_?sampleResourceQ|_Container|_Sample)..}]:=Module[
	{samples,sampleBlobs,sampleToBlobRules,containers,containerBlobs,resources,
	resourceBlobs},

	(* -- Unique samples to sample blobs -- *)
	samples = DeleteDuplicates[
		Cases[inputList,ObjectP[Object[Sample]]]
	];
	sampleBlobs = Sample[samples];
	If[MatchQ[sampleBlobs,$Failed],
		Return[$Failed]
	];

	(* -- Unique containers to sample blobs -- *)
	containers = DeleteDuplicates[
		Cases[inputList,ObjectP[Object[Container]]]
	];
	containerBlobs = Container[containers];
	If[MatchQ[containerBlobs,$Failed],
		Return[$Failed]
	];

	(* -- Unique resource blobs to sample/container blobs -- *)
	resources = DeleteDuplicates[
		Cases[
			inputList,
			_?sampleResourceQ
		]
	];

	sampleToBlobRules = MapThread[
		Function[
			{object,blob},
			(object -> blob)
		],
		(*Add catch all N->N at the end, then if we didn't transform the input it will return unchanged *)
		{
			Join[samples,containers,resources,inputList],
			Join[sampleBlobs,containerBlobs,inputList]
		}
	];

	Replace[
		inputList,
		sampleToBlobRules,
		{1}
	]
];


(* ::Subsubsection:: *)
(*blobToObject*)
Authors[blobToString]:={"tyler.pabst", "daniel.shlian", "steven"};


blobToString[blob:(_Sample|_Container)]:=With[
	{underlyingObject = blobLookup[blob,Object]},

	If[MatchQ[underlyingObject,ObjectP[]],
		Return[ToString[underlyingObject]]
	];

	If[Not[NullQ[blobLookup[blob,Model]]],
		Return["an object generated during the experiment with "<>ToString[blobLookup[blob,Model]]]
	];

	(* Last ditch Sample description *)
	(* Container blobs are required to have models, so they won't reach this point *)
	"a sample with "<> ToString[
		KeyDrop[
			DeleteCases[
				Resources`Private`toSpecificationAssociation[blob],
				{}|Null
			],
			{ID,Amount}
		]
	]
];

blobToString[object:ObjectP[]]:=object;

blobToString[inputs:{(ObjectP[]|_Sample|_Container)..}]:=With[
	{
		inputStringList = Map[
			blobToString,
			inputs
		]
	},

	ToString[inputStringList]
];