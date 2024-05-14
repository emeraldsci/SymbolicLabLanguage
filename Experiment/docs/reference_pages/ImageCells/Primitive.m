(* ::Package:: *)


(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*resolveTransferLiquidHandlingPrimitive*)


DefineUsage[resolveAcquireImagePrimitive,
	{
		BasicDefinitions->{
			{
				Definition->{"resolveAcquireImagePrimitive[Samples]","resolvedPrimitives"},
				Description->"based on the given 'Samples' and options, generates 'resolvedPrimitives' that will be used to acquire microscopic images from 'Samples'.",
				Inputs:>{
					{
						InputName->"Samples",
						Description->"The sample(s) to be imaged.",
						Widget->Alternatives[
							Widget[Type->Object,Pattern:>ObjectP[Object[Sample]]],
							Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Sample]]]]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"resolvedPrimitives",
						Description->"The resolved AcquireImage primitives containing information used to acquire a microscopic image from the samples.",
						Pattern:>{AcquireImagePrimitiveP..}
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentImageCells",
			"resolveExperimentImageCellsOptions",
			"ImageCells"
		},
		Author->{"melanie.reschke", "yanzhe.zhu", "varoth.lilascharoen", "cgullekson"}
	}
];