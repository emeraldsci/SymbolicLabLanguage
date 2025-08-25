(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ExperimentUVMelting*)


DefineUsage[ExperimentUVMelting,
{

	BasicDefinitions -> {
		{
			Definition->{"ExperimentUVMelting[Samples]","Protocol"},
			Description->"generates a 'Protocol' object for assessing the dissociation characteristics on the provided 'Samples' during heating and cooling (melting curve analysis) using UV absorbance measurements.",
			Inputs:>{
				IndexMatching[
					{
						InputName -> "Samples",
						Description-> "The samples or containers on which the experiment should act.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[{Object[Sample],Object[Container],Model[Sample]}],
							Dereference->{
								Object[Container]->Field[Contents[[All,2]]]
							}
						],
						Expandable->False,
						NestedIndexMatching->True
					},
					IndexName->"experiment samples"
				]
			},
			Outputs:>{
				{
					OutputName->"Protocol",
					Description->"The protocol object describing how to run the UVMelting experiment.",
					Pattern:>ListableP[ObjectP[Object[Protocol,UVMelting]]]
				}
			}
		}
	},
	MoreInformation -> {
		"Samples for this experiment can be prepared by pooling multiple samples with buffer inside instrument-suitable cuvettes. The maximum number of cuvettes that can currently be analysed simultaneously is 5.",
		"    - To indicate that samples should be pooled, wrap the corresponding input samples in additional curly brackets, as shown in the examples below, e.g. {{s1,s2},{s3,s4}}.",
		"    - Providing samples or container vessels in a flat list indicates that each sample should be measured individually and not be pooled.",
		"    - Providing samples in a plate indicates that each sample in the plate should be measured individually ({myPlate}). If you wish to pool all samples in the plate, wrap the plate in additional list, e.g. {{myPlate}}.",
		"    - There is no upper limit as to how many samples can be pooled for this experiment, provided that the total volume of the samples plus buffer(s) fit inside the cuvette.",
		"Prior to the aliquotting of sample(s) and buffer(s) into the cuvettes, the individual samples can be subjected to Incubation, Centrifugation, and Filtering using the shared SamplePreparation framework. Default options and option resolutions apply.",
		"    - sample preparation options for the input samples can be provided by singletons, values index-matched to the number of pools, or via a nested list matching the SamplesIn.",
		"The aliquotting / pooling of sample(s) and buffer(s) into the cuvette is performed using the shared Aliquot SamplePreparation framework. All options and default option resolution apply, some of which are listed here for clarity.",
		"    - If NONE of AssayVolume, AliquotAmount, and TargetConcentration are specified, the experiment function assumes that no dilution is desired and the samples will be pooled into the cuvette without addition of buffer.",
		"    - If AssayBuffer is not provided, but required because AssayVolume or TargetConcentration dictate it, it will automatically be set to Model[Sample, \"Milli-Q water\"].",
		"    - The cuvette in which the sample(s) should be measured can be provided via the option AliquotContainer. If AliquotContainer is not specified, and a transfer into a cuvette is needed, it will automatically be set to a model cuvette whose working range (see table below) is suitable for the total volume of the sample (sample(s) and buffer combined).",
		"The pooled sample inside the cuvette can be subjected to additional mixing and incubation, if desired, via the NestedIndexMatchingMix->True and NestedIndexMatchingIncubate->True bool options, plus their affiliated parameters.",
		"    - Mixing of the cuvette: If pooling of sample(s) and buffer occurred, mixing of the pool inside the cuvette defaults to True. Mixing is performed by pipetting up and down unless the narrow cuvette aperture and sample volume doesn't allow for it, in which case mixing is performed by inversion.",
		"    - Incubation of the cuvette: Incubation of the sample/pool inside the cuvette will not be set to True unless indicated by the user.",
		"    - The pooling options can be provided as a singleton, or as a list of values index-matched to the pools. For example, for the input samples {{s1,s2},{s3,s4}, NestedIndexMatchingMix->True and NestedIndexMatchingMix->{True,False} are both valid, while NestedIndexMatchingMix->{{True,True},{False,False}} or {True, True, False, False} are not.",
		Grid[{
			{"Scale", "Container Model", "Name", "Working Range", "Default Mix Type"},
			{"Micro", "Model[Container, Cuvette, \"id:eGakld01zz3E\"]", "Micro Scale Black Walled UV Quartz Cuvette", "0.4 - 1.0 mL", "Inversion"},
			{"Semi-Micro", "Model[Container, Cuvette, \"id:R8e1PjRDbbld\"]", "Semi-Micro Scale Black Walled UV Quartz Cuvette", "0.7 - 1.9 mL", "Pipette"},
			{"Standard", "Model[Container, Cuvette, \"id:Y0lXejGKdd1x\"]", "Standard Scale Frosted UV Quartz Cuvette", "1.9 - 4.0 mL", "Pipette"}
		}],
		"Zero-ing of the instrument via a single measurement with buffer only, prior to the thermocycling measurement, can be performed via the option BlankMeasurement->True. In this case, first the buffer is pipetted into the cuvette, a reading is performed, and then the samples are added to the cuvette.",
		"    - Blank measurements can only be taken if the buffer component of each cuvette's contents reaches above the read height of the spectrophotometer (see working range above). An error will be thrown if this is not the case.",
		"    - Blank measurements cannot be performed if a instrument-suitable cuvette is given as input and Aliquot->False, and/or if no AssayBuffer or ConcentratedBuffer/DilutionBuffer is provided."
	},
	SeeAlso -> {
		"ValidExperimentUVMeltingQ",
		"ExperimentUVMeltingOptions",
		"AnalyzeMeltingPoint",
		"AnalyzeThermodynamics",
		"PlotAbsorbanceThermodynamics",
		"PlotThermodynamics",
		"PlotMeltingPoint",
		"ExperimentFluorescenceKinetics",
		"ExperimentAbsorbanceSpectroscopy"
	},
	Author -> {"dima", "steven", "simon.vu", "waltraud.mair", "ben", "hayley"}
}];



(* ::Subsubsection:: *)
(*ExperimentUVMeltingOptions*)


DefineUsage[ExperimentUVMeltingOptions,
	{

		BasicDefinitions -> {
			{
				Definition->{"ExperimentUVMeltingOptions[Samples]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentUVMelting when it is called on 'Samples'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples or containers on which the experiment should act.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container],Model[Sample]}],
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								}
							],
							Expandable->False,
							NestedIndexMatching->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"Resolved options when ExperimentUVMelting is called on the input objects.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"This function returns the resolved options that would be fed to ExperimentUVMelting if it were called on these input objects."
		},
		SeeAlso -> {
			"ExperimentUVMelting",
			"ValidExperimentUVMeltingQ",
			"AnalyzeMeltingPoint",
			"AnalyzeThermodynamics",
			"PlotAbsorbanceThermodynamics",
			"PlotThermodynamics",
			"PlotMeltingPoint",
			"ExperimentFluorescenceKinetics",
			"ExperimentAbsorbanceSpectroscopy"
		},
		Author -> {"dima", "steven", "simon.vu", "waltraud.mair"}
	}];


DefineUsage[ExperimentUVMeltingPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentUVMeltingPreview[Samples]", "Preview"},
				Description -> "returns the graphical preview for ExperimentUVMelting when it is called on 'Samples'.  This output is always Null.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples or containers on which the experiment should act.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container],Model[Sample]}],
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								}
							],
							Expandable->False,
							NestedIndexMatching->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "Graphical preview representing the output of ExperimentUVMelting.  This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentUVMelting",
			"ValidExperimentUVMeltingQ",
			"ExperimentUVMeltingOptions",
			"AnalyzeMeltingPoint",
			"AnalyzeThermodynamics",
			"PlotAbsorbanceThermodynamics",
			"PlotThermodynamics",
			"PlotMeltingPoint",
			"ExperimentFluorescenceKinetics",
			"ExperimentAbsorbanceSpectroscopy"
		},
		Author -> {"dima", "steven", "simon.vu", "waltraud.mair"}
	}
];


(* ::Subsubsection:: *)
(*ValidExperimentUVMeltingQ*)


DefineUsage[ValidExperimentUVMeltingQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentUVMeltingQ[Samples]", "Booleans"},
				Description -> "checks whether the provided 'Samples' and specified options are valid for calling ExperimentUVMelting.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples or containers on which the experiment should act.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container],Model[Sample]}],
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								}
							],
							Expandable->False,
							NestedIndexMatching->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Booleans",
						Description -> "Whether or not the ExperimentUVMelting call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentUVMelting",
			"ExperimentUVMeltingOptions",
			"AnalyzeMeltingPoint",
			"AnalyzeThermodynamics",
			"PlotAbsorbanceThermodynamics",
			"PlotThermodynamics",
			"PlotMeltingPoint",
			"ExperimentFluorescenceKinetics",
			"ExperimentAbsorbanceSpectroscopy"
		},
		Author -> {"dima", "steven", "simon.vu", "waltraud.mair"}
	}
];