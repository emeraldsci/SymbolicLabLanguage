(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, Reactor], {
	Description->"The model of an instrument used to conduct and monitor small batch chemical reactions.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		(* -- General -- *)
		(*TODO: sort out fields update descriptions to match what the fields are*)
		ReactorType ->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ReactorTypeP (*Flow, Electrochemical, Microwave, Batch, SolidPhase, Robotic, Photochemical, and others to add*),
			Description -> "The classification of the reactor based on energy input or the types of reaction that it can conduct.",
			Category -> "General"
		},
		ReactorConditions ->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ReactorConditionsP (* HighPressure, Cryogenic, Digestion *),
			Description -> "The types of conditions that this reactor can generate.",
			Category -> "General"
		},


		(* -- Operating Limits -- *)

		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The highest temperature to which a reaction vessel can be heated without triggering a safety shutoff.",
			Category -> "Operating Limits"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The lowest temperature at which the reaction vessel can be incubated.",
			Category -> "Operating Limits"
		},
		MaxPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 PSI],
			Units -> PSI,
			Description -> "The highest pressure to which a reaction vessel without triggering a safety shutoff.",
			Category -> "Operating Limits"
		},
		MaxReactionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern:>GreaterP[0 Microliter],
			Units -> Milliliter,
			Description -> "The maximum size reaction vessel that this instrument can hold.",
			Category -> "Operating Limits"
		},
		MinReactionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern:>GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The minimum allowable reaction vessel in the smallest compatible reaction vessel.",
			Category -> "Operating Limits"
		},

		(* -- unique operations -- *)

		OverpressureVent -> {
			Format -> Single,
			Class -> Expression,
			Pattern:>BooleanP,
			Description -> "Indicates if the instrument is capable of automatically depressurizing when the reaction vial meets or exceeds the MaxPressure.",
			Category -> "Instrument Specifications"
		},
		IntermediateVent -> {
			Format -> Single,
			Class -> Expression,
			Pattern:>BooleanP,
			Description -> "Indicates if the model instrument is capable of automatically venting when a user specified pressure is reached.",
			Category -> "Instrument Specifications"
		},

		Aliquotting -> {
			Format -> Single,
			Class -> Expression,
			Pattern:>BooleanP,
			Description -> "Indicates if aliquots of the reaction mixture can be removed during the course of the reaction without physically removing the reaction vessel from the instrument.",
			Category -> "Reaction Monitoring"
		},
		(*TODO: should probably make a pattern for this, think of others and ask steven*)
		ReactorProbes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern:>Alternatives[Temperature, Pressure, Image, Video, IR, Raman, UVVis],
			Description -> "The types of data that the instrument is capable of recording during a reaction.",
			Category -> "Reaction Monitoring"
		},
		(*TODO: Look at experiment Mix - maybe is MixTypeP. Move general fields *)
		StirringType -> {
			Format -> Single,
			Class -> Expression,
			Pattern:>Alternatives[StirBar, Overhead, Agitation, Vortex],
			Description -> "The mechanism by which this reactor mixes the contents of the reaction vessel.",
			Category -> "General"
		}
		
	}
}];
