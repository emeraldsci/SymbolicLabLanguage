(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*Glycan*)
DefineUsage[Glycan,
  {
    BasicDefinitions -> {
      {"Glycan[glycanAbbreviation]", "glycan", "represents a single glycan subunit, defined as a carbohydrate modification to a protein/peptide sequence."}
    },
    Input :> {
      {"glycanAbbreviation", _String, "The name of the glycan as an abbreviation (e.g. to make a Mannose glycan, use \"Man\" as an input)."}
    },
    Output :> {
      {"glycan", _Clump, "The pictographic representation of the glycan, along with relevant meta-data contained within its underlying properties."}
    },
    SeeAlso -> {
      "AvailableGlycans",
      "GlycanSequence",
      "GlycanStructure"
    },
    Author -> {
      "tommy.harrelson"
    }
  }
];


(* ::Subsection:: *)
(*GlycanSequence*)
DefineUsage[GlycanSequence,
  {
    BasicDefinitions -> {
      {"GlycanSequence[sequenceString]", "glycanSequence", "represents a linear sequence of glycan subunits."}
    },
    Input :> {
      {"sequenceString", _String, "The string representation of the sequence of glycans in which the subunits are written in standard abbreviations separated by dashes (e.g. \"Man-Glc-Gal\" is a sequence of Mannose-Glucose-Galactose glycans)."}
    },
    Output :> {
      {"glycanSequence", _Clump, "The pictographic representation of the glycan sequence, along with relevant meta-data contained within its underlying properties."}
    },
    SeeAlso -> {
      "Glycan",
      "AvailableGlycans",
      "GlycanStructure"
    },
    Author -> {
      "tommy.harrelson"
    }
  }
];


(* ::Subsection:: *)
(*GlycanStructure*)
DefineUsage[GlycanStructure,
  {
    BasicDefinitions -> {
      {"GlycanStructure[sequences, bonds]", "glycanStructure", "represents a branched stucture comprised of linear sequences of glycan subunits."}
    },
    Input :> {
      {"sequences", {_Clump..}, "A list of glycan sequences that comprise the structure."},
      {"bonds", {Rule[_Integer, _Integer]..}, "A list of rules between integers that represent the sequence indices that are bonded to each other."}
    },
    Output :> {
      {"glycanStructure", _Clump, "The pictographic representation of the branched glycan structure, along with relevant meta-data contained within its underlying properties."}
    },
    SeeAlso -> {
      "Glycan",
      "AvailableGlycans",
      "GlycanSequence"
    },
    Author -> {
      "tommy.harrelson"
    }
  }
];


(* GlycanQ *)
DefineUsage[GlycanQ,
  {
    BasicDefinitions -> {
      {"GlycanQ[glycan]", "Bool", "checks whether the input 'glycan' is a valid structure."}
    },
    Input :> {
      {"glycan", _Clump, "The structure containing the glycan information."}
    },
    Output :> {
      {"bool", (True|False), "The Boolean output describing the validity of the input glycan."}
    },
    SeeAlso -> {
      "AvailableGlycans",
      "GlycanSequenceQ",
      "GlycanStructureQ"
    },
    Author -> {
      "tommy.harrelson"
    }
  }
];


(* GlycanSequenceQ *)
DefineUsage[GlycanSequenceQ,
  {
    BasicDefinitions -> {
      {"GlycanSequenceQ[glycanSequence]", "Bool", "checks whether the input 'glycanSequence' is a valid structure."}
    },
    Input :> {
      {"glycanSequence", _Clump, "The structure containing the glycan sequence information."}
    },
    Output :> {
      {"bool", (True|False), "The Boolean output describing the validity of the input glycan."}
    },
    SeeAlso -> {
      "AvailableGlycans",
      "GlycanQ",
      "GlycanStructureQ"
    },
    Author -> {
      "tommy.harrelson"
    }
  }
];


(* GlycanStructureQ *)
DefineUsage[GlycanStructureQ,
  {
    BasicDefinitions -> {
      {"GlycanStructureQ[glycanStructure]", "Bool", "checks whether the input 'glycanStructure' is a valid structure."}
    },
    Input :> {
      {"glycanStructure", _Clump, "The structure containing the glycan branched structure information."}
    },
    Output :> {
      {"bool", (True|False), "The Boolean output describing the validity of the input glycan."}
    },
    SeeAlso -> {
      "AvailableGlycans",
      "GlycanQ",
      "GlycanSequenceQ"
    },
    Author -> {
      "tommy.harrelson"
    }
  }
];


(* AvailableGlycans *)
DefineUsage[AvailableGlycans,
  {
    BasicDefinitions -> {
      {"AvailableGlycans[]", "glycanList", "returns the list of supported glycans that can be used in the Glycan/GlycanSequence/GlycanStructure functions."}
    },
    Input :> {
    },
    Output :> {
      {"glycanList", {_String..}, "The list of supported glycans represented as abbreviations."}
    },
    SeeAlso -> {
      "Glycan",
      "GlycanSequence",
      "GlycanStructure"
    },
    Author -> {
      "tommy.harrelson"
    }
  }
];
