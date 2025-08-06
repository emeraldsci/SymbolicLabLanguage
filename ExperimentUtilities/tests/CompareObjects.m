(* ::Subsection:: *)
(*CompareObjects*)


(* ::Subsubsection::Closed:: *)
(*CompareObjects*)

DefineTests[CompareObjects,
	{
		Example[{Basic, "Print a table summarizing the differences in how fields are populated between two objects:"},
			CompareObjects[
				{
					Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 1 " <> $SessionUUID],
					Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 2 " <> $SessionUUID]
				}
			],
			_Pane
		],
		Example[{Basic, "Two objects can be specified as a sequence:"},
			CompareObjects[
				Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 1 " <> $SessionUUID],
				Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 2 " <> $SessionUUID]
			],
			_Pane
		],
		Example[{Basic, "One object can be compared at two or more time points:"},
			CompareObjects[
				Object[Sample, "CompareObjects Test Sample"],
				Date -> {Now, DateObject[{2025, 1, 23, 16, 11}, "Instant", "Gregorian", -8.]}
			],
			_Pane
		],
		Example[{Options, OutputFormat, "Output can be returned as an association:"},
			CompareObjects[
				{
					Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 1 " <> $SessionUUID],
					Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 2 " <> $SessionUUID]
				},
				OutputFormat -> Association
			],
			AssociationMatchP[
				<|
					Object -> {
						ObjectP[Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 1 " <> $SessionUUID]],
						ObjectP[Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 2 " <> $SessionUUID]]
					}
				|>,
				AllowForeignKeys -> True
			]
		],
		Example[{Options, OutputType, "Specifying Output->Full returns a comparison of all fields in the provided objects:"},
			pane = CompareObjects[
				{
					Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 1 " <> $SessionUUID],
					Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 2 " <> $SessionUUID]
				},
				OutputType -> Full
			];
			pane[[1, 1]],
			_?(GreaterQ[Length[#], 5]&),
			Variables :> {pane}
		],
		Example[{Options, OutputType, "A list of field names with differing values can be returned:"},
			CompareObjects[
				{
					Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 1 " <> $SessionUUID],
					Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 2 " <> $SessionUUID]
				},
				OutputType -> Fields
			],
			{OrderlessPatternSequence[ID, Name, Object, Timebase]}
		],
		Example[{Options, Fields, "Specify the fields to compare between the objects:"},
			CompareObjects[
				{
					Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 1 " <> $SessionUUID],
					Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 2 " <> $SessionUUID]
				},
				Fields -> {Name},
				OutputFormat -> Association
			],
			AssociationMatchP[
				<|
					Name -> {
						"CompareObjects Test Instrument HPLC 1 " <> $SessionUUID,
						"CompareObjects Test Instrument HPLC 2 " <> $SessionUUID
					}
				|>,
				AllowForeignKeys -> False
			]
		],
		Example[{Options, ExcludedFields, "Specify the fields to exclude from the comparison between the objects:"},
			CompareObjects[
				{
					Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 1 " <> $SessionUUID],
					Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 2 " <> $SessionUUID]
				},
				ExcludedFields -> {Name},
				OutputFormat -> Association
			],
			Except[AssociationMatchP[
				<|
					Name -> _
				|>,
				AllowForeignKeys -> False
			]]
		],
		Example[{Options, Date, "Specify the date to perform the comparison between the objects:"},
			CompareObjects[
				{
					Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 1 " <> $SessionUUID],
					Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 2 " <> $SessionUUID]
				},
				Date -> Now,
				OutputFormat -> Association
			],
			AssociationMatchP[
				<|
					Object -> {
						ObjectP[Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 1 " <> $SessionUUID]],
						ObjectP[Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 2 " <> $SessionUUID]]
					}
				|>,
				AllowForeignKeys -> True
			]
		],
		Example[{Options, SortMultiple, "Multiple fields can be compared when sorted:"},
			CompareObjects[
				{
					Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 3 " <> $SessionUUID],
					Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 4 " <> $SessionUUID]
				},
				Date -> Now,
				OutputType -> Fields
			],
			_?(!MemberQ[#, StatusLog]&)
		]
	},

	SymbolSetUp :> {
		Module[{objects, existingObjects, test1Packets, allUploadPackets},

			(* All objects created for this unit test *)
			objects = Cases[
				Flatten[{
					Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 1 " <> $SessionUUID],
					Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 2 " <> $SessionUUID],
					Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 3 " <> $SessionUUID],
					Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 4 " <> $SessionUUID]
				}],
				ObjectReferenceP[]
			];

			existingObjects = PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False];

			(* Packets for first test *)
			test1Packets = Module[{objectIDs},

				objectIDs = CreateID[
					{
						Object[Instrument, HPLC],
						Object[Instrument, HPLC],
						Object[Instrument, HPLC],
						Object[Instrument, HPLC],
						Object[Instrument, HPLC]
					}
				];

				{
					<|
						Object -> objectIDs[[1]],
						Type -> Object[Instrument, HPLC],
						Name -> "CompareObjects Test Instrument HPLC 1 " <> $SessionUUID,
						Model -> Link[Model[Instrument, HPLC, "id:N80DNjlYwwJq"], Objects],
						Status -> Available,
						Timebase -> "HPLC4B",
						DeveloperObject -> True
					|>,
					<|
						Object -> objectIDs[[2]],
						Type -> Object[Instrument, HPLC],
						Name -> "CompareObjects Test Instrument HPLC 2 " <> $SessionUUID,
						Model -> Link[Model[Instrument, HPLC, "id:N80DNjlYwwJq"], Objects],
						Status -> Available,
						Timebase -> "HPLC6A",
						DeveloperObject -> True
					|>,
					<|
						Object -> objectIDs[[3]],
						Type -> Object[Instrument, HPLC],
						Name -> "CompareObjects Test Instrument HPLC 3 " <> $SessionUUID,
						Model -> Link[Model[Instrument, HPLC, "id:N80DNjlYwwJq"], Objects],
						Status -> Available,
						Replace[StatusLog] -> {
							{DateObject[{2022, 1, 1, 0, 0, 0}], Available, Link[$PersonID]},
							{DateObject[{2022, 1, 1, 10, 0, 0}], Running, Link[$PersonID]},
							{DateObject[{2022, 1, 1, 20, 0, 0}], Available, Link[$PersonID]}
						},
						Timebase -> "HPLC7B",
						DeveloperObject -> True
					|>,
					<|
						Object -> objectIDs[[4]],
						Type -> Object[Instrument, HPLC],
						Name -> "CompareObjects Test Instrument HPLC 4 " <> $SessionUUID,
						Model -> Link[Model[Instrument, HPLC, "id:N80DNjlYwwJq"], Objects],
						Status -> Available,
						Replace[StatusLog] -> {
							{DateObject[{2022, 1, 1, 10, 0, 0}], Running, Link[$PersonID]},
							{DateObject[{2022, 1, 1, 0, 0, 0}], Available, Link[$PersonID]},
							{DateObject[{2022, 1, 1, 20, 0, 0}], Available, Link[$PersonID]}
						},
						Timebase -> "HPLC8A",
						DeveloperObject -> True
					|>
				}
			];

			(* Combine packets for upload *)
			allUploadPackets = Flatten[{test1Packets}];

			Upload[allUploadPackets]
		]
	},
	SymbolTearDown :> {
		Module[{objects, existingObjects},

			(* All objects created for this unit test *)
			objects = Cases[
				Flatten[{
					Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 1 " <> $SessionUUID],
					Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 2 " <> $SessionUUID],
					Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 3 " <> $SessionUUID],
					Object[Instrument, HPLC, "CompareObjects Test Instrument HPLC 4 " <> $SessionUUID]
				}],
				ObjectReferenceP[]
			];

			existingObjects = PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False];
		]
	}
];