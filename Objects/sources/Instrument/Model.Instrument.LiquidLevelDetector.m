(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, LiquidLevelDetector], {
	Description->"The model for an instrument performing sonic based liquid level detection in multi-well plates.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		StageDistance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "Mean distance from the reading head to the stage.",
			Category -> "Instrument Specifications"
		},
		PedestalDistance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "Mean distance from the reading head to the shallow well plate pedestal.",
			Category -> "Instrument Specifications"
		},
		MinDistance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "The minimum liquid level distance that can be measured by this model of instrument.",
			Category -> "Operating Limits"
		},
		MaxDistance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "The maximum liquid level distance that can be measured by this model of instrument.",
			Category -> "Operating Limits"
		},
		CompatiblePlates -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "Plates that can be placed on the measurement tray of this model of instrument.",
			Category -> "Compatibility"
		},
		CompatibleVessels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "Vessels for which liquid level can be measured by this model of instrument.",
			Category -> "Compatibility"
		},
		VesselAdaptors->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Container,Rack],
			Description->"For each member of CompatibleVessels, the adaptor needed for holding the vessel during measurements taken with this instrument.",
			IndexMatching->CompatibleVessels,
			Category->"Instrument Specifications"
		},
		ContainerAdaptors->{
			Format -> Multiple,
			Class -> {
				Container -> Link,
				Adaptor -> Link
			},
			Pattern :> {
				Container -> _Link,
				Adaptor -> _Link
			},
			Relation -> {
				Container -> Model[Container],
				Adaptor -> Model[Container,Rack]
			},
			Headers -> {
				Container -> "Container",
				Adaptor -> "Adaptor for Container"
			},
			Description -> "The adaptors required to make containers measurable by this instrument model.",
			Category -> "Instrument Specifications"
		},
		SensorArmHeights->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0Centimeter],
			Units->Centimeter,
			Description->"For each member of CompatibleVessels, the height the detector must be set to before measuring liquid levels in the vessel.",
			IndexMatching->CompatibleVessels,
			Category->"Instrument Specifications"
		},
		PlateLayoutFileNames->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"For each member of CompatiblePlates, the plate layout file to load on the instrument's software prior to measuring liquid level in the plate.",
			IndexMatching->CompatiblePlates,
			Category->"Instrument Specifications"
		},
		MinSensorArmHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Centi*Meter],
			Units -> Meter Milli,
			Description -> "The minimum height that the sensor arm can physically be set to.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		MaxSensorArmHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Centi*Meter],
			Units -> Meter Milli,
			Description -> "The maximum height that the sensor arm can physically be set to.",
			Category -> "Sensor Information"
		}
	}
}];