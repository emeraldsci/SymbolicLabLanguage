(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*DefineAnalytes*)

DefineTests[
	DefineAnalytes,
	{
		Example[{Basic, "Define the analytes of interest in a given Object[Sample]. The analytes must be present in the given Object[Sample]'s Composition field. To get the full list of analyte types, evaluate the pattern IdentityModelTypes:"},
			DefineAnalytes[
				mySample,
				Analytes -> {Model[Molecule, Oligomer, "id:zGj91a70vjAj"]}
			],
			ObjectP[Object[Sample]],
			SetUp :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for DefineAnalytes)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for DefineAnalytes)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineAnalytes)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineAnalytes)"], Force -> True, Verbose -> False]
				];

				Upload[<|Type -> Object[Container, Vessel], Name -> "Empty 50mL Tube (Test for DefineAnalytes)", Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects]|>];

				mySample=ECL`InternalUpload`UploadSample[{{100 VolumePercent, Model[Molecule, "Water"]}, {5 Micromolar, Model[Molecule, Oligomer, "id:zGj91a70vjAj"]}}, {"A1", Object[Container, Vessel, "Empty 50mL Tube (Test for DefineAnalytes)"]}, InitialAmount->1 Milliliter, Name -> "Oligomer in Water (Test for DefineAnalytes)"];
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for DefineAnalytes)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for DefineAnalytes)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineAnalytes)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineAnalytes)"], Force -> True, Verbose -> False]
				];
			}
		]
	}
];

DefineTests[
	DefineAnalytesOptions,
	{
		Example[{Basic, "Define the analytes of interest in a given Object[Sample]. The analytes must be present in the given Object[Sample]'s Composition field. To get the full list of analyte types, evaluate the pattern IdentityModelTypes:"},
			DefineAnalytesOptions[
				mySample,
				Analytes -> {Model[Molecule, Oligomer, "id:zGj91a70vjAj"]}
			],
			_Grid,
			SetUp :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for DefineAnalytesOptions)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for DefineAnalytesOptions)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineAnalytesOptions)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineAnalytesOptions)"], Force -> True, Verbose -> False]
				];

				Upload[<|Type -> Object[Container, Vessel], Name -> "Empty 50mL Tube (Test for DefineAnalytesOptions)", Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects]|>];

				mySample=ECL`InternalUpload`UploadSample[{{100 VolumePercent, Model[Molecule, "Water"]}, {5 Micromolar, Model[Molecule, Oligomer, "id:zGj91a70vjAj"]}}, {"A1", Object[Container, Vessel, "Empty 50mL Tube (Test for DefineAnalytesOptions)"]}, InitialAmount->1 Milliliter, Name -> "Oligomer in Water (Test for DefineAnalytesOptions)"];
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for DefineAnalytesOptions)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for DefineAnalytesOptions)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineAnalytesOptions)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineAnalytesOptions)"], Force -> True, Verbose -> False]
				];
			}
		]
	}
];

DefineTests[
	ValidDefineAnalytesQ,
	{
		Example[{Basic, "Define the analytes of interest in a given Object[Sample]. The analytes must be present in the given Object[Sample]'s Composition field. To get the full list of analyte types, evaluate the pattern IdentityModelTypes:"},
			ValidDefineAnalytesQ[
				mySample,
				Analytes -> {Model[Molecule, Oligomer, "id:zGj91a70vjAj"]}
			],
			BooleanP,
			SetUp :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for ValidDefineAnalytesQ)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for ValidDefineAnalytesQ)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for ValidDefineAnalytesQ)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for ValidDefineAnalytesQ)"], Force -> True, Verbose -> False]
				];

				Upload[<|Type -> Object[Container, Vessel], Name -> "Empty 50mL Tube (Test for ValidDefineAnalytesQ)", Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects]|>];

				mySample=ECL`InternalUpload`UploadSample[{{100 VolumePercent, Model[Molecule, "Water"]}, {5 Micromolar, Model[Molecule, Oligomer, "id:zGj91a70vjAj"]}}, {"A1", Object[Container, Vessel, "Empty 50mL Tube (Test for ValidDefineAnalytesQ)"]}, InitialAmount->1 Milliliter, Name -> "Oligomer in Water (Test for ValidDefineAnalytesQ)"];
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for ValidDefineAnalytesQ)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for ValidDefineAnalytesQ)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for ValidDefineAnalytesQ)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for ValidDefineAnalytesQ)"], Force -> True, Verbose -> False]
				];
			}
		]
	}
]