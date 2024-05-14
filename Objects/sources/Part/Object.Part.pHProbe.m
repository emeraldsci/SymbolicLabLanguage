(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, pHProbe], {
	Description->"A probe used for the pH measurments in a solution.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		ProbeCertificate->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "PDFs for the quality certificate of this probe coming from the manufacturer.",
			Category -> "Model Information"
		},
		pHMeter->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument,pHMeter][Probe],
				Object[Instrument,pHMeter][SecondaryProbe],
				Object[Instrument,pHMeter][TertiaryProbe]
			],
			Description -> "The device that this part is associated with.",
			Category -> "Instrument Specifications"
		}
	}
}];
