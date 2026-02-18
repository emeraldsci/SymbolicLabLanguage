(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Title:: *)
(*Verbose: Tests*)


(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)

(* ::Subsection::Closed:: *)
(*FirstOrDefault*)

DefineTests[
	FirstOrDefault,
	{
		Example[{Basic,"Returns the first element of a list:"},
			FirstOrDefault[{1,2,3}],
			1
		],

		Example[{Basic,"Returns Null if expression is of length 0 and no default value given:"},
			FirstOrDefault[{}],
			Null
		],

		Example[{Basic,"Returns default value if expression is of length 0:"},
			FirstOrDefault[{},2000],
			2000
		],

		Example[{Additional,"Operates on the Values of Associations:"},
			FirstOrDefault[<|1->2,4->6|>],
			2
		],

		Example[{Additional,"Operates on arbitrary expressions:"},
			FirstOrDefault[Taco[1,2,3]],
			1
		],

		Test["Does not throw a message is given an Atom:",
			FirstOrDefault[1,20],
			20
		]
	}
];

(* ::Subsection::Closed:: *)
(*LastOrDefault*)

DefineTests[
	LastOrDefault,
	{
		Example[{Basic,"Returns the last element of a list:"},
			LastOrDefault[{1,2,3}],
			3
		],

		Example[{Basic,"Returns Null if expression is of length 0 and no default value given:"},
			LastOrDefault[{}],
			Null
		],

		Example[{Basic,"Returns default value if expression is of length 0:"},
			LastOrDefault[{},2000],
			2000
		],

		Example[{Additional,"Operates on the Values of Associations:"},
			LastOrDefault[<|1->2,4->6|>],
			6
		],

		Example[{Additional,"Operates on arbitrary expressions:"},
			LastOrDefault[Taco[1,2,3]],
			3
		],

		Test["Does not throw a message is given an Atom:",
			LastOrDefault[1,20],
			20
		]
	}
];

(* ::Subsection::Closed:: *)
(*MostOrDefault*)

DefineTests[
	MostOrDefault,
	{
		Example[{Basic,"Returns the list with the last element removed:"},
			MostOrDefault[{1,2,3}],
			{1,2}
		],

		Example[{Basic,"Returns Null if expression is of length 0 and no default value given:"},
			MostOrDefault[{}],
			Null
		],

		Example[{Basic,"Returns default value if expression is of length 0:"},
			MostOrDefault[{},2000],
			2000
		],

		Example[{Additional,"Operates on Associations:"},
			MostOrDefault[<|1->2,4->6|>],
			_Association?(And[
				Length[#]==1,
				#[1]==2
			]&)
		],

		Example[{Additional,"Operates on arbitrary expressions:"},
			MostOrDefault[Taco[1,2,3]],
			Taco[1,2]
		],

		Test["Does not throw a message is given an Atom:",
			MostOrDefault[1,20],
			20
		]
	}
];

(* ::Subsection::Closed:: *)
(*RestOrDefault*)

DefineTests[
	RestOrDefault,
	{
		Example[{Basic,"Returns the list with the first element removed:"},
			RestOrDefault[{1,2,3}],
			{2,3}
		],

		Example[{Basic,"Returns Null if expression is of length 0 and no default value given:"},
			RestOrDefault[{}],
			Null
		],

		Example[{Basic,"Returns default value if expression is of length 0:"},
			RestOrDefault[{},2000],
			2000
		],

		Example[{Additional,"Operates on Associations:"},
			RestOrDefault[<|1->2,4->6|>],
			_Association?(And[
				Length[#]==1,
				#[4]==6
			]&)
		],

		Example[{Additional,"Operates on arbitrary expressions:"},
			RestOrDefault[Taco[1,2,3]],
			Taco[2,3]
		],

		Test["Does not throw a message is given an Atom:",
			RestOrDefault[1,20],
			20
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*PartitionRemainder*)

DefineTests[
	PartitionRemainder,
	{
		Example[{Basic,"The function breaks lists into evenely length sublists length 'n' with remaining items that don't devide evenly appended in a final sublist:"},
			PartitionRemainder[Range[10],3],
			{{1,2,3},{4,5,6},{7,8,9},{10}}
		],
		Example[{Basic,"An offset can be provided to generate sublists with overlapping elements of length 'n' at an offset of 'd':"},
			PartitionRemainder[Range[10],3,1],
			{{1,2,3},{2,3,4},{3,4,5},{4,5,6},{5,6,7},{6,7,8},{7,8,9},{8,9,10},{9,10},{10}}
		],
		Example[{Basic,"If 'n' divides evenly into the length of the list, the function behaves like Partition:"},
			PartitionRemainder[Range[9],3],
			{{1,2,3},{4,5,6},{7,8,9}}
		],
		Example[{Options,NegativePadding,"The NegativePadding Option can be used to seperatly partition out elements from the front of the list:"},
			PartitionRemainder[Range[9],3,NegativePadding->2],
			{{1,2},{3,4,5},{6,7,8},{9}}
		],
		Example[{Attributes,"Listable","The function is listable by 'n' and 'd':"},
			PartitionRemainder[Range[10],Range[5]],
			{{{1},{2},{3},{4},{5},{6},{7},{8},{9},{10}},{{1,2},{3,4},{5,6},{7,8},{9,10}},{{1,2,3},{4,5,6},{7,8,9},{10}},{{1,2,3,4},{5,6,7,8},{9,10}},{{1,2,3,4,5},{6,7,8,9,10}}}
		],
		Test["Testing that Negative paddings larger than the list do not crash:",PartitionRemainder[Range[5],10,NegativePadding->50],
			{{1,2,3,4,5}}
		],
		Test["Symbolic input remains unevaluated:",
			PartitionRemainder[taco,time],
			_PartitionRemainder
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*LookupPath*)

DefineTests[
	LookupPath,
	{
		Example[{Basic,"Simple nested path:"},
			LookupPath[<|
				"Foo" -> <|
					"Bar"->{1,2,3},
					"Baz"->{a,b,c}
				|>
			|>, {"Foo", "Bar"}],
			{1,2,3}
		],
		Example[{Basic,"Simple nested path with index:"},
			LookupPath[<|
				"Foo" -> <|
					"Bar"->{1,2,3},
					"Baz"->{a,b,c}
				|>
			|>, {"Foo", "Baz", 2}],
			b
		],
		Example[{Basic,"Works with lists of Rules and Associations:"},
			LookupPath[<|
				"Foo" -> {
					"Bar"->{1,2,3},
					"Baz"->{a,b,c}
				}
			|>, {"Foo", "Baz", 2}],
			b
		],
		Example[{Basic,"When a component of the path references something not in the data, Missing is returned:"},
			LookupPath[<|
				"Foo" -> {
					"Bar"->{1,2,3},
					"Baz"->{a,b,c}
				}
			|>, {"Foo", "Frack", 2}],
			Missing["KeyAbsent", "Frack"]
		],
		Example[{Basic,"When a indexing into a List that is out of bounds, return Missing[IndexOutOfBounds]:"},
			LookupPath[<|
				"Foo" -> {
					"Bar"->{1,2,3},
					"Baz"->{a,b,c}
				}
			|>, {"Foo", "Bar", 20}],
			Missing["IndexOutOfBounds", 20]
		],
		Example[{Additional,"When path references something that cannot be looked up into, then $Failed is returned and a Message is displayed:"},
			LookupPath[<|
				"Foo" -> {
					"Type"->"Awesome",
					"Bar"->{1,2,3},
					"Baz"->{a,b,c}
				}
			|>, {"Foo", "Type", "Bar"}],
			$Failed,
			Messages:>{LookupPath::InnerPathDataError}
		],
		Example[{Additional,"Empty paths are always Missing:"},
			LookupPath[<|
				"Foo" -> {
					"Type"->"Awesome",
					"Bar"->{1,2,3},
					"Baz"->{a,b,c}
				}
			|>, {}],
			Missing["EmptyPath"]
		],
		Example[{Messages,"InnerPathDataError","A failure is returned is any non-Lookup-compatible data along the requested lookup path is encountered:"},
			LookupPath[
				<|
					"Foo" -> {
						"Type"->"Awesome",
						"Bar"->{1,2,3},
						"Baz"->{a,b,c}
					}
				|>,
				{"Foo","Type","Awesome"}
			],
			$Failed,
			Messages:>{
				LookupPath::InnerPathDataError
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ToList*)

DefineTests[
	ToList,
	{
		Example[{Basic,"Returns input expression if it is already a List:"},
			ToList[{1,2,3}],
			{1,2,3}
		],

		Example[{Basic,"Returns input expression wrapped in a List if it is not already a List:"},
			ToList[Association["Taco"->"Cat"]],
			{Association["Taco"->"Cat"]}
		],

		Example[{Additional,"If given a Sequence, wraps the sequence in a List:"},
			ToList[1,2,3],
			{1,2,3}
		],

		Example[{Additional,"If given no arguments, returns an empty list:"},
			ToList[],
			{}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*NullQ*)

DefineTests[
	NullQ,
	{
		Example[{Basic,"Returns True if input is a nested list of Nulls:"},
			NullQ[{{Null,Null},Null}],
			True
		],

		Example[{Basic,"Returns True if input is a single Null:"},
			NullQ[Null],
			True
		],

		Example[{Basic,"Returns False if input is not a nested list of Nulls:"},
			NullQ[{1,2,3}],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*TransposeOrEmpty*)

DefineTests[
	TransposeOrEmpty,
	{
		Example[{Basic, "Transposes a non-empty list using standard Transpose:"},
			TransposeOrEmpty[{{1, 2, 3}, {4, 5, 6}}, 3],
			{{1, 4}, {2, 5}, {3, 6}}
		],
		Example[{Basic, "Returns a list of empty lists, of the specified length, when the input list is empty:"},
			TransposeOrEmpty[{}, 3],
			{{}, {}, {}}
		],
		Example[{Basic, "Assignment to a list of variables remains safe when a non-empty list is provided:"},
			Module[{a, b, c},
				{a, b, c} = TransposeOrEmpty[{}, 3];
				{a, b, c}
			],
			{{}, {}, {}}
		],
		Example[{Basic, "Use operator form for readability with bulky code:"},
			Module[{a, b, c},
				{a, b, c} = TransposeOrEmpty[3] @ Module[
					{step1, step2, step3},

					(* Bulky code *)
					step1 = 1;
					step2 = 2;
					step3 = 3;

					(* That might return an empty list *)
					{}
				];
				{a, b, c}
			],
			{{}, {}, {}}
		],
		Example[{Additional, "Perform a normal transpose on a non-empty list and assign directly to a list of variables:"},
			Module[{a, b, c},
				{a, b, c} = TransposeOrEmpty[
					{
						{"a1", "b1", "c1"},
						{"a2", "b2", "c2"},
						{"a3", "b3", "c3"}
					},
					3
				];
				{a, b, c}
			],
			{
				{"a1", "a2", "a3"},
				{"b1", "b2", "b3"},
				{"c1", "c2", "c3"}
			}
		],
		Example[{Additional, "The assignmentLength parameter is ignored for non-empty lists:"},
			TransposeOrEmpty[{{1, 2}, {3, 4}}, 100],
			{{1, 3}, {2, 4}}
		],
		Test["Handles single-row transposition:",
			TransposeOrEmpty[{{1, 2, 3}}, 3],
			{{1}, {2}, {3}}
		],
		Test["Handles single-column transposition:",
			TransposeOrEmpty[{{1}, {2}, {3}}, 1],
			{{1, 2, 3}}
		],
		Test["Returns single empty list when assignmentLength is 1:",
			TransposeOrEmpty[{}, 1],
			{{}}
		],
		Test["Handles zero assignmentLength by returning empty list:",
			TransposeOrEmpty[{}, 0],
			{}
		],
		Test["Transpose of non-rectangular lists still fails as expected:",
			TransposeOrEmpty[{{1, 2}, {3, 4, 5}}, 2],
			Transpose[_List],
			Messages :> {Transpose::nmtx}
		],
		Test["Operator form performs a standard transpose with a non-empty list:",
			TransposeOrEmpty[3][{{1, 2, 3}, {4, 5, 6}}],
			{{1, 4}, {2, 5}, {3, 6}}
		],
		Test["Operator form returns a list of empty lists, of the specified length, when the input list is empty:",
			TransposeOrEmpty[5][{}],
			{{}, {}, {}, {}, {}}
		]
	}
];
