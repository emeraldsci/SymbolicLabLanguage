(* Define Tests *)
DefineTestsWithCompanions[AnalyzeColonies,
	{
		(*** Basic Usage ***)
		Example[{Basic, "By default, AnalyzeColonies selects the fluorescent colonies:"},
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID],
				Output->Preview
			],
			_Image,
			Stubs:>{
				AnalyzeColonies[Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID], Output->Preview] = Rasterize[
					AnalyzeColoniesPreview[Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID]]
				]
			}
		],
		
		Example[{Basic, "Set Select option to {All} to select all colonies that meet the overall constraints on diameter, separation, circularity, and regularity:"},
			packet = AnalyzeColonies[
				Object[Data, Appearance, Colonies, "Brightfield Test Object"<>$SessionUUID],
				Populations->{All},
				Upload->False
			];
			Lookup[packet, Replace[PopulationTotalColonyCount]],
			{41},
			Variables:>{packet}
		],
		
		
		
		Example[{Basic, "Set AnalysisType option to Count to estimate the total number of colonies on the plate, including clusters of colonies. Set Populations to All to count the colonies filtered by the Min and Max constraints of diameter, separation, circularity, and regularity:"},
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID],
				Populations->{All},
				AnalysisType -> Count,
				Output->Preview
			],
			_Grid
		],
		
		(* Additional *)
		Example[{Additional, "For Diameter, Isolation, Regularity, and Circularity the Populations option will by default select the top half of colonies when ordered by that feature and then keep the 10 that score the highest:"},
			packet = AnalyzeColonies[
				Object[Data, Appearance, Colonies, "Brightfield Test Object"<>$SessionUUID],
				Populations->{
					Diameter[]
				},
				Upload->False
			];
			Lookup[packet, Replace[PopulationTotalColonyCount]],
			{10},
			Variables:>{packet}
		],
		
		Example[{Basic, "Set Populations to Regularity to select the colonies with the highest regularity ratio:"},
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID],
				Populations->Regularity,
				Output->Preview
			],
			_Image,
			Stubs:>{
				AnalyzeColonies[Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID], Populations->Regularity, Output->Preview] = Rasterize[
					AnalyzeColoniesPreview[Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID], Populations->Regularity]
				]
			}
		],
		
		(** Options **)
		(* AnalysisType *)
		Example[{Options, AnalysisType, "Set AnalysisType option to Count in order to estimate the total number of colonies on the plate. By default the Populations option will be count all colonies filtered by diameter, isolation, regularity, and circularity:"},
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID],
				AnalysisType -> Count,
				Output->Preview
			],
			_Grid
		],
		
		(* Populations *)
		Example[{Options, Populations, "Use threshold with Diameter, Regularity, Circularity, or Isolation to pick colonies with specific properties:"},
			AnalyzeColonies[
				Object[Data,Appearance,Colonies,"qpix Violet Fluorescence"<>$SessionUUID],
				Populations->{Isolation[
					ThresholdDistance->1 Millimeter
				]},
				Output->Preview
			],
			_Image,
			Stubs:>{
				AnalyzeColonies[
					Object[Data,Appearance,Colonies,"qpix Violet Fluorescence"<>$SessionUUID], Populations->{Isolation[ThresholdDistance->1 Millimeter]}, Output->Preview
				] = Rasterize[
					AnalyzeColoniesPreview[Object[Data,Appearance,Colonies,"qpix Violet Fluorescence"<>$SessionUUID], Populations->{Isolation[ThresholdDistance->1 Millimeter]}]
				]
			}
		],
		
		Example[{Options, Populations, "Set Select in the primitive to BelowThreshold to select colonies lower than the specified cutoff:"},
			AnalyzeColonies[
				Object[Data,Appearance,Colonies,"qpix Violet Fluorescence"<>$SessionUUID],
				Populations->{Isolation[
					ThresholdDistance->1 Millimeter,
					Select -> BelowThreshold
				]},
				Output->Preview
			],
			_Image,
			Stubs:>{
				AnalyzeColonies[
					Object[Data,Appearance,Colonies,"qpix Violet Fluorescence"<>$SessionUUID], Populations->{Isolation[ThresholdDistance->1 Millimeter, Select -> BelowThreshold]}, Output->Preview
				] = Rasterize[
					AnalyzeColoniesPreview[Object[Data,Appearance,Colonies,"qpix Violet Fluorescence"<>$SessionUUID], Populations->{Isolation[ThresholdDistance->1 Millimeter, Select -> BelowThreshold]}]
				]
			}
		],
		
		Example[{Options, Populations, "A very large threshold value will select no colonies:"},
			AnalyzeColonies[
				Object[Data,Appearance,Colonies,"qpix Violet Fluorescence"<>$SessionUUID],
				Populations->{Isolation[
					ThresholdDistance->100 Millimeter
				]},
				Output->Preview
			],
			_Image,
			Stubs:>{
				AnalyzeColonies[
					Object[Data,Appearance,Colonies,"qpix Violet Fluorescence"<>$SessionUUID], Populations->{Isolation[ThresholdDistance->100 Millimeter]}, Output->Preview
				] = Rasterize[
					AnalyzeColoniesPreview[Object[Data,Appearance,Colonies,"qpix Violet Fluorescence"<>$SessionUUID], Populations->{Isolation[ThresholdDistance->100 Millimeter]}]
				]
			}
		],
		
		(* Number of Colonies *)
		Example[{Options, Populations, "Set the NumberOfColonies option to 20 in the Diameter unit operation to keep at most 20 of the largest colonies:"},
			packet = AnalyzeColonies[
				Object[Data,Appearance,Colonies,"qpix Violet Fluorescence"<>$SessionUUID],
				Populations->{Diameter[NumberOfColonies->20]},
				Upload -> False
			];
			Lookup[packet, Replace[PopulationTotalColonyCount]],
			{20},
			Variables:>{packet}
		],
		
		(* Number of divisions *)
		Example[{Options, Populations, "Specify the NumberOfDivisions to 10 to partition the colonies based on the feature into 10 groups. Then set Select to min and NumberOfColonies to All to keep the colonies from the smallest diameter partition:"},
			packet = AnalyzeColonies[
				Object[Data,Appearance,Colonies,"qpix Violet Fluorescence"<>$SessionUUID],
				Populations->{Diameter[
					NumberOfColonies->All,
					NumberOfDivisions -> 10,
					Select -> Min
				]},
				Upload -> False
			];
			Lookup[Lookup[packet, Replace[PopulationProperties]], "Diameter"],
			{{UnitsP[Millimeter] ..}},
			Variables:>{packet}
		],
		
		(* Label *)
		(* Number of Colonies *)
		Example[{Options, Populations, "Use PopulationName to name a population for ease of tracking:"},
			AnalyzeColonies[Object[Data, Appearance, Colonies, "qpix Violet Fluorescence" <> $SessionUUID],
				Populations -> {Circularity[PopulationName -> "Most Circular Colonies", NumberOfColonies -> 5]},
				Output -> Preview
			],
			_Image,
			Stubs:>{
				AnalyzeColonies[
					Object[Data,Appearance,Colonies,"qpix Violet Fluorescence"<>$SessionUUID], Populations -> {Circularity[PopulationName -> "Most Circular Colonies", NumberOfColonies -> 5]}, Output->Preview
				] = Rasterize[
					AnalyzeColoniesPreview[Object[Data,Appearance,Colonies,"qpix Violet Fluorescence"<>$SessionUUID], Populations -> {Circularity[PopulationName -> "Most Circular Colonies", NumberOfColonies -> 5]}]
				]
			}
		],
		
		(* Select -> Negative *)
		Example[{Options, Populations, "Set Select to Negative in the Fluorescence Unit Operation to pick non-fluorescing colonies:"},
			packet = AnalyzeColonies[
				Object[Data,Appearance,Colonies,"qpix Violet Fluorescence"<>$SessionUUID],
				Populations->{Fluorescence[
					Select -> Negative
				]},
				Upload -> False
			];
			Lookup[packet, Replace[PopulationVioletFluorescence]],
			{DistributionP[]},
			Variables:>{packet}
		],
		
		(* MultiFeatured *)
		Example[{Options, Populations, "Use the MultiFeatured primitive to intersect colonies from multiple selections. In this case overlap the Fluorescing colonies with the larger colonies:"},
			AnalyzeColonies[Object[Data, Appearance, Colonies, "qpix Violet Fluorescence" <> $SessionUUID],
				Populations -> {MultiFeatured[Features -> {Fluorescence, Diameter}]},
				Output -> Preview
			],
			_Image,
			Stubs:>{
				AnalyzeColonies[
					Object[Data,Appearance,Colonies,"qpix Violet Fluorescence"<>$SessionUUID], Populations -> {MultiFeatured[Features -> {Fluorescence, Diameter}]}, Output->Preview
				] = Rasterize[
					AnalyzeColoniesPreview[Object[Data,Appearance,Colonies,"qpix Violet Fluorescence"<>$SessionUUID], Populations -> {MultiFeatured[Features -> {Fluorescence, Diameter}]}]
				]
			}
		],
		
		(* Include options *)
		Example[{Options, Populations, "Include a colony not automatically included by the algorithm by specify a coordinate inside the boundary:"},
			AnalyzeColonies[Object[Data, Appearance, Colonies, "qpix Violet Fluorescence" <> $SessionUUID],
				Populations -> {Diameter[
					Include -> {{60.5 Millimeter, 63 Millimeter}}
				]},
				Output -> Preview
			],
			_Image,
			Stubs:>{
				AnalyzeColonies[Object[Data, Appearance, Colonies, "qpix Violet Fluorescence" <> $SessionUUID],
					Populations -> {Diameter[
						Include -> {{60.5 Millimeter, 63 Millimeter}}
					]},
					Output -> Preview
				] = Rasterize[
					AnalyzeColoniesPreview[Object[Data, Appearance, Colonies, "qpix Violet Fluorescence" <> $SessionUUID],
						Populations -> {Diameter[
							Include -> {{60.5 Millimeter, 63 Millimeter}}
						]}
					]
				]
			}
		],
		
		
		(* IncludedColonies *)
		Example[{Options, IncludedColonies, "IncludeColonies not automatically selected by the colony selection algorithm. The included colony is shown in the bottom right corner:"},
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID],
				Populations -> {Diameter[]},
				Output->Preview,
				IncludedColonies-> {{{Quantity[111.6189378805175`,"Millimeters"],Quantity[18.033638445942774`,"Millimeters"]},{Quantity[111.57670115106545`,"Millimeters"],Quantity[18.033638445942774`,"Millimeters"]},{Quantity[111.40037956621005`,"Millimeters"],Quantity[18.033638445942774`,"Millimeters"]},{Quantity[110.91365154109589`,"Millimeters"],Quantity[17.988049595105636`,"Millimeters"]},{Quantity[110.78694135273972`,"Millimeters"],Quantity[17.86335067958052`,"Millimeters"]},{Quantity[110.74470462328767`,"Millimeters"],Quantity[17.572386543355254`,"Millimeters"]},{Quantity[110.70246789383562`,"Millimeters"],Quantity[16.982413179580522`,"Millimeters"]},{Quantity[110.6179944349315`,"Millimeters"],Quantity[16.600271341680976`,"Millimeters"]},{Quantity[110.49128424657533`,"Millimeters"],Quantity[16.04381919175708`,"Millimeters"]},{Quantity[110.35652896689497`,"Millimeters"],Quantity[15.479321950508982`,"Millimeters"]},{Quantity[110.48525042808218`,"Millimeters"],Quantity[15.014047502259363`,"Millimeters"]},{Quantity[110.85934717465753`,"Millimeters"],Quantity[14.598384450508984`,"Millimeters"]},{Quantity[111.2830553177321`,"Millimeters"],Quantity[14.43211922980883`,"Millimeters"]},{Quantity[111.78989607115678`,"Millimeters"],Quantity[14.43211922980883`,"Millimeters"]},{Quantity[112.22164930555556`,"Millimeters"],Quantity[14.390552924633795`,"Millimeters"]},{Quantity[112.26321561073058`,"Millimeters"],Quantity[14.390552924633795`,"Millimeters"]},{Quantity[112.55417974695585`,"Millimeters"],Quantity[14.601736571894069`,"Millimeters"]},{Quantity[112.64133490296803`,"Millimeters"],Quantity[14.904768345105634`,"Millimeters"]},{Quantity[112.84916642884322`,"Millimeters"],Quantity[15.200425451270018`,"Millimeters"]},{Quantity[113.05699795471841`,"Millimeters"],Quantity[15.538319286886455`,"Millimeters"]},{Quantity[113.2688520262557`,"Millimeters"],Quantity[15.975435915501372`,"Millimeters"]},{Quantity[113.35600718226789`,"Millimeters"],Quantity[16.454789273568345`,"Millimeters"]},{Quantity[113.22929699391172`,"Millimeters"],Quantity[16.97637936108737`,"Millimeters"]},{Quantity[112.97587661719939`,"Millimeters"],Quantity[17.31427319670381`,"Millimeters"]},{Quantity[112.62658556887367`,"Millimeters"],Quantity[17.705800974481587`,"Millimeters"]},{Quantity[112.45763865106545`,"Millimeters"],Quantity[17.874747892289804`,"Millimeters"]},{Quantity[112.11974481544901`,"Millimeters"],Quantity[18.170404998454188`,"Millimeters"]},{Quantity[112.0352713565449`,"Millimeters"],Quantity[18.2548784573583`,"Millimeters"]},{Quantity[111.78185097983257`,"Millimeters"],Quantity[18.2548784573583`,"Millimeters"]},{Quantity[111.69737752092846`,"Millimeters"],Quantity[18.2548784573583`,"Millimeters"]},{Quantity[111.478819206621`,"Millimeters"],Quantity[18.2548784573583`,"Millimeters"]},{Quantity[111.21064949581431`,"Millimeters"],Quantity[18.20928960652116`,"Millimeters"]}}}
			],
			_Image,
			Stubs:>{
				AnalyzeColonies[
					Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID],
					Populations -> {Diameter[]},
					Output->Preview,
					IncludedColonies-> {{{Quantity[111.6189378805175`,"Millimeters"],Quantity[18.033638445942774`,"Millimeters"]},{Quantity[111.57670115106545`,"Millimeters"],Quantity[18.033638445942774`,"Millimeters"]},{Quantity[111.40037956621005`,"Millimeters"],Quantity[18.033638445942774`,"Millimeters"]},{Quantity[110.91365154109589`,"Millimeters"],Quantity[17.988049595105636`,"Millimeters"]},{Quantity[110.78694135273972`,"Millimeters"],Quantity[17.86335067958052`,"Millimeters"]},{Quantity[110.74470462328767`,"Millimeters"],Quantity[17.572386543355254`,"Millimeters"]},{Quantity[110.70246789383562`,"Millimeters"],Quantity[16.982413179580522`,"Millimeters"]},{Quantity[110.6179944349315`,"Millimeters"],Quantity[16.600271341680976`,"Millimeters"]},{Quantity[110.49128424657533`,"Millimeters"],Quantity[16.04381919175708`,"Millimeters"]},{Quantity[110.35652896689497`,"Millimeters"],Quantity[15.479321950508982`,"Millimeters"]},{Quantity[110.48525042808218`,"Millimeters"],Quantity[15.014047502259363`,"Millimeters"]},{Quantity[110.85934717465753`,"Millimeters"],Quantity[14.598384450508984`,"Millimeters"]},{Quantity[111.2830553177321`,"Millimeters"],Quantity[14.43211922980883`,"Millimeters"]},{Quantity[111.78989607115678`,"Millimeters"],Quantity[14.43211922980883`,"Millimeters"]},{Quantity[112.22164930555556`,"Millimeters"],Quantity[14.390552924633795`,"Millimeters"]},{Quantity[112.26321561073058`,"Millimeters"],Quantity[14.390552924633795`,"Millimeters"]},{Quantity[112.55417974695585`,"Millimeters"],Quantity[14.601736571894069`,"Millimeters"]},{Quantity[112.64133490296803`,"Millimeters"],Quantity[14.904768345105634`,"Millimeters"]},{Quantity[112.84916642884322`,"Millimeters"],Quantity[15.200425451270018`,"Millimeters"]},{Quantity[113.05699795471841`,"Millimeters"],Quantity[15.538319286886455`,"Millimeters"]},{Quantity[113.2688520262557`,"Millimeters"],Quantity[15.975435915501372`,"Millimeters"]},{Quantity[113.35600718226789`,"Millimeters"],Quantity[16.454789273568345`,"Millimeters"]},{Quantity[113.22929699391172`,"Millimeters"],Quantity[16.97637936108737`,"Millimeters"]},{Quantity[112.97587661719939`,"Millimeters"],Quantity[17.31427319670381`,"Millimeters"]},{Quantity[112.62658556887367`,"Millimeters"],Quantity[17.705800974481587`,"Millimeters"]},{Quantity[112.45763865106545`,"Millimeters"],Quantity[17.874747892289804`,"Millimeters"]},{Quantity[112.11974481544901`,"Millimeters"],Quantity[18.170404998454188`,"Millimeters"]},{Quantity[112.0352713565449`,"Millimeters"],Quantity[18.2548784573583`,"Millimeters"]},{Quantity[111.78185097983257`,"Millimeters"],Quantity[18.2548784573583`,"Millimeters"]},{Quantity[111.69737752092846`,"Millimeters"],Quantity[18.2548784573583`,"Millimeters"]},{Quantity[111.478819206621`,"Millimeters"],Quantity[18.2548784573583`,"Millimeters"]},{Quantity[111.21064949581431`,"Millimeters"],Quantity[18.20928960652116`,"Millimeters"]}}}
				] = Rasterize[
					AnalyzeColoniesPreview[
						Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID],
						Populations -> {Diameter[]},
						IncludedColonies-> {{{Quantity[111.6189378805175`,"Millimeters"],Quantity[18.033638445942774`,"Millimeters"]},{Quantity[111.57670115106545`,"Millimeters"],Quantity[18.033638445942774`,"Millimeters"]},{Quantity[111.40037956621005`,"Millimeters"],Quantity[18.033638445942774`,"Millimeters"]},{Quantity[110.91365154109589`,"Millimeters"],Quantity[17.988049595105636`,"Millimeters"]},{Quantity[110.78694135273972`,"Millimeters"],Quantity[17.86335067958052`,"Millimeters"]},{Quantity[110.74470462328767`,"Millimeters"],Quantity[17.572386543355254`,"Millimeters"]},{Quantity[110.70246789383562`,"Millimeters"],Quantity[16.982413179580522`,"Millimeters"]},{Quantity[110.6179944349315`,"Millimeters"],Quantity[16.600271341680976`,"Millimeters"]},{Quantity[110.49128424657533`,"Millimeters"],Quantity[16.04381919175708`,"Millimeters"]},{Quantity[110.35652896689497`,"Millimeters"],Quantity[15.479321950508982`,"Millimeters"]},{Quantity[110.48525042808218`,"Millimeters"],Quantity[15.014047502259363`,"Millimeters"]},{Quantity[110.85934717465753`,"Millimeters"],Quantity[14.598384450508984`,"Millimeters"]},{Quantity[111.2830553177321`,"Millimeters"],Quantity[14.43211922980883`,"Millimeters"]},{Quantity[111.78989607115678`,"Millimeters"],Quantity[14.43211922980883`,"Millimeters"]},{Quantity[112.22164930555556`,"Millimeters"],Quantity[14.390552924633795`,"Millimeters"]},{Quantity[112.26321561073058`,"Millimeters"],Quantity[14.390552924633795`,"Millimeters"]},{Quantity[112.55417974695585`,"Millimeters"],Quantity[14.601736571894069`,"Millimeters"]},{Quantity[112.64133490296803`,"Millimeters"],Quantity[14.904768345105634`,"Millimeters"]},{Quantity[112.84916642884322`,"Millimeters"],Quantity[15.200425451270018`,"Millimeters"]},{Quantity[113.05699795471841`,"Millimeters"],Quantity[15.538319286886455`,"Millimeters"]},{Quantity[113.2688520262557`,"Millimeters"],Quantity[15.975435915501372`,"Millimeters"]},{Quantity[113.35600718226789`,"Millimeters"],Quantity[16.454789273568345`,"Millimeters"]},{Quantity[113.22929699391172`,"Millimeters"],Quantity[16.97637936108737`,"Millimeters"]},{Quantity[112.97587661719939`,"Millimeters"],Quantity[17.31427319670381`,"Millimeters"]},{Quantity[112.62658556887367`,"Millimeters"],Quantity[17.705800974481587`,"Millimeters"]},{Quantity[112.45763865106545`,"Millimeters"],Quantity[17.874747892289804`,"Millimeters"]},{Quantity[112.11974481544901`,"Millimeters"],Quantity[18.170404998454188`,"Millimeters"]},{Quantity[112.0352713565449`,"Millimeters"],Quantity[18.2548784573583`,"Millimeters"]},{Quantity[111.78185097983257`,"Millimeters"],Quantity[18.2548784573583`,"Millimeters"]},{Quantity[111.69737752092846`,"Millimeters"],Quantity[18.2548784573583`,"Millimeters"]},{Quantity[111.478819206621`,"Millimeters"],Quantity[18.2548784573583`,"Millimeters"]},{Quantity[111.21064949581431`,"Millimeters"],Quantity[18.20928960652116`,"Millimeters"]}}}
					]
				]
			}
		],
		
		(* Manual Pick Targets *)
		Example[{Options, ManualPickTargets, "ManualPickTargets sets the location where the picking instrument will select cells in the colony. Pick target has moved at the bottom of the screen:"},
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID],
				Populations -> {Diameter[]},
				ManualPickTargets -> {{Quantity[37.5`, "Millimeters"], Quantity[12.0`, "Millimeters"]}},
				Output->Preview
			],
			_Image,
			Stubs:>{
				AnalyzeColonies[
					Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID],
					Populations -> {Diameter[]},
					ManualPickTargets -> {{Quantity[37.5`, "Millimeters"], Quantity[12.0`, "Millimeters"]}},
					Output->Preview
				] = Rasterize[
					AnalyzeColoniesPreview[
						Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID],
						Populations -> {Diameter[]},
						ManualPickTargets -> {{Quantity[37.5`, "Millimeters"], Quantity[12.0`, "Millimeters"]}}
					]
				]
			}
		],
		
		(* MinDiameter *)
		Example[{Options, MinDiameter, "Reduce MinDiameter to allow more small colonies through filtering:"},
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID],
				Populations -> {Diameter[Select -> Min, NumberOfColonies->All]},
				MinDiameter -> 0.5 Millimeter,
				Output->Preview
			],
			_Image,
			Stubs:>{
				AnalyzeColonies[
					Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID],
					Populations -> {Diameter[Select -> Min, NumberOfColonies->All]},
					MinDiameter -> 0.5 Millimeter,
					Output->Preview
				] = Rasterize[
					AnalyzeColoniesPreview[
						Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID],
						Populations -> {Diameter[Select -> Min, NumberOfColonies->All]},
						MinDiameter -> 0.5 Millimeter
					]
				]
			}
		],
		
		(* MaxDiameter *)
		Example[{Options, MaxDiameter, "Reduce MaxDiameter to filter out the larger colonies:"},
			packet = AnalyzeColonies[
				Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID],
				Populations -> {Diameter[]},
				MaxDiameter -> 2 Millimeter,
				Upload -> False
			];
			Lookup[packet, Replace[PopulationDiameters]],
			_List,
			Variables :> {packet}
		],
		
		(* MinSeparation *)
		Example[{Options, MinColonySeparation, "Increase MinColonySeparation to filter out the colonies that grow close together:"},
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID],
				Populations -> {Diameter[]},
				MinColonySeparation -> 1 Millimeter,
				Output -> Preview
			],
			_Image,
			Stubs:>{
				AnalyzeColonies[
					Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID],
					Populations -> {Diameter[]},
					MinColonySeparation -> 1 Millimeter,
					Output -> Preview
				] = Rasterize[
					AnalyzeColoniesPreview[
						Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID],
						Populations -> {Diameter[]},
						MinColonySeparation -> 1 Millimeter
					]
				]
			}
		],
		
		(* MinRegularityRatio *)
		Example[{Options, MinRegularityRatio, "Increase MinRegularityRatio to filter out the less regular colonies:"},
			packet = AnalyzeColonies[
				Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID],
				Populations -> {Diameter[NumberOfColonies->All]},
				MinRegularityRatio -> 0.9,
				Upload -> False
			];
			Lookup[packet, Replace[PopulationTotalColonyCount]],
			{208},
			Variables :> {packet}
		],
		
		(* MaxRegularityRatio *)
		Example[{Options, MaxRegularityRatio, "Decrease the MaxRegularityRatio to filter out the more regular colonies:"},
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID],
				Populations -> {Diameter[]},
				MaxRegularityRatio -> 0.9,
				Output -> Preview
			],
			_Image,
			Stubs:>{
				AnalyzeColonies[
					Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID],
					Populations -> {Diameter[]},
					MaxRegularityRatio -> 0.9,
					Output -> Preview
				] = Rasterize[
					AnalyzeColoniesPreview[
						Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID],
						Populations -> {Diameter[]},
						MaxRegularityRatio -> 0.9
					]
				]
			}
		],
		
		(* MinCircularityRatio *)
		Example[{Options, MinCircularityRatio, "Increase MinCircularityRatio to filter out the less circular colonies:"},
			packet = AnalyzeColonies[
				Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID],
				Populations -> {Diameter[NumberOfColonies->All]},
				MinCircularityRatio -> 0.9,
				Upload -> False
			];
			Lookup[packet, Replace[PopulationTotalColonyCount]],
			{290},
			Variables :> {packet}
		],
		
		(* MaxCircularityRatio *)
		Example[{Options, MaxCircularityRatio, "Decrease MaxCircularityRatio to filter out the more circular colonies:"},
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID],
				Populations -> {Diameter[]},
				MaxCircularityRatio -> 0.9,
				Output -> Preview
			],
			_Image,
			Stubs:>{
				AnalyzeColonies[
					Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID],
					Populations -> {Diameter[]},
					MaxCircularityRatio -> 0.9,
					Output -> Preview
				] = Rasterize[
					AnalyzeColoniesPreview[
						Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID],
						Populations -> {Diameter[]},
						MaxCircularityRatio -> 0.9
					]
				]
			}
		],
		
		(** Messages **)
		Example[{Messages, MinCannotExceedMax, "An error is thrown if the minimum option exceeds the maximum option for the filtering option Min/Max pairs:"},
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "Brightfield Test Object"<>$SessionUUID],
				Populations -> {Diameter[]},
				MinDiameter -> 1 Millimeter,
				MaxDiameter -> 0.5 Millimeter,
				Upload->False
			],
			$Failed,
			Messages :> {Error::MinCannotExceedMax, Error::InvalidOption}
		],
		
		(* Index matching primitives *)
		Example[{Messages, IndexMatchingPrimitive, "An error is thrown if some options in MultiFeatured are not index matched:"},
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "Brightfield Test Object"<>$SessionUUID],
				Populations->{
					MultiFeatured[
						Features->{Diameter, Fluorescence},
						NumberOfDivisions->{5}
					]
				},
				Upload->False
			],
			$Failed,
			Messages :> {Error::IndexMatchingPrimitive, Error::InvalidOption}
		],
		
		(* Excess Alls *)
		Example[{Messages, ExcessAlls, "An error is thrown if more than one All is specified in Populations:"},
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "Brightfield Test Object"<>$SessionUUID],
				Populations->{
					All, All
				},
				Upload->False
			],
			$Failed,
			Messages :> {Error::ExcessAlls, Error::InvalidOption}
		],
		
		(* IncludeExcludeOverlap *)
		Example[{Messages, IncludeExcludeOverlap, "An error is thrown if Include and Exclude intersect:"},
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "Brightfield Test Object"<>$SessionUUID],
				Populations->{
					Diameter[
						Include->{{100 Millimeter, 100 Millimeter}},
						Exclude->{{100 Millimeter, 100 Millimeter}}
					]
				},
				Upload->False
			],
			$Failed,
			Messages :> {Error::IncludeExcludeOverlap, Error::InvalidOption}
		],
		
		(* AbsorbanceImageMissing *)
		Example[{Messages, AbsorbanceImageMissing, "An error is thrown if no Absorbance image is present when Absorbance is an analyzed feature:"},
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "Brightfield Test Object"<>$SessionUUID],
				Populations->{
					Absorbance[]
				},
				Upload->False
			],
			$Failed,
			Messages :> {Error::AbsorbanceImageMissing, Error::InvalidOption}
		],
		
		(* FluorescentImageMissing *)
		Example[{Messages, FluorescentImageMissing, "An error is thrown if no Fluorescence image is present when Fluorescence is an analyzed feature:"},
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "Brightfield Test Object"<>$SessionUUID],
				Populations->{
					Fluorescence[Dye->GFP]
				},
				Upload->False
			],
			$Failed,
			Messages :> {Error::FluorescentImageMissing, Error::InvalidOption}
		],
		
		(* BothSelectMethods *)
		Example[{Messages, BothSelectMethods, "An error is thrown if both Threshold and NumberOfDivsions are specified:"},
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "Brightfield Test Object"<>$SessionUUID],
				Populations->{
					Diameter[
						ThresholdDiameter->1.1 Millimeter,
						NumberOfDivisions->2
					]
				},
				Upload->False
			],
			$Failed,
			Messages :> {Error::BothSelectMethods, Error::InvalidOption}
		],
		
		(* ThresholdSelectConflict *)
		Example[{Messages, ThresholdSelectConflict, "An error is thrown if the Select option of the Unit Operation expects a threshold with AboveThreshold or BelowThreshold, but NumberOfDivsions is specified:"},
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "Brightfield Test Object"<>$SessionUUID],
				Populations->{
					Diameter[
						Select -> AboveThreshold,
						NumberOfDivisions ->2
					]
				},
				Upload->False
			],
			$Failed,
			Messages :> {Error::ThresholdMissing, Error::ThresholdSelectConflict, Error::InvalidOption}
		],
		
		(* DivisionSelectConflict *)
		Example[{Messages, DivisionSelectConflict, "An error is thrown if the Select option of the Unit Operation expects a divisions with Min or Max, but a threshold is specified:"},
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "Brightfield Test Object"<>$SessionUUID],
				Populations->{
					Diameter[
						Select -> Max,
						ThresholdDiameter->1.1 Millimeter
					]
				},
				Upload->False
			],
			$Failed,
			Messages :> {Error::DivisionSelectConflict, Error::InvalidOption}
		],
		
		(* ThresholdMissing *)
		Example[{Messages, ThresholdMissing, "An error is thrown if the Select option of the Unit Operation expects a threshold with AboveThreshold or BelowThreshold, but no threshold is specified:"},
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "Brightfield Test Object"<>$SessionUUID],
				Populations->{
					Diameter[
						Select -> AboveThreshold,
						NumberOfDivisions ->2
					]
				},
				Upload->False
			],
			$Failed,
			Messages :> {Error::ThresholdMissing, Error::ThresholdSelectConflict, Error::InvalidOption}
		],
		
		(* InvalidWavelengthPair *)
		Example[{Messages, InvalidWavelengthPair, "An error is thrown if the ExcitationWavelength and EmissionWavelength do not form a pair accepted by the instrument:"},
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "Brightfield Test Object"<>$SessionUUID],
				Populations->{
					Fluorescence[
						ExcitationWavelength-> 377 Nanometer,
						EmissionWavelength-> 692 Nanometer
					]
				},
				Upload->False
			],
			$Failed,
			Messages :> {Error::NoAutomaticWavelength, Error::InvalidWavelengthPair, Error::InvalidOption}
		],
		
		(* DyeWavelengthConflict *)
		Example[{Messages, DyeWavelengthConflict, "An error is thrown if the ExcitationWavelength and EmissionWavelength pair does not match the specified Dye:"},
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "Brightfield Test Object"<>$SessionUUID],
				Populations->{
					Fluorescence[
						Dye -> UltraViolet,
						ExcitationWavelength-> 628 Nanometer,
						EmissionWavelength-> 692 Nanometer
					]
				},
				Upload->False
			],
			$Failed,
			Messages :> {Error::DyeWavelengthConflict, Error::FluorescentImageMissing, Error::InvalidOption}
		],
		
		(* NoAutomaticWavelength *)
		Example[{Messages, NoAutomaticWavelength, "An error is thrown if the ExcitationWavelength and EmissionWavelength or Dye are not specified and cannot automatically be resolved:"},
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "Brightfield Test Object"<>$SessionUUID],
				Populations->{
					Fluorescence[]
				},
				Upload->False
			],
			$Failed,
			Messages :> {Error::NoAutomaticWavelength, Error::InvalidOption}
		],
		
		(* SingleAutomaticWavelength *)
		Example[{Messages, SingleAutomaticWavelength, "A warning is thrown if only one of either the ExcitationWavelength or EmissionWavelength can be automatically resolved:"},
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "Model[Cell] Emission Test Object"<>$SessionUUID],
				Populations->{
					Fluorescence[]
				},
				Upload->False
			],
			_Association,
			Messages :> {Warning::SingleAutomaticWavelength}
		],
		
		(* IncorrectThresholdFormat *)
		Example[{Messages, IncorrectThresholdFormat, "An error is thrown if the threshold is expected be a quantity (Diameter/Isolation) but is a number (Regularity/Circularity) or vice versa:"},
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "Brightfield Test Object"<>$SessionUUID],
				Populations->{
					MultiFeatured[
						Features->{Diameter, Regularity},
						Threshold->{0.9, 0.9}
					]
				},
				Upload->False
			],
			$Failed,
			Messages :> {Error::IncorrectThresholdFormat, Error::InvalidOption}
		],
		
		(* NotMultipleFeatures *)
		Example[{Messages, NotMultipleFeatures, "An error is thrown if only a single feature is specified in the MultiFeatured Unit Operation:"},
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "Brightfield Test Object"<>$SessionUUID],
				Populations->{
					MultiFeatured[
						Features->{Diameter}
					]
				},
				Upload->False
			],
			$Failed,
			Messages :> {Error::NotMultipleFeatures, Error::InvalidOption}
		],
		
		
		(* --- TESTS --- *)
		
		Test["Tests are returned with Output->Tests:",
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "Brightfield Test Object"<>$SessionUUID],
				Populations -> {Diameter[]},
				Output->Tests,
				Upload->False
			],
			List[_EmeraldTest..]
		],
		
		Test["Index matched options can be resolved, even with failures:",
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "Brightfield Test Object"<>$SessionUUID],
				Populations->{
					MultiFeatured[
						Features -> {Diameter, Fluorescence},
						Select -> {Max, Positive},
						NumberOfDivisions-> {5, Null}
					]
				},
				Output->Options
			],
			_List,
			Messages :> {Error::NoAutomaticWavelength, Error::InvalidOption}
		],
		
		Test["A packet with Type Object[Data, Appearance, Colonies] can be used as input for analysis for option resolution:",
			brightfieldExamplePacket = <|
				Type -> Object[Data, Appearance, Colonies],
				ImageFile -> Link[Object[EmeraldCloudFile, "id:54n6evnrr4Z7"]],
				VioletFluorescenceImageFile -> Link[Object[EmeraldCloudFile, "id:54n6evnrr4Z7"]]
			|>;
			AnalyzeColonies[
				brightfieldExamplePacket,
				Populations->{Diameter[]},
				Upload->False,
				Output->Options
			],
			_List
		],
		
		Test["Options are returned for an AnalyzeColonies call with two colony selections:",
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "Brightfield Test Object"<>$SessionUUID],
				Populations->{{
					Diameter[],
					Absorbance[]
				}},
				Upload->False,
				Output->Options
			],
			_List,
			Messages :> {Error::AbsorbanceImageMissing, Error::InvalidOption}
		],
		
		Test["Index matching singletons will be repeated to match the width of the object:",
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "Brightfield Test Object"<>$SessionUUID],
				Populations->{
					MultiFeatured[
						Features->{Diameter, Fluorescence},
						NumberOfDivisions->5,
						NumberOfColonies->5
					]
				},
				Output->Options
			],
			_List,
			Messages :> {Error::NoAutomaticWavelength, Error::InvalidOption}
		],
		
		Test["A minimal packet will return options:",
			AnalyzeColonies[
				<|
					Object -> CreateID[Object[Data,Appearance,Colonies]],
					CellTypes -> {Link[Model[Cell, "Fluorescence wavelength Model[Cell]"<>$SessionUUID]]}
				|>,
				Populations->{AllColonies[]},
				Output->Options,
				Upload->False
			],
			_List
		],
		
		Test["An object with multiple cell types will use the first cell type to determine an appropriate wavelength:",
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "Model[Cell] Test Object Multiple Objects"<>$SessionUUID],
				Upload -> False,
				Output -> Options
			],
			_List
		],
		
		Test["Multiple data objects can be analyzed simultaneously:",
			packets = AnalyzeColonies[
				{
					Object[Data, Appearance, Colonies, "Model[Cell] Test Object"<>$SessionUUID],
					Object[Data, Appearance, Colonies, "Model[Cell] Test Object"<>$SessionUUID]
				},
				Populations->{
					MultiFeatured[
						Features->{Diameter, Fluorescence},
						NumberOfDivisions->5,
						NumberOfColonies->5
					]
				},
				MinCircularityRatio->{0.1, 0.01},
				Upload->False
			];
			MatchQ[packets, List[_Association..]],
			True,
			Variables:>{packets}
		],
		
		Test["Multiple fluorescences can be analyzed simultaneously:",
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "two fluorescence"<>$SessionUUID],
				Populations->{
					MultiFeatured[
						Features->{Fluorescence, Fluorescence},
						ExcitationWavelength->{Quantity[377,"Nanometers"], Quantity[457,"Nanometers"]},
						EmissionWavelength->{Quantity[447,"Nanometers"], Quantity[536,"Nanometers"]}
					]
				},
				Upload->False
			],
			ObjectP[Object[Analysis, Colonies]]
		],
		
		Test["Upload Object[Analysis, Colonies]:",
			AnalyzeColonies[
				Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID]
			],
			ObjectP[Object[Analysis, Colonies]]
		]
	},
	
	SymbolSetUp:>{
		
		(* create test objects by name in module *)
		Module[
			{
				modelCellPacket, modelCellEmissionOnlyPacket, modelCellObject, modelCellEmissionOnlyObject,
				brightfieldTestPacket, appearanceModelCellPacket, appearanceModelCellEmissionPacket, appearanceMultipleModelCellPacket,
				twoFluorescenceTestPacket, brightfieldTestObject, appearanceModelCellObject,
				appearanceModelCellEmissionObject, appearanceMultipleModelCellObject, twoFluorescenceTestObject,
				qpixVioletFluorescencePacket, qpixVioletFluorescenceObject, allObjects, existingObjects
			},
			
			allObjects={
				Model[Cell, "Fluorescence wavelength Model[Cell]"<>$SessionUUID],
				Model[Cell, "Fluorescence wavelength Emission Model[Cell]"<>$SessionUUID],
				Object[Data, Appearance, Colonies, "Brightfield Test Object"<>$SessionUUID],
				Object[Data, Appearance, Colonies, "Model[Cell] Test Object"<>$SessionUUID],
				Object[Data, Appearance, Colonies, "Model[Cell] Emission Test Object"<>$SessionUUID],
				Object[Data, Appearance, Colonies, "Model[Cell] Test Object Multiple Objects"<>$SessionUUID],
				Object[Data, Appearance, Colonies, "two fluorescence"<>$SessionUUID]
			};
			
			existingObjects=PickList[Flatten[allObjects], DatabaseMemberQ[Flatten[allObjects]]];
			EraseObject[existingObjects, Force->True, Verbose->False];
			
			$CreatedObjects={};
			
			(* create model[Cell] packet *)
			modelCellPacket = <|
				Type->Model[Cell],
				Name->"Fluorescence wavelength Model[Cell]"<>$SessionUUID,
				FluorescentExcitationWavelength->{350 Nanometer, 400 Nanometer},
				FluorescentEmissionWavelength->{400 Nanometer, 450 Nanometer}
			|>;
			
			modelCellEmissionOnlyPacket = <|
				Type->Model[Cell],
				Name->"Fluorescence wavelength Emission Model[Cell]"<>$SessionUUID,
				FluorescentEmissionWavelength->{550 Nanometer, 620 Nanometer}
			|>;
			
			{
				modelCellObject,
				modelCellEmissionOnlyObject
			}= Upload[
				{
					modelCellPacket,
					modelCellEmissionOnlyPacket
				}
			];
			
			(* create brightfieldTestPacket *)
			brightfieldTestPacket = <|
				Type -> Object[Data, Appearance, Colonies],
				Name->"Brightfield Test Object"<>$SessionUUID,
				ImageFile -> Link[Object[EmeraldCloudFile, "id:54n6evnrr4Z7"]],
				VioletFluorescenceImageFile -> Link[Object[EmeraldCloudFile, "id:54n6evnrr4Z7"]]
			|>;
			
			(* create test packet for model[Cell] *)
			appearanceModelCellPacket = <|
				Type -> Object[Data, Appearance, Colonies],
				Name->"Model[Cell] Test Object"<>$SessionUUID,
				ImageFile -> Link[Object[EmeraldCloudFile, "id:54n6evnrr4Z7"]],
				Replace[CellTypes]->{Link[modelCellObject]},
				VioletFluorescenceImageFile -> Link[Object[EmeraldCloudFile, "id:54n6evnrr4Z7"]]
			|>;
			
			(* create test packet for model[Cell] with only an emission wavelength *)
			appearanceModelCellEmissionPacket = <|
				Type -> Object[Data, Appearance, Colonies],
				Name->"Model[Cell] Emission Test Object"<>$SessionUUID,
				ImageFile -> Link[Object[EmeraldCloudFile, "id:54n6evnrr4Z7"]],
				Replace[CellTypes]->{Link[modelCellEmissionOnlyObject]},
				OrangeFluorescenceImageFile -> Link[Object[EmeraldCloudFile, "id:54n6evnrr4Z7"]]
			|>;
			
			(* test packet with multiple cell type links *)
			appearanceMultipleModelCellPacket = <|
				Type -> Object[Data, Appearance, Colonies],
				Name->"Model[Cell] Test Object Multiple Objects"<>$SessionUUID,
				ImageFile -> Link[Object[EmeraldCloudFile, "id:54n6evnrr4Z7"]],
				Replace[CellTypes]->{Link[modelCellObject], Link[modelCellObject]},
				VioletFluorescenceImageFile -> Link[Object[EmeraldCloudFile, "id:54n6evnrr4Z7"]]
			|>;
			
			(*create brightfieldTestPacket*)
			twoFluorescenceTestPacket=<|
				Type->Object[Data,Appearance,Colonies],
				Name->"two fluorescence"<>$SessionUUID,
				ImageFile->Link[Object[EmeraldCloudFile,"id:54n6evnrr4Z7"]],
				VioletFluorescenceImageFile->Link[Object[EmeraldCloudFile,"id:54n6evnrr4Z7"]],
				GreenFluorescenceImageFile->Link[Object[EmeraldCloudFile,"id:54n6evnrr4Z7"]]
			|>;
			
			(* create packet for new images *)
			qpixVioletFluorescencePacket=<|
				Type -> Object[Data, Appearance, Colonies],
				Name->"qpix Violet Fluorescence"<>$SessionUUID,
				ImageFile -> Link[Object[EmeraldCloudFile, "id:L8kPEjkAWaal"]],
				Replace[CellTypes]->{Link[modelCellObject]},
				VioletFluorescenceImageFile -> Link[Object[EmeraldCloudFile, "id:mnk9jOkG177Y"]]
			|>;
			
			
			(* upload the test packets *)
			{
				brightfieldTestObject,
				appearanceModelCellObject,
				appearanceModelCellEmissionObject,
				appearanceMultipleModelCellObject,
				twoFluorescenceTestObject,
				qpixVioletFluorescenceObject
			} = Upload[
				{
					brightfieldTestPacket,
					appearanceModelCellPacket,
					appearanceModelCellEmissionPacket,
					appearanceMultipleModelCellPacket,
					twoFluorescenceTestPacket,
					qpixVioletFluorescencePacket
				}
			];
		
		]
		
	},
	
	SymbolTearDown:>{
		allObjects= Join[
			Flatten[{
				Model[Cell, "Fluorescence wavelength Model[Cell]"<>$SessionUUID],
				Model[Cell, "Fluorescence wavelength Emission Model[Cell]"<>$SessionUUID],
				Object[Data, Appearance, Colonies, "Brightfield Test Object"<>$SessionUUID],
				Object[Data, Appearance, Colonies, "Model[Cell] Test Object"<>$SessionUUID],
				Object[Data, Appearance, Colonies, "Model[Cell] Emission Test Object"<>$SessionUUID],
				Object[Data, Appearance, Colonies, "Model[Cell] Test Object Multiple Objects"<>$SessionUUID],
				Object[Data, Appearance, Colonies, "two fluorescence"<>$SessionUUID],
				Object[Data, Appearance, Colonies, "qpix Violet Fluorescence"<>$SessionUUID]
			}],
			$CreatedObjects
		];
		existingObjects=PickList[allObjects, DatabaseMemberQ[allObjects]];
		EraseObject[existingObjects, Force->True, Verbose->False];
		
		Unset[$CreatedObjects];
	}
];

DefineTests[Diameter,
	{
		Example[{Basic,"Generate a Diameter unit operation:"},
			Diameter[],
			_Diameter
		],
		Example[{Basic,"Generate a Diameter unit operation that selects a population by threshold:"},
			Diameter[ThresholdDiameter -> 1 Millimeter],
			_Diameter
		],
		Example[{Basic,"Generate a Diameter unit operation that selects a population by the NumberOfDivisions:"},
			Diameter[
				PopulationName->"NumberOfDivisions Population",
				NumberOfDivisions->10,
				Select -> Min
			],
			_Diameter
		]
	}
];

DefineTests[Isolation,
	{
		Example[{Basic,"Generate an Isolation unit operation:"},
			Isolation[],
			_Isolation
		],
		Example[{Basic,"Generate an Isolation unit operation that selects a population by threshold:"},
			Isolation[ThresholdDistance -> 1 Millimeter],
			_Isolation
		],
		Example[{Basic,"Generate an Isolation unit operation that selects a population by the NumberOfDivisions:"},
			Isolation[
				PopulationName->"NumberOfDivisions Population",
				NumberOfDivisions->10,
				Select -> Min
			],
			_Isolation
		]
	}
];

DefineTests[Regularity,
	{
		Example[{Basic,"Generate a Regularity unit operation:"},
			Regularity[],
			_Regularity
		],
		Example[{Basic,"Generate a Regularity unit operation that selects a population by threshold:"},
			Regularity[ThresholdRegularity -> 0.9],
			_Regularity
		],
		Example[{Basic,"Generate a Regularity unit operation that selects a population by the NumberOfDivisions:"},
			Regularity[
				PopulationName->"NumberOfDivisions Population",
				NumberOfDivisions->10,
				Select -> Min
			],
			_Regularity
		]
	}
];

DefineTests[Circularity,
	{
		Example[{Basic,"Generate a Circularity unit operation:"},
			Circularity[],
			_Circularity
		],
		Example[{Basic,"Generate a Circularity unit operation that selects a population by threshold:"},
			Circularity[ThresholdCircularity -> 0.9],
			_Circularity
		],
		Example[{Basic,"Generate a Circularity unit operation that selects a population by the NumberOfDivisions:"},
			Circularity[
				PopulationName->"NumberOfDivisions Population",
				NumberOfDivisions->10,
				Select -> Min
			],
			_Circularity
		]
	}
];

DefineTests[Fluorescence,
	{
		Example[{Basic,"Generate a Fluorescence unit operation:"},
			Fluorescence[],
			_Fluorescence
		],
		Example[{Basic,"Generate a Fluorescence unit operation that selects a population by being Positive for Fluorescence:"},
			Fluorescence[Select-> Positive],
			_Fluorescence
		],
		Example[{Basic,"Generate a Fluorescence unit operation that selects a population by the NumberOfDivisions:"},
			Fluorescence[
				PopulationName->"NumberOfDivisions Population",
				NumberOfDivisions->10,
				Select -> Min
			],
			_Fluorescence
		]
	}
];

DefineTests[AllColonies,
	{
		Example[{Basic,"Generate an AllColonies unit operation:"},
			AllColonies[],
			_AllColonies
		],
		Example[{Basic,"Generate an AllColonies unit operation that selects a population by the NumberOfDivisions:"},
			AllColonies[
				PopulationName->"All Colonies"
			],
			_AllColonies
		]
	}
];


DefineTests[MultiFeatured,
	{
		Example[{Basic,"Generate a MultiFeatured unit operation:"},
			MultiFeatured[],
			_MultiFeatured
		],
		Example[{Basic,"Generate a MultiFeatured that groups a population by the Diameter and Isolation:"},
			MultiFeatured[Features->{Diameter, Isolation}],
			_MultiFeatured
		],
		Example[{Basic,"Generate a MultiFeatured that groups a population by the Diameter and Isolation with NumberOfDivisions and Thresholds:"},
			MultiFeatured[
				PopulationName->"Isolated and Large Colonies",
				NumberOfDivisions->{10, Null},
				Threshold -> {Null, 1 Millimeter}
			],
			_MultiFeatured
		]
	}
];