(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotTranscript*)


DefineUsage[PlotTranscript,
{
	BasicDefinitions->{
		{
			Definition->{"PlotTranscript[trans]","structure"},
			Description->"provides a visualization of any stored structures of model transcripts in the input object.",
			Inputs:>{
				{
					InputName->"trans",
					Description->"Transcript model you wish to visualize.",
					Widget->Alternatives[
						"Model[Molecule,Transcript]"->Widget[Type->Object,Pattern:>ObjectP[{Model[Molecule,Transcript]}]],
						"Model[Sample]"->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample]}]]
					]
				}
			},
			Outputs:>{
				{
					OutputName->"structure",
					Description->"Visualization of the structure of the transcript.",
					Pattern:>StructureP
				}
			}
		}
	},
	SeeAlso -> {
		"MotifForm",
		"PlotProtein"
	},
	Author -> {
		"kevin.hou",
		"brad"
	},
	Preview->True
}];
