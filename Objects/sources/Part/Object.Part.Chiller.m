(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, Chiller], {
	Description->"Information for a part designed to chill an instrument.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, Diffractometer][Chiller],
				Object[Instrument, MassSpectrometer][Chiller],
				Object[Instrument,CrystalIncubator][Chiller],
				Object[Instrument,CrystalIncubator][SecondaryChiller],
				Object[Instrument,LiquidHandler,AcousticLiquidHandler][Chiller]
			],
			Description -> "The instrument cooled by the function of this part.",
			Category -> "Instrument Specifications"
		}
	}
}];
