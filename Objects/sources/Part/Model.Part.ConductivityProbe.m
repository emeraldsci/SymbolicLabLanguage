(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, ConductivityProbe], {
	Description->"Model information for a conductivity probe used for electrical conductivity measurements of a solution.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(*--- Model Information---*)
		ProbeType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ConductivityProbeTypeP, 
			Description -> "The type of conductivity measurement principle.",
			Category -> "Model Information"
		},
		NumberOfElectrodes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0], 
			Description -> "The number of electrodes that the probe consists of.",
			Category -> "Model Information",
			Abstract -> True
		},
		(* --- Physical Properties --- *)
		ElectrodesMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP, 
			Description -> "The material that the sensor electrodes are composed of.",
			Category -> "Physical Properties"  (*TODO:voq to make sure ElectrodesMaterial and ShaftMaterial goes to the WettedMaterials *)
		},
		ShaftMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP, 
			Description -> "The material that the conductivity probe shaft is composed of.",
			Category -> "Physical Properties"
		},
		ShaftDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The outer diameter of the conductivity probe shaft.",
			Category -> "Physical Properties",
			Abstract -> True
		},	
		ShaftLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The length of the conductivity probe shaft.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		(* --- Operating Limits ---*)				
		MinConductivity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli Siemens /(Centimeter)],
			Units-> Milli Siemens /(Centimeter),
			Description -> "Minimum conductivity this probe can measure.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxConductivity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli Siemens /(Centimeter)],
			Units-> Milli Siemens /(Centimeter),
			Description -> "Maximum conductivity this probe can measure.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinSampleVolume->{
			Format->Single,
			Class -> Real,
			Pattern :>GreaterP[0*Milli*Liter],
			Units->Liter Milli,
			Description->"The minimum required sample volume needed for instrument measurement.",
			Category -> "Operating Limits"
		},
		MinDepth->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description->"The minimum required z distance that the probe needs to be submerged for the measurement.",
			Category -> "Operating Limits"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature the probe can perform a measurement at.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature the probe can perform a measurement at.",
			Category -> "Operating Limits"
		},
		SecondaryCalibration -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether to perform a two-points calibration.",
			Category -> "Model Information"
		}
	}
}];
