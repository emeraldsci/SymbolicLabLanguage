(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotCellCount*)


DefineUsage[PlotCellCount,
	{
		BasicDefinitions->{

			{
				Definition->{"PlotCellCount[cellCounts]","plot"},
				Description->"generates a graphical representation of the number of cells in 'cellCounts'.",
				Inputs:>{
					{
						InputName->"cellCounts",
						Description->"One or more Object[Analysis,CellCount] objects or a list of raw cell counts.",
						Widget->If[
							TrueQ[$ObjectSelectorWorkaround],
							Alternatives[
								"Enter object(s):"->Widget[Type->Expression,Pattern:>ListableP[_?NumericQ,2]|ListableP[ObjectP[Object[Analysis,CellCount]],2],Size->Paragraph],
								"Select object:"->Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,CellCount]],ObjectTypes->{Object[Analysis,CellCount]}],
								"Select multiple objects (BarChart):"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,CellCount]],ObjectTypes->{Object[Analysis,CellCount]}]]
							],
							Alternatives[
								"Cell Counts"->Widget[Type->Expression,Pattern:>ListableP[_?NumericQ,2]|ListableP[ObjectP[Object[Analysis,CellCount]],2],Size->Paragraph],
								"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,CellCount]],ObjectTypes->{Object[Analysis,CellCount]}],
								"Multiple Objects (BarChart):"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,CellCount]],ObjectTypes->{Object[Analysis,CellCount]}]]
							]							
						]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A graphical representation of 'cellCounts'.",
						Pattern:>ValidGraphicsP[]
					}
				}
			},

			{
				Definition->{"PlotCellCount[microscopeData]","plot"},
				Description->"generates a graphical representation of the number of cells in 'microscopeData'.",
				Inputs:>{
					{
						InputName->"microscopeData",
						Description->"The Object[Data,Microscope] object to be plotted.",
						Widget->If[
							TrueQ[$ObjectSelectorWorkaround],
							Alternatives[
								"Enter object(s):"->Widget[Type->Expression,Pattern:>ListableP[ObjectP[Object[Data,Microscope]],2],Size->Paragraph],
								"Select object(s):"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Data,Microscope]],ObjectTypes->{Object[Data,Microscope]}]]
							],
							Alternatives[
								"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Data,Microscope]],ObjectTypes->{Object[Data,Microscope]}],
								"Multiple Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Data,Microscope]],ObjectTypes->{Object[Data,Microscope]}]]
							]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A graphical representation of the number of cells in the input data.",
						Pattern:>ValidGraphicsP[]
					}
				}
			},

			{
				Definition->{"PlotCellCount[image, components]","plot"},
				Description->"generates a graphical representation of the number of cells in 'image'.",

				Inputs:>{
					{
						InputName->"image",
						Description->"An image from an Object[Data,Microscope].",
						Widget->Widget[Type->Expression,Pattern:>_?ImageQ,Size->Line]
					},
					{
						InputName->"components",
						Description->"Components from an image of cells.",
						Widget->Widget[Type->Expression,Pattern:>({{_Integer..}..})?MatrixQ,Size->Paragraph]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A graphical representation of the number of cells in the input data.",
						Pattern:>ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso -> {
			"PlotMicroscope",
			"CellCount"
		},
		Author -> {
			"sebastian.bernasek",
			"brad"
		},
		Preview->True
	}
];
