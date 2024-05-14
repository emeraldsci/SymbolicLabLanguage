(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item,SPMEFiber], {(* https://www.palsystem.com/fileadmin/public/docs/Various/Smart_SPME_Fiber_Leaflet.pdf *)
	Description->"A model of a solid phase microextraction (SPME) fiber used to adsorb analytes prior to injection into a gas chromatograph.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		FiberLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Description -> "The length of the SPME fiber.",
			Units -> Milli*Meter,
			Category -> "Physical Properties"
		},
		FiberThickness -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Description -> "The diameter of the SPME fiber.",
			Units -> Milli*Meter,
			Category -> "Physical Properties"
		},
		FiberMaterial -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (PDMS|Polyacrylate|CarbonWR|DVB),
			Description -> "The material from which the active phase of the SPME fiber has been made.",
			Category -> "Physical Properties"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The minimum temperature at which this SPME fiber is suggested to be used.",
			Units -> Celsius,
			Category -> "Physical Properties"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The maximum temperature at which this SPME fiber may be used before it begins to degrade.",
			Units -> Celsius,
			Category -> "Physical Properties"
		},
		CompatibleRinsingSolvents -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (Methanol|Ethanol|Isopropanol|AliphaticHydrocarbons),
			Description -> "The solvents that have been approved by the fiber manufacturer to be used for rinsing the fiber.",
			Category -> "Physical Properties"
		},
		IncompatibleSolvents -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (Methanol|Ethanol|Isopropanol|AliphaticHydrocarbons),
			Description -> "Any solvents that are incompatible with the SPME fiber.",
			Category -> "Physical Properties"
		}
	}
}];
