(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*DefineEHSInformation*)

DefineTests[
	DefineEHSInformation,
	{
		Example[{Basic, "Define the EHS (environment, health, and safety) information for a sample. When samples are mixed, the ECL will try its best to figure out the EHS information (ex. Flammable, Acid, Base) of the resulting sample, often assuming that any safety restrictions are propagated to the resulting sample for operator safety. However, if you know that the ECL is being too stringent in assigning EHS information, you can overrule these assignments at any time by using this function. Please note that it is crucial that any EHS information given to the ECL is correct for operator safety:"},
			DefineEHSInformation[
				Object[Sample, "Oligomer in Water (Test for DefineEHSInformation)"],
				State -> Liquid,
				Sterile -> True,
				Expires -> True,
				ShelfLife -> 12 Month,
				UnsealedShelfLife -> 6 Month,
				Radioactive -> False,
				Ventilated -> False,
				Pungent -> False,
				Flammable -> False,
				Pyrophoric -> False,
				WaterReactive -> False,
				LightSensitive -> False,
				BiosafetyLevel -> "BSL-1",
				DOTHazardClass -> Null,
				IncompatibleMaterials -> {None},
				UltrasonicIncompatible -> False,
				NFPA -> {0, 0, 0, {}},
				Acid -> False,
				Base -> False
			],
			ObjectP[Object[Sample]],
			SetUp :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for DefineEHSInformation)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for DefineEHSInformation)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineEHSInformation)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineEHSInformation)"], Force -> True, Verbose -> False]
				];

				Upload[<|Type -> Object[Container, Vessel], Name -> "Empty 50mL Tube (Test for DefineEHSInformation)", Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects]|>];

				ECL`InternalUpload`UploadSample[{{100 VolumePercent, Model[Molecule, "Water"]}, {5 Micromolar, Model[Molecule, Oligomer, "id:zGj91a70vjAj"]}}, {"A1", Object[Container, Vessel, "Empty 50mL Tube (Test for DefineEHSInformation)"]}, Name -> "Oligomer in Water (Test for DefineEHSInformation)", InitialAmount -> 10 * Milliliter];
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for DefineEHSInformation)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for DefineEHSInformation)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineEHSInformation)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineEHSInformation)"], Force -> True, Verbose -> False]
				];
			}
		]
	}
];

DefineTests[
	DefineEHSInformationOptions,
	{
		Example[{Basic, "Define the EHS (environment, health, and safety) information for a sample. When samples are mixed, the ECL will try its best to figure out the EHS information (ex. Flammable, Acid, Base) of the resulting sample, often assuming that any safety restrictions are propagated to the resulting sample for operator safety. However, if you know that the ECL is being too stringent in assigning EHS information, you can overrule these assignments at any time by using this function. Please note that it is crucial that any EHS information given to the ECL is correct for operator safety:"},
			DefineEHSInformationOptions[
				Object[Sample, "Oligomer in Water (Test for DefineEHSInformationOptions)"],
				State -> Liquid,
				Sterile -> True,
				Expires -> True,
				ShelfLife -> 12 Month,
				UnsealedShelfLife -> 6 Month,
				Radioactive -> False,
				Ventilated -> False,
				Pungent -> False,
				Flammable -> False,
				Pyrophoric -> False,
				WaterReactive -> False,
				LightSensitive -> False,
				BiosafetyLevel -> "BSL-1",
				DOTHazardClass -> Null,
				IncompatibleMaterials -> {None},
				UltrasonicIncompatible -> False,
				NFPA -> {0, 0, 0, {}},
				Acid -> False,
				Base -> False
			],
			_Grid,
			SetUp :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for DefineEHSInformationOptions)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for DefineEHSInformationOptions)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineEHSInformationOptions)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineEHSInformationOptions)"], Force -> True, Verbose -> False]
				];

				Upload[<|Type -> Object[Container, Vessel], Name -> "Empty 50mL Tube (Test for DefineEHSInformationOptions)", Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects]|>];

				ECL`InternalUpload`UploadSample[{{100 VolumePercent, Model[Molecule, "Water"]}, {5 Micromolar, Model[Molecule, Oligomer, "id:zGj91a70vjAj"]}}, {"A1", Object[Container, Vessel, "Empty 50mL Tube (Test for DefineEHSInformationOptions)"]}, Name -> "Oligomer in Water (Test for DefineEHSInformationOptions)", InitialAmount -> 10 * Milliliter];
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for DefineEHSInformationOptions)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for DefineEHSInformationOptions)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineEHSInformationOptions)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineEHSInformationOptions)"], Force -> True, Verbose -> False]
				];
			}
		]
	}
];

DefineTests[
	ValidDefineEHSInformationQ,
	{
		Example[{Basic, "Define the EHS (environment, health, and safety) information for a sample. When samples are mixed, the ECL will try its best to figure out the EHS information (ex. Flammable, Acid, Base) of the resulting sample, often assuming that any safety restrictions are propagated to the resulting sample for operator safety. However, if you know that the ECL is being too stringent in assigning EHS information, you can overrule these assignments at any time by using this function. Please note that it is crucial that any EHS information given to the ECL is correct for operator safety:"},
			ValidDefineEHSInformationQ[
				Object[Sample, "Oligomer in Water (Test for ValidDefineEHSInformationQ)"],
				State -> Liquid,
				Sterile -> True,
				Expires -> True,
				ShelfLife -> 12 Month,
				UnsealedShelfLife -> 6 Month,
				Radioactive -> False,
				Ventilated -> False,
				Pungent -> False,
				Flammable -> False,
				Pyrophoric -> False,
				WaterReactive -> False,
				LightSensitive -> False,
				BiosafetyLevel -> "BSL-1",
				DOTHazardClass -> Null,
				IncompatibleMaterials -> {None},
				UltrasonicIncompatible -> False,
				NFPA -> {0, 0, 0, {}},
				Acid -> False,
				Base -> False
			],
			BooleanP,
			SetUp :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for ValidDefineEHSInformationQ)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for ValidDefineEHSInformationQ)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for ValidDefineEHSInformationQ)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for ValidDefineEHSInformationQ)"], Force -> True, Verbose -> False]
				];

				Upload[<|Type -> Object[Container, Vessel], Name -> "Empty 50mL Tube (Test for ValidDefineEHSInformationQ)", Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects]|>];

				ECL`InternalUpload`UploadSample[{{100 VolumePercent, Model[Molecule, "Water"]}, {5 Micromolar, Model[Molecule, Oligomer, "id:zGj91a70vjAj"]}}, {"A1", Object[Container, Vessel, "Empty 50mL Tube (Test for ValidDefineEHSInformationQ)"]}, Name -> "Oligomer in Water (Test for ValidDefineEHSInformationQ)", InitialAmount -> 10 * Milliliter];
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for ValidDefineEHSInformationQ)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for ValidDefineEHSInformationQ)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for ValidDefineEHSInformationQ)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for ValidDefineEHSInformationQ)"], Force -> True, Verbose -> False]
				];
			}
		]
	}
];