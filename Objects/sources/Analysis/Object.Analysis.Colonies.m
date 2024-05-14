(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

(* Index based organization of multiple populations *)
DefineObjectType[Object[Analysis, Colonies], {
    Description-> "Analysis of microscope images to count cell colonies or plaques and characterize their location, boundary, diameter, separation, regularity, circularity, absorbance, and fluorescence. Subsets of colonies or plaques are selected to create populations with desired properties. Cells from the desired populations can be picked for further growth in subsequent experiments.",
    CreatePrivileges->None,
    Cache->Session,
    Fields -> {

        (* --- ALL COLONIES COUNTING --- *)
	
		SingletonColonyCount -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0,1],
			Description -> "The number of individual colonies detected on the plate. Colonies are identified as individuals based on a high regularity ratio, the ratio of the area of the colony to the area of a circle with the same perimeter.",
			Category -> "Analysis & Reports"
		},
		ComponentCount -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0,1],
			Description -> "The number of components detected on the plate. When multiple colonies grow into each other, they are counted as one component. Singleton colonies also count as one component.",
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
			IndexMatching-> ColonyLocations,
			Category -> "Analysis & Reports"
		},
		ColonyDiameters -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> Millimeter,
			Description -> "For each member of ColonyLocations, the diameter of a disk with the same area as the colony.",
			IndexMatching-> ColonyLocations,
			Category -> "Analysis & Reports"
		},
		ColonySeparations -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> Millimeter,
			Description -> "For each member of ColonyLocations, the shortest distance from the boundary of the colony to the boundary of another.",
			IndexMatching-> ColonyLocations,
			Category -> "Analysis & Reports"
		},
		ColonyRegularityRatios -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0,1],
			Description -> "For each member of ColonyLocations, the ratio of the area of the colony divided by the area of a circle with the same perimeter.",
			IndexMatching-> ColonyLocations,
			Category -> "Analysis & Reports"
		},
		ColonyCircularityRatio -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0,1],
			Description -> "For each member of ColonyLocations, the ratio of the minor axis to the major axis of the best fit ellipse of the colony.",
			IndexMatching-> ColonyLocations,
			Category -> "Analysis & Reports"
		},
		ColonyAbsorbances-> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0,1],
			Description -> "For each member of ColonyLocations, the average pixel value inside the colony boundary from an image generated using a blue/white filter.",
			IndexMatching-> ColonyLocations,
			Category -> "Analysis & Reports"
		},
		ColonyVioletFluorescences -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0,1],
			Description -> "For each member of ColonyLocations, the average pixel value inside the colony boundary from an image generated using a 377 nanometer excitation wavelength and a 447 nanometer emission filter.",
			IndexMatching-> ColonyLocations,
			Category -> "Analysis & Reports"
		},
		ColonyGreenFluorescences -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0,1],
			Description -> "For each member of ColonyLocations, the average pixel value inside the colony boundary from an image generated using a 457 nanometer excitation wavelength and a 536 nanometer emission filter.",
			IndexMatching-> ColonyLocations,
			Category -> "Analysis & Reports"
		},
		ColonyOrangeFluorescences -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0,1],
			Description -> "For each member of ColonyLocations, the average pixel value inside the colony boundary from an image generated using a 531 nanometer excitation wavelength and a 593 nanometer emission filter.",
			IndexMatching-> ColonyLocations,
			Category -> "Analysis & Reports"
		},
		ColonyRedFluorescences -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0,1],
			Description -> "For each member of ColonyLocations, the average pixel value inside the colony boundary from an image generated using a 531 nanometer excitation wavelength and a 624 nanometer emission filter.",
			IndexMatching-> ColonyLocations,
			Category -> "Analysis & Reports"
		},
		ColonyDarkRedFluorescences -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0,1],
			Description -> "For each member of ColonyLocations, the average pixel value inside the colony boundary from an image generated using a 628 nanometer excitation wavelength and a 692 nanometer emission filter.",
			IndexMatching-> ColonyLocations,
			Category -> "Analysis & Reports"
		},
		
        (* DISTRIBUTIONS OF ALL PROPERTIES *)
		
        AverageDiameter -> {
            Format -> Single,
            Class->Distribution,
			Pattern:>DistributionP[Micrometer],
            Units->Micrometer,
            Description -> "The distribution of colony diameters based on a disk with the same area of each colony.",
            Category -> "Analysis & Reports"
        },
		AverageSeparation -> {
			Format -> Single,
			Class->Distribution,
			Pattern:>DistributionP[Micrometer],
			Units->Micrometer,
			Description -> "The distribution of the shortest distance from the boundary of the colony to the boundary of another.",
			Category -> "Analysis & Reports"
		},
        AverageRegularity -> {
            Format -> Single,
            Class->Distribution,
			Pattern:>DistributionP[],
            Description -> "The distribution of the ratio of the area of the colony to the area of a circle with the same perimeter of each colony.",
            Category -> "Analysis & Reports"
        },
        AverageCircularity -> {
            Format -> Single,
            Class->Distribution,
			Pattern:>DistributionP[],
            Description -> "The distribution of the ratio of the minor axis to the major axis of the best fit ellipse of each colony.",
            Category -> "Analysis & Reports"
        },
        AverageAbsorbance -> {
            Format -> Single,
            Class->Distribution,
			Pattern:> DistributionP[],
            Description -> "The distribution of the relative intensity, from absorbance, of each colony.",
            Category -> "Analysis & Reports"
        },
        AverageVioletFluorescence -> {
            Format -> Single,
            Class->Distribution,
			Pattern:>DistributionP[],
            Description -> "The distribution of the relative brightness, using a 337 Nanometer excitation wavelength and a 447 Nanometer wavelength emission filter, of each colony.",
            Category -> "Analysis & Reports"
        },
        AverageGreenFluorescence -> {
            Format -> Single,
            Class->Distribution,
			Pattern:>DistributionP[],
            Description -> "The distribution of the relative brightness, using a 457 Nanometer excitation wavelength and a 536 Nanometer wavelength emission filter, of each colony.",
            Category -> "Analysis & Reports"
        },
        AverageOrangeFluorescence -> {
            Format -> Single,
            Class->Distribution,
			Pattern:>DistributionP[],
            Description -> "The distributiLooon of the relative brightness, using a 531 Nanometer excitation wavelength and a 593 Nanometer wavelength emission filter, of each colony.",
            Category -> "Analysis & Reports"
        },
        AverageRedFluorescence -> {
            Format -> Single,
            Class->Distribution,
			Pattern:>DistributionP[],
            Description -> "The distribution of the relative brightness, using a 531 Nanometer excitation wavelength and a 624 Nanometer wavelength emission filter, of each colony.",
            Category -> "Analysis & Reports"
        },
        AverageDarkRedFluorescence -> {
            Format -> Single,
            Class->Distribution,
			Pattern:>DistributionP[],
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
            Pattern :> ECL`MultiFeaturedPrimitiveP|ECL`DiameterPrimitiveP|ECL`AbsorbancePrimitiveP|ECL`IsolationPrimitiveP|ECL`CircularityPrimitiveP|ECL`RegularityPrimitiveP|ECL`FluorescencePrimitiveP|ECL`AllColoniesPrimitiveP,
            Description -> "For each member of PopulationNames, the set of options used to determine the colonies in the population.",
            Category -> "Analysis & Reports",
            IndexMatching->PopulationNames
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
            Pattern:> {
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
				(* absorbances *)
				"Absorbance" -> {_?NumericQ..},
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
            Description -> "For each member of PopulationNames, the locations, boundaries, diameters, separations, regularities, circularities, absorbances, violet fluorescence, green fluorescence, orange fluorescence, red fluorescence, and dark red fluorescence of population colonies.",
            Category -> "Analysis & Reports",
            IndexMatching->PopulationNames
        },

        (* Distributions of selected properties *)
        PopulationDiameters -> {
            Format -> Multiple,
            Class->Distribution,
			Pattern:>DistributionP[Micrometer],
            Units->Micrometer,
            Description -> "For each member of PopulationNames, the distribution of colony diameters based on a disk with the same area as the colony.",
            Category -> "Analysis & Reports",
			IndexMatching->PopulationNames
        },
        PopulationSeparations -> {
            Format -> Multiple,
            Class->Distribution,
			Pattern:>DistributionP[Micrometer],
            Units->Micrometer,
            Description -> "For each member of PopulationNames, the distribution of the distances from the boundary of each colony to the nearest boundary of another colony.",
            Category -> "Analysis & Reports",
            IndexMatching->PopulationNames
        },
        PopulationRegularities -> {
            Format -> Multiple,
            Class->Distribution,
			Pattern:>DistributionP[],
            Description -> "For each member of PopulationNames, the distribution of the ratio of the area of a component to the area of a circle with the same perimeter.",
            Category -> "Analysis & Reports",
            IndexMatching->PopulationNames
        },
        PopulationCircularities -> {
            Format -> Multiple,
            Class->Distribution,
			Pattern:>DistributionP[],
            Description -> "For each member of PopulationNames, the distribution of the ratio of the minor axis to the major axis of the best fit ellipse of each colony.",
            Category -> "Analysis & Reports",
            IndexMatching->PopulationNames
        },
        PopulationAbsorbances -> {
            Format -> Multiple,
            Class->Distribution,
			Pattern:>DistributionP[],
            Description -> "For each member of PopulationNames, the distribution of the relative intensity, from absorbance, of each colony.",
            Category -> "Analysis & Reports",
            IndexMatching->PopulationNames
        },
        PopulationVioletFluorescence -> {
            Format -> Multiple,
            Class->Distribution,
			Pattern:>DistributionP[],
            Description -> "For each member of PopulationNames, the distribution of the relative brightness, using a 337 Nanometer excitation wavelength and a 447 Nanometer wavelength emission filter, of each colony.",
            Category -> "Analysis & Reports",
            IndexMatching->PopulationNames
        },
        PopulationGreenFluorescence -> {
            Format -> Multiple,
            Class->Distribution,
			Pattern:>DistributionP[],
            Description -> "For each member of PopulationNames, the distribution of the relative brightness, using a 457 Nanometer excitation wavelength and a 536 Nanometer wavelength emission filter, of each colony.",
            Category -> "Analysis & Reports",
            IndexMatching->PopulationNames
        },
        PopulationOrangeFluorescence -> {
            Format -> Multiple,
            Class->Distribution,
			Pattern:>DistributionP[],
            Description -> "For each member of PopulationNames, the distribution of the relative brightness, using a 531 Nanometer excitation wavelength and a 593 Nanometer wavelength emission filter, of each colony.",
            Category -> "Analysis & Reports",
            IndexMatching->PopulationNames
        },
        PopulationRedFluorescence -> {
            Format -> Multiple,
            Class->Distribution,
			Pattern:>DistributionP[],
            Description -> "For each member of PopulationNames, the distribution of the relative brightness, using a 531 Nanometer excitation wavelength and a 624 Nanometer wavelength emission filter, of each colony.",
            Category -> "Analysis & Reports",
            IndexMatching->PopulationNames
        },
        PopulationDarkRedFluorescence -> {
            Format -> Multiple,
            Class->Distribution,
			Pattern:>DistributionP[],
            Description -> "For each member of PopulationNames, the distribution of the relative brightness, using a 628 Nanometer excitation wavelength and a 692 Nanometer wavelength emission filter, of each colony.",
            Category -> "Analysis & Reports",
            IndexMatching->PopulationNames
        }
    }
}];
