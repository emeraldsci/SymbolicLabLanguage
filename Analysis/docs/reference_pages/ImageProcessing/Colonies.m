(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*AnalyzeColonies*)


(* Updated definition to Command Center *)
DefineUsageWithCompanions[AnalyzeColonies,
	{
		BasicDefinitions->{

			(* Definition one - microscope data objects *)
			{
				Definition->{"AnalyzeColonies[MicroscopeData]","ColoniesAnalysis"},
				Description->"counts the cell colonies or plaques on solid media imaged in 'MicroscopeData' and then classifies and locates the colonies or plaques by desired features, including fluorescence, absorbance, diameter, regularity, circularity, and isolation. The colony analysis may be used to isolate these colonies in fresh media in subsequent protocols such as colony picking.",
				Inputs:>{
                    IndexMatching[
                        {
                            InputName -> "MicroscopeData",
                            Description-> "Microscope data objects that contain brightfield images of colonies or plaques on a plate and may also contain absorbance or fluorescence images.",
							(* Add Object[Protocol, PickColonies] once Harrison merges in his branch with Dereference field *)
                            Widget -> Widget[
                                Type -> Object,
                                Pattern :> ObjectP[{Object[Data, Appearance, Colonies]}]
                            ],
                            Expandable->False
                        },
                        IndexName -> "Microscope data"
                    ]
				},
				Outputs:>{
					{
						OutputName->"ColoniesAnalysis",
						Description->"Analysis object with the count and properties of all colonies or plaques, including the location, boundary, fluorescence, absorbance, diameter, regularity, circularity, and isolation. It also stores the location and classification of colonies or plaques with desired traits so that they can be picked for additional experimentation.",
						Pattern:>ListableP[ObjectP[Object[Analysis,Colonies]]]
					}
				}
			}
		},
		SeeAlso -> {
			"AnalyzeColoniesPreview",
			"AnalyzeColoniesOptions",
			"ValidAnalyzeColoniesQ",
			"PlotMicroscope",
			"AnalyzeCellCount",
			"ExperimentPickColonies",
			"ColonySelection"
		},
		Author -> {
			"scicomp",
			"derek.machalek",
			"hiren.patel",
            		"harrison.gronlund"
		},
        MoreInformation -> {
            "The diameter of a colony is the diameter of a disk with the same area as the colony.",
            "The separation or isolation is the shortest distance from the boundary of the colony to the boundary of another.",
            "The regularity is the ratio of the area of the colony to the area of a circle with the same perimeter.",
            "The circularity is the ratio of the minor axis to the major axis of the best fit ellipse.",
            "The absorbance is the average pixel value inside the colony boundary from an image generated using a light filter.",
            "The fluorescence is the average pixel value inside the colony boundary from an image generated using an excitation wavelength and emission filter.",
            "Available fluorescence excitation/emission pairs are 377nm/447nm, 457nm/536nm, 531nm/593nm, 531nm/624nm, and 628nm/692nm. They are respectively referred to as VioletFluorescence, GreenFluorescence, OrangeFluorescence, RedFluorescence, and DarkRedFluorescence.",
		"The picking algorithm filters the colonies using the min and max bounds of diameter, regularity, circularity, and isolation. Then the Populations option is used to group colonies into populations using the Diameter, Isolation, Regularity, Circularity, Fluorescence, Absorbance, MultiFeatured, or AllColonies Unit Operation.",
		"The counting algorithm identifies the singleton colonies on the plate and then estimates the number of colonies in colony clusters by dividing each cluster by the average area of a singleton. As a result, the total estimated colonies can be fractional."
        },
		
		(* interactivity options *)
		Preview -> True,
		PreviewOptions -> {
			"Populations",
			"ManualPickTargets",
			"IncludedColonies"
		},
		ButtonActionsGuide->{
			{Description->"Pan image", ButtonSet->"'Shift' + 'LeftDrag'"},
			{Description->"Zoom image", ButtonSet->"'LeftDrag'"},
			{Description->"Add measurement line", ButtonSet->"'Control' + 'LeftDrag'"},
			{Description->"Change image type", ButtonSet->"'Option'"},
			{Description->"Move colony target", ButtonSet->"'LeftDrag'"},
			{Description->"Include or Exclude colony", ButtonSet->"'LeftClick'"},
			{Description->"Draw custom colony", ButtonSet->"'Checkbox' + 'LeftDrag'"},
			{Description->"Delete custom colony", ButtonSet->"'Checkbox' + 'RightClick'"}
		}
	}
];

DefineUsage[Diameter,
	{
		BasicDefinitions -> {
			{"Diameter[diameterRules]","primitive","generates a population selection 'primitive' that groups a set of colonies by their diameter."}
		},
		Input:>{
			{
				"diameterRules",
				{_Rule..},
				"Key/value pairs that define a set of colonies into a population based on their diameter."
			}
		},
		Output:>{
			{"primitive",_Diameter,"A primitive that specifies a population of colonies based on their diameter."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"AnalyzeColonies",
			"Isolation",
			"Regularity",
			"Circularity",
			"Fluorescence",
			"AllColonies",
			"MultiFeatured"
		},
		Author->{"derek.machalek"}
	}
];

DefineUsage[Isolation,
	{
		BasicDefinitions -> {
			{"Isolation[isolationRules]","primitive","generates a population selection 'primitive' that groups a set of colonies by their isolation."}
		},
		Input:>{
			{
				"isolationRules",
				{_Rule..},
				"Key/value pairs that define a set of colonies into a population based on their isolation."
			}
		},
		Output:>{
			{"primitive",_Diameter,"A primitive that specifies a population of colonies based on their isolation."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"AnalyzeColonies",
			"Diameter",
			"Regularity",
			"Circularity",
			"Fluorescence",
			"AllColonies",
			"MultiFeatured"
		},
		Author->{"derek.machalek"}
	}
];

DefineUsage[Regularity,
	{
		BasicDefinitions -> {
			{"Regularity[regularityRules]","primitive","generates a population selection 'primitive' that groups a set of colonies by their regularity."}
		},
		Input:>{
			{
				"regularityRules",
				{_Rule..},
				"Key/value pairs that define a set of colonies into a population based on their regularity."
			}
		},
		Output:>{
			{"primitive",_Diameter,"A primitive that specifies a population of colonies based on their regularity."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"AnalyzeColonies",
			"Diameter",
			"Isolation",
			"Circularity",
			"Fluorescence",
			"AllColonies",
			"MultiFeatured"
		},
		Author->{"derek.machalek"}
	}
];

DefineUsage[Circularity,
	{
		BasicDefinitions -> {
			{"Circularity[circularityRules]","primitive","generates a population selection 'primitive' that groups a set of colonies by their circularity."}
		},
		Input:>{
			{
				"circularityRules",
				{_Rule..},
				"Key/value pairs that define a set of colonies into a population based on their circularity."
			}
		},
		Output:>{
			{"primitive",_Diameter,"A primitive that specifies a population of colonies based on their circularity."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"AnalyzeColonies",
			"Diameter",
			"Isolation",
			"Regularity",
			"Fluorescence",
			"AllColonies",
			"MultiFeatured"
		},
		Author->{"derek.machalek"}
	}
];

DefineUsage[Fluorescence,
	{
		BasicDefinitions -> {
			{"Fluorescence[fluorescenceRules]","primitive","generates a population selection 'primitive' that groups a set of colonies by their fluorescence."}
		},
		Input:>{
			{
				"fluorescenceRules",
				{_Rule..},
				"Key/value pairs that define a set of colonies into a population based on their fluorescence."
			}
		},
		Output:>{
			{"primitive",_Diameter,"A primitive that specifies a population of colonies based on their fluorescence."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"AnalyzeColonies",
			"Diameter",
			"Isolation",
			"Regularity",
			"Circularity",
			"AllColonies",
			"MultiFeatured"
		},
		Author->{"derek.machalek"}
	}
];

DefineUsage[MultiFeatured,
	{
		BasicDefinitions -> {
			{"MultiFeatured[multiFeaturedRules]","primitive","generates a population selection 'primitive' that groups a set of colonies by multiple features."}
		},
		Input:>{
			{
				"multiFeaturedRules",
				{_Rule..},
				"Key/value pairs that define a set of colonies into a population by multiple features."
			}
		},
		Output:>{
			{"primitive",_Diameter,"A primitive that specifies a population of colonies with multiple features."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"AnalyzeColonies",
			"Diameter",
			"Isolation",
			"Regularity",
			"Circularity",
			"Fluorescence",
			"AllColonies"
		},
		Author->{"derek.machalek"}
	}
];

DefineUsage[AllColonies,
	{
		BasicDefinitions -> {
			{"AllColonies[allColoniesRules]","primitive","generates a population selection 'primitive' that groups all colonies into a population."}
		},
		Input:>{
			{
				"allColoniesRules",
				{_Rule..},
				"Key/value pairs that define a set of colonies into a population by multiple features."
			}
		},
		Output:>{
			{"primitive",_Diameter,"A primitive that specifies all colonies into a population."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"AnalyzeColonies",
			"Diameter",
			"Isolation",
			"Regularity",
			"Circularity",
			"Fluorescence",
			"MultiFeatured"
		},
		Author->{"derek.machalek"}
	}
];
