(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, Centrifuge], {
	Description->"A model for an instrument that uses rotation to exert centrifugal force on vessels and plates.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* --- Instrument Specifications ---*)
		CentrifugeType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CentrifugeTypeP,
			Description -> "The category/mode of operation of this centrifuge model.",
			Category -> "Instrument Specifications"
		},

		(* --- Operating Limits --- *)
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature that the centrifuge can be set to maintain.",
			Category -> "Operating Limits"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature that the centrifuge can be set to maintain.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxRotationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*RPM],
			Units -> RPM,
			Description -> "The maximum rotational speed at which the centrifuge can operate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinRotationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*RPM],
			Units -> RPM,
			Description -> "The minimum rotational speed at which the centrifuge can operate.",
			Category -> "Operating Limits"
		},
		MaxTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "The maximum duration for which the centrifuge can be continuously run.",
			Category -> "Operating Limits"
		},
		SpeedResolution -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0*RPM],
			Units -> RPM,
			Description -> "The minimum increment by which this centrifuge model's spin rate can be adjusted.",
			Category -> "Operating Limits"
		},
		MaxStackHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The maximum height of a plate that the non replaceable rotor bucket can take during centrifugation.",
			Category -> "Operating Limits"
		},
		MaxWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Gram,
			Description -> "The maximum weight of a plate that the non replaceable rotor bucket can take during centrifugation.",
			Category -> "Operating Limits"
		},

		(* --- Compatibility --- *)
		CompatibleContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The container models that can be spun in this model of centrifuge.",
			Category -> "Compatibility"
		},
		ContainerCapacity -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0,1],
			Description -> "For each member of CompatibleContainers, the number of the container model that can be processed by this centrifuge at a single time.",
			Category -> "Compatibility",
			IndexMatching -> CompatibleContainers
		},
		ContainerBuckets -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, CentrifugeBucket],
			Description -> "For each member of CompatibleContainers, the centrifuge bucket for this centrifuge model that can accommodate the container model.",
			Category -> "Compatibility",
			IndexMatching -> CompatibleContainers
		},
		ContainerPositions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_String..},
			Description -> "For each member of CompatibleContainers, the positions into which the container model can fit within the relevant centrifuge bucket (if buckets are used) or rotor (if buckets are not used).",
			Category -> "Compatibility",
			IndexMatching -> CompatibleContainers
		},
		CompatibleCentrifugeBuckets ->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, CentrifugeBucket],
			Description ->"The model centrifuge buckets that can be placed on the centrifuge rotor in this model of centrifuge.",
			Category -> "Compatibility"
		},
		BucketCapacity -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "The number of buckets that may be placed in the centrifuge.",
			Category -> "Compatibility"
		},
		BucketPlacements -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {LocationPositionP..},
			Description -> "A list of deck placements to fill the centrifuge with buckets, arranged such that opposing buckets are placed sequentially.",
			Category -> "Compatibility",
			Developer -> True
		},
		CompatibleContainerParameters -> {
			Format -> Multiple,
			Class -> {
				Container->Link, 
				Capacity->Integer, 
				Rotor->Link, 
				Bucket->Link, 
				Positions->Expression, 
				MaxRadius->Real, 
				MaxRotationRate->Real
			},
			Pattern :> {
				Container->_Link, 
				Capacity->GreaterP[0,1], 
				Rotor->_Link, 
				Bucket->_Link, 
				Positions->{LocationPositionP..}, 
				MaxRadius->GreaterP[0 Millimeter], 
				MaxRotationRate->GreaterP[0 RPM]
			},
			Relation -> {
				Container->(Model[Container, Plate] | Model[Container, Vessel]), 
				Capacity->Null, 
				Rotor->Model[Container, CentrifugeRotor], 
				Bucket->Model[Container, CentrifugeBucket], 
				Positions->Null, 
				MaxRadius->Null, 
				MaxRotationRate->Null
			},
			Units -> {
				Container->None, 
				Capacity->None, 
				Rotor->None, 
				Bucket->None, 
				Positions->None, 
				MaxRadius->Millimeter, 
				MaxRotationRate->RPM
			},
			Headers -> {
				Container->"Container Model", 
				Capacity->"Capacity", 
				Rotor->"Rotor Model", 
				Bucket->"Bucket Model", 
				Positions->"Position Names", 
				MaxRadius->"Max Spin Radius", 
				MaxRotationRate->"Max Rotation Rate"
			},
			Description -> "A listing of container models accommodated by this centrifuge, indexed to other parameters relevant to the usage of those container models in this centrifuge.",
			Developer -> True,
			Category -> "Compatibility"
		}
	}
}];
