(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)

(* Index based organization of multiple populations *)
DefineObjectType[Object[Analysis, Colonies],
	{
		Description -> "Analysis of colony appearance images to count colonies or plaques and characterize their location, boundary, diameter, separation, regularity, circularity, absorbance, and fluorescence. Subsets of colonies or plaques are selected to create populations with desired properties. Cells from the desired populations can be picked for further growth in subsequent experiments.",
		CreatePrivileges -> None,
		Cache -> Session,
		Fields -> {
			(* --- ALL FEATURES COUNTING --- *)
			ComponentCount -> {
				Format -> Single,
				Class -> Integer,
				Pattern :> GreaterEqualP[0, 1],
				Description -> "The number of components detected on the plate without filtering with Diameter, CircularityRatio, RegularityRatio, and MinColonySeparation. When multiple colonies grow into each other, they are counted as one component. Singleton colonies also count as one component.",
				Category -> "Analysis & Reports"
			},
			ComponentBoundaries -> {
				Format -> Multiple,
				Class -> QuantityArray,
				Pattern :> QuantityCoordinatesP[{Millimeter, Millimeter}],
				Units -> {Millimeter, Millimeter},
				Description -> "The coordinates of points on the boundary of all the components detected on the plate without filtering with Diameter, CircularityRatio, RegularityRatio, and MinColonySeparation.",
				Category -> "Analysis & Reports"
			},
			BackgroundBlueWhiteScreen -> {
				Format -> Single,
				Class -> Distribution,
				Pattern :> DistributionP[],
				Description -> "The distribution of the intensity, from BlueWhiteScreen image, outside of margin and without any components detected.",
				Category -> "Analysis & Reports"
			},
			BackgroundVioletFluorescence -> {
				Format -> Single,
				Class -> Distribution,
				Pattern :> DistributionP[],
				Description -> "The distribution of the relative brightness, using a 377 Nanometer excitation wavelength and a 447 Nanometer wavelength emission filter, outside of margin and without any components detected.",
				Category -> "Analysis & Reports"
			},
			BackgroundGreenFluorescence -> {
				Format -> Single,
				Class -> Distribution,
				Pattern :> DistributionP[],
				Description -> "The distribution of the relative brightness, using a 457 Nanometer excitation wavelength and a 536 Nanometer wavelength emission filter, outside of margin and without any components detected.",
				Category -> "Analysis & Reports"
			},
			BackgroundOrangeFluorescence -> {
				Format -> Single,
				Class -> Distribution,
				Pattern :> DistributionP[],
				Description -> "The distribution of the relative brightness, using a 531 Nanometer excitation wavelength and a 593 Nanometer wavelength emission filter, outside of margin and without any components detected.",
				Category -> "Analysis & Reports"
			},
			BackgroundRedFluorescence -> {
				Format -> Single,
				Class -> Distribution,
				Pattern :> DistributionP[],
				Description -> "The distribution of the relative brightness, using a 531 Nanometer excitation wavelength and a 624 Nanometer wavelength emission filter, outside of margin and without any components detected.",
				Category -> "Analysis & Reports"
			},
			BackgroundDarkRedFluorescence -> {
				Format -> Single,
				Class -> Distribution,
				Pattern :> DistributionP[],
				Description -> "The distribution of the relative brightness, using a 628 Nanometer excitation wavelength and a 692 Nanometer wavelength emission filter, outside of margin and without any components detected.",
				Category -> "Analysis & Reports"
			},
			(* --- ALL COLONIES COUNTING --- *)
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
			Margin -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> None|GreaterEqualP[0, 1],
				Description -> "The margin size to overlay as a black mask on the image data. A rectangular mask with the specified margin width (in the unit of pixel) is applied along the edges of the image before colony selection. Colonies in the masked region are excluded in TotalColonyCounts in the analysis unless manual picked. This overlay helps exclude false-positive signals from the plate outline.",
				Category -> "Analysis & Reports"
			},
			SingletonColonyCount -> {
				Format -> Single,
				Class -> Integer,
				Pattern :> GreaterEqualP[0, 1],
				Description -> "The number of individual colonies detected on the plate. Colonies are identified as individuals based on a high regularity ratio, the ratio of the area of the colony to the area of a circle with the same perimeter.",
				Category -> "Analysis & Reports"
			},
			TotalColonyCount -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0],
				Description -> "The number of colonies detected on the plate, including singleton colonies and estimates for the number of colonies comprising components with multiple colonies grown together.",
				Category -> "Analysis & Reports"
			},
			(* --- ALL COLONIES CHARACTERIZATION --- *)
			ColonyLocations -> {
				Format -> Multiple,
				Class -> {Real, Real},
				Pattern :> {GreaterEqualP[0], GreaterEqualP[0]},
				Units -> {Millimeter, Millimeter},
				Headers -> {"X", "Y"},
				Description -> "The coordinates of a point inside of the colony, typically the center.",
				Category -> "Analysis & Reports"
			},
			ColonyBoundaries -> {
				Format -> Multiple,
				Class -> QuantityArray,
				Pattern :> QuantityCoordinatesP[{Millimeter, Millimeter}],
				Units -> {Millimeter, Millimeter},
				Description -> "For each member of ColonyLocations, the coordinates of points on the colony boundary.",
				IndexMatching -> ColonyLocations,
				Category -> "Analysis & Reports"
			},
			ColonyDiameters -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0],
				Units -> Millimeter,
				Description -> "For each member of ColonyLocations, the diameter of a disk with the same area as the colony.",
				IndexMatching -> ColonyLocations,
				Category -> "Analysis & Reports"
			},
			ColonySeparations -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0],
				Units -> Millimeter,
				Description -> "For each member of ColonyLocations, the shortest distance from the boundary of the colony to the boundary of another.",
				IndexMatching -> ColonyLocations,
				Category -> "Analysis & Reports"
			},
			ColonyRegularityRatios -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "For each member of ColonyLocations, the ratio of the area of the colony divided by the area of a circle with the same perimeter.",
				IndexMatching -> ColonyLocations,
				Category -> "Analysis & Reports"
			},
			ColonyCircularityRatio -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "For each member of ColonyLocations, the ratio of the minor axis to the major axis of the best fit ellipse of the colony.",
				IndexMatching -> ColonyLocations,
				Category -> "Analysis & Reports"
			},
			ColonyBlueWhiteScreens -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "For each member of ColonyLocations, the average pixel value inside the colony boundary from an image generated using a blue/white filter.",
				IndexMatching -> ColonyLocations,
				Category -> "Analysis & Reports"
			},
			ColonyVioletFluorescences -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "For each member of ColonyLocations, the average pixel value inside the colony boundary from an image generated using a 377 nanometer excitation wavelength and a 447 nanometer emission filter.",
				IndexMatching -> ColonyLocations,
				Category -> "Analysis & Reports"
			},
			ColonyGreenFluorescences -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "For each member of ColonyLocations, the average pixel value inside the colony boundary from an image generated using a 457 nanometer excitation wavelength and a 536 nanometer emission filter.",
				IndexMatching -> ColonyLocations,
				Category -> "Analysis & Reports"
			},
			ColonyOrangeFluorescences -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "For each member of ColonyLocations, the average pixel value inside the colony boundary from an image generated using a 531 nanometer excitation wavelength and a 593 nanometer emission filter.",
				IndexMatching -> ColonyLocations,
				Category -> "Analysis & Reports"
			},
			ColonyRedFluorescences -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "For each member of ColonyLocations, the average pixel value inside the colony boundary from an image generated using a 531 nanometer excitation wavelength and a 624 nanometer emission filter.",
				IndexMatching-> ColonyLocations,
				Category -> "Analysis & Reports"
			},
			ColonyDarkRedFluorescences -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "For each member of ColonyLocations, the average pixel value inside the colony boundary from an image generated using a 628 nanometer excitation wavelength and a 692 nanometer emission filter.",
				IndexMatching -> ColonyLocations,
				Category -> "Analysis & Reports"
			},
			(* DISTRIBUTIONS OF ALL PROPERTIES *)
			AverageDiameter -> {
				Format -> Single,
				Class -> Distribution,
				Pattern :> DistributionP[Micrometer],
				Units -> Micrometer,
				Description -> "The distribution of colony diameters based on a disk with the same area of each colony.",
				Category -> "Analysis & Reports"
			},
			AverageSeparation -> {
				Format -> Single,
				Class -> Distribution,
				Pattern :> DistributionP[Micrometer],
				Units -> Micrometer,
				Description -> "The distribution of the shortest distance from the boundary of the colony to the boundary of another.",
				Category -> "Analysis & Reports"
			},
			AverageRegularity -> {
				Format -> Single,
				Class -> Distribution,
				Pattern :> DistributionP[],
				Description -> "The distribution of the ratio of the area of the colony to the area of a circle with the same perimeter of each colony.",
				Category -> "Analysis & Reports"
			},
			AverageCircularity -> {
				Format -> Single,
				Class -> Distribution,
				Pattern :> DistributionP[],
				Description -> "The distribution of the ratio of the minor axis to the major axis of the best fit ellipse of each colony.",
				Category -> "Analysis & Reports"
			},
			AverageBlueWhiteScreen -> {
				Format -> Single,
				Class -> Distribution,
				Pattern :> DistributionP[],
				Description -> "The distribution of the intensity, from BlueWhiteScreen image, of each colony.",
				Category -> "Analysis & Reports"
			},
			AverageVioletFluorescence -> {
				Format -> Single,
				Class -> Distribution,
				Pattern :> DistributionP[],
				Description -> "The distribution of the relative brightness, using a 377 Nanometer excitation wavelength and a 447 Nanometer wavelength emission filter, of each colony.",
				Category -> "Analysis & Reports"
			},
			AverageGreenFluorescence -> {
				Format -> Single,
				Class -> Distribution,
				Pattern :> DistributionP[],
				Description -> "The distribution of the relative brightness, using a 457 Nanometer excitation wavelength and a 536 Nanometer wavelength emission filter, of each colony.",
				Category -> "Analysis & Reports"
			},
			AverageOrangeFluorescence -> {
				Format -> Single,
				Class -> Distribution,
				Pattern :> DistributionP[],
				Description -> "The distribution of the relative brightness, using a 531 Nanometer excitation wavelength and a 593 Nanometer wavelength emission filter, of each colony.",
				Category -> "Analysis & Reports"
			},
			AverageRedFluorescence -> {
				Format -> Single,
				Class -> Distribution,
				Pattern :> DistributionP[],
				Description -> "The distribution of the relative brightness, using a 531 Nanometer excitation wavelength and a 624 Nanometer wavelength emission filter, of each colony.",
				Category -> "Analysis & Reports"
			},
			AverageDarkRedFluorescence -> {
				Format -> Single,
				Class -> Distribution,
				Pattern :> DistributionP[],
				Description -> "The distribution of the relative brightness, using a 628 Nanometer excitation wavelength and a 692 Nanometer wavelength emission filter, of each colony.",
				Category -> "Analysis & Reports"
			},
			(* --- SELECTED POPULATIONS --- *)
			(* Index match for all population based properties *)
			PopulationNames -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "The name for a population of colonies picked by a set of options.",
				Category -> "Analysis & Reports"
			},
			ColonySelections -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> ColonySelectionPrimitiveP,
				Description -> "For each member of PopulationNames, the set of options used to determine the colonies in the population.",
				Category -> "Analysis & Reports",
				IndexMatching -> PopulationNames
			},
			PopulationTotalColonyCount -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0],
				Description -> "For each member of PopulationNames, the number of colonies detected on the plate based on the counting algorithm.",
				Category -> "Analysis & Reports"
			},
			PopulationProperties -> {
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
					"Circularity" -> {_?NumericQ..},
					(* BlueWhiteScreen *)
					"BlueWhiteScreen" -> {_?NumericQ..},
					(* VioletFluorescence *)
					"VioletFluorescence" -> {_?NumericQ..},
					(* GreenFluorescence *)
					"GreenFluorescence" -> {_?NumericQ..},
					(* OrangeFluorescence *)
					"OrangeFluorescence" -> {_?NumericQ..},
					(* RedFluorescence *)
					"RedFluorescence" -> {_?NumericQ..},
					(* DarkRedFluorescence *)
					"DarkRedFluorescence" -> {_?NumericQ..}
					},
				Description -> "For each member of PopulationNames, the locations, boundaries, and Diameter, Isolation, Regularity, Circularity, BlueWhiteScreen, and VioletFluorescence, GreenFluorescence, OrangeFluorescence, RedFluorescence, and DarkRedFluorescence feature values of population colonies.",
				Category -> "Analysis & Reports",
				IndexMatching -> PopulationNames
			},
			(* Distributions of selected properties *)
			PopulationDiameters -> {
				Format -> Multiple,
				Class -> Distribution,
				Pattern :> DistributionP[Micrometer],
				Units -> Micrometer,
				Description -> "For each member of PopulationNames, the distribution of colony diameters based on a disk with the same area as the colony.",
				Category -> "Analysis & Reports",
				IndexMatching -> PopulationNames
			},
			PopulationSeparations -> {
				Format -> Multiple,
				Class -> Distribution,
				Pattern :> DistributionP[Micrometer],
				Units -> Micrometer,
				Description -> "For each member of PopulationNames, the distribution of the distances from the boundary of each colony to the nearest boundary of another colony.",
				Category -> "Analysis & Reports",
				IndexMatching -> PopulationNames
			},
			PopulationRegularities -> {
				Format -> Multiple,
				Class -> Distribution,
				Pattern :> DistributionP[],
				Description -> "For each member of PopulationNames, the distribution of the ratio of the area of a component to the area of a circle with the same perimeter.",
				Category -> "Analysis & Reports",
				IndexMatching -> PopulationNames
			},
			PopulationCircularities -> {
				Format -> Multiple,
				Class -> Distribution,
				Pattern :>DistributionP[],
				Description -> "For each member of PopulationNames, the distribution of the ratio of the minor axis to the major axis of the best fit ellipse of each colony.",
				Category -> "Analysis & Reports",
				IndexMatching -> PopulationNames
			},
			PopulationBlueWhiteScreen -> {
				Format -> Multiple,
				Class -> Distribution,
				Pattern :> DistributionP[],
				Description -> "For each member of PopulationNames, the distribution of the intensity, from BlueWhiteScreen image, of each colony.",
				Category -> "Analysis & Reports",
				IndexMatching -> PopulationNames
			},
			PopulationVioletFluorescence -> {
				Format -> Multiple,
				Class -> Distribution,
				Pattern :> DistributionP[],
				Description -> "For each member of PopulationNames, the distribution of the relative brightness, using a 377 Nanometer excitation wavelength and a 447 Nanometer wavelength emission filter, of each colony.",
				Category -> "Analysis & Reports",
				IndexMatching -> PopulationNames
			},
			PopulationGreenFluorescence -> {
				Format -> Multiple,
				Class -> Distribution,
				Pattern :> DistributionP[],
				Description -> "For each member of PopulationNames, the distribution of the relative brightness, using a 457 Nanometer excitation wavelength and a 536 Nanometer wavelength emission filter, of each colony.",
				Category -> "Analysis & Reports",
				IndexMatching -> PopulationNames
			},
			PopulationOrangeFluorescence -> {
				Format -> Multiple,
				Class -> Distribution,
				Pattern :> DistributionP[],
				Description -> "For each member of PopulationNames, the distribution of the relative brightness, using a 531 Nanometer excitation wavelength and a 593 Nanometer wavelength emission filter, of each colony.",
				Category -> "Analysis & Reports",
				IndexMatching -> PopulationNames
			},
			PopulationRedFluorescence -> {
				Format -> Multiple,
				Class -> Distribution,
				Pattern :> DistributionP[],
				Description -> "For each member of PopulationNames, the distribution of the relative brightness, using a 531 Nanometer excitation wavelength and a 624 Nanometer wavelength emission filter, of each colony.",
				Category -> "Analysis & Reports",
				IndexMatching -> PopulationNames
			},
			PopulationDarkRedFluorescence -> {
				Format -> Multiple,
				Class -> Distribution,
				Pattern :> DistributionP[],
				Description -> "For each member of PopulationNames, the distribution of the relative brightness, using a 628 Nanometer excitation wavelength and a 692 Nanometer wavelength emission filter, of each colony.",
				Category -> "Analysis & Reports",
				IndexMatching -> PopulationNames
			},
			ColonyGrowthAnalysis -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Analysis][Reference],
				Description -> "A running log of all colony growth analyses performed on this colony analysis in order to track the colonies change.",
				Category -> "Analysis & Reports"
			}
		}
}];
