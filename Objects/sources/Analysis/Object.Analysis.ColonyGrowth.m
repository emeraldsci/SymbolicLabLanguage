(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)

(* Index based organization of multiple populations *)
DefineObjectType[Object[Analysis, ColonyGrowth],
	{
		Description -> "Analysis to track the number and morphology properties (diameter, separation, regularity and circularity) of colonies on a single plate over time.",
		CreatePrivileges -> None,
		Cache -> Session,
		Fields -> {
			ReferenceImages -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[EmeraldCloudFile],
				Description -> "The BrightField raw images analyzed for tracking colonies change.",
				Category -> "General"
			},
			MinDiameter -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0 Millimeter],
				Units -> Millimeter,
				Description -> "The smallest diameter value from which colonies are included in TotalColonyCounts in the analysis. The diameter is defined as the diameter of a circle with the same area as the colony.",
				Category -> "Analysis & Reports"
			},
			MaxDiameter -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0 Millimeter],
				Units -> Millimeter,
				Description -> "The largest diameter value from which colonies are included in TotalColonyCounts in the analysis. The diameter is defined as the diameter of a circle with the same area as the colony.",
				Category -> "Analysis & Reports"
			},
			MinColonySeparation -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0 Millimeter],
				Units -> Millimeter,
				Description -> "The closest distance included colonies can be from each other from which colonies are included in in TotalColonyCounts the data and analysis. The separation of a colony is the shortest path between the perimeter of the colony and the perimeter of any other colony.",
				Category -> "Analysis & Reports"
			},
			MinRegularityRatio -> {
				Format -> Single,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "The smallest regularity ratio from which colonies are included in TotalColonyCounts in the analysis. The regularity ratio is the ratio of the area of the colony to the area of a circle with the colony's perimeter. For example, jagged edged shapes will have a longer perimeter than smoother ones and therefore a smaller regularity ratio.",
				Category -> "Analysis & Reports"
			},
			MaxRegularityRatio -> {
				Format -> Single,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "The largest regularity ratio from which colonies are included in TotalColonyCounts in the analysis. The regularity ratio is the ratio of the area of the colony to the area of a circle with the colony's perimeter. For example, jagged edged shapes will have a longer perimeter than smoother ones and therefore a smaller regularity ratio.",
				Category -> "Analysis & Reports"
			},
			MinCircularityRatio -> {
				Format -> Single,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "The smallest circularity ratio from which colonies are included in TotalColonyCounts in the analysis. The circularity ratio is defined as the ratio of the minor axis to the major axis of the best fit ellipse. For example, a very oblong colony will have a much larger major axis compared to its minor axis and therefore a low circularity ratio.",
				Category -> "Analysis & Reports"
			},
			MaxCircularityRatio -> {
				Format -> Single,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "The largest circularity ratio from which colonies are included in the analysis. The circularity ratio is defined as the ratio of the minor axis to the major axis of the best fit ellipse. For example, a very oblong colony will have a much larger major axis compared to its minor axis and therefore a low circularity ratio.",
				Category -> "Analysis & Reports"
			},
			ImageRotationQs -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of ReferenceImages, indicates if 180-degree rotation should be applied to prior to subsequent data processing and partitioning. The first ReferenceImages is served as the base image for comparing and aligning subsequent appearance data.",
				IndexMatching -> ReferenceImages,
				Developer -> True,
				Category -> "Optimization"
			},
			BestFitParameters -> {
				Format -> Multiple,
				Class -> QuantityArray,
				Pattern :> QuantityCoordinatesP[{Millimeter, Millimeter}],
				Units -> {Millimeter, Millimeter},
				Description -> "For each member of ReferenceImages, the aligned parameters indicates how many millimeters the current image should be shifted after image rotation but prior to subsequent data partitioning compared with the first ReferenceImages.",
				IndexMatching -> ReferenceImages,
				Developer -> True,
				Category -> "Optimization"
			},
			TargetPatchSize -> {
				Format -> Single,
				Class -> Integer,
				Pattern :> GreaterEqualP[0, 1],
				Description -> "The largest dimension from which input data are partitioning into. For example, for qpix dimensions {2819, 1872}, if TargetPatchSize is set to 1000, the image is partitioned to 3X2 patches.",
				Developer -> True,
				Category -> "Optimization"
			},
			HighlightedColonies -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> EmeraldCloudFileP,
				Relation -> Object[EmeraldCloudFile],
				Description -> "For each member of ReferenceImages, the final image that contains the original image after rotational and translational adjustments and epilogs that highlight all of the colonies included in the analysis.",
				IndexMatching -> ReferenceImages,
				Category -> "Output Image"
			},
			ExcludedColonies -> {
				Format -> Multiple,
				Class -> {Real, Real},
				Pattern :> {GreaterP[0 Millimeter], GreaterP[0 Millimeter]},
				Headers -> {"X coordinate", "Y coordinate"},
				Units -> {Millimeter, Millimeter},
				Description -> "The center points of colonies to be explicitly excluded in the analysis. The center points are relative to the first ReferenceImages.",
				Category -> "Output Image"
			},
			(* Distributions of properties for each reference *)
			AverageDiameters -> {
				Format -> Multiple,
				Class -> Distribution,
				Pattern :> DistributionP[Micrometer],
				Units -> Micrometer,
				Description -> "For each member of Reference, the distribution of colony diameters based on a disk with the same area as the colony.",
				IndexMatching -> Reference,
				Category -> "Morphological Properties"
			},
			AverageSeparations -> {
				Format -> Multiple,
				Class -> Distribution,
				Pattern :> DistributionP[Micrometer],
				Units -> Micrometer,
				Description -> "For each member of Reference, the distribution of the shortest distance from the boundary of the colony to the boundary of another.",
				Category -> "Morphological Properties"
			},
			AverageRegularityRatios -> {
				Format -> Multiple,
				Class -> Distribution,
				Pattern :> DistributionP[],
				Description -> "For each member of Reference, the distribution of the ratio of the area of the colony to the area of a circle with the same perimeter of each colony.",
				Category -> "Morphological Properties"
			},
			AverageCircularityRatios -> {
				Format -> Multiple,
				Class -> Distribution,
				Pattern :> DistributionP[],
				Description -> "For each member of Reference, the distribution of the ratio of the minor axis to the major axis of the best fit ellipse of each colony.",
				Category -> "Morphological Properties"
			},
			TotalColonyProperties -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {
					(* xy coordinate of center *)
					"Location" -> {{UnitsP[Millimeter], UnitsP[Millimeter]}..},
					(* xy coordinates of boundaries *)
					"Boundary" -> {{{UnitsP[Millimeter], UnitsP[Millimeter]}..}..},
					(* diameter *)
					"Diameter" -> {UnitsP[Millimeter]..},
					(* separation *)
					"Separation" -> {UnitsP[Millimeter]..},
					(* regularity *)
					"Regularity" -> {_?NumericQ..},
					(* circularity *)
					"Circularity" -> {_?NumericQ..}
				},
				Description -> "For each member of Reference, the locations, boundaries, and Diameter, Isolation, Regularity, and Circularity, feature values of all colonies.",
				IndexMatching -> Reference,
				Category -> "Morphological Properties"
			},
			TotalColonyCountsLog -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {_?DateObjectQ, GreaterEqualP[0]},
				Description -> "A historical record of the number of colonies detected from appearance data. If ExcludedColonies is not Null, the explicitly excluded colonies are removed from the colony count here.",
				Category -> "Analysis & Reports"
			},
			NumberOfStableIntervals -> {
				Format -> Single,
				Class -> Integer,
				Pattern :> GreaterEqualP[0],
				Units -> None,
				Description -> "The number of consecutive intervals during which the TotalColonyCounts remain stable (do not increase). This metric is used to determine whether all viable colonies have been counted when calculating Colony Forming Units (CFU). This stability indicates that the growth phase of the colonies has plateaued, ensuring an accurate count of all viable colonies present.",
				Abstract -> True,
				Category -> "Analysis & Reports"
			}
		}
	}];