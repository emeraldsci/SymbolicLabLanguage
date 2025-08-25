(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, DissolutionApparatus], {
	Description->"Model information for a dissolution apparatus, used for dissolving solid samples in a liquid in controlled conditions.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
        MaxRotationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Revolution)/Minute],
			Units -> Revolution/Minute,
			Description -> "Maximum speed at which the shaft can spin to dissolve the samples.",
			Category -> "Operating Limits"
		},
		MinRotationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Revolution)/Minute],
			Units -> Revolution/Minute,
			Description -> "Minium speed at which the shaft can spin to dissolve the samples.",
			Category -> "Operating Limits"
		},
        MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "Indicates the highest temperature that this instrument can heat the media to.",
			Category -> "Operating Limits"
		},
		MinFlowRate->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter / Minute],
			Units -> Milliliter / Minute,
			Description -> "The minimum flow rates at which the sample and medium can be aspirated and dispensed.",
			Category -> "Operating Limits"
		},
		MaxFlowRate->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter / Minute],
			Units -> Milliliter / Minute,
			Description -> "The maximum flow rates at which the sample and medium can be aspirated and dispensed.",
			Category -> "Operating Limits"
		},
		MinSampleVolume->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The minimum volume of the sample that can be aspirated.",
			Category -> "Operating Limits"
		},
		MaxSampleVolume->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The maximum volume of the sample that can be aspirated.",
			Category -> "Operating Limits"
		},
		DeadVolume->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The total amount of liquid required to fill the plumbing between the dissolution vessel and the dispencing needle.",
			Category -> "Instrument Specifications"
		},
		VolumetricPrecision->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The precision of the volume aspiration and dispensing performed by the built-in syringe pump.",
			Category -> "Instrument Specifications"
		},
		TubingInnerDiameter->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The inner diameter of the tubing used to connect the dissolution vessel to the autosampler and internal plumbing of the instrument.",
			Category -> "Instrument Specifications"
		},
		TubingOuterDiameter->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The outer diameter of the tubing used to connect the dissolution vessel to the autosampler and internal plumbing of the instrument.",
			Category -> "Instrument Specifications"
		},
		TubingMaterial->{
			Format -> Single,
			Class -> Expression,
			Pattern :> PlasticP,
			Description -> "The material of the tubing used to connect the dissolution vessel to the autosampler and internal plumbing of the instrument.",
			Category -> "Instrument Specifications"
		},
		MaximumNumberOfAliquots -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Description -> "Indicates the maximum number of aliquots that can be taken from the dissolution medium during the experiment.",
			Category -> "Instrument Specifications"
		},
		DefaultMediumVessel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Vessel],
			Description -> "The default vessel used for the medium in the experiment.",
			Category -> "Instrument Specifications"
		},
		CompatibleShaftTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ShaftTypeP,
			Description -> "The types of shafts that can be used with this apparatus. These are instrument-specific and are not interchangeable.",
			Category -> "Model Information"
		}
    }
}];