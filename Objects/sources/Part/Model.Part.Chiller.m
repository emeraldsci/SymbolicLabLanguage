(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, Chiller], {
	Description->"Model information for a part designed to chill an instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,Diffractometer][Chiller],
				Model[Instrument, MassSpectrometer][Chiller],
				Model[Instrument,CrystalIncubator][Chiller],
				Model[Instrument,LiquidHandler,AcousticLiquidHandler][Chiller]
			],
			Description -> "The model of instrument cooled by the function of this model of part.",
			Category -> "Instrument Specifications"
		},
		ChillerType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ChillerTypeP,
			Description -> "The category of this model chiller based on the underlying principle used to transfer heat.",
			Category -> "Instrument Specifications"
		},
		ChillerCoolingMechanism-> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ChillerCoolingMechanismP,
			Description -> "The chiller type based on how the hot refrigerant is cooled down in the condenser part of this model chiller.",
			Category -> "Instrument Specifications"
		}
	}
}];