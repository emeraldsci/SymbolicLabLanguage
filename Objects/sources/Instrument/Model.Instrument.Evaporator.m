

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, Evaporator], {
	Description->"A model for nitrogen blow down evaporators.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		NitrogenEvaporatorType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> NitrogenEvaporatorTypeP,
			Description ->"The category of nitrogen blow down evaporator.",
			Category -> "Instrument Specifications"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature at which the evaporator can incubate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature at which the evaporator can incubate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Liter)/Minute],
			Units -> Liter/Minute,
			Description -> "Minimum flow rate the flow regulator can manage.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Liter)/Minute],
			Units -> Liter/Minute,
			Description -> "Maximum flow rate the flow regulator can manage.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		TubingInnerDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "Internal diameter of the tubing that connects to the instrument.",
			Category -> "Dimensions & Positions"
		},

		(*- Container Compatibility -*)
		CompatibleContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The container models that can be spun in this model of nitrogen evaporator.",
			Category -> "Compatibility"
		},
		ContainerCapacity -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0,1],
			Description -> "For each member of CompatibleContainers, the number of the container model that can be processed by this evaportor at a single time.",
			Category -> "Compatibility",				IndexMatching -> CompatibleContainers
		},
		RackType -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Rack],
			Description -> "The container racks that can be placed in this model of nitrogen evaporator.",
			Category -> "Compatibility"
		}
	}
}];
