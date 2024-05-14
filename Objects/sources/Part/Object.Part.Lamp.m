(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, Lamp], {
	Description->"An electrical device producing ultraviolet, infrared, or visible light.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		MaxLifeTime -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxLifeTime]],
			Pattern :> GreaterP[0*Hour],
			Description -> "The length of time that the lamp is assured to operate for and meet the specs of the manufacturer.",
			Category -> "Operating Limits"
		},
		NumberOfFlashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of flashes that the lamp has produced during experiments.",
			Category -> "Operating Limits"
		},
		MinWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinWavelength]],
			Pattern :> GreaterP[0*Nano*Meter],
			Description -> "Minimum wavelength of light emitted.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxWavelength]],
			Pattern :> GreaterP[0*Nano*Meter],
			Description -> "Maximum wavelength of light emitted.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		WindowMaterial -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],WindowMaterial]],
			Pattern :> LampWindowMaterialP,
			Description -> "The material composition of the window material in which the filament is housed.",
			Category -> "Optical Information"
		},
		PDU -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, PowerDistributionUnit][ConnectedInstruments, 1],
			Description -> "The PDU that controls power flow to this lamp.",
			Category -> "Part Specifications"
		},
		PDUIP -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[PDU]},Download[Field[PDU],IP]],
			Pattern :> IpP,
			Description -> "The IP address of the PDU that controls power flow to this valve.",
			Category -> "Part Specifications"
		},
		PDUPort -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[PDU], Field[Object]}, Computables`Private`getPDUPort[Field[Object], Field[PDU], PDUPart]],
			Pattern :> PDUPortP,
			Description -> "The specific PDU port to which this valve is connected.",
			Category -> "Part Specifications"
		},
		ConnectedInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument,LiquidHandler][TopLight],Object[Instrument, SampleImager][TopLight],Object[Instrument, SampleImager][TopLight],Object[Instrument, SampleImager][BottomLight],Object[Instrument, SampleInspector][TopLight],Object[Instrument, SampleInspector][FrontLight],Object[Instrument, SampleInspector][BackLight]],
			Description -> "The instrument for which this lamp provides illumination.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		IntegratedLiquidHandler -> {
			Format-> Single,
			Class-> Link,
			Pattern:> _Link,
			Relation-> Object[Instrument,LiquidHandler][IntegratedUVLamps],
			Description-> "The liquid handler that is connected to this UV Lamp.",
			Category-> "Integrations"
		}
	}
}];
