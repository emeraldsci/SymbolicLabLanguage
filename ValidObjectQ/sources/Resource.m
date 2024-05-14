

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section::Closed:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validResourceQTests*)


validResourceQTests[packet:PacketP[Object[Resource]]]:=With[
	{},
	{
		NotNullFieldTest[
			packet,
			{Status,DateInCart}
		],
		
		Test["If Status is not Canceled, Requestor is informed:",
			Lookup[packet,{Status,Requestor}],
			{Canceled,_}|{Except[Canceled],Except[{}]}
		],
		
		Test["If Status is Fulfilled, DateFulfilled is informed:",
			Lookup[packet,{Status,DateFulfilled}],
			{Fulfilled,Except[Null]}|{Except[Fulfilled],Null}
		],
		
		Test["If Status is Canceled, DateCanceled is informed:",
			Lookup[packet,{Status,DateCanceled}],
			{Canceled,Except[Null]}|{Except[Canceled],Null}
		],
		
		Test["If DateFulfilled is informed, it is greater than DateInCart:",
			Module[
				{dateInCart,dateFulfilled},
				{dateInCart,dateFulfilled} = Lookup[packet,{DateInCart,DateFulfilled}];
				If[Not[NullQ[dateFulfilled]],
					TrueQ[dateFulfilled>dateInCart],
					True
				]
			],
			True
		],
		
		Test["If DateCanceled is informed, it is greater than DateInCart:",
			Module[
				{dateInCart,dateCanceled},
				{dateInCart,dateCanceled} = Lookup[packet,{DateInCart,DateCanceled}];
				If[Not[NullQ[dateCanceled]],
					TrueQ[dateCanceled>dateInCart],
					True
				]
			],
			True
		]
	}
];

(* ::Subsection::Closed:: *)
(*validResourceSampleQTests*)

validResourceSampleQTests[packet:PacketP[Object[Resource,Sample]]]:=With[
	{},
	{
		Test["If Status is Fulfilled, Sample is informed:",
			Lookup[packet,{Status,Sample}],
			{Fulfilled,Except[Null]}|{Except[Fulfilled],_}
		],

		Test["If resource is requesting a Model, Amount must be specified:",
			Module[
				{sample,models,amount},
				{sample,models,amount} = Lookup[packet,{Sample,Models,Amount}];
				If[NullQ[sample]&&MatchQ[models,{NonSelfContainedSampleModelP..}],
					Not[NullQ[amount]],
					True
				]
			],
			True
		],

		Test["If the Status is Outstanding, at least one of Sample and Models must be informed:",
			Module[
				{status,sample,models},
				{status,sample,models} = Lookup[packet,{Status,Sample,Models}];
				If[MatchQ[status,Outstanding],
					MatchQ[{sample,models},Except[NullP]],
					True
				]
			],
			True
		],
		
		(* cna't rent and purchase *)
		Test["The resource is marked as either rent or purchase but not both:",
			Lookup[packet,{Rent,Purchase}],
			Except[{True,True}]
		],
		
		Test["Rent and RentContainer are not simultaneously set to True:",
			Lookup[packet,{Rent,RentContainer}],
			Except[{True,True}]
		],
		
		Test["Untracked isn't set to True if Amount is known:",
			Lookup[packet,{Amount,Untracked}],
			Except[{Except[Null],True}]
		],

		Test["If the Sample for the Resource is countable, Amount must be populated:",
			If[!NullQ[Lookup[packet, Sample]],
				With[{count = Quiet[Download[Lookup[packet, Sample], Count],{Download::FieldDoesntExist}]},
						If[
							MatchQ[count, $Failed|Null],
							True,
							!NullQ[Lookup[packet, Amount]]
						]
				],
				True
			],
			True
		],

		Test["Fulfilled Samples that are Object[Sample] that are not Rented, are Tracked and don't have amount populated, should not be Purchased:",
			Module[{sample},

				sample = Download[Lookup[packet, Sample], Object];

				If[MatchQ[Lookup[packet, Status], Fulfilled] && MatchQ[sample, ObjectReferenceP[Object[Sample]]] && !TrueQ[Lookup[packet, Rent]] && !TrueQ[Lookup[packet, Untracked]] && NullQ[Lookup[packet, Amount]],

					(* when we have Null in the Amount field and we are not Renting + we are tracking *)
					Switch[Lookup[packet, Purchase],
						(* it is all good if Purchase is not informed *)
						Null | False,
						True,

						(* True is not fine *)
						True,
						False
					],
					(* return True for all cases where Rent/Untracket are True or we don't have Amount informed *)
					True
				]],
			True
		]
	}
];


(* ::Subsection::Closed:: *)
(*validResourceInstrumentQTests*)

validResourceInstrumentQTests[packet:PacketP[Object[Resource,Instrument]]]:=With[
	{},
	
	{
		Test["If Status is Fulfilled, Instrument is informed:",
			Lookup[packet,{Status,Instrument}],
			{Fulfilled,Except[Null]}|{Except[Fulfilled],_}
		],

		Test["If Status is Fulfilled, Time is populated:",
			Lookup[packet, {Status, Time}],
			{Fulfilled, Except[Null]}|{Except[Fulfilled], _}
		],

		RequiredTogetherTest[packet,{MinTime,MaxTime}],
		
		Test["MinTime must be less than MaxTime",
			Module[
				{minTime,maxTime},
				{minTime,maxTime} = Lookup[packet,{MinTime,MaxTime}];
				If[
					And[
						Not[NullQ[minTime]],
						Not[NullQ[maxTime]]
					],
					TrueQ[minTime<=maxTime],
					True
				]
			],
			True
		],
		
		Test["If the Status is Outstanding, at least one of Instruments and InstrumentModels must be informed:",
			Module[
				{status,instrument,instrumentModels},
				{status,instrument,instrumentModels} = Lookup[packet,{Status,Instrument,InstrumentModels}];
				If[MatchQ[status,Outstanding],
					MatchQ[{instrument,instrumentModels},Except[NullP]],
					True
				]
			],
			True
		]
	}
];


(* ::Subsection::Closed:: *)
(*validResourceOperatorQTests*)

validResourceOperatorQTests[packet:PacketP[Object[Resource,Operator]]]:={};


(* ::Subsection::Closed:: *)
(*validResourceWasteQTests*)

validResourceWasteQTests[packet:PacketP[Object[Resource,Waste]]]:=With[
	{},
	{
		Test["If Status is Fulfilled, WasteSamples is informed:",
			Lookup[packet,{Status,WasteSamples}],
			{Fulfilled,Except[{}]}|{Except[Fulfilled],_}
		]
	}
];

(* ::Subsection::Closed:: *)
(* Test Registration *)


registerValidQTestFunction[Object[Resource],validResourceQTests];
registerValidQTestFunction[Object[Resource, Instrument],validResourceInstrumentQTests];
registerValidQTestFunction[Object[Resource, Operator],validResourceOperatorQTests];
registerValidQTestFunction[Object[Resource, Sample],validResourceSampleQTests];
registerValidQTestFunction[Object[Resource, Waste],validResourceWasteQTests];
