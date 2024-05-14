(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, Spectrophotometer], {
	Description->"UV/Vis Spectrophotometer which generates absorbance spectra of cuvettes as part of a larger instrument.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		LampType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],LampType]],
			Pattern :> LampTypeP,
			Description -> "Type of lamp that the instrument uses as a light source.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		
		LightSourceType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],LightSourceType]],
			Pattern :> LightSourceTypeP,
			Description -> "Specifies whether the instrument lamp provides continuous light or if it is flashed at time of acquisition.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		
		BeamOffset -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],BeamOffset]],
			Pattern :> GreaterP[0*Meter],
			Description -> "The distance from the bottom of the cuvette holder to the point at which the laser beam hits the cuvette. This should correspond with the window offset (Z-height) on the cuvette in use.",
			Category -> "Container Specifications"
		},
		
		MinMonochromator -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinMonochromator]],
			Pattern :> GreaterP[0*Meter],
			Description -> "Monochromator minimum wavelength for absorbance filtering.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		
		MaxMonochromator -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxMonochromator]],
			Pattern :> GreaterP[0*Meter],
			Description -> "Monochromator maximum wavelength for absorbance filtering.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		
		MonochromatorBandpass -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MonochromatorBandpass]],
			Pattern :> GreaterP[0*Meter],
			Description -> "Monochromator bandpass for absorbance filtering.",
			Category -> "Operating Limits"
		},
		
		MinAbsorbance->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinAbsorbance]],
			Pattern:>GreaterEqualP[0],
			Description->"The minimum absorbance that this model instrument can read within a manufacturer reported linear range.",
			Category->"Operating Limits"
		},
		
		MaxAbsorbance->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxAbsorbance]],
			Pattern:>GreaterEqualP[0],
			Description->"The maximum absorbance that this model instrument can read within a manufacturer reported linear range.",
			Category->"Operating Limits"
		},
		
		ElectromagneticRange->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],ElectromagneticRange]],
			Pattern:>ElectromagneticRangeP,
			Description->"Specifies the ranges of the Electromagnetic Spectrum, in which the instrument can measure.",
			Category->"Instrument Specifications"
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
			Description -> "The IP address of the PDU that controls power flow to this lamp.",
			Category -> "Part Specifications"
		},
		PDUPort -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[PDU], Field[Object]}, Computables`Private`getPDUPort[Field[Object], Field[PDU], PDUPart]],
			Pattern :> PDUPortP,
			Description -> "The specific PDU port to which this spectrophotometer is connected.",
			Category -> "Part Specifications"
		}
	}
}];
