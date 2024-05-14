(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotDistribution*)


DefineUsage[PlotDistribution,
	{
		BasicDefinitions->{
			{
				Definition->{"PlotDistribution[dist]","fig"},
				Description->"plots the PDF of the distribution 'dist' with statistics overlaid.",
				Inputs:>{
					{
					InputName->"dist",
					Description->"A parameterized distribution or numerical sample to plot.",
					Widget->Alternatives[
						"Numerical Sample"->Widget[Type->Expression,Pattern:>{UnitsP[]..}|_?QuantityArrayQ,Size->Line],
						"Parameterized Distribution"->Widget[Type->Expression, Pattern:>DistributionP[],Size->Line]
					]
					}
				},
				Outputs:>{
					{
					OutputName->"fig",
					Description->"A plot of the distribution.",
					Pattern:>ValidGraphicsP[]
					}
				}
			},
			{
				Definition->{"PlotDistribution[fitObject]","paramFig"},
				Description->"plots the best-fit distribution of each fitted parameter in 'fitObject'.",
				Inputs:>{
					{
					InputName->"fitObject",
					Description->"An Object[Analysis,Fit] reference containing fitted parameters to plot.",
					Widget->If[
						TrueQ[$ObjectSelectorWorkaround],
						Alternatives[
							"Enter object:"->Widget[Type->Expression,Pattern:>ObjectP[Object[Analysis,Fit]],Size->Paragraph],
							"Select object:"->Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,Fit]],ObjectTypes->{Object[Analysis,Fit]}]
						],
						Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,Fit]],ObjectTypes->{Object[Analysis,Fit]}]
					]
					}
				},
				Outputs:>{
					{
					OutputName->"paramFig",
					Description->"A 1D or 2D plot of the best-fit parameter distribution.",
					Pattern:>{{_Symbol,_Symbol}->ValidGraphicsP[]}
					}
				}
			}
		},
		MoreInformation->{},
		SeeAlso->{"SinglePrediction","PlotPrediction","AnalyzeFit"},
		Author->{
			"sebastian.bernasek",
			"brad",
			"thomas",
			"alice",
			"qian"
		},
		Preview->True
	}
];


(* ::Section:: *)
(*PlotDistributionPreview*)

DefineUsage[PlotDistributionPreview,
	{
		BasicDefinitions->{
			{
				Definition->{"PlotDistributionPreview[dist]","fig"},
				Description->"Provides a preview on the PDF of the distribution 'dist' with statistics overlaid.",
				Inputs:>{
					{
					InputName->"dist",
					Description->"A parameterized distribution or numerical sample to plot.",
					Widget->Alternatives[
						"Numerical Sample"->Widget[Type->Expression,Pattern:>{UnitsP[]..}|_?QuantityArrayQ,Size->Line],
						"Parameterized Distribution"->Widget[Type->Expression, Pattern:>DistributionP[],Size->Line]
					]
					}
				},
				Outputs:>{
					{
					OutputName->"fig",
					Description->"A plot of the distribution.",
					Pattern:>ValidGraphicsP[]
					}
				}
			},

			{
				Definition->{"PlotDistributionPreview[fitObject]","paramFig"},
				Description->"previews the best-fit distribution of each fitted parameter in 'fitObject'.",
				Inputs:>{
					{
					InputName->"fitObject",
					Description->"An Object[Analysis,Fit] reference containing fitted parameters to plot.",
					Widget->If[
						TrueQ[$ObjectSelectorWorkaround],
						Alternatives[
							"Enter object:"->Widget[Type->Expression,Pattern:>ObjectP[Object[Analysis,Fit]],Size->Paragraph],
							"Select object:"->Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,Fit]],ObjectTypes->{Object[Analysis,Fit]}]
						],
						Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,Fit]],ObjectTypes->{Object[Analysis,Fit]}]
					]
					}
				},
				Outputs:>{
					{
					OutputName->"paramFig",
					Description->"A 1D or 2D plot of the best-fit parameter distribution.",
					Pattern:>{{_Symbol,_Symbol}->ValidGraphicsP[]}
					}
				}
			}

		},
		MoreInformation->{},
		SeeAlso->{"PlotDistribution","PlotPrediction","AnalyzeFit"},
		Author->{
			"sebastian.bernasek",
			"brad",
			"thomas",
			"alice",
			"qian"
		},
		Preview->True
	}
];


(* ::Section:: *)
(*PlotDistributionOptions*)

DefineUsage[PlotDistributionOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"PlotDistributionOptions[dist]","list"},
				Description->"Provides a list of options used to generate the PDF plot of the distribution 'dist'.",
				Inputs:>{
					{
					InputName->"dist",
					Description->"A parameterized distribution or numerical sample to plot.",
					Widget->Alternatives[
						"Numerical Sample"->Widget[Type->Expression,Pattern:>{UnitsP[]..}|_?QuantityArrayQ,Size->Line],
						"Parameterized Distribution"->Widget[Type->Expression, Pattern:>DistributionP[],Size->Line]
					]
					}
				},
				Outputs:>{
					{
					OutputName->"list",
					Description->"A list of options used to plot the distribution.",
					Pattern:>_?ListQ
					}
				}
			},

			{
				Definition->{"PlotDistributionOptions[fitObject]","list"},
				Description->"Gives options used to generate the best-fit distribution of each fitted parameter in 'fitObject'.",
				Inputs:>{
					{
					InputName->"fitObject",
					Description->"An Object[Analysis,Fit] reference containing fitted parameters to plot.",
					Widget->If[
						TrueQ[$ObjectSelectorWorkaround],
						Alternatives[
							"Enter object:"->Widget[Type->Expression,Pattern:>ObjectP[Object[Analysis,Fit]],Size->Paragraph],
							"Select object:"->Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,Fit]],ObjectTypes->{Object[Analysis,Fit]}]
						],
						Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,Fit]],ObjectTypes->{Object[Analysis,Fit]}]
					]
					}
				},
				Outputs:>{
					{
					OutputName->"list",
					Description->"A list of options used to generate 1D or 2D plot of the best-fit parameter distribution.",
					Pattern:>_?ListQ
					}
				}
			}

		},
		MoreInformation->{},
		SeeAlso->{"PlotDistribution","PlotDistributionPreview","PlotPrediction","AnalyzeFit"},
		Author->{
			"sebastian.bernasek",
			"brad",
			"thomas",
			"alice",
			"qian"
		},
		Preview->True
	}
];
