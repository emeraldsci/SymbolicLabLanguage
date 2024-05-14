(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*Upload*)


DefineTests[Upload,
	{
		Example[{Basic, "Create an object:"},
			Upload[
				<|
					Type -> Object[User],
					FirstName -> "Test 1",
					LastName -> CreateUUID[],
					DeveloperObject -> True
				|>
			],
			Object[User, _String]
		],

		Example[{Basic, "Create a public object:"},
			Upload[
				<|Type -> Object[Example, Data]|>,
				AllowPublicObjects -> True
			],
			ObjectP[Object[Example, Data]]
		],

		Example[{Additional, "Create a model object:"},
			Upload[
				<|
					Type -> Model[Sample],
					Name -> CreateUUID[],
					DeveloperObject -> True
				|>
			],
			Model[Sample, _String]
		],

		Example[{Basic, "Create multiple objects at once:"},
			Upload[
				{
					<|
						Type -> Object[User],
						FirstName -> "Test 1",
						LastName -> "Pilot "<>CreateUUID[],
						DeveloperObject -> True
					|>,
					<|
						Type -> Object[Sample],
						Name -> "Test Data "<>CreateUUID[],
						DeveloperObject -> True
					|>
				}
			],
			{Object[User, _String], Object[Sample, _String]}
		],

		Example[{Basic, "Modify existing objects by specifying the Object key in an Association:"},
			With[
				{
					newPersonID=CreateID[Object[User]],
					newDataID=CreateID[Object[Sample]]
				},
				Upload[
					{
						<|
							Object -> newPersonID,
							FirstName -> "Test 1",
							LastName -> "Pilot "<>DateString[],
							DeveloperObject -> True
						|>,
						<|
							Object -> newDataID,
							Name -> "Test Data "<>CreateUUID[],
							DeveloperObject -> True
						|>
					}
				]
			],
			{Object[User, _String], Object[Sample, _String]}
		],

		Example[{Additional, "Links", "Use pre-created Object IDs to create objects and link them together all in one Upload call:"},
			With[
				{
					id1=CreateID[Object[Sample]],
					id2=CreateID[Object[Maintenance, ReceiveInventory]]
				},
				Upload[
					{
						<|
							Object -> id1,
							Name -> "Test Data 1 "<>CreateUUID[],
							Append[Receiving] -> {Link[id2, Items]},
							DeveloperObject -> True
						|>,
						<|
							Object -> id2,
							Name -> "Test Data 2 "<>CreateUUID[],
							DeveloperObject -> True
						|>
					}
				]
			],
			{Object[Sample, _String], Object[Maintenance, ReceiveInventory, _String]}
		],

		Example[{Additional, "Pre-created Object IDs can be used in indexed multiples:"},
			With[
				{
					id1=CreateID[Object[Sample]],
					id2=CreateID[Object[User]]
				},
				Upload[
					{
						<|
							Object -> id1,
							Name -> "Test Data 1 "<>CreateUUID[],
							Append[StatusLog] -> {{Now, InUse, Link[id2]}},
							DeveloperObject -> True
						|>,
						<|
							Object -> id2,
							Name -> "Test Data 2 "<>CreateUUID[],
							DeveloperObject -> True
						|>
					}
				]
			],
			{Object[Sample, _String], Object[User, _String]}
		],

		Example[{Additional, "Links", "Links can refer to Objects by Name:"},
			Module[{name="Link Name Test: "<>CreateUUID[]},
				id1=Upload[<|
					Type -> Model[Sample],
					Name -> name,
					DeveloperObject -> True
				|>];
				id2=Upload[<|
					Type -> Object[Sample],
					Model -> Link[Model[Sample, name], Objects],
					DeveloperObject -> True
				|>];
				{id1, id2}
			],
			{_Model, _Object}
		],


		Example[{Additional, "Compressed", "Compressed fields yield the same thing coming out as going in:"},
			With[
				{
					newId=Upload[
						<|
							Type -> Object[Analysis, Fit],
							Name -> "Test Compressed fields "<>DateString[],
							PredictedResponse -> Table[Prime[i], {i, 50}]
						|>
					]
				},
				newId[PredictedResponse]
			],
			Table[Prime[i], {i, 50}]
		],

		Example[{Additional, "Units", "Units are converted on Upload:"},
			With[
				{
					newId=Upload[
						<|
							Type -> Object[Sample],
							Name -> "Unit Time Test "<>CreateUUID[],
							Mass -> 1 Kilo Gram,
							Append[MassLog] -> {{Now, 1000000 Milli Gram, Null, UserSpecified}},
							DeveloperObject -> True
						|>
					]
				},
				newId[{Mass, MassLog}]
			],
			{
				Quantity[1000.0, "Grams"],
				{{_, Quantity[1000.0, "Grams"], _, _}}
			}
		],

		Example[{Additional, "QuantityArray", "QuantityArray expressions can be used as values, and will be converted:"},
			With[
				{
					newId=Upload[
						<|
							Type -> Object[Data, AbsorbanceSpectroscopy],
							Name -> "Test QA 1D Data "<>CreateUUID[],
							Temperature -> QuantityArray[{{1, 1}, {2, 1}, {3, 1}}, {"Micrometers", "Celsius"}],
							DeveloperObject -> True
						|>
					]
				},
				newId[Temperature]
			],
			QuantityArray[{{1000, 1}, {2000, 1}, {3000, 1}}, {"Nanometers", "DegreesCelsius"}]
		],

		Example[{Additional, "QuantityArray", "Insert a list of QuantityArrays into a multiple field:"},
			With[
				{
					newId=Upload[
						<|
							Type -> Object[Example, Data],
							Name -> "Test QA 1D Data "<>CreateUUID[],
							Append[QuantityArray2DMultiple] -> {
								QuantityArray[
									{{1., 1.}, {2., 3.}, {3., 6.}},
									{"Seconds", "Meter"}
								],
								QuantityArray[
									{{1., 1.}, {2., 3.}, {3., 6.}},
									{"Seconds", "Meter"}
								]
							},
							DeveloperObject -> True
						|>
					]
				},
				newId[QuantityArray2DMultiple]
			],
			{
				QuantityArray[
					{{1., 1.}, {2., 3.}, {3., 6.}},
					{"Seconds", "Meter"}
				],
				QuantityArray[
					{{1., 1.}, {2., 3.}, {3., 6.}},
					{"Seconds", "Meter"}
				]
			}
		],

		Example[{Additional, "QuantityArray", "Insert a list of QuantityArrays into a multiple field and convert their units:"},
			With[
				{
					newId=Upload[
						<|
							Type -> Object[Example, Data],
							Name -> "Test QA 1D Data "<>CreateUUID[],
							Append[QuantityArray2DMultiple] -> {
								QuantityArray[
									{{1000., 1.}, {2000., 3.}, {3000., 6.}},
									{"Seconds", "Meter"}
								],
								QuantityArray[
									{{1., 1000.}, {2., 2000.}, {3., 3000.}},
									{"Seconds", "Centimeters"}
								]
							},
							DeveloperObject -> True
						|>
					]
				},
				newId[QuantityArray2DMultiple]
			],
			{
				QuantityArray[
					{{1000., 1.}, {2000., 3.}, {3000., 6.}},
					{"Seconds", "Meter"}
				],
				QuantityArray[
					{{1., 10.}, {2., 20.}, {3., 30.}},
					{"Seconds", "Meter"}
				]
			}
		],

		Example[{Additional, "QuantityArray", "QuantityArrays convert complex indexed multiples:"},
			With[
				{
					newId=Upload[
						<|
							Type -> Object[Data, LCMS],
							Name -> "Test QA IndexedMultiple Data "<>CreateUUID[],
							Append[MassSpectra] -> {
								{
									1 Minute,
									QuantityArray[
										{{1, 1}, {2, 2}},
										{"Kilograms" / "Moles", IndependentUnit["ArbitraryUnits"]}
									]
								},
								{
									2 Minute,
									QuantityArray[
										{{1000, 2010}, {2000, 473}},
										{"Milligrams" / "Moles", IndependentUnit["ArbitraryUnits"]}
									]
								}
							},
							DeveloperObject -> True
						|>
					]
				},
				newId[MassSpectra]
			],
			{
				{
					1.0 Minute,
					QuantityArray[
						{{1000, 1}, {2000, 2}},
						{"Grams" / "Moles", IndependentUnit["ArbitraryUnits"]}
					]
				},
				{
					2.0 Minute,
					QuantityArray[
						{{1, 2010}, {2, 473}},
						{"Grams" / "Moles", IndependentUnit["ArbitraryUnits"]}
					]
				}
			}
		],

		Example[{Additional, "Links", "Links can go one way if they are so defined:"},
			With[{author=Upload[<|Type -> Object[User], DeveloperObject -> True|>]},
				Download[Upload[<|
					Type -> Object[Analysis],
					Author -> Link[author],
					Name -> "Test One-Way Link Analysis 1 "<>CreateUUID[],
					DeveloperObject -> True
				|>], Author]
			],
			LinkP[Object[User]]
		],

		Example[{Additional, "Exrpressions get written and read out correctly:"},
			With[
				{
					newDataId=Upload[
						<|
							Type -> Object[Analysis, Fit],
							Name -> "Expressions Test Data 1 "<>CreateUUID[],
							BestFitFunction -> Function[x, x^2]
						|>]
				},
				newDataId[BestFitFunction][3]
			],
			9
		],

		Example[{Additional, "Returns an empty list when given an empty list:"},
			Upload[{}, Verbose -> True],
			{}
		],
		Example[{Additional, "Append a single value to a multiple field:"},
			With[
				{object=CreateID[Object[Analysis, Fit]]},

				Upload[<|Object -> object, Append[BestFitVariables] -> X, DeveloperObject -> True|>]
			],
			ObjectReferenceP[],
			Variables :> {X}
		],
		Example[{Additional, "Prepend a single value to a multiple field:"},
			With[
				{object=CreateID[Object[Analysis, Fit]]},

				Upload[<|Object -> object, Prepend[BestFitVariables] -> X, DeveloperObject -> True|>]
			],
			ObjectReferenceP[],
			Variables :> {X}
		],
		Example[{Additional, "Boolean fields work and return BooleanP:"},
			With[
				{objects=Upload[{
					<|Type -> Object[Example, Data], BooleanField -> True|>,
					<|Type -> Object[Example, Data], BooleanField -> False|>,
					<|Type -> Object[Example, Data]|>
				}]},
				Download[objects, BooleanField]
			],
			{True, False, Null}
		],

		Example[{Options, Verbose, "Verbose->False turns off the progress/completion messages:"},
			Upload[
				<|
					Type -> Object[Analysis, Fit],
					Append[BestFitVariables] -> {X},
					DeveloperObject -> True
				|>,
				Verbose -> False
			],
			ObjectReferenceP[]
		],

		Example[{Options, Transaction, "Transaction->_String creates a unique transaction for the Upload call:"},
			With[{transactionId=CreateUUID[]},
				Upload[
					<|
						Type -> Object[Sample],
						DeveloperObject -> True
					|>,
					Transaction -> transactionId
				]
			],
			ObjectReferenceP[]
		],

		Example[{Options, CAS, "CAS->_String appends the provided Check and Set Token to the packet during the Upload call:"},
			Module[{newPersonID, newCAS},
				newPersonID=CreateID[Object[User]];
				newCAS=Lookup[
					Download[
						Upload[
							<|
								Object -> newPersonID,
								FirstName -> "Test 1",
								LastName -> "Pilot "<>CreateUUID[],
								DeveloperObject -> True
							|>
						],
						IncludeCAS -> True
					],
					CAS
				];
				Upload[
					<|
						Object -> newPersonID,
						FirstName -> "Test 1 "<>CreateUUID[]
					|>,
					CAS -> newCAS
				]
			],
			ObjectReferenceP[]
		],

		Example[{Messages, "CasLengthMismatch", "Providing an incorrect number of CAS tokens returns $Failed and provides a warning message:"},
			Upload[<|Type -> Object[Sample], DeveloperObject -> True|>, CAS -> {"CAS1", "CAS2"}],
			$Failed,
			Messages :> {
				Message[Warning::CasLengthMismatch],
				Message[Upload::Error, "Error uploading packets with provided CAS tokens"]
			}
		],

		Example[{Messages, "InvalidPacket", "Providing an invalid packet returns $Failed:"},
			Upload[<|Type -> Object[Sample], Null|>],
			$Failed,
			Messages :> {
				Message[Upload::InvalidPacket]
			}
		],

		Example[{Messages, "Error", "Providing an invalid CAS token returns $Failed and provides a message:"},
			Upload[<|Type -> Object[Sample], DeveloperObject -> True|>, CAS -> "CAS1"],
			$Failed,
			Messages :> {Message[Upload::Error, "Check and set token 'CAS1' could not be interpreted"]}
		],

		Example[{Options, ConstellationMessage, "Only print newly created objects of the specified types:"},
			Upload[{
				<|Type -> Object[Data, Volume], DateCreated -> Now|>,
				<|Type -> Object[Data, Volume], DateCreated -> Now - Hour|>,
				<|Type -> Object[Analysis, Peaks], DateCreated -> Now|>,
				<|Type -> Object[Sample], DatePurchased -> Now|>
			}, ConstellationMessage -> {Object[Data, Volume], Object[Data, PAGE]}
			],
			{ObjectReferenceP[]..}
		],
		Example[{Options, ConstellationMessage, "Print all created objects:"},
			Upload[{
				<|Type -> Object[Data, Volume], DateCreated -> Now|>,
				<|Type -> Object[Data, Volume], DateCreated -> Now - Hour|>,
				<|Type -> Object[Analysis, Peaks], DateCreated -> Now|>,
				<|Type -> Object[Sample], DatePurchased -> Now|>
			}, ConstellationMessage -> All
			],
			{ObjectReferenceP[]..}
		],
		Test["Print some created types:",
			Module[{},
				Constellation`Private`$NewVerboseObjects={};
				Block[{$DisableVerbosePrinting=False},
				Upload[{
					<|Type -> Object[Data, Volume], DateCreated -> Now|>,
					<|Type -> Object[Data, Volume], DateCreated -> Now - Hour|>,
					<|Type -> Object[Analysis, Peaks], DateCreated -> Now|>,
					<|Type -> Object[Sample], DatePurchased -> Now|>
				}, ConstellationMessage -> {Object[Data, Volume], Object[Data, PAGE], Object[Sample]}
				]];
				Constellation`Private`$NewVerboseObjects
			],
			{ObjectReferenceP[Object[Sample]], ObjectReferenceP[Object[Data, Volume]], ObjectReferenceP[Object[Data, Volume]]}
		],
		Test["Print no created types:",
			Module[{},
				Constellation`Private`$NewVerboseObjects={};
				Block[{$DisableVerbosePrinting=False},
				Upload[{
					<|Type -> Object[Data, Volume], DateCreated -> Now|>,
					<|Type -> Object[Data, Volume], DateCreated -> Now - Hour|>,
					<|Type -> Object[Analysis, Peaks], DateCreated -> Now|>,
					<|Type -> Object[Sample], DatePurchased -> Now|>
				}, ConstellationMessage -> {}
				]];
				Constellation`Private`$NewVerboseObjects
			],
			{}
		],
		Test["Print all created types:",
			Module[{},
				Constellation`Private`$NewVerboseObjects={};
				Block[{$DisableVerbosePrinting=False},
				Upload[{
					<|Type -> Object[Data, Volume], DateCreated -> Now|>,
					<|Type -> Object[Data, Volume], DateCreated -> Now - Hour|>,
					<|Type -> Object[Analysis, Peaks], DateCreated -> Now|>,
					<|Type -> Object[Sample], DatePurchased -> Now|>
				}, ConstellationMessage -> All
				]];
				Constellation`Private`$NewVerboseObjects
			],
			{ObjectReferenceP[Object[Sample]], ObjectReferenceP[Object[Analysis, Peaks]], ObjectReferenceP[Object[Data, Volume]], ObjectReferenceP[Object[Data, Volume]]}
		],

		Example[{Messages, "MissingObject", "Trying to Upload to a non-existent Object throws an error and returns $Failed:"},
			Upload[
				<|
					Object -> Object[Analysis, Fit, "foo-lkajsdfllajdlkjsjlaksjlslkjdf"<>CreateUUID[]],
					Replace[BestFitVariables] -> X,
					DeveloperObject -> True
				|>
			],
			$Failed,
			Messages :> {
				Upload::MissingObject
			}
		],

		Test["Backlinks create null sub-fields:",
			With[
				{thingOne=Upload[<|Type -> Object[Example, Data]|>]},
				thingTwo=Upload[
					<|
						Type -> Object[Example, Data],
						Append[GroupedMultipleAppendRelation] -> {{"test", Link[thingOne, GroupedMultipleAppendRelationAmbiguous, 2]}}
					|>
				];
				Download[thingOne, GroupedMultipleAppendRelationAmbiguous]
			],
			{
				{Null, Link[thingTwo, GroupedMultipleAppendRelation, 2, _String]}
			},
			Variables :> {thingOne, thingTwo}
		],

		Test["Large / Small Quantities work:",
			With[
				{id=Upload[<|Type -> Object[Example, Data], Temperature -> 4.123*^300 Celsius|>]},
				Download[id, Temperature]
			],
			_Quantity
		],

		Test["Upload can take Null Single links:",
			Upload[<|Type -> Object[Example, Data], SingleRelation -> Null|>],
			_Object
		],

		Example[{Messages, "MissingLinkID", "Return $Failed and provide a message for one way links with ids:"},
			With[
				{
					id=CreateLinkID[],
					user=CreateID[Object[User]]
				},

				Upload[<|Type -> Object[Analysis], Author -> Link[user, id], DeveloperObject -> True|>]
			],
			$Failed,
			Messages :> {Upload::MissingLinkID}
		],

		Example[{Basic, "Append[field] adds to existing values in an object:"},
			With[{
				object=Upload[
					<|
						Type -> Object[Analysis, Fit],
						Name -> "Test Data "<>CreateUUID[],
						DeveloperObject -> True
					|>
				]},

				{
					Upload[{
						<|Object -> object, Append[BestFitVariables] -> {X, Y, Z}|>,
						<|Object -> object, Append[BestFitVariables] -> {W, V, T}|>
					}],
					Download[object, BestFitVariables]
				}
			],
			{
				{ObjectReferenceP[], ObjectReferenceP[]},
				{X, Y, Z, W, V, T}
			}
		],

		Example[{Basic, "Updates are applied in-order so subsequent replaces overwrite previously appended values:"},
			With[{
				object=Upload[
					<|
						Type -> Object[Analysis, Fit],
						Name -> "Test Data "<>CreateUUID[],
						DeveloperObject -> True
					|>
				]},

				{
					Upload[{
						<|Object -> object, Append[BestFitVariables] -> {X, Y, Z}|>,
						<|Object -> object, Replace[BestFitVariables] -> {}|>,
						<|Object -> object, Append[BestFitVariables] -> {W, V}|>
					}],
					Download[object, BestFitVariables]
				}
			],
			{
				{Repeated[obj:ObjectReferenceP[], {3}]},
				{W, V}
			}
		],

		Example[{Additional, "QuantityArray", "Append to a QuantityArray field:"},
			With[
				{
					object=Upload[
						<|
							Type -> Object[Data, LCMS],
							Name -> "Test Data "<>CreateUUID[],
							DeveloperObject -> True
						|>
					]
				},
				Upload[
					Table[
						Association[
							Object -> object,
							Append[MassSpectra] -> {
								{i Minute, QuantityArray[{{10. * i, 7}}, {"Kilograms" / "Moles", IndependentUnit["ArbitraryUnits"]}] },
								{i * 2 Minute, QuantityArray[{{11. * i, 7}}, {"Kilograms" / "Moles", IndependentUnit["ArbitraryUnits"]}] }
							}
						],
						{i, 3}
					]
				];
				object[MassSpectra]
			],
			{
				{1.0 Minute, Convert[QuantityArray[{{10. * 1, 7}}, {"Kilograms" / "Moles", IndependentUnit["ArbitraryUnits"]}], {"Grams" / "Moles", IndependentUnit["ArbitraryUnits"]}]},
				{2.0 Minute, Convert[QuantityArray[{{11. * 1, 7}}, {"Kilograms" / "Moles", IndependentUnit["ArbitraryUnits"]}], {"Grams" / "Moles", IndependentUnit["ArbitraryUnits"]}]},
				{2.0 Minute, Convert[QuantityArray[{{10. * 2, 7}}, {"Kilograms" / "Moles", IndependentUnit["ArbitraryUnits"]}], {"Grams" / "Moles", IndependentUnit["ArbitraryUnits"]}]},
				{4.0 Minute, Convert[QuantityArray[{{11. * 2, 7}}, {"Kilograms" / "Moles", IndependentUnit["ArbitraryUnits"]}], {"Grams" / "Moles", IndependentUnit["ArbitraryUnits"]}]},
				{3.0 Minute, Convert[QuantityArray[{{10. * 3, 7}}, {"Kilograms" / "Moles", IndependentUnit["ArbitraryUnits"]}], {"Grams" / "Moles", IndependentUnit["ArbitraryUnits"]}]},
				{6.0 Minute, Convert[QuantityArray[{{11. * 3, 7}}, {"Kilograms" / "Moles", IndependentUnit["ArbitraryUnits"]}], {"Grams" / "Moles", IndependentUnit["ArbitraryUnits"]}]}
			}
		],

		Test["Appending an empty list to a multiple field does nothing:",
			With[{object=Upload[<|Type -> Object[Example, Data], Append[Random] -> {7.1, 8.2}|>]},
				Upload[<|Object -> object, Append[Random] -> {}|>];
				Download[object, Random]
			],
			{7.1, 8.2}
		],

		Test["Autofields created:",
			With[
				{object=Upload[<|Type -> Object[Example, Data]|>]},
				{testPersonID=Download[$PersonID, Name];
				object[CreatedBy][Name] === testPersonID,
					object[DateCreated] <= Now}(*NewDateCreated*)
			],
			{True, True}],

		Test["Cache is busted for objects which are modified after being Downloaded with Cache->Session:",
			With[
				{object=Upload[<|Type -> Object[Example, Data]|>]},

				Download[object, Cache -> Session];
				Upload[<|Object -> object, Append[Random] -> {1, 2, 3}|>];
				objectCache[getObjectCacheKey[object]]
			],
			_Missing
		],

		Test["Cache is busted for objects which are linked to in an upload after being Downloaded with Cache->Session:",
			With[
				{
					object=Upload[<|Type -> Object[Example, Data]|>],
					linkedObject=Upload[<|Type -> Object[Example, Data]|>]
				},

				Download[{object, linkedObject}, Cache -> Session];
				Upload[<|Object -> object, SingleRelation -> Link[linkedObject, SingleRelationAmbiguous]|>];

				{
					objectCache[getObjectCacheKey[object]],
					objectCache[getObjectCacheKey[linkedObject]]
				}
			],
			{_Missing, _Missing}
		],

		Test["Cache is busted for objects whose link is removed in an upload after being Downloaded with Cache->Session:",
			With[
				{
					object=Upload[<|Type -> Object[Example, Data]|>],
					linkedObject=Upload[<|Type -> Object[Example, Data]|>]
				},

				Upload[<|Object -> object, SingleRelation -> Link[linkedObject, SingleRelationAmbiguous]|>];
				Download[{object, linkedObject}, Cache -> Session];
				Upload[<|Object -> object, SingleRelation -> Null|>];

				{
					objectCache[getObjectCacheKey[object]],
					objectCache[getObjectCacheKey[linkedObject]]
				}
			],
			{_Missing, _Missing}
		],

		Test["Cache is busted for objects which are modified after being Downloaded with Cache->Download:",
			With[
				{object=Upload[<|Type -> Object[Example, Data]|>]},

				Download[object, Cache -> Download];
				Upload[<|Object -> object, Append[Random] -> {1, 2, 3}|>];
				objectCache[getObjectCacheKey[object]]
			],
			_Missing
		],

		Test["Upload to an object by name:",
			Module[
				{name, object},

				name=CreateUUID[];
				object=Upload[<|Type -> Object[Example, Data], Name -> name|>];
				Upload[<|Object -> Object[Example, Data, name], Append[Random] -> {1, 2, 3}|>];
				Download[object, Random]
			],
			N[{1, 2, 3}]
		],

		Example[{Messages, "InvalidOperation", "Provides a message and returns $Failed for operations that are not Append, Replace or Erase:"},
			Upload[<|Type -> Object[Sample], My[Name] -> "Tom", DeveloperObject -> True|>],
			$Failed,
			Messages :> {Message[Upload::InvalidOperation, {{My[Name]}}, {1}]}
		],

		Example[{Messages, "ComputableField", "Throws a message and returns $Failed if any fields specified as rules are computable:"},
			Upload[<|Type -> Object[Analysis, Fit], Derivative -> 3x^2, DeveloperObject -> True|>],
			$Failed,
			Messages :> {Message[Upload::ComputableField, {{Derivative}}, {Object[Analysis, Fit]}, {1}]}
		],

		Example[{Additional, "RuleDelayed", "Ignores an fields which are RuleDelayed:"},
			Upload[
				<|
					Type -> Object[Analysis, Fit],
					Derivative :> 3x^2,
					DeveloperObject -> True
				|>
			],
			ObjectReferenceP[Object[Analysis, Fit]]
		],

		Example[{Messages, "Timeout", "Upload must complete within a certain amount of time:"},
			Upload[<|Type -> Object[Sample], DeveloperObject -> True|>],
			$Failed,
			Messages :> {Message[Upload::Error, "Request timeout after 1 seconds."]},
			Stubs :> {
				ConstellationRequest[___]:=HTTPError[Null, "Request timeout after 1 seconds."]
			}
		],

		Example[{Additional, "Erase", "A row can be deleted from a Multiple field:"},
			Download[
				Upload[<|
					Object -> Object[Container, Rack, "Test Erase IndexedMultiple"],
					Erase[Contents] -> 2
				|>],
				Contents[[All, 1]]
			],
			{"A1", "A3"},
			SetUp :> (setupIndexedMultipleErase[])
		],

		Test["A row can be deleted from a named multiple field:",
			Download[
				Upload[<|
					Object -> Object[Example, Data, "Test Erase NamedMultiple"],
					Erase[NamedMultiple] -> 2
				|>],
				NamedMultiple[[All, 1]]
			],
			{1. Nanometer, 3. Nanometer},
			SetUp :> (setupNamedMultipleErase[])
		],

		Example[{Additional, "Erase", "Multiple rows can be deleted from a Multiple field:"},
			Download[
				Upload[<|
					Object -> Object[Container, Rack, "Test Erase IndexedMultiple"],
					Erase[Contents] -> {{1}, {3}}
				|>],
				Contents[[All, 1]]
			],
			{"A2"},
			SetUp :> (setupIndexedMultipleErase[])
		],

		Test["Multiple rows can be deleted from a named multiple field:",
			Download[
				Upload[<|
					Object -> Object[Example, Data, "Test Erase NamedMultiple"],
					Erase[NamedMultiple] -> {{1}, {3}}
				|>],
				NamedMultiple[[All, 1]]
			],
			{2. Nanometer},
			SetUp :> (setupNamedMultipleErase[])
		],

		Example[{Additional, "Erase", "Delete a column from all rows in an IndexedMultiple field:"},
			Download[
				Upload[<|
					Object -> Object[Container, Rack, "Test Erase IndexedMultiple"],
					Erase[Contents] -> {All, 1}
				|>],
				Contents[[All, 1]]
			],
			{Null, Null, Null},
			SetUp :> (setupIndexedMultipleErase[])
		],

		Example[{Additional, "Erase", "Delete a column from all rows in a named multiple field:"},
			Download[
				Upload[<|
					Object -> Object[Example, Data, "Test Erase NamedMultiple"],
					Erase[NamedMultiple] -> {All, SingleLink}
				|>],
				NamedMultiple
			],
			{
				<|UnitColumn -> 1. Nanometer, SingleLink -> Null|>,
				<|UnitColumn -> 2. Nanometer, SingleLink -> Null|>,
				<|UnitColumn -> 3. Nanometer, SingleLink -> Null|>
			},
			SetUp :> (setupNamedMultipleErase[])
		],

		Example[{Additional, "Erase", "Delete from an IndexedMultiple a specific row and column:"},
			Download[
				Upload[<|
					Object -> Object[Container, Rack, "Test Erase IndexedMultiple"],
					Erase[Contents] -> {2, 1}
				|>],
				Contents[[All, 1]]
			],
			{"A1", Null, "A3"},
			SetUp :> (setupIndexedMultipleErase[])
		],

		Test["Delete a specific row and column from a named multiple field:",
			Download[
				Upload[<|
					Object -> Object[Example, Data, "Test Erase NamedMultiple"],
					Erase[NamedMultiple] -> {2, SingleLink}
				|>],
				NamedMultiple
			],
			{
				<|UnitColumn -> 1. Nanometer, SingleLink -> _Link|>,
				<|UnitColumn -> 2. Nanometer, SingleLink -> Null|>,
				<|UnitColumn -> 3. Nanometer, SingleLink -> _Link|>
			},
			SetUp :> (setupNamedMultipleErase[])
		],

		Example[{Additional, "Erase", "Delete a specific index in an IndexedSingle field:"},
			With[
				{
					object=Upload[<|
						Type -> Model[Container, Vessel],
						Replace[Dimensions] -> {1 Meter, 1 Meter, 1 Meter},
						DeveloperObject -> True
					|>]
				},
				Download[
					Upload[<|Object -> object, Erase[Dimensions] -> 2|>],
					Dimensions
				]
			],
			{1.0 Meter, Null, 1.0 Meter}
		],

		Test["Delete a column in a named single field:",
			Download[
				Upload[<|
					Object -> Object[Example, Data, "Test Erase NamedSingle 1"],
					Erase[NamedSingle] -> MultipleLink
				|>],
				NamedSingle
			],
			<|UnitColumn -> 1. Nanometer, MultipleLink -> Null|>,
			SetUp :> (setupNamedMultipleErase[])
		],

		Test["A single row can be deleted from a multiple field:", With[
			{object=Upload[<|Type -> Object[Example, Data], Replace[Random] -> {1, 2, 3}|>]},

			Upload[<|Object -> object, Erase[Random] -> 2|>];
			object[Random]
		],
			{1., 3.}
		],

		Test["Multiple rows can be deleted from a multiple field:", With[
			{object=Upload[<|Type -> Object[Example, Data], Replace[Random] -> {1, 2, 3}|>]},

			Upload[<|Object -> object, Erase[Random] -> {{1}, {3}}|>];
			object[Random]
		],
			{2.}
		],

		Test["Deleting a negative index removes that index as counted from the end:", With[
			{object=Upload[<|Type -> Object[Example, Data], Replace[Random] -> {1, 2, 3}|>]},

			Upload[<|Object -> object, Erase[Random] -> -1|>];
			object[Random]
		],
			{1., 2.}
		],

		Test["A single row can be deleted from an indexed field:", With[
			{objects=Upload[Table[<|Type -> Object[Example, Data]|>, {2}]]},

			Upload[<|
				Object -> objects[[1]],
				IndexedSingle -> {1, "1", Link[objects[[2]], IndexedSingleBacklink]}
			|>];
			Upload[<|Object -> objects[[1]], Erase[IndexedSingle] -> 2|>];
			objects[[1]][IndexedSingle]
		],
			{1 Meter, Null, LinkP[]}
		],

		Test["Multiple rows can be deleted from an indexed field:", With[
			{objects=Upload[Table[<|Type -> Object[Example, Data]|>, {2}]]},

			Upload[<|
				Object -> objects[[1]],
				IndexedSingle -> {1, "1", Link[objects[[2]], IndexedSingleBacklink]}
			|>];

			Upload[<|Object -> objects[[1]], Erase[IndexedSingle] -> {{1}, {3}}|>];
			objects[[1]][IndexedSingle]
		],
			{Null, "1", Null}
		],

		Test["Multiple rows can be deleted from a multiple indexed field:",
			Module[
				{linkIds, objects, links, backLinks},

				linkIds=CreateLinkID[3];
				objects=Upload[Table[<|Type -> Object[Example, Data]|>, {2}]];
				links=Map[Link[objects[[2]], GroupedMultipleAppendRelationAmbiguous, 2, #]&, linkIds];
				backLinks=Map[Link[objects[[1]], GroupedMultipleAppendRelation, 2, #]&, linkIds];
				Upload[{
					<|
						Object -> objects[[1]],
						Replace[GroupedMultipleAppendRelation] -> {
							{"1", links[[1]]},
							{"2", links[[2]]},
							{"3", links[[3]]}
						}
					|>,
					<|
						Object -> objects[[2]],
						Replace[GroupedMultipleAppendRelationAmbiguous] -> {
							{"1", backLinks[[1]]},
							{"2", backLinks[[2]]},
							{"3", backLinks[[3]]}
						}
					|>
				}];
				Upload[<|
					Object -> objects[[1]],
					Erase[GroupedMultipleAppendRelation] -> {{1}, {3}}
				|>];
				{
					objects[[1]][GroupedMultipleAppendRelation],
					objects[[2]][GroupedMultipleAppendRelationAmbiguous]
				}
			],
			{
				{{"2", LinkP[]}},
				{{"2", LinkP[]}}
			}
		],

		Test["A single row can be deleted from a multiple indexed field:",
			Module[
				{linkIds, objects, links, backLinks},

				linkIds=CreateLinkID[3];
				objects=Upload[Table[<|Type -> Object[Example, Data]|>, {2}]];
				links=Map[Link[objects[[2]], GroupedMultipleAppendRelationAmbiguous, 2, #]&, linkIds];
				backLinks=Map[Link[objects[[1]], GroupedMultipleAppendRelation, 2, #]&, linkIds];
				Upload[{
					<|
						Object -> objects[[1]],
						Replace[GroupedMultipleAppendRelation] -> {
							{"1", links[[1]]},
							{"2", links[[2]]},
							{"3", links[[3]]}
						}
					|>,
					<|
						Object -> objects[[2]],
						Replace[GroupedMultipleAppendRelationAmbiguous] -> {
							{"1", backLinks[[1]]},
							{"2", backLinks[[2]]},
							{"3", backLinks[[3]]}
						}
					|>
				}];
				Upload[<|
					Object -> objects[[1]],
					Erase[GroupedMultipleAppendRelation] -> 2
				|>];
				{
					objects[[1]][GroupedMultipleAppendRelation],
					objects[[2]][GroupedMultipleAppendRelationAmbiguous]
				}
			],
			{
				{{"1", LinkP[]}, {"3", LinkP[]}},
				{{"1", LinkP[]}, {"3", LinkP[]}}
			}
		],

		Test["A single column can be deleted from a multiple indexed field:",
			Module[
				{linkIds, objects, links, backLinks},

				linkIds=CreateLinkID[3];
				objects=Upload[Table[<|Type -> Object[Example, Data]|>, {2}]];
				links=Map[Link[objects[[2]], GroupedMultipleAppendRelationAmbiguous, 2, #]&, linkIds];
				backLinks=Map[Link[objects[[1]], GroupedMultipleAppendRelation, 2, #]&, linkIds];
				Upload[{
					<|
						Object -> objects[[1]],
						Replace[GroupedMultipleAppendRelation] -> {
							{"1", links[[1]]},
							{"2", links[[2]]},
							{"3", links[[3]]}
						}
					|>,
					<|
						Object -> objects[[2]],
						Replace[GroupedMultipleAppendRelationAmbiguous] -> {
							{"1", backLinks[[1]]},
							{"2", backLinks[[2]]},
							{"3", backLinks[[3]]}
						}
					|>
				}];
				Upload[<|
					Object -> objects[[1]],
					Erase[GroupedMultipleAppendRelation] -> {All, 2}
				|>];

				objects[[1]][GroupedMultipleAppendRelation]
			],

			{{"1", Null}, {"2", Null}, {"3", Null}}
		],

		Test["A row and column can be deleted from a multiple indexed field:",
			Module[
				{linkIds, objects, links, backLinks},

				linkIds=CreateLinkID[3];
				objects=Upload[Table[<|Type -> Object[Example, Data]|>, {2}]];
				links=Map[Link[objects[[2]], GroupedMultipleAppendRelationAmbiguous, 2, #]&, linkIds];
				backLinks=Map[Link[objects[[1]], GroupedMultipleAppendRelation, 2, #]&, linkIds];
				Upload[{
					<|
						Object -> objects[[1]],
						Replace[GroupedMultipleAppendRelation] -> {
							{"1", links[[1]]},
							{"2", links[[2]]},
							{"3", links[[3]]}
						}
					|>,
					<|
						Object -> objects[[2]],
						Replace[GroupedMultipleAppendRelationAmbiguous] -> {
							{"1", backLinks[[1]]},
							{"2", backLinks[[2]]},
							{"3", backLinks[[3]]}
						}
					|>
				}];
				Upload[<|
					Object -> objects[[1]],
					Erase[GroupedMultipleAppendRelation] -> {2, 2}
				|>];
				{
					objects[[1]][GroupedMultipleAppendRelation],
					objects[[2]][GroupedMultipleAppendRelationAmbiguous]
				}
			],
			{
				{{"1", LinkP[]}, {"2", Null}, {"3", LinkP[]}},
				{{"1", LinkP[]}, {"3", LinkP[]}}
			}
		],

		(* Named fields *)
		Example[{Additional, "NamedFields", "Upload named fields:"},
			With[
				{
					obj=CreateID[{Object[Example, Data], Object[Example, Data]}],
					linkId=CreateLinkID[]
				},

				Upload[{
					<|
						Object -> obj[[1]],
						NamedSingle -> <|
							UnitColumn -> 1. Nanometer,
							MultipleLink -> Link[obj[[2]], NamedMultiple, SingleLink, linkId]
						|>
					|>,
					<|
						Object -> obj[[2]],
						Replace[NamedMultiple] -> {
							<|
								UnitColumn -> 1. Nanometer,
								SingleLink -> Link[obj[[1]], NamedSingle, MultipleLink, linkId]
							|>
						}
					|>
				}]
			],
			{ObjectReferenceP[Object[Example, Data]], ObjectReferenceP[Object[Example, Data]]}
		],

		Example[{Messages, "NamedField", "Uploading a list to a named field provides a message and returns $Failed:"},
			Upload[{
				<|
					Type -> Object[Example, Data],
					NamedSingle -> {UnitColumn -> 1 Nanometer, MultipleLink -> Null}
				|>,
				<|
					Type -> Object[Example, Data],
					NamedSingle -> {UnitColumn -> 1 Nanometer, MultipleLink -> Null}
				|>
			}],
			{$Failed, $Failed},
			Messages :> {Message[
				Upload::NamedField,
				{{NamedSingle}, {NamedSingle}},
				{Object[Example, Data], Object[Example, Data]},
				{1, 2}
			]}
		],

		Example[{Messages, "NamedMultipleField", "Uploading a list of lists to a named multiple field provides a message and returns $Failed:"},
			Upload[{
				<|
					Type -> Object[Example, Data],
					Append[NamedMultiple] -> {
						{UnitColumn -> 1 Nanometer, MultipleLink -> Null}
					}
				|>,
				<|
					Type -> Object[Example, Data],
					Replace[NamedMultiple] -> {
						{UnitColumn -> 1 Nanometer, MultipleLink -> Null}
					}
				|>
			}],
			{$Failed, $Failed},
			Messages :> {Message[
				Upload::NamedMultipleField,
				{{NamedMultiple}, {NamedMultiple}},
				{Object[Example, Data], Object[Example, Data]},
				{1, 2}
			]}
		],

		Test["Uploading an incomplete named field returns $Failed and a message:",
			Upload[<|Type -> Object[Example, Data], NamedSingle -> <|UnitColumn -> 1 Nanometer|>|>],
			$Failed,
			Messages :> {
				Message[Upload::FieldStoragePattern, {{NamedSingle}}, {Object[Example, Data]}, {1}]
			}
		],

		Test["Uploading a named field with bad keys returns $Failed and a message:",
			Upload[<|
				Type -> Object[Example, Data],
				NamedSingle -> <|BadColumn1 -> 1 Nanometer, BadColumn2 -> Null|>
			|>],
			$Failed,
			Messages :> {
				Message[Upload::FieldStoragePattern, {{NamedSingle}}, {Object[Example, Data]}, {1}]
			}
		],

		Test["Uploading a named field with bad values returns $Failed and a message:",
			Upload[<|
				Type -> Object[Example, Data],
				NamedSingle -> <|UnitColumn -> -1 Nanometer, MultipleLink -> Null|>
			|>],
			$Failed,
			Messages :> {
				Message[Upload::FieldStoragePattern, {{NamedSingle}}, {Object[Example, Data]}, {1}]
			}
		],

		Test["Uploading a named multiple field with bad values returns $Failed and a message:",
			Upload[<|
				Type -> Object[Example, Data],
				Replace[NamedMultiple] -> {<|UnitColumn -> -1 Nanometer, MultipleLink -> Null|>}
			|>],
			$Failed,
			Messages :> {
				Message[Upload::FieldStoragePattern, {{NamedMultiple}}, {Object[Example, Data]}, {1}]
			}
		],

		Test["Uploading a named multiple field with a single row returns $Failed and a message:",
			Upload[<|
				Type -> Object[Example, Data],
				Replace[NamedMultiple] -> <|UnitColumn -> -1 Nanometer, MultipleLink -> Null|>
			|>],
			$Failed,
			Messages :> {
				Message[Upload::FieldStoragePattern, {{NamedMultiple}}, {Object[Example, Data]}, {1}]
			}
		],

		Test["When creating a private object without specifying the notebook, use the default notebook:",
			Block[{$AllowPublicObjects = False},
				Download[
					Upload[<|Type -> Object[Example, Data]|>],
					Notebook[Object]
				]
			],
			ObjectReferenceP[Object[LaboratoryNotebook]],
			Messages :> {
				Message[Upload::Warning]
			}
		],

		Test["Set the Notebook field of an object on creation only:",
			Upload[<|
				Type -> Object[Example, Data],
				Notebook -> Link[Object[LaboratoryNotebook, "Test Notebook"], Objects]
			|>],
			ObjectReferenceP[Object[Example, Data]],
			SetUp :> (setupExampleNotebook[])
		],

		Test["Set the Notebook field to $Notebook if not set:",
			Block[
				{$Notebook=Download[Object[LaboratoryNotebook, "Test Notebook"], Object]},

				Download[
					Upload[<|Type -> Object[Example, Data]|>],
					Notebook
				]
			],
			LinkP[Object[LaboratoryNotebook]],
			SetUp :> (setupExampleNotebook[])
		],

		Test["Notebook field set in a packet takes precedence over $Notebook:",
			Block[
				{$Notebook=Object[LaboratoryNotebook, "123"]},

				Download[
					Upload[<|Type -> Object[Example, Data], Notebook -> Link[Object[LaboratoryNotebook, "Test Notebook"], Objects]|>],
					Notebook
				]
			],
			PatternTest[LinkP[Object[LaboratoryNotebook]], "Test Notebook" === Download[#, Name]&],
			SetUp :> {setupExampleNotebook[], setupNotebookNamed123[]}
		],

		Test["Public objects have no notebook linked to them:",
			With[
				{object=Upload[<|Type -> Object[Example, Data]|>, AllowPublicObjects -> True]},
				Download[object, Notebook]
			],
			Null
		],

		Test["An attempt to create what would otherwise be a public object when no explicit permission is granted should fail",
			Block[
				{$AllowPublicObjects = False}, (* this is the default, but unit tests have been globally given carte blanche to create public objects *)
				With[
					{object = Upload[<|Type -> Object[Example, Data]|>]},
					Download[object, Notebook]
				]
			],
			$Failed,
			SetUp :> (
				Constellation`Private`AssumeIdentity[
					Object[User, "Test user for notebook-less test protocols"],
					Constellation`Private`AllowRollback -> True
				];
			),
			TearDown :> (
				Constellation`Private`RollbackAssumeIdentity[];
			),
			Messages :> {
				Upload::PublicObjectCreationDenied
			}
		],

		Test["Public objects have no notebook linked to them:",
			With[
				{object=Upload[<|Type -> Object[Example, Data]|>, AllowPublicObjects -> True]},
				Download[object, Notebook]
			],
			Null
		],

		Example[{Messages, "PartDoesntExist", "Deleting a section that does not exist provides an error message:"},
			With[
				{object=Upload[<|
					Type -> Object[Analysis, Fit],
					Replace[BestFitVariables] -> {X, Y, Z},
					DeveloperObject -> True
				|>]},

				Upload[<|Object -> object, Erase[BestFitVariables] -> 4|>]
			],
			$Failed,
			Messages :> {Upload::PartDoesntExist}
		],

		Example[{Messages, "ObjectsField", "The Objects field of a LaboratoryNotebook cannot be modified directly:"},
			Upload[<|Object -> Object[LaboratoryNotebook, "Test Notebook"], Append[Objects] -> Link[$PersonID, Notebook]|>],
			$Failed,
			Messages :> {Upload::ObjectsField},
			SetUp :> (setupExampleNotebook[])
		],

		Example[{Messages, "EmptyName", "Uploading an object with an empty name returns $Failed and provides a message:"},
			Upload[{
				<|Type -> Object[Sample], DeveloperObject -> True|>,
				<|Type -> Object[Sample], Name -> "", DeveloperObject -> True|>,
				<|Type -> Object[Sample], Name -> "", DeveloperObject -> True|>
			}],
			{$Failed, $Failed, $Failed},
			Messages :> {Message[Upload::EmptyName, {2, 3}]}
		],

		Example[{Messages, "NameStartsWithId", "Uploading an object with a name that starts with id: returns $Failed and provides a message:"},
			randomStr=ToString[RandomReal[]];
			Upload[{
				<|Type -> Object[Sample], DeveloperObject -> True|>,
				<|Type -> Object[Sample], DeveloperObject -> True, Name -> Null|>,
				<|Type -> Object[Sample], Name -> "id:"<>randomStr, DeveloperObject -> True|>,
				<|Type -> Object[Sample], Name -> "id:"<>randomStr, DeveloperObject -> True|>
			}],
			{$Failed, $Failed, $Failed, $Failed},
			Messages :> {Message[Upload::NameStartsWithId, {3, 4}]}
		],

		Example[{Messages, "FieldStoragePattern", "Data must match the pattern of the corresponding field:"},
			Upload[{
				<|
					Type -> Object[Transaction, Order],
					Replace[ReceivedItems] -> {Link[Object[Sample, "id:zGj91aRrxbjO"]]},
					DeveloperObject -> True
				|>,
				<|
					Object -> Object[User, Emerald, "id:eGakld01z34e"],
					CakePreference -> 5,
					Name -> "123"
				|>
			}],
			{$Failed, $Failed},
			Messages :> {Upload::FieldStoragePattern}
		],

		Example[{Messages, "FieldStoragePattern", "When using EraseCases, value to be deleted must match the storage pattern for the field:"},
			Upload[<|Object -> Object[Container, Plate, "Download Test Plate"], EraseCases[Contents] -> 4|>],
			$Failed,
			Messages :> {
				Message[Upload::FieldStoragePattern, {{Contents}}, {Object[Container, Plate, "Download Test Plate"]}, {1}]
			}
		],

		Test["Indexed fields must have the correct number of fields:",
			Upload[<|
				Type -> Object[Example, Data],
				Append[GroupedMultipleAppendRelation] -> {Object[Example, Data, "f0addaa5c1fd"]}
			|>],
			$Failed,
			Messages :> {Upload::FieldStoragePattern}
		],

		Test["Invalid Object field provides a FieldStoragePattern message when there is no Type field:",
			Upload[<|Object -> Object[Sample]|>],
			$Failed,
			Messages :> {
				Message[Upload::FieldStoragePattern, {{Object}}, {$Failed}, {1}],
				Message[Upload::TypeNotSpecified, {1}]
			}
		],

		Test["Invalid Object field provides a FieldStoragePattern message when there is a Type field:",
			Upload[<|Object -> Object[Sample], Type -> Object[Sample]|>],
			$Failed,
			Messages :> {
				Message[Upload::FieldStoragePattern, {{Object}}, {Object[Sample]}, {1}]
			}
		],

		Test["Null indexed elements are valid:",
			Upload[<|
				Type -> Object[Example, Data],
				Append[GroupedMultipleAppendRelation] -> {{Null, Null}}|>
			],
			ObjectReferenceP[Object[Example, Data]]
		],

		Test["Appending a Null value fails:",
			Upload[<|Type -> Object[Example, Data], Append[Random] -> Null|>],
			$Failed,
			Messages :> {Upload::FieldStoragePattern}
		],

		Test["Implicit units are provided:",
			Upload[<|Type -> Object[Example, Data], Temperature -> 10|>],
			ObjectReferenceP[Object[Example, Data]]
		],

		Test["Links to Named Fields must specify subfields:",
			With[{objects=CreateID[Table[Object[Example, Data], {2}]]},
				Upload[<|
					Object -> objects[[1]],
					Replace[NamedMultiple] -> {<|
						SingleLink -> Link[objects[[2]], NamedSingle],
						UnitColumn -> 12
					|>}
				|>]
			],
			$Failed,
			Messages :> {Upload::FieldStoragePattern}
		],

		Test["Links to Indexed fields must specify indices:",
			With[{objects=CreateID[Table[Object[Example, Data], {2}]]},
				Upload[<|
					Object -> objects[[1]],
					Replace[GroupedMultipleAppendRelation] -> {
						"1",
						Link[objects[[2]], GroupedMultipleAppendRelation]
					}
				|>]
			],
			$Failed,
			Messages :> {Upload::FieldStoragePattern}
		],

		Example[{Messages, "MultipleField", "Multiple fields must be wrapped in either Replace, Append or Erase:"},
			With[{
				chemical=CreateID[Object[Sample]],
				person=CreateID[Object[User]]
			},
				Upload[{
					<|
						Type -> Object[Transaction, Order],
						ReceivedItems -> {Link[chemical]},
						BatchNumbers -> {"1"},
						DeveloperObject -> True
					|>,
					<|
						Object -> person,
						ProtocolsAuthored -> {},
						DeveloperObject -> True
					|>
				}]
			],
			{$Failed, $Failed},
			(* TODO: Once message matching bug is fixed, this could use a more specific message *)
			Messages :> {Upload::MultipleField}
		],

		Test["An indexed multiple field can be replaced with a single list:",
			Upload[<|
				Type -> Object[Sample],
				Replace[StatusLog] -> {Now, InUse, Null},
				DeveloperObject -> True
			|>],
			ObjectReferenceP[Object[Sample]]
		],

		Test["An indexed multiple field can be appended to with a single list:",
			Upload[<|
				Type -> Object[Sample],
				Append[StatusLog] -> {Now, InUse, Null},
				DeveloperObject -> True
			|>],
			ObjectReferenceP[Object[Sample]]
		],

		Test["Single fields may be wrapped in Replace or Append:",
			Upload[<|
				Type -> Object[Sample],
				Replace[Restricted] -> True,
				Append[Status] -> InUse,
				DeveloperObject -> True
			|>],
			ObjectReferenceP[Object[Sample]]
		],

		Example[{Messages, "SingleEraseField", "Single non indexed fields must not be wrapped in Erase:"},
			With[{obj=CreateID[Object[Sample]]},
				Upload[<|Object -> obj, Erase[Name] -> 1, DeveloperObject -> True|>]
			],
			$Failed,
			Messages :> {Upload::SingleEraseField}
		],

		Example[{Messages, "NoObject", "Packets with Erase operator must reference specific Object:"},
			Upload[<|Type -> Object[Sample], Erase[StatusLog] -> 1, DeveloperObject -> True|>],
			$Failed,
			Messages :> {Message[Upload::NoObject, {1}, {Erase[StatusLog]}]}
		],

		Example[{Messages, "NonUniqueLinkID", "A link id must not already exist in the database:"},
			With[
				{
					existingId=Last[Download[Object[Sample, "Download Test Oligomer"], Container]],
					containerObj=CreateID[Object[Container, Plate]],
					sampleObj=CreateID[Object[Sample]]
				},

				Upload[{
					<|Object -> sampleObj, Container -> Link[containerObj, Contents, 2, existingId]|>,
					<|Object -> containerObj, Replace[Contents] -> {{"A1", Link[sampleObj, Container, existingId]}}|>
				}]
			],
			{$Failed, $Failed},
			Messages :> {Upload::NonUniqueLinkID},
			SetUp :> (setupDownloadExampleObjects[])
		],

		Example[{Messages, "NonUniqueName", "Uploading an object with a name that already exists returns $Failed and provides a message:"},
			(
				Upload[<|
					Type -> Object[Sample],
					Name -> "Upload Test: Duplicate Name",
					DeveloperObject -> True
				|>];
				Upload[<|
					Type -> Object[Sample],
					Name -> "Upload Test: Duplicate Name",
					DeveloperObject -> True
				|>]
			),
			$Failed,
			Messages :> {Upload::NonUniqueName},
			SetUp :> Quiet[
				EraseObject[
					Download[Object[Sample, "Upload Test: Duplicate Name"], Object],
					Force -> True
				],
				Download::ObjectDoesNotExist
			]
		],

		Example[{Messages, "TypeNotSpecified", "Change packets must have either Object or Type key:"},
			Upload[{
				<|Type -> Object[Sample], DeveloperObject -> True|>,
				<|CakePreference -> "funfetti"|>,
				<|CakePreference -> "all cake"|>
			}],
			{$Failed, $Failed, $Failed},
			Messages :> {Message[Upload::TypeNotSpecified, {2, 3}]}
		],

		Example[{Messages, "NoSuchType", "Change packets must use an existing type:"},
			Upload[<|Type -> Object[Bad, Type], DeveloperObject -> True|>],
			$Failed,
			Messages :> {Message[Upload::NoSuchType, {Object[Bad, Type]}, {1}]}
		],

		Example[{Messages, "NoSuchField", "Change packets must have fields that exist in their types:"},
			Upload[<|Type -> Object[Sample], NotAField -> 1, DeveloperObject -> True|>],
			$Failed,
			Messages :> {Message[Upload::NoSuchField, {{NotAField}}, {Object[Sample]}, {1}]}
		],

		Test["Erase fields must exist:",
			With[{obj=CreateID[Object[Sample]]},
				Upload[<|Object -> obj, Erase[NotAField] -> 2, DeveloperObject -> True|>]
			],
			$Failed,
			Messages :> {Upload::NoSuchField}
		],

		Test["Erase fields must exist:",
			Upload[<|Type -> Object[Sample], Append[NotAField] -> 2, DeveloperObject -> True|>],
			$Failed,
			Messages :> {Upload::NoSuchField}
		],

		Example[{Messages, "ErasePattern", "Erase must correspond to an erase part specification:"},
			With[{obj=CreateID[Object[Sample]]},
				Upload[<|
					Object -> obj,
					Erase[LocationLog] -> 7.0,
					Erase[VolumeLog] -> "seven",
					DeveloperObject -> True
				|>]
			],
			$Failed,
			Messages :> {Message[Upload::ErasePattern, {{7.0, "seven"}}, {1}]}
		],

		Example[{Messages, "EraseDimension", "Erase part specification must have dimension corresponding to the field:"},
			With[{obj=CreateID[Model[Container, Vessel]]},
				Upload[<|
					Object -> obj,
					Erase[Dimensions] -> {1, 2},
					DeveloperObject -> True
				|>]
			],
			$Failed,
			Messages :> {Message[Upload::EraseDimension, {{{1, 2}}}, {1}, {{Dimensions}}]}
		],

		Example[{Messages, "RepeatLinkID", "Manually generated link ids must point at each other:"},
			With[
				{
					container=CreateID[Object[Container, Plate]],
					sample=CreateID[Object[Sample]],
					id=CreateLinkID[]
				},
				Upload[{
					<|
						Object -> container,
						Replace[Contents] -> {{"A1", Link[sample, Container, id]}}
					|>,
					<|
						Object -> sample,
						Replace[LocationLog] -> {{Null, Null, Link[container, ContentsLog, 3, id], Null, Null}}
					|>
				}]
			],
			{$Failed, $Failed},
			Messages :> {Upload::RepeatLinkID}
		],

		Example[{Messages, "FieldStoragePattern", "Links must point to the correct field:"},
			Upload[<|
				Type -> Object[Example, Data],
				Replace[MultipleAppendRelation] -> {Link[Object[Example, Data, "f0addaa5c1fd"], TestRun]}
			|>],
			$Failed,
			Messages :> {Message[
				Upload::FieldStoragePattern,
				{{MultipleAppendRelation}},
				{Object[Example, Data]},
				{1}
			]}
		],

		Test["Links must point to the correct object:",
			Upload[<|
				Type -> Object[Example, Data],
				Append[MultipleAppendRelation] -> {Link[
					Object[Example, Person Emerald, "f0addaa5c1fd"],
					MultipleAppendRelationAmbiguous
				]}|>],
			$Failed,
			Messages :> {Message[
				Upload::FieldStoragePattern,
				{{MultipleAppendRelation}},
				{Object[Example, Data]},
				{1}
			]}
		],

		Test["The same link ID cannot be used more than once in a single Upload:",
			With[
				{
					id=CreateLinkID[],
					people=CreateID[Table[Object[User], {2}]],
					protocols=CreateID[Table[Object[Protocol, HPLC], {2}]]
				},

				Upload[{
					<|
						Object -> people[[1]],
						Replace[ProtocolsAuthored] -> {Link[protocols[[1]], Author, id]},
						DeveloperObject -> True
					|>,
					<|
						Object -> protocols[[1]],
						Author -> Link[people[[1]], ProtocolsAuthored, id],
						DeveloperObject -> True
					|>,
					<|
						Object -> people[[2]],
						Replace[ProtocolsAuthored] -> {Link[protocols[[2]], Author, id]},
						DeveloperObject -> True
					|>,
					<|
						Object -> protocols[[2]],
						Author -> Link[people[[2]], ProtocolsAuthored, id],
						DeveloperObject -> True
					|>
				}]
			],
			{$Failed, $Failed, $Failed, $Failed},
			Messages :> {Upload::RepeatLinkID}
		],

		Test["Only throw one message when a single value used for an indexed multiple field:",
			With[
				{object=CreateID[Object[Example, Data]]},

				Upload[<|
					Object -> object,
					Append[GroupedUnits] -> 4
				|>]
			],
			$Failed,
			Messages :> {Upload::FieldStoragePattern}
		],

		Example[{Messages, "Error", "Returns $Failed and displays a message if there was a problem communicating with the server:"},
			Upload[<|Type -> Object[Sample], DeveloperObject -> True|>],
			$Failed,
			Messages :> {Upload::Error},
			Stubs :> {
				ConstellationRequest[___]:=HTTPError[None, "Server error."]
			}
		],

		Example[{Messages, "SingleEraseCases", "EraseCases can only be used with multiple fields:"},
			Upload[<|Object -> Object[Container, Plate, "Download Test Plate"], EraseCases[Name] -> "Hello"|>],
			$Failed,
			Messages :> {
				Upload::SingleEraseCases
			},
			SetUp :> (
				setupDownloadExampleObjects[]
			)
		],

		Example[{Additional, "EraseCases", "Delete all values in a multiple field which match the literal value specified:"},
			With[
				{object=Upload[<|
					Type -> Model[Instrument, Centrifuge],
					Replace[ContainerCapacity] -> {1, 2, 3, 2, 4},
					DeveloperObject -> True
				|>]},

				{
					Upload[<|Object -> object, EraseCases[ContainerCapacity] -> 2|>],
					Download[object, ContainerCapacity]
				}
			],
			{
				ObjectReferenceP[Model[Instrument, Centrifuge]],
				{1, 3, 4}
			}
		],

		Test["EraseCases on a multiple field with links:",
			Module[
				{objects, links, linkToDelete},

				objects=CreateID[Table[Object[Example, Data], {4}]];
				links=Link[#, MultipleAppendRelationAmbiguous]& /@ Rest[objects];
				Upload[<|Object -> objects[[1]], Append[MultipleAppendRelation] -> links|>];

				linkToDelete=Download[objects[[1]], MultipleAppendRelation][[2]];

				Upload[<|Object -> objects[[1]], EraseCases[MultipleAppendRelation] -> linkToDelete|>];

				Download[{{First[objects]}, Rest[objects]}, {{MultipleAppendRelation}, {MultipleAppendRelationAmbiguous}}]
			],
			{{{{LinkP[], LinkP[]}}} , {{{LinkP[]}}, {{}}, {{LinkP[]}}}}
		],

		Test["EraseCases on an indexed multiple field with cloud files:",
			Module[
				{object, cloudFile, preDownload},
				cloudFile=Constellation`Private`uploadCloudFile[FindFile["ExampleData/lena.tif"]];
				object=Upload[<|
					Type -> Object[Example, Data],
					Replace[IndexedCloudFile] -> {{12, cloudFile}}
				|>];

				preDownload=Download[object, IndexedCloudFile];
				Upload[<|Object -> object, EraseCases[IndexedCloudFile] -> {12, cloudFile}|>];
				{
					preDownload,
					Download[object, IndexedCloudFile]
				}
			],
			{
				{{12, _EmeraldCloudFile}},
				{}
			}
		],

		Test["EraseCases on an indexed multiple field with links:",
			Module[
				{object, linkedObject, preDownload},
				linkedObject=CreateID[Object[Example, Data]];
				object=Upload[<|
					Type -> Object[Example, Data],
					Replace[GroupedMultipleAppendRelation] -> {{"A1", Link[linkedObject, GroupedMultipleAppendRelationAmbiguous, 2]}}
				|>];

				preDownload=Download[object, GroupedMultipleAppendRelation];
				Upload[<|Object -> object, EraseCases[GroupedMultipleAppendRelation] -> preDownload[[1]]|>];

				{
					preDownload,
					Download[object, GroupedMultipleAppendRelation]
				}
			],
			{
				{{"A1", LinkP[]}},
				{}
			}
		],

		Test["EraseCases on an indexed multiple field with units:",
			Module[
				{object, preDownload},
				object=Upload[<|
					Type -> Object[Example, Data],
					Replace[GroupedUnits] -> {{"A1", 12 Second}, {"A2", 10 Minute}, {"A1", 12 Second}}
				|>];

				preDownload=Download[object, GroupedUnits];
				Upload[<|Object -> object, EraseCases[GroupedUnits] -> {"A1", 12 Second}|>];

				{
					preDownload,
					Download[object, GroupedUnits]
				}
			],
			{
				{{"A1", 12.0 Second}, {"A2", 600.0 Second}, {"A1", 12.0 Second}},
				{{"A2", 600.0 Second}}
			}
		],

		Example[{Additional, "Transfer", "Super users can transfer objects to different notebooks:"},
			(
				obj=Upload[<|Type -> Object[Sample], Notebook -> Link[nb1, Objects]|>];
				Upload[<|Object -> obj, Transfer[Notebook] -> Link[nb2, Objects]|>];
				Download[obj, Notebook]
			),
			LinkP[nb2],
			Variables :> {nb1, nb2, obj},
			SetUp :> (
				nb1=Upload[<|Type -> Object[LaboratoryNotebook], DeveloperObject -> True|>];
				nb2=Upload[<|Type -> Object[LaboratoryNotebook], DeveloperObject -> True|>]
			)
		],
		Example[{Additional, "TemporalLinks", "Uploading Temporal Links to a link class will fail, even if the Field pattern accepts a Temporal Link:"},
			{Upload[Association[Object -> closeObject, OneWayLink -> Link[farObject, Now]]], Upload[Association[Object -> closeObject, OneWayLinkTemporal -> Link[farObject, Now]]]},
			{$Failed, closeObject},
			Messages :> {
				Message[Upload::FieldStoragePattern,
					{{OneWayLink}},
					{closeObject},
					{1}
				]
			},
			SetUp :> {
				farObject=Upload[Association[Object -> CreateID[Object[Example, Analysis]]]];
				closeObject=Upload[Association[Object -> CreateID[Object[Example, Data]]]]
			}
		],
		Example[{Additional, "TemporalLinks", "Field Pattern permitting, links can be uploaded to fields of the TemporalLink class:"},
			Upload[Association[Object -> closeObject, Replace[DataAnalysisTemporal] -> {Link[closeObject], Link[closeObject, Now]}]],
			closeObject,
			SetUp :> {
				farObject=Upload[Association[Object -> CreateID[Object[Example, Analysis]]]];
				closeObject=Upload[Association[Object -> CreateID[Object[Example, Data]]]]
			}
		],
		Test["Super users can remove notebooks from objects:",
			(
				obj=Upload[<|Type -> Object[Sample], Notebook -> Link[nb, Objects]|>];
				Upload[<|Object -> obj, Transfer[Notebook] -> Null|>];
				Download[obj, Notebook]
			),
			Null,
			Variables :> {nb, obj},
			SetUp :> (
				nb=Upload[<|Type -> Object[LaboratoryNotebook], DeveloperObject -> True|>];
			)
		],

		Test["Transferring a notebook with a one way link fails and provides a message:",
			Upload[<|Object -> obj, Transfer[Notebook] -> Link[nb1]|>],
			$Failed,
			Messages :> {Upload::BadTransfer},
			Variables :> {obj, nb1, nb2},
			SetUp :> (
				nb1=Upload[<|Type -> Object[LaboratoryNotebook], DeveloperObject -> True|>];
				nb2=Upload[<|Type -> Object[LaboratoryNotebook], DeveloperObject -> True|>];
				obj=Upload[<|Type -> Object[Sample], DeveloperObject -> True|>]
			),
			TearDown :> (
				EraseObject[{nb1, nb2, obj}, Force -> True]
			)
		],
		Test["Transferring a object to Notebook -> Null on first upload where Notebook would implicitly be set works:",
			Download[Block[{$Notebook=nb}, Upload[<|Object -> obj, Notebook -> Null|>]], {Notebook}],
			{Null},
			Variables :> {obj, nb},
			SetUp :> (
				nb=Upload[<|Type -> Object[LaboratoryNotebook], DeveloperObject -> True|>];
				obj=CreateID[Object[Example, Data]]
			),
			TearDown :> (
				EraseObject[{nb, obj}, Force -> True]
			)
		],

		Example[{Messages, "BadTransfer", "Transferring a field other than Notebook returns $Failed and provides a message:"},
			Upload[<|Type -> Object[Sample], Transfer[Name] -> "A Name"|>],
			$Failed,
			Messages :> {
				Message[Upload::BadTransfer,
					{{Name}},
					{{"A Name"}},
					{Object[Sample]}
				]
			}
		],

		Example[{Messages, "NotAllowed", "Performing an operation you do not have permission for returns $Failed and provides a message:"},
			With[{obj=Upload[<|Type -> Object[Sample], DeveloperObject -> True|>]},
				Upload[<|Object -> obj, Notebook -> Null|>]
			],
			$Failed,
			Messages :> {Message[Upload::NotAllowed]}
		],

		Example[{Additional, "VariableUnit", "Data can be uploaded to VariableUnit fields:"},
			Upload[{
				<| Type -> Object[Example, Data], VariableUnitData -> 3 Gallon, DeveloperObject -> True |>,
				<| Type -> Object[Example, Data], VariableUnitData -> 7 Kilogram, DeveloperObject -> True |>
			}],
			{
				ObjectReferenceP[Object[Example, Data]],
				ObjectReferenceP[Object[Example, Data]]
			}
		],

		Test["Unsupported (server-side) units can't be uploaded to VariableUnit fields:",
			Upload@<|
				Type -> Object[Example, Data],
				(* radiant intensity, including SolidAngleUnit *)
				VariableWildcard -> (Quantity[1, "Watts"] / Quantity[1, "People"]),
				DeveloperObject -> True
			|>,
			$Failed,
			Messages :> {
				Message[Upload::Error]
			}
		],

		Test["Data with no units can't be uploaded to VariableUnit fields:",
			Upload@<|
				Type -> Object[Example, Data],
				(* radiant intensity, including SolidAngleUnit *)
				VariableWildcard -> 7,
				DeveloperObject -> True
			|>,
			$Failed,
			Messages :> {
				Message[jsonValueData::FailedToMatch],
				Message[Upload::Error],
				Message[Export::jsonstrictencoding]
			}
		],

		Example[{Additional, "BigDataQuantityArray", "Uploading BigDataQuantityArray fields work:"},
			(
				bigQA=QuantityArray[RandomReal[10000, {1000, 3}], {Minute, Meter Nano, AbsorbanceUnit Milli}];
				obj=Upload[<|Type -> Object[Example, Data], BigDataQuantityArray -> bigQA|>];
				check=Download[obj, BigDataQuantityArray, BigQuantityArrayByteLimit -> None];
				MatchQ[check, bigQA]
			),
			True,
			Variables :> {bigQA, obj, check}
		],

		Test["BigQuantityArrays work with rational numbers:",
			(
				bigQA=QuantityArray[Table[{301 / 8, 301 / 9, 301 / 10}, {1000}], {Minute, Meter Nano, AbsorbanceUnit Milli}];
				obj=Upload[<|Type -> Object[Example, Data], BigDataQuantityArray -> bigQA|>];
				check=Download[obj, BigDataQuantityArray, BigQuantityArrayByteLimit -> None];
				MatchQ[check, N[bigQA]]
			),
			True,
			Variables :> {bigQA, obj, check}

		],
		Example[{Additional, "BigData", "Uploading BigData fields work:"},
			(
				bigData=RandomReal[10000, {1000, 3}];
				obj=Upload[<|Type -> Object[Example, Data], BigData -> bigData|>];
				check=Download[obj, BigData];
				MatchQ[check, bigData]
			),
			True,
			Variables :> {bigData, obj, check}
		],

		Example[{Messages, "BigDataField", "Upload failures relatively gracefully when binary encoding fails:"},
			(
				bigQA=QuantityArray[RandomReal[10000, {1000, 3}], {Minute, Meter Nano, AbsorbanceUnit Milli}];
				Upload[<|Type -> Object[Example, Data], BigDataQuantityArray -> bigQA|>]
			),
			$Failed,
			Stubs :> {
				Constellation`Private`binaryWriteAllBlocks[_, _, _, _]:=$Failed
			},
			Messages :> {
				Upload::BigDataField,
				Upload::Error,
				Export::jsonstrictencoding
			},
			Variables :> {bigQA}
		],

		Test["BigQuantityArray as indexed multiple field:",
			With[
				{
					inDataOne = {1.0 * Gram/Mole, 2.0 * Gram/Mole, QuantityArray[RandomReal[100, {10, 2}], {Minute, ArbitraryUnit}]},
					inDataTwo = {3.0 * Gram/Mole, 4.0 * Gram/Mole, QuantityArray[RandomReal[100, {10, 2}], {Minute, ArbitraryUnit}]}
				},
				dataObj = Upload[<| Type -> Object[Data, MassSpectrometry], Replace[ReactionMonitoringMassChromatogram] -> {inDataOne, inDataTwo} |>];
				outData = Download[dataObj, ReactionMonitoringMassChromatogram];
				MatchQ[outData, {inDataOne, inDataTwo}]
			],
			True,
			Variables :> {dataObj, outData}
		],

		Test["BigQuantityArray as named multiple field:",
			With[
				{
					inDataOne = <|Number -> 1, Data -> QuantityArray[RandomReal[100, {10, 2}], {Minute, Meter Nano}]|>,
					inDataTwo = <|Number -> 2, Data -> QuantityArray[RandomReal[100, {10, 2}], {Minute, Meter Nano}]|>
				},
				dataObj = Upload[<| Type -> Object[Example, Data], Replace[NamedMultipleBigDataQuantityArray] -> {inDataOne, inDataTwo} |>];
				outData = Download[dataObj, NamedMultipleBigDataQuantityArray];
				MatchQ[outData, {inDataOne, inDataTwo}]
			],
			True,
			Variables :> {dataObj, outData}
		],

		Test["Handle quantities in Integer fields:",
			Module[
				{},
				obj=Upload@<|
					Type -> Object[Example, Data],
					IntegerQuantity -> Quantity[2, "Minutes"]
				|>;
				Download[obj, IntegerQuantity]
			],
			Quantity[120, "Seconds"],
			Variables :> {obj}
		],

		Test["Handle unicode characters in string fields:",
			With[{name="Unicode \[CapitalAHat]\[Micro]m"},
				Quiet[
					Upload[<|Type -> Object[Example, Data], Name -> name|>],
					{Upload::NonUniqueName}
				];
				Upload[<|Type -> Object[Example, Data], SingleRelation -> Link[Object[Example, Data, name], SingleRelationAmbiguous]|>]
			],
			ObjectReferenceP[Object[Example, Data]]
		],
		Test["BigQuantityArray field filled with EmeraldCloudFile:",
			Upload[<|
				Type -> Object[Example, Data],
				DeveloperObject -> True,
				BigDataQuantityArray -> Link[UploadCloudFile[FindFile["ExampleData/turtle.jpg"]]]
			|>],
			ObjectP[Object[Example, Data]]
		],

		Test["Regular multiple fields can be null:",
			Upload@<|
				Type -> Model[Sample, StockSolution, Standard],
				Replace[ReferenceChromatographs] -> Null,
				DeveloperObject -> True
			|>,
			ObjectP[Model[Sample]]
		],

		Test["Regular multiple fields can contain lists:",
			With[
				{chroma=Upload@<|Type -> Object[Data, AbsorbanceSpectroscopy], DeveloperObject -> True|>},
				Upload@<|
					Type -> Model[Sample, StockSolution, Standard],
					Replace[ReferenceChromatographs] -> {Link@chroma},
					DeveloperObject -> True
				|>
			],
			ObjectP[Model[Sample]]
		],

		Test["Regular multiple fields can contain lists including nulls (only null):",
			With[
				{},
				Upload@<|
					Type -> Model[Sample, StockSolution, Standard],
					Replace[ReferenceChromatographs] -> {Null},
					DeveloperObject -> True
				|>
			],
			ObjectP[Model[Sample]]
		],

		Test["Regular multiple fields can contain lists including nulls (replace):",
			With[
				{chroma=Upload@<|Type -> Object[Data, AbsorbanceSpectroscopy], DeveloperObject -> True|>},
				Upload@<|
					Type -> Model[Sample, StockSolution, Standard],
					Replace[ReferenceChromatographs] -> {Link@chroma, Null},
					DeveloperObject -> True
				|>
			],
			ObjectP[Model[Sample]]
		],

		Test["Regular multiple fields can contain lists including nulls (append):",
			With[
				{chroma=Upload@<|Type -> Object[Data, AbsorbanceSpectroscopy], DeveloperObject -> True|>},
				Upload@<|
					Type -> Model[Sample, StockSolution, Standard],
					Append[ReferenceChromatographs] -> {Link@chroma, Null},
					DeveloperObject -> True
				|>
			],
			ObjectP[Model[Sample]]
		],

		Test["Indexed multiple fields can be null:",
			Upload@<|Type -> Object[Example, Data], Replace[S3IndexedMultiple] -> Null|>,
			ObjectP[Object[Example, Data]]
		],

		Test["Indexed multiple fields can contain lists:",
			With[
				{pic=Constellation`Private`uploadCloudFile[FindFile["ExampleData/turtle.jpg"]]},
				Upload@<|
					Type -> Object[Example, Data],
					Replace[S3IndexedMultiple] -> {{"sample turtle", pic}, {"sample turtle (2)", pic}},
					DeveloperObject -> True
				|>
			],
			ObjectP[Object[Example, Data]]
		],

		Test["Named multiple fields can be null:",
			Upload@<|Type -> Object[Example, Data], Replace[S3NamedMultiple] -> Null|>,
			ObjectP[Object[Example, Data]]
		],

		Test["Named multiple fields can contain lists:",
			With[
				{pic=Constellation`Private`uploadCloudFile[FindFile["ExampleData/turtle.jpg"]]},
				Upload@<|
					Type -> Object[Example, Data],
					Replace[S3NamedMultiple] -> {
						<|Label -> "sample turtle", File -> pic|>,
						<|Label -> "sample turtle (2)", File -> pic|>
					},
					DeveloperObject -> True
				|>
			],
			ObjectP[Object[Example, Data]]
		],

		Test["Append to a multiple field that pointed at a single field should overwrite existing value:",
			Module[
				{resourceID, order},
				resourceID=CreateID[Object[Resource, Sample]];
				order=CreateID[Object[Transaction, Order]];
				Upload[{
					<|Object -> resourceID|>,
					<|Object -> order, Append[Resources] -> Link[resourceID, Order]|>,
					<|Object -> order, Append[Resources] -> Link[resourceID, Order]|>
				}];
				{
					Download[resourceID, Order],
					Download[order, Resources]
				}
			],
			{
				ObjectP[Object[Transaction, Order]],
				{ObjectP[Object[Resource, Sample]]}
			}
		],

		Test["Combined upload call properly creates two-way links:",
			Module[
				{v1, v2, p1, p2},
				{v1, v2}=Upload@{
					<|Type -> Model[Container, Vessel]|>,
					<|Type -> Model[Container, Vessel]|>
				};
				{p1, p2}=Upload@{
					<|Type -> Object[Product]|>,
					<|Type -> Object[Product]|>
				};
				Upload[{
					<|
						Object -> v1,
						Replace[ProductsContained] -> {
							Link[p1, DefaultContainerModel],
							Link[p2, DefaultContainerModel]
						}
					|>,
					<|
						Object -> v2,
						Replace[ProductsContained] -> {
							Link[p1, DefaultContainerModel],
							Link[p2, DefaultContainerModel]
						}
					|>
				}];
				{
					Download[{v1, v2}, {Object, ProductsContained[Object]}],
					Download[{p1, p2}, {Object, DefaultContainerModel[Object]}]
				}
			],
			{
				{{ObjectP[Model[Container, Vessel]], {}}, {ObjectP[Model[Container, Vessel]], {ObjectP[Object[Product]], ObjectP[Object[Product]]}}},
				{{ObjectP[Object[Product]], ObjectP[Model[Container, Vessel]]}, {ObjectP[Object[Product]], ObjectP[Model[Container, Vessel]]}}
			}
		],

		Test["Single replace upload call creates proper links:",
			Module[
				{notebook, id},
				notebook=CreateID[Object[LaboratoryNotebook]];
				Upload[{<|Object -> notebook|>}];
				Block[
					{$Notebook=notebook},
					id=CreateID[Object[Method, Gradient]];
					Upload[{
						Association[
							Type -> Object[Protocol, HPLC],
							Object -> CreateID[Object[Protocol, HPLC]],
							Replace[Gradients] -> {Link[id]}],
						Association[Object -> id]}];
				];
				MatchQ[id[Notebook], LinkP[notebook]]
			],
			True
		],

		Test["Automatically add bookmark when a Protocol or Transaction is uploaded:",
			Module[
				{notebook},
				notebook=CreateID[Object[LaboratoryNotebook]];
				Upload[{<|Object -> notebook|>}];
				Block[
					{$Notebook=notebook},
					Upload[{
						<| Type -> Object[Protocol, HPLC]|>,
						<| Type -> Object[Transaction, Order]|>,
						<| Type -> Object[Sample]|>
					}];
				];
				Search[Object[Favorite, Bookmark], Notebook == notebook]],
			If[enableAutomaticBookmarks,
				{
					ObjectP[Object[Favorite, Bookmark]],
					ObjectP[Object[Favorite, Bookmark]]
				},
				{}
			]
		],
		Test["Download waits for read replication time to complete before beginning:",
			(
				Constellation`Private`readReplicationTotalSleptTime = 0 Second;
				Upload[<|Type->Object[User]|>];
				(* There's a race condition where sometimes no wait is required if the upload is slow, so we're going to make sure we get some wait *)
				Constellation`Private`readReplicationWaitTime = 1 Second;
				Constellation`Private`readReplicationCompleteDate = Now + 1 Second;
				Download[$PersonID, CakePreference];
				Constellation`Private`readReplicationTotalSleptTime > 0 Second
			),
			True
		],
		Test["Search waits for read replication time to complete before beginning:",
			(
				Constellation`Private`readReplicationTotalSleptTime = 0 Second;
				Upload[<|Type->Object[User]|>];
				(* There's a race condition where sometimes no wait is required if the upload is slow, so we're going to make sure we get some wait *)
				Constellation`Private`readReplicationWaitTime = 1 Second;
				Constellation`Private`readReplicationCompleteDate = Now + 1 Second;
				Search[Object[User, Emerald, Developer], MaxResults->1];
				Constellation`Private`readReplicationTotalSleptTime > 0 Second
			),
			True
		],
		Test["Download does not wait if no upload executed:",
			(
				WaitUntilUploadReplicationComplete[];
				Constellation`Private`readReplicationTotalSleptTime = 0 Second;
				Download[$PersonID, CakePreference];
				Constellation`Private`readReplicationTotalSleptTime == 0 Second
			),
			True
		],
		Test["Search does not wait if no upload executed:",
			(
				WaitUntilUploadReplicationComplete[];
				Constellation`Private`readReplicationTotalSleptTime = 0 Second;
				Search[Object[User, Emerald, Developer], MaxResults->1];
				Constellation`Private`readReplicationTotalSleptTime == 0 Second
			),
			True
		],
		Test["Read replication waiting works even with a time change:",
			(
				(* Simluate a situation where day light savings occurs between the upload and the search, ensuring you don't wait an hour *)
				Constellation`Private`readReplicationTotalSleptTime = 0 Second;
				Upload[<|Type->Object[User]|>];
				Constellation`Private`readReplicationCompleteDate = Now + 1 Hour;
				Search[Object[User, Emerald, Developer], MaxResults->1];
				Constellation`Private`readReplicationTotalSleptTime == Constellation`Private`readReplicationWaitTime
			),
			True
		],
		Test["If $DeveloperUpload is set to True, then automatically set DeveloperObject -> True for all new packets with or without the Object key set:",
			uploadedObjects = Upload[{
				<|
					Type -> Object[User],
					FirstName -> "John",
					LastName -> "Doe"
				|>,
				<|
					Object -> CreateID[Object[User]],
					Type -> Object[User],
					FirstName -> "Jane",
					LastName -> "Doe"
				|>
			}];
			Download[uploadedObjects, DeveloperObject],
			{True, True},
			Variables :> {uploadedObjects},
			Stubs :> {$DeveloperUpload = True}
		],
		Test["If $DeveloperUpload is set to True, but DeveloperObject is set already set in the uploading packets, do not change the value, with or without the Object key set:",
			uploadedObjects = Upload[{
				<|
					Type -> Object[User],
					DeveloperObject -> False,
					FirstName -> "John",
					LastName -> "Doe"
				|>,
				<|
					Object -> CreateID[Object[User]],
					Type -> Object[User],
					DeveloperObject -> Null,
					FirstName -> "Jane",
					LastName -> "Doe"
				|>
			}];
			Download[uploadedObjects, DeveloperObject],
			{False, Null},
			Variables :> {uploadedObjects},
			Stubs :> {$DeveloperUpload = True}
		],
		Test["If $DeveloperUpload is set to True, but we are updating an object that already exists, do not set it to DeveloperObject -> True:",
			With[{
				object=Upload[
					<|
						(* making a ProcedureEvent here because if we somehow mess up and it is floating around in the lab with DeveloperObject -> False, no one will care *)
						Type -> Object[Program, ProcedureEvent],
						Name -> "Test ProcedureEvent "<>CreateUUID[],
						DeveloperObject -> False
					|>
				]},
				Upload[{
					<|Object -> object, Iteration -> 1|>,
					<|Object -> object, TotalIterations -> 3|>
				}];
				Download[object, DeveloperObject]
			],
			False,
			Stubs :> {$DeveloperUpload = True}
		],
		Test["If $DeveloperUpload is set to True, and we have multiple packets updating the same object and DeveloperObject is only set for one of them, don't update DeveloperObject for any of that ID (though do so for the others):",
			Module[{newObjects, allObjs},
				newObjects=Upload[{
					<|
						(* making a ProcedureEvent here because if we somehow mess up and it is floating around in the lab with DeveloperObject -> False, no one will care *)
						Type -> Object[Program, ProcedureEvent],
						Name -> "Test ProcedureEvent for Upload tests 1" <> CreateUUID[],
						DeveloperObject -> Null
					|>,
					<|
						(* making a ProcedureEvent here because if we somehow mess up and it is floating around in the lab with DeveloperObject -> False, no one will care *)
						Type -> Object[Program, ProcedureEvent],
						Name -> "Test ProcedureEvent for Upload tests 2" <> CreateUUID[],
						DeveloperObject -> Null
					|>
				}];
				allObjs = Upload[{
					(* explicitly specified, this one should become False *)
					<|
						Object -> newObjects[[1]],
						Iteration -> 2,
						DeveloperObject -> False
					|>,
					(* not explicitly specified, this one should not change (i.e., stay Null) because it's not a new object *)
					<|
						Object -> newObjects[[2]],
						Iteration -> 2
					|>,
					(* not explicitly specified and a newly created object with ID, should be True*)
					<|
						Object -> CreateID[Object[Program, ProcedureEvent]],
						Iteration -> 2
					|>,
					(* not explicitly stated and without Object specified, should be True *)
					<|
						Type -> Object[Program, ProcedureEvent],
						Iteration -> 2
					|>,
					(* not explicitly stated, but was explicitly stated in the previous packet at the beginning; should stay what it was (False) from above *)
					<|
						Object -> newObjects[[1]],
						TotalIterations -> 3
					|>
				}];
				Download[allObjs, DeveloperObject]
			],
			{False, Null, True, True, False},
			Stubs :> {$DeveloperUpload = True}
		]
	}

]; (* end of DefineTests[Upload] *)

setupExampleNotebook[]:=With[
	{object=Object[LaboratoryNotebook, "Test Notebook"]},
	If[!DatabaseMemberQ[object],
		Upload[<|Type -> Object[LaboratoryNotebook], Name -> "Test Notebook"|>]
	]
];

setupNotebookNamed123[]:=With[
	{object=Object[LaboratoryNotebook, "123"]},
	If[!DatabaseMemberQ[object],
		Upload[<|Type -> Object[LaboratoryNotebook], Name -> "123"|>],
		object
	]
];

setupNotebookNamed1[]:=With[
	{object=Object[LaboratoryNotebook, "1"]},
	If[!DatabaseMemberQ[object],
		Upload[<|Type -> Object[LaboratoryNotebook], Name -> "1"|>]
	]
];

setupNotebookNamed2[]:=With[
	{object=Object[LaboratoryNotebook, "2"]},
	If[!DatabaseMemberQ[object],
		Upload[<|Type -> Object[LaboratoryNotebook], Name -> "2"|>]
	]
];

DefineTests[RollbackTransaction,
	{
		Example[{Basic, "Rollback a transaction:"},
			Module[{linkedObject, object, transaction},
				linkedObject=Upload[<|Type -> Object[Example, Data]|>];
				object=Upload[<|
					Type -> Object[Example, Data],
					Replace[NamedMultiple] -> {
						<|
							UnitColumn -> 11 Nanometer,
							SingleLink -> Link[linkedObject, NamedSingle, MultipleLink]
						|>}
				|>];
				transaction=BeginUploadTransaction[];
				Upload[<|
					Object -> object,
					Replace[NamedMultiple] -> Null
				|>];
				EndUploadTransaction[];
				RollbackTransaction[transaction];
				Download[object, NamedMultiple]
			],
			{<|UnitColumn -> Quantity[11.`, "Nanometers"], SingleLink -> LinkP[Object[Example, Data]]|>}
		],
		Example[{Basic, "Rollback a parent transaction, which will also rollback all of its children transactions:"},
			Module[{obj, parentTransaction},
				obj=Upload[<|Type -> Object[Example, Data], Number -> 0|>];
				parentTransaction=BeginUploadTransaction[];
				Upload[<|Object -> obj, Number -> 5|>];
				BeginUploadTransaction[];
				Upload[<|Object -> obj, Number -> 10|>];
				EndUploadTransaction[];
				EndUploadTransaction[];
				RollbackTransaction[parentTransaction];
				Download[obj, Number]
			],
			0.
		],
		Example[{Messages, "Error", "Attempting to roll back a transaction whose field has been modified since the transaction ended will fail:"},
			Module[{obj, transaction},
				obj=Upload[<|Type -> Object[Example, Data]|>];
				transaction=BeginUploadTransaction[];
				Upload[<|Object -> obj, Number -> 5|>];
				EndUploadTransaction[];
				Upload[<|Object -> obj, Number -> 10|>];
				RollbackTransaction[transaction]
			],
			$Failed,
			Messages :> {Message[RollbackTransaction::Error]}
		],
		Example[{Messages, "TransactionAlreadyExists", "Attempting to create a new transaction that already exists will fail:"},
			Module[{transaction1, transaction2},
				transaction1=BeginUploadTransaction[];
				transaction2=BeginUploadTransaction[transaction1];
				EndUploadTransaction[transaction1];
			],
			Null,
			Messages :> {Message[RollbackTransaction::TransactionAlreadyExists]}
		],
		Example[{Additional, "Force", "Forcefully rollback a transaction even if the field value associated with the transaction does not contain the latest value:"},
			Module[{obj, transaction},
				obj=Upload[<|Type -> Object[Example, Data], Number -> 0|>];
				transaction=BeginUploadTransaction[];
				Upload[<|Object -> obj, Number -> 5|>];
				EndUploadTransaction[];
				Upload[<|Object -> obj, Number -> 10|>];
				RollbackTransaction[transaction, Force -> True];
				Download[obj, Number]
			],
			0.
		]
	},
	SymbolSetUp :> {
		$CurrentUploadTransactions={};
	},
	SymbolTearDown :> {
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
		Unset[$CreatedObjects];
		$CurrentUploadTransactions={};
	}
];


(* ::Subsubsection:: *)
(*SuperUpload*)

DefineTests[
	SuperUpload,

	(* Basic Tests *)
	(* Following the example of SuperSyncType tests, just stub the ConstellationRequest and only check that these are parsed correctly by SuperUpload. *)
	(* For a passing request, we only need a Status Code in the response. *)
	(* Stub Login to avoid database hopping during nightly testing. *)
	{
		Example[{Basic, "Upload a new object, and return new object on each database as formatted table:"},
			SuperUpload[
				<|
					Type -> Object[Container],
					Name -> "New Test Object 1 for SuperUpload Unit Testing " <> $SessionUUID,
					DeveloperObject -> True
				|>
			],
			_Pane,
			Stubs :> {
				Login[___] := Nothing,
				ConstellationRequest[___] := <|
					"responses" -> {
						<|
							"object" -> <|
								"type" -> "Object.Container"
							|>,
							"resolved_object" -> <|
								"id" -> "id:XnlV5jljzPNo",
								"type" -> "Object.Container"
							|>,
							"id" -> "id:XnlV5jljzPNo",
							"new_object" -> True
						|>
					},
					"modified_references" -> {
						<|
							"id" -> "id:XnlV5jljzPNo",
							"type" -> "Object.Container"
						|>
					},
					"client_id_objects" -> {
						<|
							"client_id" -> "clientId:SERVER_1",
							"id" -> "id:XnlV5jljzPNo",
							"type" -> "Object.Container"
						|>
					},
					"new_objects" -> {
						<|
							"id" -> "id:XnlV5jljzPNo",
							"type" -> "Object.Container"
						|>
					}
				|>
			}
		],

		Example[{Basic, "Upload new objects, and return new objects on each database as formatted table:"},
			SuperUpload[
				{
					<|
						Type -> Object[Container],
						Name -> "New Test Object 2 for SuperUpload Unit Testing " <> $SessionUUID,
						DeveloperObject -> True
					|>,
					<|
						Type -> Object[Container],
						Name -> "New Test Object 3 for SuperUpload Unit Testing " <> $SessionUUID,
						DeveloperObject -> True
					|>
				}
			],
			_Pane,
			Stubs :> {
				Login[___] := Nothing,
				ConstellationRequest[___] := <|
					"responses" -> {
						<|
							"object" -> <|
								"type" -> "Object.Container"
							|>,
							"resolved_object" -> <|
								"id" -> "id:XnlV5jljzPNo",
								"type" -> "Object.Container"
							|>,
							"id" -> "id:XnlV5jljzPNo",
							"new_object" -> True
						|>,
						<|
							"object" -> <|
								"type" -> "Object.Container"
							|>,
							"resolved_object" -> <|
								"id" -> "id:mnk9jOkOxLWZ",
								"type" -> "Object.Container"
							|>,
							"id" -> "id:mnk9jOkOxLWZ",
							"new_object" -> True
						|>
					},
					"modified_references" -> {
						<|
							"id" -> "id:XnlV5jljzPNo",
							"type" -> "Object.Container"
						|>,
						<|
							"id" -> "id:mnk9jOkOxLWZ",
							"type" -> "Object.Container"
						|>
					},
					"client_id_objects" -> {
						<|
							"client_id" -> "clientId:SERVER_1",
							"id" -> "id:XnlV5jljzPNo",
							"type" -> "Object.Container"
						|>,
						<|
							"client_id" -> "clientId:SERVER_2",
							"id" -> "id:mnk9jOkOxLWZ",
							"type" -> "Object.Container"
						|>
					},
					"new_objects" -> {
						<|
							"id" -> "id:XnlV5jljzPNo",
							"type" -> "Object.Container"
						|>,
						<|
							"id" -> "id:mnk9jOkOxLWZ",
							"type" -> "Object.Container"
						|>
					}
				|>
			}
		],

		Example[{Basic, "Upload modifications to an existing object, and return the modified object on each database as formatted table:"},
			SuperUpload[
				<|
					Object -> Object[Container, "Old Test Object 1 for SuperUpload Unit Testing " <> $SessionUUID],
					Restricted -> True,
					DeveloperObject -> True
				|>
			],
			_Pane,
			Stubs :> {
				Login[___] := Nothing,
				ConstellationRequest[___] := <|
					"status_code" -> 1,
					"responses" -> {
						<|
							"object" -> <|
								"type" -> "Object.Container",
								"name" -> "Old Test Object 1 for SuperUpload Unit Testing " <> $SessionUUID
							|>,
							"resolved_object" -> <|
								"id" -> "id:XnlV5jljzPNo",
								"type" -> "Object.Container"
							|>,
							"id" -> "id:XnlV5jljzPNo",
							"new_object" -> False
						|>
					},
					"modified_references" -> {
						<|
							"id" -> "id:XnlV5jljzPNo",
							"type" -> "Object.Container"
						|>
					}
				|>
			}
		],

		Example[{Basic, "Upload modifications to existing objects, and return modified objects on each database as formatted table:"},
			SuperUpload[
				{
					<|
						Object -> Object[Container, "Old Test Object 2 for SuperUpload Unit Testing " <> $SessionUUID],
						Restricted -> True,
						DeveloperObject -> True
					|>,
					<|
						Object -> Object[Container, "Old Test Object 3 for SuperUpload Unit Testing " <> $SessionUUID],
						Restricted -> True,
						DeveloperObject -> True
					|>
				}
			],
			_Pane,
			Stubs :> {
				Login[___] := Nothing,
				ConstellationRequest[___] := <|
					"responses" -> {
						<|
							"object" -> <|
								"type" -> "Object.Container",
								"name" -> "Old Test Object 2 for SuperUpload Unit Testing " <> $SessionUUID
							|>,
							"resolved_object" -> <|
								"id" -> "id:XnlV5jljzPNo",
								"type" -> "Object.Container"
							|>,
							"id" -> "id:XnlV5jljzPNo",
							"new_object" -> False
						|>,
						<|
							"object" -> <|
								"type" -> "Object.Container",
								"name" -> "Old Test Object 3 for SuperUpload Unit Testing " <> $SessionUUID
							|>,
							"resolved_object" -> <|
								"id" -> "id:mnk9jOkOxLWZ",
								"type" -> "Object.Container"
							|>,
							"id" -> "id:mnk9jOkOxLWZ",
							"new_object" -> False
						|>
					},
					"modified_references" -> {
						<|
							"id" -> "id:XnlV5jljzPNo",
							"type" -> "Object.Container"
						|>,
						<|
							"id" -> "id:mnk9jOkOxLWZ",
							"type" -> "Object.Container"
						|>
					}
				|>
			}
		],

		Example[{Options, OutputAsTable, "Upload a new object, and return responses as list of Rules:"},
			SuperUpload[
				<|
					Type -> Object[Container],
					Name -> "New Test Object 4 for SuperUpload Unit Testing " <> $SessionUUID,
					DeveloperObject -> True
				|>,
				OutputAsTable -> False
			],
			{Rule[(_String | _Symbol), ObjectP[]] ..},
			Stubs :> {
				Login[___] := Nothing,
				ConstellationRequest[___] := <|
					"responses" -> {
						<|
							"object" -> <|
								"type" -> "Object.Container"
							|>,
							"resolved_object" -> <|
								"id" -> "id:XnlV5jljzPNo",
								"type" -> "Object.Container"
							|>,
							"id" -> "id:XnlV5jljzPNo",
							"new_object" -> True
						|>
					},
					"modified_references" -> {
						<|
							"id" -> "id:XnlV5jljzPNo",
							"type" -> "Object.Container"
						|>
					},
					"client_id_objects" -> {
						<|
							"client_id" -> "clientId:SERVER_1",
							"id" -> "id:XnlV5jljzPNo",
							"type" -> "Object.Container"
						|>
					},
					"new_objects" -> {
						<|
							"id" -> "id:XnlV5jljzPNo",
							"type" -> "Object.Container"
						|>
					}
				|>
			}
		],

		Example[{Options, OutputAsTable, "Upload new objects, and return responses as list of Rules:"},
			SuperUpload[
				{
					<|
						Type -> Object[Container],
						Name -> "New Test Object 5 for SuperUpload Unit Testing " <> $SessionUUID,
						DeveloperObject -> True
					|>,
					<|
						Type -> Object[Container],
						Name -> "New Test Object 6 for SuperUpload Unit Testing " <> $SessionUUID,
						DeveloperObject -> True
					|>
				},
				OutputAsTable -> False
			],
			{Rule[(_String | _Symbol), {ObjectP[]..}] ..},
			Stubs :> {
				Login[___] := Nothing,
				ConstellationRequest[___] := <|
					"responses" -> {
						<|
							"object" -> <|
								"type" -> "Object.Container"
							|>,
							"resolved_object" -> <|
								"id" -> "id:XnlV5jljzPNo",
								"type" -> "Object.Container"
							|>,
							"id" -> "id:XnlV5jljzPNo",
							"new_object" -> True
						|>,
						<|
							"object" -> <|
								"type" -> "Object.Container"
							|>,
							"resolved_object" -> <|
								"id" -> "id:mnk9jOkOxLWZ",
								"type" -> "Object.Container"
							|>,
							"id" -> "id:mnk9jOkOxLWZ",
							"new_object" -> True
						|>
					},
					"modified_references" -> {
						<|
							"id" -> "id:XnlV5jljzPNo",
							"type" -> "Object.Container"
						|>,
						<|
							"id" -> "id:mnk9jOkOxLWZ",
							"type" -> "Object.Container"
						|>
					},
					"client_id_objects" -> {
						<|
							"client_id" -> "clientId:SERVER_1",
							"id" -> "id:XnlV5jljzPNo",
							"type" -> "Object.Container"
						|>,
						<|
							"client_id" -> "clientId:SERVER_2",
							"id" -> "id:mnk9jOkOxLWZ",
							"type" -> "Object.Container"
						|>
					},
					"new_objects" -> {
						<|
							"id" -> "id:XnlV5jljzPNo",
							"type" -> "Object.Container"
						|>,
						<|
							"id" -> "id:mnk9jOkOxLWZ",
							"type" -> "Object.Container"
						|>
					}
				|>
			}
		],

		Example[{Options, OutputAsTable, "Upload modifications to an existing object, and return responses as list of Rules:"},
			SuperUpload[
				<|
					Object -> Object[Container, "Old Test Object 4 for SuperUpload Unit Testing " <> $SessionUUID],
					Restricted -> True,
					DeveloperObject -> True
				|>,
				OutputAsTable -> False
			],
			{Rule[(_String | _Symbol), ObjectP[]] ..},
			Stubs :> {
				Login[___] := Nothing,
				ConstellationRequest[___] := <|
					"status_code" -> 1,
					"responses" -> {
						<|
							"object" -> <|
								"type" -> "Object.Container",
								"name" -> "Old Test Object 4 for SuperUpload Unit Testing " <> $SessionUUID
							|>,
							"resolved_object" -> <|
								"id" -> "id:XnlV5jljzPNo",
								"type" -> "Object.Container"
							|>,
							"id" -> "id:XnlV5jljzPNo",
							"new_object" -> False
						|>
					},
					"modified_references" -> {
						<|
							"id" -> "id:XnlV5jljzPNo",
							"type" -> "Object.Container"
						|>
					}
				|>
			}
		],

		Example[{Options, OutputAsTable, "Upload modifications to existing objects, and return responses as list of Rules:"},
			SuperUpload[{
				<|
					Object -> Object[Container, "Old Test Object 5 for SuperUpload Unit Testing " <> $SessionUUID],
					Restricted -> True,
					DeveloperObject -> True
				|>,
				<|
					Object -> Object[Container, "Old Test Object 6 for SuperUpload Unit Testing " <> $SessionUUID],
					Restricted -> True,
					DeveloperObject -> True
				|>
			},
				OutputAsTable -> False
			],
			{Rule[(_String | _Symbol), {ObjectP[]..}] ..},
			Stubs :> {
				Login[___] := Nothing,
				ConstellationRequest[___] := <|
					"responses" -> {
						<|
							"object" -> <|
								"type" -> "Object.Container",
								"name" -> "Old Test Object 5 for SuperUpload Unit Testing " <> $SessionUUID
							|>,
							"resolved_object" -> <|
								"id" -> "id:XnlV5jljzPNo",
								"type" -> "Object.Container"
							|>,
							"id" -> "id:XnlV5jljzPNo",
							"new_object" -> False
						|>,
						<|
							"object" -> <|
								"type" -> "Object.Container",
								"name" -> "Old Test Object 6 for SuperUpload Unit Testing " <> $SessionUUID
							|>,
							"resolved_object" -> <|
								"id" -> "id:mnk9jOkOxLWZ",
								"type" -> "Object.Container"
							|>,
							"id" -> "id:mnk9jOkOxLWZ",
							"new_object" -> False
						|>
					},
					"modified_references" -> {
						<|
							"id" -> "id:XnlV5jljzPNo",
							"type" -> "Object.Container"
						|>,
						<|
							"id" -> "id:mnk9jOkOxLWZ",
							"type" -> "Object.Container"
						|>
					}
				|>
			}
		],

		Example[{Options, {Username, Password, IncludeProduction}, "Upload new objects or modify old objects on all databases including production if IncludeProduction is True and a valid login Username and Password are provided, and return new objects or modified old objects on each database as formatted table:"},
			SuperUpload[
				<|
					Type -> Object[Container],
					Name -> "New Test Object 1 for SuperUpload Unit Testing " <> $SessionUUID,
					DeveloperObject -> True
				|>,
				Username -> "valid.username@email.com",
				Password -> "ValidPassword",
				IncludeProduction -> True
			],
			_Pane,
			Stubs :> {
				Login[___] := Nothing,
				ConstellationRequest[___] := <|
					"responses" -> {
						<|
							"object" -> <|
								"type" -> "Object.Container"
							|>,
							"resolved_object" -> <|
								"id" -> "id:XnlV5jljzPNo",
								"type" -> "Object.Container"
							|>,
							"id" -> "id:XnlV5jljzPNo",
							"new_object" -> True
						|>
					},
					"modified_references" -> {
						<|
							"id" -> "id:XnlV5jljzPNo",
							"type" -> "Object.Container"
						|>
					},
					"client_id_objects" -> {
						<|
							"client_id" -> "clientId:SERVER_1",
							"id" -> "id:XnlV5jljzPNo",
							"type" -> "Object.Container"
						|>
					},
					"new_objects" -> {
						<|
							"id" -> "id:XnlV5jljzPNo",
							"type" -> "Object.Container"
						|>
					}
				|>
			}
		],

		(* Message Tests *)
		Example[{Messages, "Return $Failed for invalid Login credentials:"},
			SuperUpload[
				<|
					Type -> Object[Container],
					Name -> "New Test Object 7 for SuperUpload Unit Testing " <> $SessionUUID,
					DeveloperObject -> True
				|>,
				Username -> "bad@email.com",
				Password -> "invalidPassword"
			],
			$Failed,
			Messages :> {Login::Server}
		],

		Example[{Messages, "Require Username and Password if syncing against Production database:"},
			SuperUpload[
				<|
					Type -> Object[Container],
					Name -> "New Test Object 8 for SuperUpload Unit Testing " <> $SessionUUID,
					DeveloperObject -> True
				|>,
				IncludeProduction -> True
			],
			$Failed,
			Messages :> {SuperUpload::UsernameAndPasswordRequired}
		],

		Example[{Messages, "Packets need to be valid to be uploaded to each database:"},
			SuperUpload[
				<|
					Type -> Object[Container],
					Name -> "New Test Object 9 for SuperUpload Unit Testing " <> $SessionUUID,
					Model -> "Invalid",
					DeveloperObject -> True
				|>
			],
			$Failed,
			Messages :> {SuperUpload::PacketNotValid}
		]

	},
	Stubs :> {$DeveloperUpload = True},
	SymbolSetUp :> Module[
		{existsFilter, oldObject1, oldObject2, oldObject3, oldObject4, oldObject5, oldObject6},

		(* Keep a list of created objects to delete after the test is run. *)
		$CreatedObjects = {};

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		existsFilter = DatabaseMemberQ[{
			Object[Container, "New Test Object 1 for SuperUpload Unit Testing " <> $SessionUUID],
			Object[Container, "New Test Object 2 for SuperUpload Unit Testing " <> $SessionUUID],
			Object[Container, "New Test Object 3 for SuperUpload Unit Testing " <> $SessionUUID],
			Object[Container, "New Test Object 4 for SuperUpload Unit Testing " <> $SessionUUID],
			Object[Container, "New Test Object 5 for SuperUpload Unit Testing " <> $SessionUUID],
			Object[Container, "New Test Object 6 for SuperUpload Unit Testing " <> $SessionUUID],
			Object[Container, "New Test Object 7 for SuperUpload Unit Testing " <> $SessionUUID],
			Object[Container, "New Test Object 8 for SuperUpload Unit Testing " <> $SessionUUID],
			Object[Container, "New Test Object 9 for SuperUpload Unit Testing " <> $SessionUUID],
			Object[Container, "Old Test Object 1 for SuperUpload Unit Testing " <> $SessionUUID],
			Object[Container, "Old Test Object 2 for SuperUpload Unit Testing " <> $SessionUUID],
			Object[Container, "Old Test Object 3 for SuperUpload Unit Testing " <> $SessionUUID],
			Object[Container, "Old Test Object 4 for SuperUpload Unit Testing " <> $SessionUUID],
			Object[Container, "Old Test Object 5 for SuperUpload Unit Testing " <> $SessionUUID],
			Object[Container, "Old Test Object 6 for SuperUpload Unit Testing " <> $SessionUUID]
		}];

		EraseObject[
			PickList[
				{
					Object[Container, "New Test Object 1 for SuperUpload Unit Testing " <> $SessionUUID],
					Object[Container, "New Test Object 2 for SuperUpload Unit Testing " <> $SessionUUID],
					Object[Container, "New Test Object 3 for SuperUpload Unit Testing " <> $SessionUUID],
					Object[Container, "New Test Object 4 for SuperUpload Unit Testing " <> $SessionUUID],
					Object[Container, "New Test Object 5 for SuperUpload Unit Testing " <> $SessionUUID],
					Object[Container, "New Test Object 6 for SuperUpload Unit Testing " <> $SessionUUID],
					Object[Container, "New Test Object 7 for SuperUpload Unit Testing " <> $SessionUUID],
					Object[Container, "New Test Object 8 for SuperUpload Unit Testing " <> $SessionUUID],
					Object[Container, "New Test Object 9 for SuperUpload Unit Testing " <> $SessionUUID],
					Object[Container, "Old Test Object 1 for SuperUpload Unit Testing " <> $SessionUUID],
					Object[Container, "Old Test Object 2 for SuperUpload Unit Testing " <> $SessionUUID],
					Object[Container, "Old Test Object 3 for SuperUpload Unit Testing " <> $SessionUUID],
					Object[Container, "Old Test Object 4 for SuperUpload Unit Testing " <> $SessionUUID],
					Object[Container, "Old Test Object 5 for SuperUpload Unit Testing " <> $SessionUUID],
					Object[Container, "Old Test Object 6 for SuperUpload Unit Testing " <> $SessionUUID]
				},
				existsFilter
			],
			Force -> True,
			Verbose -> False
		];

		{oldObject1, oldObject2, oldObject3, oldObject4, oldObject5, oldObject6} = Upload[
			{
				<|
					Type -> Object[Container],
					Name -> "Old Test Object 1 for SuperUpload Unit Testing " <> $SessionUUID,
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container],
					Name -> "Old Test Object 2 for SuperUpload Unit Testing " <> $SessionUUID,
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container],
					Name -> "Old Test Object 3 for SuperUpload Unit Testing " <> $SessionUUID,
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container],
					Name -> "Old Test Object 4 for SuperUpload Unit Testing " <> $SessionUUID,
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container],
					Name -> "Old Test Object 5 for SuperUpload Unit Testing " <> $SessionUUID,
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container],
					Name -> "Old Test Object 6 for SuperUpload Unit Testing " <> $SessionUUID,
					DeveloperObject -> True
				|>
			}
		]

	],
	SymbolTearDown :> (
		Module[{allObjects, existsFilter},

			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects = Join[
				Cases[
					Flatten[
						{
							Object[Container, "New Test Object 1 for SuperUpload Unit Testing " <> $SessionUUID],
							Object[Container, "New Test Object 2 for SuperUpload Unit Testing " <> $SessionUUID],
							Object[Container, "New Test Object 3 for SuperUpload Unit Testing " <> $SessionUUID],
							Object[Container, "New Test Object 4 for SuperUpload Unit Testing " <> $SessionUUID],
							Object[Container, "New Test Object 5 for SuperUpload Unit Testing " <> $SessionUUID],
							Object[Container, "New Test Object 6 for SuperUpload Unit Testing " <> $SessionUUID],
							Object[Container, "New Test Object 7 for SuperUpload Unit Testing " <> $SessionUUID],
							Object[Container, "New Test Object 8 for SuperUpload Unit Testing " <> $SessionUUID],
							Object[Container, "New Test Object 9 for SuperUpload Unit Testing " <> $SessionUUID],
							Object[Container, "Old Test Object 1 for SuperUpload Unit Testing " <> $SessionUUID],
							Object[Container, "Old Test Object 2 for SuperUpload Unit Testing " <> $SessionUUID],
							Object[Container, "Old Test Object 3 for SuperUpload Unit Testing " <> $SessionUUID],
							Object[Container, "Old Test Object 4 for SuperUpload Unit Testing " <> $SessionUUID],
							Object[Container, "Old Test Object 5 for SuperUpload Unit Testing " <> $SessionUUID],
							Object[Container, "Old Test Object 6 for SuperUpload Unit Testing " <> $SessionUUID]
						}
					],
					ObjectP[]
				],
				$CreatedObjects
			];

			(* Erase any objects that we failed to erase in the last unit test *)
			existsFilter = DatabaseMemberQ[allObjects];

			Quiet[EraseObject[
				PickList[
					allObjects,
					existsFilter
				],
				Force -> True,
				Verbose -> False
			]];

			Unset[$CreatedObjects]

		]
	)
];