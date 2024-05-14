(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, Wrench], {
	Description->"Model information for a tool or set of tools used to turn objects by creating a lever and applying torque.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		WrenchType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WrenchTypeP,
			Description -> "The shape of the end of the wrench indicating the type of fittings it can tighten and loosen.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		SecondaryWrenchType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WrenchTypeP,
			Description -> "For combination wrenches, the shape of the second end that indicates the type of fittings it can tighten and loosen.",
			Category-> "Part Specifications",
			Abstract -> True
		},
		GripSizes -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterP[0 Millimeter]|GreaterP[0 Inch]|GreaterP[0 Unit],
			Description -> "The sizes of the fasteners or sockets that the wrench is intended to interact with.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		MinGripSizes -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0 Millimeter]|GreaterEqualP[0 Inch]|GreaterEqualP[0 Unit],
			Description -> "For adjustable wrenches, the minimum sizes of the fasteners or sockets that the wrench is intended to interact with.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		MaxGripSizes -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterP[0 Millimeter]|GreaterP[0 Inch]|GreaterP[0 Unit],
			Description -> "For adjustable wrenches, the maximum sizes of the fasteners or sockets that the wrench is intended to interact with.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		WrenchLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units-> Inch,
			Description -> "The overall length of the wrench, end-to-end.",
			Category -> "Item Specifications",
			Abstract -> True
		},
		WrenchMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The material that the ends of the wrench is made of.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		Ratcheting -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Describes whether or not there is a mechanism to allow tightening or loosening by pivoting the tool back and forth.",
			Category -> "Part Specifications"
		},
		MinTorque -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> GreaterP[0 Newton Meter]|GreaterP[0 PoundFoot],
			Description -> "For wrenches with adjustable torque, the lowest torque value that can be set.",
			Category -> "Part Specifications"
		},
		MaxTorque -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> GreaterP[0 Newton Meter]|GreaterP[0 PoundFoot],
			Description -> "For wrenches with adjustable torque, the highest torque value that can be set.",
			Category -> "Part Specifications"
		},
		ArmLengths -> {
			Format -> Single,
			Class -> {Real,Real},
			Pattern :> {GreaterP[0 Centimeter],GreaterP[0 Centimeter]},
			Units -> {Centimeter,Centimeter},
			Description -> "For each member of GripSizes, the lengths of their short and long arms when the wrenches are L-shaped.",
			Category -> "Part Specifications",
			IndexMatching -> GripSizes,
			Headers->{"Short arm length","Long arm length"}
		},
		Kit -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this item is composed of multiple small wrenches.",
			Category -> "Part Specifications"
		}
	}
}];
