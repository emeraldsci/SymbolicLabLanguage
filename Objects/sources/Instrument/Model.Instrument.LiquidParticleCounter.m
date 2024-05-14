(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[
	Model[Instrument, LiquidParticleCounter],
	{
		Description->"A device for high accuracy count of liquid particles (HIAC).",
		CreatePrivileges->None,
		Cache->Session,
		Fields -> {
			(* --- Instrument Specifications ---*)
			DefaultFlushSteps -> {
				Format -> Multiple,
				Class -> {
					AqueousWashSolution -> Link,
					AqueousWashSolutionTemperature -> Real,
					NumberOfAqueousWashes -> Integer,
					AqueousWashWaitTimes -> Real,
					SurfactantWashSolution -> Link,
					SurfactantWashSolutionTemperature -> Real,
					NumberOfSurfactantWashes -> Integer,
					SurfactantWashWaitTimes -> Real,
					AlcoholWashSolution -> Link,
					AlcoholWashSolutionTemperature -> Real,
					NumberOfAlcoholWashes -> Integer,
					AlcoholWashWaitTimes -> Real
				},
				Pattern :> {
					AqueousWashSolution -> _Link,
					AqueousWashSolutionTemperature -> GreaterP[0 Kelvin],
					NumberOfAqueousWashes -> GreaterP[0,1],
					AqueousWashWaitTimes -> GreaterP[0*Minute],
					SurfactantWashSolution -> _Link,
					SurfactantWashSolutionTemperature -> GreaterP[0 Kelvin],
					NumberOfSurfactantWashes -> GreaterP[0,1],
					SurfactantWashWaitTimes -> GreaterP[0*Minute],
					AlcoholWashSolution -> _Link,
					AlcoholWashSolutionTemperature -> GreaterP[0 Kelvin],
					NumberOfAlcoholWashes -> GreaterP[0,1],
					AlcoholWashWaitTimes -> GreaterP[0*Minute]
				},
				Units -> {
					AqueousWashSolution -> None,
					AqueousWashSolutionTemperature -> Celsius,
					NumberOfAqueousWashes -> None,
					AqueousWashWaitTimes -> Minute,
					SurfactantWashSolution -> None,
					SurfactantWashSolutionTemperature -> Celsius,
					NumberOfSurfactantWashes -> None,
					SurfactantWashWaitTimes -> Minute,
					AlcoholWashSolution -> None,
					AlcoholWashSolutionTemperature -> Celsius,
					NumberOfAlcoholWashes -> None,
					AlcoholWashWaitTimes -> Minute
				},
				Relation -> {
					AqueousWashSolution -> Alternatives[Model[Sample],Object[Sample]],
					AqueousWashSolutionTemperature -> Null,
					NumberOfAqueousWashes -> Null,
					AqueousWashWaitTimes -> Null,
					SurfactantWashSolution -> Alternatives[Model[Sample],Object[Sample]],
					SurfactantWashSolutionTemperature -> Null,
					NumberOfSurfactantWashes -> Null,
					SurfactantWashWaitTimes -> Null,
					AlcoholWashSolution -> Alternatives[Model[Sample],Object[Sample]],
					AlcoholWashSolutionTemperature -> Null,
					NumberOfAlcoholWashes -> Null,
					AlcoholWashWaitTimes -> Null
				},
				Description -> "Steps describing how the wash solutions pumped through the instrument's flow path used to wash any residual samples out the instrument.",
				Category -> "Instrument Specifications"
			},
			PreRinseVolume -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0 * Liter],
				Units -> Liter Milli,
				Description -> "The volume of the sample used to flow into the syringe tubing to rinse out the lines with the sample before beginning the reading.",
				Category -> "Instrument Specifications"
			},

			(* --- Operating Limits --- *)
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
				Category -> "Operating Limits",
				Abstract -> True
			},
			MaxSampleConcentration -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0*Particle/Milliliter],
				Units -> Micrometer,
				Description -> "Maximum particle concentration the instrument is capable of detecting. Additional constraints can be placed by the light obscuration sensor.",
				Category -> "Operating Limits",
				Abstract -> True
			},
			MinSampleTemperature -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0*Kelvin],
				Units -> Celsius,
				Description -> "Minimum temperature instrument can incubate sample.",
				Category -> "Operating Limits",
				Abstract -> True
			},
			MaxSampleTemperature -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0*Kelvin],
				Units -> Celsius,
				Description -> "Maximum temperature instrument can incubate sample.",
				Category -> "Operating Limits",
				Abstract -> True
			},
			MinSampleVolume -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0*Milliliter],
				Units -> Milliliter,
				Description -> "Minimum sample volume including dead volume of sample required to provide the instrument with enough of volume to measure particle count.",
				Category -> "Operating Limits",
				Abstract -> True
			},
				(*-------------------*)
			MaxSyringeVolume -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0*Milliliter],
				Units -> Milliliter,
				Description -> "Maximum capacity of the syringe pump used to dispense the fluid.",
				Category -> "Operating Limits",
				Abstract -> True
			},
			MinSyringeFlowRate -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0*Milliliter/ Minute],
				Units -> Milliliter/ Minute,
				Description -> "The minimum flow rate of syringe when aspirating or dispensing.",
				Category -> "Operating Limits"
			},
			MaxSyringeFlowRate -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0*Milliliter/ Minute],
				Units -> Milliliter/ Minute,
				Description -> "The maximum flow rate of syringe when aspirating or dispensing.",
				Category -> "Operating Limits"
			},
			MinStirRate -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0*RPM],
				Units -> RPM,
				Description -> "The slowest rotational speed at which the integrated stir plate can operate.",
				Category -> "Operating Limits"
			},
			MaxStirRate -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0*RPM],
				Units -> RPM,
				Description -> "The fastest rotational speed at which the integrated stir plate can operate.",
				Category -> "Operating Limits"
			},
			SampleContainerClearance-> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0*Millimeter],
				Units -> Millimeter,
				Description -> "The maximum container height used to fit the sample container into the instrument.",
				Category -> "Operating Limits"
			},
			ProbeLength -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0*Centimeter],
				Units -> Centimeter,
				Description -> "Length of the probe.",
				Category -> "Operating Limits",
				Abstract -> True
			},
			MaxSamplingHeight -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0*Centimeter],
				Units -> Centimeter,
				Description -> "The max height of probe that can collect the sample, this is calculated as the bottom.",
				Category -> "Operating Limits",
				Abstract -> True
			}
		}
	}
];
