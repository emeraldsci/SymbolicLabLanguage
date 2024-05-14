(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument,EnvironmentalChamber], {
	Description->"A model of testing chamber capable of controlling temperature, humidity, and/or UV-Vis light exposure.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		EnvironmentalControls -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> EnvironmentalControlsP,
			Description -> "A list of environmental variables this model of testing chamber can control.",
			Category -> "Instrument Specifications"
		},
		
		LampType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> LampTypeP,
			Description -> "The type of lamp this model of testing chamber uses as a light source.",
			Category -> "Instrument Specifications"
		},
		
		InternalDimensions -> {
			Format -> Single,
			Class -> {Real,Real,Real},
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Units -> {Meter,Meter,Meter},
			Description -> "The size of the space inside this model of testing chamber.",
			Category -> "Dimensions & Positions",
			Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
		},
		
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature this model of testing chamber can maintain.",
			Category -> "Operating Limits"
		},
		
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature this model of testing chamber can maintain.",
			Category -> "Operating Limits"
		},
		
		MinHumidity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0*Percent, 100*Percent],
			Units -> Percent,
			Description -> "Minimum relative humidity this model of testing chamber can maintain.",
			Category -> "Operating Limits"
		},
		
		MaxHumidity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0*Percent, 100*Percent],
			Units -> Percent,
			Description -> "Maximum relative humidity this model of testing chamber can maintain.",
			Category -> "Operating Limits"
		},
		
		MinUVLightIntensity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Watt)/Meter^2],
			Units -> Watt/Meter^2,
			Description -> "Minimum UV light intensity this model of testing chamber can maintain.",
			Category -> "Operating Limits"
		},
		
		MaxUVLightIntensity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Watt)/Meter^2],
			Units -> Watt/Meter^2,
			Description -> "Maximum UV light intensity this model of testing chamber can maintain.",
			Category -> "Operating Limits"
		},	
		
		MinVisibleLightIntensity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Lumen)/Meter^2],
			Units -> Lumen/Meter^2,
			Description -> "Minimum visible light intensity this model of testing chamber can maintain.",
			Category -> "Operating Limits"
		},
		
		MaxVisibleLightIntensity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Lumen)/Meter^2],
			Units -> Lumen/Meter^2,
			Description -> "Maximum visible light intensity this model of testing chamber can maintain.",
			Category -> "Operating Limits"
		}
		
	}
}];
