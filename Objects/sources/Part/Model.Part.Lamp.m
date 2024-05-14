

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part, Lamp], {
	Description->"A model for an electrical device producing ultraviolet, infrared, or other light.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		LampType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> LampTypeP,
			Description -> "The construction type of the lamp, such as filament material or the inert gas in the bulb.",
			Category -> "Optical Information",
			Abstract -> True
		},
		LampOperationMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> LampOperationModeP,
			Description -> "The method by which the light is produced by the lamp.",
			Category -> "Optical Information",
			Abstract -> True
		},
		WindowMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> LampWindowMaterialP,
			Description -> "The material composition of the window material in which the filament is housed.",
			Category -> "Optical Information"
		},
		MaxLifeTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Hour],
			Units -> Hour,
			Description -> "The length of time that the lamp is assured to operate for and meet the specs of the manufacturer.",
			Category -> "Operating Limits"
		},
		MaxFlashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of flashes that the lamp is assured to generate as reported by the manufacturer specs.",
			Category -> "Operating Limits"
		},
		MinWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "Minimum wavelength of light emitted.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "Maximum wavelength of light emitted.",
			Category -> "Operating Limits",
			Abstract -> True
		}
	}
}];
