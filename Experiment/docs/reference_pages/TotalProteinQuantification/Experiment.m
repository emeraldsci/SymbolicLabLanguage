(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(* ExperimentTotalProteinQuantification *)

DefineUsage[ExperimentTotalProteinQuantification,{
	BasicDefinitions-> {
		{
			Definition -> {"ExperimentTotalProteinQuantification[Samples]", "Protocol"},
			Description ->"generates a 'Protocol' object for running an absorbance- or fluorescence-based assay to determine the total protein concentration of input 'Samples'.",
			Inputs :> {
				IndexMatching[
					{
						InputName -> "Samples",
						Description -> "The samples to be run in an absorbance- or fluorescence-based total protein concentration determination assay. The concentration of proteins present in the samples is determined by change in absorbance or fluorescence of a dye at a specific wavelength.",
						Widget -> Alternatives[
							"Sample or Container" -> Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes->{Object[Sample],Object[Container]},
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								}
							],
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
					Description -> "A protocol object for running an absorbance- or fluorescence-based assay to determine total protein concentration.",
					Pattern :> ObjectP[Object[Protocol, TotalProteinDetection]]
				}
			}
		}
	},
	MoreInformation->{
		"When AssayType -> Bradford, a Quick Start Bradford Protein Assay is performed. For more information about compatible reagents and troubleshooting, please see Object[Report,Literature,\"Quick Start Bradford Protein Assay Instruction Manual\"].",
		"When AssayType -> BCA, a Pierce BCA Protein Assay is performed. For more information about compatible reagents and troubleshooting, please see Object[Report,Literature,\"Pierce BCA Protein Assay Kit Instructions\"].",
		"When AssayType -> FluorescenceQuantification, a Quant-iT Protein Assay is performed. For more information about compatible reagents and troubleshooting, please see Object[Report, Literature, \"Quant-iT Protein Assay Kit User Guide\"].",
		"The protein quantification experiment is carried out in a 96-well plate of model Model[Container, Plate, \"96-well Black Wall Greiner Plate\"].",
		"If multiple QuantificationWavelengths are specified, the absorbance or fluorescence values of each from those wavelengths will be averaged to create the standard curve used for protein quantification.",
		"The average calculated TotalProteinConcentration is uploaded to each unique input sample. This average takes into account NumberOfReplicates, as well as any dilution of input samples using the Aliquot Sample Preparation options."
	},
	SeeAlso->{
		"ExperimentTotalProteinQuantificationOptions",
		"ExperimentTotalProteinQuantificationPreview",
		"ValidExperimentTotalProteinQuantificationQ",
		"AnalyzeTotalProteinQuantification"
	},
	Tutorials->{
		"Sample Preparation"
	},
	Author->{"jireh.sacramento", "andrey.shur", "lei.tian", "jihan.kim", "kstepurska", "eqian", "spencer.clark"}
}];