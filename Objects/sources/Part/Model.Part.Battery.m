(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part, Battery], {
	Description->"A model of a portable source of electric power that can be installed in a device to power it.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		Rechargeable->{
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description->"Whether the battery can be charged again after discharging.",
			Category->"Part Specifications",
			Abstract->True
		},
		BatteryMaterials->{
			Format-> Single,
			Class-> Expression,
			Pattern :> BatteryMaterialsP,
			Description->"The materials of construction for this model of battery is composed of. E.g LithiumIon, LeadAcid.",
			Category->"Part Specifications",
			Abstract->True
		},
		MaximumCharge->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Ampere*Hour],
			Units -> Milli*Ampere*Hour,
			Description -> "The maximum charge that this battery can hold and discharge.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		Voltage->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "The amount of voltage this model of battery is rated to output.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		Amperage->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Ampere],
			Units -> Ampere,
			Description -> "The amount of amps this model of battery is rated to output.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		BatteryHousing->{
			Format->Single,
			Class->Expression,
			Pattern:>BatteryTypeP,
			Description->"The housing form factor in which the battery is encased. Devices which use this model of battery housing must have its matching field enumerated.",
			Category->"Part Specifications",
			Abstract->True
		}
	}
}];
