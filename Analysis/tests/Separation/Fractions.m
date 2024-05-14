(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Fractions: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*AnalyzeFractions*)


(* ::Subsubsection::Closed:: *)
(*AnalyzeFractions*)


DefineTests[
	AnalyzeFractions,
{
	ObjectTest[
		{Basic, "By default, AnalyzeFractions selects no fractions:"},
		AnalyzeFractions[Object[Data, Chromatography, "id:54n6evKxbxRB"]][SamplesPicked],
		{},
		TimeConstraint -> 1000,
		CheckFields -> {{FractionsPicked -> {{Null, Null, Null}}, SamplesPicked -> {}, Reference -> {LinkP[Object[Data, Chromatography, "id:54n6evKxbxRB"]]}}}
	],
 	ObjectTest[
		{Basic, "Use options (Include) to select what fractions to include:"},
		AnalyzeFractions[Object[Data, Chromatography, "id:54n6evKxbxRB"], Include -> {1, 2}][SamplesPicked],
		{LinkP[Object[Sample, "id:dORYzZn65mlG"]], LinkP[Object[Sample, "id:eGakld09XDL1"]]},
		TimeConstraint -> 1000,
		CheckFields -> {{FractionsPicked -> {{Quantity[20.41416667, "Minutes"], Quantity[20.894, "Minutes"], "2A2"}, {Quantity[21.87833333, "Minutes"], Quantity[22.161, "Minutes"], "2A3"}}, SamplesPicked -> {LinkP[Object[Sample, "id:dORYzZn65mlG"]], LinkP[Object[Sample, "id:eGakld09XDL1"]]}, Reference -> {LinkP[Object[Data, Chromatography, "id:54n6evKxbxRB"]]}}},
		ResolvedOptions -> {Include -> {1, 2}}
	],
 	ObjectTest[
		{Basic, "Use options (TopPeaks) to select what fractions to include:"},
		AnalyzeFractions[Object[Data, Chromatography, "id:54n6evKxbxRB"], TopPeaks -> 1][SamplesPicked],
		{LinkP[Object[Sample, "id:GmzlKjYVAR0k"]], LinkP[Object[Sample, "id:AEqRl951OdJ5"]]},
		TimeConstraint -> 1000,
		CheckFields -> {{FractionsPicked -> {{Quantity[27.71566667, "Minutes"], Quantity[29.516, "Minutes"], "2A10"}, {Quantity[29.516, "Minutes"], Quantity[30., "Minutes"], "2A11"}}, SamplesPicked -> {LinkP[Object[Sample, "id:GmzlKjYVAR0k"]], LinkP[Object[Sample, "id:AEqRl951OdJ5"]]}, Reference -> {LinkP[Object[Data, Chromatography, "id:54n6evKxbxRB"]]}}},
		ResolvedOptions -> {TopPeaks -> 1}
	],
	ObjectTest[
		{Basic, "Take an HPLC protocol as input and include first fraction from the samples:"},
		AnalyzeFractions[Object[Protocol, HPLC, "id:D8KAEvdq47Em"], Include -> {1}][SamplesPicked],
		{{LinkP[Object[Sample, "id:zGj91aRlbA9J"]]}, {LinkP[Object[Sample, "id:L8kPEjNGZAP4"]]}, {LinkP[Object[Sample, "id:D8KAEvdeY5A3"]]}, {LinkP[Object[Sample, "id:jLq9jXY0ZAXZ"]]}, {LinkP[Object[Sample, "id:9RdZXvKxP9vK"]]}},
		TimeConstraint -> 1000
	],
 	ObjectTest[
		{Basic, "Plot picked fractions:"},
		PlotFractions[AnalyzeFractions[Object[Data, Chromatography, "id:54n6evKxbxRB"]]],
		_?ValidGraphicsQ,
		TimeConstraint -> 1000,
		CheckFields -> {{FractionsPicked -> {{Null, Null, Null}}, SamplesPicked -> {}, Reference -> {LinkP[Object[Data, Chromatography, "id:54n6evKxbxRB"]]}}}
	],
	ObjectTest[
		{Basic, "Upload FractionsPicked result to input Object[Data, Chromatography]:"},
		AnalyzeFractions[Object[Data, Chromatography, "id:54n6evKxbxRB"], TopPeaks -> 1, Exclude -> {28.5 Minute}];
		Object[Data,Chromatography,"id:54n6evKxbxRB"][FractionsPicked],
		{{Quantity[29.516, "Minutes"], Quantity[30., "Minutes"], "2A11"}},
		TimeConstraint -> 1000
	],
 	ObjectTest[
		{Additional, "Given list of chromatography datas:"},
		AnalyzeFractions[{Object[Data, Chromatography, "id:54n6evKxbxRB"], Object[Data, Chromatography, "id:1ZA60vwj7GRE"]}][SamplesPicked],
		{{}, {}},
		TimeConstraint -> 1000
	],
	ObjectTest[
		{Additional, "Fractions are collected with a span:"},
		AnalyzeFractions[Object[Data, Chromatography, "id:54n6evKxbxRB"], Include -> {2 ;; 5}][SamplesPicked],
		{LinkP[Object[Sample, "id:eGakld09XDL1"]], LinkP[Object[Sample, "id:pZx9jon470r4"]], LinkP[Object[Sample, "id:4pO6dMWK9j7L"]], LinkP[Object[Sample, "id:Vrbp1jG3qazq"]]},
		TimeConstraint -> 1000,
		CheckFields -> {{}},
		ResolvedOptions -> {Include -> {2 ;; 5}}
	],
	Example[{Additional,"One $Failed in a list of inputs:"},
		AnalyzeFractions[{
			Object[Data, Chromatography, "id:54n6evKxbxRB"],
  		Object[Data, Chromatography, "id:lYq9jRxRzV4p"],
  		Object[Data, Chromatography, "id:1ZA60vwj7GRE"]
		}],
		{ObjectP[Object[Analysis,Fractions]],$Failed,ObjectP[Object[Analysis,Fractions]]},
		Messages :> {Message[Error::MissingCollectedFractions]}
	],
 	ObjectTest[
		"Given list of chromatography datas, Return Packet:",
		AnalyzeFractions[{Object[Data, Chromatography, "id:54n6evKxbxRB"], Object[Data, Chromatography, "id:1ZA60vwj7GRE"]}, TopPeaks -> 1],
		{ObjectReferenceP[Object[Analysis, Fractions]], ObjectReferenceP[Object[Analysis, Fractions]]},
		TimeConstraint -> 1000
	],
 	ObjectTest[
		{Options, Exclude, "Exclude the fraction overlapping 28.5 Minute:"},
		AnalyzeFractions[Object[Data, Chromatography, "id:54n6evKxbxRB"], TopPeaks -> 1, Exclude -> {28.5 Minute}][FractionsPicked],
		{{Quantity[29.516, "Minutes"], Quantity[30., "Minutes"], "2A11"}},
		TimeConstraint -> 1000,
		CheckFields -> {{FractionsPicked -> {{Quantity[29.516, "Minutes"], Quantity[30., "Minutes"], "2A11"}}, SamplesPicked -> {LinkP[Object[Sample, "id:AEqRl951OdJ5"]]}, Reference -> {LinkP[Object[Data, Chromatography, "id:54n6evKxbxRB"]]}}},
		ResolvedOptions -> {TopPeaks -> 1, Exclude -> {28.5 Minute}}
	],
 	ObjectTest[
		{Options, Exclude, "Exclude the 10th fraction from the FractionsCollected list:"},
		AnalyzeFractions[Object[Data, Chromatography, "id:54n6evKxbxRB"], Exclude -> {10}, Include -> {9}][SamplesPicked],
		{LinkP[Object[Sample, "id:GmzlKjYVAR0k"]]},
		TimeConstraint -> 1000,
		CheckFields -> {{FractionsPicked -> {{Quantity[27.71566667, "Minutes"], Quantity[29.516, "Minutes"], "2A10"}}, SamplesPicked -> {LinkP[Object[Sample, "id:GmzlKjYVAR0k"]]}, Reference -> {LinkP[Object[Data, Chromatography, "id:54n6evKxbxRB"]]}}},
		ResolvedOptions -> {Exclude -> {10}, Include -> {9}}
	],
	ObjectTest[
		{Options, Exclude, "Get all TopPeaks, but exclude the fraction overlapping 26 minutes and the second fraction:"},
		AnalyzeFractions[Object[Data, Chromatography, "id:54n6evKxbxRB"], TopPeaks -> All, Exclude -> {2, 26*Minute}][FractionsPicked],
		{{Quantity[22.17766667, "Minutes"], Quantity[23.0775, "Minutes"], "2A4"}, {Quantity[23.09416667, "Minutes"], Quantity[23.66616667, "Minutes"], "2A5"}, {Quantity[23.68283333, "Minutes"], Quantity[24.91966667, "Minutes"], "2A6"}, {Quantity[26.06166667, "Minutes"], Quantity[26.78616667, "Minutes"], "2A8"}, {Quantity[26.80283333, "Minutes"], Quantity[27.699, "Minutes"], "2A9"}, {Quantity[27.71566667, "Minutes"], Quantity[29.516, "Minutes"], "2A10"}, {Quantity[29.516, "Minutes"], Quantity[30., "Minutes"], "2A11"}},
		TimeConstraint -> 17,
		CheckFields -> {{FractionsPicked -> {{Quantity[22.17766667, "Minutes"], Quantity[23.0775, "Minutes"], "2A4"}, {Quantity[23.09416667, "Minutes"], Quantity[23.66616667, "Minutes"], "2A5"}, {Quantity[23.68283333, "Minutes"], Quantity[24.91966667, "Minutes"], "2A6"}, {Quantity[26.06166667, "Minutes"], Quantity[26.78616667, "Minutes"], "2A8"}, {Quantity[26.80283333, "Minutes"], Quantity[27.699, "Minutes"], "2A9"}, {Quantity[27.71566667, "Minutes"], Quantity[29.516, "Minutes"], "2A10"}, {Quantity[29.516, "Minutes"], Quantity[30., "Minutes"], "2A11"}}}},
		ResolvedOptions -> {TopPeaks -> All, Exclude -> {2, Quantity[26, "Minutes"]}}
	],
 	ObjectTest[
		{Options, Include, "Include the fraction overlapping 22.5 Minute:"},
		AnalyzeFractions[Object[Data, Chromatography, "id:54n6evKxbxRB"], TopPeaks -> 1, Include -> {22.5 Minute}][FractionsPicked],
		{{Quantity[22.17766667, "Minutes"], Quantity[23.0775, "Minutes"], "2A4"}, {Quantity[27.71566667, "Minutes"], Quantity[29.516, "Minutes"], "2A10"}, {Quantity[29.516, "Minutes"], Quantity[30., "Minutes"], "2A11"}},
		TimeConstraint -> 1000,
		CheckFields -> {{FractionsPicked -> {{Quantity[22.17766667, "Minutes"], Quantity[23.0775, "Minutes"], "2A4"}, {Quantity[27.71566667, "Minutes"], Quantity[29.516, "Minutes"], "2A10"}, {Quantity[29.516, "Minutes"], Quantity[30., "Minutes"], "2A11"}}, SamplesPicked -> {LinkP[Object[Sample, "id:pZx9jon470r4"]], LinkP[Object[Sample, "id:GmzlKjYVAR0k"]], LinkP[Object[Sample, "id:AEqRl951OdJ5"]]}, Reference -> {LinkP[Object[Data, Chromatography, "id:54n6evKxbxRB"]]}}},
		ResolvedOptions -> {TopPeaks -> 1, Include -> {22.5 Minute}}
	],
 	ObjectTest[
		{Options, Include, "Include the second fraction from the FractionsCollected list:"},
		AnalyzeFractions[Object[Data, Chromatography, "id:54n6evKxbxRB"], TopPeaks -> 1, Include -> {2}][FractionsPicked],
		{{Quantity[21.87833333, "Minutes"], Quantity[22.161, "Minutes"], "2A3"}, {Quantity[27.71566667, "Minutes"], Quantity[29.516, "Minutes"], "2A10"}, {Quantity[29.516, "Minutes"], Quantity[30., "Minutes"], "2A11"}},
		TimeConstraint -> 1000,
		CheckFields -> {{FractionsPicked -> {{Quantity[21.87833333, "Minutes"], Quantity[22.161, "Minutes"], "2A3"}, {Quantity[27.71566667, "Minutes"], Quantity[29.516, "Minutes"], "2A10"}, {Quantity[29.516, "Minutes"], Quantity[30., "Minutes"], "2A11"}}, SamplesPicked -> {LinkP[Object[Sample, "id:eGakld09XDL1"]], LinkP[Object[Sample, "id:GmzlKjYVAR0k"]], LinkP[Object[Sample, "id:AEqRl951OdJ5"]]}, Reference -> {LinkP[Object[Data, Chromatography, "id:54n6evKxbxRB"]]}}},
		ResolvedOptions -> {TopPeaks -> 1, Include -> {2}}
	],
 	ObjectTest[
		{Options, Include, "Include the second fraction and the fraction overlapping the 26 Minute mark:"},
		AnalyzeFractions[Object[Data, Chromatography, "id:54n6evKxbxRB"], TopPeaks -> 1, Include -> {2, 26*Minute}][FractionsPicked],
		{{Quantity[21.87833333, "Minutes"], Quantity[22.161, "Minutes"], "2A3"}, {Quantity[24.93633333, "Minutes"], Quantity[26.045, "Minutes"], "2A7"}, {Quantity[27.71566667, "Minutes"], Quantity[29.516, "Minutes"], "2A10"}, {Quantity[29.516, "Minutes"], Quantity[30., "Minutes"], "2A11"}},
		TimeConstraint -> 1000,
		CheckFields -> {{FractionsPicked -> {{Quantity[21.87833333, "Minutes"], Quantity[22.161, "Minutes"], "2A3"}, {Quantity[24.93633333, "Minutes"], Quantity[26.045, "Minutes"], "2A7"}, {Quantity[27.71566667, "Minutes"], Quantity[29.516, "Minutes"], "2A10"}, {Quantity[29.516, "Minutes"], Quantity[30., "Minutes"], "2A11"}}, SamplesPicked -> {LinkP[Object[Sample, "id:eGakld09XDL1"]], LinkP[Object[Sample, "id:XnlV5jmaDOLo"]], LinkP[Object[Sample, "id:GmzlKjYVAR0k"]], LinkP[Object[Sample, "id:AEqRl951OdJ5"]]}, Reference -> {LinkP[Object[Data, Chromatography, "id:54n6evKxbxRB"]]}}},
		ResolvedOptions -> {TopPeaks -> 1, Include -> {2, Quantity[26, "Minutes"]}}
	],
 	ObjectTest[
		{Options, Domain, "Domain can also be specified with time units:"},
		AnalyzeFractions[Object[Data, Chromatography, "id:54n6evKxbxRB"], Domain -> {26*Minute, 0.48*Hour}, Include -> {7}][FractionsPicked],
		{{Quantity[26.06166667, "Minutes"], Quantity[26.78616667, "Minutes"], "2A8"}},
		TimeConstraint -> 1000,
		CheckFields -> {{FractionsPicked -> {{Quantity[26.06166667, "Minutes"], Quantity[26.78616667, "Minutes"], "2A8"}}, SamplesPicked -> {LinkP[Object[Sample, "id:qdkmxz0Vl163"]]}, Reference -> {LinkP[Object[Data, Chromatography, "id:54n6evKxbxRB"]]}}},
		ResolvedOptions -> {Domain -> {Quantity[26, "Minutes"], Quantity[0.48, "Hours"]}, Include -> {7}}
	],
 	ObjectTest[
		{Options, OverlappingPeaks, "Return only fractions overlapping the biggest peak:"},
		AnalyzeFractions[Object[Data, Chromatography, "id:1ZA60vwj7GRE"], TopPeaks -> 1, OverlappingPeaks -> Download[Object[Data, Chromatography, "id:1ZA60vwj7GRE"], AbsorbancePeaksAnalyses[[-1]]]][SamplesPicked],
		{LinkP[Object[Sample, "id:bq9LA0dvpa1e"]], LinkP[Object[Sample, "id:KBL5DvYOARPj"]], LinkP[Object[Sample, "id:jLq9jXY0ZAOa"]]},
		TimeConstraint -> 1000,
		CheckFields -> {{FractionsPicked -> {{Quantity[40.73716667, "Minutes"], Quantity[41.45716667, "Minutes"], "1C5"}, {Quantity[41.45716667, "Minutes"], Quantity[42.17733333, "Minutes"], "1C6"}, {Quantity[42.17733333, "Minutes"], Quantity[42.89733333, "Minutes"], "1C7"}}, SamplesPicked -> {LinkP[Object[Sample, "id:bq9LA0dvpa1e"]], LinkP[Object[Sample, "id:KBL5DvYOARPj"]], LinkP[Object[Sample, "id:jLq9jXY0ZAOa"]]}, Reference -> {LinkP[Object[Data, Chromatography, "id:1ZA60vwj7GRE"]]}}},
		ResolvedOptions -> {TopPeaks -> 1, OverlappingPeaks -> ObjectP[Object[Analysis, Peaks, "id:dORYzZn0XpnR"]]}
	],
	ObjectTest[
   		{Options, OverlappingPeaks, "If no peaks are specified, then no selecting is done based on peaks.  In this case no collected samples are returned:"},
   		AnalyzeFractions[Object[Data, Chromatography, "id:1ZA60vwj7GRE"], OverlappingPeaks -> Null][SamplesPicked],
   		{},
   		TimeConstraint -> 1000
   	],
 	ObjectTest[
		{Options, TopPeaks, "By default, uses only the largest (by area) peak:"},
		AnalyzeFractions[Object[Data, Chromatography, "id:1ZA60vwj7GRE"], TopPeaks -> 1][SamplesPicked],
		{LinkP[Object[Sample, "id:bq9LA0dvpa1e"]], LinkP[Object[Sample, "id:KBL5DvYOARPj"]], LinkP[Object[Sample, "id:jLq9jXY0ZAOa"]]},
		TimeConstraint -> 1000,
		CheckFields -> {{FractionsPicked -> {{Quantity[40.73716667, "Minutes"], Quantity[41.45716667, "Minutes"], "1C5"}, {Quantity[41.45716667, "Minutes"], Quantity[42.17733333, "Minutes"], "1C6"}, {Quantity[42.17733333, "Minutes"], Quantity[42.89733333, "Minutes"], "1C7"}}, SamplesPicked -> {LinkP[Object[Sample, "id:bq9LA0dvpa1e"]], LinkP[Object[Sample, "id:KBL5DvYOARPj"]], LinkP[Object[Sample, "id:jLq9jXY0ZAOa"]]}, Reference -> {LinkP[Object[Data, Chromatography, "id:1ZA60vwj7GRE"]]}}},
		ResolvedOptions -> {TopPeaks -> 1}
	],
 	ObjectTest[
		{Options, TopPeaks, "Use the 2 largest peaks:"},
		AnalyzeFractions[Object[Data, Chromatography, "id:1ZA60vwj7GRE"], OverlappingPeaks -> Download[Object[Data, Chromatography, "id:1ZA60vwj7GRE"], AbsorbancePeaksAnalyses[[-1]]], TopPeaks -> 2][SamplesPicked],
		{LinkP[Object[Sample, "id:bq9LA0dvpa1e"]], LinkP[Object[Sample, "id:KBL5DvYOARPj"]], LinkP[Object[Sample, "id:jLq9jXY0ZAOa"]], LinkP[Object[Sample, "id:7X104vKNoP6J"]], LinkP[Object[Sample, "id:N80DNjlozkvq"]]},
		TimeConstraint -> 1000,
		CheckFields -> {{FractionsPicked -> {{Quantity[40.73716667, "Minutes"], Quantity[41.45716667, "Minutes"], "1C5"}, {Quantity[41.45716667, "Minutes"], Quantity[42.17733333, "Minutes"], "1C6"}, {Quantity[42.17733333, "Minutes"], Quantity[42.89733333, "Minutes"], "1C7"}, {Quantity[42.89733333, "Minutes"], Quantity[43.6175, "Minutes"], "1C8"}, {Quantity[43.6175, "Minutes"], Quantity[44.0815, "Minutes"], "1C9"}}, SamplesPicked -> {LinkP[Object[Sample, "id:bq9LA0dvpa1e"]], LinkP[Object[Sample, "id:KBL5DvYOARPj"]], LinkP[Object[Sample, "id:jLq9jXY0ZAOa"]], LinkP[Object[Sample, "id:7X104vKNoP6J"]], LinkP[Object[Sample, "id:N80DNjlozkvq"]]}, Reference -> {LinkP[Object[Data, Chromatography, "id:1ZA60vwj7GRE"]]}}},
		ResolvedOptions -> {OverlappingPeaks -> ObjectP[Object[Analysis, Peaks, "id:dORYzZn0XpnR"]], TopPeaks -> 2}
	],
 	ObjectTest[
		{Options, TopPeaks, "Use TopPeaks->All to use peaks:"},
		AnalyzeFractions[Object[Data, Chromatography, "id:1ZA60vwj7GRE"], TopPeaks -> All][SamplesPicked],
		{LinkP[Object[Sample, "id:bq9LA0dvpa1e"]], LinkP[Object[Sample, "id:KBL5DvYOARPj"]], LinkP[Object[Sample, "id:jLq9jXY0ZAOa"]], LinkP[Object[Sample, "id:7X104vKNoP6J"]], LinkP[Object[Sample, "id:N80DNjlozkvq"]]},
		TimeConstraint -> 1000,
		CheckFields -> {{FractionsPicked -> {{Quantity[40.73716667, "Minutes"], Quantity[41.45716667, "Minutes"], "1C5"}, {Quantity[41.45716667, "Minutes"], Quantity[42.17733333, "Minutes"], "1C6"}, {Quantity[42.17733333, "Minutes"], Quantity[42.89733333, "Minutes"], "1C7"}, {Quantity[42.89733333, "Minutes"], Quantity[43.6175, "Minutes"], "1C8"}, {Quantity[43.6175, "Minutes"], Quantity[44.0815, "Minutes"], "1C9"}}, SamplesPicked -> {LinkP[Object[Sample, "id:bq9LA0dvpa1e"]], LinkP[Object[Sample, "id:KBL5DvYOARPj"]], LinkP[Object[Sample, "id:jLq9jXY0ZAOa"]], LinkP[Object[Sample, "id:7X104vKNoP6J"]], LinkP[Object[Sample, "id:N80DNjlozkvq"]]}, Reference -> {LinkP[Object[Data, Chromatography, "id:1ZA60vwj7GRE"]]}}},
		ResolvedOptions -> {TopPeaks -> All}
	],
 	ObjectTest[
		{Options, TopPeaks, "Use TopPeaks->0 to use no peaks:"},
		AnalyzeFractions[Object[Data, Chromatography, "id:1ZA60vwj7GRE"], TopPeaks -> 0][SamplesPicked],
		{},
		TimeConstraint -> 1000,
		CheckFields -> {{FractionsPicked -> {{Null, Null, Null}}, SamplesPicked -> {}, Reference -> {LinkP[Object[Data, Chromatography, "id:1ZA60vwj7GRE"]]}}},
		ResolvedOptions -> {TopPeaks -> 0}
	],
	ObjectTest[
		{Options, Template, "Use options from previous fractions analysis:"},
		AnalyzeFractions[Object[Data, Chromatography, "id:54n6evKxbxRB"], Template -> AnalyzeFractions[Object[Data, Chromatography, "id:54n6evKxbxRB"], TopPeaks -> 5]][SamplesPicked],
		{LinkP[Object[Sample, "id:XnlV5jmaDOLo"]], LinkP[Object[Sample, "id:qdkmxz0Vl163"]], LinkP[Object[Sample, "id:O81aEB4zxlXp"]], LinkP[Object[Sample, "id:GmzlKjYVAR0k"]], LinkP[Object[Sample, "id:AEqRl951OdJ5"]]},
		TimeConstraint -> 1000
	],
 	ObjectTest[
		{Messages, "InvalidPosition", "Positions to Include or Exclude cannot be greater than the number of collected fractions:"},
		AnalyzeFractions[Object[Data, Chromatography, "id:54n6evKxbxRB"], Exclude -> {100}, Include -> {200}][SamplesPicked],
		{},
		Messages :> {Message[Warning::InvalidPosition, 100, 10], Message[Warning::InvalidPosition, 200, 10]},
		TimeConstraint -> 1000,
		CheckFields -> {{FractionsPicked -> {{Null, Null, Null}}, SamplesPicked -> {}, Reference -> {LinkP[Object[Data, Chromatography, "id:54n6evKxbxRB"]]}}},
		ResolvedOptions -> {Exclude -> {100}, Include -> {200}}
	],
	Example[
		{Messages, "IncludeOutsideDomain", "An inclusion specified in the Include option apply to a fraction which are not in the Domain:"},
		AnalyzeFractions[Object[Data, Chromatography, "id:54n6evKxbxRB"], Domain -> {0*Minute, 25*Minute}, Include -> {10}, Upload->False],
		validAnalysisPacketP[Object[Analysis, Fractions],
			{
				Replace[FractionsPicked] -> {{29.516, 30., "2A11"}},
				Replace[SamplesPicked] -> {LinkP[Object[Sample, "id:AEqRl951OdJ5"]]},
				Replace[Reference] -> {LinkP[Object[Data, Chromatography, "id:54n6evKxbxRB"]]}
			},
			ResolvedOptions -> {Domain -> {Quantity[0, "Minutes"], Quantity[25, "Minutes"]}, Include -> {10}}
		],
		Messages :> {Message[Warning::IncludeOutsideDomain, {10}]},
		TimeConstraint -> 1000
	],
	Example[
		{Messages, "IncludeHasNoEffect", "An inclusion specified in the Include option apply to a fraction which have already been selected.:"},
		AnalyzeFractions[Object[Data, Chromatography, "id:54n6evKxbxRB"], Include -> {10}, TopPeaks -> 1, Upload->False],
		validAnalysisPacketP[Object[Analysis, Fractions],
			{
				Replace[FractionsPicked] -> {{27.71566667, 29.516, "2A10"}, {29.516, 30., "2A11"}},
				Replace[SamplesPicked] -> {LinkP[Object[Sample, "id:GmzlKjYVAR0k"]], LinkP[Object[Sample, "id:AEqRl951OdJ5"]]},
				Replace[Reference] -> {LinkP[Object[Data, Chromatography, "id:54n6evKxbxRB"]]}
			},
			ResolvedOptions -> {Include -> {10}, TopPeaks -> 1}
		],
		Messages :> {Message[Warning::IncludeHasNoEffect, {10}]},
		TimeConstraint -> 1000
	],
	Example[
 		{Messages, "UnexpectedUnits", "An error is thrown when non time units are used in the include option:"},
 		AnalyzeFractions[Object[Data, Chromatography, "id:54n6evKxbxRB"], Include -> {1*Meter ;; 2*Meter}],
 		$Failed,
 		Messages :> {Message[Error::UnexpectedUnits]},
 		TimeConstraint -> 1000
 	],
	Example[
 		{Messages, "FractionalIndexes", "The span option of include expects integer values ot select indexes:"},
 		AnalyzeFractions[Object[Data, Chromatography, "id:54n6evKxbxRB"], Include -> {1.5 ;; 2.3}],
 		$Failed,
 		Messages :> {Message[Error::FractionalIndexes]},
 		TimeConstraint -> 1000
 	],
	ObjectTest[
		{Issues, "Include option overrides Exclude option because of the order in which the filtering occurs:"},
		AnalyzeFractions[Object[Data, Chromatography, "id:54n6evKxbxRB"], Exclude -> {3}, Include -> {3}][FractionsPicked],
		{{Quantity[22.17766667, "Minutes"], Quantity[23.0775, "Minutes"], "2A4"}},
		TimeConstraint -> 14,
		CheckFields -> {{FractionsPicked -> {{Quantity[22.17766667, "Minutes"], Quantity[23.0775, "Minutes"], "2A4"}}}},
		ResolvedOptions -> {Exclude -> {3}, Include -> {3}}
	],
	Test["Command Builder makes call like this:",
		MatchQ[
			AnalyzeFractions[Object[Data, Chromatography, "id:54n6evKxbxRB"], Output -> {Preview, Options}],
			Alternatives[
				{_Grid, _List} /; $CCD,
				{_DynamicModule, _List}
			]
		],
		True
	],
  Test["Bad option errors and exits:",
		AnalyzeFractions[Object[Data, Chromatography, "id:54n6evKxbxRB"], Include -> horse],
		$Failed,
		Messages:>{Error::Pattern}
  ],
  Example[
		{Messages, "MissingCollectedFractions", "Data objects with no fractions throw an error and return $Failed:"},
		testChromatographyNoFractions = Upload[Association[Type -> Object[Data, Chromatography]]];
		AnalyzeFractions[testChromatographyNoFractions],
		$Failed,
		Messages :> {Message[Error::MissingCollectedFractions]},
		TimeConstraint -> 1000
	],



		(*
			COMMAND BUILDER INTEGRATION
		*)

	Test["No options, single object:",
		Analysis`Private`opsFromJSON[ECL`AppHelpers`ResolvedOptionsJSON[AnalyzeFractions,{{Object[Data,Chromatography,"id:1ZA60vwj7GRE"]}},{}]],
		{"0","Null","Null","{0., 65.*Minute}"}
	],
	Test["Yes options, single object:",
		Analysis`Private`opsFromJSON[ECL`AppHelpers`ResolvedOptionsJSON[AnalyzeFractions,
			{{Object[Data,Chromatography,"id:1ZA60vwj7GRE"]}},
			{TopPeaks->2,Exclude->{5},Domain->{10Minute,50Minute}}]
		],
		{"2","Null","{5}","{10*Minute, 50*Minute}"}
	],
	Test["No options, two objects:",
		Analysis`Private`opsFromJSON[ECL`AppHelpers`ResolvedOptionsJSON[AnalyzeFractions,{{Object[Data,Chromatography,"id:54n6evKxbxRB"],Object[Data,Chromatography,"id:1ZA60vwj7GRE"]}},{}]],
		{"0","Null","Null","{{0., 65.006667*Minute}, {0., 65.*Minute}}"}
	],
	Test["Yes options, two objects:",
		Analysis`Private`opsFromJSON[ECL`AppHelpers`ResolvedOptionsJSON[AnalyzeFractions,{{Object[Data,Chromatography,"id:54n6evKxbxRB"],Object[Data,Chromatography,"id:1ZA60vwj7GRE"]}},{TopPeaks->{2,1},Exclude->{{5},{1,2}},Domain->{{10Minute,50Minute},{5Minute,33Minute}}}]],
		{"{2, 1}","Null","{{5}, {1, 2}}","{{10*Minute, 50*Minute}, {5*Minute, 33*Minute}}"}
	]
}
]

(* ::Subsubsection::Closed:: *)
(*AnalyzeFractionsOptions*)


DefineTests[
	AnalyzeFractionsOptions,
	{
		(*
			---------- BASIC ------------
		*)
		Example[{Basic,"Resolve options for a data object:"},
			Quiet[AnalyzeFractionsOptions[Object[Data, Chromatography, "id:54n6evKxbxRB"]],{Download::MissingField}],
			_Grid,
			TimeConstraint -> 1000
		],

		Example[{Basic,"Resolve options for HPLC protocol input:"},
			AnalyzeFractionsOptions[Object[Protocol, HPLC, "id:D8KAEvdq47Em"]],
			_Grid,
			TimeConstraint -> 1000
		],

		Example[{Options,OutputFormat,"Return the options as a list:"},
			AnalyzeFractionsOptions[Object[Data, Chromatography, "id:54n6evKxbxRB"],OutputFormat->List],
			{___Rule}?(ContainsAll[Keys[Options[AnalyzeFractions]],Map[SymbolName,Keys[#]]]&)
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*AnalyzeFractionsPreview*)


DefineTests[
	AnalyzeFractionsPreview,
	{
		(*
			---------- BASIC ------------
		*)
		Example[{Basic,"Generate preview for a data object:"},
			AnalyzeFractionsPreview[Object[Data, Chromatography, "id:54n6evKxbxRB"]],
			_DynamicModule|_Grid,
			TimeConstraint -> 1000
		],

		Example[{Basic,"Generate preview for HPLC protocol input:"},
			AnalyzeFractionsPreview[Object[Protocol, HPLC, "id:D8KAEvdq47Em"]],
			_SlideView,
			TimeConstraint -> 1000
		],

		Example[{Basic,"Generate previews for list of chromatography:"},
			AnalyzeFractionsPreview[{Object[Data, Chromatography, "id:54n6evKxbxRB"],Object[Data, Chromatography, "id:AEqRl9KVpYNa"]},Domain -> {1 Minute, 3 Minute}],
			AnalyzeFractionsPreview[{Object[Data, Chromatography, "id:vXl9j57xa0JN"], Object[Data, Chromatography, "id:xRO9n3BxJZlz"]},Domain -> {1 Minute, 3 Minute}],
			_SlideView,
			TimeConstraint -> 1000
		],

		Example[{Basic,"Generate preview with user specified option:"},
			AnalyzeFractionsPreview[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],TopPeaks->0],
			_DynamicModule|_Grid,
			TimeConstraint -> 1000
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidAnalyzeFractionsQ*)


DefineTests[
	ValidAnalyzeFractionsQ,
	{
		(*
			---------- BASIC ------------
		*)
		Example[{Basic,"Validate input for a data object:"},
			ValidAnalyzeFractionsQ[Object[Data, Chromatography, "id:54n6evKxbxRB"]],
			True,
			TimeConstraint -> 1000
		],

		Example[{Basic,"Validate input for HPLC protocol input:"},
			ValidAnalyzeFractionsQ[Object[Protocol, HPLC, "id:D8KAEvdq47Em"]],
			True,
			TimeConstraint -> 1000
		],

		Example[{Basic,"Validate input with user specified option:"},
			ValidAnalyzeFractionsQ[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],TopPeaks->0],
			True,
			TimeConstraint -> 1000
		],

		Example[{Options, OutputFormat, "Return an EmeraldTestSummary:"},
			ValidAnalyzeFractionsQ[Object[Data, Chromatography, "id:54n6evKxbxRB"], OutputFormat->TestSummary],
			_EmeraldTestSummary,
			TimeConstraint -> 1000
		],

		Example[{Options, Verbose, "Print verbose messages reporting test passage / failure:"},
			ValidAnalyzeFractionsQ[Object[Data, Chromatography, "id:54n6evKxbxRB"], Verbose->True],
			True,
			TimeConstraint -> 1000
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*AnalyzeFractionsApp*)


DefineTests[
	AnalyzeFractionsApp,
	{
	(*
			---------- BASIC ------------
		*)
		Example[{Basic,"Pick fractions from a data object:"},
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"]],
			{Link[Object[Sample, _String]],	Link[Object[Sample, _String]]},
			TimeConstraint -> 1000,
			Stubs :> {
				AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"]]
						= AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"], Upload->False, App -> False]
			}
		],
		Test["Pick fractions from a data object, Return Packet:",
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],TopPeaks->1, Upload->False,App->False,Output->Packet],
			Analysis`Private`validAnalysisPacketP[Object[Analysis, Fractions],
				{
					Replace[FractionsPicked]->{{27.71566667`,29.516`,"2A10"},{29.516`,30.`,"2A11"}},
					Replace[Reference] -> {Link[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],FractionPickingAnalysis]},
					Replace[SamplesPicked]->{Link[Object[Sample, _String]],Link[Object[Sample, _String]]}
				},
				ResolvedOptions -> {Upload->False,App->False,Output->Packet,OverlappingPeaks->PacketP[Object[Analysis,Peaks]],Include->{},Exclude->{},Domain->All,TopPeaks->1,AppTest->False},
				NullFields -> { TheoreticalFractionVolumes},
				Round -> 12
			],
			TimeConstraint -> 1000
		],

		Example[{Basic,"Take an HPLC protocol as input:"},
		AnalyzeFractionsApp[Object[Protocol, HPLC, "id:D8KAEvdq47Em"], Include -> {1}, Upload -> False, App -> False],
			{{LinkP[Object[Sample]]..}..},
			TimeConstraint -> 1000,
			Stubs :> {
				AnalyzeFractionsApp[Object[Protocol, HPLC, "id:D8KAEvdq47Em"]]
						= AnalyzeFractionsApp[Object[Protocol, HPLC, "id:D8KAEvdq47Em"], Include -> {1},Upload->False, App -> False]
			}
		],
		Test["Take an HPLC protocol as input, Return Packet:",
			AnalyzeFractionsApp[Object[Protocol, HPLC, "id:D8KAEvdq47Em"],Upload->False,App->False,Output->Packet],
			Repeat[Analysis`Private`validAnalysisPacketP[Object[Analysis, Fractions], {}], 5],
			TimeConstraint -> 1000
		],


	(*
			------------------ ADDITIONAL -------------------
		*)
		Example[{Additional,"Given list of chromatography datas:"},
			AnalyzeFractionsApp[{Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Object[Data, Chromatography, "id:1ZA60vwj7GRE"]}],
			{
				{Link[Object[Sample, _String]],Link[Object[Sample, _String]]},
				{Link[Object[Sample, _String]],	Link[Object[Sample, _String]],Link[Object[Sample, _String]]}
			},
			TimeConstraint -> 1000,
			Stubs :> {
				AnalyzeFractionsApp[{Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Object[Data, Chromatography, "id:1ZA60vwj7GRE"]}]
						= AnalyzeFractionsApp[{Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Object[Data, Chromatography, "id:1ZA60vwj7GRE"]}, Upload->False, App -> False]
			}
		],
		Test["Given list of chromatography datas, Return Packet:",
			AnalyzeFractionsApp[{Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Object[Data, Chromatography, "id:1ZA60vwj7GRE"]}, Upload->False,App->False,Output->Packet],
			{
				Analysis`Private`validAnalysisPacketP[Object[Analysis, Fractions],
					{
						Replace[FractionsPicked]->{{27.71566667`,29.516`,"2A10"},{29.516`,30.`,"2A11"}},
						Replace[Reference] -> {Link[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],FractionPickingAnalysis]}
					},
					ResolvedOptions -> {Upload->False,App->False,Output->Packet,OverlappingPeaks->_,Include->{},Exclude->{},Domain->All,TopPeaks->1, AppTest->False},
					NullFields -> { TheoreticalFractionVolumes},
					Round -> 12
				],
				Analysis`Private`validAnalysisPacketP[Object[Analysis, Fractions],
					{
						Replace[FractionsPicked] -> {{40.73716667`,41.45716667`,"1C5"},{41.45716667`,42.17733333`,"1C6"},{42.17733333`,42.89733333`,"1C7"}},
						Replace[Reference] -> {Link[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],FractionPickingAnalysis]}
					},
					ResolvedOptions -> {Upload->False,App->False,Output->Packet,OverlappingPeaks->PacketP[Object[Analysis,Peaks]],Include->{},Exclude->{},Domain->All,TopPeaks->1,AppTest->False},
					NullFields -> {TheoreticalFractionVolumes},
					Round -> 12
				]
			},
			TimeConstraint -> 1000
		],


	(*
			-------------- OPTIONS ----------------------
		*)
		Example[{Options,Exclude,"Exclude the fraction overlapping 28.5 Minute:"},
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Exclude->{28.5 Minute}, TopPeaks->1, Output->FractionsPicked],
			{{29.516`,30.`,"2A11"}},
			TimeConstraint -> 1000,
			Stubs :> {
				AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Exclude->{28.5 Minute}, TopPeaks->1, Output->FractionsPicked]
						= AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Exclude->{28.5 Minute}, TopPeaks->1, Output->FractionsPicked, Upload->False, App -> False]
			}
		],
		Test["Exclude the fraction overlapping 28.5 Minute, Return Packet:",
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Exclude->{28.5 Minute}, Upload->False,App->False,Output->Packet],
			validAnalysisPacketP[Object[Analysis, Fractions],
				{
					Replace[FractionsPicked]->{{29.516`,30.`,"2A11"}},
					Replace[Reference] -> {Link[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],FractionPickingAnalysis]}
				},
				ResolvedOptions -> {Exclude->{28.5 Minute},Upload->False,App->False,Output->Packet,OverlappingPeaks->PacketP[Object[Analysis,Peaks]],Include->{},Domain->All,TopPeaks->1,AppTest->False},
				NullFields -> {TheoreticalFractionVolumes},
				Round -> 12
			],
			TimeConstraint -> 1000
		],
		Example[{Options,Exclude,"Exclude the 10th fraction from the FractionsCollected list:"},
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Exclude->{10}],
			{Link[Object[Sample, _String]]},
			TimeConstraint -> 1000,
			Stubs :> {
				AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Exclude->{10}]
						= AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Exclude->{10}, Upload->False, App -> False]
			}
		],
		Test["Exclude the 10th fraction, Return Packet:",
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Exclude->{10}, Upload->False,App->False,Output->Packet],
			validAnalysisPacketP[Object[Analysis, Fractions],
				{
					Replace[FractionsPicked]->{{27.71566667`,29.516`,"2A10"}},
					Replace[Reference] -> {Link[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],FractionPickingAnalysis]}
				},
				ResolvedOptions -> {Exclude->{10},Upload->False,App->False,Output->Packet,OverlappingPeaks->PacketP[Object[Analysis,Peaks]],Include->{},Domain->All,TopPeaks->1, AppTest->False},
				NullFields -> {TheoreticalFractionVolumes},
				Round -> 12
			],
			TimeConstraint -> 1000
		],
		Example[
			{Options, Exclude, "Get all TopPeaks, but exclude the fraction overlapping 26 minutes and the second fraction:"},
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"], TopPeaks -> All, Exclude -> {2, 26*Minute}, Output -> FractionsPicked, Upload -> False, App -> False],
			{{22.17766667, 23.0775, "2A4"}, {23.09416667, 23.66616667, "2A5"}, {23.68283333, 24.91966667, "2A6"}, {26.06166667, 26.78616667, "2A8"}, {26.80283333, 27.699, "2A9"}, {27.71566667, 29.516, "2A10"}, {29.516, 30., "2A11"}},
			TimeConstraint -> 1000
		],
		Example[{Options,Include,"Include the fraction overlapping 22.5 Minute:"},
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Include->{22.5 Minute},Output->FractionsPicked],
			{{22.17766667`,23.0775`,"2A4"},{27.71566667`,29.516`,"2A10"},{29.516`,30.`,"2A11"}},
			TimeConstraint -> 1000,
			Stubs :> {
				AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Include->{22.5 Minute},Output->FractionsPicked]
						= AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Include->{22.5 Minute},Output->FractionsPicked, Upload->False, App -> False]
			}
		],
		Test["Include the fraction overlapping 22. Minute, Return Packet:",
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Include->{22. Minute}, Upload->False,App->False,Output->Packet],
			validAnalysisPacketP[Object[Analysis, Fractions],
				{
					Replace[FractionsPicked]->{{21.87833333`,22.161`,"2A3"},{27.71566667`,29.516`,"2A10"},{29.516`,30.`,"2A11"}},
					Replace[Reference] -> {Link[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],FractionPickingAnalysis]}
				},
				ResolvedOptions -> {Include->{22. Minute},Upload->False,App->False,Output->Packet,OverlappingPeaks->PacketP[Object[Analysis,Peaks]],Exclude->{},Domain->All,TopPeaks->1, AppTest->False},
				NullFields -> {TheoreticalFractionVolumes},
				Round -> 12
			],
			TimeConstraint -> 1000
		],
		Example[{Options,Include,"Include the second fraction from the FractionsCollected list:"},
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"], Include->{2},Output->FractionsPicked],
			{{21.87833333`,22.161`,"2A3"},{27.71566667`,29.516`,"2A10"},{29.516`,30.`,"2A11"}},
			TimeConstraint -> 1000,
			Stubs :> {
				AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Include->{2},Output->FractionsPicked]
						= AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Include->{2},Output->FractionsPicked, Upload->False, App -> False]
			}
		],
		Test["Include the second fraction, Return Packet:",
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Include->{2}, Upload->False,App->False,Output->Packet],
			validAnalysisPacketP[Object[Analysis, Fractions],
				{
					Replace[FractionsPicked]->{{21.87833333`,22.161`,"2A3"},{27.71566667`,29.516`,"2A10"},{29.516`,30.`,"2A11"}},
					Replace[Reference] -> {Link[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],FractionPickingAnalysis]}
				},
				ResolvedOptions -> {Include->{2},Upload->False,App->False,Output->Packet,OverlappingPeaks->PacketP[Object[Analysis,Peaks]],Exclude->{},Domain->All,TopPeaks->1, AppTest->False},
				NullFields -> {TheoreticalFractionVolumes},
				Round -> 12
			],
			TimeConstraint -> 1000
		],
		Example[{Options,Include,"Include the second fraction and the fraction overlapping the 26 Minute mark:"},
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Include->{2,26 Minute},Output->FractionsPicked],
			{{21.87833333`,22.161`,"2A3"},{24.93633333`,26.045`,"2A7"},{27.71566667`,29.516`,"2A10"},{29.516`,30.`,"2A11"}},
			TimeConstraint -> 1000,
			Stubs :> {
				AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Include->{2,26 Minute},Output->FractionsPicked]
						= AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Include->{2,26 Minute},Output->FractionsPicked, Upload->False, App -> False]
			}
		],
		Test["Include the second fraction and the fraction overlapping the 26 Minute mark, Return Packet:",
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Include->{2,26 Minute}, Upload->False,App->False,Output->Packet],
			validAnalysisPacketP[Object[Analysis, Fractions],
				{
					Replace[FractionsPicked]->{{21.87833333`,22.161`,"2A3"},{24.93633333`,26.045`,"2A7"},{27.71566667`,29.516`,"2A10"},{29.516`,30.`,"2A11"}},
					Replace[Reference] -> {Link[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],FractionPickingAnalysis]}
				},
				ResolvedOptions -> {Include->{2, Quantity[26,"Minutes"]},Upload->False,App->False,Output->Packet,OverlappingPeaks->PacketP[Object[Analysis,Peaks]],Exclude->{},Domain->All,TopPeaks->1, AppTest->False},
				NullFields -> {TheoreticalFractionVolumes},
				Round -> 12
			],
			TimeConstraint -> 1000
		],

		Example[{Options,Domain,"Only consider fractions in the domain {26,28}:"},
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Domain->{26,28}, Output->FractionsPicked],
			{{27.71566667`,29.516`,"2A10"}},
			TimeConstraint -> 1000,
			Stubs :> {
				AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Domain->{26,28}, Output->FractionsPicked]
						= AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Domain->{26,28}, Output->FractionsPicked,Upload->False, App -> False]
			}
		],
		Test["Only consider fractions in the domain {26,28}, Return Packet:",
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Domain->{26,28}, Upload->False,App->False,Output->Packet],
			validAnalysisPacketP[Object[Analysis, Fractions],
				{
					Replace[FractionsPicked]->{{27.71566667`,29.516`,"2A10"}},
					Replace[Reference] -> {Link[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],FractionPickingAnalysis]}
				},
				ResolvedOptions -> {Domain->{26,28},Upload->False,App->False,Output->Packet,OverlappingPeaks->PacketP[Object[Analysis,Peaks]],Include->{},Exclude->{},TopPeaks->1,AppTest->False},
				NullFields -> {TheoreticalFractionVolumes},
				Round -> 12
			],
			TimeConstraint -> 1000
		],
		Example[{Options,Domain,"Domain can also be specified with time units:"},
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Domain->{26Minute,0.48Hour}, Output->FractionsPicked],
			{{27.71566667`,29.516`,"2A10"}},
			TimeConstraint -> 1000,
			Stubs :> {
				AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Domain->{26Minute,0.48Hour}, Output->FractionsPicked]
						= AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Domain->{26Minute,0.48Hour}, Output->FractionsPicked, Upload->False, App -> False]
			}
		],

		Example[{Options,OverlappingPeaks,"Return only fractions overlapping the biggest peak:"},
			AnalyzeFractionsApp[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],OverlappingPeaks->Download[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],AbsorbancePeaksAnalyses[[-1]]]],
			{Link[Object[Sample, _String]],
				Link[Object[Sample, _String]],
				Link[Object[Sample, _String]]},
			TimeConstraint -> 1000,
			Stubs :> {
				AnalyzeFractionsApp[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],OverlappingPeaks->Download[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],AbsorbancePeaksAnalyses[[-1]]]]
						= AnalyzeFractionsApp[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],OverlappingPeaks->Download[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],AbsorbancePeaksAnalyses[[-1]]], Upload->False, App -> False]
			}
		],
		Test["Return only fractions overlapping the biggest peak, Return Packet:",
			AnalyzeFractionsApp[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],OverlappingPeaks->Download[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],AbsorbancePeaksAnalyses[[-1]]], Upload->False,App->False,Output->Packet],
			validAnalysisPacketP[Object[Analysis, Fractions],
				{
					Replace[FractionsPicked]->{{40.73716667`,41.45716667`,"1C5"},{41.45716667`,42.17733333`,"1C6"},{42.17733333`,42.89733333`,"1C7"}}
				},
				ResolvedOptions->{OverlappingPeaks->PacketP[Object[Analysis,Peaks]],TopPeaks->1,Upload->False,App->False,Output->Packet,Include->{},Exclude->{},Domain->All,AppTest->False},
				Round -> 12
			],
			TimeConstraint -> 1000
		],
		Example[{Options,OverlappingPeaks,"If no peaks are specified, then no selecting is done based on peaks.  In this case no collected samples are returned:"},
			AnalyzeFractionsApp[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],OverlappingPeaks->Null],
			{},
			TimeConstraint -> 1000,
			Stubs :> {
				AnalyzeFractionsApp[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],OverlappingPeaks->Null]
						= AnalyzeFractionsApp[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],OverlappingPeaks->Null, Upload->False, App -> False]
			}
		],


		Example[{Options,TopPeaks,"By default, uses only the largest (by area) peak:"},
			AnalyzeFractionsApp[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],TopPeaks->1],
			{Link[Object[Sample, _String]],Link[Object[Sample, _String]],Link[Object[Sample, _String]]},
			TimeConstraint -> 1000,
			Stubs :> {
				AnalyzeFractionsApp[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],TopPeaks->1]
						= AnalyzeFractionsApp[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],TopPeaks->1, Upload->False, App -> False]
			}
		],
		Test["By default, uses only the largest (by area) peak, Return Packet:",
			AnalyzeFractionsApp[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],TopPeaks->1, Upload->False,App->False,Output->Packet],
			validAnalysisPacketP[Object[Analysis, Fractions],
				{
					Replace[FractionsPicked]->{{40.73716667`,41.45716667`,"1C5"},{41.45716667`,42.17733333`,"1C6"},{42.17733333`,42.89733333`,"1C7"}}
				},
				ResolvedOptions->{OverlappingPeaks->PacketP[Object[Analysis,Peaks]],TopPeaks->1,Upload->False,App->False,Output->Packet,Include->{},Exclude->{},Domain->All,AppTest->False},
				Round -> 12
			],
			TimeConstraint -> 1000
		],
		Example[{Options,TopPeaks,"Use the 2 largest peaks:"},
			AnalyzeFractionsApp[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],OverlappingPeaks->Download[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],AbsorbancePeaksAnalyses[[-1]]],TopPeaks->2],
			{Link[Object[Sample, _String]],
				Link[Object[Sample, _String]],
				Link[Object[Sample, _String]],
				Link[Object[Sample, _String]],
				Link[Object[Sample, _String]]},
			EquivalenceFunction->RoundMatchQ[12],
			TimeConstraint -> 1000,
			Stubs :> {
				AnalyzeFractionsApp[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],OverlappingPeaks->Download[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],AbsorbancePeaksAnalyses[[-1]]],TopPeaks->2]
						= AnalyzeFractionsApp[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],OverlappingPeaks->Download[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],AbsorbancePeaksAnalyses[[-1]]],TopPeaks->2, Upload->False, App -> False]
			}
		],
		Test["Use the 2 largest peaks, Return Packet:",
			AnalyzeFractionsApp[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],TopPeaks->2, Upload->False,App->False,Output->Packet],
			validAnalysisPacketP[Object[Analysis, Fractions],
				{
					Replace[FractionsPicked]->{{40.73716667`,41.45716667`,"1C5"},{41.45716667`,42.17733333`,"1C6"},{42.17733333`,42.89733333`,"1C7"},{42.89733333`,43.6175`,"1C8"},{43.6175`,44.0815`,"1C9"}}
				},
				ResolvedOptions->{OverlappingPeaks->PacketP[Object[Analysis,Peaks]],TopPeaks->2,Upload->False,App->False,Output->Packet,Include->{},Exclude->{},Domain->All,AppTest->False},
				Round -> 12
			],
			TimeConstraint -> 1000
		],
		Example[{Options,TopPeaks,"Use TopPeaks->All to use peaks:"},
			AnalyzeFractionsApp[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],TopPeaks->All],
			{Link[Object[Sample, _String]],
				Link[Object[Sample, _String]],
				Link[Object[Sample, _String]],
				Link[Object[Sample, _String]],
				Link[Object[Sample, _String]]},
			TimeConstraint -> 1000,
			Stubs :> {
				AnalyzeFractionsApp[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],TopPeaks->All]
						= AnalyzeFractionsApp[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],TopPeaks->All, Upload->False, App -> False]
			}
		],
		Test["Use TopPeaks->All to use peaks, Output->Packet:",
			AnalyzeFractionsApp[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],TopPeaks->All, Upload->False,App->False,Output->Packet],
			validAnalysisPacketP[Object[Analysis, Fractions],
				{
					Replace[FractionsPicked]->{{40.73716667`,41.45716667`,"1C5"},{41.45716667`,42.17733333`,"1C6"},{42.17733333`,42.89733333`,"1C7"},{42.89733333`,43.6175`,"1C8"},{43.6175`,44.0815`,"1C9"}}
				},
				ResolvedOptions->{OverlappingPeaks->PacketP[Object[Analysis,Peaks]],TopPeaks->All,Upload->False,App->False,Output->Packet,Include->{},Exclude->{},Domain->All,AppTest->False},
				Round -> 12
			],
			TimeConstraint -> 1000
		],
		Example[{Options,TopPeaks,"Use TopPeaks->None or TopPeaks->0 to use no peaks:"},
			AnalyzeFractionsApp[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],TopPeaks->None],
			{},
			TimeConstraint -> 1000,
			Stubs :> {
				AnalyzeFractionsApp[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],TopPeaks->None]
						= AnalyzeFractionsApp[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],TopPeaks->None, Upload->False, App -> False]
			}
		],
		Test["Use TopPeaks->None or TopPeaks->0 to use no peaks, Return Packet:",
			AnalyzeFractionsApp[Object[Data, Chromatography, "id:1ZA60vwj7GRE"],TopPeaks->None, Upload->False,App->False,Output->Packet],
			validAnalysisPacketP[Object[Analysis, Fractions],
				{
					Replace[FractionsPicked] -> {{Null,Null,Null}}
				},
				ResolvedOptions->{OverlappingPeaks->PacketP[Object[Analysis,Peaks]],TopPeaks->None,Upload->False,App->False,Output->Packet,Include->{},Exclude->{},Domain->All,AppTest->False},
				Round -> 12
			],
			TimeConstraint -> 1000
		],


		Example[{Options, Output, "Return only the picked fractions:"},
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Output->FractionsPicked],
			{{27.71566667`,29.516`,"2A10"},{29.516`,30.`,"2A11"}},
			EquivalenceFunction->RoundMatchQ[12],
			TimeConstraint -> 1000,
			Stubs :> {
				AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Output->FractionsPicked]
						= AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"], Upload->False,Output->FractionsPicked, App -> False]
			}
		],
		Example[{Options, Output, "Return the picked fractions and the reference:"},
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"], Output -> {FractionsPicked, Reference}],
			{{{27.71566667`,29.516`,"2A10"},{29.516`,30.`,"2A11"}},{Link[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"], FractionPickingAnalysis]}},
			EquivalenceFunction->RoundMatchQ[12],
			TimeConstraint -> 1000,
			Stubs :> {
				AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"], Output -> {FractionsPicked, Reference}]
						= AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"], Upload->False, Output -> {FractionsPicked, Reference}, App -> False]
			}
		],
		Example[{Options, Output, "Return the entire packet:"},
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Output->Packet],
			validAnalysisPacketP[Object[Analysis, Fractions],
				{
					Replace[FractionsPicked] -> {{27.71566667`,29.516`,"2A10"},{29.516`,30.`,"2A11"}},
					Replace[Reference] -> {Link[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],FractionPickingAnalysis]}
				},
				ResolvedOptions -> {Upload->False,Output->Packet,OverlappingPeaks->PacketP[Object[Analysis,Peaks]],TopPeaks->1,Include->{},Exclude->{},Domain->All},
				NullFields -> {TheoreticalFractionVolumes},
				Round -> 12
			],
			TimeConstraint -> 1000,
			Stubs :> {
				AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Output->Packet]
						= AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"], Upload->False,Output->Packet, App -> False]
			}
		],


		Example[{Options,Options,"Use options from previous fractions analysis:"},
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Options->Object[Analysis, Fractions, "id:zGj91a7bxljx"]],
			{Link[Object[Sample, _String]],Link[Object[Sample, _String]],Link[Object[Sample, _String]],Link[Object[Sample, _String]],Link[Object[Sample, _String]]},
			TimeConstraint -> 1000,
			Stubs :> {
				AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Options->Object[Analysis, Fractions, "id:zGj91a7bxljx"]]
						= AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"], Upload->False,Options->Object[Analysis, Fractions, "id:zGj91a7bxljx"], App -> False]
			}
		],
		Example[{Options,Options,"Explicitly specify TopPeaks option, and pull remaining options from previous fractions analysis:"},
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Options->Object[Analysis, Fractions, "id:zGj91a7bxljx"],TopPeaks->2],
			{Link[Object[Sample, _String]],Link[Object[Sample, _String]],Link[Object[Sample, _String]]},
			TimeConstraint -> 1000,
			Stubs :> {
				AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Options->Object[Analysis, Fractions, "id:zGj91a7bxljx"],TopPeaks->2]
						= AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"], Upload->False,Options->Object[Analysis, Fractions, "id:zGj91a7bxljx"],TopPeaks->2, App -> False]
			}
		],
		Test["Explicitly specify TopPeaks option, and pull remaining options from previous fractions analysis:",
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"], Upload->False,Output->Packet,Options->Object[Analysis, Fractions, "id:zGj91a7bxljx"],TopPeaks->2, App -> False],
			validAnalysisPacketP[Object[Analysis, Fractions],
				{},
				ResolvedOptions -> {Options->Object[Analysis, Fractions, "id:zGj91a7bxljx"],TopPeaks->2},
				Round -> 12
			],
			TimeConstraint -> 1000
		],



		Example[{Options,App,"Set App -> True to launch interactive app:"},
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"]],
			Null,
			Stubs :> {AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"]] = Null}
		],


	(*
			---------- MESSAGES -------------
		*)
		Example[{Messages,"InvalidPosition","Positions to Include or Exclude cannot be greater than the number of collected fractions:"},
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Exclude->{100},Include->{200}],
			{Link[Object[Sample, _String]],Link[Object[Sample, _String]]},
			Messages:>{Warning::InvalidPosition,Warning::InvalidPosition},
			Stubs :> {
				AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Exclude->{100},Include->{200}]
						= AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Exclude->{100},Include->{200},Upload->False, App -> False]
			}
		],

	(*
			---------- ISSUES -------------
		*)
		Example[{Issues,"Include option overrides Exclude option because of the order in which the filtering occurs:"},
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Output->FractionsPicked,Exclude->{28.5 Minute},Include->{28.5 Minute}],
			{{27.71566667`,29.516`,"2A10"},{29.516`,30.`,"2A11"}},
			TimeConstraint -> 1000,
			Stubs :> {
				AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Output->FractionsPicked,Exclude->{28.5 Minute},Include->{28.5 Minute}]
						= AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Output->FractionsPicked,Exclude->{28.5 Minute},Include->{28.5 Minute},Upload->False, App -> False]
			}
		],



	(*
			---------------- TESTS --------------------
		*)
		Test["App short-circuits to return Null if no fractions picked in data:",
			AnalyzeFractionsApp[Object[Data, Chromatography, "id:wqW9BP4YDpjV"],Upload->False,App->True],
			Null
		],

		Test["Upload the analysis packet if Upload -> True:",
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Upload->True,App->False,Output->Object],
			ObjectReferenceP[Object[Analysis,Fractions]],
			Stubs:>{
				Print[_]:=Null
			},
			TimeConstraint -> 1000
		],

		Test["UnresolvedOptions records all input options in their original form, while ResolvedOptions stores all parsed options that are actually applied to the analysis:",
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"], pony->"boop", Include -> "dog", Upload -> False, App -> False, Output->Packet],
			validAnalysisPacketP[Object[Analysis, Fractions],
				{
					Replace[FractionsPicked]->{{27.71566667`,29.516`,"2A10"},{29.516`,30.`,"2A11"}},
					Replace[Reference] -> {Link[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],FractionPickingAnalysis]},
					UnresolvedOptions->{pony->"boop",Include -> "dog",Upload->False,App->False,Output->Packet}
				},
				ResolvedOptions -> {Upload->False,App->False,Output->Packet,OverlappingPeaks->PacketP[Object[Analysis,Peaks]],Include->{},Exclude->{},Domain->All,TopPeaks->1,AppTest->False},
				Round -> 12
			],
			Messages :> {Warning::UnknownOption, Warning::OptionPattern},
			TimeConstraint -> 1000
		],

		Test["Given packet:",
			AnalyzeFractionsApp[Download[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"]], Upload->False, App -> False],
			{Link[Object[Sample, _String]],	Link[Object[Sample, _String]]},
			TimeConstraint -> 1000
		],
		Test["Given link:",
			AnalyzeFractionsApp[Link[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"]], Upload->False, App -> False],
			{Link[Object[Sample, _String]],	Link[Object[Sample, _String]]},
			TimeConstraint -> 1000
		],



	(*
			--------------------- APP TESTING  --------------------
		*)
		Test["App Cancel Button:",
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Upload->False,App->True,AppTest->Cancel],
			$Canceled
		],
		Test["App Skip Button:",
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Upload->False,App->True,AppTest->Skip],
			Null
		],
		Test["App Return Button:",
			AnalyzeFractionsApp[Object[Data, Chromatography, "Test Data Object for AnalyzeFractionsApp"],Upload->False,App->True,AppTest->Return],
			{Link[Object[Sample, _String]],Link[Object[Sample, _String]]},
			TimeConstraint -> 1000
		]


	}
];


(* ::Section:: *)
(*End Test Package*)
