(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, SampleInspector], {
	Description->"The model for an inspector that agitates and record videos to observe the moving particles in the sample.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Camera -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part],
			Description -> "A list of the cameras available for this model of the instrument.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Illumination -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleInspectorIlluminationDirectionP,
			Description -> "The directions from which light sources can be provided relative to the sample positioned on the agitator in this model of the instrument.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		LightSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sensor],
			Description -> "A list of sensor available for measuring the intensity of internal illumination for this model of the instrument.",
			Category -> "Instrument Specifications"
		},
		IntegratedAgitator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument],
			Description -> "A list of the sample agitators available for this model of the instrument.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Backdrops -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part],
			Description -> "A list of the monochromatic panels available for this model of the instrument.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		TemperatureSensor->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sensor],
			Description -> "Sensornet temperature probe available for measuring the internal temperature of this model of the instrument.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		Refrigerator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part, RefrigerationUnit],
			Description -> "Refrigeration unit that cools the interior of the inspection chamber of this model of the instrument.",
			Category -> "Instrument Specifications"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature that may be achieved by this model of the instrument.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature that may be achieved by this model of the instrument.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinRotationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Revolution)/Second],
			Units -> Revolution/Second,
			Description -> "Minimum speed at which the agitator in this model of the instrument can spin samples.",
			Category -> "Operating Limits"
		},
		MaxRotationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Revolution)/Second],
			Units -> Revolution/Second,
			Description -> "Maximum speed at which the agitator in this model of the instrument can spin samples.",
			Category -> "Operating Limits"
		},
		MinAgitationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Second)],
			Units -> Second,
			Description -> "Minimum duration at which the agitator in this model of the instrument can spin samples.",
			Category -> "Operating Limits"
		},
		MaxAgitationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Second)],
			Units -> Second,
			Description -> "Maximum duration at which the agitator in this model of the instrument can spin samples.",
			Category -> "Operating Limits"
		},
		CompatibleVessels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "Vessels whose contents may be inspected by this model of the instrument.",
			Category -> "Compatibility"
		}
	}
}];
