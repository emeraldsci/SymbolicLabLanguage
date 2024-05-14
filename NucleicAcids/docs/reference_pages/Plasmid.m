(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*Glycan*)
DefineUsage[PlotPlasmid,
  {
    BasicDefinitions -> {
      {"PlotPlasmid[GenBankFile]", "Plot", "generates a plasmid map showing the locations features contained in 'GenBankFile'."}
    },
    Input :> {
      {"GenBankFile", _String|ObjectP[Object[EmeraldCloudFile]], "The 'GenBankFile' representing a plasmid. This may be either a path to a local file or an EmeraldCloudFile object."}
    },
    Output :> {
      {"Plot", ValidGraphicsP[], "The graphic of the plasmid map."}
    },
    SeeAlso -> {
      "Plot"
    },
    Author -> {
      "brian.day"
    }
  }
];
