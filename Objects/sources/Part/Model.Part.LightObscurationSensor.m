(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, LightObscurationSensor], {
	Description->"Model information for a light obscuration sensor that measures the reduction in light intensity and processes the signal to determine particle size and count.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* --- Physical Properties --- *)
		FlowCellPathLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micrometer],
			Units -> Micrometer,
			Description -> "The distance that the laser traverses through the sample before reaching the detector.",
			Category -> "Physical Properties"
		},
		FlowCellVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milliliter],
			Units -> Milliliter,
			Description -> "The volume of the light obscuration sensor's flow cell.",
			Category -> "Physical Properties"
		},
		FlowCellDimensions -> {
			Format -> Single,
			Class -> {Real, Real, Real},
			Pattern :> {GreaterEqualP[0*Micrometer], GreaterEqualP[0*Micrometer],GreaterEqualP[0*Micrometer]},
			Units -> {Micrometer, Micrometer,Micrometer},
			Headers -> {"Flow Cell Width", "Flow Cell Height", "Flow Cell Depth"},
			Description -> "Dimensions of the flow cell for this model of sensor.",
			Category -> "Physical Properties"
		},

		(* --- Operating Limits ---*)
		MinParticleSize -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micrometer],
			Units -> Micrometer,
			Description -> "Minimum particle size the instrument can detect. Additional constraints can be placed by the light obscuration sensor.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxParticleSize -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micrometer],
			Units -> Micrometer,
			Description -> "Maximum particle size the instrument can detect. Additional constraints can be placed by the light obscuration sensor.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinSampleConcentration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Particle/Milliliter], (*TODO add Particle to Units same as Cell*)
			Units -> Micrometer,
			Description -> "Minimum particle concentration the instrument is capable of detecting. Additional constraints can be placed by the light obscuration sensor.",
			Category -> "Operating Limits"
		},
		MaxSampleConcentration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Particle/Milliliter],
			Units -> Micrometer,
			Description -> "Maximum particle concentration the instrument is capable of detecting. Additional constraints can be placed by the light obscuration sensor.",
			Category -> "Operating Limits"
		},
		MinSampleTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature instrument can incubate sample.",
			Category -> "Operating Limits"
		},
		MaxSampleTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature instrument can incubate sample.",
			Category -> "Operating Limits"
		}
	}
}];
