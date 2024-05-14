(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

$AnalyzeColoniesResolvedOptions = {};

(* storage of properties *)
colonyPropertyColumns = <|
	Location -> 1,
	Boundary -> 2,
	Diameter -> 3,
	Isolation -> 4,
	Regularity -> 5,
	Circularity -> 6,
	Absorbance -> 7,
	VioletFluorescence -> 8,
	GreenFluorescence -> 9,
	OrangeFluorescence -> 10,
	RedFluorescence -> 11,
	DarkRedFluorescence -> 12
|>;

(* fluorescence wavelength pairs *)
wavelengthFluorescenceColors = AssociationThread[
	List @@ QPixFluorescenceWavelengthsP,
	{
		VioletFluorescence,
		GreenFluorescence,
		OrangeFluorescence,
		RedFluorescence,
		DarkRedFluorescence
	}
];

(* fluorescence wavelength pair with Dye *)
(* Note that Blue and GFP use the same wavelengths *)
fluorescenceDyeTable = AssociationThread[
	{
		UltraViolet, GFP, Blue, Cy3, TxRed, Red
	},
	{
		{Quantity[377, "Nanometers"], Quantity[447, "Nanometers"]},
		{Quantity[457, "Nanometers"], Quantity[536, "Nanometers"]},
		{Quantity[457, "Nanometers"], Quantity[536, "Nanometers"]},
		{Quantity[531, "Nanometers"], Quantity[593, "Nanometers"]},
		{Quantity[531, "Nanometers"], Quantity[624, "Nanometers"]},
		{Quantity[628, "Nanometers"], Quantity[692, "Nanometers"]}
	}
];

(* note that that in the inverted table we always find GFP and not Blue *)
dyeFluorescenceTable = AssociationThread[
	{
		{Quantity[377, "Nanometers"], Quantity[447, "Nanometers"]},
		{Quantity[457, "Nanometers"], Quantity[536, "Nanometers"]},
		{Quantity[531, "Nanometers"], Quantity[593, "Nanometers"]},
		{Quantity[531, "Nanometers"], Quantity[624, "Nanometers"]},
		{Quantity[628, "Nanometers"], Quantity[692, "Nanometers"]}
	},
	{
		UltraViolet, GFP, Cy3, TxRed, Red
	}
];

(* shared options for small primitives *)
DefineOptionSet[AnalyzeColoniesFeatureOptions :> {
	{
		OptionName->NumberOfColonies,
		Default->Automatic,
		Description->"The upper limit for the count of colonies in the population.",
		ResolutionDescription->"If Select is Min or Max, up to 10 colonies are selected, otherwise All colonies are selected.",
		AllowNull->True,
		Category->"Characterization",
		Widget->Alternatives[
			Widget[Type -> Number, Pattern :> GreaterEqualP[2, 1]],
			Widget[Type -> Enumeration, Pattern :> Alternatives[All]]
		],
		Required->False
	},
	{
		OptionName->NumberOfDivisions,
		Default->Automatic,
		Description->"The number of partitions to group colonies into. Partitions are ordered by the Unit Operation feature. If the Select option is Min or Max, the lowest or highest partition will be used, respectively.",
		ResolutionDescription->"If Select is Min or Max, set to 2.",
		AllowNull->True,
		Category->"Characterization",
		Widget->Widget[Type -> Number, Pattern :> GreaterEqualP[2, 1]],
		Required->False
	},
	{
		OptionName->PopulationName,
		Default->Automatic,
		Description->"The name used to reference the population of colonies.",
		ResolutionDescription->"By default, each population is labeled as ColonySelection with sequential integers.",
		AllowNull->False,
		Category->"Characterization",
		Widget->Widget[Type->String,Pattern:>_String,Size->Word],
		Required->False
	},
	{
		OptionName -> Include,
		Default -> {},
		Description -> "Coordinates of colonies included in the selection even if they do not match the selection criteria.",
		AllowNull -> False,
		Widget -> Alternatives[Adder[
			{
				"X" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Millimeter], Units -> Millimeter],
				"Y" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Millimeter], Units -> Millimeter]
			}
		], Widget[Type -> Enumeration, Pattern :> Alternatives[None]]],
		Required -> False,
		Category -> "Characterization"
	},
	
	{
		OptionName -> Exclude,
		Default -> {},
		Description -> "Coordinates of colonies excluded from the selection even if they match the selection criteria.",
		AllowNull -> True,
		Category -> "Characterization",
		Widget -> Alternatives[Adder[
			{
				"X" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Millimeter], Units -> Millimeter],
				"Y" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Millimeter], Units -> Millimeter]
			}
		], Widget[Type -> Enumeration, Pattern :> Alternatives[None]]],
		Required -> False,
		Category -> "Characterization"
	}
}
];

(* Primitive specific values *)
featurePrimitiveOptions = {
	OutputUnitOperationParserFunction -> None,
	FastTrack -> True,
	InputOptions -> {Select},
	Generative -> False,
	Category -> "Colony Picking"
};

(* All PRIMITIVE *)
allPrimitive=DefinePrimitive[AllColonies,
	Options:>{
		ModifyOptions[AnalyzeColoniesFeatureOptions, {PopulationName, Include, Exclude}]
	},
	Sequence@@featurePrimitiveOptions,
	Icon -> Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","All.png"}]],
	Description -> "Specifies every filtered colony into a population."
];
DefinePrimitiveSet[AllColoniesPrimitiveP,{allPrimitive}];

(* DIAMETER PRIMITIVE *)
diameterPrimitive=DefinePrimitive[Diameter,
	Options:>{
		{
			OptionName->Select,
			Default->Automatic,
			Description->"The method used to group colonies into a population. Colonies are first ordered by their Diameter, defined as the diameter of a colony is the diameter of a disk with the same area as the colony. If the Select option is Min or Max, the ordered colonies are divided into partitions based on the NumberOfDivisions. From there, the smallest or largest partition is grouped into a population depending on if the Select option is Min or Max. For example, if the Select option is set to Max and the NumberOfDivisions is 10, the colonies will be divided into 10 partitions sorted from smallest to largest and the partition with the largest colonies will be selected as the population. Alternatively, if the Select option is AboveThreshold or BelowThreshold, an absolute cutoff is used to group ordered colonies into a population. The threshold is set by the ThresholdDiameter option. For example, if the Select option is BelowThreshold and the ThresholdDiameter is 0.8 Millimeter, all colonies smaller than 0.8 Millimeter in Diameter are grouped into a population.",
			ResolutionDescription->"If the Threshold is specified, set to AboveThreshold, otherwise set to Max.",
			AllowNull->False,
			Category->"Characterization",
			Widget-> Widget[Type -> Enumeration, Pattern :> Alternatives[Min, Max, AboveThreshold, BelowThreshold]],
			Required->False
		},
		{
			OptionName->ThresholdDiameter,
			Default->Null,
			Description->"The min or max possible diameter for a colony to be included in the population. When the Select option is AboveThreshold or BelowThreshold, all colonies with a diameter larger or smaller than the ThresholdDiameter, respectively, are grouped into a population. The colony diameter is defined as the diameter of a disk with the same area as the colony.",
			AllowNull->True,
			Category->"Characterization",
			Widget->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Millimeter],Units->Alternatives[Millimeter]],
			Required->False
		}
	},
	SharedOptions:>{AnalyzeColoniesFeatureOptions},
	
	Sequence@@featurePrimitiveOptions,
	Icon -> Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","Diameter.png"}]],
	Description -> "Specifies the population of colonies to be selected by their diameter. The diameter is defined as the diameter of a disk with the same area as the colony."
];
DefinePrimitiveSet[DiameterPrimitiveP,{diameterPrimitive}];

(* ISOLATION PRIMITIVE *)
isolationPrimitive=DefinePrimitive[Isolation,
	Options:>{
		{
			OptionName->Select,
			Default->Automatic,
			Description->"The method used to group colonies into a population. Colonies are first ordered by their Isolation, the shortest distance from the boundary of the colony to the boundary of another. If the Select option is Min or Max, the ordered colonies are divided into partitions based on the NumberOfDivisions. From there, the least isolated or most isolated partition is grouped into a population depending on if the Select option is Min or Max. For example, if the Select option is set to Max and the NumberOfDivisions is 10, the colonies will be divided into 10 partitions sorted from least isolated to most isolated and the partition with the most isolated colonies will be selected as the population. Alternatively, if the Select option is AboveThreshold or BelowThreshold, an absolute cutoff is used to group ordered colonies into a population. The threshold is set by the ThresholdDistance option. For example, if the Select option is AboveThreshold and the ThresholdDistance is 1 Millimeter, all colonies with separation greater than 1 Millimeter are grouped into a population.",
			ResolutionDescription->"If the Threshold is specified, set to AboveThreshold, otherwise set to Max.",
			AllowNull->False,
			Category->"Characterization",
			Widget-> Widget[Type -> Enumeration, Pattern :> Alternatives[Min, Max, AboveThreshold, BelowThreshold]],
			Required->False
		},
		{
			OptionName->ThresholdDistance,
			Default->Null,
			Description->"The min or max possible isolation for a colony to be included in the population. When the Select option is AboveThreshold or BelowThreshold, all colonies with an isolation distance larger or smaller than the ThresholdDistance, respectively, are grouped into a population. The isolation is the shortest distance from the boundary of the colony to the boundary of another.",
			AllowNull->True,
			Category->"Characterization",
			Widget->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Millimeter],Units->Alternatives[Millimeter]],
			Required->False
		}
	},
	SharedOptions:>{AnalyzeColoniesFeatureOptions},
	
	Sequence@@featurePrimitiveOptions,
	Icon -> Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","Isolation.png"}]],
	Description -> "Specifies the population of colonies to be selected by their isolation. The isolation is the shortest distance from the boundary of the colony to the boundary of another."
];
DefinePrimitiveSet[IsolationPrimitiveP,{isolationPrimitive}];

(* REGULARITY PRIMITIVE *)
regularityPrimitive=DefinePrimitive[Regularity,
	Options:>{
		{
			OptionName->Select,
			Default->Automatic,
			Description->"The method used to group colonies into a population. Colonies are first ordered by their Regularity, the ratio of the area of the colony to the area of a circle with the same perimeter. If the Select option is Min or Max, the ordered colonies are divided into partitions based on the NumberOfDivisions. From there, the least regular or most regular partition is grouped into a population depending on if the Select option is Min or Max. For example, if the Select option is set to Max and the NumberOfDivisions is 10, the colonies will be divided into 10 partitions sorted from least regular to most regular and the partition with the most regular colonies will be selected as the population. Alternatively, if the Select option is AboveThreshold or BelowThreshold, an absolute cutoff is used to group ordered colonies into a population. The threshold is set by the ThresholdRegularity option. For example, if the Select option is AboveThreshold and the ThresholdRegularity is 0.9, all colonies with a regularity ratio greater than 0.9 are grouped into a population.",
			ResolutionDescription->"If the Threshold is specified, set to AboveThreshold, otherwise set to Max.",
			AllowNull->False,
			Category->"Characterization",
			Widget-> Widget[Type -> Enumeration, Pattern :> Alternatives[Min, Max, AboveThreshold, BelowThreshold]],
			Required->False
		},
		{
			OptionName->ThresholdRegularity,
			Default->Null,
			Description->"The min or max possible regularity ratio for a colony to be included in the population. When the Select option is AboveThreshold or BelowThreshold, all colonies with a regularity ratio larger or smaller than the ThresholdRegularity, respectively, are grouped into a population. The colony regularity ratio is the ratio of the area of the colony to the area of a circle with the same perimeter.",
			AllowNull->True,
			Category->"Characterization",
			Widget->Widget[Type->Number,Pattern:>RangeP[0,1]],
			Required->False
		}
	},
	SharedOptions:>{AnalyzeColoniesFeatureOptions},
	
	Sequence@@featurePrimitiveOptions,
	Icon -> Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","Regularity.png"}]],
	Description -> "Specifies the population of colonies to be selected by their regularity ratio. The regularity ratio is the ratio of the area of the colony to the area of a circle with the same perimeter."
];
DefinePrimitiveSet[RegularityPrimitiveP,{regularityPrimitive}];

(* CIRCULARITY PRIMITIVE *)
circularityPrimitive=DefinePrimitive[Circularity,
	Options:>{
		{
			OptionName->Select,
			Default->Automatic,
			Description->"The method used to group colonies into a population. Colonies are first ordered by their Circularity, the ratio of the minor axis to the major axis of the best fit ellipse. If the Select option is Min or Max, the ordered colonies are divided into partitions based on the NumberOfDivisions. From there, the least circular or most circular partition is grouped into a population depending on if the Select option is Min or Max. For example, if the Select option is set to Max and the NumberOfDivisions is 10, the colonies will be divided into 10 partitions sorted from least circular to most circular and the partition with the most circular colonies will be selected as the population. Alternatively, if the Select option is AboveThreshold or BelowThreshold, an absolute cutoff is used to group ordered colonies into a population. The threshold is set by the ThresholdCircularity option. For example, if the Select option is AboveThreshold and the ThresholdCircularity is 0.9, all colonies with a circularity ratio greater than 0.9 are grouped into a population.",
			ResolutionDescription->"If the Threshold is specified, set to AboveThreshold, otherwise set to Max.",
			AllowNull->False,
			Category->"Characterization",
			Widget-> Widget[Type -> Enumeration, Pattern :> Alternatives[Min, Max, AboveThreshold, BelowThreshold]],
			Required->False
		},
		{
			OptionName->ThresholdCircularity,
			Default->Null,
			Description->"The min or max possible circularity ratio for a colony to be included in the population. When the Select option is AboveThreshold or BelowThreshold, all colonies with a circularity ratio larger or smaller than the ThresholdCircularity, respectively, are grouped into a population. The colony circularity ratio is the ratio of the minor axis to the major axis of the best fit ellipse.",
			AllowNull->True,
			Category->"Characterization",
			Widget->Widget[Type->Number,Pattern:>RangeP[0,1]],
			Required->False
		}
	},
	SharedOptions:>{AnalyzeColoniesFeatureOptions},
	
	Sequence@@featurePrimitiveOptions,
	Icon -> Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","Circularity.png"}]],
	Description -> "Specifies the population of colonies to be selected by their circularity ratio. The circularity ratio is the ratio of the minor axis to the major axis of the best fit ellipse."
];
DefinePrimitiveSet[CircularityPrimitiveP,{circularityPrimitive}];

absorbancePrimitive=DefinePrimitive[Absorbance,
	Options:>{
		{
			OptionName->Color,
			Default->Blue,
			Description->"The color of the optical filter placed between the camera and the plate of colonies. Colonies that are the same color as the filter appear lighter, while those that are a different color appear darker. For example, with a red filter, white colonies will show up lighter because the red component of the white light is not blocked by the filter. However, blue colonies appear darker because the blue light is blocked by the red filter.",
			AllowNull->False,
			Category->"Characterization",
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Blue]],
			Required->False
		},
		{
			OptionName->FilterWavelength,
			Default->Quantity[400, Nanometer],
			Description->"The mean wavelength of light allowed to pass through the optical filter. Colonies that are near the same wavelength as the filter appear lighter, while those that are a different wavelength appear darker. For example, with a red filter, white colonies will show up lighter because the red component of the white light, which has a wavelength around 650 nanometers, is not blocked by the filter. However, blue colonies, which have a wavelength around 450 nanometers, appear darker because the blue light is blocked by the red filter.",
			AllowNull->False,
			Category->"Characterization",
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Quantity[400, Nanometer]]],
			Required->False
		},
		{
			OptionName->Select,
			Default->Automatic,
			Description->"The method used to group colonies into a population. Colonies are first ordered by their absorbance, the average pixel value inside the colony boundary from an image generated using a light filter. If the Select option is Min or Max, the ordered colonies are divided into partitions based on the NumberOfDivisions. From there, the least bright or most bright partition is grouped into a population depending on if the Select option is Min or Max. For example, if the Select option is set to Max and the NumberOfDivisions is 10, the colonies will be divided into 10 partitions sorted from least bright to most bright and the most bright partition will be selected as the population. Alternatively, if the Select option is Positive or Negative, the ordered colonies are first clustered into two groups based on their Absorbance. Then, if the Select option is Positive, the group with the higher brightness is selected as the population. However, if the Select option is Negative, the group with the lower brightness values are chosen as the population.",
			ResolutionDescription->"If the NumberOfDivisions is specified, set to Max, otherwise set to Positive.",
			AllowNull->False,
			Category->"Characterization",
			Widget-> Widget[Type -> Enumeration, Pattern :> Alternatives[Min, Max, Positive, Negative]],
			Required->False
		}
	},
	SharedOptions:>{AnalyzeColoniesFeatureOptions},
	
	Sequence@@featurePrimitiveOptions,
	Icon -> Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","Absorbance.png"}]],
	Description -> "Specifies the population of colonies to be selected by their absorbance. The absorbance is the average pixel value inside the colony boundary from an image generated using a light filter."
];
DefinePrimitiveSet[AbsorbancePrimitiveP,{absorbancePrimitive}];

fluorescencePrimitive=DefinePrimitive[Fluorescence,
	Options:>{
		{
			OptionName->Dye,
			Default->Automatic,
			Description->"The coloring used to detect colonies that fluoresce at an EmissionWavelength when exposed to an ExcitationWavelength.",
			ResolutionDescription->"Automatically set to the dye of the excitation and emission wavelength pair specified in the Object[Data, Microscope].",
			AllowNull->False,
			Category->"Characterization",
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[UltraViolet, GFP, Blue, Cy3, TxRed, Red]],
			Required->False
		},
		{
			OptionName->ExcitationWavelength,
			Default->Automatic,
			Description->"The wavelength of light that adds energy to colonies and causes them to fluoresce. Pairs with an EmissionWavelength.",
			ResolutionDescription->"Automatically set to the excitation wavelength pair specified in the Object[Data, Microscope].",
			AllowNull->False,
			Category->"Characterization",
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Quantity[377, Nanometer], Quantity[457, Nanometer], Quantity[531, Nanometer], Quantity[628, Nanometer]]],
			Required->False
		},
		{
			OptionName->EmissionWavelength,
			Default->Automatic,
			Description->"The light that the instrument measures to detect colonies fluorescing at a particular wavelength. Pairs with an ExcitationWavelength.",
			ResolutionDescription->"Automatically set to the emission wavelength pair specified in the Object[Data, Microscope].",
			AllowNull->False,
			Category->"Characterization",
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Quantity[447, Nanometer], Quantity[536, Nanometer], Quantity[593, Nanometer], Quantity[624, Nanometer], Quantity[692, Nanometer]]],
			Required->False
		},
		{
			OptionName->Select,
			Default->Automatic,
			Description->"The method used to group colonies into a population. Colonies are first ordered by their Fluorescence, the average pixel value inside the colony boundary from an image generated using an excitation wavelength and emission filter. If the Select option is Min or Max, the ordered colonies are divided into partitions based on the NumberOfDivisions. From there, the least fluorescing or most fluorescing partition is grouped into a population depending on if the Select option is Min or Max. For example, if the Select option is set to Max and the NumberOfDivsions is 10, the colonies will be divided into 10 partitions sorted from least fluorescing to most fluorescing and the most fluorescing partition will be selected as the population. Alternatively, if the Select option is Positive or Negative, the ordered colonies are first clustered into two groups based on their Fluorescence. Then, if the Select option is Positive, the group with the higher fluorescing values is selected as the population. However, if the Select option is Negative, the group with the lower fluorescence values are chosen as the population.",
			ResolutionDescription->"If the NumberOfDivisions is specified, set to Max, otherwise set to Positive.",
			AllowNull->False,
			Category->"Characterization",
			Widget-> Widget[Type -> Enumeration, Pattern :> Alternatives[Min, Max, Positive, Negative]],
			Required->False
		}
	},
	SharedOptions:>{AnalyzeColoniesFeatureOptions},
	
	Sequence@@featurePrimitiveOptions,
	Icon -> Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","Fluorescence.png"}]],
	Description -> "Specifies the population of colonies to be selected by their fluorescence. The fluorescence is the average pixel value inside the colony boundary from an image generated using an excitation wavelength and emission filter."
];
DefinePrimitiveSet[FluorescencePrimitiveP,{fluorescencePrimitive}];

multiFeaturedPrimitive = DefinePrimitive[MultiFeatured,
	Options :> {
		IndexMatching[
			IndexMatchingParent -> Features,
			{
				OptionName -> Features,
				Default -> {Isolation, Diameter},
				Description -> "The characteristics selected from Diameter, Regularity, Isolation, Circularity, Absorbance, and Fluorescence of the colony by which the population will be isolated. For example, if Features is set to {Isolation, Diameter}, the colonies that are both larger than the median colony and more fluorescing than the median colony will be grouped into a population. More than one feature must be specified, otherwise the individual feature Unit Operation should be used. Colonies that match all features in the MultiFeatured unit operation will be included in the population.",
				AllowNull -> False,
				Category -> "Characterization",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> ColonySelectionFeatureP
				],
				Required -> True
			},
			{
				OptionName->Select,
				Default->Automatic,
				Description->"The method used to group colonies into a population. Colonies are first ordered by their Feature. If the Select option is Min or Max, the ordered colonies are divided into partitions based on the NumberOfDivisions. From there, the smallest or largest partition is grouped into a population depending on if the Select option is Min or Max. For example, if the Select option is set to Max and the NumberOfDivsions is 10, the colonies will be divided into 10 partitions sorted by the Feature and the highest partition will become the selected population. If the Select option is AboveThreshold or BelowThreshold, an absolute cutoff is used to group ordered colonies into a population. The threshold values is set by the Threshold option. For example, if the Select option is BelowThreshold, the Feature is Diameter, and the Threshold is 0.8 Millimeter, all colonies with Diameter less than 0.8 Millimeter will be selected as the population. If the Select option is Positive or Negative, the colonies are first clustered into two groups based on their Fluorescence or Absorbance. Then, if the Select option is Positive, the group with the higher Fluorescing or Absorbance values is selected as the population. However, if the Select option is Negative, the group with the lower Fluorescence or Absorbance values are chosen as the population.",
				ResolutionDescription -> "For Diameter, Isolation, Regularity, and Circularity features the default is Max unless a Threshold is specified, in which case the default is AboveThreshold. For Fluorescence and Absorbance the default is Positive, unless the NumberOfDivisions is specified, in which case the default is Max.",
				AllowNull->False,
				Category->"Characterization",
				Widget-> Widget[Type -> Enumeration, Pattern :> Alternatives[Min, Max, AboveThreshold, BelowThreshold, Positive, Negative]],
				Required->False
			},
			{
				OptionName->NumberOfDivisions,
				Default->Automatic,
				Description->"The number of partitions to group colonies into. Partitions are ordered by the Features. If the Select option is Min or Max, the lowest or highest partition will be used, respectively.",
				ResolutionDescription -> "If the Select option is set to Min or Max, set NumberOfDivisions to 2.",
				AllowNull->True,
				Category->"Characterization",
				Widget->Widget[Type -> Number, Pattern :> GreaterEqualP[2, 1]],
				Required->False
			},
			{
				OptionName->Threshold,
				Default->Null,
				Description->"The min or max possible feature value (e.g., Diameter or Regularity) for a colony to be included in the population. When the Select option is AboveThreshold or BelowThreshold, all colonies with a feature value larger or smaller than the Threshold, respectively, are grouped into a population.",
				AllowNull->True,
				Category->"Characterization",
				Widget->Alternatives[
					Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Millimeter],Units->Alternatives[Millimeter]],
					Widget[Type->Number,Pattern:>RangeP[0,1]]
				],
				Required->False
			},
			{
				OptionName->Color,
				Default->Automatic,
				Description->"The color of the optical filter placed between the camera and the plate of colonies. Colonies that are the same color as the filter appear lighter, while those that are a different color appear darker. For example, with a red filter, white colonies will show up lighter because the red component of the white light is not blocked by the filter. However, blue colonies appear darker because the blue light is blocked by the red filter.",
				ResolutionDescription -> "If the feature is Absorbance, set to Blue.",
				AllowNull->True,
				Category->"Characterization",
				Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Blue]],
				Required->False
			},
			{
				OptionName->FilterWavelength,
				Default->Automatic,
				Description->"The mean wavelength of light allowed to pass through the optical filter. Colonies that are near the same wavelength as the filter appear lighter, while those that are a different wavelength appear darker. For example, with a red filter, white colonies will show up lighter because the red component of the white light, which has a wavelength around 650 nanometers, is not blocked by the filter. However, blue colonies, which have a wavelength around 450 nanometers, appear darker because the blue light is blocked by the red filter.",
				ResolutionDescription -> "If the feature is Absorbance, set to Quantity[400, Nanometer].",
				AllowNull->True,
				Category->"Characterization",
				Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Quantity[400, Nanometer]]],
				Required->False
			},
			{
				OptionName->Dye,
				Default->Automatic,
				Description->"The coloring used to detect colonies that fluoresce at an EmissionWavelength when exposed to an ExcitationWavelength.",
				ResolutionDescription->"Automatically set to the dye of the excitation and emission wavelength pair specified in the Object[Data, Microscope].",
				AllowNull->True,
				Category->"Characterization",
				Widget->Widget[Type->Enumeration,Pattern:>Alternatives[UltraViolet, GFP, Blue, Cy3, TxRed, Red]],
				Required->False
			},
			{
				OptionName->ExcitationWavelength,
				Default->Automatic,
				Description->"The wavelength of light that adds energy to colonies and causes them to fluoresce. Pairs with an EmissionWavelength.",
				ResolutionDescription->"Automatically set to the excitation wavelength pair specified in the Object[Data, Microscope].",
				AllowNull->True,
				Category->"Characterization",
				Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Quantity[377, Nanometer], Quantity[457, Nanometer], Quantity[531, Nanometer], Quantity[628, Nanometer]]],
				Required->False
			},
			{
				OptionName->EmissionWavelength,
				Default->Automatic,
				Description->"The light that the instrument measures to detect colonies fluorescing at a particular wavelength. Pairs with an ExcitationWavelength.",
				ResolutionDescription->"Automatically set to the emission wavelength pair specified in the Object[Data, Microscope].",
				AllowNull->True,
				Category->"Characterization",
				Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Quantity[447, Nanometer], Quantity[536, Nanometer], Quantity[593, Nanometer], Quantity[624, Nanometer], Quantity[692, Nanometer]]],
				Required->False
			}
		],
		ModifyOptions[AnalyzeColoniesFeatureOptions, {PopulationName, NumberOfColonies, Include, Exclude}]
	},
	
	OutputUnitOperationParserFunction -> None,
	FastTrack -> True,
	InputOptions -> {Feature},
	Generative -> False,
	Category -> "Colony Picking",
	Icon -> Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","MultiFeature.png"}]],
	Description -> "Specifies a group of colonies to be categorized as a population with multiple desired features, based on the colony Diameter, Isolation, Regularity, Circularity, Fluorescence, and Absorbance."

];
DefinePrimitiveSet[MultiFeaturedPrimitiveP, {multiFeaturedPrimitive}];

(* Define function options *)
DefineOptionSet[AnalyzeColoniesSharedOptions :> {
	IndexMatching[
		IndexMatchingInput -> "Microscope data",
		{
			OptionName -> AnalysisType,
			Default -> Pick,
			Description -> "For each data object, indicates if the function is only categorizing, counting, and characterizing colonies, or if it is also locating colonies on the plate for picking.",
			ResolutionDescription -> "If the data object is spawned by a picking protocol that is in process, set to Pick. If the protocol has completed or there is no protocol, set to Count.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Count, Pick]
			],
			Category -> "General"
		},
		{
			OptionName -> MinDiameter,
			Default -> 0.5 Millimeter,
			Description -> "For each data object, the smallest diameter value from which colonies or plaques will be included. The diameter is defined as the diameter of a circle with the same area as the colony.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterP[0 Millimeter],
				Units -> Millimeter
			],
			Category -> "Filtering"
		},
		{
			OptionName -> MaxDiameter,
			Default -> 2 Millimeter,
			Description -> "For each data object, the largest diameter value from which colonies or plaques will be included. The diameter is defined as the diameter of a circle with the same area as the colony.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterP[0 Millimeter],
				Units -> Millimeter
			],
			Category -> "Filtering"
		},
		{
			OptionName -> MinColonySeparation,
			Default -> 0.2 Millimeter,
			Description -> "For each data object, the closest distance included colonies can be from each other from which colonies or plaques will be included. The separation of a colony is the shortest path between the perimeter of the colony and the perimeter of any other colony.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterP[0 Millimeter],
				Units -> Millimeter
			],
			Category -> "Filtering"
		},
		{
			OptionName -> MinRegularityRatio,
			Default -> 0.65,
			Description -> "For each data object, the smallest regularity ratio from which colonies or plaques will be included. The regularity ratio is the ratio of the area of the colony to the area of a circle with the colony's perimeter. For example, jagged edged shapes will have a longer perimeter than smoother ones and therefore a smaller regularity ratio.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[0, 1]
			],
			Category -> "Filtering"
		},
		{
			OptionName -> MaxRegularityRatio,
			Default -> 1.0,
			Description -> "For each data object, the largest regularity ratio from which colonies or plaques will be included. The regularity ratio is the ratio of the area of the colony to the area of a circle with the colony's perimeter. For example, jagged edged shapes will have a longer perimeter than smoother ones and therefore a smaller regularity ratio.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[0, 1]
			],
			Category -> "Filtering"
		},
		{
			OptionName -> MinCircularityRatio,
			Default -> 0.65,
			Description -> "For each data object, the smallest circularity ratio from which colonies or plaques will be included. The circularity ratio is defined as the ratio of the minor axis to the major axis of the best fit ellipse. For example, a very oblong colony will have a much larger major axis compared to its minor axis and therefore a low circularity ratio.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[0, 1]
			],
			Category -> "Filtering"
		},
		{
			OptionName -> MaxCircularityRatio,
			Default -> 1.0,
			Description -> "For each data object, the largest circularity ratio from which colonies or plaques will be included. The circularity ratio is defined as the ratio of the minor axis to the major axis of the best fit ellipse. For example, a very oblong colony will have a much larger major axis compared to its minor axis and therefore a low circularity ratio.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[0, 1]
			],
			Category -> "Filtering"
		}
		
	]
}
];

DefineOptions[AnalyzeColonies,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "Microscope data",
				{
					OptionName -> IncludedColonies,
					Default -> {},
					Description -> "For each data object, the explicitly selected boundaries of colonies to include in the analysis by drawing on the interactive preview.",
					AllowNull -> False,
					Widget -> Adder[Widget[Type -> Expression, Pattern :> Alternatives[QuantityArrayP[{{Millimeter, Millimeter}..}], {{GreaterEqualP[0 Millimeter], GreaterEqualP[0 Millimeter]} ..}, {}], Size -> Line]],
					Category -> "Filtering"
				},
				{
					OptionName -> Populations,
					Default -> Automatic,
					Description -> "For each data object, the criteria used to group colonies together into a population and may be picked from for subsequent growth using protocols such as ColonyPicker. Criteria are based on the ordering of colonies by the desired feature(s): diameter, regularity, circularity, isolation, fluorescence, and absorbance. For more information see documentation on colony selection Unit Operations: Diameter, Isolation, Regularity, Circularity, Fluorescence, Absorbance, MultiFeatured, and AllColonies.",
					ResolutionDescription -> "If the excitation and emissions wavelengths in the Object[Data, Microscope] match one the instrument dyes, set to Fluorescence, otherwise set to All.",
					AllowNull -> False,
					Widget -> Alternatives[Adder[
						Alternatives[
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Fluorescence, Absorbance, Diameter, Isolation, Circularity, Regularity, All]
							],
							"Fluorescence"->Widget[
								Type -> UnitOperation,
								Pattern :> FluorescencePrimitiveP
							],
							"Absorbance"-> Widget[
								Type -> UnitOperation,
								Pattern :> AbsorbancePrimitiveP
							],
							"Diameter" -> Widget[
								Type -> UnitOperation,
								Pattern :> DiameterPrimitiveP
							],
							"Isolation"-> Widget[
								Type -> UnitOperation,
								Pattern :> IsolationPrimitiveP
							],
							"Circularity"->Widget[
								Type -> UnitOperation,
								Pattern :> CircularityPrimitiveP
							],
							"Regularity"->Widget[
								Type -> UnitOperation,
								Pattern :> RegularityPrimitiveP
							],
							"AllColonies"->Widget[
								Type -> UnitOperation,
								Pattern :> AllColoniesPrimitiveP
							],
							"MultiFeatured" -> Widget[
								Type -> UnitOperation,
								Pattern :> MultiFeaturedPrimitiveP
							]
						]
					],
						Alternatives[
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Fluorescence, Absorbance, Diameter, Isolation, Circularity, Regularity, All]
							],
							"Fluorescence"->Widget[
								Type -> UnitOperation,
								Pattern :> FluorescencePrimitiveP
							],
							"Absorbance"-> Widget[
								Type -> UnitOperation,
								Pattern :> AbsorbancePrimitiveP
							],
							"Diameter" -> Widget[
								Type -> UnitOperation,
								Pattern :> DiameterPrimitiveP
							],
							"Isolation"-> Widget[
								Type -> UnitOperation,
								Pattern :> IsolationPrimitiveP
							],
							"Circularity"->Widget[
								Type -> UnitOperation,
								Pattern :> CircularityPrimitiveP
							],
							"Regularity"->Widget[
								Type -> UnitOperation,
								Pattern :> RegularityPrimitiveP
							],
							"AllColonies"->Widget[
								Type -> UnitOperation,
								Pattern :> AllColoniesPrimitiveP
							],
							"MultiFeatured" -> Widget[
								Type -> UnitOperation,
								Pattern :> MultiFeaturedPrimitiveP
							]
						]
					],
					NestedIndexMatching -> True,
					Category -> "Characterization"
				},
				{
					OptionName -> ManualPickTargets,
					Default -> None,
					Description -> "For each data object, the custom target coordinates on the plate to be picked by a colony picking instrument.",
					AllowNull -> True,
					Widget -> Alternatives[
						Adder[
							{
								"X" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Millimeter], Units -> Millimeter],
								"Y" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Millimeter], Units -> Millimeter]
							}
						],
						Widget[Type -> Enumeration, Pattern :> Alternatives[None]]
					],
					Category -> "Picking"
				}
		],
		{
			OptionName -> ImageRequirement,
			Default -> True,
			Description -> "Indicates if missing image warnings should be surfaced.",
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Category -> "Hidden"
		},
		AnalyzeColoniesSharedOptions,
		OutputOption,
		UploadOption
	}
];

(* Warnings and Errors *)
Error::IndexMatchingPrimitive = "For the following data objects `1`, the population selection primitives at indices `2` are unable to be expanded and index match options. Please adjust option lengths in the primitive for the options {Feature, FeatureGrouping, BinarySelection, Divisions, Wavelength} to be the same length or singleton options which will be expanded to the appropriate dimension for index matching.";
Error::ExcessAlls = "For the following data objects `1`, the population selection primitives have more than 1 All. Please select only 1 All per data object.";
Error::MinCannotExceedMax = "For the following data objects `1`, the minimum criteria for, `2`, exceeds the maximum criteria. Please reduce the minimum criteria or increase the maximum criteria.";

Error::IncludeExcludeOverlap = "For the following data objects, `1`, the population selection primitives at indices `2` have at least one of the the same locations specified in the Exclude and Include options. Please ensure that each location is specified in only one of the Include and Exclude options.";
Error::AbsorbanceImageMissing = "For the following data objects `1`, the population selection primitives at indices `2` require Absorbance features, but the data objects do not have Images at the requested wavelengths. Please select wavelengths that correspond to images in the data objects.";
Error::FluorescentImageMissing = "For the following data objects `1`, the population selection primitives at indices `2` require Fluorescence features, but the data objects do not have Images at the requested wavelengths. Please select wavelengths that correspond to images in the data objects.";

Error::BothSelectMethods = "For the following data objects, `1`, the population selection primitives at indices `2`, use both the Threshold and Division option to select colonies. Please only use a single method, Threshold or Division.";
Error::ThresholdSelectConflict = "For the following data objects, `1`, the population selection primitives at indices `2`, the select method (AboveThreshold or BelowThreshold) expects a threshold, but the NumberOfDivsions was used instead. Please only select a threshold.";
Error::DivisionSelectConflict = "For the following data objects, `1`, the population selection primitives at indices `2`, the select method (Min or Max) expects a division, but a threshold was used. Please only select the NumberOfDivsions.";
Error::ThresholdMissing = "For the following data objects, `1`, the population selection primitives at indices `2`, the select method (AboveThreshold or BelowThreshold) expects a threshold. Please enter a threshold for the colony selection.";
Error::InvalidWavelengthPair = "For the following data objects, `1`, the population selection primitives at indices `2`, the excitation and emission wavelength are not a valid pair. Please select excitation and emission wavelength that form a valid pair from " <>ToString[QPixFluorescenceWavelengthsP] <>".";
Error::DyeWavelengthConflict = "For the following data objects, `1`, the population selection primitives at indices `2`, the excitation and emission wavelength pair does not match the wavelength pair that corresponds to the dye. Please specify either the dye or the excitation and emission wavelength pair.";
Error::NoAutomaticWavelength = "For the following data objects, `1`, the population selection primitives at indices `2`, the automatic excitation and emission wavelength could not be resolved from the information in Model[Cell] for the colonies. Please specify the dye or excitation and emission wavelength pair to use.";
Warning::SingleAutomaticWavelength = "For the following data objects, `1`, the population selection primitives at indices `2`, only the excitation or emission wavelength matches the information from Model[Cell]. The excitation and emission pair will still be used for fluorescent analysis.";
Error::IncorrectThresholdFormat = "For the following data objects, `1`, the population selection primitives at indices `2`, the feature expects a different threshold format. For Diameter and Isolation use Quantity[_, Millimeter] and for Circularity and Regularity use RangeP[0,1].";
Error::NotMultipleFeatures = "For the following data objects, `1`, the population selection primitives at indices `2`, multiple features are expected when using the MultiFeatured unit operation. If you only want to use a single feature, use the feature specific unit operations (e.g. Fluorescence).";
Error::RepeatedPopulationNames  = "For the following data objects, `1`, the population selection primitives at indices `2`, use the same PopulationName for multiple populations. Please make PopulationNames unique or let them be resolved automatically."

(* Main function *)
DefineAnalyzeFunction[
	AnalyzeColonies,
	<|
		InputData -> Alternatives[
			ObjectP[Object[Data, Appearance]],
			ObjectP[Object[Data, Appearance, Colonies]]
		]
	|>,
	{
		Batch[analyzeResolveInputColonies],
		Batch[analyzeResolveOptionsColonies],
		analyzeCalculateColonies,
		analyzePreviewColonies
	},
	FinalOptionsStep -> Batch[analyzeResolveOptionsColonies]
];

(* Resolve inputs on a packet input *)
analyzeResolveInputColonies[
	KeyValuePattern[{
		UnresolvedInputs -> KeyValuePattern[{
			InputData -> inputObject : ListableP[
				ObjectP[
					{
						Object[Data, Appearance],
						Object[Data, Appearance, Colonies]
					}
				]
			]
		}],
		Batch -> True
	}]
] := Module[
	{
		colonyImage, inputObjectReference, cellFluorescentExcitationRange,
		cellFluorescentEmissionRange, inputLength, analysisLinks, scale,
		violetFluorescenceImageFile, greenFluorescenceImageFile,
		orangeFluorescenceImageFile, redFluorescenceImageFile,
		darkRedFluorescenceImageFile, blueWhiteScreenImageFile,
		fluorescentImageFiles, fluorescentImages,
		fluorescenceWavelengthImages, absorbanceImages,
		absorbanceWavelengthImages, resolvedInputs,
		packet
	},
	
	inputLength = Length[inputObject];
	
	(* batch together downloading *)
	{
		colonyImage,
		cellFluorescentExcitationRange,
		cellFluorescentEmissionRange,
		inputObjectReference,
		scale,
		violetFluorescenceImageFile,
		greenFluorescenceImageFile,
		orangeFluorescenceImageFile,
		redFluorescenceImageFile,
		darkRedFluorescenceImageFile,
		blueWhiteScreenImageFile
	} = Quiet[
		Transpose[
			Download[
				inputObject,
				{
					ImageFile,
					CellTypes[[1]][FluorescentExcitationWavelength],
					CellTypes[[1]][FluorescentEmissionWavelength],
					Object,
					Scale,
					VioletFluorescenceImageFile,
					GreenFluorescenceImageFile,
					OrangeFluorescenceImageFile,
					RedFluorescenceImageFile,
					DarkRedFluorescenceImageFile,
					BlueWhiteScreenImageFile
				}
			]
		],
		(* added this because of the error with CellTypes[[1]] when no CellTypes present *)
		{Download::Part, Download::MissingField}
	];
	
	(* flatten the excitation/emission wavelengths to the expected level and replace empty lists with index match input of nulls *)
	cellFluorescentExcitationRange = Replace[cellFluorescentExcitationRange, $Failed -> Null, 1];
	cellFluorescentEmissionRange = Replace[cellFluorescentEmissionRange, $Failed -> Null, 1];
	
	(* import cloud file *)
	colonyImage = ImportCloudFile/@colonyImage;
	
	(* replace failed values with Null so ImportCloudFile works *)
	fluorescentImageFiles = {
		violetFluorescenceImageFile,
		greenFluorescenceImageFile,
		orangeFluorescenceImageFile,
		redFluorescenceImageFile,
		darkRedFluorescenceImageFile
	} /. $Failed -> Null;
	
	(* import the fluorescent image cloud files *)
	(* right now we assume 1 fluorescene image at a time and ImportCloudFile[Null] is fast, but should remove mapping *)
	fluorescentImages = ImportCloudFile/@Transpose[fluorescentImageFiles];
	
	(* crete an association for fluorescence images *)
	fluorescenceWavelengthImages = Map[
		AssociationThread[
			List @@ QPixFluorescenceWavelengthsP,
			#
		]&,
		fluorescentImages
	];
	
	blueWhiteScreenImageFile = blueWhiteScreenImageFile /. $Failed -> Null;
	
	(* import the absorbance image cloud files *)
	absorbanceImages = ImportCloudFile[blueWhiteScreenImageFile];
	
	absorbanceWavelengthImages = Map[
		AssociationThread[
			List @@ QPixAbsorbanceWavelengthsP,
			#
		]&,
		absorbanceImages
	];
	
	(* create an association of inputs *)
	resolvedInputs = ResolvedInputs -> <|
		ImageData -> colonyImage,
		InputData -> inputObject,
		CellFluorescentExcitationRange -> cellFluorescentExcitationRange,
		CellFluorescentEmissionRange -> cellFluorescentEmissionRange,
		InputObject -> inputObjectReference,
		(* default value of 21.9 Pixel/Millimeter comes from qpix values (need to connect this to preview without hardcoding *)
		Scale -> Convert[scale, Pixel/Millimeter] /. Null|$Failed -> 21.9 Pixel/Millimeter,
		FluorescenceWavelengthImages -> fluorescenceWavelengthImages, (*)KeyDrop[BatchTranspose[fluorescenceWavelengthImages], Batch], *)
		AbsorbanceWavelengthImages -> Flatten[absorbanceImages]
	|>;
	
	(* create reference links to the data objects *)
	analysisLinks = Link[#, ColonyAnalysis]& /@ inputObject;
	
	(* start filling the packet with the known information *)
	packet = Packet -> <|
		Type -> ConstantArray[Object[Analysis, Colonies], inputLength],
		Replace[Reference] -> analysisLinks
	|>;
	
	(* return the input in batch form *)
	<|
		resolvedInputs,
		packet,
		Batch -> True
	|>

];

colonySelectResolution[
	listedSelect_,
	inputObjects_,
	gatherTests_,
	cellFluorescentExcitationRange_,
	cellFluorescentEmissionRange_,
	fluorescenceWavelengthImages_,
	absorbanceImages_,
	imageRequirement_
] := Module[
	{
		safeSelect, safeSelectTests, resolvedColonySelect, resolvedColonySelectTests,
		resolutionError, failingObjectList, safeOpsBool, cleanSafeSelect, safeOpsErrors
	},
	
	(*
		call safe options for the primitive.
		safeSelect is the actual output with safe options.
		cleanSafeSelect contains resolutions that were cleaned up for further option resolution
	*)
	{
		safeSelect,
		cleanSafeSelect,
		safeSelectTests,
		safeOpsBool
	} = primitiveSafeOptions[
		listedSelect,
		inputObjects,
		gatherTests
	];
	
	(* resolve the primitive *)
	{
		resolvedColonySelect,
		resolvedColonySelectTests,
		resolutionError
	} = resolvePrimitive[
		cleanSafeSelect,
		inputObjects,
		gatherTests,
		cellFluorescentExcitationRange,
		cellFluorescentEmissionRange,
		fluorescenceWavelengthImages,
		absorbanceImages,
		imageRequirement
	];
	
	(* find the errors from the safe ops *)
	(* if any colony selection failed (safeOpsBool False) the whole object is listed as failed *)
	safeOpsErrors = Map[!Or @@ # &, safeOpsBool];
	
	(* find if any objects failed in safe ops or resolution *)
	failingObjectList = Or @@@ Transpose[{safeOpsErrors, resolutionError}];
	
	(*
		if there were errors in the safeOps put in the original safeSelect values
		because we swapped in a clean one temporarily to avoid a cascade of errors
	 *)
	resolvedColonySelect = MapThread[
		resolvedColonySelectionMap,
		{resolvedColonySelect, safeSelect, safeOpsBool}
	];
	
	(* return resolved select, tests, and if any failures occurred *)
	{resolvedColonySelect, {safeSelectTests, resolvedColonySelectTests}, failingObjectList}

];

(* function for second layer of mapping to swap in a clean select *)
resolvedColonySelectionMap[resolvedColonySelect_, safeSelect_, safeOpsErrors_] := MapThread[
	If[MatchQ[#3, False], #2, #1]&,
	{resolvedColonySelect, safeSelect, safeOpsErrors}
];

(* check if there are too many (more than 1) Unknowns in the Select input *)
excessAllQ[select : Except[_List]] := {False};
excessAllQ[select_List] := Map[Length[Cases[#, All]] > 1&, select];

excessAllTestsAndMessages[gatherTests_, booleans_, inputData_] := Module[
	{
		passingObjects, failingObjects
	},
	
	passingObjects = PickList[inputData, booleans, False];
	failingObjects = PickList[inputData, booleans, True];
	
	If[gatherTests,
		(* if gathering tests return the passing and failing tests *)
		{
			excessAllTestCreator[passingObjects, True],
			excessAllTestCreator[failingObjects, False]
		},
		
		(* otherwise send a message if there are failing objects *)
		If[Length[failingObjects] > 0,
			Message[Error::ExcessAlls, failingObjects]
		];
		(* Explicitly return Null *)
		Null
	]

];

(* for empty lists, return Null *)
excessAllTestCreator[{}, _] := Null;
(* test creator *)
excessAllTestCreator[inputObjects_, testBoolean_] := Test[
	"For the following data objects " <> ECL`InternalUpload`ObjectToString[inputObjects] <> ", the ColonySelection primitives do not have more than 1 All.",
	testBoolean,
	True
];


(*Resolve options - this is batched for the sake of messages/tests *)
analyzeResolveOptionsColonies[
	KeyValuePattern[{
		ResolvedInputs -> KeyValuePattern[{
			InputData -> inputData_,
			CellFluorescentExcitationRange -> cellFluorescentExcitationRange_,
			CellFluorescentEmissionRange -> cellFluorescentEmissionRange_,
			InputObject -> inputObjects_,
			FluorescenceWavelengthImages -> fluorescenceWavelengthImages_,
			AbsorbanceWavelengthImages -> absorbanceImages_
		}],
		ResolvedOptions -> KeyValuePattern[{
			Populations -> select_,
			MinRegularityRatio -> minRegularity_,
			MaxRegularityRatio -> maxRegularity_,
			MinCircularityRatio -> minCircularity_,
			MaxCircularityRatio -> maxCircularity_,
			MinDiameter -> minDiameter_,
			MaxDiameter -> maxDiameter_,
			MinColonySeparation -> minColonySeparation_,
			ImageRequirement -> imageRequirement_,
			ManualPickTargets -> manualPickTargets_,
			Output -> output_,
			AnalysisType -> analysisType_
		}],
		Batch -> True
	}]
] := Module[
	{
		gatherTests, resolvedSelect, resolvedSelectTests,
		regularityBool, circularityBool,  diameterBool, minMaxBooleans,
		minMaxObjectFailures, minMaxString, minMaxTests, testStrings, goodObjects,
		badObjects, passingTests, failingTests, colonySelections,
		selectFailures, invalidOptions, excessAllBoolean, excessAllsTest, minMaxObjectPasses,
		overallResolutionFailure, resolvedOptions, intermediates, inputTests, resolvedManualPickTargets,
		maxPlateDimension
	},
	
	(* check if output contains test *)
	gatherTests = MemberQ[Flatten[output], Tests];
	
	(* SELECT *)
	
	(* check for multiple All in select *)
	excessAllBoolean = excessAllQ[select];
	
	(* if there are excess Unknowns, issue an error or create the tests *)
	excessAllsTest = excessAllTestsAndMessages[gatherTests, excessAllBoolean, inputData];
	
	(* convert Automatic to correct defaults to be further resolved *)
	colonySelections = MapThread[
		Replace[ToList[#1],
			{
				All -> AllColonies[],
				Fluorescence -> Fluorescence[],
				Absorbance -> Absorbance[],
				Diameter -> Diameter[],
				Isolation -> Isolation[],
				Circularity -> Circularity[],
				Regularity -> Regularity[],
				(* If there are no Excitation/Emission wavelengths, set to All, otherwise set to Fluorescence *)
				Automatic -> If[And[
						MatchQ[cellFluorescentExcitationRange, ListableP[Null]],
						MatchQ[cellFluorescentEmissionRange, ListableP[Null]]
					],
					AllColonies[],
					Fluorescence[]
				]
			},
			{1}
		]&,
		{select, analysisType}
	];
	
	(* resolve the colony selections, get tests, and a boolean indicating failure *)
	{
		resolvedSelect,
		resolvedSelectTests,
		selectFailures
	} = colonySelectResolution[
		colonySelections,
		inputObjects,
		gatherTests,
		cellFluorescentExcitationRange,
		cellFluorescentEmissionRange,
		fluorescenceWavelengthImages,
		absorbanceImages,
		imageRequirement
	];
	
	(* OR the excessUnknownBoolean and select failures to indicate True is either one failed *)
	selectFailures = Or @@@ Transpose[{selectFailures, excessAllBoolean}];
	
	(* check if min < max for diameter, regularity, circularity *)
	regularityBool =  MapThread[Less, {minRegularity, maxRegularity}];
	circularityBool = MapThread[Less, {minCircularity, maxCircularity}];
	diameterBool = MapThread[Less, {minDiameter, maxDiameter}];
	
	(* list of booleans for bounds if errors occurred *)
	minMaxBooleans = {
		regularityBool,
		circularityBool,
		diameterBool
	};
	
	(* find which objects passed (all booleans are true) then flip so failures are true *)
	minMaxObjectPasses = And @@@ Transpose[minMaxBooleans];
	minMaxObjectFailures = Not /@ minMaxObjectPasses;
	
	(* look at the max booleans and combine them together *)
	overallResolutionFailure = Or @@@ (Transpose[{minMaxObjectFailures, selectFailures}]);
	
	(* create message if we are not gathering tests *)
	If[Not[gatherTests],
		
		(* string for the error messages *)
		minMaxString = {
			"Regularity",
			"Circularity",
			"Diameter"
		};
		
		(* write the error messages for the booleans *)
		MapThread[
			minMaxMessage[inputObjects, #1, #2]&,
			{minMaxBooleans, minMaxString}
		];
		
		(* find the invalid options to write failures *)
		invalidOptions = invalidOptionSelection[minMaxBooleans, selectFailures];
		
		(* write the messages for invalid options *)
		If[Length[invalidOptions] > 0,
			Message[Error::InvalidOption, Flatten[invalidOptions]]
		];
	
	];
	
	(* tests *)
	minMaxTests = If[gatherTests,
		
		(* test strings *)
		testStrings = {
			"the minimum regularity value cannot exceed the maximum regularity value:",
			"the minimum circularity value cannot exceed the maximum circularity value:",
			"the minimum diameter value cannot exceed the maximum diameter value:"
		};
		
		(* pull out the passing objects *)
		goodObjects = Map[
			PickList[inputObjects, #, True]&,
			minMaxBooleans
		];
		
		(* pull out the failing objects *)
		badObjects = Map[
			PickList[inputObjects, #, False]&,
			minMaxBooleans
		];
		
		(* create the passing and failing tests *)
		passingTests = MapThread[
			minMaxTestCreator[#1, True, #2]&,
			{goodObjects, testStrings}
		];
		
		failingTests = MapThread[
			minMaxTestCreator[#1, True, #2]&,
			{badObjects, testStrings}
		];
		
		(* return all tests *)
		{
			passingTests,
			failingTests
		},
		
		{}
	];
	
	(* resolve manual pick targets by deleting duplicates and resolving automatic to {} *)
	resolvedManualPickTargets = If[MatchQ[#, _List], DeleteDuplicates[#], #]&/@manualPickTargets;
	
	(* prepare the resolved options ahead of time *)
	resolvedOptions = ResolvedOptions -> <|
		Populations -> resolvedSelect,
		ManualPickTargets -> resolvedManualPickTargets
	|> ;
	
	(* intermediates *)
	intermediates = Intermediate -> <|
		Failures -> overallResolutionFailure,
		MaxPlateDimension -> ConstantArray[maxPlateDimension, Length[inputData]]
	|>;
	
	(* create test association *)
	inputTests = Tests -> <|
		(* put all tests in the first returned value *)
		resolvedOptionTests -> {
			(* combine all tests and only keep the EmeraldTests and get rid of Nulls *)
			Cases[
				Flatten[{
					ToList[minMaxTests],
					ToList[resolvedSelectTests],
					ToList[excessAllsTest]
				}],
				_EmeraldTest
			],
			
			(* create empty lists to match length of inputs for batch to work *)
			If[Length[inputData] > 1,
				Sequence@@ConstantArray[{}, Length[inputData] - 1],
				Nothing
			]
		}
	|>;
	
	<|
		resolvedOptions,
		intermediates,
		inputTests,
		Batch -> True
	|>

];

invalidOptionSelection[minMaxBooleans_, selectFailures_] := Module[
	{
		minMaxOptionPasses, minMaxOptionFailures, selectOptionFailure,
		optionFailures, invalidOptions
	},
	
	(* find which min max booleans had failures *)
	minMaxOptionPasses = And @@@ minMaxBooleans;
	(* flip the booleans so failures are true *)
	minMaxOptionFailures = Not /@ minMaxOptionPasses;
	
	(* find if the select option had a failure *)
	selectOptionFailure = {Or @@ selectFailures};
	
	(* using the booleans, select the relevant options that failed *)
	optionFailures = Join[selectOptionFailure, minMaxOptionFailures];
	
	(* select the invalid options where the option failures was True *)
	invalidOptions = PickList[
		{Populations, {MinRegularityRatio, MaxRegularityRatio}, {MinCircularityRatio, MaxCircularityRatio}, {MinDiameter, MaxDiameter}},
		optionFailures
	];
	
	Flatten[invalidOptions]

];

(* test generation of minMax tests *)
minMaxTestCreator[inputObjects_, testBoolean_, testString_] := Module[
	{
		introString, testConnectorString
	},
	
	(* test string *)
	introString = "For data object input ";
	testConnectorString = ", ";
	
	(* check if objects exist for the test *)
	If[Length[inputObjects] > 0,
		Test[introString <> ECL`InternalUpload`ObjectToString[inputObjects] <> testConnectorString <> testString,
			testBoolean,
			True
		],
		Nothing
	]

];

(* message function for min and max values *)
minMaxMessage[inputObjects_, boolean_, messageString_] := Module[
	{
		badObjects
	},
	
	(* find the offending objects *)
	badObjects = PickList[inputObjects, boolean, False];
	
	If[Length[badObjects] > 0,
		(* return a customized minMax message with the specific objects and message string *)
		Message[Error::MinCannotExceedMax, badObjects, messageString];
		(* return the boolean corresponding to if an error: False - error, True - passing *)
		False,
		True
	]

];

(*
	takes in a matrix of booleans that correspond to passing/failing booleans for
	object/option pairs and returns an association of objects and at what indices
	values of the boolean (true-passing, false-failing) were found
*)
objectOptionIndexAssociation[inputObjects_, objectOptionBooleans_, boolean_, mergingFunction_] := Module[
	{
		identifiedCoordinates, objectIndices, optionIndices, objectOptionAssociation, identifiedObjects
	},
	
	(* find the coordinates where primitiveLengthBooleans is false *)
	identifiedCoordinates = Position[objectOptionBooleans, boolean];
	
	(* 1 is index of the object and 2 is index of the Colony selection *)
	objectIndices = identifiedCoordinates[[;; , 1]];
	
	(* calculate the corresponding offending indices *)
	optionIndices = identifiedCoordinates[[;; , 2]];
	
	(* combine the object indices and their option indices *)
	objectOptionAssociation = Merge[Thread[objectIndices -> optionIndices], mergingFunction];
	
	(* pull out the objects corresponding to the object indices *)
	identifiedObjects = inputObjects[[Keys[objectOptionAssociation]]];
	
	(* return the objects and corresponding option indices *)
	{identifiedObjects, Values[objectOptionAssociation]}

];

(* modify bad primitives for testing purposes by distilling them down to simple blocks *)
modifyBadPrimitiveLength[primitiveOptions_, badObjectsIndices_, badOptionsIndices_] := Module[
	{
		badTuples
	},
	
	(* create tuples to from bad object and option indices *)
	badTuples = Flatten[
		MapThread[
			Tuples[{ToList[#1], ToList[#2]}]&,
			{badObjectsIndices, badOptionsIndices}
		],
		1
	];
	
	(* map at bad objects and options to replace bad options *)
	MapAt[
		cleanColonySelection,
		primitiveOptions,
		badTuples
	]

];

(* return a clean association that will not cause issues *)
cleanColonySelection[colonySelection_] := MultiFeatured[<|
	Features -> {Diameter, Diameter},
	Select -> {Max, Max},
	NumberOfDivisions -> {2, 2},
	Threshold -> {Automatic, Automatic},
	Color -> {Automatic, Automatic},
	FilterWavelength -> {Automatic, Automatic},
	Dye -> {Automatic, Automatic},
	ExcitationWavelength -> {Automatic, Automatic},
	EmissionWavelength -> {Automatic, Automatic},
	PopulationName -> "Index match failure",
	Include -> None,
	Exclude -> None,
	NumberOfColonies -> 10
|>];


(* upper level function to aggregate tests and errors *)
primitiveSafeOptions[primitiveOptions_, inputObjects_, gatherTests_] := Module[
	{
		resolvedPrimitiveSafeOption, primitiveLengthBooleans, combinedResults,
		badObjectsIndices, badOptionsIndices, primitiveSafeTests, badObjects,
		failingPrimitiveLengthsQTest, goodObjects, goodOptions, passingPrimitiveLengthsQTest,
		cleanResolvedPrimitiveSafeOption, primitiveSafeOpsTests
	},
	
	(* get the resolved options and tests for each primitive *)
	combinedResults = primitiveSafeOptionsHelper /@ primitiveOptions;
	
	(* get the resolved options, safe options tests, and booleans for primitive lengths by transposing the outputs *)
	(* the primitive length dimensions are objects by select options, but are not guaranteed to be rectangular *)
	{resolvedPrimitiveSafeOption, primitiveSafeOpsTests, primitiveLengthBooleans} = Transpose[Flatten[combinedResults, {{1}, {3}}], 1 <-> 2];
	
	(* the bad objects and bad ColonySelection indices *)
	{badObjects, badOptionsIndices} = objectOptionIndexAssociation[inputObjects, primitiveLengthBooleans, False, Join];
	
	(* write the failure message *)
	If[Length[badObjects] > 0 && Not[gatherTests],
		Message[Error::IndexMatchingPrimitive, badObjects, badOptionsIndices]
	];
	
	(* return the safe options if selected *)
	primitiveSafeTests = If[gatherTests,
		
		(* if there are failing tests, write the failing tests from collected data *)
		failingPrimitiveLengthsQTest = If[Length[badObjects] > 0,
			Test[
				"For data objects " <> ECL`InternalUpload`ObjectToString[badObjects] <> ", the index-matching fields for ColonySelection primitives at index " <> ToString[badOptionsIndices] <> " are properly formatted:",
				False,
				True
			],
			Nothing
		];
		
		(* calculate the passing data *)
		{goodObjects, goodOptions} = objectOptionIndexAssociation[inputObjects, primitiveLengthBooleans, True, Join];
		
		(* if there are passing tests, write the test for that *)
		(* if there are failing tests, write the failing tests from collected data *)
		passingPrimitiveLengthsQTest = If[Length[goodObjects] > 0,
			Test[
				"For data objects " <> ECL`InternalUpload`ObjectToString[goodObjects] <> ", the index-matching fields for ColonySelection primitives at indices " <> ToString[goodOptions] <> " are properly formatted:",
				True,
				True
			],
			Nothing
		];
		
		(* combine all tests, including those from the safe ops calls on primitives *)
		Flatten[{
			failingPrimitiveLengthsQTest,
			passingPrimitiveLengthsQTest,
			primitiveSafeOpsTests
		}],
		
		(* otherwise return an empty list *)
		{}
	];
	
	(* find the indices of problematic objects so that they can be made usable for tests and not fail immediately *)
	badObjectsIndices = Position[inputObjects, #]& /@ badObjects;
	
	(* modify the bad objects option pairs to all be length 1 to avoid future issues with tests and options *)
	cleanResolvedPrimitiveSafeOption = modifyBadPrimitiveLength[resolvedPrimitiveSafeOption, badObjectsIndices, badOptionsIndices];
	
	(* return the resolved options, the cleaned up bad primitives for further resolution, tests, and a failure boolean *)
	{resolvedPrimitiveSafeOption, cleanResolvedPrimitiveSafeOption, primitiveSafeTests, primitiveLengthBooleans}

];

(* the primitive structure in this case is primitiveHead[Association[List[Rules...]]] *)
primitiveHeadBody[primitiveOption_] := primitiveOption /. head_[Association[body___]] :> {head, {body}};

(* list overload *)
primitiveSafeOptionsHelper[primitiveOptions_List] := primitiveSafeOptionsHelper /@ primitiveOptions;

(* singleton call single features, return empty list for tests and True for index matching boolean *)
primitiveSafeOptionsHelper[primitiveOption_] := Module[
	{
		primitiveHead, primitiveRulesList, safeOps, safeOpsTest
	},
	
	(* the primitive structure in this case is primitiveHead[Association[List[Rules...]]] *)
	{primitiveHead, primitiveRulesList} = primitiveHeadBody[primitiveOption];
	
	(* call safe options on the primitive because the framework does not do that for unit ops *)
	{safeOps, safeOpsTest} = SafeOptions[Head[primitiveOption], Normal[First[primitiveOption]], AutoCorrect -> False, Output -> {Result, Tests}];
	
	(* put the head back on and return an empty list for test and true boolean for index matching *)
	{primitiveHead[Association@@safeOps], safeOpsTest, True}
];

(* singleton call on multifeature *)
primitiveSafeOptionsHelper[primitiveOption_MultiFeatured] := Module[
	{
		primitiveHead, resolvedPrimitive, primitiveRulesList, indexMatchFields, primitiveUnresolvedIndexRules, ruleLengths,
		expansionLength, listedRuleLengths, indexLengthsBool, primitiveSafeOptionsTests, defaultKeys,
		singletonKeys, unexpandedKeys, unexpandedRules, expandedRules
	},
	
	(* the primitive structure in this case is primitiveHead[Association[List[Rules...]]] *)
	{primitiveHead, primitiveRulesList} = primitiveHeadBody[primitiveOption];
	
	(*index matching rules *)
	indexMatchFields = {
		Features, Select, NumberOfDivisions, Threshold, Color, FilterWavelength,
		Dye, ExcitationWavelength, EmissionWavelength
	};
	
	(* pull out the index matching rules to check that they are equal length *)
	primitiveUnresolvedIndexRules = FilterRules[primitiveRulesList, indexMatchFields];
	
	(*find length index matching rules *)
	ruleLengths = ruleLength /@ primitiveUnresolvedIndexRules;
	
	(* find expansion length *)
	expansionLength = Max[ruleLengths];
	
	(* find lengths of listed rules *)
	listedRuleLengths = Select[ruleLengths, # > 0&];
	
	(*Check to make sure all rule sets are the same length or singletons*)
	indexLengthsBool = Not[!MatchQ[Length[Union[listedRuleLengths]], 1] && expansionLength > 0];
	
	(* Pull out the safe options and tests *)
	{resolvedPrimitive, primitiveSafeOptionsTests} = SafeOptions[primitiveHead, primitiveRulesList, AutoCorrect -> False, Output -> {Result, Tests}];
	
	(*If we are dealing with lists we need to expand the automatic/default rules *)
	(* Add listability if only singletons are used *)
	(* Find the default/automatic rule keys in the index matched field *)
	defaultKeys = Complement[indexMatchFields, Keys[primitiveUnresolvedIndexRules]];
	
	(* find the keys whose rule length is 0 *)
	singletonKeys = PickList[Keys[primitiveUnresolvedIndexRules], ruleLengths, 0];
	
	(* join together rule keys that need to be expanded *)
	unexpandedKeys = Join[defaultKeys, singletonKeys];
	
	(*Find the unexpanded rules from the keys *)
	unexpandedRules = FilterRules[resolvedPrimitive, unexpandedKeys];
	
	(* expand the rules *)
	expandedRules = ruleExpander[#, expansionLength]& /@ unexpandedRules;
	(* Replace the rules in the resolved primitive *)
	resolvedPrimitive = ReplaceRule[resolvedPrimitive, expandedRules];
	
	(* Replace the second list header with the primitive head *)
	resolvedPrimitive = resolvedPrimitive /. List[body___] :> primitiveHead[body];
	
	(* return resolved primitive and tests *)
	{resolvedPrimitive, primitiveSafeOptionsTests, indexLengthsBool}

];

(* helper for to find length of rule *)
ruleLength[Rule[key_, value_List]] := Length[value];
ruleLength[Rule[key_, value_]] := 0;

(*special case for wavelength *)
ruleLength[Rule[key : Wavelength, value_List]] := Module[{},
	(* If it is longer than 2, then nested list lengths will be 1, but if it is length 2 it could be mistaken for a single fluorescence wavelength of {Excitation, Emission} pair *)
	If[!MatchQ[Length[value], 2],
		Length[value],
		
		(*Otherwise check if it is an excitation emission pair and return 0 if true and 2 if false *)
		If[MatchQ[value, QPixFluorescenceWavelengthsP],
			0,
			2
		]
	
	]

];

(*special case for divisions *)
ruleLength[Rule[key : Divisions, value_List]] := Module[{},
	(* If it is longer than 2, then nested list lengths will be 1, but if it is length 2 a single division call *)
	If[!MatchQ[Length[value], 2],
		Length[value],
		
		(*Otherwise check if it is an excitation emission pair and return 0 if true and 2 if false *)
		If[MatchQ[value, {_?NumericQ, _?NumericQ}],
			0,
			2
		]
	
	]

];

(* Expand out index matched rules that are automatic *)
ruleExpander[Rule[key_, value_], repeats_] := Rule[key, Repeat[value, repeats]];
ruleExpander[Rule[key_, value_], 0] := Rule[key, {value}];

cellQPixPair[emissionWavelengthRange_, excitationWavelengthRange_] := Module[
	{
		wavelengthPairs, excitationPairs, emissionPairs, matchingPairs
	},
	
	(* ex/em pairs options, convert alternatives into a list *)
	wavelengthPairs = List @@ QPixFluorescenceWavelengthsP;
	
	(* find the pairs that match the excitation range *)
	excitationPairs = If[Length[emissionWavelengthRange] > 0,
		Select[wavelengthPairs, (emissionWavelengthRange[[1]] < #[[1]] < emissionWavelengthRange[[2]])&],
		{}
	];
	
	(* find the the pairs that match the emission range *)
	emissionPairs = If[Length[excitationWavelengthRange] > 0,
		Select[wavelengthPairs, (excitationWavelengthRange[[1]] < #[[2]] < excitationWavelengthRange[[2]])&],
		{}
	];
	
	(* find the overlap between the pairs *)
	matchingPairs = Intersection[excitationPairs, emissionPairs];
	
	(*
		Return the best suggested wavelength and a value indicating how many matching pairs there were 0-2
	*)
	If[Length[matchingPairs] > 0,
		{First[matchingPairs], 2},
		(* if no fulling matching pair, but there is an excitation pair, return that *)
		If[Length[excitationPairs] > 0,
			{First[excitationPairs], 1},
			(* otherwise return the first of the emission pairs *)
			If[Length[emissionPairs] > 0,
				{First[emissionPairs], 1},
				(* if nothing return Null *)
				{Null, 0}
			]
		]
	]
];

(* find if unique labels are used for the colony selections *)
uniqueColonyNames[safeSelectPrimitive_] := Module[
	{
		colonySelectionLabels
	},
	
	(* pull out PopulationName from each ColonySelection by looking into the association of ColonySelection *)
	colonySelectionLabels = Lookup[#[[1]], PopulationName]& /@ safeSelectPrimitive;
	
	(* remove automatic from list *)
	colonySelectionLabels = DeleteCases[colonySelectionLabels, Automatic];
	
	(* check if the colony names are unique and return a string corresponding to an error *)
(*	If[DuplicateFreeQ[colonySelectionLabels], {},{"NonUniqueColonyLabels"}]*)
	
	DuplicateFreeQ[colonySelectionLabels]
];

(* main function for colony selection primitive resolution *)
resolvePrimitive[
	safeSelectPrimitive_List,
	inputObjects_,
	gatherTests_,
	cellFluorescentExcitationRange_,
	cellFluorescentEmissionRange_,
	fluorescenceWavelengthImages_,
	absorbanceImages_,
	imageRequirement_
] := Module[
	{
		resolvedPrimitiveAndTests, uniqueColonyNamesBools, uniqueColonyNamesBoolObjects,
		resolvedPrimitives, failingStrings, aggregatedPrimitivesAndTestBooleans,
		badObjectsAndOptions, failureCheck, errorSet, failureCheckBooleans,
		primitiveSelectionTests, goodObjectsAndOptions,
		passingTests, failingTests, uniqueColonyNamesBoolGoodObjects, uniqueNamePassingTest,
		uniqueNameFailingTest, failingSelectionBoolean, selectionWarningIndices, warningIndices,
		uniqueColonyBoolean, allFailures, badStrings, badObjectBoolean,
		noFluorescenceImageTestString, badObjectIndices, failingObjectsBoolean, noAbsorbanceImageTestString,
		includeExcludeOverlapString, bothSelectMethodsTestString, thresholdSelectConflictTestString,
		divisionSelectConflictTestString, thresholdMissingTestString, invalidWavelengthPairTestString,
		dyeWavelengthConflictTestString, noAutomaticWavelengthTestString, singleAutomaticWavelengthTestString,
		incorrectThresholdFormatTestString, notMultipleFeaturesTestString,
		testStrings, passingStrings
	},
	
	(* get the results back and pass/fail booleans back *)
	{resolvedPrimitiveAndTests, uniqueColonyNamesBools} = Transpose[
		MapThread[
			resolveColonySelectionSets[#1, #2, #3, #4, #5, imageRequirement]&,
			{
				safeSelectPrimitive,
				cellFluorescentExcitationRange,
				cellFluorescentEmissionRange,
				fluorescenceWavelengthImages,
				absorbanceImages
			}
		]
	];
	
	(* find bad objects and their indices from non-unique colony names *)
	uniqueColonyNamesBoolObjects = PickList[inputObjects, uniqueColonyNamesBools, False];
	
	(* aggregate together the resolved primitives and test booleans *)
	(* the flatten is used as a non-rectangular transpose *)
	aggregatedPrimitivesAndTestBooleans = Transpose[
		Flatten[
			resolvedPrimitiveAndTests,
			{{1}, {3}}
		],
		1 <-> 2
	];
	
	(* pull out the resolved primitive and booleans then flatten the boolean strings *)
	{resolvedPrimitives, failingStrings} = aggregatedPrimitivesAndTestBooleans;
	
	(* combine errors from dor each unit operation *)
	failingStrings = Join[Sequence @@ #] & /@ failingStrings;
	
	(* delete duplicate errors *)
	failingStrings = Map[DeleteDuplicates, failingStrings, {2}];
	
	testStrings = {
		"IncludeExcludeOverlap", "AbsorbanceImageMissing", "FluorescenceImageMissing",
		"BothSelect", "ThresholdSelectConflict", "DivisionSelectConflict", "ThresholdMissing",
		"ValidWavelengthPair", "DyeWavelengthConflict", "NoAutomaticWavelength", "SingleAutomaticWavelength",
		"IncorrectThresholdFormat", "NotMultipleFeatures"
	};
	
	(* convert error positions to {object, indices *)
	objectIndexTuples[{}, _]:={};
	objectIndexTuples[x_List, objects_List]:=Module[{grouped, objectsUsed},
		grouped = GroupBy[x[[;;,;;2]],  (#[[1]]&)->(#[[2]]&)];
		objectsUsed = objects[[Keys[grouped]]];
		{objectsUsed, Values[grouped]}
	];
	(* finds positions of errors and organizes them as tuples of {objects, indices *)
	formatErrors[errors_, failingString_, objects_]:=Module[
		{},
		(* find positions of failures *)
		positions = Position[errors, failingString];
		objectIndexTuples[positions, objects]
	];
	
	badObjectsAndOptions = formatErrors[failingStrings, #, inputObjects]&/@testStrings;
	
	(* need to align the string failures with the errorSet *)
	(* all errors for the ColonySelection, a Hold is used or the errors will turn into strings *)
	errorSet = {
		Hold[Error::IncludeExcludeOverlap],
		Hold[Error::AbsorbanceImageMissing],
		Hold[Error::FluorescentImageMissing],
		Hold[Error::BothSelectMethods],
		Hold[Error::ThresholdSelectConflict],
		Hold[Error::DivisionSelectConflict],
		Hold[Error::ThresholdMissing],
		Hold[Error::InvalidWavelengthPair],
		Hold[Error::DyeWavelengthConflict],
		Hold[Error::NoAutomaticWavelength],
		Hold[Warning::SingleAutomaticWavelength],
		Hold[Error::IncorrectThresholdFormat],
		Hold[Error::NotMultipleFeatures]
	};
	
	(* pull out errors that are warnings to ensure that those failures are not fatal *)
	warningIndices = PickList[
		Range[Length[errorSet]],
		errorSet,
		_?(Extract[#, {1, 1}] === Warning &)
	];
	
	(* write messages for all failures if we are not gathering tests *)
	If[Not[gatherTests],
		
		(* failure check for everything except for warnings*)
		failureCheck = ConstantArray[True, Length[badObjectsAndOptions]];
		failureCheck[[warningIndices]] = False;
		
		(* write messages and check for failures *)
		failureCheckBooleans = MapThread[
			(* #1 is the object and association options, but is split into two inputs *)
			primitiveMessageCreation[Sequence @@ #1, #2, #3]&,
			{badObjectsAndOptions, errorSet, failureCheck}
		];
		
		(* write message for unique colony names *)
		uniqueColonyBoolean = If[Length[uniqueColonyNamesBoolObjects] > 0,
			Message[Error::RepeatedPopulationNames, uniqueColonyNamesBoolObjects, PickList[Range[Length[inputObjects]], uniqueColonyNamesBools, False]];
			(* return true if there was an error *)
			True,
			False
		];
		
		allFailures = Append[failureCheckBooleans, uniqueColonyBoolean];
		
		(* check if a failure check boolean is true, in which case we want to return $Failed *)
		MemberQ[allFailures, True],
		
		(* otherwise do not return failure *)
		False
	
	];
	
	(* write tests for all booleans *)
	primitiveSelectionTests = If[gatherTests,
		
		(* find the passingStrings, by complementing with the failing strings mapped over each index corresponding to a single population *)
		passingStringIndex[failuresStrings_, testingStrings_]:=Complement[testingStrings, #]&/@failingStrings;
		
		(* map over the failing strings in each object to find the passing strings *)
		passingStrings = passingStringIndex[#, testStrings]&/@failingStrings;
		
		(* create all object-index tuples *)
		goodObjectsAndOptions = formatErrors[passingStrings, #, inputObjects]&/@testStrings;
		
		(* test strings *)
		includeExcludeOverlapString = "include and exclude cannot contain the same points:";
		noAbsorbanceImageTestString = "if an Absorbance feature is selected, a corresponding image must be available:";
		noFluorescenceImageTestString = "if a fluorescent feature is selected, a corresponding image must be available:";
		bothSelectMethodsTestString = "both NumberOfDivisions and Threshold cannot be used to specify a population at the same time:";
		thresholdSelectConflictTestString = "if the Select method is AboveThreshold or BelowThreshold, then the NumberOfDivision cannot be specified:";
		divisionSelectConflictTestString = "if the Select method is Min or Max then a Threshold cannot be used:";
		thresholdMissingTestString = "if the Select method is AboveThreshold or BelowThreshold, then a Threshold value must be specified:";
		invalidWavelengthPairTestString = "if the feature is Fluorescence, the excitation and emission wavelength pair is a valid instrument setting:";
		dyeWavelengthConflictTestString = "if the feature is Fluorescence, the excitation and emission wavelength pair matches the specified dye or either the dye or excitation and emission wavelength pair are automatic:";
		noAutomaticWavelengthTestString = "if the feature is Fluorescence, the excitation and emission wavelength pair can be resolved from the options or Model[Cell] information:";
		singleAutomaticWavelengthTestString = "if the feature is Fluorescence, and only one wavelength matches the Model[Cell] a warning is thrown";
		incorrectThresholdFormatTestString = "if the feature is Diameter or Distance the threshold is a distance Quantity, if the feature is regularity or circularity the threshold is a number between 0 and 1";
		notMultipleFeaturesTestString = "if the MultiFeatured Unit Operation is used, multiple features are input:";
		
		(* join test strings together to map over, use the same order as failing strings *)
		testStrings = {
			includeExcludeOverlapString,
			noAbsorbanceImageTestString,
			noFluorescenceImageTestString,
			bothSelectMethodsTestString,
			thresholdSelectConflictTestString,
			divisionSelectConflictTestString,
			thresholdMissingTestString,
			invalidWavelengthPairTestString,
			dyeWavelengthConflictTestString,
			noAutomaticWavelengthTestString,
			singleAutomaticWavelengthTestString,
			incorrectThresholdFormatTestString,
			notMultipleFeaturesTestString
		};
		
		(* map over passing tests *)
		(* #1 contains the object and associated options *)
		passingTests = MapThread[
			primitiveTestCreator[Sequence @@ #1, True, #2]&,
			{goodObjectsAndOptions, testStrings}
		];
		
		(* map over failing tests *)
		(* #1 contains the object and associated options *)
		failingTests = MapThread[
			primitiveTestCreator[Sequence @@ #1, False, #2]&,
			{badObjectsAndOptions, testStrings}
		];
		
		(* uniqueColonyNamesQ*)
		(* find bad objects from colony names *)
		uniqueColonyNamesBoolGoodObjects = PickList[inputObjects, uniqueColonyNamesBools, True];
		
		(* unique colony passing test *)
		uniqueNamePassingTest = If[Length[uniqueColonyNamesBoolGoodObjects] > 0,
			Test[
				(* programmatically create the test strings *)
				"For the data objects, " <> ECL`InternalUpload`ObjectToString[uniqueColonyNamesBoolGoodObjects] <> ", all PopulationNames are unique:",
				True,
				True
			],
			Nothing
		];
		
		(* unique colony failing test *)
		uniqueNameFailingTest = If[Length[uniqueColonyNamesBoolObjects] > 0,
			Test[
				(* programmatically create the test strings *)
				"For the data objects, " <> ECL`InternalUpload`ObjectToString[uniqueColonyNamesBoolObjects] <> ", all PopulationNames are unique:",
				False,
				True
			],
			Nothing
		];
		
		(* return all tests *)
		{
			failingTests,
			passingTests,
			uniqueNameFailingTest,
			uniqueNamePassingTest
		},
		
		(* otherwise return no tests *)
		{}
	
	];
	
	(* instead of hard coding the warning indices, we could look at the error set for warnings *)
	selectionWarningIndices = ToList /@ warningIndices;
	
	(* remove the wavelength check and unused superlative selection from the test booleans this is the 6th check *)
	badStrings = Delete[testStrings, selectionWarningIndices];
	
	(* check if one of the bad strings is present in the failing strings *)
	failingStringTest[allFailingStrings_, primitiveFailingStrings_]:=Or@@(MemberQ[allFailingStrings, #]&/@Flatten[primitiveFailingStrings]);
	
	(* get bad object indices by finding the locations of failures *)
	badObjectBoolean = Map[
		failingStringTest[badStrings, #]&,
		failingStrings
	];
	badObjectIndices = Flatten[Position[badObjectBoolean, True]];
	
	(* set failing indices to True *)
	failingSelectionBoolean = ConstantArray[False, Length[inputObjects]];
	failingSelectionBoolean[[badObjectIndices]] = True;
	
	(* check if an object failed from option resolution or has a non-unique name *)
	(* the not on the unique colony name flips the failing tests to be True to match the failing selection options *)
	failingObjectsBoolean = MapThread[Or[#1, Not[#2]] &, {failingSelectionBoolean, uniqueColonyNamesBools}];
	
	(* return the resolved primitive options, tests, and an index matched list of failing option resolutions *)
	{resolvedPrimitives, primitiveSelectionTests, failingObjectsBoolean}

];

(* message creation and failure check *)
primitiveMessageCreation[_,_]:=False;
primitiveMessageCreation[objects_, optionIndices_, Hold[error_], failureCheck_] := If[Length[objects] > 0,
	
	(* Error has to be held otherwise it will evaluate to a string *)
	Message[error, objects, optionIndices];
	(* if the message also necessitates a failure, return that *)
	failureCheck,
	False
];

(* create tests for primitives for objects, option indexes, and test string *)
(* overload where there are no tests to make *)
primitiveTestCreator[_,_]:={};
(* main function *)
primitiveTestCreator[objects_, optionIndices_, passingBoolean_, testString_] := Module[
	{
		introString, selectionString, testConnectString
	},
	
	(* test strings *)
	introString = "For the data objects, ";
	selectionString = ", at ColonySelection primitive indices ";
	testConnectString = ", ";
	
	(* check if there are objects, make a test *)
	If[Length[objects] > 0,
		Test[
			(* programmatically create the test strings *)
			introString <> ECL`InternalUpload`ObjectToString[objects] <> selectionString <> ToString[optionIndices] <> testConnectString <> testString,
			passingBoolean,
			True
		],
		Nothing
	]

];

(* list overload *)
resolveColonySelectionSets[
	safeSelectPrimitive_,
	cellFluorescentExcitationRange_,
	cellFluorescentEmissionRange_,
	fluorescenceWavelengthImages_,
	absorbanceImage_,
	imageRequirement_
] := Module[
	{
		resolvedPrimitiveAndTests, uniqueColonyNamesBool
	},
	
	(* Check that the population names are unique, if not throw an error *)
	uniqueColonyNamesBool = uniqueColonyNames[safeSelectPrimitive];
	
	(* use reap to collect the strings that correspond to errors *)
	resolvedPrimitiveAndTests = MapIndexed[
		Reap[resolveOneColonySelection[
			#1,
			First@#2,
			(* these are values of the data objects, not the selections *)
			CellFluorescentExcitationRange -> cellFluorescentExcitationRange,
			CellFluorescentEmissionRange -> cellFluorescentEmissionRange,
			FluorescenceWavelengthImages -> fluorescenceWavelengthImages,
			AbsorbanceImage -> absorbanceImage,
			ImageRequirement -> imageRequirement
		]]&,
		safeSelectPrimitive
	];
	
	(* add boolean to the end of primitives and tests *)
	{
		resolvedPrimitiveAndTests,
		uniqueColonyNamesBool
	}

];

(* pull out head and body of association *)
primitiveHeadAssociation[primitive_]:= primitive /. head_[body___] :> {head, body};

(* resolve colony selection label *)
resolvePopulationName[label_, index_]:= If[MatchQ[label, Automatic],
	
	(* String join to create a unique name *)
	"ColonySelection" <> ToString[index],
	
	(* Otherwise leave alone *)
	label
];

(* resolve select for Diameter, Isolation, Regularity, Circularity *)
resolveSelect[numberOfDivisions_, numberOfColonies_, select_, threshold_]:=Module[
	{
		thresholdSpecifiedBool, divisionsSpecifiedBool, bothSelectBool, resolvedNumberOfDivisions, resolvedThreshold,
		resolvedNumberOfColonies, resolvedSelect, thresholdSelectConflictBool, divisionSelectConflictBool,
		thresholdMissingBool, primitiveError
	},
	
	(* failures are false and acceptable is true *)
	(* resolve select *)
	(* check that threshold diameter and number of divisions are not both populated *)
	thresholdSpecifiedBool = Not[MatchQ[threshold, Automatic|Null]];
	divisionsSpecifiedBool = Not[MatchQ[numberOfDivisions, Automatic|Null]];
	bothSelectBool = Not[And[thresholdSpecifiedBool, divisionsSpecifiedBool]];
	If[Not[bothSelectBool], Sow["BothSelect"]];
	
	(* check if Select is in conflict with the Select method *)
	thresholdSelectConflictBool = Not[And[MatchQ[select, AboveThreshold|BelowThreshold], divisionsSpecifiedBool]];
	If[Not[thresholdSelectConflictBool], Sow["ThresholdSelectConflict"]];
	
	divisionSelectConflictBool = Not[And[MatchQ[select, Min|Max], thresholdSpecifiedBool]];
	If[Not[divisionSelectConflictBool], Sow["DivisionSelectConflict"]];
	
	(* check if threshold is missing when Select expects it *)
	thresholdMissingBool = Not[And[MatchQ[select, AboveThreshold|BelowThreshold], Not[thresholdSpecifiedBool]]];
	If[Not[thresholdMissingBool], Sow["ThresholdMissing"]];
	
	(* check if we have one error to skip additional resolution *)
	primitiveError = Not[And[bothSelectBool, thresholdSelectConflictBool, divisionSelectConflictBool, thresholdMissingBool]];
	
	(*
		if both methods (threshold or divisions) are not specified or in conflict with the Select option,
		we resolve the one that is specified, default to what aligns with Select (min/max - Divisions, above/below - Thresholds), or resolve to defualts
		otherwise return what we have and return an error
	*)
	{resolvedNumberOfDivisions, resolvedThreshold, resolvedNumberOfColonies, resolvedSelect} = If[Not[primitiveError],
		(*
			if the threshold is specified, set number of divisions to null and numberOfColonies to All if Automatic,
			otherwise set the threshold to Null and resolve the divisions
		*)
		If[thresholdSpecifiedBool,
			(* Use threshold options *)
			{Null, threshold, numberOfColonies/.Automatic -> All, select/.Automatic -> AboveThreshold},
			
			(* Use division defaults *)
			{numberOfDivisions/.Automatic -> 2, Null, numberOfColonies/.Automatic -> 10, select/.Automatic -> Max}
		],
		(* if we are here, there is an error, don't put effort into resolving *)
		{numberOfDivisions, threshold, numberOfColonies, select}
	];
	
	(* return new options and failures booleans *)
	{
		resolvedNumberOfDivisions, resolvedNumberOfColonies, resolvedSelect, resolvedThreshold
	}

];

(* resolve for Absorbance or Fluorescence *)
resolveSelect[numberOfDivisions_, numberOfColonies_, select_]:=Module[
	{
		divisionsSpecifiedBool, divisionConflictBool, primitiveError,
		resolvedNumberOfDivisions, resolvedNumberOfColonies, resolvedSelect
	},
	
	(* failures are false and acceptable is true *)
	(* resolve select *)
	(* check that threshold diameter and number of divisions are not both populated *)
	divisionsSpecifiedBool = Not[MatchQ[numberOfDivisions, Automatic|Null]];
	
	(* check if Select is in conflict with the selected method *)
	divisionConflictBool = Not[And[MatchQ[select, Positive|Negative], divisionsSpecifiedBool]];
	If[Not[divisionConflictBool], Sow["DivisionSelectConflict"]];
	
	(* check if we have one error to skip additional resolution *)
	primitiveError = Not[divisionConflictBool];
	
	(*
		if both methods (threshold or divisions) are not specified or in conflict with the Select option,
		we resolve the one that is specified, default to what aligns with Select (min/max - Divisions, above/below - Thresholds), or resolve to defualts
		otherwise return what we have and return an error
	*)
	{resolvedNumberOfDivisions, resolvedNumberOfColonies, resolvedSelect} = If[Not[primitiveError],
		(*
			if the threshold is specified, set number of divisions to null and numberOfColonies to All if Automatic,
			otherwise set the threshold to Null and resolve the divisions
		*)
		If[divisionsSpecifiedBool||MatchQ[select, Max|Min],
			(* Use division options *)
			{numberOfDivisions/.Automatic -> 2, numberOfColonies/.Automatic -> 10, select/.Automatic -> Max},
			(* Use clustering options *)
			{Null, numberOfColonies/.Automatic -> All, select/.Automatic -> Positive}
		],
		(* if we are here, there is an error, don't put effort into resolving *)
		{numberOfDivisions, numberOfColonies, select}
	];
	
	(* return the calculated values *)
	{resolvedNumberOfDivisions, resolvedNumberOfColonies, resolvedSelect}
];

(* singleton function *)
(* Resolve SingleFeature *)
resolveOneColonySelection[
	safeSelectPrimitive:_Diameter|_Isolation|_Regularity|_Circularity,
	safeSelectIndex_,
	ops:OptionsPattern[]
] := Module[
	{
		primitiveHead, safeSelect, select, numberOfColonies, numberOfDivisions,
		colonySelectionLabel, resolvedPrimitive, thresholdSymbol, threshold, include, exclude,
		listedInclude, listedExclude
	},
	
	(* Split the primitive by the head and internal association *)
	{primitiveHead, safeSelect} = primitiveHeadAssociation[safeSelectPrimitive];
	
	(* lookup ThresholdSymbol based on the primitive head *)
	thresholdSymbol = ReplaceAll[primitiveHead,
		{
			Diameter -> ThresholdDiameter, Isolation -> ThresholdDistance,
			Regularity -> ThresholdRegularity, Circularity -> ThresholdCircularity
		}
	];
	
	(* lookup the options for Diameter *)
	{
		select, numberOfColonies, numberOfDivisions,
		colonySelectionLabel, threshold,
		include, exclude
	} = Lookup[safeSelect,
		{
			Select, NumberOfColonies, NumberOfDivisions,
			PopulationName, thresholdSymbol,
			Include, Exclude
		}
	];
	
	(* resolve include and exclude *)
	{listedInclude, listedExclude} = resolveIncludeExclude[include, exclude];
	
	(* resolve the colony selection label *)
	colonySelectionLabel = resolvePopulationName[colonySelectionLabel, safeSelectIndex];
	
	{
		numberOfDivisions, numberOfColonies, select, threshold
	} = resolveSelect[numberOfDivisions, numberOfColonies, select, threshold];
	
	resolvedPrimitive = primitiveHead[<|
		Select -> select,
		NumberOfDivisions -> numberOfDivisions,
		thresholdSymbol -> threshold,
		NumberOfColonies -> numberOfColonies,
		PopulationName -> colonySelectionLabel,
		Exclude -> listedExclude,
		Include -> listedInclude
	|>];
	
	resolvedPrimitive
];

resolveOneColonySelection[
	safeSelectPrimitive:_Absorbance,
	safeSelectIndex_,
	ops:OptionsPattern[]
] := Module[
	{
		primitiveHead, safeSelect, select, numberOfColonies, numberOfDivisions,
		colonySelectionLabel, resolvedPrimitive, color, absorbanceWavelength, include, exclude,
		listedInclude, listedExclude
	},
	
	(* Split the primitive by the head and internal association *)
	{primitiveHead, safeSelect} = primitiveHeadAssociation[safeSelectPrimitive];
	
	(* lookup the options for Diameter *)
	{
		select, numberOfColonies, numberOfDivisions,
		colonySelectionLabel, color, absorbanceWavelength,
		include, exclude
	} = Lookup[safeSelect,
		{
			Select, NumberOfColonies, NumberOfDivisions,
			PopulationName, Color, FilterWavelength,
			Include, Exclude
		}
	];
	
	(* resolve include and exclude *)
	{listedInclude, listedExclude} = resolveIncludeExclude[include, exclude];
	
	(* resolve the colony selection label and select option *)
	colonySelectionLabel = resolvePopulationName[colonySelectionLabel, safeSelectIndex];
	
	{numberOfDivisions, numberOfColonies, select}=resolveSelect[numberOfDivisions, numberOfColonies, select];
	
	(* check if there is an absorbance image *)
	absorbanceImageCheck[ops];
	
	resolvedPrimitive = primitiveHead[<|
		Select -> select,
		NumberOfDivisions -> numberOfDivisions,
		NumberOfColonies -> numberOfColonies,
		PopulationName -> colonySelectionLabel,
		Color -> Blue,
		FilterWavelength -> Quantity[400, Nanometer],
		Include -> listedInclude,
		Exclude -> listedExclude
	|>];
	
	resolvedPrimitive
];

(* check if the absorbance image is present and if not sow a string that will convert to an error *)
absorbanceImageCheck[ops:OptionsPattern[]]:=Module[
	{absorbanceImage, imageRequirement, imageMissingBool},
	(* look up image and requirement option *)
	{absorbanceImage, imageRequirement} = Lookup[ToList[ops], {AbsorbanceImage, ImageRequirement}];
	(* check if the image is present *)
	imageMissingBool = MatchQ[absorbanceImage, Null];
	(* if there is not image, but it is required, Sow a string *)
	If[And[imageMissingBool, First[imageRequirement]], Sow["AbsorbanceImageMissing"]];
];

resolveOneColonySelection[
	safeSelectPrimitive:_Fluorescence,
	safeSelectIndex_,
	ops:OptionsPattern[]
] := Module[
	{
		primitiveHead, safeSelect, select, numberOfColonies, numberOfDivisions,
		colonySelectionLabel, resolvedPrimitive, color,
		dye, excitationWavelength, emissionWavelength, include, exclude,
		listedInclude, listedExclude
	},
	
	(* Split the primitive by the head and internal association *)
	{primitiveHead, safeSelect} = primitiveHeadAssociation[safeSelectPrimitive];
	
	(* lookup the options for Diameter *)
	{
		select, numberOfColonies, numberOfDivisions,
		colonySelectionLabel, color, dye,
		excitationWavelength, emissionWavelength,
		include, exclude
	} = Lookup[safeSelect,
		{
			Select, NumberOfColonies, NumberOfDivisions,
			PopulationName, Color,
			Dye, ExcitationWavelength, EmissionWavelength,
			Include, Exclude
		}
	];
	
	(* resolve include and exclude *)
	{listedInclude, listedExclude} = resolveIncludeExclude[include, exclude];
	
	(* resolve the colony selection label *)
	colonySelectionLabel = resolvePopulationName[colonySelectionLabel, safeSelectIndex];
	
	(* resolve select and associated wavelengths *)
	{numberOfDivisions, numberOfColonies, select}=resolveSelect[numberOfDivisions, numberOfColonies, select];
	
	(* resolve wavelengths *)
	{dye, excitationWavelength, emissionWavelength} = fluorescenceWavelengthResolver[
		dye, excitationWavelength, emissionWavelength, ops
	];
	
	resolvedPrimitive = primitiveHead[<|
		Select -> select,
		NumberOfDivisions -> numberOfDivisions,
		NumberOfColonies -> numberOfColonies,
		PopulationName -> colonySelectionLabel,
		Dye -> dye,
		ExcitationWavelength -> excitationWavelength,
		EmissionWavelength -> emissionWavelength,
		Include -> listedInclude,
		Exclude -> listedExclude
	|>];
	
	resolvedPrimitive
];

(* resolve the fluorescence wavelength *)
fluorescenceWavelengthResolver[
	dye_, excitationWavelength_, emissionWavelength_, ops:OptionsPattern[]
]:=Module[
	{
		validWavelengthPairBool, wavelengthPair, dyeWavelength, dyeWavelengthConflictBool,
		resolvedWavelengthPair, noWavelengthInfo, resolvedDye, resolvedExcitationWavelength,
		resolvedEmissionWavelength, automaticDyeBool, automaticWavelengthBool, automaticWavelength,
		matchingCount, noAutomaticWavelengthBool, singleAutomaticWavelengthBool, fluorescenceImage,
		imageMissingBool, cellFluorescentExcitationRange, cellFluorescentEmissionRange,
		fluorescenceWavelengthImages, imageRequirement
	},
	
	(* pull options out of resolveOneColonySelection *)
	{
		cellFluorescentExcitationRange,
		cellFluorescentEmissionRange,
		fluorescenceWavelengthImages,
		imageRequirement
	} = Lookup[ToList[ops],
		{
			CellFluorescentExcitationRange,
			CellFluorescentEmissionRange,
			FluorescenceWavelengthImages,
			ImageRequirement
		}
	];
	
	(* check that excitation and emission wavelength are a valid pair *)
	wavelengthPair = {excitationWavelength, emissionWavelength};
	validWavelengthPairBool = MatchQ[wavelengthPair, QPixFluorescenceWavelengthsP|{Automatic, _}|{_, Automatic}];
	If[Not[validWavelengthPairBool], Sow["ValidWavelengthPair"]];
	
	
	(* if there is one automatic, fill in the second half *)
	resolvedWavelengthPair = wavelengthPair/.{{Automatic, Automatic}->Automatic};
	resolvedWavelengthPair = FirstCase[List @@ QPixFluorescenceWavelengthsP, Replace[resolvedWavelengthPair, Automatic -> _, 1], Automatic];
	
	(* check that the dye and wavelengths are not in conflict with each other *)
	dyeWavelength = Lookup[fluorescenceDyeTable, dye, dye];
	dyeWavelengthConflictBool = If[Not[Or[MatchQ[dyeWavelength, Automatic], MatchQ[resolvedWavelengthPair, Automatic]]],
		MatchQ[dyeWavelength, resolvedWavelengthPair],
		True
	];
	If[Not[dyeWavelengthConflictBool], Sow["DyeWavelengthConflict"]];
	
	(* check what dye and wavelength info we have *)
	automaticDyeBool = MatchQ[dyeWavelength, Automatic];
	automaticWavelengthBool = MatchQ[resolvedWavelengthPair, Automatic];
	noWavelengthInfo = And[automaticDyeBool, automaticWavelengthBool];
	
	(* if everything is automatic, then we want to lookup from Model[Cell] *)
	(*
		compare cell emission and excitation range to QPix options to determine a wavelength,
		also return a count of the number of matching pairs to issue a warning
	*)
	{automaticWavelength, matchingCount} = cellQPixPair[cellFluorescentExcitationRange, cellFluorescentEmissionRange];
	
	(* if there were errors, return the default values, otherwise resolve *)
	{resolvedDye, resolvedExcitationWavelength, resolvedEmissionWavelength} = If[And[validWavelengthPairBool, dyeWavelengthConflictBool],
		
		(* if we have no info, use the automatic values *)
		If[noWavelengthInfo,
			(* use data from Model[Cell] if everything is automatic *)
			{Lookup[dyeFluorescenceTable, Key[automaticWavelength], Null], If[matchingCount>0, Sequence@@automaticWavelength, Sequence@@{Null, Null}]},
			
			(* if the dye is not specified *)
			If[automaticDyeBool,
				(* use data from the ex/em pair *)
				{Lookup[dyeFluorescenceTable, Key[resolvedWavelengthPair], Null], Sequence@@resolvedWavelengthPair},
				(* otherwise, use data from dye *)
				{dye, Sequence@@Lookup[fluorescenceDyeTable, dye]}
			]
	
		],
		
		(* defaults on error *)
		{dye, excitationWavelength, emissionWavelength}
		
	];
	
	(* extra warnings if the automatic wavelength from Model[Cell] was used *)
	noAutomaticWavelengthBool = Not[And[noWavelengthInfo, MatchQ[matchingCount, 0]]];
	If[Not[noAutomaticWavelengthBool], Sow["NoAutomaticWavelength"]];
	singleAutomaticWavelengthBool = Not[And[noWavelengthInfo, MatchQ[matchingCount, 1]]];
	If[Not[singleAutomaticWavelengthBool], Sow["SingleAutomaticWavelength"]];
	
	(* check if we have the fluorescent image we need *)
	fluorescenceImage = Lookup[fluorescenceWavelengthImages, Key[{resolvedExcitationWavelength, resolvedEmissionWavelength}]];
	imageMissingBool = MatchQ[fluorescenceImage, Null];
	
	(* if we don't have the image we need and the image requirement was not turned off (in the case that only option resolution is performed) return an error *)
	If[And[imageMissingBool, First[imageRequirement]], Sow["FluorescenceImageMissing"]];
	
	{
		resolvedDye, resolvedExcitationWavelength, resolvedEmissionWavelength
	}

];


(* Resolve ALLColonies *)
resolveOneColonySelection[
	safeSelectPrimitive_AllColonies,
	safeSelectIndex_,
	ops:OptionsPattern[]
]:=Module[
	{
		primitiveHead, safeSelect, colonySelectionLabel, include, exclude,
		listedInclude, listedExclude
	},
	
	(* Split the primitive by the head and internal association *)
	{primitiveHead, safeSelect} = primitiveHeadAssociation[safeSelectPrimitive];
	
	(* resolve the colony selection label *)
	{
		colonySelectionLabel, include, exclude
	}= Lookup[safeSelect,
		{
			PopulationName, Include, Exclude
		}
	];
	
	(* resolve include and exclude *)
	{listedInclude, listedExclude} = resolveIncludeExclude[include, exclude];
	
	colonySelectionLabel = resolvePopulationName[colonySelectionLabel, safeSelectIndex];
	
	(* replace the resolved values *)
	safeSelect = ReplaceRule[
		Normal@safeSelect,
		{
			PopulationName -> colonySelectionLabel,
			Include -> listedInclude,
			Exclude -> listedExclude
		}
	];
	
	(* wrap the head around the resolved values *)
	primitiveHead[Association@@safeSelect]
	
];

(* assume features have to be defined *)
resolveIndexMatchedFeatures[
	feature_,
	select_,
	numberOfDivisions_,
	threshold_,
	color_,
	absorbanceWavelength_,
	dye_,
	excitationWavelength_,
	emissionWavelength_,
	numberOfColonies_,
	ops:OptionsPattern[]
] :=Module[
	{
		resolvedSelectOptions, resolvedNumberOfDivisions, resolvedNumberOfColonies, resolvedSelect, resolvedThreshold,
		resolvedColor, resolvedAbsorbanceWavelength, resolvedDye, resolvedExcitationWavelength, resolvedEmissionWavelength
	},
	
	(* if the feature is Absorbance/Fluorescence, resolve Select without threshold *)
	{
		resolvedNumberOfDivisions, resolvedNumberOfColonies, resolvedSelect, resolvedThreshold
	} = If[MatchQ[feature, Absorbance|Fluorescence],
		resolvedSelectOptions = resolveSelect[numberOfDivisions, numberOfColonies, select];
		(* insert a Null value for Threshold *)
		Append[resolvedSelectOptions, Null],
		
		(* otherwise use the threshold for other properties *)
		(* check that the threshold is a quantity for Diameter/Isolation and Number for Circularity/Regularity *)
		correctThresholdFormatBool = If[MatchQ[feature, Diameter|Isolation],
			MatchQ[threshold, _Quantity|Automatic|Null],
			MatchQ[threshold, RangeP[0,1]|Automatic|Null]
		];
		If[Not[correctThresholdFormatBool], Sow["IncorrectThresholdFormat"]];
		resolveSelect[numberOfDivisions, numberOfColonies, select, threshold]
	];
	
	(* if the feature is Absorbance, resolve and wavelength, otherwise set to Null *)
	{resolvedColor, resolvedAbsorbanceWavelength} = If[MatchQ[feature, Absorbance],
		absorbanceImageCheck[ops];
		{Blue, Quantity[400, Nanometer]},
		{Null, Null}
	];
	
	(* if the feature is Fluorescence, resolve dye and wavelengths, otherwise set to Null *)
	{resolvedDye, resolvedExcitationWavelength, resolvedEmissionWavelength} = If[MatchQ[feature, Fluorescence],
		fluorescenceWavelengthResolver[dye, excitationWavelength, emissionWavelength, ops],
		{Null, Null, Null}
	];
	
	(* return the resolved values *)
	{
		feature, resolvedSelect, resolvedNumberOfDivisions, resolvedThreshold, resolvedColor,
		resolvedAbsorbanceWavelength, resolvedDye, resolvedExcitationWavelength, resolvedEmissionWavelength, resolvedNumberOfColonies
	}
	
];


(* Resolve ColonySelection *)
resolveOneColonySelection[
	safeSelectPrimitive_MultiFeatured,
	safeSelectIndex_,
	ops:OptionsPattern[]
] := Module[
	{
		primitiveHead, safeSelect, features,select, numberOfDivisions, threshold, color,
		absorbanceWavelength, dye, excitationWavelength, emissionWavelength,
		colonySelectionLabel, numberOfColonies, exclude, include,
		resolvedFeatures, resolvedSelect, resolvedNumberOfDivisions, resolvedThreshold,
		resolvedColor, resolvedAbsorbanceWavelength, resolvedDye,
		resolvedExcitationWavelength, resolvedEmissionWavelength, resolvedNumberOfColonies,
		listedInclude, listedExclude, multipleFeaturesBool
	},
	
	(* Split the primitive by the head and internal association *)
	{primitiveHead, safeSelect} = safeSelectPrimitive /. head_[body___] :> {head, body};
	
	(* Pull the rule values out of the primitive association *)
	(* use allPrimitives to pull out the superlatives as a group later *)
	{
		(* index matched *)
		features,select, numberOfDivisions, threshold, color, absorbanceWavelength,
		dye, excitationWavelength, emissionWavelength,
		(* singleton options *)
		colonySelectionLabel, numberOfColonies, exclude, include
	} = Lookup[safeSelect, {
		Features, Select, NumberOfDivisions, Threshold, Color, FilterWavelength,
		Dye, ExcitationWavelength, EmissionWavelength,
		PopulationName, NumberOfColonies, Exclude, Include
	}];
	
	(* check that the length of features is > 1 *)
	multipleFeaturesBool = Length[features]>1;
	If[Not[multipleFeaturesBool], Sow["NotMultipleFeatures"]];
	
	(* map thread through the index matched features *)
	(* resolve index matching features as sets *)
	{
		resolvedFeatures, resolvedSelect, resolvedNumberOfDivisions, resolvedThreshold,
		resolvedColor, resolvedAbsorbanceWavelength, resolvedDye,
		resolvedExcitationWavelength, resolvedEmissionWavelength, resolvedNumberOfColonies
	} = Transpose[MapThread[
		resolveIndexMatchedFeatures[
			##, numberOfColonies, ops
		]&,
		{
			features, select, numberOfDivisions,
			threshold, color, absorbanceWavelength,
			dye, excitationWavelength, emissionWavelength
		}
	]];
	
	(* resolve NumberOf Colonies based on first feature *)
	resolvedNumberOfColonies = First[resolvedNumberOfColonies];
	
	(* If colony selection label is automatic, name it ColonySelection1, ColonySelection2, ... *)
	colonySelectionLabel = resolvePopulationName[colonySelectionLabel, safeSelectIndex];
	
	(* resolve include and exclude *)
	{listedInclude, listedExclude} = resolveIncludeExclude[include, exclude];
	
	(*thread the rule values with the keys to create an association *)
	safeSelect = <|
		Features -> resolvedFeatures,
		Select -> resolvedSelect,
		NumberOfDivisions -> resolvedNumberOfDivisions,
		Threshold -> resolvedThreshold,
		Color -> resolvedColor,
		FilterWavelength -> resolvedAbsorbanceWavelength,
		Dye -> resolvedDye,
		ExcitationWavelength -> resolvedExcitationWavelength,
		EmissionWavelength -> resolvedEmissionWavelength,
		PopulationName -> colonySelectionLabel,
		NumberOfColonies -> resolvedNumberOfColonies,
		Exclude -> listedExclude,
		Include -> listedInclude
	|>;
	
	(* replace the head to create the primitive*)
	primitiveHead[safeSelect]

];

(* resolve include and exclude by checking if they overlap *)
(*
	include and exclude are tricky because if any point in a colony is selected,
	it will be included or excluded. At this point in time we do not know if two
	points point to the same colony, unless they are the exact same. So here we
	only check if the options are the exact same.
	May need to add check that Include/Exclude are within the image dimensions
	Additional resolution can be done after the calculation of colonies
*)
resolveIncludeExclude[include_, exclude_]:=Module[
	{
		listedInclude, listedExclude, includeExcludeIntersection, overlapIncludeExcludeBool
	},
	
	(* add lists to include and exclude if not lists of lists *)
(*	{listedInclude, listedExclude} = Replace[#, {a : Except[_List], b : Except[_List]} :> {{a, b}}, {0}]& /@ {include, exclude};*)
	
	listedInclude = include/.None->{};
	listedExclude = exclude/.None->{};
	
	(* check for overlaps *)
	includeExcludeIntersection = Intersection[listedInclude, listedExclude];
	overlapIncludeExcludeBool = Not[And[Length[includeExcludeIntersection] > 0, includeExcludeIntersection =!= {{}}]];
	If[Not[overlapIncludeExcludeBool], Sow["IncludeExcludeOverlap"]];
	
	(* returned listed options and replace {} with None *)
	{listedInclude/.{}->None, listedExclude/.{}->None}
];

(*Calculate the colony parameters for the packet*)
analyzeCalculateColonies[
	KeyValuePattern[{
		ResolvedInputs -> KeyValuePattern[{
			ImageData -> inputImage_,
			Scale -> scale_,
			FluorescenceWavelengthImages -> fluorescenceWavelengthImages_,
			AbsorbanceWavelengthImages -> absorbanceImage_
		}],
		ResolvedOptions -> KeyValuePattern[{
			Populations -> select_,
			MinRegularityRatio -> minRegularity_,
			MaxRegularityRatio -> maxRegularity_,
			MinCircularityRatio -> minCircularity_,
			MaxCircularityRatio -> maxCircularity_,
			MinDiameter -> minDiameter_,
			MaxDiameter -> maxDiameter_,
			MinColonySeparation -> minColonySeparation_,
			ManualPickTargets -> manualPickTargets_,
			IncludedColonies -> manualColonyBoundaries_,
			Output -> output_
		}],
		Intermediate -> KeyValuePattern[{
			Failures -> resolutionFailure_,
			MaxPlateDimension -> maxPlateDimension_
			
		}]
	}]
] := Module[
	{
		colonySelectionLabels, testsOrOptionsBool,
		maskedImage, smallComponentsThreshold, pixelWidth,
		calculatedComponentsPerimeterPositions, calculatedComponentsLocation,
		calculatedComponentsDiameter, calculatedComponentsSeparation,
		calculatedComponentsRegularity, calculatedComponentsCircularity,
		calculatedComponentsAbsorbance, calculatedComponentsVioletFluorescence,
		calculatedComponentsGreenFluorescence, calculatedComponentsOrangeFluorescence,
		calculatedComponentsRedFluorescence, calculatedComponentsDarkRedFluorescence,
		averageDiameter, averageRegularity, averageCircularity,
		averageAbsorbance, averageVioletFluorescence, averageGreenFluorescence,
		averageOrangeFluorescence, averageRedFluorescence, averageDarkRedFluorescence,
		selectedDiameterDistributions, selectedSeparationDistributions,
		selectedRegularityDistributions, selectedCircularityDistributions,
		selectedAbsorbanceDistributions, selectedVioletFluorescenceDistributions,
		selectedGreenFluorescenceDistributions, selectedOrangeFluorescenceDistributions,
		selectedRedFluorescenceDistributions, selectedDarkRedFluorescenceDistributions,
		calculatedColonies, selectedColoniesList, selectedColoniesValues, calculatedSelectedDistributions,
		colonySelectOptions, colonySelectionCounts, include,
		exclude, unitlessInclude, unitlessExclude, includeIndices, excludeIndices,
		unitlessManualPickTargets, defaultComponentsLocation, unitlessManualColonyBoundaries,
		imageSize, binarizedManualImages, resizedImages, measurementsCustomColonies,
		numberedCustomColonyMeasurements, manualComponentsArea, manualComponentsAuthalicRadius,
		manualComponentsWidth, manualComponentsLength, manualComponentsEquivalentDiskRadius,
		manualComponentsPerimeterPositions, manualComponentsLocation,
		manualComponentsRegularity, manualComponentsCircularity, manualComponentsDiameter,
		manualComponentsSeparation, manualComponentsVioletFluorescence, manualComponentsGreenFluorescence,
		manualComponentsOrangeFluorescence, manualComponentsRedFluorescence,
		manualComponentsDarkRedFluorescence, manualComponentsAbsorbance,
		pickedComponentsLocation, pickedComponentsPerimeterPositions, pickedComponentsDiameter,
		pickedComponentsSeparation, pickedComponentsRegularity, pickedComponentsCircularity,
		pickedComponentsAbsorbance, pickedComponentsVioletFluorescence, pickedComponentsGreenFluorescence,
		pickedComponentsOrangeFluorescence, pickedComponentsRedFluorescence, pickedComponentsDarkRedFluorescence,
		pickedComponentsProperties, pickedComponentsValues, pickedColoniesCount,
		sumComponentArea, totalComponents, singletonComponentArea, averageSingletonArea,
		totalColonyCount, allComponentsArea,
		allComponentsAuthalicRadius, allComponentsWidth,
		allComponentsLength, allComponentsEquivalentDiskRadius, allComponentsLocation,
		allComponentsRegularity, allComponentsCircularity,
		allComponentsDiameter, allComponentsSeparation, allComponentsVioletFluorescence,
		allComponentsGreenFluorescence, allComponentsOrangeFluorescence,
		allComponentsRedFluorescence, allComponentsDarkRedFluorescence,
		allComponentsAbsorbance, allComponentsPerimeterPositions,
		candidateDiameter, candidateSeparation, candidateRegularity,
		candidateCircularity, candidateAbsorbance,
		candidateVioletFluorescence, candidateGreenFluorescence,
		candidateOrangeFluorescence, candidateRedFluorescence,
		candidateDarkRedFluorescence, (* allComponentsProperties, *)
		labels, populationRuleList, calculatedComponentsProperties,
		maskWidth, topHatThreshold, localAdaptiveThreshold, boundingDiskThreshold,
		regionDifference, boundaryMask, topHatImage, locallyBinarized,
		largeComponents, globallyBinarized, globalLocalMask, selectedComponents,
		allComponentsImage, allMasks, unorderedPerimeters,
		perimeterMeans, allCenters, componentsPerimeters,
		componentsPerimetersMillimeter, allComponentsPerimeters, allComponentsPerimetersMillimeter,
		allComponentsLocationMillimeter, individualColonies, unitlessComponentsLocation,
		unitlessComponentsPerimeterPositions, manualMasks
	},
	
	(* check if the only requested feedback is options or test and not result or preview *)
	testsOrOptionsBool = MatchQ[output, ListableP[Alternatives[Options, Tests]]];
	
	(* if only Tests or Options were requested, skip the calculations *)
	If[testsOrOptionsBool,
		Return[<||>]
	];
	
	(* if there was an error in the option resolution, return failure *)
	If[resolutionFailure,
		Return[$Failed]
	];
	
	(* COUNTING ALGORITHM START *)
	(* OUTLINE *)
	(*
		1) Clean up image to include all colonies
			a) Filter image with top-hat to identify image features
			b) Use local binarization to identify colonies and other components such as plate outlines
				-Local binarization will separate out touching colonies, but creates many artifacts in large dark regions
				-Eliminate non-circular and small items on the local binarization
			c) Use global binarization to get general idea of where things are in the image
				-This will generously pick up and merge together clusters
			d) ImageMultiply global and local binarization
				-ImageMultiply will keep any pixels that are white in both images white, otherwise the pixel will be black
				-This keeps the colonies and gets rid of the artifacts
			e) Remove small components and fill in holes
		2) Calculate all properties of all components
		3) If picking:
			a) Filter out the colonies that meet the given criteria
				- Diameter, Regularity, Circularity, Isolation
			b) Merge in the manually selected colonies
			c) Select the colonies that match the select option
				- This accounts for Include/Exclude
	
	*)
	
	(* find the pixel width by inverting the scale and stripping units *)
	pixelWidth = QuantityMagnitude[1 / scale];
	
	(* hard coded image values *)
	(* boundary around the image for masking *)
	maskWidth = 100;
	topHatThreshold = 20;
	localAdaptiveThreshold = 10;
	smallComponentsThreshold = 25;
	boundingDiskThreshold = 0.2;

	(*RegionDifference evaluates to BooleanRegion (instead of Polygon) in version 12.0 which is not a valid Graphics
	primitive.  So for backwards compatibility, the masking Polygon is manually constructed.*)
	regionDifference =
     With[
		{x1 = ImageDimensions[inputImage][[1]],
			y1 = ImageDimensions[inputImage][[2]],
			xc0 = maskWidth*1,
			yc0 = maskWidth*1,
			xc1 = (ImageDimensions[inputImage] - maskWidth)[[1]],
			yc1 = (ImageDimensions[inputImage] - maskWidth)[[2]]
		},
		Polygon[
			{{0, 0}, {0, y1}, {x1, y1}, {x1,
				0}} -> {{{xc0, yc0}, {xc0, yc1}, {xc1, yc1}, {xc1, yc0}}}
		]
	];

	(* Mask the image *)
	boundaryMask = Graphics[
		regionDifference,
		ImageSize->ImageDimensions[inputImage],
		ImagePadding->None,
		Frame->None,
		PlotRangePadding->None
	];
	
	(* image after the edge mask has been applied *)
	maskedImage = ImageMultiply[inputImage, boundaryMask];
	
	(* even out the lighting with top hat transform *)
	topHatImage = TopHatTransform[maskedImage,DiskMatrix[topHatThreshold]];
	
	(* locally binarize the image with the threshold around the size of colony *)
	locallyBinarized = LocalAdaptiveBinarize[topHatImage, localAdaptiveThreshold];
	
	(* keep only the acceptable colonies based on circularity and size *)
	largeComponents = SelectComponents[locallyBinarized, #Count > smallComponentsThreshold && #BoundingDiskCoverage > boundingDiskThreshold&];
	
	(* globally binarize the image *)
	globallyBinarized = Binarize[topHatImage];
	
	(* combine global and local binarization, because local creates artifacts where nothing is present and global makes things too puffy *)
	(* image multiply only keeps things in both, it removes the artifacts from local and excess pixels around the colonies in global *)
	globalLocalMask = ImageMultiply[largeComponents, globallyBinarized];
	
	(* final transform to clean up small components and fill in the circles for image with calculations *)
	selectedComponents = SelectComponents[globalLocalMask, #Count > smallComponentsThreshold&];
	allComponentsImage = FillingTransform[selectedComponents];
	
	(* Calculate properties of total colonies, PerimeterPositions are not calculated for all colonies because they are slow! *)
	{
		allComponentsArea,
		allComponentsAuthalicRadius,
		allComponentsWidth,
		allComponentsLength,
		allComponentsEquivalentDiskRadius,
		allComponentsLocation,
		allMasks
	} = Map[
		Association @@ ComponentMeasurements[allComponentsImage, #]&,
		{
			"Area",
			"AuthalicRadius",
			"Width",
			"Length",
			"EquivalentDiskRadius",
			"Centroid",
			"Mask"
		}
	];
	
	(* calculate perimeters separately because ImageMeasurements is much faster *)
	unorderedPerimeters = ImageMeasurements[allComponentsImage, "PerimeterPositions"];
	
	(* estimate the center of the unordered parameters *)
	perimeterMeans = Mean/@unorderedPerimeters;
	
	(* find the center that is closest to the perimeter mean to assign its perimeter correctly *)
	allCenters = Values[allComponentsLocation];
	componentsPerimeters = Map[
		(First@Nearest[perimeterMeans->unorderedPerimeters, #1])&,
		allCenters
	];
	
	(* add units to the perimeters and put in association form *)
	componentsPerimetersMillimeter = Quantity[componentsPerimeters * pixelWidth, Millimeter];
	allComponentsPerimeters = Association@@Array[#->componentsPerimeters[[#]]&,Length[allCenters]];
	allComponentsPerimetersMillimeter = Association@@Array[#->componentsPerimetersMillimeter[[#]]&,Length[allCenters]];
	
	(* calculate the output properties based on image measurements *)
	(* note that separation is not calculated for all colonies because it is slow *)
	{
		allComponentsRegularity,
		allComponentsCircularity,
		allComponentsDiameter,
		allComponentsSeparation,
		allComponentsVioletFluorescence,
		allComponentsGreenFluorescence,
		allComponentsOrangeFluorescence,
		allComponentsRedFluorescence,
		allComponentsDarkRedFluorescence,
		allComponentsAbsorbance,
		allComponentsPerimeterPositions
	} = calculateColonyProperties[
		allComponentsLocation,
		allComponentsArea,
		allComponentsAuthalicRadius,
		allComponentsWidth,
		allComponentsLength,
		allComponentsEquivalentDiskRadius,
		allComponentsPerimeters,
		allMasks,
		pixelWidth,
		fluorescenceWavelengthImages,
		absorbanceImage,
		{},
		{}
	];
	
	(* Calculate distributions for all colonies, including manually selected colonies *)
	{
		averageDiameter,
		averageRegularity,
		averageCircularity,
		averageAbsorbance,
		averageVioletFluorescence,
		averageGreenFluorescence,
		averageOrangeFluorescence,
		averageRedFluorescence,
		averageDarkRedFluorescence
	} = Map[
		(* if colonies exist calculate the distribution, otherwise return null *)
		safeEmpiricalDistributionRule,
		{
			allComponentsDiameter,
			allComponentsRegularity,
			allComponentsCircularity,
			allComponentsAbsorbance,
			allComponentsVioletFluorescence,
			allComponentsGreenFluorescence,
			allComponentsOrangeFluorescence,
			allComponentsRedFluorescence,
			allComponentsDarkRedFluorescence
		}
	];
	
	(* add units to the components locations for storage *)
	allComponentsLocationMillimeter = allComponentsLocation * pixelWidth * Millimeter;
	
	(* combine all property rules *)
	allComponentsProperties = Merge[
		{
			allComponentsLocationMillimeter,
			allComponentsPerimetersMillimeter,
			allComponentsDiameter,
			allComponentsRegularity,
			allComponentsCircularity,
			allComponentsSeparation,
			allComponentsAbsorbance,
			allComponentsVioletFluorescence,
			allComponentsGreenFluorescence,
			allComponentsOrangeFluorescence,
			allComponentsRedFluorescence,
			allComponentsDarkRedFluorescence
		},
		Join
	];
	
	(* POPULATION SELECTION STARTS *)
	
	(* select components based on filtering criteria *)
	individualColonies = Select[
		allComponentsProperties,
		And[
			minDiameter <= #[[3]] <= maxDiameter,
       		minRegularity <= #[[4]] <= maxRegularity,
			minCircularity <= #[[5]] <= maxCircularity,
        	minColonySeparation <= #[[6]]
		]&
	];
	
	(* if there are some colonies, break them up by property, otherwise set calculated values to empty list *)
	{
		calculatedComponentsLocation,
		calculatedComponentsPerimeterPositions,
		calculatedComponentsDiameter,
		calculatedComponentsRegularity,
		calculatedComponentsCircularity,
		calculatedComponentsSeparation,
		calculatedComponentsAbsorbance,
		calculatedComponentsVioletFluorescence,
		calculatedComponentsGreenFluorescence,
		calculatedComponentsOrangeFluorescence,
		calculatedComponentsRedFluorescence,
		calculatedComponentsDarkRedFluorescence
	} = If[Length[individualColonies]>0,
		Transpose[Values[individualColonies]],
		ConstantArray[{},12]
	];
	
	(* convert centers and boundaries to be unitless *)
	unitlessComponentsLocation = QuantityMagnitude[calculatedComponentsLocation];
	unitlessComponentsPerimeterPositions = QuantityMagnitude[calculatedComponentsPerimeterPositions];
	
	(* use manual selections of picking targets to override defaults *)
	(* convert manual selection to millimeter and strip units *)
	unitlessManualPickTargets = QuantityMagnitude[Convert[#, Millimeter]]&/@(manualPickTargets/.None->{});
	unitlessManualPickTargets = unitlessManualPickTargets/.{{}}->{};
	
	(* map over perimeters to see if any manual pick target is inside of a colony, if so replace the default center *)
	calculatedComponentsLocation = MapThread[
		SelectFirst[unitlessManualPickTargets, Function[{center}, InPolygonQ[#2, center]], #1]&,
		{unitlessComponentsLocation, unitlessComponentsPerimeterPositions}
	];
	
	(* add units back to the components location *)
	calculatedComponentsLocation = Quantity[calculatedComponentsLocation, Millimeter];
	
	(* combine all property rules *)
	calculatedComponentsProperties = Association@@MapIndexed[
		First[#2]->#1&,
		Transpose[{
			calculatedComponentsLocation,
			calculatedComponentsPerimeterPositions,
			calculatedComponentsDiameter,
			calculatedComponentsSeparation,
			calculatedComponentsRegularity,
			calculatedComponentsCircularity,
			calculatedComponentsAbsorbance,
			calculatedComponentsVioletFluorescence,
			calculatedComponentsGreenFluorescence,
			calculatedComponentsOrangeFluorescence,
			calculatedComponentsRedFluorescence,
			calculatedComponentsDarkRedFluorescence
		}]
	];
	
	(* all components are the same length so pick one to calculate the number of colonies *)
	calculatedColonies = Length[calculatedComponentsLocation];
	
	(* count the raw total components *)
	(* find area of all colonies *)
	totalComponents = Length[allComponentsArea];
	
	(* find the components with regularity (ECL definition) greater than 0.8, which is an estimated cutoff for singleton colonies *)
	singletonComponentArea = PickList[Values[allComponentsArea], Values[allComponentsRegularity], _?(#>0.8&)];
	
	(* calculate the area of all colonies *)
	sumComponentArea = Total[Values[allComponentsArea]];
	
	(* if there are some round colonies, use them as the base case, otherwise count number of components *)
	totalColonyCount = If[Length[singletonComponentArea]>0,
		(* calculate the average area of the singletons *)
		averageSingletonArea = Mean[singletonComponentArea];
		
		(* divide the average singleton area by each total area to estimate the colonies *)
		Round[sumComponentArea/averageSingletonArea, 0.1],
		
		(* use number of components found *)
		totalComponents
	];
	
	(*
		If there are manually selected colonies, calculate their properties and join them with the computed ones,
		otherwise the computed ones account for all colonies
	*)
	{
		pickedComponentsLocation,
		pickedComponentsPerimeterPositions,
		pickedComponentsDiameter,
		pickedComponentsSeparation,
		pickedComponentsRegularity,
		pickedComponentsCircularity,
		pickedComponentsAbsorbance,
		pickedComponentsVioletFluorescence,
		pickedComponentsGreenFluorescence,
		pickedComponentsOrangeFluorescence,
		pickedComponentsRedFluorescence,
		pickedComponentsDarkRedFluorescence
	} = If[Length[Flatten@manualColonyBoundaries]>0,
	
		(*
			Manually selected colonies need to be appended to all after the selected colonies,
			 because they should not be picked up by the colony selections
		*)
		
		(* make the boundaries unitless *)
		unitlessManualColonyBoundaries = QuantityMagnitude[manualColonyBoundaries, Millimeter] / pixelWidth;
		
		(* get binarized image size *)
		imageSize = ImageDimensions[inputImage];
		
		(* create binarized image with plot range of image size *)
		binarizedManualImages = Map[
			Binarize[ColorNegate[Graphics[
				Polygon[#],
				PlotRange -> {{0, imageSize[[1]]}, {0, imageSize[[2]]}},
				ImageSize->imageSize
			]]]&,
			unitlessManualColonyBoundaries
		];
		
		(* resize the images to the same size as the image so pixels match dimensions *)
		resizedImages = ImageResize[#, imageSize]&/@binarizedManualImages;
		
		(* pull out the desired measurements *)
		measurementsCustomColonies = Map[
			customColonyMeasurements,
			resizedImages
		];
		
		(* number the measurements starting counting from number of calculated colonies *)
		numberedCustomColonyMeasurements = Array[
			Map[
				Function[{mapInput},
					#+calculatedColonies->mapInput
				],
				measurementsCustomColonies[[#]]
			]&,
			Length[measurementsCustomColonies]
		];
		
		(* convert to associations organized by measurement type like All Colony measurements *)
		{
			manualComponentsArea,
			manualComponentsAuthalicRadius,
			manualComponentsWidth,
			manualComponentsLength,
			manualComponentsEquivalentDiskRadius,
			manualComponentsPerimeterPositions,
			manualComponentsLocation,
			manualMasks
		} = Association @@@ Transpose[numberedCustomColonyMeasurements];
		
		(* calculate properties for all manually selected colonies *)
		(* calculate the output properties based on image measurements *)
		{
			manualComponentsRegularity,
			manualComponentsCircularity,
			manualComponentsDiameter,
			manualComponentsSeparation,
			manualComponentsVioletFluorescence,
			manualComponentsGreenFluorescence,
			manualComponentsOrangeFluorescence,
			manualComponentsRedFluorescence,
			manualComponentsDarkRedFluorescence,
			manualComponentsAbsorbance,
			manualComponentsPerimeterPositions
		} = Values@calculateColonyProperties[
			manualComponentsLocation,
			manualComponentsArea,
			manualComponentsAuthalicRadius,
			manualComponentsWidth,
			manualComponentsLength,
			manualComponentsEquivalentDiskRadius,
			manualComponentsPerimeterPositions,
			manualMasks,
			pixelWidth,
			fluorescenceWavelengthImages,
			absorbanceImage,
			allComponentsLocation,
			allComponentsPerimeters
		];
		
		(* join manual and all colonies together *)
		MapThread[
			Join,
			{
				{
					calculatedComponentsLocation,
					calculatedComponentsPerimeterPositions,
					calculatedComponentsDiameter,
					calculatedComponentsSeparation,
					calculatedComponentsRegularity,
					calculatedComponentsCircularity,
					calculatedComponentsAbsorbance,
					calculatedComponentsVioletFluorescence,
					calculatedComponentsGreenFluorescence,
					calculatedComponentsOrangeFluorescence,
					calculatedComponentsRedFluorescence,
					calculatedComponentsDarkRedFluorescence
				},
				{
					Quantity[Values[manualComponentsLocation] * pixelWidth, Millimeter],
					Quantity[manualComponentsPerimeterPositions* pixelWidth, Millimeter],
					manualComponentsDiameter,
					manualComponentsSeparation,
					manualComponentsRegularity,
					manualComponentsCircularity,
					manualComponentsAbsorbance,
					manualComponentsVioletFluorescence,
					manualComponentsGreenFluorescence,
					manualComponentsOrangeFluorescence,
					manualComponentsRedFluorescence,
					manualComponentsDarkRedFluorescence
				}
			}
		],
		
		(* return only calculated colonies if there are no manually selected ones *)
		{
			calculatedComponentsLocation,
			calculatedComponentsPerimeterPositions,
			calculatedComponentsDiameter,
			calculatedComponentsSeparation,
			calculatedComponentsRegularity,
			calculatedComponentsCircularity,
			calculatedComponentsAbsorbance,
			calculatedComponentsVioletFluorescence,
			calculatedComponentsGreenFluorescence,
			calculatedComponentsOrangeFluorescence,
			calculatedComponentsRedFluorescence,
			calculatedComponentsDarkRedFluorescence
		}
		
	];
	
	(* Calculate distributions for all colonies, including manually selected colonies *)
	{
		candidateDiameter,
		candidateSeparation,
		candidateRegularity,
		candidateCircularity,
		candidateAbsorbance,
		candidateVioletFluorescence,
		candidateGreenFluorescence,
		candidateOrangeFluorescence,
		candidateRedFluorescence,
		candidateDarkRedFluorescence
	} = Map[
		(* if colonies are selected calculate the distribution, otherwise return null *)
		safeEmpiricalDistributionList,
		{
			pickedComponentsDiameter,
			pickedComponentsSeparation,
			pickedComponentsRegularity,
			pickedComponentsCircularity,
			pickedComponentsAbsorbance,
			pickedComponentsVioletFluorescence,
			pickedComponentsGreenFluorescence,
			pickedComponentsOrangeFluorescence,
			pickedComponentsRedFluorescence,
			pickedComponentsDarkRedFluorescence
		}
	];
	
	(* combine all property rules *)
	pickedComponentsProperties = Association@@MapIndexed[
		First[#2]->#1&,
		Transpose[{
			pickedComponentsLocation,
			pickedComponentsPerimeterPositions,
			pickedComponentsDiameter,
			pickedComponentsSeparation,
			pickedComponentsRegularity,
			pickedComponentsCircularity,
			pickedComponentsAbsorbance,
			pickedComponentsVioletFluorescence,
			pickedComponentsGreenFluorescence,
			pickedComponentsOrangeFluorescence,
			pickedComponentsRedFluorescence,
			pickedComponentsDarkRedFluorescence
		}]
	];
	
	(* before we add units, we want to find if our include/exclude options match the data *)
	(* use first in lookup to see the association inside the primitive *)
	{
		include,
		exclude
	} = Transpose[
		Map[
			Lookup[First[#], {Include, Exclude}]&,
			select
		]
	];
	
	(* convert to pixels and pull off units for InPolygonQ *)
	{
		unitlessInclude,
		unitlessExclude
	} = Map[
		QuantityMagnitude,
		{include/.None->{}, exclude/.None->{}}
	];
	
	(* convert include and exclude locations to indices in calculated components *)
	{
		includeIndices,
		excludeIndices
	} = Map[
		overlappingManualSelection[#, QuantityMagnitude[pickedComponentsPerimeterPositions], QuantityMagnitude[pickedComponentsLocation]]&,
		{unitlessInclude, unitlessExclude}
	];
	
	(* Calculate colonies that belong to the specified populations *)
	(* go to helper function to handle one select at a time *)
	(* pass in includeIndices, and excludeIndices to adjust selections *)
	selectedColoniesList = colonySelector[
		select,
		calculatedComponentsProperties,
		includeIndices,
		excludeIndices,
		pickedComponentsProperties
	];
	
	(* pull out the colony values and set Nulls if empty *)
	selectedColoniesValues = Replace[Values[#], {}->Null]& /@ selectedColoniesList;
	
	(* Calculate distributions for population colonies *)
	calculatedSelectedDistributions = colonyDistributions /@ selectedColoniesList;
	
	(* pull out the distributions of interest *)
	{
		selectedDiameterDistributions,
		selectedSeparationDistributions,
		selectedRegularityDistributions,
		selectedCircularityDistributions,
		selectedAbsorbanceDistributions,
		selectedVioletFluorescenceDistributions,
		selectedGreenFluorescenceDistributions,
		selectedOrangeFluorescenceDistributions,
		selectedRedFluorescenceDistributions,
		selectedDarkRedFluorescenceDistributions
	} = Transpose[calculatedSelectedDistributions];
	
	(* population names and specified options *)
	colonySelectOptions = ToList[select];
	colonySelectionLabels = Lookup[#[[1]], PopulationName]& /@ colonySelectOptions;
	
	(* number of colonies in each selected population *)
	colonySelectionCounts = Length /@ selectedColoniesList;
	
	(* pull the values from the rules in the association *)
	pickedComponentsValues = Replace[Values[pickedComponentsProperties], {}->Null];
	
	(* picked components are the same length so pick one to calculate the number of colonies *)
	pickedColoniesCount = Length[pickedComponentsLocation];
	
	(* save the default component locations to help keep track of manually selected targets *)
	defaultComponentsLocation = QuantityMagnitude[pickedComponentsLocation];
	
	(* form named list of rules *)
	labels = {
		"Location", "Boundary", "Diameter", "Separation", "Regularity",
		"Circularity", "Absorbance", "VioletFluorescence", "GreenFluorescence",
		"OrangeFluorescence", "RedFluorescence", "DarkRedFluorescence"
	};
	
	populationRuleList = Map[
		If[# === Null,
			Null,
			MapThread[Rule, {labels, Transpose[#]}]
		]&,
		selectedColoniesValues
	];
	
	allComponentsPerimetersMillimeter = QuantityArray[QuantityMagnitude[#], {Millimeter, Millimeter}] & /@ allComponentsPerimetersMillimeter;
	
	(*Return associations *)
	<|
		Intermediate -> <|
			(* store the default centers to use in Complement in preview to identify manually selected centers *)
			DefaultCenters -> defaultComponentsLocation,
			PopulationValues -> selectedColoniesValues,
			CandidateProperties -> pickedComponentsValues,
			IncludeDefault -> QuantityMagnitude[include/.None->{}],
			ExcludeDefault -> QuantityMagnitude[exclude/.None->{}]
		|>,
		Packet -> <|
			
			(* All Colonies *)
			TotalColonyCount -> totalColonyCount,
			SingletonColonyCount -> Length[singletonComponentArea],
			ComponentCount -> totalComponents,
			Replace[ColonyLocations] -> Values@allComponentsLocationMillimeter,
			Replace[ColonyBoundaries] -> Values@allComponentsPerimetersMillimeter,
			Replace[ColonyDiameters] -> Values@allComponentsDiameter,
			Replace[ColonyRegularityRatios] -> Values@allComponentsRegularity,
			Replace[ColonyCircularityRatio] -> Values@allComponentsCircularity,
			Replace[ColonySeparations] -> Values@allComponentsSeparation,
			Replace[ColonyAbsorbances] -> Values@allComponentsAbsorbance,
			Replace[ColonyVioletFluorescences] -> Values@allComponentsVioletFluorescence,
			Replace[ColonyGreenFluorescences] -> Values@allComponentsGreenFluorescence,
			Replace[ColonyOrangeFluorescences] -> Values@allComponentsOrangeFluorescence,
			Replace[ColonyRedFluorescences] -> Values@allComponentsRedFluorescence,
			Replace[ColonyDarkRedFluorescences] -> Values@allComponentsDarkRedFluorescence,
			AverageDiameter -> averageDiameter,
			AverageRegularity -> averageRegularity,
			AverageCircularity -> averageCircularity,
			AverageAbsorbance -> averageAbsorbance,
			AverageVioletFluorescence -> averageVioletFluorescence,
			AverageGreenFluorescence -> averageGreenFluorescence,
			AverageOrangeFluorescence -> averageOrangeFluorescence,
			AverageRedFluorescence -> averageRedFluorescence,
			AverageDarkRedFluorescence -> averageDarkRedFluorescence,
			
			(* Population colonies *)
			Replace[PopulationNames] -> colonySelectionLabels,
			Replace[ColonySelections] -> colonySelectOptions,
			Replace[PopulationTotalColonyCount] -> colonySelectionCounts,
			Replace[PopulationProperties] -> populationRuleList,
			Replace[PopulationDiameters] -> selectedDiameterDistributions,
			Replace[PopulationSeparations] -> selectedSeparationDistributions,
			Replace[PopulationRegularities] -> selectedRegularityDistributions,
			Replace[PopulationCircularities] -> selectedCircularityDistributions,
			Replace[PopulationAbsorbances] -> selectedAbsorbanceDistributions,
			Replace[PopulationVioletFluorescence] -> selectedVioletFluorescenceDistributions,
			Replace[PopulationGreenFluorescence] -> selectedGreenFluorescenceDistributions,
			Replace[PopulationOrangeFluorescence] -> selectedOrangeFluorescenceDistributions,
			Replace[PopulationRedFluorescence] -> selectedRedFluorescenceDistributions,
			Replace[PopulationDarkRedFluorescence] -> selectedDarkRedFluorescenceDistributions
			
			(* Contamination information *)
		
		|>
	|>

];

(* if values exist calculate the empirical distribution, calculate it *)
safeEmpiricalDistributionRule = If[Length[Values[#]]>0,
	EmpiricalDistribution[Values[#]],
	Null
]&;

safeEmpiricalDistributionList = If[Length[#]>0,
	EmpiricalDistribution[#],
	Null
]&;

(* Colony Property Functions *)

(* REGULARITY *)
regularityFunction = Function[{area, authalicRadius}, area / (authalicRadius^2 * Pi)];

(* CIRCULARITY *)
circularityFunction = Function[{width, length}, width / length];

(* DIAMETER *)
diameterFunction = Function[{equivalentDiskRadius, pixelWidth}, 2 * equivalentDiskRadius * pixelWidth];

(* separation distance function *)
separationFunction = Function[
	{perimeterPositions, separationBoundaries, pixelWidth},
	pixelWidth * separationCalculation[separationBoundaries, perimeterPositions]
];

(* fluorescence functions *)
(* return associations for each fluorescence wavelength *)
fluorescenceComponentsFunction[masks_, fluorescenceImageAssociation_] := Values[individualIntensity[masks, #]& /@ fluorescenceImageAssociation];
(* single calculation *)
(* if no image present, return zeros *)
individualIntensity[masks_, image : Null] := AssociationThread[Keys[masks], 0];
individualIntensity[masks_, image_] := Module[
	{rows},
	
	(* number of rows in image *)
	rows = ImageDimensions[image][[2]];
	
	Map[
		pixelIntensities[image, #, rows]&,
		masks
	]
];

pixelIntensities[image_, mask_, rows_]:= With[
	{
		(* pixels from image to xy domain *)
		xyPixels = pixelTransform[#, rows]&/@mask["NonzeroPositions"]
	},
	
	Mean[Flatten[PixelValue[image, xyPixels]]]
];

(* converts from MM image dimensions (row, column) to (x,y) coordinates *)
pixelTransform[{imageRow_, imageColumn_}, rows_] := {imageColumn - 1/2, rows - imageRow + 1/2};

(*separation function for components *)
separationComponentsFunction[candidateCenters_, allCenters_, allPerimeters_, pixelWidth_] := MapIndexed[
	First[#2] -> findCenter[#1, allCenters, allPerimeters]*pixelWidth*Millimeter&,
	candidateCenters
];

findCenter[myCenter_, allCenters_, allPerimeters_]:= Module[
	{myPosition, myPerimeters, otherPerimeters, otherCenters},
	
	(* find the position we are looking at *)
	myPosition = Position[allCenters, myCenter];
	myPerimeters = allPerimeters[[First@myPosition]];
	
	(* remove the colony of interest from the existing list *)
	otherPerimeters = Delete[allPerimeters, myPosition];
	otherCenters = Delete[allCenters, myPosition];
	
	(* calculate the isolation *)
	myIsolationFunc[myCenter, otherCenters, myPerimeters, otherPerimeters]
	
];

(* individual isolation calculation *)
myIsolationFunc[myCenter_, otherCenters_, myPerimeters_, otherPerimeters_]:=Module[
	{nearestPerimeters, flatNearestPerimeters},
	
	(* find perimeters of colonies with nearest 10 centers from the given center *)
	nearestPerimeters = Nearest[otherCenters->otherPerimeters, myCenter, 10];
	
	(* flatten nearest boundaries to search over *)
	flatNearestPerimeters = Flatten[nearestPerimeters, 1];
	
	(* find nearest point to point in 10 selected boundaries *)
	Min[Nearest[flatNearestPerimeters->{"Distance"}, myPerimeters]]

];

(* colony property calculations *)
calculateColonyProperties[
	allComponentsLocation_,
	componentsArea_,
	componentsAuthalicRadius_,
	componentsWidth_,
	componentsLength_,
	componentsEquivalentDiskRadius_,
	componentsPerimeterPositions_,
	masks_,
	pixelWidth_,
	fluorescenceWavelengthImages_,
	absorbanceImage_,
	isolationCenters_,
	isolationPerimeters_
]:= Module[
	{
		componentsRegularity, componentsCircularity, componentsDiameter,
		componentsSeparation, componentsVioletFluorescence, componentsGreenFluorescence,
		componentsOrangeFluorescence, componentsRedFluorescence, componentsDarkRedFluorescence,
		componentsAbsorbance, mergedComponentsPerimeterPositions, allLocations,
		allPerimeters
	},

	(* Combine values to get the regularity, circularity, diameter, and separation Functions above *)
	componentsRegularity = regularityFunction[componentsArea, componentsAuthalicRadius];
	componentsCircularity = circularityFunction[componentsWidth, componentsLength];
	
	(*
		round any values larger than 1 to 1 since that is the theoretical max,
		but small numerical error from counting perimeter from pixel edges makes it larger than 1
	*)
	componentsRegularity = Min[#, 1]&/@componentsRegularity;
	
	(* Add units to Diameter *)
	componentsDiameter = diameterFunction[componentsEquivalentDiskRadius, pixelWidth] * Millimeter;
	
	(* Separation *)
	(* check if we are calculating properties of the algorithmic case if isolationCenters/isolationPerimeters are empty *)
	(* for the manual case we want to combine the locations/perimeters together from the algorithmic and manual options *)
	(* in the algorithmic case the isolationCenters/Perimeters are empty *)
	allLocations = Join[Values@allComponentsLocation, Values@isolationCenters];
	
	allPerimeters = If[isolationCenters === {},
		Join[Values@componentsPerimeterPositions, Values@isolationPerimeters],
		Join[First/@Values[componentsPerimeterPositions], Values@isolationPerimeters]
	];
	
	componentsSeparation = separationComponentsFunction[Values@allComponentsLocation, allLocations, allPerimeters, pixelWidth];
	
	(* calculate fluorescence using mask and fluorescence image *)
	(* need to pull out the correct wavelength from the selection and look up the correct image *)
	(* batch key gets added from BatchTranspose and we want to drop it *)
	{
		componentsVioletFluorescence,
		componentsGreenFluorescence,
		componentsOrangeFluorescence,
		componentsRedFluorescence,
		componentsDarkRedFluorescence
	} = fluorescenceComponentsFunction[masks, KeyDrop[fluorescenceWavelengthImages, Batch]];
	
	(* find absorbances for all values *)
	componentsAbsorbance = individualIntensity[masks, absorbanceImage];
	
	(* consolidate boundaries into a single list, there will be two or more if there is a shared corner *)
	mergedComponentsPerimeterPositions = (Join @@ #)&/@componentsPerimeterPositions;
	
	(* return all calculated properties *)
	{
		componentsRegularity,
		componentsCircularity,
		componentsDiameter,
		componentsSeparation,
		componentsVioletFluorescence,
		componentsGreenFluorescence,
		componentsOrangeFluorescence,
		componentsRedFluorescence,
		componentsDarkRedFluorescence,
		componentsAbsorbance,
		mergedComponentsPerimeterPositions
	}

];

(*
	for manually selected colonies, calculated desired properties off of each image
*)
customColonyMeasurements[image_] := First[Values[ComponentMeasurements[
	image,
	{
		"Area",
		"AuthalicRadius",
		"Width",
		"Length",
		"EquivalentDiskRadius",
		"PerimeterPositions",
		"Centroid",
		"Mask"
	},
	(* without this criteria the the borders of the image get detected *)
	(#Width>3&)
]]];

(*
	note the difference between inPolygonQ and InPolygonQ,
	lower case one is used to ensure  valid inputs are passed to the upper case one
*)
(* overloads to InPolygonQ which does not work on empty list *)
inPolygonQ[boundaries_, selection : ListableP[{}]] := False;
(*
	if a set of points is passed as input to InPolygonQ, a list is returned, check if one is true.
	option resolution forces include/exclude to always be a list of points instead of individual points
*)
inPolygonQ[boundaries_, selection : {{_?NumericQ, _?NumericQ}..}] := (Or @@ InPolygonQ[boundaries, #])& /@ selection;
(* if there are multiple selections we need to map over them first *)
inPolygonQ[boundaries_, selection_List] := (inPolygonQ[boundaries, #])& /@ selection;
(* if there is only one point just call InPolygonQ[] *)
inPolygonQ[boundaries_, selection : {_?NumericQ, _?NumericQ}] := InPolygonQ[boundaries, selection];


(* find if include/exclude match the center or are inside colony boundaries *)
overlappingManualSelection[selection_, allComponentsPerimeterPositions_, allComponentsLocation_] := Module[
	{
		centerPositions, polygonPositionBooleans, polygonPositions,
		roundingTolerance
	},
	
	(* find indices where selection matches allComponentsLocation within rounding tolerance *)
	roundingTolerance = 10^-6;
	centerPositions = Map[
		Flatten[
			Position[
				Round[allComponentsLocation, roundingTolerance],
				Alternatives @@ (Round[#, roundingTolerance])
			]
		]&,
		selection
	];
	
	(* find indices where the selection overlaps a perimeter position *)
	(* the firsts remove an extra level of listed ness in the selection and boundaries *)
	polygonPositionBooleans = Map[
		inPolygonQ[#, selection]&,
		allComponentsPerimeterPositions
	];
	
	(* find the positions where point was in the polygon *)
	polygonPositions = Position[polygonPositionBooleans, True];
	
	(* separate out the polygon positions by the index they belong to (second value) *)
	polygonPositions = GroupBy[polygonPositions, (#[[2]] &) -> (#[[1]] &)];
	
	(*
		to ensure each selection has at least an empty list apply a replace rule on each index pointing to an empty list,
		those with selections will be replaced
	*)
	polygonPositions = ReplaceRule[
		Map[# -> {}&, Range[Length[selection]]],
		Normal[polygonPositions]
	];
	
	(* sort them to put the keys in the correct order, and pull out the values to be the same structure as center positions *)
	polygonPositions = Values[Sort[polygonPositions]];
	
	(* merge the selected positions and remove duplicates *)
	Flatten[DeleteDuplicates[Join[#]]]& /@ Transpose[{centerPositions, polygonPositions}]
];

(* helper to calculated colony distributions *)
colonyDistributions[selectedColoniesAssociation_] := Module[
	{
		distributionColumns
	},
	
	(* get the correct columns to look in *)
	distributionColumns = Map[
		colonyPropertyColumns,
		{
			Diameter,
			Isolation,
			Regularity,
			Circularity,
			Absorbance,
			VioletFluorescence,
			GreenFluorescence,
			OrangeFluorescence,
			RedFluorescence,
			DarkRedFluorescence
		}
	];
	
	(* return the distributions after mapping across the columns to get the data *)
	Map[
		associationColumnDistribution[selectedColoniesAssociation, #]&,
		distributionColumns
	]
];

associationColumnDistribution[colonyAssociation_, column_] := Module[
	{
		featureValues
	},
	
	(* pull the values out of the association *)
	featureValues = Values[colonyAssociation[[;;, column]]];
	
	(* if there are values, calculate the distribution, otherwise return Null *)
	If[Length[featureValues]>0,
		(* calculate the distribution *)
		EmpiricalDistribution[featureValues],
		Null
	]
];


(* helper function to handle ColonySelection inputs *)
(* multiple ColonySelections *)
colonySelector[
	select_List,
	algoProperties_,
	include_,
	exclude_,
	allProperties_
] := MapThread[
	singleColonySelection[#1, algoProperties, #2, #3, allProperties]&,
	{select, include, exclude}
];

(* single ColonySelection *)
colonySelector[
	select_,
	algoProperties_,
	include_,
	exclude_,
	allProperties_
] := {singleColonySelection[
	select,
	algoProperties,
	include,
	exclude,
	allProperties
]};

(* select colonies for one selection*)
singleColonySelection[
	select_,
	algoProperties_,
	include_,
	exclude_,
	allProperties_
] := Module[
	{
		selectedFeatureColonies, selectedColonies
	},
	
	(* for each feature, select the features that match the criteria *)
	selectedFeatureColonies = Sort[singlePopulationSelection[select, algoProperties]];
	
	(* select the colonies that meet the specified criteria *)
	selectedColonies = KeyTake[algoProperties, selectedFeatureColonies];
	
	(* for exclude we want to drop keys from the current selection *)
	selectedColonies = KeyDrop[selectedColonies, exclude];
	
	(* for include we want to add values from all components properties *)
	selectedColonies = Join[selectedColonies, KeyTake[allProperties, include]];
	
	(*
		sort colonies to preserve order with all components
		only for inspect, no logic depends on this order
	*)
	selectedColonies = KeySort[selectedColonies]

];

(* helper to look up fluorescence feature *)
fluorescenceColumn[Fluorescence, wavelength_] := wavelengthFluorescenceColors[wavelength];
fluorescenceColumn[property_, wavelength_] := property;

(* lookup the threshold symbol used based on the feature *)
findFeatureThreshold[feature_] := ReplaceAll[feature,
	{
		Diameter -> ThresholdDiameter, Isolation -> ThresholdDistance,
		Regularity -> ThresholdRegularity, Circularity -> ThresholdCircularity,
		Fluorescence|Absorbance -> ThresholdPlaceholder
	}
];

(* case with multiple features *)
singlePopulationSelection[population_MultiFeatured, algoProperties_]:=Module[
	{
		head, rules, select, numberOfColonies, numberOfDivisions,
		colonySelectionLabel, threshold, dye, features,
		singleFeatureColonies, intersectingColonies, sortingColonyOrder,
		sortedColonies
	},
	
	(* pull off the head and rules for the unit operation *)
	{head, rules} = primitiveHeadBody[population];
	
	(* pull out the individual keys needed for the feature and pass to single feature selection *)
	{
		select, numberOfColonies, numberOfDivisions,
		colonySelectionLabel, threshold, dye, features
	} = Lookup[rules,
		{
			Select, NumberOfColonies, NumberOfDivisions,
			PopulationName, Threshold, Dye, Features
		}
	];
	
	(* map over them to find the single feature selection *)
	singleFeatureColonies = MapThread[
		singleFeatureSelection[##, algoProperties]&,
		{features, select, numberOfDivisions, threshold, dye}
	];
	
	(* intersect the colonies to get the colonies that have the desired features *)
	intersectingColonies = Intersection@@singleFeatureColonies;
	
	(* sort the output colonies by the output order of the first feature *)
	sortingColonyOrder = First[singleFeatureColonies];
	
	(* sort the colonies by the first feature *)
	sortedColonies = SortBy[intersectingColonies, First[Position[sortingColonyOrder, #]]&];
	
	(* overlap the features to select the right colonies *)
	(* apply number of colonies, which is either a number or all *)
	If[numberOfColonies === All,
		sortedColonies,
		Take[sortedColonies, Min[numberOfColonies, Length[sortedColonies]]]
	]
];

(* case with all colonies, just return all the keys *)
singlePopulationSelection[population_AllColonies, algoProperties_]:=Keys[algoProperties];

(* case with one feature *)
singlePopulationSelection[population_, algoProperties_]:=Module[
	{
		feature, rules, numberOfColonies, numberOfDivisions,
		colonySelectionLabel, threshold, dye, thresholdSymbol, select,
		selectedColonies
	},
	
	(* pull off the head and rules for the unit operation *)
	{feature, rules} = primitiveHeadBody[population];
	
	(* find threshold symbol based on the head, for Fluorescence and Absorbance use a placeholder *)
	(* lookup ThresholdSymbol based on the primitive head *)
	thresholdSymbol = findFeatureThreshold[feature];
	
	(* pull out the individual keys needed for the feature and pass to single feature selection *)
	{
		select, numberOfColonies, numberOfDivisions,
		colonySelectionLabel, threshold, dye
	} = Lookup[rules,
		{
			Select, NumberOfColonies, NumberOfDivisions,
			PopulationName, thresholdSymbol, Dye
		},
		(* fluorescence and absorbance threshold should not find anything and be set to Null *)
		Null
	];
	
	(* select colonies and return them in sorted order *)
	selectedColonies = singleFeatureSelection[feature, select, numberOfDivisions, threshold, dye, algoProperties];
	
	(* apply number of colonies, which is either a number or all *)
	If[numberOfColonies === All,
		selectedColonies,
		Take[selectedColonies, Min[numberOfColonies, Length[selectedColonies]]]
	]
	
];

(* find the keys (colony numbers) that meet the single feature criteria *)
singleFeatureSelection[
	feature_,
	select_,
	numberOfDivisions_,
	threshold_,
	dye_,
	allComponentsProperties_
] := Module[
	{
		selectedFeature, featureColumn, featureAssociation, totalComponentLength, selectedLength,
		rangeStart, rangeEnd, sortedFeatureAssociationKeys, wavelength, specifiedDivision,
		selectFunction, selectedColonies
	},
	
	(* if the feature is Fluorescence, we need to look at the wavelength to pull the correct column *)
	selectedFeature = If[MatchQ[feature, Fluorescence],
		wavelength = Lookup[fluorescenceDyeTable, dye];
		wavelengthFluorescenceColors[wavelength],
		feature
	];
	
	(* look up feature column *)
	featureColumn = colonyPropertyColumns[selectedFeature];
	
	(* pull out column of interest from all components *)
	featureAssociation = allComponentsProperties[[;;, featureColumn]];
	
	Switch[select,
		Min|Max,
			(* DIVISIONS *)
			(* find length of features to be selected based on divisions and total components *)
			totalComponentLength = Length[featureAssociation];
			selectedLength = totalComponentLength / numberOfDivisions;
			
			(* if select is max, take the first division since sorted from highest to lowest, if min take the lowest is the numberOfDivisions *)
			specifiedDivision = If[MatchQ[select, Max], 1, numberOfDivisions];
			
			(* find the range that is to be selected from *)
			rangeStart = Round[selectedLength * (specifiedDivision - 1) + 1];
			rangeEnd = Round[selectedLength * (specifiedDivision)];
			
			(* sort the components by the right hand side  *)
			sortedFeatureAssociationKeys = Keys[Sort[featureAssociation, Greater]];
			
			(* return the keys from the selected range *)
			sortedFeatureAssociationKeys[[rangeStart ;; rangeEnd]],
		
		AboveThreshold|BelowThreshold,
			(* THRESHOLDS *)
			selectFunction = If[select === AboveThreshold,
				# > threshold&,
				# < threshold&
			];
			selectedColonies = Select[featureAssociation, selectFunction];
			
			(* sort from highest to lowest if AboveThreshold or lowest to highest with BelowThreshold *)
			selectedColonies = If[select === AboveThreshold,
				Sort[selectedColonies, Greater],
				Sort[selectedColonies]
			];
			
			(* return the selected keys *)
			Keys[selectedColonies],
		
		Positive|Negative,
			(* CLUSTERS *)
			(* TODO, add a warning if the clusters do not automatically split into two groups *)
		
			(* split into two clusters *)
			clusters = FindClusters[Values@featureAssociation -> featureAssociation, 2];
			(* sort the clusters by fluorescence so that the first group is low and the second is high *)
			sortedClusters = Sort[clusters, Mean@Values[#1] < Mean@Values[#2] &];
			(* return the requested Positive or Negative cluster *)
			selectedCluster = select/.{Positive->2, Negative -> 1};
			Keys[sortedClusters[[selectedCluster]]]
	
	]

];

(* if neither preview matches return Null *)
analyzePreviewColonies[___]:=<|Preview->Null|>;

(* ==================================== *)
(*      AnalyzeColoniesPreview          *)
(*              COUNT                   *)
(* ==================================== *)

(* analyzePreviewColonies overload if AnalysisType -> Count *)
(* image is input object *)
analyzePreviewColonies[KeyValuePattern[{
	ResolvedInputs -> KeyValuePattern[{
		Scale -> graphicsScale_,
		ImageData -> imageFile_
	}],
	ResolvedOptions -> KeyValuePattern[{
		AnalysisType -> Count
	}],
	Packet -> KeyValuePattern[{
		(* ColonyBoundaries is a list of QuantityArrays denoting boundaries for every connected cluster.
		   Length[ColonyBoundaries] < colonyCount. *)
		Replace[ColonyBoundaries] -> allComponentsPerimetersMillimeter_,
		(* This is the colony count, with the clusters split *)
		TotalColonyCount -> colonyCount_,
		Replace[PopulationNames] -> colonySelectionLabels_,
		(* PopulationProperties  *)
		Replace[PopulationProperties] -> namedPopulationProperties_,
		Replace[PopulationTotalColonyCount] -> colonySelectionCounts_
		
	}]
}]] := Module[{allSelectionLabels, allUnitlessBoundaries, unitlessBoundariesOfColonyByPopulations,
	listOfBoundariesBelongingToNoPopulation, listOfBoundariesBelongingToMultiplePopulations, listOfBoundariesBelongingToSinglePopulation,
	otherPolygons, singleColonyPolgons, singleColonyPolgonsWithColorDirectives, multiColonyPolygons,coloniesLayer,
	informationTables, preview},

	(* add all and no colonies to the labels lists *)
	allSelectionLabels = colonySelectionLabels;

	(*Strip away units for all identified colonies*)
	allUnitlessBoundaries = QuantityMagnitude[allComponentsPerimetersMillimeter];

	(*Get all the boundaries from namedPopulationProperties, and strip away units*)
	unitlessBoundariesOfColonyByPopulations = QuantityMagnitude[Lookup[namedPopulationProperties, "Boundary"]];

	(*Remove colony boundaries frm allUnitlessBoundaries that belong to at least one population*)
	listOfBoundariesBelongingToNoPopulation = Complement[allUnitlessBoundaries, Sequence @@ unitlessBoundariesOfColonyByPopulations];

	(*Identify those boundaries that belong to multiple populations*)
	listOfBoundariesBelongingToMultiplePopulations =
		Cases[Tally[Join @@ unitlessBoundariesOfColonyByPopulations], {boundary_, _Integer?(# > 1 &)} :>boundary];

	(*Remove colony boundaries from unitlessBoundaries belonging to multiple populations*)
	listOfBoundariesBelongingToSinglePopulation = DeleteCases[unitlessBoundariesOfColonyByPopulations,
		Alternatives @@ listOfBoundariesBelongingToMultiplePopulations, {2}];

	(*=====build the graphical primitives for the static preview=====*)
	otherPolygons = Polygon[listOfBoundariesBelongingToNoPopulation];
	multiColonyPolygons = Polygon[listOfBoundariesBelongingToMultiplePopulations];

	(*Convert list of list of coordinate to list of Polygons. Then riffle in EdgeForm[polygonColor] directives.*)
	singleColonyPolgons = Polygon/@listOfBoundariesBelongingToSinglePopulation;
	singleColonyPolgonsWithColorDirectives =
		Riffle[singleColonyPolgons,
			{EdgeForm[polygonColor[{1}]],EdgeForm[polygonColor[{2}]],EdgeForm[polygonColor[{3}]]},
			{1,2*Length[singleColonyPolgons], 2}];

	(*Build the graphics containing all the polygons*)
	coloniesLayer =
		Graphics[{
			FaceForm[{Opacity[0.0]}],
			EdgeForm[{polygonColor[{}], Dashing[{}], AbsoluteThickness[0.75]}],
			otherPolygons,
			singleColonyPolgonsWithColorDirectives,
			FaceForm[{Opacity[0.0]}],
			EdgeForm[{polygonColor[{1,2}], Dashing[{}], AbsoluteThickness[0.75]}],
			multiColonyPolygons
		}];

	(*Build table on the right side of the interactive image*)
	informationTables = Style[
		Column[{
			Grid[{
				{Style["Legend", FontSize -> 16]},
				{staticPreviewColonyLegend[allSelectionLabels]},
				{Row[{Style["Counts", FontSize -> 16]}]},
				{staticPreviewColonyCountTable[{allSelectionLabels, colonySelectionCounts}, colonyCount]}
			},
				ItemSize -> {25},
				Alignment -> {Left},
				Spacings -> {{}, {0, 0.5, 2, 0.5}},
				Dividers -> {False, {False, False, True, False, False}}
			]
		}, Frame -> All],
		FontSize -> 13,
		FontFamily -> "Verdana",
		ShowStringCharacters -> False
	];

	preview = Grid[{{
			DynamicModule[{currentImage = "image"},
				InteractiveImage[
					ECLImageAlbum[Dynamic[currentImage], {"image"->imageFile}],
					coloniesLayer,
					ImageScale -> graphicsScale,
					AutoDownsampling -> True,
					ContentSize -> 800
				]
			],
			informationTables
		}}
	];

	<|
		Preview -> preview
	|>
];

(*This makes the legend for the static preview*)
staticPreviewColonyLegend[selectionLabel_List] := Module[
	{
		selectionIconList, unselectedIcon, multipleSelectionIcon, unselectedRow, multipleSelectionRow, gridList
	},

	selectionIconList = Array[colonyIcon, Length[selectionLabel]];
	unselectedIcon = colonyIcon[Unevaluated@Sequence[]];
	multipleSelectionIcon = colonyIcon[Unevaluated@Sequence[1, 2]];

	unselectedRow = {{unselectedIcon, Pane["Outside selected population"]}};
	multipleSelectionRow = {{multipleSelectionIcon, Pane["Member of multiple populations"]}};

	gridList =
		Join[
			selectionTableRows[{selectionIconList,selectionLabel}],
			unselectedRow,
			multipleSelectionRow
		];

	Grid[gridList,
		Alignment -> {Left,Left},
		Dividers -> None,
		ItemSize -> {{Full, Fit}}
	]

];

(*This makes the formatted table with the counts*)
staticPreviewColonyCountTable[selectionNamesAndCount_List, totalCount_] := Module[
	{
		gridList, totalCountsRow
	},

	totalCountsRow = {{Pane["Total Colonies"], totalCount}};

	gridList =
		Join[
			countTableRows[selectionNamesAndCount],
			totalCountsRow
		];

	Grid[gridList,
		Alignment -> {Left,Right},
		Dividers -> None,
		ItemSize -> {{Fit, Full}}
	]
];

selectionTableRows[selectionIconAndLabel_List] :=
	MapThread[
		{#1, Pane[Style[#2, FontSlant -> Italic, FontColor -> RGBColor[0, .5, 0.75]]]} &,
		selectionIconAndLabel
	];

(*This makes a list of rows of colony count by selection*)
countTableRows[selectionNamesAndCount_List] :=
    MapThread[
		{Pane[Row[{Style[#1, FontSlant -> Italic, FontColor -> RGBColor[0, .5, 0.75]]}]], #2} &,
		selectionNamesAndCount
	];


analyzePreviewColonies[KeyValuePattern[{
	UnresolvedInputs -> KeyValuePattern[{
		InputData -> inputObject_
	}],
	ResolvedInputs -> KeyValuePattern[{
		FluorescenceWavelengthImages -> fluorescenceWavelengthImages_,
		AbsorbanceWavelengthImages -> absorbanceImage_,
		Scale -> graphicsScale_,
		ImageData -> imageFile_
	}],
	ResolvedOptions -> resolvedOptions_,
	Packet -> KeyValuePattern[{
		Replace[PopulationNames] -> colonySelectionLabels_,
		TotalColonyCount -> colonyCount_
	}],
	Intermediate -> KeyValuePattern[{
		DefaultCenters -> defaultCenters_,
		PopulationValues -> populationProperties_,
		CandidateProperties -> colonyProperties_,
		IncludeDefault -> includeDefault_,
		ExcludeDefault -> excludeDefault_
	}]
}]] := Module[
	{
		populationCenters, populationPositions,
		myDynamicModule, allSelectionLabels,
		lengthPopulations, extraImageLabels, extraImages, labeledImageAssociation,
		extraImagesPreview, labelledImages, colonyIconList, output, unitlessCenters,
		initialPopulationMembers, previewClump, defaultCentersCheck, originalBoundaries,
		unitlessBoundaries
	},
	
	(* set the interactive options to the global for update preview *)
	$AnalyzeColoniesResolvedOptions = Normal[KeyTake[resolvedOptions, {ManualPickTargets, Populations, IncludedColonies}]];
	
	(* lookup output in resolved options *)
	output = Lookup[resolvedOptions, Output];
	
	(* if the output does not contain preview, return nothing *)
	If[!(MemberQ[output, Preview] || MatchQ[output, Preview]),
		Return[<||>]
	];
	
	(* Find the extra images and their labels *)
	extraImageLabels = Append[Values[wavelengthFluorescenceColors], Absorbance];
	extraImages = Append[Values[fluorescenceWavelengthImages], absorbanceImage];
	
	(* create an association and only keep the actual images *)
	labeledImageAssociation = AssociationThread[ToString/@extraImageLabels, extraImages];
	labeledImageAssociation = Select[labeledImageAssociation, ImageQ];
	extraImagesPreview = Normal[labeledImageAssociation];
	
	(* add all and no colonies to the labels lists *)
	allSelectionLabels = colonySelectionLabels;
	
	(* from the colonies packet pull out the centers (1st column) and boundaries (2nd column) *)
	{unitlessCenters, unitlessBoundaries} = extractCentersBoundaries[colonyProperties, {1, 2}];
	
	(* from the population properties pull out the centers (1st column) *)
	(* the population properties have one extra level of listedness so use First*)
	populationCenters = Map[
		First[extractCentersBoundaries[#, {1}]]&,
		populationProperties
	];
	
	(* find the positions of the populations in the center data *)
	populationPositions = Flatten[Position[unitlessCenters, Alternatives @@ #]]& /@ populationCenters;
	
	(* create clicking icons *)
	colonyIconList = colonyIcon/@Range[Length[allSelectionLabels]];
	
	(* set up rules for values beneath labels for pop-up menu *)
	(* pairs of labels and associated colored circles *)
	allSelectionLabels = MapIndexed[
		First[#2] ->
			EmeraldMenuItem[{
				(* colored circle *)
				colonyIconList[[First[#2]]]
				,
				(* text *)
				#1
			}]&,
		allSelectionLabels
	];

	lengthPopulations = Length[allSelectionLabels];

	(* image and popup menu input *)
	labelledImages = Join[
		{"Brightfield"-> imageFile},
		extraImagesPreview
	];
	
	defaultCentersCheck = defaultCenters;
	
	(* create a list the length of colonies and each item is a list of the populations it belongs to *)
	(*
		list of length # of colonies. Each item is a list of the populations it belongs to
		e.g., {{1,2},{1},{1,3},{}},

		and store it in the previewClump.  It will affect the Include/Exclude suboptions of ColonySelection
	*)
	initialPopulationMembers = initializePopulationMemberList[Length[allSelectionLabels], Length[unitlessCenters], populationPositions];
	
	originalBoundaries = QuantityMagnitude[Lookup[resolvedOptions, IncludedColonies]];
	
	(* consider two variabales, state and options *)
	previewClump = Clump[
		{
			(*Command Center Options*)
			"Populations" :> populationMembershipToSelect[
				$This["Populations"],
				initialPopulationMembers,
				$This["PopulationMembershipList"],
				$This["ManualPopulationMembershipList"],
				$This["CenterList"],
				$This["ManualCenterList"],
				$This,
				includeDefault,
				excludeDefault
			],
			"IncludedColonies" :> Quantity[Union[$This["ManualColonyBoundariesList"], originalBoundaries/.{{}}->{}],Millimeter],
			"ManualPickTargets" :> centersToManualPickTargets[
				{defaultCenters, $This["CenterList"]},
				{$This["ManualDefaultCenterList"], $This["ManualCenterList"]}
			],

			(*Preview state variables*)
			"PopulationMembershipList" :> setPopulationMembership[
				$This["Populations"],
				$This,
				"CenterList",
				initialPopulationMembers,
				unitlessBoundaries
			],
			
			"ManualPopulationMembershipList" :> setManualPopulationMembership[
				$This["Populations"],
				$This,
				"ManualCenterList"
			],
			
			"CenterList" :> replaceDefaultCenters[
				defaultCenters,
				unitlessBoundaries,
				QuantityMagnitude[$This["ManualPickTargets"]]
			],
			
			"ManualColonyBoundariesList" :> Complement[QuantityMagnitude[$This["IncludedColonies"]], originalBoundaries],
			
			"ManualDefaultCenterList" :> Map[
				RegionCentroid[Polygon[#]]&,
				$This["ManualColonyBoundariesList"]
			],
			
			"ManualCenterList" :> replaceDefaultCenters[
				$This["ManualDefaultCenterList"],
				$This["ManualColonyBoundariesList"],
				QuantityMagnitude[$This["ManualPickTargets"]]
			],
			
			"UpdatePreviewBoolean" :> False
			
		}
	];
	
	(* define the preview clump to the function name *)
	DefinePreviewClump[AnalyzeColonies, previewClump];
	
	(* batch clump set *)
	ClumpSet[previewClump,
		{
			"UpdatePreviewBoolean" -> True,
			"Populations" -> Lookup[resolvedOptions, Populations],
			"ManualPickTargets" -> Lookup[resolvedOptions, ManualPickTargets]/.ListableP[None]->{},
			"IncludedColonies" -> Lookup[resolvedOptions, IncludedColonies]
		}
	];
	
	(* create a dynamic module to return *)
	myDynamicModule = createColoniesPreview[
		allSelectionLabels,
		colonySelectionLabels,
		colonyCount,
		Dynamic[unitlessBoundaries],
		labelledImages,
		graphicsScale,
		colonyIconList,
		Dynamic[previewClump]
	];

	(*Return associations *)
	<|
		Preview -> myDynamicModule
	|>

];

(* CLUMP FUNCTIONS *)

(*
	all manual population memberships are included,
	include is diff of populationMembership and initialPopulationMembers,
	exclude is diff of initialPopulationMembers and populationMembership
*)

(* this overload handles when a new colony is drawn or removed *)
(* if it is added, we want to leave select as is because ClumpSet in manual polygon drawing updated it *)
(* if it is deleted, we want to remove the included options that pertained to the deleted polygon *)
populationMembershipToSelect[
	select_,
	initialPopulationMembers_,
	populationMembershipList_,
	manualPopulationMembershipList_,
	centers_,
	manualCenterList_,
	this_,
	includeDefault_,
	excludeDefault_
] /; Length[manualPopulationMembershipList] =!= Length[manualCenterList] := Module[
	{allCenters},
	
	(* combine ManualCenterList and Centers *)
	allCenters = Join[manualCenterList, centers];
	
	(* remove the include option from select if include has been deleted *)
	Map[removeDeletedPolygon[#, allCenters]&, select]

];

(* function to check remove includes that are in any of the deleted polygons *)
removeDeletedPolygon[select_, allCenters_]:=Module[
	{myAssoc, selectHead},
	
	selectHead = Head[select];
	
	(* pull out primitive association *)
	myAssoc = First[select];
	
	(* rewrite the include option to remove includes in the removed polygons *)
	myAssoc[Include] = Quantity[Cases[
		QuantityMagnitude[myAssoc[Include]],
		(* check if the include point is in any manual colony to be removed *)
		Alternatives@@allCenters
	], "Millimeters"];
	
	myAssoc[Include] = myAssoc[Include]/.{}->None;
	
	(* replace colony selection head to restore the primitive *)
	selectHead[
		myAssoc
	]
];

populationMembershipToSelect[
	select_,
	initialPopulationMembers_,
	populationMembershipList_,
	manualPopulationMembershipList_,
	centers_,
	manualCenterList_,
	this_,
	includeDefault_,
	excludeDefault_
] := Module[
	{manualCenterInclude, algoInclude, algoExclude, algoCenterInclude, algoCenterExclude, overallCenterInclude},
	
	(* helper to pick the centers of colonies for include/exclude based on the difference between actual and default values *)
	pickCenter[myCenters_, diffedColonies_, selectIndex_] := PickList[myCenters, diffedColonies, _?(MemberQ[#,selectIndex]&)];
	
	manualCenterInclude = Array[pickCenter[manualCenterList, manualPopulationMembershipList, #]&, Length[select]];
	
	(* include algo colonies *)
	algoInclude = MapThread[Complement[#1, #2]&, {populationMembershipList, initialPopulationMembers}];
	
	algoCenterInclude = Array[pickCenter[centers, algoInclude, #]&, Length[select]];
	
	(* exclude algo colonies *)
	algoExclude = MapThread[Complement[#1, #2]&, {initialPopulationMembers, populationMembershipList}];
	algoCenterExclude = Array[pickCenter[centers, algoExclude, #]&, Length[select]];
	
	algoCenterExclude = MapThread[Join, {algoCenterExclude, excludeDefault}];
	
	(* combine manual includes with algo includes *)
	overallCenterInclude = MapThread[Join, {algoCenterInclude, manualCenterInclude, includeDefault}];
	
	(* add units *)
	algoCenterExclude = algoCenterExclude*Millimeter;
	overallCenterInclude = overallCenterInclude*Millimeter;
	
	(* TODO - check than include/exclude do not come from the same colony (could be different points), if so delete them both *)
	
	(* append include and exclude to the keys in select *)
	selectIncludeExclude[primitive_, include_, exclude_, updatePreviewBoolean_]:=Module[
		{assoc, selectHead},
		
		(* pull out association *)
		assoc = First[primitive];
		selectHead = Head[primitive];
		
		{assoc[Include], assoc[Exclude]} = If[updatePreviewBoolean,
			
			(* updated from outside, we want to keep include/exclude *)
			{assoc[Include], assoc[Exclude]},
			
			(* clicked on image, we do not want to keep include/exclude *)
			{include, exclude}
		];
		
		(* return to None if an empty list *)
		assoc[Include] = assoc[Include]/.{}->None;
		assoc[Exclude] = assoc[Exclude]/.{}->None;
		
		selectHead[assoc]
	
	];
	
	(* return the updated select option *)
	MapThread[(selectIncludeExclude[#1, #2, #3, this["UpdatePreviewBoolean"]])&,{select, overallCenterInclude, algoCenterExclude}]

];

(* join together diffs of actual and default values and default value should be {{}} *)
centersToManualPickTargets[{defaultCenters_, centers_}, {manualDefaultCenter_, manualCenters_}] := Join[
	Complement[centers, defaultCenters]*Millimeter,
	Complement[manualCenters, manualDefaultCenter]*Millimeter
]/.{}->{{}};

(* add units to new boundaries *)
toManualColonyBoundaries[unitlessManualColonyBoundaries_] := Quantity[unitlessManualColonyBoundaries,Millimeter];

(* if a manual pick target is inside a unitless boundary, we need to replace the defaultCenters *)
replaceDefaultCenters[
	defaultCenters_,
	unitlessBoundaries_,
	manualPickTargets_
]:= MapThread[
	SelectFirst[manualPickTargets, Function[{pickTarget}, InPolygonQ[#2, pickTarget]], #1]&,
	{defaultCenters, unitlessBoundaries}
];

(* if the manual pick targets do not exist, return the centers *)
replaceDefaultCenters[defaultCenters_, _, {{}}]:= defaultCenters;

setManualPopulationMembership[select_, this_, centerString_]:=setPopulationMembership[
	select,
	this,
	centerString,
	ConstantArray[{}, Length[this[centerString]]],
	this["ManualColonyBoundariesList"]
];

setPopulationMembership[
	select_,
	this_,
	centerString_,
	initialPopulationMembers_,
	polygon_
] := Module[
	{excludedColonies, includedColonies, centerList, includeList, excludeList, excludedIndices, includedIndices},
	
	centerList = this[centerString];
	
	(* pull out include and exclude from select to make lists of coordinates *)
	{excludedColonies, includedColonies} = Transpose[Lookup[First[#], {Exclude, Include}] & /@select];
	
	(* replace None with {} and apply QuantityMagnitude *)
	excludedColonies = QuantityMagnitude[excludedColonies/.None->{}];
	includedColonies = QuantityMagnitude[includedColonies/.None->{}];
	
	inBounds[boundaries_, points_]:= Module[
		{selection},
		selection = SelectFirst[boundaries, Function[{boundary},inPolygonQ[boundary, #]],{}]&/@points;
		
		Flatten[Join@@Position[boundaries, #]&/@selection]
	];
	
	colonyIndices[boundaries_, colonies_]:= If[MatchQ[boundaries, {}],
		{},
		Map[
			inBounds[boundaries, #]&,
			colonies
		]
	];
	
	(* find where the included and excluded colonies are on the center list and replace the coordinates with the position *)
	excludedIndices = colonyIndices[polygon, excludedColonies];
	includedIndices = colonyIndices[polygon, includedColonies];
	
	(* find the include options that are inside the boundary of a colony *)
	
	(*
		create a list of populations to include in the same format at as the initialPopulationMembers, {{},{1},{},{2,3}...},
		convert index in includedIndices to number and the index becomes the position
	*)
	createIndexedList[indices_, length_]:=Module[
		{indexList},
		indexList = ConstantArray[{}, length];
		MapIndexed[
			If[indexList[[#1]] =!={},
				indexList[[#1]] = Join[indexList[[#1]], ConstantArray[#2, Length[#1]], 2],
				{}
			]&,
			indices
		];
		indexList
	];
	
	includeList = createIndexedList[includedIndices, Length[initialPopulationMembers]];
	excludeList = createIndexedList[excludedIndices, Length[initialPopulationMembers]];
	
	MapThread[
		Complement[Join[#1, #2], #3]&,
		{initialPopulationMembers, includeList, excludeList}
	]
	
];


createColoniesPreview[
	allSelectionLabels_,
	colonySelectionLabels_,
	colonyCount_,
	Dynamic[unitlessBoundaries_],
	labelledImages_,
	graphicsScale_,
	colonyIconList_,
	Dynamic[previewClump_]
] := DynamicModule[
	{
		clickableColonyPolygons,
		clickableManualColonyPolygons,

		selectedPopulation,
		manualPolygonSelection,
		imageName,
		drawingPolygonLassoLayer,
		drawingPolygonEllipseLayer
	},
	
	(* set the default values *)
	selectedPopulation = {1};
	manualPolygonSelection = {};
	imageName = "Brightfield";

	
	(* helper to draw algorithmically selected colonies *)
	clickableColonyPolygons = ClumpDynamic[
		Array[
		colonyPolygon[
			Part[unitlessBoundaries,#],
			Dynamic[Part[previewClump["CenterList"],#]],
			Dynamic[Part[previewClump["PopulationMembershipList"],#]],(*{1} or {}, or {1,2}*)
			Dynamic[selectedPopulation],
			colonyIconList,
			previewClump
		]&,
		Length[unitlessBoundaries]
	],TrackedSymbols:>{previewClump["PopulationMembershipList"],selectedPopulation,previewClump["CenterList"]}];
	
	(* helper to create custom colony polygons *)
	clickableManualColonyPolygons = ClumpDynamic[
		Array[
			colonyPolygon[
				Part[previewClump["ManualColonyBoundariesList"],#],
				Dynamic[Part[previewClump["ManualCenterList"],#]],
				Dynamic[Part[previewClump["ManualPopulationMembershipList"],#]],(*{1} or {}, or {1,2}*)
				Dynamic[selectedPopulation],
				colonyIconList,
				previewClump
			]&,
			Length[previewClump["ManualColonyBoundariesList"]]
		],
		TrackedSymbols:>{previewClump["ManualPopulationMembershipList"],selectedPopulation,previewClump["ManualColonyBoundariesList"], previewClump["ManualCenterList"]}
	];
	
	(* helper that draws manual colonies and updates the values so they get updates in clickableManualColonyPolygons *)
	drawingPolygonEllipseLayer = manualPolygonEllipse[
		Dynamic[manualPolygonSelection],
		Dynamic[selectedPopulation],
		Dynamic[previewClump["ManualColonyBoundariesList"]],
		Dynamic[previewClump["ManualCenterList"]],
		Dynamic[previewClump["ManualPopulationMembershipList"]],
		Dynamic[previewClump["ManualDefaultCenterList"]],
		previewClump
	];

	drawingPolygonLassoLayer = manualPolygonLasso[
		Dynamic[manualPolygonSelection],
		Dynamic[selectedPopulation],
		Dynamic[previewClump["ManualColonyBoundariesList"]],
		Dynamic[previewClump["ManualCenterList"]],
		Dynamic[previewClump["ManualPopulationMembershipList"]],
		Dynamic[previewClump["ManualDefaultCenterList"]],
		previewClump
	];
	
	(* create the dynamic window *)
	Grid[
		{
			{
				(* (1,1) element *)
				(* combine graphics over image with show *)
				InteractiveImage[
					(* colony image *)
					(* join together base image (bright field, with extra image for toggling *)
					ECLImageAlbum[
						Dynamic[imageName],
						labelledImages
					],
					(* our boundary graphics *)
					Graphics[{
						clickableColonyPolygons,
						clickableManualColonyPolygons,
						drawingPolygonEllipseLayer,
						drawingPolygonLassoLayer
					}],
					ContentSize -> 750,
					ImageScale -> graphicsScale,
					AutoDownsampling -> True
				],
				
				(*This is the legend on the right side of the image*)
				Style[Column[
					{
						Column[
							{
								Style["Image Type", FontSize -> 16],
								PopupMenu[
									Dynamic[imageName],
									Keys[labelledImages]
								],
								Style["Populations", FontSize -> 16],
								EmeraldSelectionBar[
									Dynamic[selectedPopulation],
									allSelectionLabels,
									FieldSize -> {10}
								],
								Style["Legend", FontSize -> 16],
								Grid[{
									{
										Graphics[
											{
												FaceForm[],
												EdgeForm[{polygonColor[{1, 2}], Thick}],
												Disk[{0, 0}, 0.5]
											},
											ImageSize -> 15
										],
										Style["Member of multiple populations", FontSize -> 14]
									},
									{
										Graphics[
											{
												FaceForm[],
												EdgeForm[{polygonColor[{}], Thick}],
												Disk[{0, 0}, 0.5]
											},
											ImageSize -> 15
										],
										Style["Outside selected population", FontSize -> 14]
									},
									{
										Graphics[
											{
												FaceForm[{Black}],
												EdgeForm[{Black}],
												Line[{{-1, -1}, {1, 1}}],
												Line[{{-1, 1}, {1, -1}}]
											},
											ImageSize -> 15
										],
										Style["Pick Target", FontSize -> 14]
									}
								}, Alignment->Left],
								Style["Add Colonies", FontSize -> 16],
								CheckboxBar[
									Dynamic[manualPolygonSelection, If[Length[#] > 1, manualPolygonSelection = #[[-1 ;;]], manualPolygonSelection = #] &],
									{1->"Ellipse", 2->"Lasso"},
									Appearance-> "Vertical"
								],
								Style["Counts", FontSize -> 16],
								dynamicPreviewColonyCountTable[
									{
										colonySelectionLabels,
										Dynamic[previewClump["PopulationMembershipList"]],
										Dynamic[previewClump["ManualPopulationMembershipList"]]
									},
									ClumpDynamic[
										colonyCount + Length[previewClump["ManualCenterList"]],
										TrackedSymbols:>{previewClump["ManualCenterList"]}
									]
								]
							},


							Alignment -> Left,
							Dividers -> {False, {False, False, True, False, True, False, True, False, True, False}}
						]
					},
					Alignment -> Left,
					Frame -> All
				],
					FontFamily -> "Verdana",
					ShowStringCharacters->False
				]
				
			}
			
		}
	]
];

dynamicPreviewColonyCountTable[
	{selectionNames_, Dynamic[populationMembership_], Dynamic[manualPopulationMembership_]},
	totalCount_
] := ClumpDynamic[Grid[
		MapThread[
			{Pane[Row[{Style[#1, FontSlant -> Italic, FontColor -> RGBColor[0, .5, 0.75]]}]], #2} &,
			{selectionNames, Count[Flatten@Join[populationMembership, manualPopulationMembership], #] & /@ Range[Length[selectionNames]]}
		],
		Alignment -> {Left,Left},
		Dividers -> None,
		ItemSize -> {{Full, Full}}
	], TrackedSymbols:>{populationMembership, manualPopulationMembership}
];

colonyPolygon[
	boundaryCoordinates_,
	Dynamic[Part[center_,idx_]],
	Dynamic[Part[populationMembership_,idx_]],(*{1} or {}, or {1,2}*)
	Dynamic[selectedPopulation_],
	colonySelectionLabels_,
	previewClump_
]:=DynamicModule[{displayCenter=center[[idx]], isMovingCenter=False},
	With[
		{intersectionList=Intersection[populationMembership[[idx]], selectedPopulation]},
		{color=polygonColor[intersectionList]},
		{pickTargetBox=If[intersectionList==={},
			{},
			pickTargetBox[color,
				boundaryCoordinates,
				Dynamic[Part[center,idx]],
				{Dynamic[displayCenter], Dynamic[isMovingCenter]},
				previewClump
			]]
		},

		DynamicBox[
			{
				FaceForm[{Opacity[0.0]}],
				EdgeForm[{color, Dashing[{}], AbsoluteThickness[0.75]}],
				If[
					Or[isMovingCenter,CurrentValue["MouseOver"]],
					EdgeForm[{AbsoluteThickness[3]}],
					{}
				],
				TagBox[
					PolygonBox[boundaryCoordinates],

					EventHandlerTag[{
						"MouseClicked":>
							(
								ClumpSet[previewClump, "UpdatePreviewBoolean" -> False];
								polygonMouseClickHandler[
									Dynamic[populationMembership[[idx]]],
									selectedPopulation,
									previewClump
								];
							)
						,
						Method -> "Preemptive",
						PassEventsDown -> False,
						PassEventsUp -> False
					}]
				],

				EdgeForm[],
				FaceForm[Opacity[0.0]],
				pickTargetBox
			}
		]
	]];

polygonColor[{}] := RGBColor[0.53,0.77,1.00];
polygonColor[{1}] := RGBColor[1.00, 0.78, 0.23];
polygonColor[{2}] := RGBColor[1.00, 0.35, 0.42];
polygonColor[{3}] := RGBColor[0.047, 0.74, 0.59];
polygonColor[{_,__}] := RGBColor[0.81, 0.47, 0.87];


pickTargetBox[
	color_,
	boundaryCoordinates_,
	Dynamic[Part[center_,idx_]],
	{Dynamic[displayCenter_], Dynamic[isMovingCenter_]},
	previewClump_
] :=
	TagBox[
		DynamicBox[
			{
				DiskBox[Dynamic[displayCenter], 0.25],
				color,
				FEPrivate`If[
					Or[isMovingCenter,FrontEnd`CurrentValue["MouseOver"]],
					AbsoluteThickness[3],
					AbsoluteThickness[0.75]
				],
				(*DiskBox[Dynamic[displayCenter], 0.25],*)
				LineBox[Dynamic[{{-0.25, -0.25}, {0.25, 0.25}}/FEPrivate`Sqrt[2] + {displayCenter,displayCenter}]],
				LineBox[Dynamic[{{-0.25, 0.25}, {0.25, -0.25}}/FEPrivate`Sqrt[2] + {displayCenter,displayCenter}]]

			}
		]
		,
		EventHandlerTag[
			{
				"MouseDown" :>
					(
						FEPrivate`Set[isMovingCenter, True];
						FEPrivate`Set[displayCenter, CurrentValue[{"MousePosition", "Graphics"}]]
					),

				"MouseDragged" :> FEPrivate`Set[displayCenter, CurrentValue[{"MousePosition", "Graphics"}]],

				"MouseUp" :> (
					If[
						InPolygonQ[boundaryCoordinates, displayCenter],
						center[[idx]] = displayCenter;
						(*Send new changes to CommandBuilder*)
						LogPreviewChanges[
							previewClump,
							{
								ManualPickTargets -> previewClump["ManualPickTargets"]/.ListableP[{}]->None
							}
						];
						,
						displayCenter = center[[idx]];
					];
					isMovingCenter=False
				),
				Method -> "Preemptive",
				PassEventsDown -> False,
				PassEventsUp -> False
			}
		]
	];

(* map over colony heads to add include and exclude options *)
(* diff returns ALL the info from the line that changed *)
selectDiff[oldSelect_, newSelect_]:= Module[
	{
		includeDiffBool, excludeDiffBool,
		includeList, excludeList, nonNullValue, unitOpAssociation,
		heads
	},
	
	heads = Head/@oldSelect;
	
	(* helper function for the diff *)
	mapDiff[select1_, select2_, key_]:= MapThread[ContainsExactly[#1[[1]][key], #2[[1]][key]] &, {select1, select2}];
	
	(* diff bool to check include change *)
	{includeDiffBool, excludeDiffBool} = mapDiff[oldSelect, newSelect, #]&/@{Include, Exclude};
	
	(* helper to find the new Include/Exclude that changed *)
	diffedValues[diffBool_, key_] := MapIndexed[
		If[#1 === True, key -> Null, key -> First[Lookup[newSelect[[#2,1]],key]]]&,
		diffBool
	];
	
	(* create the updated keys for the unit operation *)
	includeList = diffedValues[includeDiffBool, Include];
	excludeList = diffedValues[excludeDiffBool, Exclude];
	
	(* function that checks if values in rules are null *)
	nonNullValue = Function[value, Values[value] =!= Null];
	
	(* create the diffed association, and keep keep only the non-null values *)
	unitOpAssociation = Association@@Select[#, nonNullValue]&/@Transpose[{includeList, excludeList}];
	
	(* apply heads to outputs *)
	MapThread[
		#1[#2]&,
		{heads, unitOpAssociation}
	]

];


(*Flips populationMembership depending on selectedPopulation after user click*)
polygonMouseClickHandler[
	Dynamic[populationMembership_],
	selectedPopulation_,
	previewClump_
]:= Module[{oldSelect},
	
	oldSelect = previewClump["Populations"];
	
	populationMembership = Union[
		Complement[populationMembership, selectedPopulation],
		Complement[selectedPopulation, populationMembership]
	];
	
	LogPreviewChanges[
		previewClump,
		{
			ManualPickTargets -> previewClump["ManualPickTargets"]/.ListableP[{}]->None,
			Populations -> selectDiff[oldSelect, previewClump["Populations"]]
		}
	]
];

manualPolygonEllipse[
	Dynamic[manualPolygonSelection_],
	Dynamic[selectedPopulation_],
	Dynamic[manualBoundaryCoordinatesList_],
	Dynamic[manualCenterList_],
	Dynamic[manualPopulationMembershipList_],
	Dynamic[manualDefaultCenter_],
	previewClump_
] := DynamicModule[
	{
		drawingCenter = Scaled[{-1.1, -1.1}],
		anchorPoint = {0, 0},
		drawingRadii = {0, 0},
		regionMemberManualQ, newBoundary, oldSelect
	},
	{
		(* Directives to match colonies *)
		FaceForm[{Yellow, Opacity[0]}],
		EdgeForm[{Yellow, Opacity[1]}],
		Disk[Dynamic[drawingCenter], Dynamic[drawingRadii]],
		EventHandler[
			(* if checkbox is clicked, void all other clicking with a giant rectangle *)
			Dynamic[
				If[MatchQ[manualPolygonSelection, {1}],
					MouseAppearance[Style[Rectangle[Scaled[{0, 0}], Scaled[{1, 1}]], ShowContents -> False],"DrawCircle"],
					{}
				],
				TrackedSymbols:>{manualPolygonSelection}
			],
			{
				"MouseDown" :> (
					FEPrivate`Set[drawingCenter, FrontEnd`MousePosition["Graphics"]];
					FEPrivate`Set[anchorPoint, FrontEnd`MousePosition["Graphics"]]
				),
				
				"MouseDragged" :> (
					FEPrivate`Set[drawingCenter,
						{
							(FrontEnd`MousePosition["Graphics"][[1]] + anchorPoint[[1]]) / 2,
							(FrontEnd`MousePosition["Graphics"][[2]] + anchorPoint[[2]]) / 2
						}
					];
					FEPrivate`Set[drawingRadii,
						{
							FEPrivate`Abs[FrontEnd`MousePosition["Graphics"][[1]] - drawingCenter[[1]]],
							FEPrivate`Abs[FrontEnd`MousePosition["Graphics"][[2]] - drawingCenter[[2]]]
						}
					]
				),
				
				"MouseUp" :> (
					(* minimum colony size *)
					If[And[drawingRadii[[1]]>0.5, drawingRadii[[2]]>0.5],
						(* append to list of all drawn colonies *)
						newBoundary = MeshCoordinates[BoundaryDiscretizeRegion[Disk@@{drawingCenter, drawingRadii}]];
						
						oldSelect = previewClump["Populations"];
						
						(* update the manually drawn colonies *)
						ClumpSet[previewClump,
							{
								"UpdatePreviewBoolean" -> False,
								"ManualDefaultCenterList" -> Append[manualDefaultCenter, drawingCenter],
								"ManualCenterList" -> Append[manualCenterList, drawingCenter],
								"ManualColonyBoundariesList" -> Append[manualBoundaryCoordinatesList, QuantityMagnitude[newBoundary]],
								"ManualPopulationMembershipList" -> Append[manualPopulationMembershipList, selectedPopulation]
							}
						];
						LogPreviewChanges[
							previewClump,
							{
								IncludedColonies -> previewClump["IncludedColonies"],
								Populations -> selectDiff[oldSelect, previewClump["Populations"]]
							}
						];
						
					];
					
					(* reset drawing parameters *)
					Set[drawingCenter, Scaled[{-1.1, -1.1}]];
					Set[drawingRadii, {0, 0}];
				
				),
				
				(* right click in regions to delete them *)
				{"MouseClicked", 2} :> (
					
					(* find which disks were right clicked by checking mouse location *)
					regionMemberManualQ = Not[InPolygonQ[#, MousePosition["Graphics"]]]&/@manualBoundaryCoordinatesList;
					
					oldSelect = previewClump["Populations"];
					
					(* remove the manual properties that were removed by the right click *)
					ClumpSet[previewClump,
						{
							"UpdatePreviewBoolean" -> False,
							"ManualDefaultCenterList" -> PickList[manualDefaultCenter, regionMemberManualQ, True],
							"ManualCenterList" -> PickList[manualCenterList, regionMemberManualQ, True],
							"ManualColonyBoundariesList" -> PickList[manualBoundaryCoordinatesList, regionMemberManualQ, True],
							"ManualPopulationMembershipList" -> PickList[manualPopulationMembershipList, regionMemberManualQ, True]
						}
					];
					LogPreviewChanges[
						previewClump,
						{
							IncludedColonies -> previewClump["IncludedColonies"],
							Populations -> selectDiff[oldSelect, previewClump["Populations"]]
						}
					]
				
				)
			}
		]
	}
];

manualPolygonLasso[
	Dynamic[manualPolygonSelection_],
	Dynamic[selectedPopulation_],
	Dynamic[manualBoundaryCoordinatesList_],
	Dynamic[manualCenterList_],
	Dynamic[manualPopulationMembershipList_],
	Dynamic[manualDefaultCenter_],
	previewClump_
] := DynamicModule[
	{
		drawingPoints = {},
		allPoints = {},
		regionMemberManualQ,
		oldSelect
	},
	{
		(* Directives to match colonies *)
		FaceForm[{Yellow, Opacity[0]}],
		EdgeForm[{Yellow, Opacity[1]}],
		Yellow,
		Line[Dynamic[drawingPoints]],
		EventHandler[
			(* if checkbox is clicked, void all other clicking with a giant rectangle *)
			Dynamic[
				If[MatchQ[manualPolygonSelection, {2}],
					MouseAppearance[Style[Rectangle[Scaled[{0, 0}], Scaled[{1, 1}]], ShowContents -> False],"DrawPolygon"],
					{}
				],
				TrackedSymbols:>{manualPolygonSelection}
			],
			{
				"MouseDown" :> (
					FEPrivate`Set[drawingPoints, {FrontEnd`MousePosition["Graphics"]}]
				),
				"MouseDragged" :> (
					FEPrivate`Set[drawingPoints, FEPrivate`Join[drawingPoints, {FrontEnd`MousePosition["Graphics"]}]]
				),
				
				"MouseUp" :> (
					(* minimum colony size, about a radius of 0.25 *)
					If[Area[Polygon[drawingPoints]]>0.6,
						
						allPoints = Join[allPoints, {drawingPoints}];
						
						oldSelect = previewClump["Populations"];
						
						(* update the manually drawn colonies *)
						ClumpSet[previewClump,
							{
								"UpdatePreviewBoolean" -> False,
								"ManualDefaultCenterList" -> Append[manualDefaultCenter, RegionCentroid[Polygon[Last[allPoints]]]],
								"ManualCenterList" -> Append[manualCenterList, RegionCentroid[Polygon[Last[allPoints]]]],
								"ManualColonyBoundariesList" -> Append[manualBoundaryCoordinatesList, Last[allPoints]],
								"ManualPopulationMembershipList" -> Append[manualPopulationMembershipList, selectedPopulation]
							}
						];
						
						LogPreviewChanges[
							previewClump,
							{
								IncludedColonies -> previewClump["IncludedColonies"],
								Populations -> selectDiff[oldSelect, previewClump["Populations"]]
							}
						]
					];

					(* reset drawing parameters *)
					Set[drawingPoints, {}]
				
				),
				
				(* right click in regions to delete them *)
				{"MouseClicked", 2} :> (
					
					(* find which disks were right clicked by checking mouse location *)
					regionMemberManualQ = Not[InPolygonQ[#, MousePosition["Graphics"]]]&/@manualBoundaryCoordinatesList;
					
					oldSelect = previewClump["Populations"];
					
					(* remove the manual properties that were removed by the right click *)
					ClumpSet[previewClump,
						{
							"UpdatePreviewBoolean" -> False,
							"ManualDefaultCenterList" -> PickList[manualDefaultCenter, regionMemberManualQ, True],
							"ManualCenterList" -> PickList[manualCenterList, regionMemberManualQ, True],
							"ManualColonyBoundariesList" -> PickList[manualBoundaryCoordinatesList, regionMemberManualQ, True],
							"ManualPopulationMembershipList" -> PickList[manualPopulationMembershipList, regionMemberManualQ, True]
						}
					];
					
					LogPreviewChanges[
						previewClump,
						{
							IncludedColonies -> previewClump["IncludedColonies"],
							Populations -> selectDiff[oldSelect, previewClump["Populations"]]
						}
					];
				
				)
			}
		]
	}
];


(* function to check if includes are in any of the deleted polygons *)
removeIncludeDeletedPolygon[select_, removedPolygons_]:=Module[
	{myAssoc, selectHead},
	
	(* pull out primitive association *)
	myAssoc = First[select];
	selectHead = Head[select];
	
	(* rewrite the include option to remove includes in the removed polygon *)
	myAssoc[Include] = Select[
		myAssoc[Include],
		(* check if the include point is in any manual colony to be removed *)
		inAnyPolygon[#, removedPolygons]&
	];
	
	myAssoc[Include] = myAssoc[Include]/.{}->None;
	
	(* replace colony selection head to restore the primitive *)
	selectHead[
		myAssoc
	]
];

inAnyPolygon[include_, removedPolygons_]:=Module[
	{inIndividualPolygons},
	
	(* check if present in any polygon *)
	inIndividualPolygons = Map[
		RegionMember[
			Polygon[QuantityMagnitude[#]],
			QuantityMagnitude[include]
		]&,
		removedPolygons
	];
	
	(* if in any polygons, then the result is true, but we don't want to select it, so we flip it *)
	Not@MemberQ[inIndividualPolygons, True]
	
];

(*Returns the list of {True and False} indicating... *)
initializeStateVariableList[numberOfPopulations_, numberOfColonies_, allPositions_] :=
	Module[{stateVariableList},
		(* Start by defining at array of False *)
		stateVariableList = ConstantArray[False, {numberOfPopulations, numberOfColonies}];
		
		(* flip the values contained in the matrix to true *)
		MapThread[
			ReplacePart[#1, (List /@ #2) -> True] &,
			{stateVariableList, allPositions}
		]
	];

(* create a list the length of colonies and each item is a list of the populations it belongs to *)
initializePopulationMemberList[numberOfPopulations_, numberOfColonies_, allPositions_]:=Module[
	{populationBools},
	
	(* booleans indicating if a colony (each item in list) is a member of the population (each item within each item population) *)
	populationBools = isPopulationMember[allPositions, #]&/@Range[numberOfColonies];
	
	(* convert the true values to indices *)
	PickList[Range[Length[allPositions]], #] & /@ populationBools
];


(* population member helper that returns booleans on if a colony is a member of the population *)
isPopulationMember[allPositions_, index_] := MemberQ[#, index] & /@ allPositions;

(* programmatically create the colony circles*)
colonyIcon[index_] := Graphics[
	{
		FaceForm[],
		EdgeForm[{polygonColor[{index}], Thick}],
		Disk[{0, 0}, 0.5]
	},
	ImageSize->15
];

(* function to add row indices to turn indices into coordinates *)
addIndex[index_, values_] := Map[{First[index], #}&, values];

(* extract and transpose the property data from selected columns *)
extractCentersBoundaries[properties_, columns_List] := Transpose[QuantityMagnitude[
	Extract[
		properties,
		{;;, columns}
	]
]];

(* if the properties are Null return a list of empty list the length of columns *)
extractCentersBoundaries[Null, columns_List] := ConstantArray[{}, Length[columns]];