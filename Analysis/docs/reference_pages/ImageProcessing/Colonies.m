(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*AnalyzeColonies*)


(* Updated definition to Command Center *)
DefineUsageWithCompanions[AnalyzeColonies,
	{
		BasicDefinitions -> {
			(* Definition one - microscope data objects *)
			{
				Definition -> {"AnalyzeColonies[MicroscopeData]", "ColoniesAnalysis"},
				Description -> "counts the colonies on solid media imaged in 'MicroscopeData'. This function classifies and locates the colonies based on a selected feature, which can be one of the following: Diameter, Regularity, Circularity, Isolation, Fluorescence, and BlueWhiteScreen. Additionally, classification can be based on a combination of desired features (MultiFeatured), or all colonies defined with Min/MaxDiameter, Min/MaxCircularityRatio, Min/MaxRegularityRatio, MinColonySeparation and Margin (AllColonies). For more information see documentation on colony population Unit Operations: Diameter, Isolation, Regularity, Circularity, Fluorescence, BlueWhiteScreen, MultiFeatured, and AllColonies. The generated 'ColoniesAnalysis' can be used to isolate these colonies in fresh media in subsequent protocols, such as colony picking.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "MicroscopeData",
							Description-> "Microscope data objects that contain BrightField images of colonies on a plate and may also contain BlueWhiteScreen or various fluorescence images.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Data, Appearance, Colonies]}]
							],
							Expandable -> False
						},
						IndexName -> "Microscope data"
					]
				},
				Outputs :> {
					{
						OutputName -> "ColoniesAnalysis",
						Description -> "Analysis object with the count and properties of colonies, including their location, boundary, diameter, regularity, circularity, and isolation. It also includes the pixel values of the colonies from BlueWhiteScreen or various fluorescence images. Additionally, the analysis object stores the classification of the colonies that meet the desired features.",
						Pattern :> ListableP[ObjectP[Object[Analysis, Colonies]]]
					}
				}
			}
		},
		SeeAlso -> {
			"PlotColonies",
			"AnalyzeCellCount",
			"ExperimentPickColonies",
			"ExperimentQuantifyColonies",
			"Diameter",
			"Regularity",
			"Circularity",
			"Isolation",
			"Fluorescence",
			"BlueWhiteScreen",
			"MultiFeatured",
			"AllColonies"
		},
		Author -> {
			"scicomp",
			"derek.machalek",
			"hiren.patel",
			"harrison.gronlund",
			"lige.tonggu"
		},
		MoreInformation -> {
			"The diameter of a colony is the diameter of a disk with the same area as the colony.",
			"The separation or isolation is the shortest distance from the boundary of the colony to the boundary of another.",
			"The regularity is the ratio of the area of the colony to the area of a circle with the same perimeter.",
			"The circularity is the ratio of the minor axis to the major axis of the best fit ellipse.",
			"BlueWhiteScreen features the average pixel value inside the colony boundary from a BlueWhiteScreen image generated using a blue-light blocking filter.",
			"Fluorescence features the average pixel value inside the colony boundary from an image generated using an excitation wavelength and emission filter.",
			"Available fluorescence excitation/emission pairs are 377nm/447nm, 457nm/536nm, 531nm/593nm, 531nm/624nm, and 628nm/692nm. They are respectively referred to as VioletFluorescence, GreenFluorescence, OrangeFluorescence, RedFluorescence, and DarkRedFluorescence.",
			"The picking algorithm filters the colonies using the min and max bounds of diameter, regularity, circularity, and isolation outside of the margin. Then the Populations option is used to group colonies into populations using the Diameter, Isolation, Regularity, Circularity, Fluorescence, BlueWhiteScreen, MultiFeatured, or AllColonies Unit Operation.",
			"The counting algorithm identifies the singleton colonies on the plate and then estimates the number of colonies in colony clusters by dividing each cluster by the average area of a singleton. As a result, the total estimated colonies can be fractional."
		},
		(* interactivity options *)
		Preview -> True,
		PreviewOptions -> {
			"Populations",
			"ManualPickTargets",
			"IncludedColonies"
		},
		ButtonActionsGuide -> {
			{Description -> "Pan image", ButtonSet -> "'Shift' + 'LeftDrag'"},
			{Description -> "Zoom image", ButtonSet -> "'LeftDrag'"},
			{Description -> "Add measurement line", ButtonSet -> "'Control' + 'LeftDrag'"},
			{Description -> "Change image type", ButtonSet -> "'Option'"},
			{Description -> "Move colony target", ButtonSet -> "'LeftDrag'"},
			{Description -> "Include or Exclude colony", ButtonSet -> "'LeftClick'"},
			{Description -> "Draw custom colony", ButtonSet -> "'Checkbox' + 'LeftDrag'"},
			{Description -> "Delete custom colony", ButtonSet -> "'Checkbox' + 'RightClick'"}
		}
	}
];

DefineUsage[Diameter,
	{
		BasicDefinitions -> {
			{"Diameter[diameterRules]", "primitive", "generates a population selection 'primitive' that groups a set of colonies by their diameter."}
		},
		Input :> {
			{
				"diameterRules",
				{_Rule..},
				"Key/value pairs that define a set of colonies into a population based on their diameter."
			}
		},
		Output :> {
			{"primitive", _Diameter, "A primitive that specifies a population of colonies based on their diameter."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"AnalyzeColonies",
			"Isolation",
			"Regularity",
			"Circularity",
			"BlueWhiteScreen",
			"Fluorescence",
			"AllColonies",
			"MultiFeatured"
		},
		Author -> {"scicomp"}
	}
];

DefineUsage[Isolation,
	{
		BasicDefinitions -> {
			{"Isolation[isolationRules]", "primitive", "generates a population selection 'primitive' that groups a set of colonies by their isolation."}
		},
		Input :> {
			{
				"isolationRules",
				{_Rule..},
				"Key/value pairs that define a set of colonies into a population based on their isolation."
			}
		},
		Output :> {
			{"primitive", _Isolation, "A primitive that specifies a population of colonies based on their isolation."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"AnalyzeColonies",
			"Diameter",
			"Regularity",
			"Circularity",
			"BlueWhiteScreen",
			"Fluorescence",
			"AllColonies",
			"MultiFeatured"
		},
		Author -> {"scicomp"}
	}
];

DefineUsage[Regularity,
	{
		BasicDefinitions -> {
			{"Regularity[regularityRules]", "primitive", "generates a population selection 'primitive' that groups a set of colonies by their regularity."}
		},
		Input :> {
			{
				"regularityRules",
				{_Rule..},
				"Key/value pairs that define a set of colonies into a population based on their regularity."
			}
		},
		Output :> {
			{"primitive", _Regularity, "A primitive that specifies a population of colonies based on their regularity."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"AnalyzeColonies",
			"Diameter",
			"Isolation",
			"Circularity",
			"BlueWhiteScreen",
			"Fluorescence",
			"AllColonies",
			"MultiFeatured"
		},
		Author -> {"scicomp"}
	}
];

DefineUsage[Circularity,
	{
		BasicDefinitions -> {
			{"Circularity[circularityRules]", "primitive", "generates a population selection 'primitive' that groups a set of colonies by their circularity."}
		},
		Input :> {
			{
				"circularityRules",
				{_Rule..},
				"Key/value pairs that define a set of colonies into a population based on their circularity."
			}
		},
		Output :> {
			{"primitive", _Circularity, "A primitive that specifies a population of colonies based on their circularity."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"AnalyzeColonies",
			"Diameter",
			"Isolation",
			"Regularity",
			"BlueWhiteScreen",
			"Fluorescence",
			"AllColonies",
			"MultiFeatured"
		},
		Author -> {"scicomp"}
	}
];

DefineUsage[BlueWhiteScreen,
	{
		BasicDefinitions -> {
			{"BlueWhiteScreen[blueWhiteScreenRules]", "primitive", "generates a population selection 'primitive' that groups a set of colonies by the average pixel value inside the colony boundary from a BlueWhiteScreen image."}
		},
		Input :> {
			{
				"blueWhiteScreenRules",
				{_Rule..},
				"Key/value pairs that define a set of colonies into a population based on their BlueWhiteScreen feature."
			}
		},
		Output :> {
			{"primitive", _BlueWhiteScreen, "A primitive that specifies a population of colonies based on their BlueWhiteScreen feature."}
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
		Author -> {"scicomp"}
	}
];

DefineUsage[Fluorescence,
	{
		BasicDefinitions -> {
			{"Fluorescence[fluorescenceRules]", "primitive", "generates a population selection 'primitive' that groups a set of colonies by the average pixel value inside the colony boundary from various fluorescence images."}
		},
		Input :> {
			{
				"fluorescenceRules",
				{_Rule..},
				"Key/value pairs that define a set of colonies into a population based on their fluorescence."
			}
		},
		Output :> {
			{"primitive", _Fluorescence, "A primitive that specifies a population of colonies based on their fluorescence."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"AnalyzeColonies",
			"Diameter",
			"Isolation",
			"Regularity",
			"Circularity",
			"BlueWhiteScreen",
			"AllColonies",
			"MultiFeatured"
		},
		Author -> {"scicomp"}
	}
];

DefineUsage[MultiFeatured,
	{
		BasicDefinitions -> {
			{"MultiFeatured[multiFeaturedRules]", "primitive", "generates a population selection 'primitive' that groups a set of colonies by multiple features, including Diameter, Regularity, Isolation, Circularity, BlueWhiteScreen, and Fluorescence."}
		},
		Input :> {
			{
				"multiFeaturedRules",
				{_Rule..},
				"Key/value pairs that define a set of colonies into a population by multiple features, including Diameter, Regularity, Isolation, Circularity, BlueWhiteScreen, and Fluorescence."
			}
		},
		Output :> {
			{"primitive", _MultiFeatured, "A primitive that specifies a population of colonies with multiple features."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"AnalyzeColonies",
			"Diameter",
			"Isolation",
			"Regularity",
			"Circularity",
			"BlueWhiteScreen",
			"Fluorescence",
			"AllColonies"
		},
		Author -> {"scicomp"}
	}
];

DefineUsage[AllColonies,
	{
		BasicDefinitions -> {
			{"AllColonies[allColoniesRules]", "primitive", "generates a population selection 'primitive' that groups every filtered colony into a single classification. The filter options include Min/MaxDiameter, Min/MaxCircularityRatio, Min/MaxRegularityRatio, MinColonySeparation and Margin."}
		},
		Input :> {
			{
				"allColoniesRules",
				{_Rule..},
				"Key/value pairs that define a set of colonies within a single classification."
			}
		},
		Output :> {
			{"primitive", _AllColonies, "A primitive that specifies all colonies into a single classification."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"AnalyzeColonies",
			"Diameter",
			"Isolation",
			"Regularity",
			"Circularity",
			"BlueWhiteScreen",
			"Fluorescence",
			"MultiFeatured"
		},
		Author -> {"scicomp"}
	}
];
