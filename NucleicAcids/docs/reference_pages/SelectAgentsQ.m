(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: tharr *)
(* :Date: 2023-04-19 *)


DefineUsage[SelectAgentsQ,
  {
    BasicDefinitions -> {
      {"SelectAgentsQ[DNAStrand]", "Boolean", "determines if the sequence encoded by 'DNAStrand' maps to a hazardous nucleic acid or protein in the Select Agents list provided by the HHS."},
      {"SelectAgentsQ[PeptideStrand]", "Boolean", "determines if the sequence encoded by 'PeptideStrand' maps to a hazardous nucleic acid or protein in the Select Agents list provided by the HHS."}
    },
    MoreInformation -> {
      "The list of Select Agents and Toxins that are monitored by the US government is at the following URL: https://www.selectagents.gov/sat/list.htm#ftn6"
    },
    Input :> {
      {"DNAStrand", _?DNAQ, "The input DNA sequence that must be checked whether it maps to a select agent. This is usually the predicted output of ExperimentDNASynthesis."},
      {"PeptideStrand", _?PeptideQ, "The input peptide sequence that must be checked whether it maps to a select agent. This is usually the predicted output of ExperimentPeptideSynthesis."}
    },
    Output :> {
      {"Boolean", (True | False), "Output that specifies if the input sequence is on the select agents and toxins list."}
    },
    SeeAlso -> {
      "ExperimentDNASynthesis",
      "ExperimentPeptideSynthesis"
    },
    Author -> {"tommy.harrelson"}
  }
];