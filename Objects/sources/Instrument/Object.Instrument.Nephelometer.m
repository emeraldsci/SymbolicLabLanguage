(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, Nephelometer], {
	Description->"The model for an instrument used to measure the intensity of scattered light from sample solutions, producing turbidity data from well-plates.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		LightSource -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],LightSource]],
			Pattern :> ExcitationSourceP|LampTypeP,
			Description -> "The light sources available to probe the sample.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		LightSourceWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],LightSourceWavelength]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The wavelength at which the light source of the instrument emits light.",
			Category -> "Operating Limits"
		},
		Detector -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Detector]],
			Pattern :> OpticalDetectorP,
			Description -> "The type of detector available to measure the intensity of scattered light from the sample.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		SamplingPatterns -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],SamplingPatterns]],
			Pattern :> PlateReaderSamplingP,
			Description -> "Indicates the positions in the well the plate reader is capable of sampling from when taking readings.",
			Category -> "Instrument Specifications"
		},
		ScatterDirection -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ScatterDirection]],
			Pattern :> Alternatives[Forward,Backward,Side],
			Description -> "Indicates the direction or directions of scattered light that the nephelometer is able to detect light from.",
			Category -> "Instrument Specifications"
		},
		ScatterAngle -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ScatterAngle]],
			Pattern :> GreaterP[0*Degree],
			Description -> "Indicates the angle at which the Detector is located in relation to the source light if only one angle is available.",
			Category -> "Instrument Specifications"
		},
		UlbrichtSphere -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],UlbrichtSphere]],
			Pattern :> BooleanP,
			Description -> "Indicates if scattered light from the sample passes into a reflective sphere called an Ulbricht sphere that preserves the intensity of the light while dereferencing the directionality of the light.",
			Category -> "Instrument Specifications"
		},
		AvailableGases -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],AvailableGases]],
			Pattern :> Alternatives[CarbonDioxide,Oxygen],
			Description -> "The gases whose levels can be controlled in the atmosphere inside the plate reader.",
			Category -> "Instrument Specifications"
		},
		SecondaryWasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "An additional container associated with the instrument used to collect any liquid waste produced by the instrument during operation.",
			Category -> "Instrument Specifications"
		},




		UlbrichtSphereMinScatterAngle -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],UlbrichtSphereMinScatterAngle]],
			Pattern :> GreaterP[0*Degree],
			Description -> "If the nephelometer passes scattered light to an Ulbricht sphere, the minimum angle at which light enters the sphere, where 0 degrees is light transmitted in a straight line from the source through the sample to the detector.",
			Category -> "Operating Limits"
		},
		UlbrichtSphereMaxScatterAngle -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],UlbrichtSphereMaxScatterAngle]],
			Pattern :> GreaterP[0*Degree],
			Description -> "If the nephelometer passes scattered light to an Ulbricht sphere, the maximum angle at which light enters the sphere, where 0 degrees is light transmitted in a straight line from the source through the sample to the detector.",
			Category -> "Operating Limits"
		},
		MinScatterAngle -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinScatterAngle]],
			Pattern :> GreaterP[0*Degree],
			Description -> "If the nephelometer is able to detect light from multiple angles, the minimum angle at which it can measure scattered light, where 0 degrees is light transmitted in a straight line from the source through the sample to the detector.",
			Category -> "Operating Limits"
		},
		MaxScatterAngle -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxScatterAngle]],
			Pattern :> GreaterP[0*Degree],
			Description -> "If the nephelometer is able to detect light from multiple angles, the maximum angle at which it can measure scattered light, where 0 degrees is light transmitted in a straight line from the source through the sample to the detector.",
			Category -> "Operating Limits"
		},
		MinOxygenLevel -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinOxygenLevel]],
			Pattern :> GreaterP[0*Percent],
			Description -> "Minimum level of oxygen in the atmosphere inside the plate reader that can be maintained.",
			Category -> "Operating Limits"
		},
		MaxOxygenLevel -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxOxygenLevel]],
			Pattern :> GreaterP[0*Percent],
			Description -> "Maximum level of oxygen in the atmosphere inside the plate reader that can be maintained.",
			Category -> "Operating Limits"
		},
		MinCarbonDioxideLevel -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinCarbonDioxideLevel]],
			Pattern :> GreaterP[0*Percent],
			Description -> "Minimum level of carbon dioxide in the atmosphere inside the plate reader that can be maintained.",
			Category -> "Operating Limits"
		},
		MaxCarbonDioxideLevel -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxCarbonDioxideLevel]],
			Pattern :> GreaterP[0*Percent],
			Description -> "Maximum level of carbon dioxide in the atmosphere inside the plate reader that can be maintained.",
			Category -> "Operating Limits"
		},
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Minimum temperature at which the plate reader can incubate.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Maximum temperature at which the plate reader can incubate.",
			Category -> "Operating Limits"
		},
		InjectorVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],InjectorVolume]],
			Pattern :> GreaterEqualP[0*Liter],
			Description -> "The volume of the injector used to add liquid to the plate.",
			Category -> "Operating Limits"
		},
		InjectorDeadVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],InjectorDeadVolume]],
			Pattern :> GreaterEqualP[0*Liter],
			Description -> "The volume of the tube between the injector syringe and the injector nozzle. This volume is required to fill the injector tube and cannot be injected into wells.",
			Category -> "Operating Limits"
		},
		MaxDispensingSpeed -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxDispensingSpeed]],
			Pattern :> GreaterP[(0*(Liter*Milli))/Minute],
			Description -> "Maximum speed reagent can be delivered to the read wells.",
			Category -> "Operating Limits"
		},


		CompatiblePlates -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],CompatiblePlates]],
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "Plates that can be placed on the measurement tray of this model of instrument.",
			Category -> "Compatibility"
		},

		IntegratedLiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, LiquidHandler][IntegratedNephelometer],
			Description -> "The liquid handler that is connected to this nephelometer.",
			Category -> "Integrations"
		}
	}
}];
