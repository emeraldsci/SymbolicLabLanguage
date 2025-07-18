

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container, Plate], {
	Description->"A container that stores lab samples in individual wells. Often meets the ANSI/SBS plate dimensions standard.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		SerialNumber -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The manufacturer provided serial number of the plate.",
			Category -> "Container Specifications"
		},
		RecommendedFillVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], RecommendedFillVolume]],
			Pattern :> GreaterP[0*Micro*Liter],
			Description -> "The largest volume recommended in a full well of this plate.",
			Category -> "Container Specifications",
			Abstract -> True
		},
		PlateColor -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], PlateColor]],
			Pattern :> PlateColorP,
			Description -> "The color of the main body of the plate.",
			Category -> "Container Specifications"
		},
		WellColor -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], WellColor]],
			Pattern :> PlateColorP,
			Description -> "The color of the bottom of the wells of the plate.",
			Category -> "Container Specifications"
		},
		WellDimensions -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],WellDimensions]],
			Pattern :>  {GreaterP[0*Milli*Meter],GreaterP[0*Milli*Meter]},
			Description -> "Size of the rectangular wells in {X (Horizontal), Y (Vertical)}.",
			Category -> "Container Specifications"
		},
		WellDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], WellDiameter]],
			Pattern :> GreaterP[0*Milli*Meter],
			Description -> "Diameter of each round well.",
			Category -> "Container Specifications"
		},
		HorizontalMargin -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], HorizontalMargin]],
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Description -> "Distance from the left edge of the plate to the edge of the first well.",
			Category -> "Container Specifications"
		},
		VerticalMargin -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], VerticalMargin]],
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Description -> "Distance from the top edge of the plate to the edge of the first well.",
			Category -> "Container Specifications"
		},
		DepthMargin -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], DepthMargin]],
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Description -> "Z-axis distance from the bottom of the plate to the bottom of the first well.",
			Category -> "Container Specifications"
		},
		HorizontalPitch -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], HorizontalPitch]],
			Pattern :> GreaterP[0*Milli*Meter],
			Description -> "Center-to-center distance from one well to the next in a given row.",
			Category -> "Container Specifications"
		},
		VerticalPitch -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], VerticalPitch]],
			Pattern :> GreaterP[0*Milli*Meter],
			Description -> "Center-to-center distance from one well to the next in a given column.",
			Category -> "Container Specifications"
		},
		WellDepth -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], WellDepth]],
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Description -> "Maximum z-axis depth of each well.",
			Category -> "Container Specifications"
		},
		WellBottom -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], WellBottom]],
			Pattern :> WellShapeP,
			Description -> "Shape of the bottom of each well.",
			Category -> "Container Specifications"
		},
		ConicalWellDepth -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], ConicalWellDepth]],
			Pattern :> GreaterP[0*Milli*Meter],
			Description -> "Height of the conical section of the well.",
			Category -> "Container Specifications"
		},
		Rows -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], Rows]],
			Pattern :> GreaterP[0, 1],
			Description -> "The number of rows of wells in the plate.",
			Category -> "Container Specifications"
		},
		Columns -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], Columns]],
			Pattern :> GreaterP[0, 1],
			Description -> "The number of columns of wells in the plate.",
			Category -> "Container Specifications"
		},
		NumberOfWells -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], NumberOfWells]],
			Pattern :> GreaterP[0, 1],
			Description -> "Number of individual wells the plate has.",
			Category -> "Container Specifications",
			Abstract -> True
		},
		AspectRatio -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], AspectRatio]],
			Pattern :> GreaterP[0],
			Description -> "Ratio of the number of columns of wells vs the number of rows of wells on the plate.",
			Category -> "Container Specifications"
		},
		BlankInvalid -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that the structure of the plate has potentially been compromised by another protocol and therefore any blank data is invalid.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		BiohazardSealed -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the plate containing solid biohazard waste has been taped and its lid has been secured to the container body by tape. If BiohazardSealed is True, the solid biohazard waste can be disposed into biohazard wastebin directly.",
			Category -> "Container History",
			Developer -> True
		},
		UsageLog -> {
			Format -> Multiple,
			Class -> {Expression,Link},
			Pattern :> {_?DateObjectQ, _Link},
			Relation -> {Null, Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Headers->{"Date","Use"},
			Description -> "The dates the plate has previously been used in protocols.",
			Category -> "General"
		}
	}
}];
