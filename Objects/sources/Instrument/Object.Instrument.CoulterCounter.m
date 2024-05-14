(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument,CoulterCounter],{
	Description->"A particle analyzer instrument that can count and size particles in a sample by suspending them in a conductive electrolyte solution, pumping them through an aperture, and measuring the corresponding electrical resistance change caused by particles in place of the ions passing through the aperture.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(*------------------------------Instrument Specifications------------------------------*)
		ElectrodesMaterial->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],ElectrodesMaterial]],
			Pattern:>{MaterialP,MaterialP},
			Description->"The material of which the electrodes that are put inside and outside the aperture tube are made. These electrodes are submerged in the measurement sample in order to form a close circuit to measure the momentary electrical resistance change per particle passage.",
			Category->"Instrument Specifications"
		},
		ApertureTube->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Part,ApertureTube],
			Description->"The aperture tube that is currently installed in the sample compartment of the coulter counter. Aperture tube itself is a glass tube with a small aperture near the bottom through which particles are pumped to perturb the electrical resistance for accurate sizing and counting.",
			Category->"Instrument Specifications"
		},
		ElectrolyteSolutionContainer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container],
			Description->"The container connected to the coulter counter that holds a reservoir of clean electrolyte solution. The electrolyte solution is pumped to the MeasurementContainer to flush the aperture tube between sample runs to remove particles that may remain trapped in the bottom of the aperture tube.",
			(* TODO: new container object for electrolyte jar + waster jar *)
			Category->"Instrument Specifications"
		},
		ParticleTrapContainer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container],
			Description->"The container connected to the coulter counter that is used to keep large particles from entering the internal plumbing system to avoid damages to valves and integrated diaphragm metering pump.",
			(* TODO: new container object for particle trap *)
			Category->"Instrument Specifications"
		},
		InternalWasteContainer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container],
			Description->"The container connected to the coulter counter that is used to collect the liquid waste flow from MeasurementContainer or the chamber of integrated diaphragm metering pump during electrical resistance measurement.",
			(* TODO: new container object for internal waste container *)
			Category->"Instrument Specifications"
		},
		(*------------------------------Operating Limit------------------------------*)
		MinParticleSize->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinParticleSize]],
			Pattern:>GreaterP[0 Micrometer],
			Description->"The minimum particle size the instrument can detect. Additional constraints can be placed by the connected aperture tube.",
			Category->"Operating Limits"
		},
		MaxParticleSize->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxParticleSize]],
			Pattern:>GreaterP[0 Micrometer],
			Description->"The maximum particle size the instrument can detect. Additional constraints can be placed by the connected aperture tube.",
			Category->"Operating Limits"
		},
		MinOperatingTemperature->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinOperatingTemperature]],
			Pattern:>GreaterEqualP[0 Kelvin],
			Description->"The minimum temperature at which the coulter counter is capable of producing a reliable electrical resistance measurement.",
			Category->"Operating Limits"
		},
		MaxOperatingTemperature->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxOperatingTemperature]],
			Pattern:>GreaterEqualP[0 Kelvin],
			Description->"The maximum temperature at which the coulter counter is capable of producing a reliable electrical resistance measurement.",
			Category->"Operating Limits"
		},
		MinHumidity->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinHumidity]],
			Pattern:>GreaterEqualP[0 Percent],
			Description->"The minimum relative humidity at which the coulter counter is capable of producing a reliable electrical resistance measurement.",
			Category->"Operating Limits"
		},
		MaxHumidity->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxHumidity]],
			Pattern:>GreaterEqualP[0 Percent],
			Description->"The maximum relative humidity at which the coulter counter is capable of producing a reliable electrical resistance measurement.",
			Category->"Operating Limits"
		},
		MinMixRate->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinMixRate]],
			Pattern:>GreaterP[0 RPM],
			Description->"The minimum rotation speed that the integrated stirrer can operate during electrical resistance measurement.",
			Category->"Operating Limits"
		},
		MaxMixRate->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxMixRate]],
			Pattern:>GreaterP[0 RPM],
			Description->"The maximum rotation speed that the integrated stirrer can operate during electrical resistance measurement.",
			Category->"Operating Limits"
		},
		MinCurrent->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinCurrent]],
			Pattern:>GreaterP[0 Microampere],
			Description->"The minimum value of the constant current that the coulter counter can apply to the aperture tube during electrical resistance measurement. This is done to register the momentary electrical resistance change per particle passage as voltage pulse to the electronics.",
			Category->"Operating Limits"
		},
		MaxCurrent->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxCurrent]],
			Pattern:>GreaterP[0 Microampere],
			Description->"The maximum value of the constant current that the coulter counter can apply to the aperture tube during electrical resistance measurement. This is done to register the momentary electrical resistance change per particle passage as voltage pulse to the electronics.",
			Category->"Operating Limits"
		},
		MinGain->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinGain]],
			Pattern:>GreaterP[0],
			Description->"The minimum amplification factor that the coulter counter can apply to the collected pulse voltage.",
			Category->"Operating Limits"
		},
		MaxGain->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxGain]],
			Pattern:>GreaterP[0],
			Description->"The maximum amplification factor that the coulter counter can apply to the collected pulse voltage.",
			Category->"Operating Limits"
		}
	}
}
];

