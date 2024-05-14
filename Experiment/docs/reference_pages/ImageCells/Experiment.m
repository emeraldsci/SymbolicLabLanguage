(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*Imaging Primitive*)


DefineUsage[AcquireImage,
	{
		BasicDefinitions->{
			{"AcquireImage[Mode]","primitive","generate an ExperimentImageCells-compatible 'primitive' that describes a set of parameters used to acquire an image of a sample."}
		},
		Input:>{
			{
				"Mode",
				MicroscopeModeP,
				"The type of microscopy technique used to acquire an image of a sample. BrightField is the simplest type of microscopy technique that uses white light to illuminate the sample, resulting in an image in which the specimen is darker than the surrounding areas that are devoid of it. Bright-field microscopy is useful for imaging samples stained with dyes or samples with intrinsic colors. PhaseContrast microscopy increases the contrast between the sample and its background, allowing it to produce highly detailed images from living cells and transparent biological samples. Epifluorescence microscopy uses light at a specific wavelength range to excite a fluorophore of interest in the sample and capture the resulting emitted fluorescence to generate an image. ConfocalFluorescence microscopy employs a similar principle as Epifluorescence to illuminate the sample and capture the emitted fluorescence along with pinholes in the light path to block out-of-focus light in order to increase optical resolution. Confocal microscopy is often used to image thick samples or to clearly distinguish structures that vary in height along the z-axis."
			}
		},
		Output:>{
			{
				"primitive",
				_AcquireImage,
				"A primitive containing information used to acquire an image from a sample."
			}
		},
		Sync->Automatic,
		SeeAlso->{
			"ExperimentImageCells",
			 "ImageCells"
		},
		Author->{"melanie.reschke", "yanzhe.zhu"}
	}
];


(* ::Subsubsection:: *)
(*ExperimentImageCells*)


DefineUsage[ExperimentImageCells,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentImageCells[Samples]","Protocol"},
				Description->"generates a 'Protocol' for imaging the provided 'Samples' using a widefield microscope or a high content imager. Samples may be imaged in bright-field, phase contrast, epifluorescence, or confocal fluorescence mode.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The sample(s) to be imaged.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
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
						Description->"A protocol object or packet that will be used to acquire images(s) of the provided 'Samples'.",
						Pattern:>ListableP[ObjectP[Object[Protocol,ImageCells]]]
					}
				}
			}
		},
		MoreInformation->{
			"Black-walled plates are preferred to minimize background, container autofluorescence, and crosstalk between closely-spaced wells."
		},
		SeeAlso->{
			"ValidExperimentImageCellsQ",
			"ExperimentImageCellsOptions",
			"ExperimentImageCellsPreview",
			"ImageCells"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"melanie.reschke", "yanzhe.zhu", "varoth.lilascharoen", "cgullekson"}
	}
];