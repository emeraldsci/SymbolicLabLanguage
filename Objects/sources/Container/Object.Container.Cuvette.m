(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Container, Cuvette], {
	Description->"A description of a cuvette which can be used to hold a sample during spectroscopic experiments.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		PathLength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], PathLength]],
			Pattern :> GreaterP[0*Meter],
			Description -> "The distance light will travel from entering the sample to exiting it.",
			Category -> "Container Specifications",
			Abstract -> True
		},
		WallType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], WallType]],
			Pattern :> WallTypeP,
			Description -> "Indicates if the cuvette has two clear sides (Frosted), four clear sides (Clear) or is self masking (BlackWalled).",
			Category -> "Container Specifications",
			Abstract -> True
		},
		NeckType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], NeckType]],
			Pattern :> NeckTypeP,
			Description -> "The GPI/SPI Neck Finish designation of the cuvette used to determine the cap threading.",
			Category -> "Container Specifications"
		},
		MinRecommendedWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinRecommendedWavelength]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The wavelength below which insufficient transmission occurs for most spectroscopic experiments performed using this cuvette.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxRecommendedWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxRecommendedWavelength]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The wavelength above which insufficient transmission occurs for most spectroscopic experiments performed using this cuvette.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		WindowWidth -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], WindowWidth]],
			Pattern :> GreaterP[0*Meter],
			Description -> "The horizontal size (left-to-right) of the optical window.",
			Category -> "Container Specifications"
		},
		WindowHeight -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], WindowHeight]],
			Pattern :> GreaterP[0*Meter],
			Description -> "The vertical size (top-to-bottom) of the optical window.",
			Category -> "Container Specifications"
		},
		WindowOffset -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], WindowOffset]],
			Pattern :> GreaterP[0*Meter],
			Description -> "The distance from the bottom of the cuvette to the center of the optical window. This should correspond with the beam offset (Z-height) on the instrument used with this cuvette.",
			Category -> "Container Specifications"
		},
		InternalDimensions->{
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],InternalDimensions]],
			Pattern :> {GreaterP[0*Milli*Meter], GreaterP[0*Milli*Meter]},
			Description -> "The internal dimensions of the cuvette in the form: {horizontal (left-to-right), vertical (front-to-back)}.",
			Category -> "Dimensions & Positions"
		},
		InternalDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], InternalDiameter]],
			Pattern :> GreaterP[0*Milli*Meter],
			Description -> "Interior diameter of the cuvette's contents holding cavity.",
			Category -> "Dimensions & Positions"
		},
		InternalDepth -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], InternalDepth]],
			Pattern :> GreaterP[0*Milli*Meter],
			Description -> "Maximum interior depth of the cuvette's contents holding cavity.",
			Category -> "Dimensions & Positions"
		},
		Scale -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], Scale]],
			Pattern :> CuvetteScaleP,
			Description -> "Shape of cuvette's contents holding cavity.",
			Category -> "Dimensions & Positions"
		},
		RecommendedFillVolumes -> {
			Format -> Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model], RecommendedFillVolumes]],
			Pattern :> GreaterP[0*Micro*Liter],
			Description -> "The largest recommended fill volume of this cuvette.",
			Category -> "Operating Limits"
		}
	}
}];
