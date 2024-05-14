(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineTests[
	ValidStorageConditionQ,
	{
		Example[{Basic, "Returns False if the safety information fields from the sample do not match those of the storage condition:"},
			ValidStorageConditionQ[myChemicalObject, myStorageCondition],
			False,
			SetUp :> {
				$CreatedObjects={};

				(* Upload a sample and a storage condition for testing. *)
				myChemicalModel=Upload[<|
					Type -> Model[Sample],
					Flammable -> Null,
					Acid -> True,
					Base -> Null,
					Pyrophoric -> True
				|>];

				myChemicalObject=Upload[<|
					Type -> Object[Sample],
					Model -> Link[myChemicalModel, Objects]
				|>];

				myStorageCondition=Upload[<|
					Type -> Model[StorageCondition],
					Flammable -> Null,
					Acid -> Null,
					Base -> Null,
					Pyrophoric -> True,
					DeveloperObject -> True
				|>];
			},
			TearDown :> {
				EraseObject[$CreatedObjects, Force -> True]
			},
			Messages :> {Error::InvalidStorageCondition}
		],
		Example[{Basic, "Returns True if the safety information fields from the sample match those of the storage condition:"},
			ValidStorageConditionQ[myChemicalObject, myStorageCondition],
			True,
			SetUp :> {
				$CreatedObjects={};

				(* Upload a sample and a storage condition for testing. *)
				myChemicalModel=Upload[<|
					Type -> Model[Sample],
					Flammable -> True,
					Acid -> Null,
					Base -> Null,
					Pyrophoric -> True
				|>];

				myChemicalObject=Upload[<|
					Type -> Object[Sample],
					Model -> Link[myChemicalModel, Objects],
					Flammable -> True,
					Acid -> Null,
					Base -> Null,
					Pyrophoric -> True
				|>];

				myStorageCondition=Upload[<|
					Type -> Model[StorageCondition],
					Flammable -> True,
					Acid -> Null,
					Base -> Null,
					Pyrophoric -> True,
					DeveloperObject -> True
				|>];
			},
			TearDown :> {
				EraseObject[$CreatedObjects, Force -> True]
			}
		],
		Example[{Basic, "Returns True if given SampleStorageTypeP|Disposal as the Storage Condition. This is because the symbol will automatically resolve to a valid storage condition in UploadStorageCondition[...]:"},
			ValidStorageConditionQ[myChemicalObject, Disposal],
			True,
			SetUp :> {
				$CreatedObjects={};

				(* Upload a sample and a storage condition for testing. *)
				myChemicalModel=Upload[<|
					Type -> Model[Sample],
					Flammable -> True,
					Acid -> Null,
					Base -> Null,
					Pyrophoric -> True
				|>];

				myChemicalObject=Upload[<|
					Type -> Object[Sample],
					Model -> Link[myChemicalModel, Objects]
				|>];
			},
			TearDown :> {
				EraseObject[$CreatedObjects, Force -> True]
			}
		],
		Example[{Additional, "When given multiple samples, makes sure that the storage condition can accomodate all of the safety information from the samples. Returns False because the Storage Condition cannot handle Acids:"},
			ValidStorageConditionQ[{myChemicalObject, myChemicalObject2}, myStorageCondition],
			False,
			SetUp :> {
				$CreatedObjects={};

				(* Upload a sample and a storage condition for testing. *)
				myChemicalModel=Upload[<|
					Type -> Model[Sample],
					Flammable -> True,
					Acid -> Null,
					Base -> Null,
					Pyrophoric -> True
				|>];

				myChemicalObject=Upload[<|
					Type -> Object[Sample],
					Model -> Link[myChemicalModel, Objects],
					Flammable -> True,
					Acid -> Null,
					Base -> Null,
					Pyrophoric -> True
				|>];

				myChemicalModel2=Upload[<|
					Type -> Model[Sample],
					Flammable -> Null,
					Acid -> True,
					Base -> Null,
					Pyrophoric -> Null
				|>];

				myChemicalObject2=Upload[<|
					Type -> Object[Sample],
					Model -> Link[myChemicalModel2, Objects],
					Flammable -> Null,
					Acid -> True,
					Base -> Null,
					Pyrophoric -> Null
				|>];

				myStorageCondition=Upload[<|
					Type -> Model[StorageCondition],
					Flammable -> True,
					Acid -> Null,
					Base -> Null,
					Pyrophoric -> True,
					DeveloperObject -> True
				|>];
			},
			TearDown :> {
				EraseObject[$CreatedObjects, Force -> True]
			},
			Messages :> {
				Error::InvalidStorageCondition
			}
		],
		Example[{Additional, "When given multiple samples, makes sure that the storage condition can accomodate all of the safety information from the samples. Returns True because the storage condition handles Flammable, Pyrophoric, and Acid:"},
			ValidStorageConditionQ[{myChemicalObject, myChemicalObject2}, myStorageCondition],
			True,
			SetUp :> {
				$CreatedObjects={};

				(* Upload a sample and a storage condition for testing. *)
				myChemicalModel=Upload[<|
					Type -> Model[Sample],
					Flammable -> True,
					Acid -> Null,
					Base -> Null,
					Pyrophoric -> True
				|>];

				myChemicalObject=Upload[<|
					Type -> Object[Sample],
					Model -> Link[myChemicalModel, Objects],
					Flammable -> True,
					Acid -> Null,
					Base -> Null,
					Pyrophoric -> True
				|>];

				myChemicalModel2=Upload[<|
					Type -> Model[Sample],
					Flammable -> Null,
					Acid -> True,
					Base -> Null,
					Pyrophoric -> Null
				|>];

				myChemicalObject2=Upload[<|
					Type -> Object[Sample],
					Model -> Link[myChemicalModel2, Objects],
					Flammable -> Null,
					Acid -> True,
					Base -> Null,
					Pyrophoric -> Null
				|>];

				myStorageCondition=Upload[<|
					Type -> Model[StorageCondition],
					Flammable -> True,
					Acid -> True,
					Base -> Null,
					Pyrophoric -> True,
					DeveloperObject -> True
				|>];
			},
			TearDown :> {
				EraseObject[$CreatedObjects, Force -> True]
			}
		],
		Example[{Additional, "When given raw booleans, makes sure that the booleans match the Storage Condition safety information:"},
			ValidStorageConditionQ[True, False, False, True, myStorageCondition],
			False,
			SetUp :> {
				$CreatedObjects={};

				myStorageCondition=Upload[<|
					Type -> Model[StorageCondition],
					Flammable -> True,
					Acid -> True,
					Base -> Null,
					Pyrophoric -> True,
					DeveloperObject -> True
				|>];
			},
			TearDown :> {
				EraseObject[$CreatedObjects, Force -> True]
			},
			Messages :> {
				Error::InvalidStorageCondition
			}
		],
		Example[{Additional, "When given raw booleans, makes sure that the booleans match the Storage Condition safety information:"},
			ValidStorageConditionQ[True, True, False, True, myStorageCondition],
			True,
			SetUp :> {
				$CreatedObjects={};

				myStorageCondition=Upload[<|
					Type -> Model[StorageCondition],
					Flammable -> True,
					Acid -> True,
					Base -> Null,
					Pyrophoric -> True,
					DeveloperObject -> True
				|>];
			},
			TearDown :> {
				EraseObject[$CreatedObjects, Force -> True]
			}
		],
		Example[{Basic, "Returns False when given an unknown format:"},
			ValidStorageConditionQ[TacoCat],
			False
		]
	}
]
