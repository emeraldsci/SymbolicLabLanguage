(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container,Plate,Irregular],{
	Description->"A container that stores lab samples in individual wells. The well size and layout of well columns and rows may not be consistent throughout the plate.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{

		WellColors -> {
			Format -> Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model], WellColors]],
			Pattern :> PlateColorP,
			Description -> "For each member of Positions, the color of the bottom of the well.",
			Category -> "Container Specifications"
		},
		WellTreatments -> {
			Format -> Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model], WellTreatments]],
			Pattern :> WellTreatmentP,
			Description -> "For each member of Positions, the treatement or coating, if any, on the well.",
			Category -> "Container Specifications"
		},
		WellPositionDimensions -> {
			Format -> Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model], WellPositionDimensions]],
			Pattern :> {GreaterP[0*Milli*Meter],GreaterP[0*Milli*Meter]},
			Description -> "For each member of Positions, the internal size of the well.",
			Category -> "Container Specifications"
		},
		WellDiameters -> {
			Format -> Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model], WellDiameters]],
			Pattern :> GreaterP[0*Milli*Meter],
			Description -> "For each member of Positions, the diameter of the well, if round.",
			Category -> "Container Specifications"
		},
		WellDepths -> {
			Format -> Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model], WellDepths]],
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Description -> "For each member of Positions, the maximum z-axis depth of the well.",
			Category -> "Container Specifications"
		},
		WellBottoms -> {
			Format -> Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model], WellBottoms]],
			Pattern :> WellShapeP,
			Description -> "For each member of Positions, the shape of the bottom of the well.",
			Category -> "Container Specifications"
		},
		ConicalWellDepths -> {
			Format -> Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model], ConicalWellDepths]],
			Pattern :> GreaterP[0*Milli*Meter],
			Description -> "For each member of Positions, the depth of the conical section of the well.",
			Category -> "Container Specifications"
		},
		MinVolumes -> {
			Format -> Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model], MinVolumes]],
			Pattern :> GreaterP[0*Micro*Liter],
			Description -> "For each member of Positions, the smallest amount of fluid the well can hold.",
			Category -> "Operating Limits"
		},
		MaxVolumes -> {
			Format -> Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxVolumes]],
			Pattern :> GreaterP[0*Micro*Liter],
			Description -> "For each member of Positions, the largest amount of fluid the well can hold.",
			Category -> "Operating Limits"
		},
		RecommendedFillVolumes -> {
			Format -> Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model], RecommendedFillVolumes]],
			Pattern :> GreaterP[0*Micro*Liter],
			Description -> "For each member of Positions, the largest recommended fill volume in the wells of this plate.",
			Category -> "Operating Limits"
		}
	}
}];
