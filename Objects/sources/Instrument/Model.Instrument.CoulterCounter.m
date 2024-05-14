(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument,CoulterCounter],{
	Description->"Model of a particle analyzer instrument that can count and size particles in a sample by suspending them in a conductive electrolyte solution, pumping them through an aperture, and measuring the corresponding electrical resistance change caused by particles in place of the ions passing through the aperture.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(*------------------------------Instrument Specifications------------------------------*)
		ElectrodesMaterial->{
			Format->Single,
			Class->{Expression,Expression},
			Pattern:>{MaterialP,MaterialP},
			Headers->{"Cathode Material","Anode Material"},
			Description->"The material of which the electrodes that are put inside and outside the aperture tube are made. These electrodes are submerged in the measurement sample in order to form a close circuit to measure the momentary electrical resistance change per particle passage.",
			Category->"Instrument Specifications"
		},
		(*------------------------------Compatibility------------------------------*)
		(* does not need compatible fields, fill Positions - footprint field - fill footprint for Model.Container.Vessel of ST beakers and accuvettes + Part.ApertureTube *)
		(*------------------------------Operating Limit------------------------------*)
		(* this field should not exist in instrument object *)
		(*MaxSampleConcentration->{
			Format->Single,
			Class->VariableUnit,
			Pattern:>Alternatives[
				GreaterP[0 Particle/Milliliter],
				GreaterP[0 EmeraldCell/Milliliter]
			],
			Units->None,
			Description->"The maximum particle or cell concentration the instrument is capable of counting and sizing with high accuracy. Above this threshold, coincident particle passage effect (multiple particles passing through the aperture of the ApertureTube at approximately the same time to be registered as one larger particle) cannot be fully corrected by automated algorithm, resulting in a less accurate particle count and size distribution. Interpretation from data generated this way is not recommended and should be examined with extra caution.",
			Category->"Operating Limits"
		},*)
		MinParticleSize->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Micrometer],
			Units->Micrometer,
			Category->"Operating Limits",
			Description->"The minimum particle size the instrument can detect. Additional constraints can be placed by the connected aperture tube.",
			Abstract->True
		},
		MaxParticleSize->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Micrometer],
			Units->Micrometer,
			Category->"Operating Limits",
			Description->"The maximum particle size the instrument can detect. Additional constraints can be placed by the connected aperture tube.",
			Abstract->True
		},
		MinOperatingTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"The minimum temperature at which the coulter counter is capable of producing a reliable electrical resistance measurement.",
			Category->"Operating Limits"
		},
		MaxOperatingTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"The maximum temperature at which the coulter counter is capable of producing a reliable electrical resistance measurement.",
			Category->"Operating Limits"
		},
		MinHumidity->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Percent],
			Units->Percent,
			Description->"The minimum relative humidity at which the coulter counter is capable of producing a reliable electrical resistance measurement.",
			Category->"Operating Limits"
		},
		MaxHumidity->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Percent],
			Units->Percent,
			Description->"The maximum relative humidity at which the coulter counter is capable of producing a reliable electrical resistance measurement.",
			Category->"Operating Limits"
		},
		MinMixRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 RPM],
			Units->RPM,
			Description->"The minimum rotation speed that the integrated stirrer can operate during electrical resistance measurement.",
			Category->"Operating Limits"
		},
		MaxMixRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 RPM],
			Units->RPM,
			Description->"The maximum rotation speed that the integrated stirrer can operate during electrical resistance measurement.",
			Category->"Operating Limits"
		},
		MinCurrent->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Microampere],
			Units->Microampere,
			Description->"The minimum value of the constant current that the coulter counter can apply to the aperture tube during electrical resistance measurement. This is done to register the momentary electrical resistance change per particle passage as voltage pulse to the electronics.",
			Category->"Operating Limits"
		},
		MaxCurrent->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Microampere],
			Units->Microampere,
			Description->"The maximum value of the constant current that the coulter counter can apply to the aperture tube during electrical resistance measurement. This is done to register the momentary electrical resistance change per particle passage as voltage pulse to the electronics.",
			Category->"Operating Limits"
		},
		MinGain->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0],
			Description->"The minimum amplification factor that the coulter counter can apply to the collected pulse voltage.",
			Category->"Operating Limits"
		},
		MaxGain->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0],
			Description->"The maximum amplification factor that the coulter counter can apply to the collected pulse voltage.",
			Category->"Operating Limits"
		}
	}
}
];

