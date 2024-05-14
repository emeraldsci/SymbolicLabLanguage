(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, Nephelometer], {
	Description->"The model for an instrument used to measure the intensity of scattered light from sample solutions, producing turbidity data from well-plates.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		LightSource -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ExcitationSourceP|LampTypeP,
			Description -> "The light sources available to probe the sample.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		LightSourceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The wavelength at which the light source of the instrument emits light.",
			Category -> "Instrument Specifications"
		},
		Detector -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> OpticalDetectorP,
			Description -> "The type of detector available to measure the intensity of scattered light from the sample.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		SamplingPatterns -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> PlateReaderSamplingP,
			Description -> "Indicates the positions in the well the plate reader is capable of sampling from when taking readings.",
			Category -> "Instrument Specifications"
		},
		ScatterDirection -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Forward,Backward,Side],
			Description -> "Indicates the direction or directions of scattered light that the nephelometer is able to detect light from.",
			Category -> "Instrument Specifications"
		},
		ScatterAngle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Degree],
			Units -> Degree,
			Description -> "Indicates the angle at which the Detector is located in relation to the source light if only one angle is available.",
			Category -> "Instrument Specifications"
		},
		UlbrichtSphere -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if scattered light from the sample passes into a reflective sphere called an Ulbricht sphere that preserves the intensity of the light while dereferencing the directionality of the light.",
			Category -> "Instrument Specifications"
		},
		AvailableGases -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[CarbonDioxide,Oxygen],
			Description -> "The gases whose levels can be controlled in the atmosphere inside the plate reader.",
			Category -> "Instrument Specifications"
		},



		UlbrichtSphereMinScatterAngle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Degree],
			Units -> Degree,
			Description -> "If the nephelometer passes scattered light to an Ulbricht sphere, the minimum angle at which light enters the sphere, where 0 degrees is light transmitted in a straight line from the source through the sample to the detector.",
			Category -> "Operating Limits"
		},
		UlbrichtSphereMaxScatterAngle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Degree],
			Units -> Degree,
			Description -> "If the nephelometer passes scattered light to an Ulbricht sphere, the maximum angle at which light enters the sphere, where 0 degrees is light transmitted in a straight line from the source through the sample to the detector.",
			Category -> "Operating Limits"
		},
		MinScatterAngle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Degree],
			Units -> Degree,
			Description -> "If the nephelometer is able to detect light from multiple angles, the minimum angle at which it can measure scattered light, where 0 degrees is light transmitted in a straight line from the source through the sample to the detector.",
			Category -> "Operating Limits"
		},
		MaxScatterAngle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Degree],
			Units -> Degree,
			Description -> "If the nephelometer is able to detect light from multiple angles, the maximum angle at which it can measure scattered light, where 0 degrees is light transmitted in a straight line from the source through the sample to the detector.",
			Category -> "Operating Limits"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature at which the plate reader can incubate.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature at which the plate reader can incubate.",
			Category -> "Operating Limits"
		},
		MinOxygenLevel -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Percent],
			Units -> Percent,
			Description -> "Minimum level of oxygen in the atmosphere inside the plate reader that can be maintained.",
			Category -> "Operating Limits"
		},
		MaxOxygenLevel -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Percent],
			Units -> Percent,
			Description -> "Maximum level of oxygen in the atmosphere inside the plate reader that can be maintained.",
			Category -> "Operating Limits"
		},
		MinCarbonDioxideLevel -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Percent],
			Units -> Percent,
			Description -> "Minimum level of carbon dioxide in the atmosphere inside the plate reader that can be maintained.",
			Category -> "Operating Limits"
		},
		MaxCarbonDioxideLevel -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Percent],
			Units -> Percent,
			Description -> "Maximum level of carbon dioxide in the atmosphere inside the plate reader that can be maintained.",
			Category -> "Operating Limits"
		},
		InjectorVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the injector used to add liquid to the plate.",
			Category -> "Operating Limits"
		},
		InjectorDeadVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the tube between the injector syringe and the injector nozzle. This volume is required to fill the injector tube and cannot be injected into wells.",
			Category -> "Operating Limits"
		},
		MaxDispensingSpeed -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*(Liter*Milli))/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "Maximum speed reagent can be delivered to the read wells.",
			Category -> "Operating Limits"
		},


		CompatiblePlates -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "Plates that can be placed on the measurement tray of this model of instrument.",
			Category -> "Compatibility"
		}

	}
}];
