(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentAgaroseGelElectrophoresis*)

DefineUsage[ExperimentAgaroseGelElectrophoresis,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentAgaroseGelElectrophoresis[Samples]", "Protocol"},
				Description -> "generates a 'Protocol' object to conduct electrophoretic size and charged based separation on input 'Samples' by running them through agarose gels.  Experiments can be run analytically to assess composition and purity or preparatively to purify selected bands of material as they run through the gel.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples to be run through an agarose gel and analyzed and/or purified via gel electrophoresis.",
							Widget ->
								Alternatives[
									"Sample or Container"->Widget[
										Type -> Object,
										Pattern :> ObjectP[{Object[Sample], Object[Container]}],
										ObjectTypes -> {Object[Sample], Object[Container]},
										Dereference -> {
											Object[Container] -> Field[Contents[[All, 2]]]
										}
									],
									"Container with Well Position"->{
										"Well Position" -> Alternatives[
											"A1 to P24" -> Widget[
												Type -> Enumeration,
												Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
												PatternTooltip -> "Enumeration must be any well from A1 to H12."
											],
											"Container Position" -> Widget[
												Type -> String,
												Pattern :> LocationPositionP,
												PatternTooltip -> "Any valid container position.",
												Size->Line
											]
										],
										"Container" -> Widget[
											Type -> Object,
											Pattern :> ObjectP[{Object[Container]}]
										]
									},
									"Model Sample"->Widget[
										Type -> Object,
										Pattern :> ObjectP[Model[Sample]],
										ObjectTypes -> {Model[Sample]}
									]
								],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Protocol",
						Description -> "A protocol object that describes the agarose gel electrophoresis experiment to be run.",
						Pattern :> ObjectP[Object[Protocol, AgaroseGelElectrophoresis]]
					}
				}
			}
		},
		MoreInformation -> {
			"A maximum of 48 samples across four gels can be run in one protocol when the Scale is Preparative.",
			"A maximum of 92 samples across four gels can be run in one protocol when the Scale is Analytical, with one Ladder lane in each gel.",
			"The most accurate sizing is achieved by selecting two Loading Dyes with oligomer lengths shorter and longer than the band of interest. Please see Section 7.1 and Figure 7.1.0.1 of Object[Report, Literature, \"Ranger Technology User Manual Rev 1.14\"] for more detailed information about appropriate LoadingDyes for each gel percentage, and the Object Catalog or AgaroseLoadingDyeP for a list of all LoadingDyes compatible with agarose gels.",
			"Overloading can lead to inaccurate sizing. The loading capacity for discrete bands of dsDNA varies from 250 ng to 2 ug, depending on both the AgarosePercentage and the oligomer length. Please refer to Section 7.2.1 and Table 7.2.1.1 of Object[Report, Literature, \"Ranger Technology User Manual Rev 1.14\"] for more detailed information.",
			"High ionic-strength buffers, such as PCR buffers, can have an impact on the migration rate of DNA oligomers. Typically, the calculated size of oligomers will be smaller than expected in such buffers. Please refer to Section 7.7.2 of Object[Report, Literature, \"Ranger Technology User Manual Rev 1.14\"] for more information on how ionic strength affects sizing. This sizing issue can be mitigated by diluting input samples with water.",
			"When the Scale is Preparative, there are multiple ways to specify which band will be isolated. The recommended method is to set AutomaticPeakDetection to True, and to specify the PeakDetectionRange. Doing so will collect the largest (most fluorescent) peak in this region. The default PeakDetectionRange is from 75% to 110% of the size of the band of interest. Another reasonable method is to set AutomaticPeakDetection to False and set the CollectionSize to the size of the band of interest. This method may lead to missing the band of interest in a high ionic strength buffer. It is not recommended to specify the CollectionRange, as doing so may lead to low sample recovery or very dilute recovered sample. For more information about size selection, and how the ExtractionVolume is related, please refer to Section 7.3 of Object[Report, Literature, \"Ranger Technology User Manual Rev 1.14\"].",
			"Table 1.1: Available Gels for Analytical and Preparative Experiments:",
			Grid[{
				{"Scale", "AgarosePercentage", "GelModel"},
				{Preparative, 0.5 Percent, Model[Item, Gel, "Size Selection 0.5% agarose cassette, 12 channel"]},
				{Analytical, 0.5 Percent, Model[Item, Gel, "Analytical 0.5% agarose cassette, 24 channel"]},
				{Preparative, 1.0 Percent, Model[Item, Gel, "Size Selection 1.0% agarose cassette, 12 channel"]},
				{Analytical, 1.0 Percent, Model[Item, Gel, "Analytical 1.0% agarose cassette, 24 channel"]},
				{Preparative, 1.5 Percent, Model[Item, Gel, "Size Selection 1.5% agarose cassette, 12 channel"]},
				{Analytical, 1.5 Percent, Model[Item, Gel, "Analytical 1.5% agarose cassette, 24 channel"]},
				{Preparative, 2.0 Percent, Model[Item, Gel, "Size Selection 2.0% agarose cassette, 12 channel"]},
				{Analytical, 2.0 Percent, Model[Item, Gel, "Analytical 2.0% agarose cassette, 24 channel"]},
				{Preparative, 3.0 Percent, Model[Item, Gel, "Size Selection 3.0% agarose cassette, 12 channel"]},
				{Analytical, 3.0 Percent, Model[Item, Gel, "Analytical 3.0% agarose cassette, 24 channel"]}
			}],
			"Table 1.2: Default LoadingDye Selections Based on AgarosePercentage:",
			Grid[{
				{"AgarosePercentage", "LoadingDye 1", "LoadingDye 2"},
				{"0.5%", Model[Sample, "3000 bp dyed loading buffer for agarose gel electrophoresis"], Model[Sample, "10000 bp dyed loading buffer for agarose gel electrophoresis"]},
				{"1%", Model[Sample, "1000 bp dyed loading buffer for agarose gel electrophoresis"], Model[Sample, "10000 bp dyed loading buffer for agarose gel electrophoresis"]},
				{"1.5%", Model[Sample, "300 bp dyed loading buffer for agarose gel electrophoresis"], Model[Sample, "3000 bp dyed loading buffer for agarose gel electrophoresis"]},
				{"2%", Model[Sample, "200 bp dyed loading buffer for agarose gel electrophoresis"], Model[Sample, "2000 bp dyed loading buffer for agarose gel electrophoresis"]},
				{"3%", Model[Sample, "100 bp dyed loading buffer for agarose gel electrophoresis"], Model[Sample, "500 bp dyed loading buffer for agarose gel electrophoresis"]}
			}]
		},
		SeeAlso -> {
			"ValidExperimentAgaroseGelElectrophoresisQ",
			"ExperimentAgaroseGelElectrophoresisOptions",
			"ExperimentAgaroseGelElectrophoresisPreview",
			"AnalyzePeaks",
			"ExperimentPAGE"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {"mohamad.zandian", "hayley", "nont.kosaisawe", "xiwei.shan", "spencer.clark"}
	}
];