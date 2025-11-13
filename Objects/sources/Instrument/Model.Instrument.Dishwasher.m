(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, Dishwasher], {
	Description->"A model for an instrument for washing laboratory glassware and plasticware.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		HEPAFilteredDrying -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the washer is capable of HEPA filtered drying.",
			Category -> "Instrument Specifications"
		},
		Detergent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,Consumable],
			Description -> "Detergent used to wash labware compatible with this instrument.",
			Category -> "Instrument Specifications"
		},
		Neutralizer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,Consumable],
			Description -> "Acid neutralizing agent compatible with this instrument.",
			Category -> "Instrument Specifications"
		},
		Softener -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,Consumable],
			Description -> "Chemical agent that is used to soften tap water used to clean the labware.",
			Category -> "Instrument Specifications"
		},
		AirFilter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part,Filter],
			Description -> "Filter that is used to filter air when drying the labware.",
			Category -> "Instrument Specifications"
		},
		DishwasherRacks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The models of dish racks that can be used in this type of dishwasher.",
			Category -> "Compatibility"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The minimum water temperature that the dishwasher can use to clean labware.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The maximum water temperature that the dishwasher can use to clean labware.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		InternalDimensions -> {
			Format -> Single,
			Class -> {Real,Real,Real},
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Units -> {Meter,Meter,Meter},
			Description -> "The size of the space inside the dishwasher.",
			Category -> "Dimensions & Positions",
			Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
		},
		PositionHeights -> {
			Format -> Multiple,
			Class -> {String,Real},
			Pattern :> {LocationPositionP,GreaterEqualP[0*Meter]},
			Units -> {None, Meter},
			Description -> "The distances between the bottom of the dishwasher chamber and the positions where racks can be inserted.",
			Category -> "Dimensions & Positions",
			Headers -> {"Rack Slot","Z-Position"}
		},
		PositionMaxWeights -> {
			Format -> Multiple,
			Class -> {String, Real},
			Pattern :> {LocationPositionP, GreaterEqualP[0 Kilogram]},
			Units -> {None, Kilogram},
			Description -> "The upper bound weight limit for each position. The total weight of any rack and its contents should not exceed this value when loaded at these positions.",
			Category -> "Operating Limits",
			Headers -> {"Rack Slot", "Max Weight"}
		}
	}
}];
