(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Item,Electrode], {
	Description->"Object information for an electrode object, which is made of conductive material(s) and inserted in various medias to deliver voltage and current.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		(* Electrode Information *)
		BulkMaterial -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], BulkMaterial]],
			Pattern :> MaterialP,
			Description -> "The main material composition of this electrode object. This is the same with the WettedMaterials field if the Coated field is False.",
			Category -> "Physical Properties"
		},
		Coated -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], Coated]],
			Pattern :> BooleanP,
			Description -> "Indicates if there is a different type of material outside the electrode other than the bulk material. If the electrode is coated, it should not be polished.",
			Category -> "Physical Properties"
		},
		CoatMaterial -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], CoatMaterial]],
			Pattern :> MaterialP,
			Description -> "The surface material of this electrode object, if it is coated. This is the same with the WettedMaterials field if the Coated field is True.",
			Category -> "Physical Properties"
		},
		ElectrodeShape -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], ElectrodeShape]],
			Pattern :> ElectrodeShapeP,
			Description -> "The general type / class description containing information about the material, shape and size of the electrode.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		ElectrodePackagingMaterial -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], ElectrodePackagingMaterial]],
			Pattern :> MaterialP,
			Description -> "The type of material and shape wrapping the working material of the electrode.",
			Category -> "Physical Properties"
		},
		MinPotential -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinPotential]],
			Pattern :> VoltageP,
			Description -> "The minimum voltage that can be applied to this electrode model.",
			Category -> "Operating Limits"
		},
		MaxPotential -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxPotential]],
			Pattern :> VoltageP,
			Description -> "The maximum voltage that can be applied to this electrode object.",
			Category -> "Operating Limits"
		},

		(* Polishing and Cleaning Information *)
		PolishingSolutions -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], PolishingSolutions]],
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The recommended polishing solution models used to polish this electrode object.",
			Category -> "Electrode Polishing"
		},
		PolishingPads -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], PolishingPads]],
			Pattern :> _Link,
			Relation -> Model[Item, ElectrodePolishingPad],
			Description -> "The recommended polishing pad models used to polish this electrode object.",
			Category -> "Electrode Polishing"
		},
		SonicationSensitive -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], SonicationSensitive]],
			Pattern :> BooleanP,
			Description -> "Indicates the electrode object has components that may be damaged if it is sonication-cleaned.",
			Category -> "Cleaning"
		},

		(* Usage Information *)
		UsageLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link, Link},
			Pattern :> {_?DateObjectQ, ElectrodeRoleP, _Link, _Link},
			Relation -> {Null, Null, Object[Data], Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Headers -> {"Date", "Role", "Cyclic Voltammetry Data", "Responsible Party"},
			Description -> "Record the historical usage types of this electrode object.",
			Category -> "Usage Information"
		},
		NumberOfPolishings -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "Indicates the number of polishings have been performed on this electrode object.",
			Category -> "Usage Information"
		},
		PolishingLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link, _Link, _Link},
			Relation -> {
				Null,
				Object[Protocol],
				Object[Item, ElectrodePolishingPad][PolishingLog],
				Object[Sample] | Model[Sample],
				Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]
			},
			Headers -> {"Date", "Polishing Protocol", "Polishing Pad", "Polishing Solution", "Responsible Party"},
			Description -> "Record the historical polishes performed on this electrode object.",
			Category -> "Usage Information"
		},

		(* Maintenance *)
		CurrentElectrodeImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Link to a current photo of this electrode object.",
			Category -> "Usage Information"
		},
		ImageLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[EmeraldCloudFile], Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Headers -> {"Date", "Image", "Responsible Party"},
			Description -> "Describe the historical appearances of this electrode object.",
			Category -> "Usage Information"
		},
		RustCheckingLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link},
			Pattern :> {_?DateObjectQ, Alternatives[None, Both, WorkingPart, NonWorkingPart], _Link},
			Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Headers -> {"Date", "Rust Location", "Responsible Party"},
			Description -> "Record the presence of rust on this electrode object.",
			Category -> "Usage Information"
		}
	}
}];
