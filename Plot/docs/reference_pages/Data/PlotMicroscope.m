(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotMicroscope*)


DefineUsage[PlotMicroscope,{
	BasicDefinitions->{
		{
			Definition->{"PlotMicroscope[imageObject]","plot"},
			Description->"creates a graphical display of the images associated with the provided 'imageObject'.",
			Inputs:>{
				{
					InputName->"imageObject",
					Description->"The Object[Data,Microscope] object to be plotted.",
					Widget->If[
						TrueQ[$ObjectSelectorWorkaround],
						Alternatives[
							"Enter object(s):"->Widget[Type->Expression,Pattern:>ListableP[ObjectP[Object[Data,Microscope]]],Size->Line],
							"Select object(s):"->Adder@Widget[Type->Object,Pattern:>ObjectP[Object[Data,Microscope]],ObjectTypes->{Object[Data,Microscope]}]
						],
						Alternatives[
							"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Data,Microscope]],ObjectTypes->{Object[Data,Microscope]}],
							"Multiple Objects"->Adder@Widget[Type->Object,Pattern:>ObjectP[Object[Data,Microscope]],ObjectTypes->{Object[Data,Microscope]}]
						]
					]
				}
			},
			Outputs:>{
				{
					OutputName->"plot",
					Description->"A graphical display of the provided 'imageObject'.",
					Pattern:>_Graphics
				}
			}
		},
		{
			Definition->{"PlotMicroscope[cellModels]","plot"},
			Description->"creates a graphical display of the images associated with the provided 'cellModels'.",

			Inputs:>{
				{
					InputName->"cellModels",
					Description->"The Model[Sample] that has Microscope images in its ReferenceImages field to be plotted.",
					Widget->If[
						TrueQ[$ObjectSelectorWorkaround],
						Alternatives[
							"Enter model(s):"->Widget[Type->Expression,Pattern:>ListableP[ObjectP[Model[Sample]]],Size->Line],
							"Select model(s):"->Adder@Widget[Type->Object,Pattern:>ObjectP[Model[Sample]],ObjectTypes->{Model[Sample]}]
						],
						Alternatives[
							"Single Model"->Widget[Type->Object,Pattern:>ObjectP[Model[Sample]],ObjectTypes->{Model[Sample]}],
							"Multiple Models"->Adder@Widget[Type->Object,Pattern:>ObjectP[Model[Sample]],ObjectTypes->{Model[Sample]}]
						]
					]
				}
			},
			Outputs:>{
				{
					OutputName->"plot",
					Description->"A graphical display of the provided 'cellModels'.",
					Pattern:>_Graphics
				}
			}
		},
		{
			Definition->{"PlotMicroscope[cellObjects]","plot"},
			Description->"creates a graphical display of the images associated with the provided 'cellObjects'.",

			Inputs:>{
				{
					InputName->"cellObjects",
					Description->"The Model[Sample] that has Microscope images in its ReferenceImages field to be plotted.",
					Widget->If[
						TrueQ[$ObjectSelectorWorkaround],
						Alternatives[
							"Enter model(s):"->Widget[Type->Expression,Pattern:>ListableP[ObjectP[Object[Sample]]],Size->Line],
							"Select model(s):"->Adder@Widget[Type->Object,Pattern:>ObjectP[Object[Sample]],ObjectTypes->{Object[Sample]}]
						],
						Alternatives[
							"Single Model"->Widget[Type->Object,Pattern:>ObjectP[Object[Sample]],ObjectTypes->{Object[Sample]}],
							"Multiple Models"->Adder@Widget[Type->Object,Pattern:>ObjectP[Object[Sample]],ObjectTypes->{Object[Sample]}]
						]
					]					
				}
			},
			Outputs:>{
				{
					OutputName->"plot",
					Description->"A graphical display of the provided 'cellModels'.",
					Pattern:>_Graphics
				}
			}
		}
	},
	SeeAlso -> {
		"PlotImage",
		"PlotObject",
		"cellCounts"
	},
	Author -> {"dirk.schild", "amir.saadat", "wyatt", "brad", "Catherine", "Sean", "Ruben", "derek.machalek"},
	Preview->True
}];