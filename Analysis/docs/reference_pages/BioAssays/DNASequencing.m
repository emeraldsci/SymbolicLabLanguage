(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)



(* ::Subsection:: *)
(*AnalyzeDNASequencing*)

DefineUsage[AnalyzeDNASequencing,
  {
    BasicDefinitions -> {
      {
        Definition -> {"AnalyzeDNASequencing[sequencingData]", "sequence"},
        Description -> "conducts base-calling analysis to assign a DNA 'sequence' to the electropherogram peaks in 'sequencingData'.",
        Inputs :> {
          {
            InputName -> "sequencingData",
            Description -> "DNASequencing data containing four-channel electropherograms to conduct base-calling analysis on.",
            Widget -> Widget[Type->Object,Pattern:>ObjectP[Object[Data,DNASequencing]]]
          }
        },
        Outputs :> {
          {
            OutputName -> "sequence",
            Description -> "The identified DNA sequence, as well as quality values and/or base probabilities for each predicted nucleobase.",
            Pattern :> ObjectP[Object[Analysis,DNASequencing]]
          }
        }
      },
      {
        Definition -> {"AnalyzeDNASequencing[sequencingProtocol]", "sequences"},
        Description -> "conducts base-calling analysis to assign DNA 'sequences' to all sequencing data present in 'sequencingProtocol'.",
        Inputs :> {
          {
            InputName -> "sequencingProtocol",
            Description -> "A DNASequencing protocol containing one or more DNASequencing data objects.",
            Widget -> Widget[Type->Object,Pattern:>ObjectP[Object[Protocol,DNASequencing]]]
          }
        },
        Outputs :> {
          {
            OutputName -> "sequences",
            Description -> "Identified sequences, quality values, and/or base probabilities for each DNASequencing data object in 'protocol'.",
            Pattern :> {ObjectP[Object[Analysis,DNASequencing]]..}
          }
        }
      },
      {
        Definition -> {"AnalyzeDNASequencing[xyData]", "sequence"},
        Description -> "conducts base-calling analysis to assign a DNA 'sequence' to the raw electropherogram traces represented by 'xyData'.",
				CommandBuilder -> False,
        Inputs :> {
          {
            InputName -> "xyData",
            Description -> "Four sets of {x,y} data points corresponding to sequencing electropherogram traces of each DNA nucleobase, in the order A, C, T, G.",
            Widget -> {
							"A Trace"->Widget[Type->Expression,Pattern:>CoordinatesP|QuantityCoordinatesP[],Size->Paragraph],
							"C Trace"->Widget[Type->Expression,Pattern:>CoordinatesP|QuantityCoordinatesP[],Size->Paragraph],
							"G Trace"->Widget[Type->Expression,Pattern:>CoordinatesP|QuantityCoordinatesP[],Size->Paragraph],
							"T Trace"->Widget[Type->Expression,Pattern:>CoordinatesP|QuantityCoordinatesP[],Size->Paragraph]
						}
          }
        },
        Outputs :> {
          {
            OutputName -> "sequence",
            Description -> "The identified DNA sequence, as well as quality values and/or base probabilities for each predicted nucleobase.",
            Pattern :> ObjectP[Object[Analysis,DNASequencing]]
          }
        }
      }
  	},
		MoreInformation -> {
			"The Phred Method is an implementation of the base-calling algorithm of Ewing et al. described in Object[Report, Literature, \"id:N80DNj1P84VX\"]: B. Ewing et al. \"Base-Calling of Automated Sequencer Traces using Phred.\" Genome Research 8.3 (1998): 175-185.",
			"The Phred quality score Q = -10 Log10[P], where P is the probability of incorrect assignment. For example, 99% accuracy is equivalent to P = 0.01, or a quality score of Q = 20.",
      "A quality value of >20 is considered an accurate assignment, quality between 15-19 is considered mediocre accuracy, and a quality value below 15 is considered poor accuracy."
		},
    SeeAlso -> {
			"ExperimentDNASequencing",
			"PlotDNASequencing",
      "SequenceAlignmentTable"
    },
    Author -> {"taylor.hochuli", "kevin.hou", "nont.kosaisawe"},
    Preview->True
  }
];



(* ::Subsection:: *)
(*AnalyzeDNASequencing*)

DefineUsage[AnalyzeDNASequencingOptions,
  {
    BasicDefinitions -> {
      {
        Definition -> {"AnalyzeDNASequencingOptions[sequencingData]", "resolvedOptions"},
        Description -> "returns the resolved options for AnalyzeDNASequencing when it is called on 'sequencingData'.",
        Inputs :> {
          {
            InputName -> "sequencingData",
            Description -> "DNASequencing data containing four-channel electropherograms to conduct base-calling analysis on.",
            Widget -> Widget[Type->Object,Pattern:>ObjectP[Object[Data,DNASequencing]]]
          }
        },
        Outputs :> {
          {
            OutputName -> "resolvedOptions",
            Description -> "The resolved options when AnalyzeDNASequencing is called on the given inputs.",
            Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
          }
        }
      },
      {
        Definition -> {"AnalyzeDNASequencingOptions[protocol]", "resolvedOptions"},
        Description -> "returns the resolved options for AnalyzeDNASequencing when it is called on 'protocol'.",
        Inputs :> {
          {
            InputName -> "protocol",
            Description -> "A DNASequencing protocol containing one or more DNASequencing data objects.",
            Widget -> Widget[Type->Object,Pattern:>ObjectP[Object[Protocol,DNASequencing]]]
          }
        },
        Outputs :> {
          {
            OutputName -> "resolvedOptions",
            Description -> "The resolved options when AnalyzeDNASequencing is called on the given inputs.",
            Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
          }
        }
      },
      {
        Definition -> {"AnalyzeDNASequencingOptions[xyData]", "resolvedOptions"},
        Description -> "returns the resolved options for AnalyzeDNASequencing when it is called on 'xyData'.",
				CommandBuilder -> False,
        Inputs :> {
          {
            InputName -> "xyData",
            Description -> "Four sets of {x,y} data points corresponding to sequencing electropherogram traces of each DNA nucleobase, in the order A, C, T, G.",
            Widget -> {
							"A Trace"->Widget[Type->Expression,Pattern:>CoordinatesP|QuantityCoordinatesP[],Size->Paragraph],
							"C Trace"->Widget[Type->Expression,Pattern:>CoordinatesP|QuantityCoordinatesP[],Size->Paragraph],
							"G Trace"->Widget[Type->Expression,Pattern:>CoordinatesP|QuantityCoordinatesP[],Size->Paragraph],
							"T Trace"->Widget[Type->Expression,Pattern:>CoordinatesP|QuantityCoordinatesP[],Size->Paragraph]
						}
          }
        },
        Outputs :> {
          {
            OutputName -> "resolvedOptions",
            Description -> "The resolved options when AnalyzeDNASequencing is called on the given inputs.",
            Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
          }
        }
      }
  	},
    SeeAlso -> {
			"AnalyzeDNASequencing",
			"AnalyzeDNASequencingPreview",
			"ValidAnalyzeDNASequencingQ"
    },
    Author -> {"scicomp", "brad", "kevin.hou"}
  }
];



(* ::Subsection:: *)
(*AnalyzeDNASequencingPreview*)

DefineUsage[AnalyzeDNASequencingPreview,
  {
    BasicDefinitions -> {
      {
        Definition -> {"AnalyzeDNASequencingPreview[sequencingData]", "preview"},
        Description -> "returns a graphical 'preview' of the output of AnalyzeDNASequencing when it is called on 'sequencingData'.",
        Inputs :> {
          {
            InputName -> "sequencingData",
            Description -> "DNASequencing data containing four-channel electropherograms to conduct base-calling analysis on.",
            Widget -> Widget[Type->Object,Pattern:>ObjectP[Object[Data,DNASequencing]]]
          }
        },
        Outputs :> {
          {
            OutputName -> "preview",
            Description -> "The graphical preview representing the output of AnalyzeDNASequencing.",
            Pattern :> ValidGraphicsP[]
          }
        }
      },
      {
        Definition -> {"AnalyzeDNASequencingPreview[protocol]", "preview"},
        Description -> "returns a graphical 'preview' of the output of AnalyzeDNASequencing when it is called on 'protocol'.",
        Inputs :> {
          {
            InputName -> "protocol",
            Description -> "A DNASequencing protocol containing one or more DNASequencing data objects.",
            Widget -> Widget[Type->Object,Pattern:>ObjectP[Object[Protocol,DNASequencing]]]
          }
        },
        Outputs :> {
          {
            OutputName -> "preview",
            Description -> "The graphical preview representing the output of AnalyzeDNASequencing.",
            Pattern :> ValidGraphicsP[]
          }
        }
      },
      {
        Definition -> {"AnalyzeDNASequencingPreview[xyData]", "preview"},
        Description -> "returns a graphical 'preview' of the output of AnalyzeDNASequencing when it is called on 'xyData'.",
				CommandBuilder -> False,
        Inputs :> {
          {
            InputName -> "xyData",
            Description -> "Four sets of {x,y} data points corresponding to sequencing electropherogram traces of each DNA nucleobase, in the order A, C, T, G.",
            Widget -> {
							"A Trace"->Widget[Type->Expression,Pattern:>CoordinatesP|QuantityCoordinatesP[],Size->Paragraph],
							"C Trace"->Widget[Type->Expression,Pattern:>CoordinatesP|QuantityCoordinatesP[],Size->Paragraph],
							"G Trace"->Widget[Type->Expression,Pattern:>CoordinatesP|QuantityCoordinatesP[],Size->Paragraph],
							"T Trace"->Widget[Type->Expression,Pattern:>CoordinatesP|QuantityCoordinatesP[],Size->Paragraph]
						}
          }
        },
        Outputs :> {
          {
            OutputName -> "preview",
            Description -> "The graphical preview representing the output of AnalyzeDNASequencing.",
            Pattern :> ValidGraphicsP[]
          }
        }
      }
  	},
    SeeAlso -> {
			"AnalyzeDNASequencing",
			"AnalyzeDNASequencingOptions",
			"ValidAnalyzeDNASequencingQ"
    },
    Author -> {"scicomp", "brad", "kevin.hou"}
  }
];



(* ::Subsection:: *)
(*ValidAnalyzeDNASequencingQ*)

DefineUsage[ValidAnalyzeDNASequencingQ,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ValidAnalyzeDNASequencingQ[sequencingData]", "boolean"},
        Description -> "checks whether 'sequencingData' and any specified options are valid inputs to AnalyzeDNASequencing.",
        Inputs :> {
          {
            InputName -> "sequencingData",
            Description -> "DNASequencing data containing four-channel electropherograms to conduct base-calling analysis on.",
            Widget -> Widget[Type->Object,Pattern:>ObjectP[Object[Data,DNASequencing]]]
          }
        },
        Outputs :> {
          {
            OutputName -> "boolean",
            Description -> "A value indicating whether the AnalyzeDNASequencing call is valid. The return value can be changed with the OutputFormat option.",
            Pattern :> _EmeraldTestSummary|BooleanP
          }
        }
      },
      {
        Definition -> {"ValidAnalyzeDNASequencingQ[protocol]", "boolean"},
        Description -> "checks whether 'protocol' and any specified options are valid inputs to AnalyzeDNASequencing.",
        Inputs :> {
          {
            InputName -> "protocol",
            Description -> "A DNASequencing protocol containing one or more DNASequencing data objects.",
            Widget -> Widget[Type->Object,Pattern:>ObjectP[Object[Protocol,DNASequencing]]]
          }
        },
        Outputs :> {
          {
            OutputName -> "boolean",
            Description -> "A value indicating whether the AnalyzeDNASequencing call is valid. The return value can be changed with the OutputFormat option.",
            Pattern :> _EmeraldTestSummary|BooleanP
          }
        }
      },
      {
        Definition -> {"ValidAnalyzeDNASequencingQ[xyData]", "boolean"},
        Description -> "checks whether 'xyData' and any specified options are valid inputs to AnalyzeDNASequencing.",
				CommandBuilder -> False,
        Inputs :> {
          {
            InputName -> "xyData",
            Description -> "Four sets of {x,y} data points corresponding to sequencing electropherogram traces of each DNA nucleobase, in the order A, C, T, G.",
            Widget -> {
							"A Trace"->Widget[Type->Expression,Pattern:>CoordinatesP|QuantityCoordinatesP[],Size->Paragraph],
							"C Trace"->Widget[Type->Expression,Pattern:>CoordinatesP|QuantityCoordinatesP[],Size->Paragraph],
							"G Trace"->Widget[Type->Expression,Pattern:>CoordinatesP|QuantityCoordinatesP[],Size->Paragraph],
							"T Trace"->Widget[Type->Expression,Pattern:>CoordinatesP|QuantityCoordinatesP[],Size->Paragraph]
						}
          }
        },
        Outputs :> {
          {
            OutputName -> "boolean",
            Description -> "A value indicating whether the AnalyzeDNASequencing call is valid. The return value can be changed with the OutputFormat option.",
            Pattern :> _EmeraldTestSummary|BooleanP
          }
        }
      }
  	},
    SeeAlso -> {
			"AnalyzeDNASequencing",
			"AnalyzeDNASequencingOptions",
			"AnalyzeDNASequencingPreview"
    },
    Author -> {"scicomp", "brad", "kevin.hou"}
  }
];