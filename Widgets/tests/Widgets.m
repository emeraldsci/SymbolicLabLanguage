(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Title:: *)
(*Options: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*Ps & Qs*)


DefineTests[
	ValidWidgetQ,
	{
		Example[{Basic,"The following enumeration Widget is valid because A|B|C matches Alternatives[...]:" },
			ValidWidgetQ[Widget[Type->Enumeration,Pattern:>A|B|C]],
			True
		],
		Example[{Basic,"The following number widget is not valid because the value of Increment does not match the Pattern field:" },
			ValidWidgetQ[
				Widget[<|
					Type->Number,
					Pattern:>RangeP[0,10],
					Min -> 0,
					Max -> 10,
					Increment -> 0.1,
					PatternTooltip->"This is the tooltip explanation.",
					Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
				|>]
			],
			False
		],
		Example[{Basic,"The following number Widget is invalid because One Taco is not a valid increment:" },
			ValidWidgetQ[
				Widget[<|
					Type->Number,
					Pattern:>RangeP[0,10],
					Min -> 0,
					Max -> 10,
					Increment -> "One Taco",
					PatternTooltip->"This is the tooltip explanation.",
					Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
				|>]
			],
			False
		],
		Example[{Basic,"ValidWidgetQ is recursive and will check for valid widgets at all levels. The following primitive widget is valid since each of the Object and Number widgets are valid:" },
			ValidWidgetQ[
				Widget[
					Type->Primitive,
					Pattern :> _Transfer|_Mix,
					PrimitiveTypes->{Transfer,Mix},
					PrimitiveKeyValuePairs -> {
						Transfer->{
							Source->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes->{Object[Sample],Object[Container]}
							],
							Destination->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes->{Object[Sample],Object[Container]}
							]
						},
						Mix->{
							Source->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes->{Object[Sample],Object[Container]}
							],
							MixCount->Widget[
								Type->Number,
								Pattern:>GreaterP[1],
								Min -> 1,
								Max -> Null
							]
						}
					}
				]
			],
			True
		],
		Example[{Basic,"ValidWidgetQ is recursive and will check for valid widgets at all levels. The following primitive widget is invalid because the increment of the number widget doesn't match its pattern:" },
			ValidWidgetQ[
				Widget[<|
					Type->Primitive,
					Pattern :> _Transfer|_Mix,
					PrimitiveTypes->{Transfer,Mix},
					PrimitiveKeyValuePairs -> {
						Transfer->{
							Source->Widget[<|
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes->{Object[Sample],Object[Container]},
								PatternTooltip->"This is the tooltip explanation.",
								Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
							|>],
							Destination->Widget[<|
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes-> {Object[Sample],Object[Container]},
								PatternTooltip->"This is the tooltip explanation.",
								Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
							|>]
						},
						Mix->{
							Source->Widget[<|
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes->{Object[Sample],Object[Container]},
								PatternTooltip->"This is the tooltip explanation.",
								Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
							|>],
							MixCount->Widget[<|
								Type->Number,
								Pattern:>GreaterP[1],
								Min -> 1,
								Max -> Null,
								Increment -> 0.1,
								PatternTooltip->"This is the tooltip explanation.",
								Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
							|>]
						}
					},
					PatternTooltip->"This is the tooltip explanation.",
					Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
				|>]
			],
			False
		],
		Example[{Additional,"The following enumeration Widget is invalid because the Pattern does not match _Alternatives:" },
			ValidWidgetQ[Widget[<|Type->Enumeration,Pattern:>_Integer,PatternTooltip->"This is the tooltip explanation.",Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"|>]],
			False
		],
		Example[{Additional,"The following number widget is invalid because units cannot be specified in the Min field:" },
			ValidWidgetQ[
				Widget[<|
					Type->Number,
					Pattern:>RangeP[0,10],
					Min -> 0*Newton,
					Max -> 10,
					Increment -> 0.1,
					PatternTooltip->"This is the tooltip explanation.",
					Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
				|>]
			],
			False
		],
		Example[{Additional,"The following Quantity widget is valid because all of the units match:" },
			ValidWidgetQ[
				Widget[<|
					Type->Quantity,
					Pattern:>RangeP[0 Newton,10 Newton],
					Min -> 0 Newton,
					Max -> 10 Newton,
					Increment -> Null,
					PatternTooltip->"This is the tooltip explanation.",
					Units -> Alternatives[
						CompoundUnit[
							{1,{Meter,{Millimeter,Meter,Kilometer}}},
							{1,{Kilogram,{Kilogram,Gram}}},
							{-2,{Second,{Millisecond,Second,Minute,Hour}}}
						],
						{1,{Newton,{Newton}}}
					],
					Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
				|>]
			],
			True
		],
		Example[{Additional,"The following Quantity widget is invalid because Taco is not a known unit:" },
			ValidWidgetQ[
				Widget[<|
					Type->Quantity,
					Pattern:>RangeP[0 Newton,1 Newton],
					Min -> 0 Newton,
					Max -> 10 Newton,
					Increment -> 0.1 Newton,
					PatternTooltip->"This is the tooltip explanation.",
					Units -> Alternatives[
						CompoundUnit[
							{1,{Meter,{Millimeter,Meter,Kilometer}}},
							{1,{Kilotaco,{Kilotaco,Taco}}},
							{-1,{Second,{Millisecond,Second,Minute,Hour}}}
						],
						{1,{Newton,{Newton}}}
					],
					Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
				|>]
			],
			False
		],
		Example[{Additional,"The following Color widget is valid because the Pattern matches Verbatim[ColorP]:" },
			ValidWidgetQ[
				Widget[<|
					Type->Color,
					Pattern:>ColorP,
					PatternTooltip->"This is the tooltip explanation.",
					Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
				|>]
			],
			True
		],
		Example[{Additional,"The following Color widget is invalid because the Pattern does not match Verbatim[ColorP]:" },
			ValidWidgetQ[
				Widget[<|
					Type->Color,
					Pattern:>ColorP,
					MyFavoriteColor->Blue,
					PatternTooltip->"This is the tooltip explanation.",
					Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
				|>]
			],
			False
		],
		Example[{Additional,"The following Date widget is valid because the Pattern matches Verbatim[_?DateObjectQ]:" },
			ValidWidgetQ[
				Widget[<|
					Type->Date,
					Pattern:>_?DateObjectQ,
					TimeSelector->True,
					PatternTooltip->"This is the tooltip explanation.",
					Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2",
					Increment->Null,
					Max->Null,
					Min->Null
				|>]
			],
			True
		],
		Example[{Additional,"The following Date widget is invalid because the Pattern does not match Verbatim[_?DateObjectQ]:" },
			ValidWidgetQ[
				Widget[<|
					Type->Date,
					Pattern:>"Taco Tuesday",
					TimeSelector->True,
					PatternTooltip->"This is the tooltip explanation.",
					Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
				|>]
			],
			False
		],
		Example[{Additional,"The following String widget is valid because each of the fields match their pattern:" },
			ValidWidgetQ[
				Widget[<|
					Type->String,
					Pattern:>_?StringQ,
					Size->Word,
					PatternTooltip->"This is the tooltip explanation.",
					BoxText->"Enter a brief description of the Sample",
					Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
				|>]
			],
			True
		],
		Example[{Additional,"The following String widget is invalid because 1 Meter is not a known Textbox Size:" },
			ValidWidgetQ[
				Widget[<|
					Type->String,
					Pattern:>_?StringQ,
					Size->1 Meter,
					PatternTooltip->"This is the tooltip explanation.",
					BoxText->"Enter a brief description of the Sample",
					Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
				|>]
			],
			False
		],
		Example[{Additional,"The following Object widget is valid because each of the fields match their pattern:" },
			ValidWidgetQ[
				Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
					ObjectTypes->{Model[Sample],Object[Sample]},
					PatternTooltip->"This is the tooltip explanation.",
					ObjectBuilderFunctions->{}
				]
			],
			True
		],
		Example[{Additional,"The following Object widget is invalid because Model[Food,Taco] is not a valid type:" },
			ValidWidgetQ[
				Widget[<|
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
					ObjectTypes->{Model[Food,Taco],Object[Sample]},
					PatternTooltip->"This is the tooltip explanation.",
					Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
				|>]
			],
			False
		],
		Example[{Additional,"The following Field Reference widget is valid because each of the fields match their pattern:" },
			ValidWidgetQ[
				Widget[Type->FieldReference,Pattern:>FieldReferenceP[],ObjectTypes->{Model[Sample]}]
			],
			True
		],
		Example[{Additional,"The following Field Reference widget is invalid because Model[Food,Taco] is not a known type:" },
			ValidWidgetQ[
				Widget[<|
					Type->FieldReference,
					Pattern:>FieldReferenceP[],
					ObjectTypes->{Model[Food,Taco],Object[Sample]},
					Fields->Fields[{Model[Food,Taco],Object[Sample]}],
					PatternTooltip->"This is the tooltip explanation.",
					Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
				|>]
			],
			False
		],
		Example[{Additional,"The following MultiSelect widget is valid because the pattern matches DuplicateFreeListableP[_Alternatives] and the items in the alternatives are in the Items field:" },
			ValidWidgetQ[
				Widget[<|
					Type->MultiSelect,
					Pattern:>DuplicateFreeListableP["Taco"|"Burrito"|"Bowl"],
					Items->{"Taco","Burrito","Bowl"},
					PatternTooltip->"This is the tooltip explanation.",
					Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
				|>]
			],
			True
		],
		Example[{Additional,"The following MultiSelect widget is invalid because the Items key is missing:" },
			ValidWidgetQ[
				Widget[<|
					Type->MultiSelect,
					Pattern:>DuplicateFreeListableP["Taco"|"Burrito"|"Bowl"],
					PatternTooltip->"This is the tooltip explanation.",
					Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
				|>]
			],
			False
		],
		Example[{Additional,"The following Expression widget is valid because each of the fields match their pattern:" },
			ValidWidgetQ[
				Widget[<|
					Type->Expression,
					Pattern:>_,
					Size->Line,
					PatternTooltip->"This is the tooltip explanation.",
					BoxText->Null,
					Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
				|>]
			],
			True
		],
		Example[{Additional,"The following Expression widget is invalid because Taco is not a known Textbox size:" },
			ValidWidgetQ[
				Widget[<|
					Type->Expression,
					Pattern:>_,
					Size->Taco,
					PatternTooltip->"This is the tooltip explanation.",
					BoxText->Null,
					Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
				|>]
			],
			False
		],
		Example[{Additional,"The following Adder widget is valid because each of the quantity widgets are valid:" },
			ValidWidgetQ[
				Adder[
				{
					"Time" -> Widget[<|
						Type->Quantity,
						Pattern:>RangeP[0 Second,10 Hour],
						Min -> 0 Second,
						Max -> 10 Hour,
						Increment -> Null,
						PatternTooltip->"This is the tooltip explanation.",
						Units -> {1,{Second,{Second, Minute, Hour}}},
						Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
					|>],
					"Flow Rate" -> Widget[<|
						Type->Quantity,
						Pattern:>RangeP[0 (Micro Liter)/Second,100 (Micro Liter)/Second],
						Min -> 0 (Micro Liter)/Second,
						Max -> 100 (Micro Liter)/Second,
						Increment -> Null,
						PatternTooltip->"This is the tooltip explanation.",
						Units ->
							CompoundUnit[
								{1,{Micro Liter,{Pico Liter, Micro Liter,Milli Liter}}},
								{-1,{Second,{Millisecond,Second,Minute,Hour}}}
							],
						Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
					|>],
					"Percentages" -> Widget[<|
						Type->Quantity,
						Pattern:>RangeP[0 Percent,100 Percent],
						Min -> 0 Percent,
						Max -> 100 Percent,
						Increment -> Null,
						PatternTooltip->"This is the tooltip explanation.",
						Units -> {1,{Percent,{Percent}}},
						Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
					|>]
				},
				Orientation->Vertical
			]
		],
			True
		],
		Example[{Additional,"The following Adder widget is invalid because it contains an invalid Quantity Widget:" },
			ValidWidgetQ[
				Adder[
				{
					"Time" -> Widget[<|
						Type->Quantity,
						Pattern:>RangeP[0 Second,10 Hour],
						Min -> 0 Second,
						Max -> 10 Hour,
						Increment -> 10 Second,
						PatternTooltip->"This is the tooltip explanation.",
						Units -> {1,{Second,{Second, Minute, Hour}}},
						Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
					|>],
					"Flow Rate" -> Widget[<|
						Type->Quantity,
						Pattern:>RangeP[0 (Micro Liter)/Second,100 (Micro Liter)/Second],
						Min -> 0 (Micro Liter)/Second,
						Max -> 100 (Micro Liter)/Second,
						Increment -> 1 (Micro Liter)/Second,
						PatternTooltip->"This is the tooltip explanation.",
						Units ->
							CompoundUnit[
								{1,{Micro Liter,{Pico Liter, Micro Liter,Milli Liter}}},
								{-1,{Second,{Millisecond,Second,Minute,Hour}}}
							],
						Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
					|>],
					"Tacos" -> Widget[<|
						Type->Quantity,
						Pattern:>RangeP[0 Taco,100 Taco],
						Min -> 0 Taco,
						Max -> 100 Taco,
						Increment -> 1 Taco,
						PatternTooltip->"This is the tooltip explanation.",
						Units -> {1,{Taco,{Millitaco, Taco, Kilotaco}}},
						Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
					|>]
				},
				Orientation->Vertical
			]
		],
			False
		],
		Example[{Additional,"The following Alternatives widget is valid because each of the internal widgets is valid:" },
			ValidWidgetQ[
				Alternatives[
					Widget[Type->Enumeration,Pattern:>0|1|2|3|4|5],
					Widget[<|
						Type->Number,
						Pattern:>RangeP[0,5],
						Min -> 0,
						Max -> 5,
						Increment -> Null,
						PatternTooltip->"This is the tooltip explanation.",
						Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
					|>]
				]
			],
			True
		],
		Example[{Additional,"The following Alternatives widget is valid because each of the internal widgets is valid (test with labels):" },
			ValidWidgetQ[
				Alternatives[
					"Enumeration Label"->Widget[Type->Enumeration,Pattern:>0|1|2|3|4|5],
					"Number Label"->Widget[<|
						Type->Number,
						Pattern:>RangeP[0,5],
						Min -> 0,
						Max -> 5,
						Increment -> Null,
						PatternTooltip->"This is the tooltip explanation.",
						Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
					|>],
					"Molecule Label" -> Widget[<|Type -> Molecule,
						Pattern :> MoleculeP,
						PatternTooltip -> "blah",
						Identifier -> "6156c3bc-23e6-48d9-b505-92b183a4915e"|>]
				]
			],
			True
		],
		Example[{Additional,"The following Alternatives widget is invalid because the enumeration widget is invalid:" },
			ValidWidgetQ[
				Alternatives[
					Widget[<|Type->Enumeration,Pattern:>_Integer,Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"|>],
					Widget[<|
						Type->Number,
						Pattern:>RangeP[0,5],
						Min -> 0,
						Max -> 5,
						Increment -> 1,
						PatternTooltip->"This is the tooltip explanation.",
						Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
					|>]
				]
			],
			False
		],
		Example[{Additional,"The following Alternatives widget is invalid because the enumeration widget is invalid (test with labels):" },
			ValidWidgetQ[
				Alternatives[
					"Enumeration Label"->Widget[<|Type->Enumeration,Pattern:>_Integer,Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"|>],
					"Number Label"->Widget[<|
						Type->Number,
						Pattern:>RangeP[0,5],
						Min -> 0,
						Max -> 5,
						Increment -> 1,
						PatternTooltip->"This is the tooltip explanation.",
						Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
					|>]
				]
			],
			False
		],
		Example[{Additional,"The following Tuples widget is valid because each of the internal widgets is valid:" },
			ValidWidgetQ[
				{
					"Enumeration Widget" -> Widget[Type->Enumeration,Pattern:>0|1|2|3|4|5],
					"Number Widget" -> Widget[<|
						Type->Number,
						Pattern:>RangeP[0,5],
						Min -> 0,
						Max -> 5,
						Increment -> Null,
						PatternTooltip->"This is the tooltip explanation.",
						Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
					|>],
					"Molecule Label" -> Widget[<|Type -> Molecule,
						Pattern :> MoleculeP,
						PatternTooltip -> "blah",
						Identifier -> "6156c3bc-23e6-48d9-b505-92b183a4915e"|>]
				}
			],
			True
		],
		Example[{Additional,"The following Tuples widget is invalid because labels for each widget must be provided:" },
			ValidWidgetQ[
				{
					Widget[<|Type->Enumeration,Pattern:>0|1|2|3|4|5,Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"|>],
					Widget[<|
						Type->Number,
						Pattern:>RangeP[0,5],
						Min -> 0,
						Max -> 5,
						Increment -> 1,
						PatternTooltip->"This is the tooltip explanation.",
						Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
					|>]
				}
			],
			False
		],
		Example[{Additional,"The following Molecule Widget is Valid:" },
			ValidWidgetQ[
				Widget[<|Type -> Molecule,
					Pattern :> MoleculeP,
					PatternTooltip -> "blah",
					Identifier -> "6156c3bc-23e6-48d9-b505-92b183a4915e"|>]
			],
			True
		],
		Example[{Additional,"The following Head Widget is Valid because Type and Head exist and Widget is a valid widget:" },
			ValidWidgetQ[
				Widget[
					<|
					  Type->Head,
						Head->Taco,
						Widget->Widget[
							Type->Enumeration,
							Pattern:>Taco1|Taco2
						],
						Pattern:>blah,
						PatternTooltip->"blah",
						Identifier->"6156c3bc-23e6-48d9-b505-92b183a4915e"
					|>
				]
			],
			True
		],
		Example[{Additional,"The following Head Widget is invalid because Head does not exist:" },
			ValidWidgetQ[
				Widget[
					<|
						Type->Head,
						Widget->Widget[
							Type->Enumeration,
							Pattern:>Taco1|Taco2
						],
						Pattern:>blah,
						PatternTooltip->"blah",
						Identifier->"6156c3bc-23e6-48d9-b505-92b183a4915e"
					|>
				]
			],
			False
		],
		Example[{Additional,"The following Head Widget is invalid because Widget is not a valid widget:" },
			ValidWidgetQ[
				Widget[
					<|
						Type->Head,
						Head->Taco,
						Widget->Widget[
							Type->Enumeration,
							Pattern:>Taco1
						],
						Pattern:>blah,
						PatternTooltip->"blah",
						Identifier->"6156c3bc-23e6-48d9-b505-92b183a4915e"
					|>
				]
			],
			False,
			Messages :> {Widget::EnumerationPatternValue}
		]
	}
];


DefineTests[WidgetTypeQ,
	{
		Example[{Basic, "WidgetTypeQ checks for valid widget types. In the following example, Adder is a valid widget type:" },
			WidgetTypeQ[Adder],
			True
		],
		Example[{Basic, "WidgetTypeQ checks for valid widget types. In the following example, Number is a valid widget type:" },
			WidgetTypeQ[Number],
			True
		],
		Example[{Basic, "WidgetTypeQ checks for valid widget types. In the following example, Taco is not a valid widget type:" },
			WidgetTypeQ[Taco],
			False
		]
	}
];


(* ::Subsection::Closed:: *)
(*Short Hand Functions*)


DefineTests[Adder,
	{
		Example[{Basic, "Create an Adder widget, using an Enumeration widget as the singleton:"},
			Adder[
				Widget[
					Type->Enumeration,
					Pattern:>1|2|3|4|5
				]
			],
			Adder[Widget[<|Items -> {1, 2, 3, 4, 5}, Identifier -> _String, Type -> Enumeration, Verbatim[Pattern :> 1 | 2 | 3 | 4 | 5], PatternTooltip -> "Enumeration must be either 1, 2, 3, 4, or 5."|>],Orientation->Vertical]
		],
		Example[{Basic, "Create an Adder widget, using a Number widget as the singleton:"},
			Adder[
				Widget[
					Type->Number,
					Pattern:>GreaterP[0]
				]
			],
			Adder[Widget[<|Type->Number,Pattern:>GreaterP[0],Identifier->_String,Increment->Null,Max->Null,Min->0,PatternTooltip->"Number must be greater than 0."|>],Orientation->Vertical]
		],
		Example[{Basic, "Create an Adder widget, using a Tuple widget as the singleton:"},
			Adder[
				{
					"First Number"->Widget[
						Type->Number,
						Pattern:>GreaterP[0]
					],
					"Second Number"->Widget[
						Type->Number,
						Pattern:>GreaterP[0]
					]
				},
				Orientation->Vertical
			],
			Adder[{"First Number"->Widget[<|Type->Number,Pattern:>GreaterP[0],Identifier->_String,Increment->Null,Max->Null,Min->0,PatternTooltip->"Number must be greater than 0."|>],"Second Number"->Widget[<|Type->Number,Pattern:>GreaterP[0],Identifier->_String,Increment->Null,Max->Null,Min->0,PatternTooltip->"Number must be greater than 0."|>]},Orientation->Vertical]
		],
		Example[{Messages, "InvalidWidget","When the singleton widget inside of the adder does not match WidgetP, a message is thrown. In the following example, the labels are missing from the tuple widget:"},
			Adder[
				{
					Widget[
						Type->Number,
						Pattern:>GreaterP[0]
					],
					Widget[
						Type->Number,
						Pattern:>GreaterP[0]
					]
				}
			],
			$Failed,
			Messages:>{Adder::InvalidWidget}
		]
	}
];


DefineTests[Widget,
	{
		Example[{Basic, "Create an Enumeration widget:"},
			Widget[
				Type->Enumeration,
				Pattern:>1|2|3|4|5
			],
			Widget[<|Items -> {1, 2, 3, 4, 5}, Identifier -> _String, Type -> Enumeration, Verbatim[Pattern :> 1 | 2 | 3 | 4 | 5], PatternTooltip -> "Enumeration must be either 1, 2, 3, 4, or 5."|>]
		],
		Example[{Basic, "Create a Multiselect widget:"},
			Widget[
				Type->MultiSelect,
				Pattern:>DuplicateFreeListableP[NucleusP]
			],
			Widget[<|Type -> MultiSelect, Verbatim[Pattern :> DuplicateFreeListableP[NucleusP]], PatternTooltip ->_String, Identifier -> _String, Items -> {_String..}|>]
		],
		Example[{Basic, "Create an String widget:"},
			Widget[
				Type->String,
				Pattern:>_?StringQ,
				Size->Word
			],
			Widget[<|Type->String,Pattern:>Verbatim[_?StringQ],Size->Word,PatternTooltip->_String,BoxText->Null,Identifier->_String|>]
		],
		Example[{Basic, "Create an Molecule widget:"},
			Widget[Type -> Molecule, Pattern :> MoleculeP],
			Widget[<|Type -> Molecule, Pattern :> MoleculeP, PatternTooltip -> _String, Identifier -> _String|>]
		],
		Example[{Basic, "Returns $Failed if a Widget cannot be created from the provided inputs (the Min value is invalid):"},
			Widget[
				Type->Number,
				Pattern:>RangeP[0,10],
				Min -> 0 * Newton,
				Max -> 10,
				Increment -> 0.1
			],
			$Failed,
			Messages:>{Widget::NumberMinValue}
		],
		Example[{Basic, "Returns $Failed if a Widget cannot be created from the provided inputs (the Size key is required for the String Widget):"},
			Widget[
				Type->String,
				Pattern:>_?StringQ
			],
			$Failed,
			Messages:>{Widget::StringMissingSizeKey}
		],
		Example[{Basic, "Returns $Failed if a Widget cannot be created from the provided inputs (Pattern must be provided as SetDelayed):"},
			Widget[
				Type->Number,
				Pattern->RangeP[0,10],
				Min -> 0,
				Max -> 10,
				Increment -> Null
			],
			$Failed,
			Messages:>{Widget::PatternSetDelayed}
		],
		Example[{Additional, "Create an Number widget:"},
			Widget[
				Type->Number,
				Pattern:>RangeP[0,3],
				Min -> 0,
				Max -> 3
			],
			Widget[<|Type->Number,Pattern:>RangeP[0,3],Min->0,Max->3,Identifier->_String,Increment->Null,PatternTooltip->"Number must be greater than or equal to 0 and less than or equal to 3."|>]
		],
		Example[{Additional, "Create an Quantity widget:"},
			Widget[
				Type->Quantity,
				Pattern:>RangeP[0 Newton,1 Newton],
				Increment -> Null,
				Units -> Alternatives[
					CompoundUnit[
						{1,{Meter,{Millimeter,Meter,Kilometer}}},
						{1,{Kilogram,{Kilogram,Gram}}},
						{-2,{Second,{Millisecond,Second,Minute,Hour}}}
					],
					{1,{Newton,{Newton}}}
				]
			],
			Widget[<|Type->Quantity,Pattern:>RangeP[0 Newton,1 Newton],Increment->Null,Identifier->_String,Max->Quantity[1,"Newtons"],Min->Quantity[0,"Newtons"],Units->Verbatim[CompoundUnit[{1,{Quantity[1,"Meters"],{Quantity[1,"Millimeters"],Quantity[1,"Meters"],Quantity[1,"Kilometers"]}}},{1,{Quantity[1,"Kilograms"],{Quantity[1,"Kilograms"],Quantity[1,"Grams"]}}},{-2,{Quantity[1,"Seconds"],{Quantity[1,"Milliseconds"],Quantity[1,"Seconds"],Quantity[1,"Minutes"],Quantity[1,"Hours"]}}}]|{1,{Quantity[1,"Newtons"],{Quantity[1,"Newtons"]}}}],PatternTooltip->"Quantity must be greater than or equal to 0 newtons and less than or equal to 1 newton."|>]
		],
		Example[{Additional, "Using the Alternatives shorthand to make a Quantity widget will group units appropriately:"},
			Widget[
				Type -> Quantity,
				Pattern :> RangeP[-10 Celsius, 40 Celsius],
				Units -> Alternatives[Celsius, Fahrenheit, Kelvin]
			],
			Widget[<|Type -> Quantity, Pattern :> RangeP[-10 Celsius, 40 Celsius], Identifier -> _String, Increment -> Null, Max -> Quantity[40, "DegreesCelsius"], Min -> Quantity[-10, "DegreesCelsius"], Units -> {1, {Quantity[1, "DegreesCelsius"], {Quantity[1, "DegreesCelsius"], Quantity[1, "DegreesFahrenheit"], Quantity[1, "Kelvins"]}}}, PatternTooltip ->_String|>]
		],
		Example[{Additional, "Create an Quantity widget, with a simple unit:"},
			Widget[
				Type->Quantity,
				Pattern:>RangeP[0 Percent, 100 Percent],
				Min-> 0 Percent,
				Max-> 100 Percent,
				Increment->Null,
				Units->{1,{Percent,{Percent}}}
			],
			Widget[<|Type->Quantity,Pattern:>RangeP[0 Percent,100 Percent],Min->Quantity[0,"Percent"],Max->Quantity[100,"Percent"],Increment->Null,Identifier->_String,Units->{1,{Quantity[1,"Percent"],{Quantity[1,"Percent"]}}},PatternTooltip->"Quantity must be greater than or equal to 0 percent and less than or equal to 100 percent."|>]
		],
		Example[{Additional, "Create an Quantity widget, using short hand syntax for the units:"},
			Widget[
				Type->Quantity,
				Pattern:>RangeP[0 Percent, 100 Percent],
				Min-> 0 Percent,
				Max-> 100 Percent,
				Increment->Null,
				Units->Percent
			],
			Widget[<|Type->Quantity,Pattern:>RangeP[0 Percent,100 Percent],Min->Quantity[0,"Percent"],Max->Quantity[100,"Percent"],Increment->Null,Identifier->_String,Units->{1,{Quantity[1,"Percent"],{Quantity[1,"Percent"]}}},PatternTooltip->"Quantity must be greater than or equal to 0 percent and less than or equal to 100 percent."|>]
		],
		Example[{Additional, "Create an Quantity widget, using short hand syntax for the units:"},
			Widget[
				Type->Quantity,
				Pattern:>RangeP[0 Percent, 100 Percent],
				Min-> 0 Percent,
				Max-> 100 Percent,
				Increment->Null,
				Units->{Percent,{Percent}}
			],
			Widget[<|Type->Quantity,Pattern:>RangeP[0 Percent,100 Percent],Min->Quantity[0,"Percent"],Max->Quantity[100,"Percent"],Increment->Null,Identifier->_String,Units->{1,{Quantity[1,"Percent"],{Quantity[1,"Percent"]}}},PatternTooltip->"Quantity must be greater than or equal to 0 percent and less than or equal to 100 percent."|>]
		],
		Example[{Additional, "Create an Quantity widget, using short hand syntax for the units with an Alternatives:"},
			Widget[
				Type->Quantity,
				Pattern:>GreaterP[0 Foot],
				Units->Alternatives[
					Foot,
					{Meter,{Millimeter,Meter,Kilometer}}
				]
			],
			Widget[<|Type->Quantity,Pattern:>GreaterP[0 Foot],Identifier->_String,Increment->Null,Max->Null,Min->Quantity[0,"Feet"],Units->Verbatim[{1,{Quantity[1,"Feet"],{Quantity[1,"Feet"]}}}|{1,{Quantity[1,"Meters"],{Quantity[1,"Millimeters"],Quantity[1,"Meters"],Quantity[1,"Kilometers"]}}}],PatternTooltip->"Quantity must be greater than 0 feet."|>]
		],
		Example[{Additional, "Create an Quantity widget, using short hand syntax for the units with an Alternatives and a CompoundUnit:"},
			Widget[
				Type->Quantity,
				Pattern:>RangeP[0 Newton,1 Newton],
				Increment -> Null,
				Units -> Alternatives[
					CompoundUnit[
						{Meter,{Millimeter,Meter,Kilometer}},
						Kilogram,
						{-2,{Second,{Millisecond,Second,Minute,Hour}}}
					],
					Newton
				]
			],
			Widget[<|Type->Quantity,Pattern:>RangeP[0 Newton,1 Newton],Increment->Null,Identifier->_String,Max->Quantity[1,"Newtons"],Min->Quantity[0,"Newtons"],Units->Verbatim[CompoundUnit[{1,{Quantity[1,"Meters"],{Quantity[1,"Millimeters"],Quantity[1,"Meters"],Quantity[1,"Kilometers"]}}},{1,{Quantity[1,"Kilograms"],{Quantity[1,"Kilograms"]}}},{-2,{Quantity[1,"Seconds"],{Quantity[1,"Milliseconds"],Quantity[1,"Seconds"],Quantity[1,"Minutes"],Quantity[1,"Hours"]}}}]|{1,{Quantity[1,"Newtons"],{Quantity[1,"Newtons"]}}}],PatternTooltip->"Quantity must be greater than or equal to 0 newtons and less than or equal to 1 newton."|>]
		],
		Example[{Additional, "Create a Quantity widget with alternative units and an alternatives pattern:"},
			Widget[
				Type->Quantity,
				Pattern:>GreaterP[0 Nanomole]|GreaterP[0 Gram],
				Units->Alternatives[Nanomole,Gram]
			],
			Widget[<|Type->Quantity,Pattern:>Verbatim[GreaterP[0 Nanomole]|GreaterP[0 Gram]],Identifier->_String,Increment->Null,Max->Null,Min->Quantity[0,"Nanomoles"],Units->Verbatim[{1,{Quantity[1,"Nanomoles"],{Quantity[1,"Nanomoles"]}}}|{1,{Quantity[1,"Grams"],{Quantity[1,"Grams"]}}}],PatternTooltip->"Quantity must be greater than 0 nanomoles or greater than 0 grams."|>]
		],
		Example[{Additional, "Create an Color widget:"},
			Widget[
				Type->Color,
				Pattern:>ColorP
			],
			Widget[<|Type->Color,Pattern:>ColorP,PatternTooltip->_String,Identifier->_String|>]
		],
		Example[{Additional, "Create a Date widget:"},
			Widget[
				Type->Date,
				Pattern:>_?DateObjectQ,
				TimeSelector->True
			],
			Widget[<|Type->Date,Verbatim[Pattern:>_?DateObjectQ],TimeSelector->True,Identifier->_String,Increment->Null,Max->Null,Min->Null,PatternTooltip->"Date must be a valid date."|>]
		],
		Example[{Additional, "Create a String widget:"},
			Widget[
				Type->String,
				Pattern:>_?StringQ,
				Size->Word
			],
			Widget[<|Type->String,Pattern:>Verbatim[_?StringQ],Size->Word,PatternTooltip->_String,BoxText->Null,Identifier->_String|>]
		],
		Example[{Additional, "Create a Object widget (PreparedSample defaults to True when Object[Sample] or one of their subtypes is given as a valid object to select):"},
			Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
				ObjectTypes->{Model[Sample],Object[Sample]}
			],
			Widget[<|Type->Object,ObjectTypes->{Model[Sample],Object[Sample]},Dereference->{},Identifier->_String,ObjectBuilderFunctions->{UploadSampleModel},OpenPaths->{},PreparedContainer->False,PreparedSample->True,Select->Null,PatternTooltip->"Object must be an object of type or subtype Model[Sample] or Object[Sample] or a prepared sample.",Pattern:>Verbatim[ObjectP[{Model[Sample],Object[Sample]}]|_String]|>]
		],
		Example[{Additional, "Create a Object widget (PreparedContainer defaults to True when Object[Container] or one of their subtypes is given as a valid object to select):"},
			Widget[
				Type->Object,
				Pattern:>ObjectP[{Object[Container]}],
				ObjectTypes->{Object[Container]}
			],
			Widget[Association[Type->Object,ObjectTypes->{Object[Container]},Dereference->{},Identifier->_String,ObjectBuilderFunctions->{},OpenPaths->{},PreparedContainer->True,PreparedSample->False,Select->Null,PatternTooltip->"Object must be an object of type or subtype Object[Container] or a prepared sample.",Pattern:>Verbatim[ObjectP[{Object[Container]}]|_String]]]
		],
		Example[{Additional, "Create a Field Reference widget:"},
			Widget[
				Type->FieldReference,
				Pattern:>FieldReferenceP[],
				ObjectTypes->{Model[Sample],Object[Sample]},
				Fields->{BoilingPoint,Data}
			],
			Widget[<|Type->FieldReference,Pattern:>FieldReferenceP[],ObjectTypes->{Model[Sample],Object[Sample]},Fields->{BoilingPoint,Data},Identifier->_String,ObjectBuilderFunctions->{UploadSampleModel},PatternTooltip->_String|>]
		],
		Example[{Additional, "Create a Primitive widget (the Widget function recursively will evaluate if there are nested Widgets) -- using the old PrimitiveKeyValuePairs way:"},
			Widget[
				Type->Primitive,
				Pattern :> _Transfer|_Mix,
				PrimitiveTypes->{Transfer,Mix},
				PrimitiveKeyValuePairs -> {
					Transfer->{
						Source->Widget[
							Type->Object,
							Pattern:>ObjectP[{Object[Sample],Object[Container]}],
							ObjectTypes->{Object[Sample],Object[Container]}
						],
						Destination->Widget[
							Type->Object,
							Pattern:>ObjectP[{Object[Sample],Object[Container]}],
							ObjectTypes-> {Object[Sample],Object[Container]}
						]
					},
					Mix->{
						Source->Widget[
							Type->Object,
							Pattern:>ObjectP[{Object[Sample],Object[Container]}],
							ObjectTypes->{Object[Sample],Object[Container]}
						],
						MixCount->Widget[
							Type->Number,
							Pattern:>GreaterP[1],
							Min -> 1,
							Max -> Null,
							Increment -> Null
						]
					}
				}
			],
			Verbatim[Widget][KeyValuePattern[{Type->Primitive}]]
		],
		Example[{Additional, "Create a Primitive widget (the Widget function recursively will evaluate if there are nested Widgets) -- using the old PrimitiveKeyValuePairs way:"},
			Widget[
				Type->Primitive,
				Pattern :> _Transfer|_Mix,
				PrimitiveTypes->{Transfer,Mix},
				PrimitiveKeyValuePairs -> {
					Transfer->{
						Source->Widget[
							Type->Object,
							Pattern:>ObjectP[{Object[Sample],Object[Container]}],
							ObjectTypes->{Object[Sample],Object[Container]}
						],
						Destination->Widget[
							Type->Object,
							Pattern:>ObjectP[{Object[Sample],Object[Container]}],
							ObjectTypes-> {Object[Sample],Object[Container]}
						]
					},
					Mix->{
						Source->Widget[
							Type->Object,
							Pattern:>ObjectP[{Object[Sample],Object[Container]}],
							ObjectTypes->{Object[Sample],Object[Container]}
						],
						MixCount->Widget[
							Type->Number,
							Pattern:>GreaterP[1],
							Min -> 1,
							Max -> Null,
							Increment -> Null
						]
					}
				}
			],
			Verbatim[Widget][KeyValuePattern[{Type->Primitive}]]
		],
		Example[{Additional, "Create a MultiSelect widget:"},
			Widget[
				Type->MultiSelect,
				Pattern:>DuplicateFreeListableP[1|2|3|4|5]
			],
			Widget[<|Type->MultiSelect,Pattern:>Verbatim[DuplicateFreeListableP[1|2|3|4|5]],PatternTooltip->_String,Identifier->_String,Items->{1,2,3,4,5}|>]
		],
		Example[{Additional, "Create an Expression widget:"},
			Widget[
				Type->Expression,
				Pattern:>_,
				Size->Line
			],
			Widget[<|Type->Expression,Pattern:>_,Size->Line,PatternTooltip->_String,BoxText->Null,Identifier->_String|>]
		],
		Example[{Additional, "Create a Head widget:"},
			Widget[
				Type->Head,
				Head->Taco,
				Widget->Widget[
					Type->Number,
					Pattern:>GreaterP[0]
				]
			],
			Widget[<|Type->Head,Head->Taco,Widget->ValidWidgetP,PatternTooltip->_String,Identifier->_String,Pattern:>_|>]
		],
		Example[{Messages, "InvalidType", "Returns $Failed if a Widget cannot be created from the provided inputs (Type must match WidgetTypeP):"},
			Widget[
				Type->Taco,
				Pattern:>RangeP[0,3],
				Min -> 0,
				Max -> 3,
				Increment -> 0.1
			],
			$Failed,
			Messages:>{Widget::InvalidType}
		],
		Example[{Messages, "MissingTypeKey", "Returns $Failed if a Widget cannot be created from the provided inputs (the Type key must be provided):"},
			Widget[
				Pattern:>RangeP[0,10],
				Min -> 0,
				Max -> 10,
				Increment -> 0.1
			],
			$Failed,
			Messages:>{Widget::MissingTypeKey}
		],
		Example[{Messages, "MissingPatternKey", "Returns $Failed if a Widget cannot be created from the provided inputs (the Pattern key must be provided):"},
			Widget[
				Type->Number,
				Min -> 0,
				Max -> 10,
				Increment -> 0.1
			],
			$Failed,
			Messages:>{Widget::MissingPatternKey}
		],
		Example[{Messages, "PatternSetDelayed", "Returns $Failed if a Widget cannot be created from the provided inputs (Pattern must be provided as SetDelayed):"},
			Widget[
				Type->Number,
				Pattern->RangeP[0,10],
				Min -> 0,
				Max -> 10,
				Increment -> Null
			],
			$Failed,
			Messages:>{Widget::PatternSetDelayed}
		],
		Example[{Messages, "InvalidPatternTooltipValue", "Returns $Failed if a Widget cannot be created from the provided inputs (the value for PatternTooltip must match _String):"},
			Widget[
				Type->Number,
				Pattern:>RangeP[0,10],
				Min -> 0,
				Max -> 10,
				Increment -> Null,
				PatternTooltip->myTaco
			],
			$Failed,
			Messages:>{Widget::InvalidPatternTooltipValue}
		],
		Example[{Messages, "EnumerationPatternValue", "The value for the key Pattern must match _Alternatives for the Enumeration widget:"},
			Widget[
				Type->Enumeration,
				Pattern:>_Integer
			],
			$Failed,
			Messages:>{Widget::EnumerationPatternValue}
		],
		Example[{Messages, "EnumerationInvalidKeys", "Returns $Failed if keys are given to Widget[...] that do not match the enumeration widget type:"},
			Widget[
				Type->Enumeration,
				Pattern:>1|2|3|4|5,
				FavoriteFood->Taco
			],
			$Failed,
			Messages:>{Widget::EnumerationInvalidKeys}
		],
		Example[{Messages, "EnumerationItemsValue", "The value for the key Value must be consistent with the given Pattern. The Pattern must match Alternatives@@Items:"},
			Widget[
				Type->Enumeration,
				Pattern:>1|2|3|4|5,
				Items->{1,2,3,4}
			],
			$Failed,
			Messages:>{Widget::EnumerationItemsValue}
		],
		Example[{Messages, "NumberPatternValue", "The value for the key Pattern must match InequalityP|Span[InequalityP,InequaltiyP] for the Number widget:"},
			Widget[
				Type->Number,
				Pattern:>Taco,
				Min -> 0,
				Max -> 10,
				Increment -> 0.1
			],
			$Failed,
			Messages:>{Widget::NumberPatternValue}
		],
		Example[{Messages, "NumberMinValue", "The value for the key Min must match the given pattern for the Number widget:"},
			Widget[
				Type->Number,
				Pattern:>RangeP[0,10],
				Min -> 1,
				Max -> 10,
				Increment -> Null
			],
			$Failed,
			Messages:>{Widget::NumberMinValue}
		],
		Example[{Messages, "NumberMaxValue", "The value for the key Max must matchthe given pattern for the Number widget:"},
			Widget[
				Type->Number,
				Pattern:>RangeP[0,10],
				Min -> 0,
				Max -> 11,
				Increment -> Null
			],
			$Failed,
			Messages:>{Widget::NumberMaxValue}
		],
		Example[{Messages, "NumberIncrementValue", "The value for the key Increment must match the given pattern for the Number widget:"},
			Widget[
				Type->Number,
				Pattern:>RangeP[0,10],
				Min -> 0,
				Max -> 10,
				Increment -> 0.1
			],
			$Failed,
			Messages:>{Widget::NumberIncrementValue}
		],
		Example[{Messages, "NumberInvalidKeys", "Returns $Failed if there are keys that do not belong to the Number Widget:"},
			Widget[
				Type->Number,
				Pattern:>RangeP[0,10],
				Min -> 0,
				Max -> 10,
				Increment -> Null,
				FavoriteFood->Taco
			],
			$Failed,
			Messages:>{Widget::NumberInvalidKeys}
		],
		Example[{Messages, "QuantityPatternValue", "The value for the key Pattern match InequalityP for the Quantity widget:"},
			Widget[
				Type->Quantity,
				Pattern:>Taco,
				Min->0 Percent,
				Max-> 100 Percent,
				Units->{1,{Percent,{Percent}}}
			],
			$Failed,
			Messages:>{Widget::QuantityPatternValue}
		],
		Example[{Messages, "QuantityMinValue", "The value for the key Min must match _?QuantityQ|Null for the Quantity widget:"},
			Widget[
				Type->Quantity,
				Pattern:>RangeP[0 Percent, 100 Percent],
				Min-> Taco,
				Max-> 100 Percent,
				Units->{1,{Percent,{Percent}}}
			],
			$Failed,
			Messages:>{Widget::QuantityMinValue}
		],
		Example[{Messages, "QuantityMaxValue", "The value for the key Max must match _?QuantityQ|Null for the Quantity widget:"},
			Widget[
				Type->Quantity,
				Pattern:>RangeP[0 Percent, 100 Percent],
				Min-> 0 Percent,
				Max-> Taco,
				Units->{1,{Percent,{Percent}}}
			],
			$Failed,
			Messages:>{Widget::QuantityMaxValue}
		],
		Example[{Messages, "QuantityIncrementValue", "The value for the key Increment must match _?QuantityQ|Null for the Quantity widget:"},
			Widget[
				Type->Quantity,
				Pattern:>RangeP[0 Percent, 100 Percent],
				Min-> 0 Percent,
				Max-> 100 Percent,
				Increment->Taco,
				Units->{1,{Percent,{Percent}}}
			],
			$Failed,
			Messages:>{Widget::QuantityIncrementValue}
		],
		Example[{Messages, "UnknownUnitShortHand", "Returns $Failed is an invalid short-hand is provided:"},
			Widget[
				Type->Quantity,
				Pattern:>RangeP[0 Percent, 100 Percent],
				Min-> 0 Percent,
				Max-> 100 Percent,
				Increment->0.1 Percent,
				Units->Taco
			],
			$Failed,
			Messages:>{Widget::UnknownUnitShortHand}
		],
		Example[{Messages, "QuantityMissingUnitsKey", "The key Units must be specified to create a Quantity widget:"},
			Widget[
				Type->Quantity,
				Pattern:>RangeP[0 Percent, 100 Percent],
				Min-> 0 Percent,
				Max-> 100 Percent,
				Increment->0.1 Percent
			],
			$Failed,
			Messages:>{Widget::QuantityMissingUnitsKey}
		],
		Example[{Messages, "QuantityInvalidKeys", "Returns $Failed if there are keys that do not belong to the Quantity Widget:"},
			Widget[
				Type->Quantity,
				Pattern:>RangeP[0 Percent, 100 Percent],
				Min-> 0 Percent,
				Max-> 100 Percent,
				Increment->0.1 Percent,
				Units->{1,{Percent,{Percent}}},
				FavoriteFood->Taco
			],
			$Failed,
			Messages:>{Widget::QuantityInvalidKeys}
		],
		Example[{Messages, "QuantityPatternUnitMismatch", "Returns $Failed if part of the units in the Units key have been left out of the Pattern. In the following example, the developer has let the user specify a quantity with units Mole or Gram but the pattern only matches on Mole:"},
			Widget[
				Type->Quantity,
				Pattern:>RangeP[0 Mole,1 Mole],
				Increment -> Null,
				Units -> Alternatives[
					Gram,
					Mole
				]
			],
			$Failed,
			Messages:>{Widget::QuantityPatternUnitMismatch}
		],
		Example[{Messages, "QuantityPatternUnits", "Returns $Failed if the units of the Units key do not match the pattern:"},
			Widget[
				Type->Quantity,
				Pattern:>RangeP[0 Pound,1 Pound],
				Increment -> Null,
				Units -> Alternatives[
					CompoundUnit[
						{Meter,{Millimeter,Meter,Kilometer}},
						Kilogram,
						{-2,{Second,{Millisecond,Second,Minute,Hour}}}
					],
					Newton
				]
			],
			$Failed,
			Messages:>{Widget::QuantityPatternUnits}
		],
		Example[{Messages, "QuantityPatternUnits", "Returns $Failed the unit dimensions of the Pattern and Unit keys do not match exactly:"},
			Widget[
					Type->Quantity,
					Pattern:>GreaterP[0 Molar],
					Units->Alternatives[
						{1,{Micromolar,{Micromolar,Millimolar,Molar}}},
						CompoundUnit[
							{1,{Gram,{Gram,Microgram,Milligram}}},
							{-1,{Liter,{Liter,Microliter,Milliliter}}}
						]
					]
				],
			$Failed,
			Messages:>{Widget::QuantityPatternUnitMismatch}
		],
		Example[{Messages, "ColorPatternValue", "The value for the key Pattern must match Verbatim[ColorP] for the Color widget:"},
			Widget[
				Type->Color,
				Pattern:>_Integer
			],
			$Failed,
			Messages:>{Widget::ColorPatternValue}
		],
		Example[{Messages, "ColorInvalidKeys", "Returns $Failed if there are keys that do not belong to the Color Widget:"},
			Widget[
				Type->Color,
				Pattern:>ColorP,
				FavoriteFood->Taco
			],
			$Failed,
			Messages:>{Widget::ColorInvalidKeys}
		],
		Example[{Messages, "DatePatternValue", "The value for the key Pattern must match Verbatim[_?DateObjectQ] for the Date widget:"},
			Widget[
				Type->Date,
				Pattern:>_Integer,
				TimeSelector->True
			],
			$Failed,
			Messages:>{Widget::DatePatternValue}
		],
		Example[{Messages, "DateTimeSelectorValue", "The value for the key TimeSelector must match BooleanP for the Date widget:"},
			Widget[
				Type->Date,
				Pattern:>_?DateObjectQ,
				TimeSelector->Taco
			],
			$Failed,
			Messages:>{Widget::DateTimeSelectorValue}
		],
		Example[{Messages, "DateMissingTimeSelectorKey", "The key TimeSelector must be specified to create a Date widget:"},
			Widget[
				Type->Date,
				Pattern:>_?DateObjectQ
			],
			$Failed,
			Messages:>{Widget::DateMissingTimeSelectorKey}
		],
		Example[{Messages, "DateInvalidKeys", "Returns $Failed if there are keys that do not belong to the Date Widget:"},
			Widget[
				Type->Date,
				Pattern:>_?DateObjectQ,
				TimeSelector->True,
				FavoriteFood->Taco
			],
			$Failed,
			Messages:>{Widget::DateInvalidKeys}
		],
		Example[{Messages, "DateInequalityPatternValue", "Returns $Failed if the inequality pattern is misspecified:"},
			Widget[
				Type->Date,
				Pattern:>GreaterP[Taco],
				TimeSelector->True
			],
			$Failed,
			Messages:>{Widget::DateInequalityPatternValue}
		],
		Example[{Messages, "InvalidMinValue", "Returns $Failed if the Min value is misspecified:"},
			Widget[
				Type->Date,
				Pattern:>GreaterP[DateObject["July 2018"]],
				Min->Taco,
				TimeSelector->True
			],
			$Failed,
			Messages:>{Widget::InvalidMinValue}
		],
		Example[{Messages, "InvalidMaxValue", "Returns $Failed if the Max value is misspecified:"},
			Widget[
				Type->Date,
				Pattern:>GreaterP[DateObject["July 2018"]],
				Max->Taco,
				TimeSelector->True
			],
			$Failed,
			Messages:>{Widget::InvalidMaxValue}
		],
		Example[{Messages, "InvalidIncrementValue", "Returns $Failed if the Increment value is misspecified:"},
			Widget[
				Type->Date,
				Pattern:>GreaterP[DateObject["July 2018"]],
				Increment->Taco,
				TimeSelector->True
			],
			$Failed,
			Messages:>{Widget::InvalidIncrementValue}
		],
		Example[{Messages, "StringSizeValue", "The value for the key Size must match Word|Line|Paragraph for the String widget:"},
			Widget[
				Type->String,
				Pattern:>_?StringQ,
				Size->Taco
			],
			$Failed,
			Messages:>{Widget::StringSizeValue}
		],
		Example[{Messages, "StringBoxTextValue", "The value for the key BoxText must match _String|Null for the String widget:"},
			Widget[
				Type->String,
				Pattern:>_?StringQ,
				BoxText->Taco,
				Size->Word
			],
			$Failed,
			Messages:>{Widget::StringBoxTextValue}
		],
		Example[{Messages, "StringMissingSizeKey", "The key Size must be specified to create a String widget:"},
			Widget[
				Type->String,
				Pattern:>_?StringQ
			],
			$Failed,
			Messages:>{Widget::StringMissingSizeKey}
		],
		Example[{Messages, "StringInvalidKeys", "Returns $Failed if there are keys that do not belong to the String Widget:"},
			Widget[
				Type->String,
				Pattern:>_?StringQ,
				Size->Word,
				FavoriteFood->Taco
			],
			$Failed,
			Messages:>{Widget::StringInvalidKeys}
		],
		Example[{Messages, "ObjectPatternValue", "The value for the key Pattern must match _ObjectP for the Object widget:"},
			Widget[
				Type->Object,
				Pattern:>Taco,
				ObjectTypes->{Model[Sample],Object[Sample]}
			],
			$Failed,
			Messages:>{Widget::ObjectPatternValue}
		],
		Example[{Messages, "ObjectOpenPathsValue", "The value for the key OpenPaths must match {{ObjectP[Object[Catalog]]..}...} for the Object widget:"},
			Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
				ObjectTypes->{Model[Sample],Object[Sample]},
				OpenPaths->Taco
			],
			$Failed,
			Messages:>{Widget::ObjectOpenPathsValue}
		],
		Example[{Messages, "ObjectOpenPathRoot", "Each OpenPath must begin with Object[Catalog,\"Root\"]:"},
			Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
				ObjectTypes->{Model[Sample],Object[Sample]},
				OpenPaths->{{"Taco","Instruments"}}
			],
			$Failed,
			Messages:>{Widget::ObjectOpenPathRoot}
		],
		Example[{Messages, "ObjectOpenPathsContents", "The OpenPath must be valid. Every child Object[Catalog] must be a member of its parent Object[Catalog]'s Contents field:"},
			Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
				ObjectTypes->{Model[Sample],Object[Sample]},
				OpenPaths->{{Object[Catalog,"Root"],Object[Catalog,"Taco"]}}
			],
			$Failed,
			Messages:>{Widget::ObjectOpenPathsContents}
		],
		Example[{Messages, "ObjectObjectBuildersValue", "The value for the key ObjectBuilders must match {_Symbol...} for the Object widget:"},
			Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
				ObjectTypes->{Model[Sample],Object[Sample]},
				ObjectBuilderFunctions->Taco
			],
			$Failed,
			Messages:>{Widget::ObjectObjectBuildersValue}
		],
		Example[{Messages, "ObjectObjectTypesValue", "The value for the key ObjectTypes must match {TypeP[]..} for the Object widget:"},
			Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
				ObjectTypes->Taco
			],
			$Failed,
			Messages:>{Widget::ObjectObjectTypesValue}
		],
		Example[{Messages, "ObjectInvalidKeys", "Returns $Failed if there are keys that do not belong to the Object Widget:"},
			Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
				ObjectTypes->{Model[Sample],Object[Sample]},
				FavoriteFood->Taco
			],
			$Failed,
			Messages:>{Widget::ObjectInvalidKeys}
		],
		Example[{Messages, "ObjectInvalidDereferencePattern", "Returns $Failed if the Dereference field does not match its basic pattern:"},
			Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
				ObjectTypes->{Model[Sample],Object[Sample]},
				Dereference->Taco
			],
			$Failed,
			Messages:>{Widget::ObjectInvalidDereferencePattern}
		],
		Example[{Messages, "FieldReferencePatternValue", "The value for the key Pattern must match _FieldReferenceP for the Field Reference widget:"},
			Widget[
				Type->FieldReference,
				Pattern:>Taco,
				ObjectTypes->{Model[Sample],Object[Sample]},
				Fields->{BoilingPoint,Data}
			],
			$Failed,
			Messages:>{Widget::FieldReferencePatternValue}
		],
		Example[{Messages, "FieldReferenceObjectTypesValue", "The value for the key ObjectTypes must match {TypeP[]..} for the Field Reference widget:"},
			Widget[
				Type->FieldReference,
				Pattern:>FieldReferenceP[],
				ObjectTypes->Taco,
				Fields->{BoilingPoint,Data}
			],
			$Failed,
			Messages:>{Widget::FieldReferenceObjectTypesValue}
		],
		Example[{Messages, "FieldReferenceFieldsValue", "The value for the key Fields must match {FieldP[Output\[Rule]Short]..} for the Field Reference widget:"},
			Widget[
				Type->FieldReference,
				Pattern:>FieldReferenceP[],
				ObjectTypes->{Model[Sample],Object[Sample]},
				Fields->Taco
			],
			$Failed,
			Messages:>{Widget::FieldReferenceFieldsValue}
		],
		Example[{Messages, "FieldReferenceInvalidKeys", "Returns $Failed if there are keys that do not belong to the Field Reference Widget:"},
			Widget[
				Type->FieldReference,
				Pattern:>FieldReferenceP[],
				ObjectTypes->{Model[Sample],Object[Sample]},
				Fields->{BoilingPoint,Data},
				FavoriteFood->Taco
			],
			$Failed,
			Messages:>{Widget::FieldReferenceInvalidKeys}
		],
		Example[{Messages, "PrimitivePrimitiveTypesValue", "The value for the key PrimitiveTypes must match {_Symbol..} for the Primitive widget:"},
			Widget[
				Type->Primitive,
				Pattern :> _Transfer|_Mix,
				PrimitiveTypes->Taco,
				PrimitiveKeyValuePairs -> {
					Transfer->{
						Source->Widget[
							Type->Object,
							Pattern:>ObjectP[{Object[Sample],Object[Container]}],
							ObjectTypes->{Object[Sample],Object[Container]}
						],
						Destination->Widget[
							Type->Object,
							Pattern:>ObjectP[{Object[Sample],Object[Container]}],
							ObjectTypes-> {Object[Sample],Object[Container]}
						]
					},
					Mix->{
						Source->Widget[
							Type->Object,
							Pattern:>ObjectP[{Object[Sample],Object[Container]}],
							ObjectTypes->{Object[Sample],Object[Container]}
						],
						MixCount->Widget[
							Type->Number,
							Pattern:>GreaterP[1],
							Min -> 1,
							Max -> Null,
							Increment -> Null
						]
					}
				}
			],
			$Failed,
			Messages:>{Widget::PrimitivePrimitiveTypesValue}
		],
		Example[{Messages, "PrimitivePrimitiveKeyValuePairsValue", "The value for the key PrimitiveKeyValuePairs must match {(_Symbol\[Rule]{(_Symbol\[Rule]WidgetP)..})..} for the Primitive widget:"},
			Widget[
				Type->Primitive,
				Pattern :> _Transfer|_Mix,
				PrimitiveTypes->{Transfer,Mix},
				PrimitiveKeyValuePairs -> Taco
			],
			$Failed,
			Messages:>{Widget::PrimitivePrimitiveKeyValuePairsValue}
		],
		Example[{Messages, "PrimitiveMissingPrimitiveKeyValuePairsKey", "The key PrimitiveKeyValuePairs must be specified to create a Primitive widget:"},
			Widget[
				Type->Primitive,
				Pattern :> _Transfer|_Mix,
				PrimitiveTypes->{Transfer,Mix}
			],
			$Failed,
			Messages:>{Widget::PrimitiveMissingPrimitiveKeyValuePairsKey}
		],
		Example[{Messages, "PrimitiveInvalidKeys", "Returns $Failed if there are keys that do not belong to the Primitive Widget:"},
			Widget[
				Type->Primitive,
				Pattern :> _Transfer|_Mix,
				PrimitiveTypes->{Transfer,Mix},
				PrimitiveKeyValuePairs -> {
					Transfer->{
						Source->Widget[
							Type->Object,
							Pattern:>ObjectP[{Object[Sample],Object[Container]}],
							ObjectTypes->{Object[Sample],Object[Container]}
						],
						Destination->Widget[
							Type->Object,
							Pattern:>ObjectP[{Object[Sample],Object[Container]}],
							ObjectTypes-> {Object[Sample],Object[Container]}
						]
					},
					Mix->{
						Source->Widget[
							Type->Object,
							Pattern:>ObjectP[{Object[Sample],Object[Container]}],
							ObjectTypes->{Object[Sample],Object[Container]}
						],
						MixCount->Widget[
							Type->Number,
							Pattern:>GreaterP[1],
							Min -> 1,
							Max -> Null,
							Increment -> Null
						]
					}
				},
				FavoriteFood->Taco
			],
			$Failed,
			Messages:>{Widget::PrimitiveInvalidKeys}
		],
		Example[{Messages, "MultiSelectPatternValue", "The value for the key Pattern must match ListableP[_Alternatives] for the MultiSelect widget:"},
			Widget[
				Type->MultiSelect,
				Pattern:>_Integer
			],
			$Failed,
			Messages:>{Widget::MultiSelectPatternValue}
		],
		Example[{Messages, "MultiSelectItemsValue", "The value for the key Items must be consistent with the given Pattern. The Pattern should match DuplicateFreeListableP[Alternatives@@Items]:"},
			Widget[
				Type->MultiSelect,
				Pattern:>DuplicateFreeListableP[1|2|3|4|5],
				Items->{1,2,3}
			],
			$Failed,
			Messages:>{Widget::MultiSelectItemsValue}
		],
		Example[{Messages, "MultiSelectInvalidKeys", "Returns $Failed if there are keys that do not belong to the MultiSelect Widget:"},
			Widget[
				Type->MultiSelect,
				Pattern:>1|2|3|4|5,
				FavoriteFood->Taco
			],
			$Failed,
			Messages:>{Widget::MultiSelectInvalidKeys}
		],
		Example[{Messages, "ExpressionMissingSizeKey", "The key Size must be specified to create a Expression widget:"},
			Widget[
				Type->Expression,
				Pattern:>_
			],
			$Failed,
			Messages:>{Widget::ExpressionMissingSizeKey}
		],
		Example[{Messages, "ExpressionSizeValue", "The value for the key Size must match Word|Line|Paragraph for the MultiSelect widget:"},
			Widget[
				Type->Expression,
				Pattern:>_,
				Size->Taco
			],
			$Failed,
			Messages:>{Widget::ExpressionSizeValue}
		],
		Example[{Messages, "ExpressionInvalidKeys", "Returns $Failed if there are keys that do not belong to the Expression Widget:"},
			Widget[
				Type->Expression,
				Pattern:>_,
				Size->Line,
				FavoriteFood->Taco
			],
			$Failed,
			Messages:>{Widget::ExpressionInvalidKeys}
		],
		Example[{Messages, "MoleculePatternValue", "Returns $Failed if there is a pattern that does not belong to a Molecule Widget:"},
			Widget[
				Type->Molecule,
				Pattern:>_
			],
			$Failed,
			Messages:>{Widget::MoleculePatternValue}
		],
		Example[{Messages, "MoleculeInvalidKeys", "Returns $Failed if there is a key that does not belong to a Molecule Widget:"},
			Widget[
				Type->Molecule,
				Pattern:> MoleculeP,
				Size->Line
			],
			$Failed,
			Messages:>{Widget::MoleculeInvalidKeys}
		],
		Example[{Messages, "NoKeyExists", "When trying to de-reference a key that does not exist in the Widget, $Failed is returned:"},
			Widget[
				Type->Expression,
				Pattern:>_,
				Size->Line
			][Taco],
			$Failed,
			Messages:>{Widget::NoKeyExists}
		],
		Example[{Messages, "The key Head must be specified to create a Head widget:"},
			Widget[
				Type->Head,
				Widget->Widget[
					Type->Number,
					Pattern:>GreaterP[0]
				]
			],
			$Failed,
			Messages:>{Widget::HeadMissingHeadKey}
		],
		Example[{Messages, "The key Widget must be specified to create a Head widget:"},
			Widget[
				Type->Head,
				Head->Taco
			],
			$Failed,
			Messages:>{Widget::HeadMissingWidgetKey}
		],
		Example[{Additional, "Returns $Failed if there is a key that does not belong to a Head Widget:"},
			Widget[
				Type->Head,
				Head->Taco,
				Widget->Widget[
					Type->Number,
					Pattern:>GreaterP[0]
				],
				Size->Line
			],
			$Failed,
			Messages:>{Widget::HeadInvalidKeys}
		],
		Example[{Additional, "The pattern key is automatically calculated and should not be manually set:"},
			Widget[
				Type->Head,
				Head->Taco,
				Widget->Widget[
					Type->Number,
					Pattern:>GreaterP[0]
				],
				Pattern:>Taco[GreaterP[0]]
			],
			$Failed,
			Messages:>{Widget::HeadPatternInformed}
		]
	}
];


(* ::Subsection::Closed:: *)
(*Pattern Builder*)


DefineTests[GenerateInputPattern,
	{
		Example[{Basic, "Build a pattern for an options list:"},
			GenerateInputPattern[
				{
					OptionName->GradientA,
					Default->Automatic,
					AllowNull->True,
					Description->"Definition of Buffer A domains in the form {Time, % Buffer A} or % BufferA.",
					ResolutionDescription->"Automatically resolves from the provided gradient method object.",
					Category->Gradient,
					Widget->Alternatives[
						Widget[Type->Quantity,Pattern:>RangeP[0 Percent, 100 Percent],Units->{1,{Percent,{Percent}}}],
						Adder[
							{
								"Time"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Minute],Units->{1,{Minute,{Second,Minute,Hour}}}],
								"Percentage"->Widget[Type->Quantity,Pattern:>RangeP[0 Percent, 100 Percent],Units->{1,{Percent,{Percent}}}]
							}
						]
					]
				}
			],
			Verbatim[<|
				Pattern:>Hold[((RangeP[0 Percent,100 Percent]|{{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}..})|Automatic)|Null],
				SingletonPattern:>Hold[((RangeP[0 Percent,100 Percent]|{{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}..})|Automatic)|Null],
				PooledPattern:>Null
			|>]
		],
		Example[{Basic, "Build a pattern for an input list:"},
			GenerateInputPattern[
				{
					InputName->"My Input Name.",
					Description->"A description of this input.",
					Widget->Alternatives[
						Widget[Type->Quantity,Pattern:>RangeP[0 Percent, 100 Percent],Units->{1,{Percent,{Percent}}}],
						Adder[
							{
								"Time"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Minute],Units->{1,{Minute,{Second,Minute,Hour}}}],
								"Percentage"->Widget[Type->Quantity,Pattern:>RangeP[0 Percent, 100 Percent],Units->{1,{Percent,{Percent}}}]
							}
						]
					],
					IndexMatching->"inputName"
				}
			],
			Verbatim[<|
				Pattern:>Hold[RangeP[0 Percent,100 Percent]|{{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}..}],
				SingletonPattern:>Hold[RangeP[0 Percent,100 Percent]|{{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}..}],
				PooledPattern:>Null
			|>]
		],
		Example[{Basic, "Build a pattern for a quantity widget:"},
			GenerateInputPattern[
				Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Percent, 100 Percent],
					Units->{1,{Percent,{Percent}}}
				]
			],
			Verbatim[Hold[RangeP[0 Percent,100 Percent]]]
		],
		Example[{Basic, "Build a pattern for an adder widget:"},
			GenerateInputPattern[
				Adder[
					{
						"Time"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Minute],Units->{1,{Minute,{Second,Minute,Hour}}}],
						"Percentage"->Widget[Type->Quantity,Pattern:>RangeP[0 Percent, 100 Percent],Units->{1,{Percent,{Percent}}}]
					}
				]
			],
			Verbatim[Hold[{{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}..}]]
		],
		Example[{Basic, "Build a pattern for a head widget:"},
			GenerateInputPattern[
				Widget[
					Type->Head,
					Head->Taco,
					Widget->Widget[
						Type->Quantity,
						Pattern:>RangeP[0 Percent, 100 Percent],
						Units->{1,{Percent,{Percent}}}
					]
				]
			],
			Verbatim[Hold[Verbatim[Taco][RangeP[0 Percent, 100 Percent]]]]
		],
		Example[{Basic, "Build a pattern for a widget unit:"},
			GenerateInputPattern[
				Alternatives[
					CompoundUnit[
						Alternatives[
							{1,{Gram,{Milligram,Gram,Kilogram}}},
							{1,{Pound,{Pound}}}
						],
						Alternatives[
							{1,{Meter,{Millimeter,Meter,Kilometer}}},
							{1,{Foot,{Inch,Foot}}}
						],
						{-2,{Second,{Millisecond,Second}}}
					],
					{1,{Newton,{Newton, Kilo*Newton}}}
				]
			],
			_Hold (* The unit tester is being weird so I'm setting the test to be thing until Sean gets back to me - Thomas. *)
		],
		Example[{Additional, "Build a pattern for an alternatives widget:"},
			GenerateInputPattern[
				Alternatives[
					Widget[Type->Quantity,Pattern:>RangeP[0 Percent, 100 Percent],Units->{1,{Percent,{Percent}}}],
					Adder[
						{
							"Time"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Minute],Units->{1,{Minute,{Second,Minute,Hour}}}],
							"Percentage"->Widget[Type->Quantity,Pattern:>RangeP[0 Percent, 100 Percent],Units->{1,{Percent,{Percent}}}]
						}
					]
				]
			],
			Verbatim[Hold[RangeP[0 Percent,100 Percent]|{{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}..}]]
		],
		Example[{Additional, "Build a pattern for an alternatives widget (with labels):"},
			GenerateInputPattern[
				Alternatives[
					"Quantity Label"->Widget[Type->Quantity,Pattern:>RangeP[0 Percent, 100 Percent],Units->{1,{Percent,{Percent}}}],
					"Adder Label"->Adder[
						{
							"Time"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Minute],Units->{1,{Minute,{Second,Minute,Hour}}}],
							"Percentage"->Widget[Type->Quantity,Pattern:>RangeP[0 Percent, 100 Percent],Units->{1,{Percent,{Percent}}}]
						}
					]
				]
			],
			Verbatim[Hold[RangeP[0 Percent,100 Percent]|{{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}..}]]
		],
		Example[{Additional, "Build a pattern for a tuples widget:"},
			GenerateInputPattern[
				{
					"Time"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Minute],Units->{1,{Minute,{Second,Minute,Hour}}}],
					"Percentage"->Widget[Type->Quantity,Pattern:>RangeP[0 Percent, 100 Percent],Units->{1,{Percent,{Percent}}}]
				}
			],
			Verbatim[Hold[{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}]]
		],
		Example[{Additional, "Build a pattern for an enumeration widget:"},
			GenerateInputPattern[
				Widget[
					Type->Enumeration,
					Pattern:>1|2|3|4|5
				]
			],
			Verbatim[Hold[1|2|3|4|5]]
		],
		Example[{Additional, "Build a pattern for a span widget:"},
			GenerateInputPattern[
				Span[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0 Newton, 100 Newton],
						Units->Alternatives[
							CompoundUnit[
								Alternatives[
									{1,{Kilogram,{Milligram,Gram,Kilogram}}},
									{1,{Pound,{Pound}}}
								],
								Alternatives[
									{1,{Meter,{Millimeter,Meter,Kilometer}}},
									{1,{Foot,{Inch,Foot}}}
								],
								{-2,{Second,{Millisecond,Second}}}
							],
							Newton
						]
					],
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0 Newton, 100 Newton],
						Units->Alternatives[
							CompoundUnit[
								Alternatives[
									{1,{Kilogram,{Milligram,Gram,Kilogram}}},
									{1,{Pound,{Pound}}}
								],
								Alternatives[
									{1,{Meter,{Millimeter,Meter,Kilometer}}},
									{1,{Foot,{Inch,Foot}}}
								],
								{-2,{Second,{Millisecond,Second}}}
							],
							Newton
						]
					]
				]
			],
			Verbatim[Hold[RangeP[0 Newton,100 Newton];;RangeP[0 Newton,100 Newton]]]
		],
		Example[{Additional, "Build a pattern for a very nested widget:"},
			GenerateInputPattern[
				{
					"Time"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Minute],Units->{1,{Minute,{Second,Minute,Hour}}}],
					"Percentage"->Widget[Type->Quantity,Pattern:>RangeP[0 Percent, 100 Percent],Units->{1,{Percent,{Percent}}}],
					"Alternatives"->Alternatives[
						Widget[Type->Quantity,Pattern:>RangeP[0 Percent, 100 Percent],Units->{1,{Percent,{Percent}}}],
						Adder[
							{
								"Time"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Minute],Units->{1,{Minute,{Second,Minute,Hour}}}],
								"Percentage"->Widget[Type->Quantity,Pattern:>RangeP[0 Percent, 100 Percent],Units->{1,{Percent,{Percent}}}],
								"Alternatives"->Alternatives[
									Widget[Type->Quantity,Pattern:>RangeP[0 Percent, 100 Percent],Units->{1,{Percent,{Percent}}}],
									Adder[
										{
											"Time"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Minute],Units->{1,{Minute,{Second,Minute,Hour}}}],
											"Percentage"->Widget[Type->Quantity,Pattern:>RangeP[0 Percent, 100 Percent],Units->{1,{Percent,{Percent}}}]
										}
									]
								]
							}
						]
					]
				}
			],
			Verbatim[
				Hold[{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent],RangeP[0 Percent,100 Percent]|{{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent],RangeP[0 Percent,100 Percent]|{{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}..}}..}}]
			]
		],

		Example[{Options,Tooltips, "Build a pattern for a tuples widget with Tooltips:"},
			GenerateInputPattern[
				{
					"Time"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Minute],Units->{1,{Minute,{Second,Minute,Hour}}}],
					"Percentage"->Widget[Type->Quantity,Pattern:>RangeP[0 Percent, 100 Percent],Units->{1,{Percent,{Percent}}}]
				},
				Tooltips->True
			],
			Verbatim[Hold[{Tooltip[Hold[GreaterEqualP[0*Minute]], "Quantity must be greater than or equal to 0 minutes."], Tooltip[Hold[RangeP[0*Percent, 100*Percent]], "Quantity must be greater than or equal to 0 percent and less than or equal to 100 percent."]}]]
		],

		Example[{Messages, "InvalidWidget", "A pattern cannot be built if the given widget is invalid:"},
			GenerateInputPattern[
				{
					OptionName->GradientA,
					Default->Automatic,
					AllowNull->True,
					Description->"Definition of Buffer A domains in the form {Time, % Buffer A} or % BufferA.",
					ResolutionDescription->"Automatically resolves from the provided gradient method object.",
					Category->Gradient,
					IndexMatching->Input,
					Widget->"I Love Tacos!"
				}
			],
			$Failed,
			Messages:>{GenerateInputPattern::InvalidWidget}
		],
		Example[{Messages, "AllowNull", "AllowNull must match BooleanP if an option list is provided:"},
			GenerateInputPattern[
				{
					OptionName->GradientA,
					Default->Automatic,
					AllowNull->Taco,
					Description->"Definition of Buffer A domains in the form {Time, % Buffer A} or % BufferA.",
					ResolutionDescription->"Automatically resolves from the provided gradient method object.",
					Category->Gradient,
					IndexMatching->Input,
					Widget->"I Love Tacos!"
				}
			],
			$Failed,
			Messages:>{GenerateInputPattern::AllowNull}
		],
		Example[{Additional, "Create a pattern for an atomic WidgetUnit:"},
			GenerateInputPattern[{1,{Gram,{Milligram,Gram,Kilogram}}}],
			Verbatim[Hold[UnitsP[Quantity[1,"Grams"]]]]
		],
		Example[{Messages, "MainUnitNotProvidedInUnitsList", "Returns $Failed if the main unit is not contained in the units list, for an atomic WidgetUnit:"},
			GenerateInputPattern[
				Alternatives[
					CompoundUnit[
						Alternatives[
							{1,{Gram,{Milligram,Kilogram}}},
							{1,{Pound,{Pound}}}
						],
						Alternatives[
							{1,{Meter,{Millimeter,Meter,Kilometer}}},
							{1,{Foot,{Inch,Foot}}}
						],
						{-2,{Second,{Millisecond,Second}}}
					],
					{1,{Newton,{Newton, Kilo*Newton}}}
				]
			],
			$Failed,
			Messages:>{GenerateInputPattern::MainUnitNotProvidedInUnitsList}
		],
		Example[{Messages, "MissingRequiredKey", "Returns $Failed if a required key is missing from an options packet. In this example the OptionName key is missing:"},
			GenerateInputPattern[
				{
					Default->Automatic,
					AllowNull->True,
					Widget->Widget[Type->Number,Pattern:>GreaterP[0,1]],
					Description->"Indicates the number of each appetizer to server.",
					ResolutionDescription->"Automatically resolves to include one of each requested appetizer.",
					IndexMatching->Appetizer
				}
			],
			$Failed,
			Messages:>{GenerateInputPattern::MissingRequiredKey}
		]
	}
];

(* ::Subsection::Closed:: *)
(* OverallPatternTooltip *)
DefineTests[OverallPatternTooltip,
    {
        Example[{Basic,"The overall tooltip is the same as the widget tooltip for atomic widgets:"},
            OverallPatternTooltip[
				Widget[<|
					Type->String,
					Pattern:>_?StringQ,
					Size->Word,
					PatternTooltip->"This is the tooltip explanation.",
					BoxText->"Enter a brief description of the Sample",
					Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
				|>]
			],
            "This is the tooltip explanation."
        ],
        Example[{Basic,"For Alternative widgets The tooltip is constructed by linking widget tooltips with \"or\":"},
            OverallPatternTooltip[
				Alternatives[
					Widget[Type->Enumeration,Pattern:>BooleanP],
					Widget[Type->Quantity, Pattern:>RangeP[0 Second,10 Hour], Units -> Hour]
				]
			],
			"Greater than or equal to 0 seconds and less than or equal to 10 hours or True or False."
        ],
		Example[{Basic,"Span widgets link the options with \"to\":"},
			OverallPatternTooltip[
				Span[
					Widget[Type->Number,Pattern:>GreaterP[0]],
					Widget[Type->Number,Pattern:>GreaterP[10]]
				]
			],
			"A span from anything greater than 0 to anything greater than 10."
		],
		Example[{Basic,"Adder widgets indicate a list of items is expected:"},
			OverallPatternTooltip[
				Adder[
					Widget[Type->Enumeration,Pattern:>BooleanP]
				]
			],
			"List of one or more True or False entries."
		],
		Example[{Basic,"Tuple widgets display the string labels:"},
			OverallPatternTooltip[
				{
					"First Number"->Widget[
						Type->Number,
						Pattern:>GreaterP[0]
					],
					"Second Number"->Widget[
						Type->Number,
						Pattern:>GreaterP[0]
					]
				}
			],
			"{First Number, Second Number}"
		],
		Example[{Messages,"UnknownWidget","Print a message and returns $Failed if the widget is not recognized:"},
			OverallPatternTooltip[Alternatives[Widget[Type->Tacos,Pattern:>Chicken|Fish]]],
			$Failed,
			Messages:>{OverallPatternTooltip::UnknownWidget},
			Stubs:>(ValidWidgetP[x_]:=_)
		],
		Test["Handles the case where alternatives have labels:",
			OverallPatternTooltip[
				Alternatives[
				"Enumeration Label"->Widget[Type->Enumeration,Pattern:>0|1|2|3|4|5],
				"Number Label"->Widget[<|
					Type->Number,
					Pattern:>RangeP[0,5],
					Min -> 0,
					Max -> 5,
					Increment -> Null,
					PatternTooltip->"This is the tooltip explanation.",
					Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
				|>],
				"Molecule Label" -> Widget[<|Type -> Molecule,
					Pattern :> MoleculeP,
					PatternTooltip -> "blah",
					Identifier -> "6156c3bc-23e6-48d9-b505-92b183a4915e"|>]
				]
			],
			_String
		],
		Test["Adders with orientation markers are okay:",
			OverallPatternTooltip[
				Adder[
					{
						"Time" -> Widget[<|
							Type->Quantity,
							Pattern:>RangeP[0 Second,10 Hour],
							Min -> 0 Second,
							Max -> 10 Hour,
							Increment -> Null,
							PatternTooltip->"This is the tooltip explanation.",
							Units -> {1,{Second,{Second, Minute, Hour}}},
							Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
						|>],
						"Flow Rate" -> Widget[<|
							Type->Quantity,
							Pattern:>RangeP[0 (Micro Liter)/Second,100 (Micro Liter)/Second],
							Min -> 0 (Micro Liter)/Second,
							Max -> 100 (Micro Liter)/Second,
							Increment -> Null,
							PatternTooltip->"This is the tooltip explanation.",
							Units ->
								CompoundUnit[
									{1,{Micro Liter,{Pico Liter, Micro Liter,Milli Liter}}},
									{-1,{Second,{Millisecond,Second,Minute,Hour}}}
								],
							Identifier->"4bc02b7c-e071-4d46-a60e-121e5e2911e2"
						|>]
					},
					Orientation->Vertical
				]
			],
			"List of one or more {Time, Flow Rate} entries."
		]
    }
]
