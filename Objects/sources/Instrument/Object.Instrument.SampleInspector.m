(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, SampleInspector], {
	Description -> "An inspector that agitates and record videos to observe the moving particles in the sample.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> {
		Camera -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, Camera][SampleInspector],
			Description  -> "Fixed lense camera part of this sample inspector that is used to observe the vessels.",
			Category -> "Instrument Specifications"
		},
		Illumination  -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleInspectorIlluminationDirectionP,
			Description -> "The directions from which light sources can be provided relative to the sample positioned on the agitator.",
			Category -> "Instrument Specifications"
		},
		TopLight -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, Lamp][ConnectedInstrument],
			Description -> "Lamp that provides top illumination for this sample imager.",
			Category -> "Instrument Specifications"
		},
		FrontLight -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, Lamp][ConnectedInstrument],
			Description -> "Lamp that provides front illumination for this sample imager.",
			Category -> "Instrument Specifications"
		},
		BackLight -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, Lamp][ConnectedInstrument],
			Description -> "Lamp that provides back illumination for this sample imager.",
			Category -> "Instrument Specifications"
		},
		LightSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "The sensor that measures illumination for this sample inspector.",
			Category -> "Instrument Specifications"
		},
		IntegratedAgitator-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument,Vortex][IntegratedSampleInspector],Object[Instrument,Shaker][IntegratedSampleInspector]],
			Description -> "The instrument in the sample inspector that agitates the sample prior to video capture.",
			Category -> "Instrument Specifications"
		},
		Backdrops -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, Backdrop][SampleInspector],
			Description -> "A list of the monochromatic panels available for this model of Sample Inspector.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		TemperatureSensor->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Sensornet temperature probe used by this specific instrument to measure the temperature of the box.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		Refrigerator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, RefrigerationUnit][ConnectedInstrument],
			Description -> "Refrigeration unit that cools the interior of the inspection chamber of this specific instrument.",
			Category -> "Instrument Specifications"
		},
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The minimum temperature that the sample inspector can be set to maintain.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The maximum temperature that the sample inspector can be set to maintain.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinRotationRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinRotationRate]],
			Pattern :> GreaterP[0*RPM],
			Description -> "The minimum duration for which the sample inspector can agitate samples.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxRotationRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxRotationRate]],
			Pattern :> GreaterP[0*RPM],
			Description -> "The minimum duration for which the sample inspector can agitate samples.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinAgitationTime -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinAgitationTime]],
			Pattern :> GreaterP[0*Second],
			Description -> "The minimum duration for which the sample inspector can agitate samples.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxAgitationTime -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxAgitationTime]],
			Pattern :> GreaterP[0*Second],
			Description -> "The minimum duration for which the sample inspector can agitate samples.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		CompatibleVessels -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],CompatibleVessels]],
			Pattern :> _Link,
			Description -> "Vessels whose contents may be inspected by this specific instrument.",
			Category -> "Compatibility"
		}
	}
}];
