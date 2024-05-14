(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, PressureRegulator], {
  Description->"A device used for for controlling pressure output.",
  CreatePrivileges->None,
  Cache->Download,
  Fields -> {
		ConnectedInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument][ArgonPressureRegulators],
				Object[Instrument][CO2PressureRegulators],
				Object[Instrument][HeliumPressureRegulators],
				Object[Instrument][NitrogenPressureRegulators]
			],
			Description -> "Instruments for into which this part is installed.",
			Category -> "Part Specifications",
			Abstract -> True
		}
  }
}];
