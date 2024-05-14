(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Ladder: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*AnalyzeLadder*)


(* ::Subsubsection:: *)
(*AnalyzeLadder*)


DefineTests[
	AnalyzeLadder, {

	(* ---- Basic ---- *)
	Example[{Basic, "Fit standard curve to peaks analysis:"},
		PlotLadder@AnalyzeLadder[Object[Analysis, Peaks, "id:6V0npvmwxExw"]],
		ValidGraphicsP[]
	],
	Test["Fit standard curve to peaks analysis, Return Packet:",
		AnalyzeLadder[Object[Analysis, Peaks, "id:vXl9j5qErJak"], Upload->False, FitNormalization->False],
		validAnalysisPacketP[Object[Analysis, Ladder],
			{
				Replace[FragmentPeaks] -> {
					{10,11.1`}, {15,21.126667`}, {20,25.253333`}, {25,28.873333`}, {30,30.98`}, {35,33.166667`},
					{40,34.46`}, {45,35.82`}, {50,36.706667`}, {60,38.28`}, {70,39.513333`}, {80,40.466667`}
				},
				Replace[PeaksAnalysis] -> LinkP[Object[Analysis, Peaks],StandardAnalysis],
				Replace[Reference] -> LinkP[Object[Data, Chromatography], StandardAnalyses],
				Replace[ReferenceField] -> Absorbance
			},
			ResolvedOptions -> {
				Upload -> False,
				ReferenceField -> Absorbance,
				Align -> Minimum,
				Reverse -> False,
				Function -> Size,
				FitType -> Exponential,
				FitNormalization -> False,
				ExpectedSizes -> {10,15,20,25,30,35,40,45,50,60,70,80,90,100}*Nucleotide},
			NonNullFields -> {ExpectedSizeFunction, ExpectedPositionFunction},
			Round -> 12
		],
		Messages :> {Warning::DefaultSizes}
	],


	Example[{Basic, "Fit standard curve to chromatogram peaks:"},
		PlotLadder@AnalyzeLadder[Object[Data, Chromatography, "id:qdkmxzqoEzD1"]],
		ValidGraphicsP[]
	],
	Test["Fit standard curve to chromatogram peaks, Return Packet:",
		AnalyzeLadder[Object[Data, Chromatography, "id:jLq9jXY4Rae1"], Upload -> False,FitNormalization->False],
		validAnalysisPacketP[Object[Analysis, Ladder],
			{
				Replace[FragmentPeaks] -> {
					{10,7.853333`}, {15,11.52`}, {20,13.58`}, {25,14.666667`}, {30,15.333333`}, {35,25.24`}
				},
				Replace[PeaksAnalysis] -> LinkP[Object[Analysis, Peaks], StandardAnalysis],
				Replace[Reference] -> LinkP[Object[Data, Chromatography], StandardAnalyses],
				Replace[ReferenceField] -> Absorbance
			},
			ResolvedOptions -> {
				ReferenceField -> Absorbance,
				Align -> Minimum,
				Reverse -> False,
				Function -> Size,
				FitType -> Exponential,
				FitNormalization -> False,
				Template -> Null,
				Upload -> False
			},
			NonNullFields -> {ExpectedSizeFunction, ExpectedPositionFunction},
			Round -> 12
		],
		Messages:>{Warning::DefaultSizes}
	],

	Example[{Basic, "Fit standard curve to PAGE lane intensity peaks:"},
		PlotLadder@AnalyzeLadder[Object[Data, PAGE, "id:Z1lqpMzaGPWO"]],
		ValidGraphicsP[]
	],
	Test["Fit standard curve to PAGE lane intensity peaks, Return Packet:",
		AnalyzeLadder[Object[Data, PAGE, "id:GmzlKjP8j0Yp"], Upload -> False, FitNormalization->False],
		Analysis`Private`validAnalysisPacketP[Object[Analysis, Ladder],
			{
				Replace[FragmentPeaks] ->{
					{300, 143.63636363636363`}, {200, 162.72727272727275`},
					{150, 198.1818181818182`}, {100, 206.36363636363637`},
					{75, 225.45454545454547`}, {50, 233.63636363636363`},
					{35, 258.1818181818182`}, {25, 278.1818181818182`},
					{20, 353.6363636363637`}, {15, 365.4545454545455`}, {10, 398.1818181818182`}
				},
				Replace[PeaksAnalysis] -> LinkP[Object[Analysis, Peaks], StandardAnalysis],
				Replace[Reference] -> LinkP[Object[Data, PAGE],LadderAnalyses],
				Replace[ReferenceField] -> OptimalLaneIntensity
			},
			ResolvedOptions -> {
				ReferenceField -> OptimalLaneIntensity,
				Align -> Minimum,
				Reverse -> True,
				Function -> Size,
				FitType -> Exponential,
				FitNormalization -> False,
				Template -> Null,
				Upload -> False
			},
			NonNullFields -> {ExpectedSizeFunction, ExpectedPositionFunction},
			Round -> 12
		]
	],

	Example[{Basic, "Plot a standard fit:"},
		PlotLadder[AnalyzeLadder[Object[Analysis, Peaks, "id:6V0npvmwxExw"]],PlotType->Fit],
		_?ValidGraphicsQ
	],
	Example[{Basic, "Plot standard sizes associated with their peaks:"},
		PlotLadder[AnalyzeLadder[Object[Analysis, Peaks, "id:6V0npvmwxExw"]],PlotType->Peaks],
		_?ValidGraphicsQ
	],


(* --------- ADDITIONAL ------------ *)

	Example[{Additional, "Fit standard curve to Western MassSpectrum peaks:"},
		PlotLadder@AnalyzeLadder[Object[Data, Western, "id:xRO9n3vk9O6x"],
			ExpectedSizes -> {12, 40, 66, 116, 180, 230}*Kilogram/Mole,
			FitType -> Linear],
		ValidGraphicsP[]
	],

	Example[{Additional, "Fit standard curve to CESDS peaks:"},
		PlotLadder@AnalyzeLadder[Object[Data, CapillaryGelElectrophoresisSDS, "id:zGj91a7pxlkv"]],
		ValidGraphicsP[]
	],
	Test["ExpectedSizes is automatically resolved for CESDS data:",
		Lookup[
			Analysis`Private`stripAppendReplaceKeyHeads@AnalyzeLadder[Object[Data, CapillaryGelElectrophoresisSDS, "id:zGj91a7pxlkv"],Upload->False],
			{Sizes,SizeUnit}
		],
		{
			{10, 20, 33, 55, 103, 178, 270},
			Quantity[1, ("Kilograms")/("Moles")]
		}
	],

	Example[{Additional, "Analyze a list of peaks objects:"},
		PlotLadder/@AnalyzeLadder[{Object[Analysis, Peaks, "id:vXl9j5qErJak"],Object[Analysis, Peaks, "id:bq9LA0dB4nDv"]}],
		{ValidGraphicsP[], ValidGraphicsP[]},
		Messages:>{Warning::DefaultSizes}
	],

	Example[{Additional, "Analyze a list of data objects:"},
		PlotLadder/@AnalyzeLadder[{Object[Data, Chromatography, "id:AEqRl954MZr5"], Object[Data, Chromatography, "id:jLq9jXY4Rae1"]}],
		{ValidGraphicsP[], ValidGraphicsP[]},
		Messages:>{Warning::DefaultSizes}
	],


	(* ---- Options ---- *)

	Example[{Options, ReferenceField, "Use the peaks from the Absorbance field of the data object:"},
		AnalyzeLadder[Object[Data, Chromatography, "id:jLq9jXY4Rae1"], ReferenceField -> Absorbance, FitType -> Linear][ExpectedSizeFunction],
		QuantityFunction[0.96746 + 1.46491 #1 &, {Quantity[1, "Minutes"]},Quantity[1, IndependentUnit["Nucleotides"]]],
		EquivalenceFunction -> RoundMatchQ[6,Force->True],
		Messages:>{Warning::DefaultSizes}
	],
	Test["Use the peaks from the Absorbance field of the data object:",
		AnalyzeLadder[Object[Data, Chromatography, "id:jLq9jXY4Rae1"], Upload -> False, ReferenceField -> Absorbance, FitType -> Linear],
		validAnalysisPacketP[Object[Analysis, Ladder],
			{
				Replace[FragmentPeaks] -> {{10,7.853333`},{15,11.52`},{20,13.58`},{25,14.666667`},{30,15.333333`},{35,25.24`}},
				Replace[PeaksAnalysis] -> LinkP[Object[Analysis, Peaks],StandardAnalysis],
				Replace[Reference] -> LinkP[Object[Data, Chromatography],StandardAnalyses],
				Replace[ReferenceField] -> Absorbance
			},
			ResolvedOptions -> {
				Upload -> False,
				ReferenceField -> Absorbance,
				Align -> Minimum,
				Reverse -> False,
				Function -> Size,
				FitType -> Linear,
				FitNormalization -> False,
				ExpectedSizes -> {10,15,20,25,30,35,40,45,50,60,70,80,90,100}*Nucleotide
			},
			NonNullFields -> {ExpectedSizeFunction, ExpectedPositionFunction},
			Round -> 12
		],
		Messages:>{Warning::DefaultSizes}
	],

	Example[{Options, ExpectedSizes, "Specify standard sizes Model[Sample, StockSolution, Standard]:"},
		PlotLadder@AnalyzeLadder[Object[Analysis, Peaks, "id:bq9LA0dB4nDv"], ExpectedSizes->Model[Sample,StockSolution,Standard,"id:zGj91a7wobEe"]],
		ValidGraphicsP[]
	],
	Example[{Options, PlotType, "Display peaks data on the preview plot:"},
		PlotLadder@AnalyzeLadder[Object[Analysis, Peaks, "id:bq9LA0dB4nDv"],
			ExpectedSizes->Model[Sample,StockSolution,Standard,"id:zGj91a7wobEe"],
			PlotType->Peaks
		],
		ValidGraphicsP[]
	],
	Test["Specify standard sizes Model[Sample, StockSolution, Standard]:",
		AnalyzeLadder[Object[Analysis, Peaks, "id:bq9LA0dB4nDv"],
			ExpectedSizes->Model[Sample,StockSolution,Standard,"id:zGj91a7wobEe"],
			Upload->False, FitNormalization->False
		],
		Analysis`Private`validAnalysisPacketP[Object[Analysis, Ladder],
			{
				Replace[FragmentPeaks] -> {{10,7.853333`},{15,11.52`},{20,13.58`},{25,14.666667`},{30,15.333333`},{35,25.24`}},
				Replace[PeaksAnalysis] -> LinkP[Object[Analysis, Peaks], StandardAnalysis],
				Replace[Reference] -> LinkP[Object[Data, Chromatography], StandardAnalyses],
				Replace[ReferenceField] -> Absorbance,
				Replace[Ladder] -> Link[Model[Sample, StockSolution, Standard, _String], LadderAnalyses]
			},
			ResolvedOptions -> {
				ExpectedSizes -> {10,15,20,25,30,35,40,45,50,60,70,80,90,100}*Nucleotide,
				Upload->False,
				ReferenceField->Absorbance,
				Align->Minimum,
				Reverse->False,
				Function->Size,
				FitType->Exponential,
				FitNormalization->False
			},
			NonNullFields -> {ExpectedSizeFunction, ExpectedPositionFunction},
			Round -> 12
		]
	],

	Example[{Options, ExpectedSizes, "Specify standard sizes:"},
		PlotLadder@AnalyzeLadder[Object[Analysis, Peaks, "id:bq9LA0dB4nDv"], ExpectedSizes->{10,15,20,25,30,35,40,45,50,60,70,80,90,100}*Nucleotide],
		ValidGraphicsP[]
	],
	Test["Specify standard sizes:",
		AnalyzeLadder[Object[Analysis, Peaks, "id:bq9LA0dB4nDv"],
			ExpectedSizes->{10,15,20,25,30,35,40,45,50,60,70,80,90,100}*Nucleotide,
			Upload->False,FitNormalization->False
		],
		validAnalysisPacketP[Object[Analysis, Ladder],
			{
				Replace[FragmentPeaks] -> {{10,7.853333`},{15,11.52`},{20,13.58`},{25,14.666667`},{30,15.333333`},{35,25.24`}},
				Replace[PeaksAnalysis] -> LinkP[Object[Analysis,Peaks],StandardAnalysis],
				Replace[Reference] -> LinkP[Object[Data,Chromatography], StandardAnalyses],
				Replace[ReferenceField] -> Absorbance
			},
			ResolvedOptions -> {
				ExpectedSizes -> {10,15,20,25,30,35,40,45,50,60,70,80,90,100}*Nucleotide,
				Upload -> False,
				ReferenceField -> Absorbance,
				Align -> Minimum,
				Reverse -> False,
				Function -> Size,
				FitType -> Exponential,
				FitNormalization -> False
			},
			NonNullFields -> {ExpectedSizeFunction, ExpectedPositionFunction},
			Round -> 12
		]
	],

	Example[{Options, ExpectedSizes, "Specify a smaller standard set:"},
		PlotLadder@AnalyzeLadder[Object[Analysis, Peaks, "id:bq9LA0dB4nDv"], ExpectedSizes->{10,15,20,25,30,35,40,45,50}*Nucleotide],
		ValidGraphicsP[]
	],
	Test["Specify a smaller standard set:",
		AnalyzeLadder[Object[Analysis, Peaks, "id:bq9LA0dB4nDv"],
			ExpectedSizes->{10,15,20,25,30,35,40,45,50}*Nucleotide,
			Upload->False,FitNormalization->False
		],
		validAnalysisPacketP[Object[Analysis, Ladder],
			{
				Replace[FragmentPeaks] -> {{10,7.853333`},{15,11.52`},{20,13.58`},{25,14.666667`},{30,15.333333`},{35,25.24`}},
				Replace[PeaksAnalysis] -> LinkP[Object[Analysis, Peaks],StandardAnalysis],
				Replace[Reference] -> LinkP[Object[Data, Chromatography],StandardAnalyses],
				Replace[ReferenceField] -> Absorbance
			},
			ResolvedOptions -> {
				ExpectedSizes -> {10,15,20,25,30,35,40,45,50}*Nucleotide,
				Upload -> False,
				ReferenceField -> Absorbance,
				Align -> Minimum,
				Reverse -> False,
				Function -> Size,
				FitType -> Exponential,
				FitNormalization -> False
			},
			NonNullFields -> {ExpectedSizeFunction, ExpectedPositionFunction},
			Round -> 12
		]
	],

	Example[{Options, Align, "Associate right:"},
		PlotLadder@AnalyzeLadder[
			Object[Analysis, Peaks, "id:bq9LA0dB4nDv"],
			ExpectedSizes->{10,15,20,25,30,35,40,45,50,60,70,80,90,100}*Nucleotide,
			Align->Maximum
		],
		ValidGraphicsP[]
	],
	Test["Associate right:",
		AnalyzeLadder[
			Object[Analysis, Peaks, "id:bq9LA0dB4nDv"],
			ExpectedSizes->{10,15,20,25,30,35,40,45,50,60,70,80,90,100}*Nucleotide,
			Upload->False,
			Align->Maximum,
			FitNormalization->False
		],
		validAnalysisPacketP[Object[Analysis, Ladder],
			{
				Replace[FragmentPeaks] -> {{50,7.853333`},{60,11.52`},{70,13.58`},{80,14.666667`},{90,15.333333`},{100,25.24`}},
				Replace[PeaksAnalysis] -> LinkP[Object[Analysis, Peaks],StandardAnalysis],
				Replace[Reference] -> LinkP[Object[Data, Chromatography],StandardAnalyses],
				Replace[ReferenceField] -> Absorbance
			},
			ResolvedOptions -> {
				ExpectedSizes -> {10,15,20,25,30,35,40,45,50,60,70,80,90,100}*Nucleotide,
				Upload -> False,
				Align -> Maximum,
				ReferenceField -> Absorbance,
				Reverse -> False,
				Function -> Size,
				FitType -> Exponential,
				FitNormalization -> False
			},
			NonNullFields -> {ExpectedSizeFunction, ExpectedPositionFunction},
			Round -> 12
		]
	],

	Example[{Options, Align, "Align ladder starting with minimum peak position, and reverse ladder:"},
		PlotLadder@AnalyzeLadder[
			Object[Analysis, Peaks, "id:bq9LA0dB4nDv"],
			ExpectedSizes->{10,15,20,25,30,35,40,45,50,60,70,80,90,100}*Nucleotide,
			Align->Maximum,
			Reverse -> True],
		ValidGraphicsP[]
	],
	Test["Associate right and reverse:",
		AnalyzeLadder[
			Object[Analysis, Peaks, "id:bq9LA0dB4nDv"],
			ExpectedSizes->{10,15,20,25,30,35,40,45,50,60,70,80,90,100}*Nucleotide,
			Upload->False,
			Align->Maximum,
			Reverse -> True,
			FitNormalization->False
		],
		validAnalysisPacketP[Object[Analysis, Ladder],
			{
				Replace[FragmentPeaks] -> {{35,7.853333`},{30,11.52`},{25,13.58`},{20,14.666667`},{15,15.333333`},{10,25.24`}},
				Replace[PeaksAnalysis] -> LinkP[Object[Analysis, Peaks],StandardAnalysis],
				Replace[Reference] -> LinkP[Object[Data, Chromatography],StandardAnalyses],
				Replace[ReferenceField] -> Absorbance
			},
			ResolvedOptions -> {
				ExpectedSizes -> {10,15,20,25,30,35,40,45,50,60,70,80,90,100}*Nucleotide,
				Upload -> False,
				Align -> Maximum,
				Reverse -> True,
				ReferenceField -> Absorbance,
				Function -> Size,
				FitType -> Exponential,
				FitNormalization -> False
			},
			NonNullFields -> {ExpectedSize, ExpectedPosition},
			Round -> 12
		]
	],

	Example[{Options, Align, "Comparing alignment at maximum and minimum:"},
		Grid[{{
				PlotLadder[
					AnalyzeLadder[
						Object[Analysis, Peaks, "id:vXl9j5qErJak"],
						ExpectedSizes->{10,15,20,25,30,35,40}*Nucleotide,
						Align->Minimum
					],
					PlotType->Peaks,
					PlotLabel->Style["Ladder sizes aligned starting at minimum peak position",16]
				],
				PlotLadder[
					AnalyzeLadder[
						Object[Analysis, Peaks, "id:vXl9j5qErJak"],
						ExpectedSizes->{10,15,20,25,30,35,40}*Nucleotide,
						Align->Maximum
					],
				PlotType->Peaks,
				PlotLabel->Style["Ladder sizes aligned starting at maximum peak position",16]
			]
		}}],
		Grid[{{ValidGraphicsP[], ValidGraphicsP[]}}]
	],



	Example[{Options, Reverse, "Reverse:"},
		PlotLadder@AnalyzeLadder[Object[Analysis, Peaks, "id:bq9LA0dB4nDv"],ExpectedSizes->{10,15,20,25,30,35,40,45,50,60,70,80,90,100}*Nucleotide, Reverse->True,FitType->Linear],
		ValidGraphicsP[]
	],
	Test["Reverse:",
		AnalyzeLadder[
			Object[Analysis, Peaks, "id:bq9LA0dB4nDv"],
			ExpectedSizes->{10,15,20,25,30,35,40,45,50,60,70,80,90,100}*Nucleotide,
			Upload->False,
			Reverse->True,
			FitType->Linear
		],
		validAnalysisPacketP[Object[Analysis, Ladder],
			{
				Replace[FragmentPeaks] -> {{100,7.853333`},{90,11.52`},{80,13.58`},{70,14.666667`},{60,15.333333`},{50,25.24`}},
				Replace[PeaksAnalysis] -> LinkP[Object[Analysis, Peaks],StandardAnalysis],
				Replace[Reference] -> LinkP[Object[Data, Chromatography],StandardAnalyses],
				Replace[ReferenceField] -> Absorbance
			},
			ResolvedOptions -> {
				ExpectedSizes -> {10,15,20,25,30,35,40,45,50,60,70,80,90,100}*Nucleotide,
				Upload -> False,
				Reverse -> True,
				ReferenceField -> Absorbance,
				Align -> Minimum,
				Function -> Size,
				FitType -> Linear,
				FitNormalization -> False
			},
			NonNullFields -> {ExpectedSizeFunction, ExpectedPositionFunction},
			Round -> 12
		]
	],

	(* 30 *)
	Example[{Options, Reverse, "Comparing Reverse options:"},
		Grid[{{
			PlotLadder[
				AnalyzeLadder[
					Object[Analysis, Peaks, "id:vXl9j5qErJak"],
					ExpectedSizes->{10,15,20,25,30,35,40,45,50,60,70,80,90,100}*Nucleotide,
					Reverse->False
				],
				PlotType->Peaks,PlotLabel->"Ladder sizes ordered as given"
			],
			PlotLadder[
				AnalyzeLadder[
					Object[Analysis, Peaks, "id:vXl9j5qErJak"],
					ExpectedSizes->{10,15,20,25,30,35,40,45,50,60,70,80,90,100}*Nucleotide,
					Reverse->True
				],
				PlotType->Peaks,
				PlotLabel->"Ladder size order reversed"
			]
		}}],
		Grid[{{ValidGraphicsP[], ValidGraphicsP[]}}]
	],



	Example[{Options, FitType, "Fit linear ExpectedSize:"},
		PlotLadder@AnalyzeLadder[
			Object[Analysis, Peaks, "id:bq9LA0dB4nDv"],
			ExpectedSizes->{10,15,20,25,30,35,40,45,50,60,70,80,90,100}*Nucleotide,
			FitType->Linear
		],
		ValidGraphicsP[]
	],
	Test["Fit linear ExpectedSize:",
		AnalyzeLadder[
			Object[Analysis, Peaks, "id:bq9LA0dB4nDv"],
			ExpectedSizes->{10,15,20,25,30,35,40,45,50,60,70,80,90,100}*Nucleotide,
			Upload->False,
			FitType->Linear
		],
		validAnalysisPacketP[Object[Analysis, Ladder],
			{
				Replace[FragmentPeaks] -> {{10,7.853333`},{15,11.52`},{20,13.58`},{25,14.666667`},{30,15.333333`},{35,25.24`}},
				Replace[PeaksAnalysis] -> LinkP[Object[Analysis, Peaks],StandardAnalysis],
				Replace[Reference] -> LinkP[Object[Data, Chromatography],StandardAnalyses],
				Replace[ReferenceField] -> Absorbance
			},
			ResolvedOptions -> {
				ExpectedSizes -> {10,15,20,25,30,35,40,45,50,60,70,80,90,100}*Nucleotide,
				Upload->False,
				FitType->Linear,
				ReferenceField->Absorbance,
				Align->Minimum,
				Reverse->False,
				Function->Size
			},
			NonNullFields -> {ExpectedSizeFunction, ExpectedPositionFunction},
			Round -> 12
		]
	],

	Example[{Options, FitType, "Fit cubic ExpectedSize:"},
		PlotLadder@AnalyzeLadder[
			Object[Analysis, Peaks, "id:bq9LA0dB4nDv"],
			ExpectedSizes->{10,15,20,25,30,35,40,45,50,60,70,80,90,100}*Nucleotide,
			FitType->Cubic
		],
		ValidGraphicsP[]
		(*,Messages:>{Warning::DefaultSizes}*)
	],
	Test["Fit cubic ExpectedSize:",
		AnalyzeLadder[
			Object[Analysis, Peaks, "id:bq9LA0dB4nDv"],
			ExpectedSizes->{10,15,20,25,30,35,40,45,50,60,70,80,90,100}*Nucleotide,
			Upload->False,
			FitType->Cubic
		],
		validAnalysisPacketP[Object[Analysis, Ladder],
			{
				Replace[FragmentPeaks] -> {{10,7.853333`},{15,11.52`},{20,13.58`},{25,14.666667`},{30,15.333333`},{35,25.24`}},
				Replace[PeaksAnalysis] -> LinkP[Object[Analysis, Peaks],StandardAnalysis],
				Replace[Reference] -> LinkP[Object[Data, Chromatography],StandardAnalyses],
				Replace[ReferenceField] -> Absorbance
			},
			ResolvedOptions -> {
				ExpectedSizes->{10,15,20,25,30,35,40,45,50,60,70,80,90,100}*Nucleotide,
				Upload->False,
				FitType->Cubic,
				ReferenceField->Absorbance,
				Align->Minimum,
				Reverse->False,
				Function->Size,
				FitNormalization->False
			},
			NonNullFields -> {ExpectedSizeFunction, ExpectedPositionFunction},
			Round -> 12
		]
	],


	Example[{Options, Function, "Fit ExpectedPosition function:"},
		AnalyzeLadder[Object[Analysis, Peaks, "id:bq9LA0dB4nDv"], Function->Position][ExpectedPosition],
		_QuantityFunction,
		EquivalenceFunction -> RoundMatchQ[10],
		Messages:>{Warning::DefaultSizes}
	],
	Test["Set Fit to find the ExpectedPosition:",
		AnalyzeLadder[
			Object[Analysis, Peaks, "id:bq9LA0dB4nDv"],
			ExpectedSizes->{10,15,20,25,30,35,40,45,50,60,70,80,90,100}*Nucleotide,
			Upload->False,
			Function->Position,
			FitNormalization->False
		],
		validAnalysisPacketP[Object[Analysis, Ladder],
			{
				Replace[FragmentPeaks] -> {{10,7.853333`},{15,11.52`},{20,13.58`},{25,14.666667`},{30,15.333333`},{35,25.24`}},
				Replace[PeaksAnalysis] -> LinkP[Object[Analysis, Peaks],StandardAnalysis],
				Replace[Reference] -> LinkP[Object[Data, Chromatography],StandardAnalyses],
				Replace[ReferenceField] -> Absorbance
			},
			ResolvedOptions -> {
				ExpectedSizes->{10,15,20,25,30,35,40,45,50,60,70,80,90,100}*Nucleotide,
				Upload->False,
				Function->Position,
				ReferenceField->Absorbance,
				Align->Minimum,
				Reverse->False,
				FitType->Exponential,
				FitNormalization->False
			},
			NonNullFields -> {ExpectedSizeFunction, ExpectedPositionFunction},
			Round -> 12
		]
	],
	Example[{Options, Function, "Fit ExpectedPosition function and return inverse function ExpectedSize:"},
		AnalyzeLadder[Object[Analysis, Peaks, "id:bq9LA0dB4nDv"], Function->Position][ExpectedSize],
		QuantityFunctionP[],
		Messages:>{Warning::DefaultSizes}
	],

	Example[{Options,Template,"Use options from previous ladder analysis:"},
		PlotLadder@AnalyzeLadder[
			Object[Analysis, Peaks, "id:vXl9j5qErJak"],
			Upload->False,
			Template->Object[Analysis, Ladder, theTemplateObjectID]
		],
		ValidGraphicsP[],
		SetUp :> (
			theTemplateObject = Upload[
				<|Type -> Object[Analysis, Ladder],
				UnresolvedOptions -> {
					ReferenceField -> Title,
					Output -> {Preview, Options}
				},
				ResolvedOptions -> {
					ReferenceField -> Absorbance,
					Align -> Minimum,
					Reverse -> False,
					Function -> Size,
					FitType -> Exponential,
					ExpectedSizes -> {
						Quantity[10, IndependentUnit["Nucleotides"]],
						Quantity[15, IndependentUnit["Nucleotides"]],
						Quantity[20, IndependentUnit["Nucleotides"]],
						Quantity[25, IndependentUnit["Nucleotides"]],
						Quantity[30, IndependentUnit["Nucleotides"]],
						Quantity[35, IndependentUnit["Nucleotides"]],
						Quantity[40, IndependentUnit["Nucleotides"]],
						Quantity[45, IndependentUnit["Nucleotides"]],
						Quantity[50, IndependentUnit["Nucleotides"]],
						Quantity[60, IndependentUnit["Nucleotides"]],
						Quantity[70, IndependentUnit["Nucleotides"]],
						Quantity[80, IndependentUnit["Nucleotides"]],
						Quantity[90, IndependentUnit["Nucleotides"]],
						Quantity[100,IndependentUnit["Nucleotides"]]
					},
					Name -> Null,
					Output -> Result,
					Upload -> True,
					Template -> Null
				},
				DeveloperObject -> True|>
			];
			theTemplateObjectID = theTemplateObject[ID];
		),
		TearDown :> (
			If[DatabaseMemberQ[theTemplateObject],
				EraseObject[theTemplateObject, Force -> True, Verbose -> False]];
		)
	],

	Example[{Options,Template,"Explicitly specify FitType option, and pull remaining options from previous ladder analysis:"},
		PlotLadder@AnalyzeLadder[Object[Analysis, Peaks, "id:vXl9j5qErJak"],Upload->False,Template->Object[Analysis, Ladder, theTemplateObjectID],FitType->Cubic],
		ValidGraphicsP[],
		SetUp :> (
			theTemplateObject = Upload[
				<|Type -> Object[Analysis, Ladder],
				UnresolvedOptions -> {
					ReferenceField -> Title,
					Output -> {Preview, Options}
				},
				ResolvedOptions -> {
					ReferenceField -> Absorbance,
					Align -> Minimum,
					Reverse -> False,
					Function -> Size,
					FitType -> Exponential,
					ExpectedSizes -> {
						Quantity[10, IndependentUnit["Nucleotides"]],
						Quantity[15, IndependentUnit["Nucleotides"]],
						Quantity[20, IndependentUnit["Nucleotides"]],
						Quantity[25, IndependentUnit["Nucleotides"]],
						Quantity[30, IndependentUnit["Nucleotides"]],
						Quantity[35, IndependentUnit["Nucleotides"]],
						Quantity[40, IndependentUnit["Nucleotides"]],
						Quantity[45, IndependentUnit["Nucleotides"]],
						Quantity[50, IndependentUnit["Nucleotides"]],
						Quantity[60, IndependentUnit["Nucleotides"]],
						Quantity[70, IndependentUnit["Nucleotides"]],
						Quantity[80, IndependentUnit["Nucleotides"]],
						Quantity[90, IndependentUnit["Nucleotides"]],
						Quantity[100,IndependentUnit["Nucleotides"]]
					},
					Name -> Null,
					Output -> Result,
					Upload -> True,
					Template -> Null
				}, DeveloperObject -> True|>];
			theTemplateObjectID = theTemplateObject[ID];
		),
		TearDown :> (
			If[DatabaseMemberQ[theTemplateObject],
				EraseObject[theTemplateObject, Force -> True, Verbose -> False]];
		)
	],


	Test["Explicitly specify FitType option, and pull remaining options from previous ladder analysis:",
		AnalyzeLadder[Object[Analysis, Peaks, "id:vXl9j5qErJak"],Upload->False,Template->Object[Analysis, Ladder, theTemplateObjectID],FitType->Cubic][[1]],
		validAnalysisPacketP[Object[Analysis, Ladder],
			{},
			ResolvedOptions -> {Template->Object[Analysis,Ladder,theTemplateObjectID], FitType->Cubic, Function->Position},
			Round -> 12
		],
		SetUp :> (
		theTemplateObject = Upload[<|Type -> Object[Analysis, Ladder], UnresolvedOptions -> {ReferenceField -> Title, Output -> {Preview, Options}},
				ResolvedOptions -> {ReferenceField -> Absorbance, Align -> Minimum, Reverse -> False, Function -> Position, FitType -> Exponential, ExpectedSizes -> {Quantity[10, IndependentUnit["Nucleotides"]],
					Quantity[15, IndependentUnit["Nucleotides"]],
					Quantity[20, IndependentUnit["Nucleotides"]],
					Quantity[25, IndependentUnit["Nucleotides"]],
					Quantity[30, IndependentUnit["Nucleotides"]],
					Quantity[35, IndependentUnit["Nucleotides"]],
					Quantity[40, IndependentUnit["Nucleotides"]],
					Quantity[45, IndependentUnit["Nucleotides"]],
					Quantity[50, IndependentUnit["Nucleotides"]],
					Quantity[60, IndependentUnit["Nucleotides"]],
					Quantity[70, IndependentUnit["Nucleotides"]],
					Quantity[80, IndependentUnit["Nucleotides"]],
					Quantity[90, IndependentUnit["Nucleotides"]],
					Quantity[100,IndependentUnit["Nucleotides"]]},
					Name -> Null, Output -> {Result}, Upload -> True, Template -> Null}, DeveloperObject -> True|>];
		theTemplateObjectID = theTemplateObject[ID];
		),
		TearDown :> (
			If[DatabaseMemberQ[theTemplateObject],
				EraseObject[theTemplateObject, Force -> True, Verbose -> False]];
		)
	],

	Example[{Options, Output, "Return the preview:"},
		AnalyzeLadder[Object[Analysis, Peaks, "id:bq9LA0dB4nDv"], Output->Preview],
		TabView[{_String -> ValidGraphicsP[], _String -> ValidGraphicsP[]}],
		Messages:>{Warning::DefaultSizes}
	],

	Example[{Options, Output, "Return the entire packet:"},
		AnalyzeLadder[
			Object[Analysis, Peaks, "id:bq9LA0dB4nDv"],
			Upload->False,
			Output->Result,
			FitNormalization -> False
		],
		validAnalysisPacketP[Object[Analysis, Ladder],
			{
				Replace[FragmentPeaks] -> {{10,7.853333`},{15,11.52`},{20,13.58`},{25,14.666667`},{30,15.333333`},{35,25.24`}},
				Replace[PeaksAnalysis] -> LinkP[Object[Analysis, Peaks],StandardAnalysis],
				Replace[Reference] -> LinkP[Object[Data, Chromatography],StandardAnalyses],
				Replace[ReferenceField] -> Absorbance
			},
			ResolvedOptions -> {
				Upload->False,
				ReferenceField->Absorbance,
				Align->Minimum,
				Reverse->False,
				Function->Size,
				FitType->Exponential,
				ExpectedSizes->{10,15,20,25,30,35,40,45,50,60,70,80,90,100}*Nucleotide,
				FitNormalization->False
			},
			NonNullFields -> {ExpectedSizeFunction, ExpectedPositionFunction},
			Round -> 12
		],
		Messages:>{Warning::DefaultSizes}
	],

	Example[{Options, Name, "Assign a name to the analyze ladder object:"},
		AnalyzeLadder[Object[Analysis, Peaks, "id:bq9LA0dB4nDv"], Name->"some name "<>CreateUUID[], Output->Preview],
		TabView[{_String -> ValidGraphicsP[], _String -> ValidGraphicsP[]}],
		Messages:>{Warning::DefaultSizes}
	],

	(* ---- Messages ---- *)

	Example[{Messages, "DefaultSizes", "Calling AnalyzeLadder on a data object that does not have a properly set Composition field of the linked Samples object results in a warning that a default ladder size set is being used:"},
			PlotLadder@AnalyzeLadder[Object[Data, Chromatography, "id:AEqRl954MZr5"]],
			ValidGraphicsP[],
			Messages:>{Warning::DefaultSizes}
	],

	Example[{Messages, "AnalyzePeaksFailure", "Calling AnalyzeLadder on a ReferenceField that does not interact well with AnalyzePeaks will result in an error:"},
			AnalyzeLadder[Object[Data, PAGE, "id:Z1lqpMzaGPWO"], ReferenceField -> MediumLowExposureLadderIntensity, Upload->False],
			$Failed,
			Messages:>{Warning::PeaksFieldEmpty, Error::InvalidInput, Error::AnalyzePeaksFailure}
	],

	Example[{Messages, "ReferenceFieldNotResolved", "If the given reference field is not a valid peaks field of the data object, Automatic will be used instead:"},
		PlotLadder@AnalyzeLadder[Object[Data, Chromatography, "id:jLq9jXY4Rae1"], ReferenceField -> Title, Upload->False],
		ValidGraphicsP[],
		Messages:>{Warning::UnrecognizedPeaksField, Warning::DefaultSizes}
	],

	Test["If the given reference field is not a valid peaks field of the data object, Automatic will be used instead:",
		AnalyzeLadder[
			Object[Data, Chromatography, "id:jLq9jXY4Rae1"],
			Upload -> False,
			ReferenceField -> Title,
			FitNormalization->False
		],
		validAnalysisPacketP[Object[Analysis, Ladder],
			{
				Replace[FragmentPeaks] ->{{10,7.853333`},{15,11.52`},{20,13.58`},{25,14.666667`},{30,15.333333`},{35,25.24`}},
				Replace[PeaksAnalysis] -> LinkP[Object[Analysis, Peaks],StandardAnalysis],
				Replace[Reference] -> LinkP[Object[Data, Chromatography],StandardAnalyses],
				Replace[ReferenceField] -> Absorbance
			},
			ResolvedOptions -> {
				Upload->False,
				ReferenceField->Absorbance,
				Align->Minimum,
				Reverse->False,
				Function->Size,
				FitType->Exponential,
				FitNormalization->False,
				ExpectedSizes->{10,15,20,25,30,35,40,45,50,60,70,80,90,100}*Nucleotide
			},
			NonNullFields -> {ExpectedSizeFunction, ExpectedPositionFunction},
			Round -> 12
		],
		Messages:>{Warning::UnrecognizedPeaksField, Warning::DefaultSizes}
	],

	Example[{Messages,"PeaksFieldEmpty","Conducts Analyze Peaks, but Fail because only 1 peak picked."},
		AnalyzeLadder[Object[Data, Chromatography, "id:D8KAEvdq0q3O"], Upload -> False],
		$Failed,
		Messages:>{Warning::PeaksFieldEmpty, Error::SingularPeak}
	],

	Example[{Messages,"NoPickedPeaks","Given peaks object has no picked peaks:"},
		AnalyzeLadder[Object[Analysis, Peaks, "id:GmzlKjY5eAvN"], Upload->False],
		$Failed,
		Messages:>{Error::NoPickedPeaks}
	],

	Example[{Messages,"PeaksFieldEmpty","Input CESDS object has not had its RelativeMigrationData field peak-picked yet:"},
		AnalyzeLadder[Object[Data, CapillaryGelElectrophoresisSDS, "id:L8kPEjnMoGOG"], Upload->False],
		$Failed,
		Messages:>{Warning::PeaksFieldEmpty, Error::SingularPeak}
	],

	(* ---- Tests ---- *)

	Test["Upload and return all objects:",
		AnalyzeLadder[Object[Analysis, Peaks, "id:bq9LA0dB4nDv"], Upload->True],
		ObjectP[Object[Analysis, Ladder]],
		Stubs:>{Print[___]:=Null},
		Messages:>{Warning::DefaultSizes}
	],

	Test["Return all packets:",
		AnalyzeLadder[Object[Analysis, Peaks, "id:bq9LA0dB4nDv"], Upload->False, FitNormalization->False],
		(* { *)
				validAnalysisPacketP[Object[Analysis, Ladder],
					{
						Replace[FragmentPeaks] -> {{10,7.853333`},{15,11.52`},{20,13.58`},{25,14.666667`},{30,15.333333`},{35,25.24`}},
						Replace[PeaksAnalysis] -> LinkP[Object[Analysis, Peaks],StandardAnalysis],
						Replace[Reference] -> LinkP[Object[Data, Chromatography],StandardAnalyses],
						Replace[ReferenceField] -> Absorbance
					},
					ResolvedOptions -> {
						Reverse->False,
						ReferenceField->Absorbance,
						Upload->False,
						Align->Minimum,
						Function->Size,
						FitType->Exponential,
						FitNormalization->False,
						ExpectedSizes->{10,15,20,25,30,35,40,45,50,60,70,80,90,100}*Nucleotide
					},
					NonNullFields -> {ExpectedSizeFunction, ExpectedPositionFunction},
					Round -> 12
				]
		,Messages:>{Warning::DefaultSizes}
	],

	Test["Given a packet:",
		PlotLadder@AnalyzeLadder[Download[Object[Analysis, Peaks, "id:vXl9j5qErJak"]], Upload->False],
		ValidGraphicsP[],
		Messages:>{Warning::DefaultSizes}
	],
	Test["Given a link:",
		PlotLadder@AnalyzeLadder[Link[Object[Analysis, Peaks, "id:vXl9j5qErJak"]], Upload->False],
		ValidGraphicsP[],
		Messages:>{Warning::DefaultSizes}
	]

	},
  SymbolSetUp :> (
    $CreatedObjects = {}
  ),
  SymbolTearDown :> (
    Quiet[EraseObject[$CreatedObjects, Force -> True]];
    Unset[$CreatedObjects]
  )
	Platform->{"Windows"}
];



(* ::Subsubsection:: *)
(*AnalyzeLadderOptions*)
DefineTests[AnalyzeLadderOptions, {
	Example[{Basic,"Return all default options used in this function:"},
		AnalyzeLadderOptions[Object[Analysis,Peaks,"id:vXl9j5qErJak"]],
		_Grid,
		Messages :> {Warning::DefaultSizes}
	],
	Example[{Basic,"Return all options including speficied ones used in this function:"},
		AnalyzeLadderOptions[Object[Analysis,Peaks,"id:vXl9j5qErJak"],Output->Result],
		_Grid,
		Messages :> {Warning::DefaultSizes}
	],
	Example[{Options,OutputFormat,"Return the options as a list:"},
		AnalyzeLadderOptions[Object[Analysis,Peaks,"id:vXl9j5qErJak"],OutputFormat->List],
		{
			ReferenceField -> Absorbance, Align -> Minimum, Reverse -> False, Function -> Size, FitType -> Exponential,
			ExpectedSizes -> {
				Quantity[10, IndependentUnit["Nucleotides"]], Quantity[15, IndependentUnit["Nucleotides"]], Quantity[20, IndependentUnit["Nucleotides"]],
				Quantity[25, IndependentUnit["Nucleotides"]], Quantity[30, IndependentUnit["Nucleotides"]], Quantity[35, IndependentUnit["Nucleotides"]],
				Quantity[40, IndependentUnit["Nucleotides"]], Quantity[45, IndependentUnit["Nucleotides"]], Quantity[50, IndependentUnit["Nucleotides"]],
				Quantity[60, IndependentUnit["Nucleotides"]], Quantity[70, IndependentUnit["Nucleotides"]], Quantity[80, IndependentUnit["Nucleotides"]],
				Quantity[90, IndependentUnit["Nucleotides"]], Quantity[100, IndependentUnit["Nucleotides"]]
			},
			Name -> Null, PlotType -> All, FitNormalization -> True, Template -> Null
		},
		Messages :> {Warning::DefaultSizes}
	]
}
];


(* ::Subsubsection:: *)
(*AnalyzeLadderPreview*)
DefineTests[AnalyzeLadderPreview, {
	Example[{Basic,"Plots the standard peak points in ladder with ExpectedSize or ExpectedPosition functions overlayed:"},
		AnalyzeLadderPreview[Object[Analysis,Peaks,"id:vXl9j5qErJak"]],
		TabView[{_String -> ValidGraphicsP[], _String -> ValidGraphicsP[]}],
		Messages :> {Warning::DefaultSizes}
	],
	Example[{Basic,"Can also work on PAGE data:"},
		AnalyzeLadderPreview[Object[Data,PAGE,"id:Z1lqpMzaGPWO"]],
		TabView[{_String -> ValidGraphicsP[], _String -> ValidGraphicsP[]}]
	],
	Example[{Basic,"Can work on Chromatography data:"},
		AnalyzeLadderPreview[Object[Data,Chromatography,"id:AEqRl954MZr5"]],
		TabView[{_String -> ValidGraphicsP[], _String -> ValidGraphicsP[]}],
		Messages :> {Warning::DefaultSizes}
	]
}
];


(* ::Subsubsection:: *)
(*ValidAnalyzeLadderQ*)
DefineTests[ValidAnalyzeLadderQ, {
	Example[{Basic,"Return test results for all the gathered tests/warning:"},
		ValidAnalyzeLadderQ[Object[Analysis,Peaks,"id:vXl9j5qErJak"]],
		True,
		Messages :> {Warning::DefaultSizes}
	],
	Example[{Basic,"The function also checks if the input objects are valid:"},
		ValidAnalyzeLadderQ[Object[Data,PAGE,"id:Z1lqpMzaGPWO"]],
		True
	],
	Example[{Options,OutputFormat,"Specify OutputFormat to be TestSummary:"},
		ValidAnalyzeLadderQ[Object[Analysis,Peaks,"id:vXl9j5qErJak"],OutputFormat->TestSummary],
		_EmeraldTestSummary,
		Messages :> {Warning::DefaultSizes}
	],
	Example[{Options,Verbose,"Specify Verbose to be True:"},
		ValidAnalyzeLadderQ[Object[Analysis,Peaks,"id:vXl9j5qErJak"], Verbose->True],
		True,
		Messages :> {Warning::DefaultSizes}
	]
}
];


(* ::Section:: *)
(*End Test Package*)
