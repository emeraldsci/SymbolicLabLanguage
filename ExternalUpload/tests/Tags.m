(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*DefineTags*)

DefineTests[
	DefineTags,
	{
		Example[{Basic, "Assign informative labels to a given Object[Sample]. The Tags field is most often used as a catch-all to store external information about a sample, before it arrived in the ECL (ex. batch numbers, degredation information), any information about activities inside of the ECL is automatically tracked and logged in the Object[Sample]. If transfers are made out of this sample into another destination sample, the destination sample will inherit the Tags of this source sample:"},
			DefineTags[
				mySample,
				Tags -> {
					"Batch #6",
					"Production Facility US/CA/94305",
					"QA ID #18372"
				}
			],
			ObjectP[Object[Sample]],
			SetUp :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for DefineTags)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for DefineTags)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineTags)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineTags)"], Force -> True, Verbose -> False]
				];

				Upload[<|Type -> Object[Container, Vessel], Name -> "Empty 50mL Tube (Test for DefineTags)", Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects]|>];

				mySample=ECL`InternalUpload`UploadSample[{{100 VolumePercent, Model[Molecule, "Water"]}, {5 Micromolar, Model[Molecule, Oligomer, "id:zGj91a70vjAj"]}}, {"A1", Object[Container, Vessel, "Empty 50mL Tube (Test for DefineTags)"]}, InitialAmount -> 1 Milliliter, Name -> "Oligomer in Water (Test for DefineTags)"];
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for DefineTags)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for DefineTags)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineTags)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineTags)"], Force -> True, Verbose -> False]
				];
			}
		]
	}
];

DefineTests[
	DefineTagsOptions,
	{
		Example[{Basic, "Assign informative labels to a given Object[Sample]. The Tags field is most often used as a catch-all to store external information about a sample, before it arrived in the ECL (ex. batch numbers, degredation information), any information about activities inside of the ECL is automatically tracked and logged in the Object[Sample]. If transfers are made out of this sample into another destination sample, the destination sample will inherit the Tags of this source sample:"},
			DefineTagsOptions[
				mySample,
				Tags -> {
					"Batch #6",
					"Production Facility US/CA/94305",
					"QA ID #18372"
				}
			],
			_Grid,
			SetUp :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for DefineTagsOptions)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for DefineTagsOptions)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineTagsOptions)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineTagsOptions)"], Force -> True, Verbose -> False]
				];

				Upload[<|Type -> Object[Container, Vessel], Name -> "Empty 50mL Tube (Test for DefineTagsOptions)", Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects]|>];

				mySample=ECL`InternalUpload`UploadSample[{{100 VolumePercent, Model[Molecule, "Water"]}, {5 Micromolar, Model[Molecule, Oligomer, "id:zGj91a70vjAj"]}}, {"A1", Object[Container, Vessel, "Empty 50mL Tube (Test for DefineTagsOptions)"]}, InitialAmount -> 1 Milliliter, Name -> "Oligomer in Water (Test for DefineTagsOptions)"];
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for DefineTagsOptions)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for DefineTagsOptions)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineTagsOptions)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineTagsOptions)"], Force -> True, Verbose -> False]
				];
			}
		]
	}
];

DefineTests[
	ValidDefineTagsQ,
	{
		Example[{Basic, "Assign informative labels to a given Object[Sample]. The Tags field is most often used as a catch-all to store external information about a sample, before it arrived in the ECL (ex. batch numbers, degredation information), any information about activities inside of the ECL is automatically tracked and logged in the Object[Sample]. If transfers are made out of this sample into another destination sample, the destination sample will inherit the Tags of this source sample:"},
			ValidDefineTagsQ[
				mySample,
				Tags -> {
					"Batch #6",
					"Production Facility US/CA/94305",
					"QA ID #18372"
				}
			],
			BooleanP,
			SetUp :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for ValidDefineTagsQ)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for ValidDefineTagsQ)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for ValidDefineTagsQ)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for ValidDefineTagsQ)"], Force -> True, Verbose -> False]
				];

				Upload[<|Type -> Object[Container, Vessel], Name -> "Empty 50mL Tube (Test for ValidDefineTagsQ)", Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects]|>];

				mySample=ECL`InternalUpload`UploadSample[{{100 VolumePercent, Model[Molecule, "Water"]}, {5 Micromolar, Model[Molecule, Oligomer, "id:zGj91a70vjAj"]}}, {"A1", Object[Container, Vessel, "Empty 50mL Tube (Test for ValidDefineTagsQ)"]}, InitialAmount -> 1 Milliliter, Name -> "Oligomer in Water (Test for ValidDefineTagsQ)"];
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for ValidDefineTagsQ)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for ValidDefineTagsQ)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for ValidDefineTagsQ)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for ValidDefineTagsQ)"], Force -> True, Verbose -> False]
				];
			}
		]
	}
];