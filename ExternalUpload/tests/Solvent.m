(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*DefineSolvent*)

DefineTests[
	DefineSolvent,
	{
		Example[{Basic, "Define the solvent of this Object[Sample]:"},
			DefineSolvent[
				mySample,
				Solvent -> Model[Sample, "Milli-Q water"]
			],
			ObjectP[Object[Sample]],
			SetUp :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for DefineSolvent)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for DefineSolvent)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineSolvent)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineSolvent)"], Force -> True, Verbose -> False]
				];

				Upload[<|Type -> Object[Container, Vessel], Name -> "Empty 50mL Tube (Test for DefineSolvent)", Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects]|>];

				mySample=ECL`InternalUpload`UploadSample[{{100 VolumePercent, Model[Molecule, "Water"]}, {5 Micromolar, Model[Molecule, Oligomer, "id:zGj91a70vjAj"]}}, {"A1", Object[Container, Vessel, "Empty 50mL Tube (Test for DefineSolvent)"]}, InitialAmount -> 1 Milliliter, Name -> "Oligomer in Water (Test for DefineSolvent)"];
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for DefineSolvent)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for DefineSolvent)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineSolvent)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineSolvent)"], Force -> True, Verbose -> False]
				];
			}
		]
	}
];

DefineTests[
	DefineSolventOptions,
	{
		Example[{Basic, "Define the solvent of this Object[Sample]:"},
			DefineSolventOptions[
				mySample,
				Solvent -> Model[Sample, "Milli-Q water"]
			],
			_Grid,
			SetUp :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for DefineSolventOptions)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for DefineSolventOptions)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineSolventOptions)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineSolventOptions)"], Force -> True, Verbose -> False]
				];

				Upload[<|Type -> Object[Container, Vessel], Name -> "Empty 50mL Tube (Test for DefineSolventOptions)", Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects]|>];

				mySample=ECL`InternalUpload`UploadSample[{{100 VolumePercent, Model[Molecule, "Water"]}, {5 Micromolar, Model[Molecule, Oligomer, "id:zGj91a70vjAj"]}}, {"A1", Object[Container, Vessel, "Empty 50mL Tube (Test for DefineSolventOptions)"]}, InitialAmount -> 1 Milliliter, Name -> "Oligomer in Water (Test for DefineSolventOptions)"];
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for DefineSolventOptions)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for DefineSolventOptions)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineSolventOptions)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for DefineSolventOptions)"], Force -> True, Verbose -> False]
				];
			}
		]
	}
];

DefineTests[
	ValidDefineSolventQ,
	{
		Example[{Basic, "Define the composition of the solvent of this Object[Sample]:"},
			ValidDefineSolventQ[
				mySample,
				Solvent -> Model[Sample, "Milli-Q water"]
			],
			BooleanP,
			SetUp :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for ValidDefineSolventQ)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for ValidDefineSolventQ)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for ValidDefineSolventQ)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for ValidDefineSolventQ)"], Force -> True, Verbose -> False]
				];

				Upload[<|Type -> Object[Container, Vessel], Name -> "Empty 50mL Tube (Test for ValidDefineSolventQ)", Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects]|>];

				mySample=ECL`InternalUpload`UploadSample[{{100 VolumePercent, Model[Molecule, "Water"]}, {5 Micromolar, Model[Molecule, Oligomer, "id:zGj91a70vjAj"]}}, {"A1", Object[Container, Vessel, "Empty 50mL Tube (Test for ValidDefineSolventQ)"]}, InitialAmount -> 1 Milliliter, Name -> "Oligomer in Water (Test for ValidDefineSolventQ)"];
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Sample, "Oligomer in Water (Test for ValidDefineSolventQ)"]],
					EraseObject[Object[Sample, "Oligomer in Water (Test for ValidDefineSolventQ)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Object[Container, Vessel, "Empty 50mL Tube (Test for ValidDefineSolventQ)"]],
					EraseObject[Object[Container, Vessel, "Empty 50mL Tube (Test for ValidDefineSolventQ)"], Force -> True, Verbose -> False]
				];
			}
		]
	}
];