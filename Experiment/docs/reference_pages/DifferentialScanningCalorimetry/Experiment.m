(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ExperimentDifferentialScanningCalorimetry*)


DefineUsage[ExperimentDifferentialScanningCalorimetry,
	{

		BasicDefinitions -> {
			{
				Definition->{"ExperimentDifferentialScanningCalorimetry[Samples]","Protocol"},
				Description->"generates a 'Protocol' object for performing capillary-based differential scanning calorimetry (DSC) on the provided 'Samples' by measuring the heat flux as a function of temperature.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples which will be heated to determine thermodynamic properties. If provided as a list of lists, each group of samples or containers within a single list are combined before the experiment is run.",
							Widget->Alternatives[
								"Sample or Container" -> Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
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
							Expandable->False,
							NestedIndexMatching->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol object describing how to run the DSC experiment.",
						Pattern:>ListableP[ObjectP[Object[Protocol,DifferentialScanningCalorimetry]]]
					}
				}
			}
		},
		MoreInformation -> {
			"Samples for this experiment can be prepared by pooling multiple samples.",
			"    - To indicate that samples should be pooled, wrap the corresponding input samples in additional curly brackets, as shown in the examples below, e.g. {{s1,s2},{s3,s4}}.",
			"    - Providing samples or container vessels in a flat list indicates that each sample should be measured individually and not be pooled.",
			"    - Providing samples in a plate indicates that each sample in the plate should be measured individually ({myPlate}). If you wish to pool all samples in the plate, wrap the plate in additional list, e.g. {{myPlate}}.",
			"    - There is no upper limit as to how many samples can be pooled for this experiment, provided that the total volume of the samples plus buffer(s) is less than or equal to the MaxVolume of Model[Container, Plate, \"96-well 500uL Round Bottom DSC Plate\"].",
			"Prior to the aliquotting of sample(s) and buffer(s) into the plate, the individual samples can be subjected to Incubation, Centrifugation, and Filtering using the shared SamplePreparation framework. Default options and option resolutions apply.",
			"    - Sample preparation options for the input samples can be provided by singletons, values index-matched to the number of pools, or via a nested list matching the SamplesIn.",
			"The aliquotting / pooling of sample(s) and buffer(s) into the plate is performed using the shared Aliquot SamplePreparation framework. All options and default option resolution apply, some of which are listed here for clarity.",
			"    - If NONE of AssayVolume, AliquotAmount, and TargetConcentration are specified, the experiment function assumes that no dilution is desired and the samples will be pooled into the plate without addition of buffer.",
			"    - If AssayBuffer is not provided, but required because AssayVolume or TargetConcentration dictate it, it will automatically be set to Model[Sample, \"Milli-Q water\"].",
			"    - The plate in which the sample(s) should be measured can be provided via the option AliquotContainer. If AliquotContainer is not specified, and a transfer into a plate is needed, it will automatically be set to Model[Container, Plate, \"96-well 500uL Round Bottom DSC Plate\"].",
			"The pooled sample inside the plate can be subjected to additional mixing and incubation, if desired, via the NestedIndexMatchingMix -> True and NestedIndexMatchingIncubate -> True bool options, plus their affiliated parameters.",
			"    - Mixing of the plate: If pooling of sample(s) and buffer occurred, mixing of the pool inside the plate defaults to True. Mixing is performed by vortexing and controlled by the PooledMixRate option.",
			"    - Incubation of the plate: Incubation of the sample/pool inside the plate will not be set to True unless indicated by the user."
		},
		SeeAlso -> {
			"ValidExperimentDifferentialScanningCalorimetryQ",
			"ExperimentDifferentialScanningCalorimetryOptions"
		},
		Author -> {"malav.desai", "waseem.vali", "lei.tian", "boris.brenerman", "cgullekson", "steven"}
	}
];



(* ::Subsubsection:: *)
(*ExperimentDifferentialScanningCalorimetryOptions*)


DefineUsage[ExperimentDifferentialScanningCalorimetryOptions,
	{

		BasicDefinitions -> {
			{
				Definition->{"ExperimentDifferentialScanningCalorimetryOptions[Samples]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentDifferentialScanningCalorimetry when it is called on 'Samples'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples which will be heated to determine thermodynamic properties. If provided as a list of lists, each group of samples or containers within a single list are combined before the experiment is run.",
							Widget->Alternatives[
								"Sample or Container" -> Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
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
							Expandable->False,
							NestedIndexMatching->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"Resolved options when ExperimentDifferentialScanningCalorimetry is called on the input objects.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"This function returns the resolved options that would be fed to ExperimentDifferentialScanningCalorimetry if it were called on these input objects."
		},
		SeeAlso -> {
			"ExperimentDifferentialScanningCalorimetry",
			"ValidExperimentDifferentialScanningCalorimetryQ"
		},
		Author -> {"malav.desai", "waseem.vali", "lei.tian", "boris.brenerman", "cgullekson", "steven"}
	}];


DefineUsage[ExperimentDifferentialScanningCalorimetryPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentDifferentialScanningCalorimetryPreview[Samples]", "Preview"},
				Description -> "returns the graphical preview for ExperimentDifferentialScanningCalorimetry when it is called on 'Samples'.  This output is always Null.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples which will be heated to determine thermodynamic properties. If provided as a list of lists, each group of samples or containers within a single list are combined before the experiment is run.",
							Widget->Alternatives[
								"Sample or Container" -> Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
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
							Expandable->False,
							NestedIndexMatching->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "Graphical preview representing the output of ExperimentDifferentialScanningCalorimetry.  This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentDifferentialScanningCalorimetry",
			"ValidExperimentDifferentialScanningCalorimetryQ"
		},
		Author -> {"malav.desai", "waseem.vali", "ryan.bisbey", "boris.brenerman", "cgullekson", "steven"}
	}
];


(* ::Subsubsection:: *)
(*ValidExperimentDifferentialScanningCalorimetryQ*)


DefineUsage[ValidExperimentDifferentialScanningCalorimetryQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentDifferentialScanningCalorimetryQ[Samples]", "Booleans"},
				Description -> "checks whether the provided 'Samples' and specified options are valid for calling ExperimentDifferentialScanningCalorimetry.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples which will be heated to determine thermodynamic properties. If provided as a list of lists, each group of samples or containers within a single list are combined before the experiment is run.",
							Widget->Alternatives[
								"Sample or Container" -> Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
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
							Expandable->False,
							NestedIndexMatching->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Booleans",
						Description -> "Whether or not the ExperimentDifferentialScanningCalorimetry call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentDifferentialScanningCalorimetry",
			"ExperimentDifferentialScanningCalorimetryOptions"
		},
		Author -> {"malav.desai", "waseem.vali", "ryan.bisbey", "boris.brenerman", "steven"}
	}
];