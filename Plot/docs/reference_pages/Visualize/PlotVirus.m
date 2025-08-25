(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotVirus*)


DefineUsage[PlotVirus,
	{
		BasicDefinitions -> {
			{
				Definition->{"PlotVirus[virus]","plot"},
				Description->"provides a visualization of any stored image of the 'virus', usually an electron microscope image, for a model 'virus'.",
				Inputs:>{
					{
						InputName->"virus",
						Description->"A Model[Sample] which contains the Virus model to visualize.",
						Widget->If[
							TrueQ[$ObjectSelectorWorkaround],
							Alternatives[
								"Enter object:"->Widget[Type->Expression,Pattern:>ObjectP[Model[Sample]],Size->Line],
								"Select object:"->Widget[Type->Object,Pattern:>ObjectP[Model[Sample]],ObjectTypes->{Model[Sample]}]
							],
							Widget[Type->Object,Pattern:>ObjectP[Model[Sample]],ObjectTypes->{Model[Sample]}]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"Visualization of the image stored for the virus model.",
						Pattern:>ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso -> {
			"PlotImage",
			"PlotCloudFile",
			"PlotObject",
			"PlotProtein"
		},
		Author -> {"dirk.schild", "amir.saadat", "brad"},
		Preview->True
	}
];