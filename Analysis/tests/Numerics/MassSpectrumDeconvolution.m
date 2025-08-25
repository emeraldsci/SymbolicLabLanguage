(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineTests[AnalyzeMassSpectrumDeconvolution,
  {
    (* --- Basic Tests --- *)
    Example[{Basic, "Run deconvolution analysis for a single Object[Data, MassSpectrometry]:"},
      AnalyzeMassSpectrumDeconvolution[Object[Data, MassSpectrometry, "id:rea9jla4N43O"], Upload->False],
      ObjectP[Object[Analysis, MassSpectrumDeconvolution]]
    ],
    Example[{Basic, "Run deconvolution analysis for a single Object[Data, ChromatographyMassSpectra]:"},
      AnalyzeMassSpectrumDeconvolution[Object[Data, ChromatographyMassSpectra, "id:J8AY5jAWBBpj"], Upload->False],
      ObjectP[Object[Analysis, MassSpectrumDeconvolution]]
    ],
    Example[{Basic, "Run deconvolution analysis for a single Object[Protocol, MassSpectrometry]:"},
      AnalyzeMassSpectrumDeconvolution[Object[Protocol, MassSpectrometry, "AMSD Test Object"], Upload->False],
      {ObjectP[Object[Analysis, MassSpectrumDeconvolution]]..},
      TimeConstraint -> 1800,
      Stubs :> {
        Download[{Object[Protocol, MassSpectrometry, "AMSD Test Object"]}, Data] =
            {{Object[Data, MassSpectrometry, "id:rea9jla4N43O"], Object[Data, MassSpectrometry, "id:rea9jla4N43O"]}}
      }
    ],
    Example[{Basic, "Run deconvolution analysis for a single Object[Protocol, LCMS]:"},
      AnalyzeMassSpectrumDeconvolution[Object[Protocol, LCMS, "AMSD Test Object"], Upload->False],
      {ObjectP[Object[Analysis, MassSpectrumDeconvolution]]..},
      TimeConstraint -> 1800,
      Stubs :> {
        Download[{Object[Protocol, LCMS, "AMSD Test Object"]}, Data] =
            {{Object[Data, ChromatographyMassSpectra, "id:J8AY5jAWBBpj"], Object[Data, ChromatographyMassSpectra, "id:J8AY5jAWBBpj"]}}
      }
    ],

    (* --- Options Tests --- *)
    (* Pre-processing Options *)
    Example[{Options, SmoothingWidth, "SmoothingWidth sets the standard deviation of a Gaussian noise filter that is used to denoise the data:"},
      AnalyzeMassSpectrumDeconvolution[Object[Data, MassSpectrometry, "id:rea9jla4N43O"], SmoothingWidth->Quantity[0.1, Dalton], Upload->False],
      ObjectP[Object[Analysis, MassSpectrumDeconvolution]]
    ],
    Example[{Options, IntensityThreshold, "IntensityThreshold sets the minimum intensity for a data point in the data set. Values below the threshold will be removed before deisotoping:"},
      AnalyzeMassSpectrumDeconvolution[Object[Data, MassSpectrometry, "id:rea9jla4N43O"], IntensityThreshold->Quantity[0.1, ArbitraryUnit], Upload->False],
      ObjectP[Object[Analysis, MassSpectrumDeconvolution]]
    ],

    (* Peak Clustering Options *)
    Example[{Options, IsotopicPeakTolerance, "IsotopicPeakTolerance sets the maximum allowed deviation from expected peak position:"},
      AnalyzeMassSpectrumDeconvolution[Object[Data, MassSpectrometry, "id:rea9jla4N43O"], IsotopicPeakTolerance->Quantity[0.05, Dalton], Upload->False],
      ObjectP[Object[Analysis, MassSpectrumDeconvolution]]
    ],
    Example[{Options, MinCharge, "MinCharge can be adjusted to examine only multiply charged fragments:"},
      AnalyzeMassSpectrumDeconvolution[Object[Data, MassSpectrometry, "id:rea9jla4N43O"], MinCharge->2, Upload->False][IsotopicClusterCharge],
      {GreaterEqualP[2, 1]...}
    ],
    Example[{Options, MaxCharge, "MaxCharge can be adjusted to examine only multiply charged fragments:"},
      AnalyzeMassSpectrumDeconvolution[Object[Data, MassSpectrometry, "id:rea9jla4N43O"], MaxCharge->4, Upload->False][IsotopicClusterCharge],
      {LessEqualP[4, 1]...}
    ],
    Example[{Options, MinIsotopicPeaks, "MinIsotopicPeaks can be adjusted to examine clusters with a large number of fragments:"},
      AnalyzeMassSpectrumDeconvolution[Object[Data, MassSpectrometry, "id:rea9jla4N43O"], MinIsotopicPeaks->10, Upload->False][IsotopicClusterPeaksCount],
      {GreaterEqualP[10, 1]...}
    ],
    Example[{Options, MaxIsotopicPeaks, "MaxIsotopicPeaks can be adjusted to examine clusters with a large number of isotopic peaks:"},
      AnalyzeMassSpectrumDeconvolution[Object[Data, MassSpectrometry, "id:rea9jla4N43O"], MaxIsotopicPeaks->10, Upload->False][IsotopicClusterPeaksCount],
      {LessEqualP[10, 1]...}
    ],
    Example[{Options, AveragineClustering, "AveragineClustering can be set to False, and isotopic clusters are determined only by the FragmentTolerance and IsotopicPeaksRange options:"},
      AnalyzeMassSpectrumDeconvolution[Object[Data, MassSpectrometry, "id:rea9jla4N43O"], AveragineClustering->False, Upload->False],
      ObjectP[Object[Analysis, MassSpectrumDeconvolution]]
    ],
    Example[{Options, StartIntensityCheck, "StartIntensityCheck can be increased to delay the intensity check performed when AveragineClustering is set to True:"},
      AnalyzeMassSpectrumDeconvolution[Object[Data, MassSpectrometry, "id:rea9jla4N43O"], StartIntensityCheck->3, Upload->False],
      ObjectP[Object[Analysis, MassSpectrumDeconvolution]]
    ],

    (* Post-processing Options *)
    Example[{Options, KeepOnlyDeisotoped, "KeepOnlyDeisotoped can be set to False to retain peak information for fragments without isotopic peaks:"},
      AnalyzeMassSpectrumDeconvolution[Object[Data, MassSpectrometry, "id:rea9jla4N43O"], KeepOnlyDeisotoped->False, Upload->False][IsotopicClusterPeaksCount],
      {GreaterEqualP[1, 1]...}
    ],
    Example[{Options, SumIntensity, "SumIntensity can be set to False, such that the intensity of the deisotoped peaks is the highest intensity peak in the isotopic cluster:"},
      AnalyzeMassSpectrumDeconvolution[Object[Data, MassSpectrometry, "id:rea9jla4N43O"], SumIntensity->False, Upload->False],
      ObjectP[Object[Analysis, MassSpectrumDeconvolution]]
    ],
    Example[{Options, ChargeDeconvolution, "ChargeDeconvolution can be set to True to shift the deisotoped peaks to their single-charged equivalent position:"},
      AnalyzeMassSpectrumDeconvolution[Object[Data, MassSpectrometry, "id:rea9jla4N43O"], ChargeDeconvolution->True, Upload->False],
      ObjectP[Object[Analysis, MassSpectrumDeconvolution]]
    ],


    (* --- Message Tests --- *)
    Example[{Messages, "OutputOption",
      "A message is thrown when Output includes both Result and Preview:"},
      AnalyzeMassSpectrumDeconvolution[Object[Data, MassSpectrometry, "id:rea9jla4N43O"], Output -> {Result, Preview}], $Failed,
      Messages :> {AnalyzeMassSpectrumDeconvolution::OutputOption}
    ],
    (* Stub HTTPRequest for speed, since messages are thrown before request. *)
    Example[{Messages, "FatalError", "A message is thrown when we cannot contact the server, or an error is returned:"},
      AnalyzeMassSpectrumDeconvolution[Object[Data, MassSpectrometry, "id:rea9jla4N43O"]],
      $Failed,
      Messages :> {AnalyzeMassSpectrumDeconvolution::FatalError},
      Stubs :> {
        HTTPRequestJSON[_] = HTTPError[None, "This is a bad request!"]
      }
    ],
    Example[{Messages, "ProtocolObject", "A warning is thrown when Protocol object inputs are used during a local evaluation:"},
      AnalyzeMassSpectrumDeconvolution[Object[Protocol, MassSpectrometry, "AMSD Test Object"], Upload->False],
      {ObjectP[Object[Analysis, MassSpectrumDeconvolution]]..},
      Messages :> {AnalyzeMassSpectrumDeconvolution::ProtocolObject},
      Stubs :> {
        (* Must stub the data download for the protocol overload too, since we stub the request. *)
        Download[{Object[Protocol, MassSpectrometry, "AMSD Test Object"]}, Data] = {{Object[Data, MassSpectrometry, "id:1"]}},
        Download[{Object[Data, MassSpectrometry, "id:1"]}, MzMLFile] = {" Pretend I'm a Cloud File :) "},
        ECL`$ManifoldRuntime = False,
        HTTPRequestJSON[_] = <|"0" -> {{
          "Object.Data.MassSpectrometry", "id:DataObject", "id:RawMzMLCloudFile", "id:CentroidMzMLCloudFile", "id:DeconvolutedMzMLCloudFile",
          (* Placeholder Data - RetentionTimes, MassToChargeRatios, Intensities, Charges, IsotopicPeaksCounts*)
          {{1,2,3}, {{1}, {2}, {3}}, {{1}, {2}, {3}}, {{1}, {2}, {3}}, {{1}, {2}, {3}}}
        }}|>
      }
    ],
    Test["Testing that options are correctly resolved with a protocol input:",
      AnalyzeMassSpectrumDeconvolution[Object[Protocol, MassSpectrometry, "AMSD Test Object"], SmoothingWidth -> 1.0 Gram / Mole, IntensityThreshold -> 2.4 ArbitraryUnit, Upload->False],
      {ObjectP[Object[Analysis, MassSpectrumDeconvolution]]..},
      Messages :> {AnalyzeMassSpectrumDeconvolution::ProtocolObject},
      Stubs :> {
        (* Must stub the data download for the protocol overload too, since we stub the request. *)
        Download[{Object[Protocol, MassSpectrometry, "AMSD Test Object"]}, Data] = {{Object[Data, MassSpectrometry, "id:1"]}},
        Download[{Object[Data, MassSpectrometry, "id:1"]}, MzMLFile] = {" Pretend I'm a Cloud File :) "},
        ECL`$ManifoldRuntime = False,
        HTTPRequestJSON[_] = <|"0" -> {{
          "Object.Data.MassSpectrometry", "id:DataObject", "id:RawMzMLCloudFile", "id:CentroidMzMLCloudFile", "id:DeconvolutedMzMLCloudFile",
          (* Placeholder Data - RetentionTimes, MassToChargeRatios, Intensities, Charges, IsotopicPeaksCounts*)
          {{1,2,3}, {{1}, {2}, {3}}, {{1}, {2}, {3}}, {{1}, {2}, {3}}, {{1}, {2}, {3}}}
        }}|>
      }
    ],
    Example[{Messages, "ChargeRange", "Message is thrown when ChargeRange option is not ordered:"},
      AnalyzeMassSpectrumDeconvolution[Object[Data, MassSpectrometry, "id:rea9jla4N43O"], MinCharge->10, MaxCharge->1, Upload->False],
      ObjectP[Object[Analysis, MassSpectrumDeconvolution]],
      Messages :> {AnalyzeMassSpectrumDeconvolution::ChargeRange},
      Stubs :> {
        HTTPRequestJSON[_] = <|"0" -> {{
          "Object.Data.MassSpectrometry", "id:DataObject", "id:RawMzMLCloudFile", "id:CentroidMzMLCloudFile", "id:DeconvolutedMzMLCloudFile",
          (* Placeholder Data - RetentionTimes, MassToChargeRatios, Intensities, Charges, IsotopicPeaksCounts*)
          {{1,2,3}, {{1}, {2}, {3}}, {{1}, {2}, {3}}, {{1}, {2}, {3}}, {{1}, {2}, {3}}}
        }}|>
      }
    ],
    Example[{Messages, "IsotopicPeaksRange", "A message is thrown when IsotopicPeaksRange option is not ordered:"},
      AnalyzeMassSpectrumDeconvolution[Object[Data, MassSpectrometry, "id:rea9jla4N43O"], MinIsotopicPeaks->20, MaxIsotopicPeaks->2, Upload->False],
      ObjectP[Object[Analysis, MassSpectrumDeconvolution]],
      Messages :> {AnalyzeMassSpectrumDeconvolution::IsotopicPeaksRange},
      Stubs :> {
        HTTPRequestJSON[_] = <|"0" -> {{
          "Object.Data.MassSpectrometry", "id:DataObject", "id:RawMzMLCloudFile", "id:CentroidMzMLCloudFile", "id:DeconvolutedMzMLCloudFile",
          (* Placeholder Data - RetentionTimes, MassToChargeRatios, Intensities, Charges, IsotopicPeaksCounts*)
          {{1,2,3}, {{1}, {2}, {3}}, {{1}, {2}, {3}}, {{1}, {2}, {3}}, {{1}, {2}, {3}}}
        }}|>
      }
    ],
    Example[{Messages, "StartIntensityCheck", "A message is thrown when StartIntensityCheck is specified along with DecreasingCheck->False:"},
      AnalyzeMassSpectrumDeconvolution[Object[Data, MassSpectrometry, "id:rea9jla4N43O"], StartIntensityCheck->3, AveragineClustering->False, Upload->False],
      ObjectP[Object[Analysis, MassSpectrumDeconvolution]],
      Messages :> {AnalyzeMassSpectrumDeconvolution::StartIntensityCheck},
      Stubs :> {
        HTTPRequestJSON[_] = <|"0" -> {{
          "Object.Data.MassSpectrometry", "id:DataObject", "id:RawMzMLCloudFile", "id:CentroidMzMLCloudFile", "id:DeconvolutedMzMLCloudFile",
          (* Placeholder Data - RetentionTimes, MassToChargeRatios, Intensities, Charges, IsotopicPeaksCounts*)
          {{1,2,3}, {{1}, {2}, {3}}, {{1}, {2}, {3}}, {{1}, {2}, {3}}, {{1}, {2}, {3}}}
        }}|>
      }
    ],

    (* --- Additional Tests --- *)
    Example[{Additional, "Output->Preview returns a graphics object:"},
      AnalyzeMassSpectrumDeconvolution[Object[Data, ChromatographyMassSpectra, "id:J8AY5jAWBBpj"], Output->Preview, Upload->False],
      _?ValidGraphicsQ
    ],
    Example[{Additional, "Output->Preview returns a SlideView of graphics objects:"},
      AnalyzeMassSpectrumDeconvolution[{
        Object[Data, ChromatographyMassSpectra, "id:J8AY5jAWBBpj"],
        Object[Data, ChromatographyMassSpectra, "id:J8AY5jAWBBpj"]
      }, Output->Preview, Upload->False],
      _SlideView
    ]
  },

  (* --- Variables, SetUp, and TearDown --- *)
  SymbolSetUp :> (
    $CreatedObjects = {}
  ),
  SymbolTearDown :> (
    EraseObject[Pick[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
    Unset[$CreatedObjects];
  )
];


(* Not using DefineTestsWithCompanions because I needed to do work outside the framework for preview to be speedy in main function. *)
DefineTests[AnalyzeMassSpectrumDeconvolutionPreview,
  {
    Example[{Basic, "Run deconvolution analysis for a single Object[Data, MassSpectrometry]:"},
      AnalyzeMassSpectrumDeconvolutionPreview[Object[Data, MassSpectrometry, "id:rea9jla4N43O"], Upload -> False],
      ValidGraphicsP[]
    ],
    Example[{Basic, "Run deconvolution analysis for a single Object[Data, ChromatographyMassSpectra]:"},
      AnalyzeMassSpectrumDeconvolutionPreview[Object[Data, ChromatographyMassSpectra, "id:J8AY5jAWBBpj"], Upload -> False],
      ValidGraphicsP[]
    ],
    Example[{Basic, "Run deconvolution analysis for a single Object[Protocol, MassSpectrometry]:"},
      AnalyzeMassSpectrumDeconvolutionPreview[Object[Protocol, MassSpectrometry, "AMSD Test Object"], Upload -> False],
      ValidGraphicsP[],
      TimeConstraint -> 1800,
      Stubs :> {
        Download[{Object[Protocol, MassSpectrometry, "AMSD Test Object"]}, Data] =
            {{Object[Data, MassSpectrometry, "id:rea9jla4N43O"], Object[Data, MassSpectrometry, "id:rea9jla4N43O"]}}
      }
    ]
  }
];


DefineTests[AnalyzeMassSpectrumDeconvolutionOptions,
  {
    Example[{Basic, "Run deconvolution analysis for a single Object[Data, MassSpectrometry]:"},
      AnalyzeMassSpectrumDeconvolutionOptions[Object[Data, MassSpectrometry, "id:rea9jla4N43O"], Upload -> False],
      _Grid | _List
    ],
    Example[{Basic, "Run deconvolution analysis for a single Object[Data, ChromatographyMassSpectra]:"},
      AnalyzeMassSpectrumDeconvolutionOptions[Object[Data, ChromatographyMassSpectra, "id:J8AY5jAWBBpj"], Upload -> False],
      _Grid | _List
    ],
    Example[{Basic, "Run deconvolution analysis for a single Object[Protocol, MassSpectrometry]:"},
      AnalyzeMassSpectrumDeconvolutionOptions[Object[Protocol, MassSpectrometry, "AMSD Test Object"], Upload -> False],
      _Grid | _List,
      TimeConstraint -> 1800,
      Stubs :> {
        Download[{Object[Protocol, MassSpectrometry, "AMSD Test Object"]}, Data] =
            {{Object[Data, MassSpectrometry, "id:rea9jla4N43O"], Object[Data, MassSpectrometry, "id:rea9jla4N43O"]}}
      }
    ]
  }
];


DefineTests[ValidAnalyzeMassSpectrumDeconvolutionQ,
  {
    Example[{Basic, "Run deconvolution analysis for a single Object[Data, MassSpectrometry], and run the tests:"},
      ValidAnalyzeMassSpectrumDeconvolutionQ[Object[Data, MassSpectrometry, "id:rea9jla4N43O"], Upload -> False],
      True
    ],
    Example[{Basic, "Run deconvolution analysis for a single Object[Data, ChromatographyMassSpectra], and run the tests:"},
      ValidAnalyzeMassSpectrumDeconvolutionQ[Object[Data, ChromatographyMassSpectra, "id:J8AY5jAWBBpj"], Upload -> False],
      True
    ],
    Example[{Basic, "Run deconvolution analysis for a single Object[Protocol, MassSpectrometry], and run the tests:"},
      ValidAnalyzeMassSpectrumDeconvolutionQ[Object[Protocol, MassSpectrometry, "AMSD Test Object"], Upload -> False],
      True,
      TimeConstraint -> 1800,
      Stubs :> {
        (* ValidQ function will also try to download and validate the entire protocol object. Stub a simple placeholder object for the check. *)
        Download[{Object[Protocol, MassSpectrometry, "AMSD Test Object"]}] =
            {<|Type -> Object[Data], Object -> Object[Data, "id:1"], DateCreated -> Now|>},
        Download[{Object[Protocol, MassSpectrometry, "AMSD Test Object"]}, Data] =
            {{Object[Data, MassSpectrometry, "id:rea9jla4N43O"]}}
      }
    ],
    Example[{Basic, "Run deconvolution analysis for a single Object[Data, MassSpectrometry], and print the test outputs:"},
      ValidAnalyzeMassSpectrumDeconvolutionQ[Object[Data, MassSpectrometry, "id:rea9jla4N43O"], Upload -> False, Verbose->True],
      True
    ],
    Example[{Basic, "Run deconvolution analysis for a single Object[Data, MassSpectrometry], and return the test summary:"},
      ValidAnalyzeMassSpectrumDeconvolutionQ[Object[Data, MassSpectrometry, "id:rea9jla4N43O"], Upload -> False, OutputFormat->TestSummary],
      _EmeraldTestSummary
    ]
  }
];
