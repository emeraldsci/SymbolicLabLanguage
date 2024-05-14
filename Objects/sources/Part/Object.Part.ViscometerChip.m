(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, ViscometerChip], {
	Description->"A microfluidic rectangular slit chip used to measure viscosity with a viscometer.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		Instrument-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation-> Object[Instrument,Viscometer][ViscometerChip],
			Description -> "The viscometer instrument that the ViscometerChip is connected to and used in measuring viscosity of samples.",
			Category -> "Part Specifications",
			Abstract-> True
		},
		MaxPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Pascal],
			Units -> Pascal,
			Description -> "The maximum pressure across the measurement channel that can be measured by the chip.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		ChannelHeight -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],ChannelHeight]],
			Pattern :> GreaterEqualP[0*Millimeter],
			Description -> "The height of the chip's measurement channel.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		ChannelWidth -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],ChannelWidth]],
			Pattern :> GreaterEqualP[0*Millimeter],
			Description -> "The height of the chip's measurement channel.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		ChannelLength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],ChannelLength]],
			Pattern :> GreaterEqualP[0*Millimeter],
			Description -> "The height of the chip's measurement channel.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		UsageLog -> {
			Format -> Multiple,
			Class -> {Expression,Link,Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Protocol] | Object[Qualification] | Object[Maintenance],Object[Sample]},
			Headers->{"Date","Use","Sample"},
			Description -> "The dates the chip has previously been used to take measurements of samples.",
			Category -> "Organizational Information"
		}
	}
}];
