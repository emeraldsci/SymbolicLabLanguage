(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*DefineComposition*)

DefineTests[
	DefineComposition,
	{
		(*Basic input, default behavior to Replace the current composition*)
		Example[{Basic, "Define the molecular components that are present in this Object[Sample]. DefineComposition commonly run after samples have been separated (ex. HPLC/FPLC/Filter/SolidPhaseExtraction) and their composition have been changed. After analyzing the data collected from the separation and determining what components you believe are present in the sample, use this function to populate those components in the Composition field of the sample:"},
			DefineComposition[
				mySample,
				Composition -> {
					{100 VolumePercent, Model[Molecule, "Water"]},
					{5 Micromolar, Model[Molecule, Oligomer, "id:zGj91a70vjAj"]}
				}
			],
			ObjectP[Object[Sample]],
			SetUp :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for DefineComposition)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for DefineComposition)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineComposition)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineComposition)"], Force -> True, Verbose -> False]
				];

				Upload[<|Type -> Object[Container, Vessel], Name -> "Empty 50mL Tube (Test for DefineComposition)", Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects]|>];

				mySample=ECL`InternalUpload`UploadSample[{{100 VolumePercent, Model[Molecule, "Water"]}, {5 Micromolar, Model[Molecule, Oligomer, "id:zGj91a70vjAj"]}}, {"A1", Object[Container, Vessel, "Empty 50mL Tube (Test for DefineComposition)"]}, InitialAmount -> 1 Milliliter, Name -> "Oligomer in Water (Test for DefineComposition)"];
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for DefineComposition)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for DefineComposition)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineComposition)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineComposition)"], Force -> True, Verbose -> False]
				];
			}
		],
		(*Append option test, adds components to existing composition*)
		Example[{Basic, "Append to the molecular components that are present in this Object[Sample]. DefineComposition commonly run after samples have been separated (ex. HPLC/FPLC/Filter/SolidPhaseExtraction) and their composition have been changed. After analyzing the data collected from the separation and determining what components you believe are present in the sample, use this function to append to the existing components in the Composition field of the sample:"},
			DefineComposition[
				mySampleToAppend,
				Composition -> {
					{100 Micromolar, Model[Molecule, "id:BYDOjvG676mq"]}
				},
				Append -> True
			],
			ObjectP[Object[Sample]],
			SetUp :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for Append DefineComposition)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for Append DefineComposition)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for Append DefineComposition)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for Append DefineComposition)"], Force -> True, Verbose -> False]
				];

				Upload[<|Type -> Object[Container, Vessel], Name -> "Empty 50mL Tube (Test for Append DefineComposition)", Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects]|>];

				mySampleToAppend=ECL`InternalUpload`UploadSample[{{100 VolumePercent, Model[Molecule, "Water"]}, {5 Micromolar, Model[Molecule, Oligomer, "id:zGj91a70vjAj"]}}, {"A1", Object[Container, Vessel, "Empty 50mL Tube (Test for Append DefineComposition)"]}, InitialAmount -> 1 Milliliter, Name -> "Oligomer in Water (Test for Append DefineComposition)"];
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for Append DefineComposition)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for Append DefineComposition)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for Append DefineComposition)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for Append DefineComposition)"], Force -> True, Verbose -> False]
				];
			}
		]
	}
];

DefineTests[
	DefineCompositionOptions,
	{
		(*Basic input, default behavior to Replace the current composition*)
		Example[{Basic, "Define the molecular components that are present in this Object[Sample]. DefineCompositionOptions commonly run after samples have been separated (ex. HPLC/FPLC/Filter/SolidPhaseExtraction) and their composition have been changed. After analyzing the data collected from the separation and determining what components you believe are present in the sample, use this function to populate those components in the Composition field of the sample:"},
			DefineCompositionOptions[
				mySample,
				Composition -> {
					{100 VolumePercent, Model[Molecule, "Water"]},
					{5 Micromolar, Model[Molecule, Oligomer, "id:zGj91a70vjAj"]}
				}
			],
			_Grid,
			SetUp :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for DefineCompositionOptions)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for DefineCompositionOptions)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineCompositionOptions)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineCompositionOptions)"], Force -> True, Verbose -> False]
				];

				Upload[<|Type -> Object[Container, Vessel], Name -> "Empty 50mL Tube (Test for DefineCompositionOptions)", Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects]|>];

				mySample=ECL`InternalUpload`UploadSample[{{100 VolumePercent, Model[Molecule, "Water"]}, {5 Micromolar, Model[Molecule, Oligomer, "id:zGj91a70vjAj"]}}, {"A1", Object[Container, Vessel, "Empty 50mL Tube (Test for DefineCompositionOptions)"]}, InitialAmount -> 1 Milliliter, Name -> "Oligomer in Water (Test for DefineCompositionOptions)"];
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for DefineCompositionOptions)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for DefineCompositionOptions)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineCompositionOptions)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineCompositionOptions)"], Force -> True, Verbose -> False]
				];
			}
		],
		(*Append option test, adds components to existing composition*)
		Example[{Basic, "Append to the molecular components that are present in this Object[Sample]. DefineCompositionOptions commonly run after samples have been separated (ex. HPLC/FPLC/Filter/SolidPhaseExtraction) and their composition have been changed. After analyzing the data collected from the separation and determining what components you believe are present in the sample, use this function to append to the existing components in the Composition field of the sample:"},
			DefineCompositionOptions[
				mySampleToAppend,
				Composition -> {
					{100 Micromolar, Model[Molecule, "id:BYDOjvG676mq"]}
				},
				Append -> True
			],
			_Grid,
			SetUp :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for Append DefineCompositionOptions)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for Append DefineCompositionOptions)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for Append DefineCompositionOptions)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for Append DefineCompositionOptions)"], Force -> True, Verbose -> False]
				];

				Upload[<|Type -> Object[Container, Vessel], Name -> "Empty 50mL Tube (Test for Append DefineCompositionOptions)", Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects]|>];

				mySampleToAppend=ECL`InternalUpload`UploadSample[{{100 VolumePercent, Model[Molecule, "Water"]}, {5 Micromolar, Model[Molecule, Oligomer, "id:zGj91a70vjAj"]}}, {"A1", Object[Container, Vessel, "Empty 50mL Tube (Test for Append DefineCompositionOptions)"]}, InitialAmount -> 1 Milliliter, Name -> "Oligomer in Water (Test for Append DefineCompositionOptions)"];
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for Append DefineCompositionOptions)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for Append DefineCompositionOptions)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for Append DefineCompositionOptions)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for Append DefineCompositionOptions)"], Force -> True, Verbose -> False]
				];
			}
		]
	}
];

DefineTests[
	ValidDefineCompositionQ,
	{
		(*Basic input, default behavior to Replace the current composition*)
		Example[{Basic, "Define the molecular components that are present in this Object[Sample]. ValidDefineCompositionQ commonly run after samples have been separated (ex. HPLC/FPLC/Filter/SolidPhaseExtraction) and their composition have been changed. After analyzing the data collected from the separation and determining what components you believe are present in the sample, use this function to populate those components in the Composition field of the sample:"},
			ValidDefineCompositionQ[
				mySample,
				Composition -> {
					{100 VolumePercent, Model[Molecule, "Water"]},
					{5 Micromolar, Model[Molecule, Oligomer, "id:zGj91a70vjAj"]}
				}
			],
			BooleanP,
			SetUp :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for ValidDefineCompositionQ)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for ValidDefineCompositionQ)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for ValidDefineCompositionQ)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for ValidDefineCompositionQ)"], Force -> True, Verbose -> False]
				];

				Upload[<|Type -> Object[Container, Vessel], Name -> "Empty 50mL Tube (Test for ValidDefineCompositionQ)", Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects]|>];

				mySample=ECL`InternalUpload`UploadSample[{{100 VolumePercent, Model[Molecule, "Water"]}, {5 Micromolar, Model[Molecule, Oligomer, "id:zGj91a70vjAj"]}}, {"A1", Object[Container, Vessel, "Empty 50mL Tube (Test for ValidDefineCompositionQ)"]}, InitialAmount -> 1 Milliliter, Name -> "Oligomer in Water (Test for ValidDefineCompositionQ)"];
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for ValidDefineCompositionQ)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for ValidDefineCompositionQ)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for ValidDefineCompositionQ)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for ValidDefineCompositionQ)"], Force -> True, Verbose -> False]
				];
			}
		],
		(*Append option test, adds components to existing composition*)
		Example[{Basic, "Append to the molecular components that are present in this Object[Sample]. ValidDefineCompositionQ commonly run after samples have been separated (ex. HPLC/FPLC/Filter/SolidPhaseExtraction) and their composition have been changed. After analyzing the data collected from the separation and determining what components you believe are present in the sample, use this function to append to the existing components in the Composition field of the sample:"},
			ValidDefineCompositionQ[
				mySampleToAppend,
				Composition -> {
					{100 Micromolar, Model[Molecule, "id:BYDOjvG676mq"]}
				},
				Append -> True
			],
			BooleanP,
			SetUp :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for Append ValidDefineCompositionQ)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for Append ValidDefineCompositionQ)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for Append ValidDefineCompositionQ)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for Append ValidDefineCompositionQ)"], Force -> True, Verbose -> False]
				];

				Upload[<|Type -> Object[Container, Vessel], Name -> "Empty 50mL Tube (Test for Append ValidDefineCompositionQ)", Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects]|>];

				mySampleToAppend=ECL`InternalUpload`UploadSample[{{100 VolumePercent, Model[Molecule, "Water"]}, {5 Micromolar, Model[Molecule, Oligomer, "id:zGj91a70vjAj"]}}, {"A1", Object[Container, Vessel, "Empty 50mL Tube (Test for Append ValidDefineCompositionQ)"]}, InitialAmount -> 1 Milliliter, Name -> "Oligomer in Water (Test for Append ValidDefineCompositionQ)"];
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for Append ValidDefineCompositionQ)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for Append ValidDefineCompositionQ)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for Append ValidDefineCompositionQ)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for Append ValidDefineCompositionQ)"], Force -> True, Verbose -> False]
				];
			}
		]
	}
];