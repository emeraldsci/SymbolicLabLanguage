

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Analysis, Gating], {
	Description->"Filtering and/or grouping of multi dimensional data by algorithmic clustering or manual gating.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		Channels -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GatingChannelsP | _Integer,
			Description -> "The possible sensor recording channels for each datapoint that can be used for filtering and grouping analysis.",
			Category -> "General"
		},
		Dimensions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GatingDimensionsP | _Integer,
			Description -> "The possible dimensions (e.g height, width) of each recording channel in the data that can be used for filtering and grouping analysis.",
			Category -> "General"
		},
		DimensionUnits -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> UnitsP[],
			Description -> "The Units of each dimension of the data.",
			Category -> "General"
		},
		FilterGates -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GateP,
			Description -> "A list of definitions of the bounds for filtering the data, each in the form: {The channels of the data that were used for gating, the dimensions of the data that were used for gating, the polygon describing the gate, whether the interior of the polygon is included or excluded}.",
			Category -> "General"
		},
		GroupGates -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GateP..},
			Description -> "A list of definitions of the bounds for grouping the data, each defined as a list of Gates. Each Gate is in the form: {The channels of the data that were used for gating, the dimensions of the data that were used for gating, the polygon describing the gate, whether the interior of the polygon is included or excluded}.",
			Category -> "General"
		},
		ClusterChannels -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GatingChannelsP,
			Description -> "The channels of the data that were used to generate the groupings by clustering.",
			Category -> "General"
		},
		ClusterDimensions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GatingDimensionsP | _Integer,
			Description -> "The dimensions of the data that were used to generate the groupings by clustering.",
			Category -> "General"
		},
		GroupLabels -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The labels used to name groups.",
			Category -> "General"
		},
		DistanceFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistanceFunctionP,
			Description -> "The function used to determine distance between points in order to generate groups by clustering.",
			Category -> "General"
		},
		ClusterMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ClusterMethodP,
			Description -> "The mathematical algorithm used to generate the groups via clustering in this analysis.",
			Category -> "General"
		},
		NumberOfGroups -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The total number of groups used by automatic clustering algorithm or manual grouping to generate groups.",
			Category -> "General"
		},
		Quadrant -> {
			Format -> Single,
			Class -> {VariableUnit, VariableUnit},
			Pattern :> {UnitsP[RFU] | UnitsP[RFU*Second] | UnitsP[Unit], UnitsP[RFU] | UnitsP[RFU*Second] | UnitsP[Unit]},
			Headers -> {"X Value","Y Value"},
			Description -> "The coordinate used to group the data by dividing it into quandrants.",
			Category -> "General"
		},
		SelectedData -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {{_?NumericQ..}...},
			Units -> None,
			Description -> "The data selected for analysis by the filtering gates.",
			Category -> "Analysis & Reports"
		},
		ExcludedData -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {{_?NumericQ..}...},
			Units -> None,
			Description -> "The data excluded for analysis by the filtering gates.",
			Category -> "Analysis & Reports"
		},
		GroupData -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> _Association,
			Units -> None,
			Description -> "The data grouped into a list of clusters determined by the clustering algorithm.",
			Category -> "Analysis & Reports"
		}
	}
}];
