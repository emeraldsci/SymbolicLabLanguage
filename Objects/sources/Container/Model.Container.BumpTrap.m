

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

DefineObjectType[Model[Container, BumpTrap], {
	Description->"A model of glassware used to catch liquid solvent that escapes a rotovaps evaporation flask during evaporation.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		TaperGroundJointSize -> {
			Format -> Single,
			Class -> String,
			Pattern :> GroundGlassJointSizeP,
			Description -> "The taper ground joint size designation of the mouth on this vessel.",
			Category -> "Container Specifications"
		},
		InternalDimensions -> {
			Format -> Single,
			Class -> {Real,Real},
			Pattern :> {GreaterP[0*Milli*Meter],GreaterP[0*Milli*Meter]},
			Units -> {Meter Milli,Meter Milli},
			Headers -> {"Width","Depth"},
			Description -> "Interior size of the vessel's contents holding cavity.",
			Category -> "Dimensions & Positions"
		},
		InternalDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Interior diameter of the vessel's contents holding cavity.",
			Category -> "Dimensions & Positions"
		},
		Aperture -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Meter],
			Units -> Meter Milli,
			Description -> "The minimum opening diameter encountered when aspirating from the container.",
			Category -> "Dimensions & Positions"
		},
		InternalDepth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The distance from the aperture to the bottom of vessel's contents-holding cavity.",
			Category -> "Dimensions & Positions"
		},
		SelfStandingContainers->{
			Format->Multiple,
			Class->Link,
			Pattern :> _Link,
			Relation->Model[Container,Rack],
			Description->"Model of a container capable of holding this type of vessel upright.",
			Category->"Compatibility"
		},
		PlateImagerRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Rack],
			Description -> "Model of a rack that can be used to image this container on a plate imager instrument.",
			Category -> "Compatibility"
		},
		SampleImagerRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Rack],
			Description -> "Model of a rack that can be used to image this container on a sample imager instrument.",
			Category -> "Compatibility"
		},
		Stocked->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if the empty containers of this model are kept in stock for use on demand in experiments.",
			Abstract->True,
			Category -> "Container Specifications"
		}
	}
}];
