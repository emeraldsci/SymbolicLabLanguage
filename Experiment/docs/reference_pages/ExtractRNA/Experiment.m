(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*ExperimentExtractRNA*)

DefineUsage[ExperimentExtractRNA,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentExtractRNA[Samples]","Protocol"},
				Description->"creates a 'Protocol' object for isolating RNA from live cell or cell lysate 'Samples' through lysing (if the input sample contains cells, rather than lysate), clearing the lysate of cellular debris by homogenization (optional), followed by one or more rounds of optional crude purification techniques including precipitation (such as a cold ethanol or isopropanol wash), liquid-liquid extraction (such as a phenol-chloroform extraction), solid phase extraction (such as a spin column), and magnetic bead separation (selectively binding RNA to magnetic beads while washing non-binding impurities from the mixture). Digestion enzymes can be added during any of these crude purification steps to degrade DNA in order to improve the purity of the extracted RNA. Extracted RNA can be further purified and analyzed with experiments including, but not limited to, ExperimentHPLC, ExperimentFPLC, and ExperimentPAGE (see experiment help files to learn more).",(*TODO: refine common phrase at the end to hint at further purification options available. coordinate with extract team. 'Including but not limited to ... See help files here to find out more'*)
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The live cell or cell lysate samples from which RNA is to be extracted.",
							Widget->Alternatives[
								"Sample or Container"->Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
									Dereference->{
										Object[Container]->Field[Contents[[All,2]]]
									}
								],
								"Container with Well Position"->{
									"Well Position"->Alternatives[
										"A1 to P24"->Widget[
											Type->Enumeration,
											Pattern:>Alternatives@@Flatten[AllWells[NumberOfWells->384]],
											PatternTooltip->"Enumeration must be any well from A1 to P24."
										],
										"Container Position"->Widget[
											Type->String,
											Pattern:>LocationPositionP,
											PatternTooltip->"Any valid container position.",
											Size->Line
										]
									],
									"Container"->Widget[
										Type->Object,
										Pattern:>ObjectP[{Object[Container]}]
									]
								}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"Protocol generated to isolate RNA from live cell(s) or cell lysate(s) in the input object(s) or containter(s).",
						Pattern:>ObjectP[Object[Protocol,RoboticCellPreparation]]
					}
				}
			}
		},
		MoreInformation->{},
		SeeAlso->{
			ValidExperimentExtractRNAQ,
			ExperimentExtractRNAOptions,
			ExperimentLyseCells,
			(*ExperimentExtractGenomicDNA,*)
			ExperimentExtractPlasmidDNA,
			ExperimentExtractProtein,
			(*ExperimentExtractOrganelle,*)
			ExperimentSolidPhaseExtraction,
			ExperimentLiquidLiquidExtraction,
			ExperimentPrecipitate,
			ExperimentMagneticBeadSeparation,
			ExperimentqPCR,
			ExperimentDigitalPCR,
			ExperimentPCR,
			ExperimentPAGE,
			ExperimentAbsorbanceSpectroscopy
		},
		Tutorials->{},
		Author->{
			"melanie.reschke"
		}

	}
];