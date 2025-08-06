(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*AbsorbanceQuantification: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*AnalyzeAbsorbanceQuantification*)


(* ::Subsubsection:: *)
(*AnalyzeAbsorbanceQuantification*)


DefineTests[AnalyzeAbsorbanceQuantification,
	{

		Example[{Basic, "Analyze the data from an absorbance quantification protocol:"},
			Download[AnalyzeAbsorbanceQuantification[{Object[Data, AbsorbanceSpectroscopy, "id:XnlV5jKmAVaM"], Object[Data, AbsorbanceSpectroscopy, "id:n0k9mG8zw95n"], Object[Data, AbsorbanceSpectroscopy, "id:Z1lqpMzG8qJW"]}], Concentration],
			{_?ConcentrationQ}
		],

		Example[{Basic, "Given list of absorbance spectroscopy datas, calculate concentration:"},
			Download[
				AnalyzeAbsorbanceQuantification[
					{
						Object[Data, AbsorbanceIntensity, "id:9RdZXv1nBRkJ"],
						Object[Data, AbsorbanceIntensity, "id:mnk9jORWqnNN"],
						Object[Data, AbsorbanceIntensity, "id:BYDOjvGXVYbE"],
						Object[Data, AbsorbanceIntensity, "id:M8n3rx0oE81E"],
						Object[Data, AbsorbanceIntensity, "id:WNa4ZjKxrNOD"],
						Object[Data, AbsorbanceIntensity, "id:54n6evLMx4lY"],
						Object[Data, AbsorbanceIntensity, "id:n0k9mG8WR034"]
					},
					ParentProtocol -> True,
					PathLength -> 1. * Centimeter,
					PathLengthMethod -> Constant,
					Wavelength -> {
						260. Nanometer,
						260. Nanometer,
						260. Nanometer,
						260. Nanometer,
						260. Nanometer,
						260. Nanometer,
						280. Nanometer
					}
				],
				Concentration
			],
			{_?ConcentrationQ..}
		],

		Example[{Basic, "Analyze the data from an AbsorbanceIntensity run using diluted samples on the Lunatic:"},
			AnalyzeAbsorbanceQuantification[
				{
					Object[Data, AbsorbanceIntensity, "id:9RdZXv1nBRkJ"],
					Object[Data, AbsorbanceIntensity, "id:mnk9jORWqnNN"],
					Object[Data, AbsorbanceIntensity, "id:BYDOjvGXVYbE"],
					Object[Data, AbsorbanceIntensity, "id:M8n3rx0oE81E"],
					Object[Data, AbsorbanceIntensity, "id:WNa4ZjKxrNOD"],
					Object[Data, AbsorbanceIntensity, "id:54n6evLMx4lY"],
					Object[Data, AbsorbanceIntensity, "id:n0k9mG8WR034"]
				},
				ParentProtocol -> True,
				PathLength -> 1. * Centimeter,
				PathLengthMethod -> Constant,
				Wavelength -> {
					260. Nanometer,
					260. Nanometer,
					260. Nanometer,
					260. Nanometer,
					260. Nanometer,
					260. Nanometer,
					280. Nanometer
				}
			],
			{ObjectP[Object[Analysis, AbsorbanceQuantification]]..}
		],

		Example[{Additional, "Populate the dilutions properly based on the protocol's AliquotSamplePreparation field:"},
			analyses = AnalyzeAbsorbanceQuantification[
				{
					Object[Data, AbsorbanceIntensity, "id:9RdZXv1nBRkJ"],
					Object[Data, AbsorbanceIntensity, "id:mnk9jORWqnNN"],
					Object[Data, AbsorbanceIntensity, "id:BYDOjvGXVYbE"],
					Object[Data, AbsorbanceIntensity, "id:M8n3rx0oE81E"],
					Object[Data, AbsorbanceIntensity, "id:WNa4ZjKxrNOD"],
					Object[Data, AbsorbanceIntensity, "id:54n6evLMx4lY"],
					Object[Data, AbsorbanceIntensity, "id:n0k9mG8WR034"]
				},
				ParentProtocol -> True,
				PathLength -> 1. * Centimeter,
				PathLengthMethod -> Constant,
				Wavelength -> {
					260. Nanometer,
					260. Nanometer,
					260. Nanometer,
					260. Nanometer,
					260. Nanometer,
					260. Nanometer,
					280. Nanometer
				}
			];
			DeleteCases[Flatten[#], Null]& /@ Download[analyses, {SampleDilution, SampleDilutions}],
			{{1.}, {1.25}, {RangeP[1.66666, 1.66667]}, {2.5}, {5.}, {10., 20.}}
		],

		Example[{Options, DestinationPlateModel, "Specify the plate model for the plate in which the samples were diluted during the protocol:"},
			PlotObject@AnalyzeAbsorbanceQuantification[{Object[Data, AbsorbanceSpectroscopy, "id:XnlV5jKmAVaM"], Object[Data, AbsorbanceSpectroscopy, "id:n0k9mG8zw95n"], Object[Data, AbsorbanceSpectroscopy, "id:Z1lqpMzG8qJW"]}, DestinationPlateModel -> Model[Container, Plate, "id:n0k9mGzRaaBn"]],
			{_?ValidGraphicsQ}
		],

		Test["Specify the plate model for the plate in which the samples were diluted during the protocol:",
			stripAppendReplaceKeyHeads@AnalyzeAbsorbanceQuantification[{Object[Data, AbsorbanceSpectroscopy, "id:XnlV5jKmAVaM"], Object[Data, AbsorbanceSpectroscopy, "id:n0k9mG8zw95n"], Object[Data, AbsorbanceSpectroscopy, "id:Z1lqpMzG8qJW"]}, Upload -> False, DestinationPlateModel -> Model[Container, Plate, "id:n0k9mGzRaaBn"], Output -> Result],
			{validAnalysisPacketP[Object[Analysis, AbsorbanceQuantification],
				{
				},
				ResolvedOptions -> {DestinationPlateModel -> Model[Container, Plate, "id:n0k9mGzRaaBn"]}
			]},
			TimeConstraint -> 600
		],

		Test["Update the Composition field of SamplesIn:",
			analysisObjs = AnalyzeAbsorbanceQuantification[
				{
					Object[Data, AbsorbanceIntensity, "id:9RdZXv1nBRkJ"],
					Object[Data, AbsorbanceIntensity, "id:mnk9jORWqnNN"],
					Object[Data, AbsorbanceIntensity, "id:BYDOjvGXVYbE"],
					Object[Data, AbsorbanceIntensity, "id:M8n3rx0oE81E"],
					Object[Data, AbsorbanceIntensity, "id:WNa4ZjKxrNOD"],
					Object[Data, AbsorbanceIntensity, "id:54n6evLMx4lY"],
					Object[Data, AbsorbanceIntensity, "id:n0k9mG8WR034"]
				},
				ParentProtocol -> True,
				PathLength -> 1. * Centimeter,
				PathLengthMethod -> Constant,
				Wavelength -> {
					260. Nanometer,
					260. Nanometer,
					260. Nanometer,
					260. Nanometer,
					260. Nanometer,
					260. Nanometer,
					280. Nanometer
				}
			];
			Download[analysisObjs, SamplesIn[Composition]],
			{
				{{{ConcentrationP, LinkP[Model[Molecule, "id:L8kPEjn6vbwA"]], _}, {Null, Null, _}}},
				{{{ConcentrationP, LinkP[Model[Molecule, "id:L8kPEjn6vbwA"]], _}, {Null, Null, _}}},
				{{{ConcentrationP, LinkP[Model[Molecule, "id:L8kPEjn6vbwA"]], _}, {Null, Null, _}}},
				{{{ConcentrationP, LinkP[Model[Molecule, "id:L8kPEjn6vbwA"]], _}, {Null, Null, _}}},
				{{{ConcentrationP, LinkP[Model[Molecule, "id:L8kPEjn6vbwA"]], _}, {Null, Null, _}}},
				{
					{{ConcentrationP, LinkP[Model[Molecule, "id:L8kPEjn6vbwA"]], _}, {Null, Null, _}},
					{{ConcentrationP, LinkP[Model[Molecule, "id:L8kPEjn6vbwA"]], _}, {Null, Null, _}}
				}
			},
			Variables :> {analysisObjs}
		],
		Test["Populate the Analyte field in the analysis objects:",
			analysisObjs = AnalyzeAbsorbanceQuantification[
				{
					Object[Data, AbsorbanceIntensity, "id:9RdZXv1nBRkJ"],
					Object[Data, AbsorbanceIntensity, "id:mnk9jORWqnNN"],
					Object[Data, AbsorbanceIntensity, "id:BYDOjvGXVYbE"],
					Object[Data, AbsorbanceIntensity, "id:M8n3rx0oE81E"],
					Object[Data, AbsorbanceIntensity, "id:WNa4ZjKxrNOD"],
					Object[Data, AbsorbanceIntensity, "id:54n6evLMx4lY"],
					Object[Data, AbsorbanceIntensity, "id:n0k9mG8WR034"]
				},
				ParentProtocol -> True,
				PathLength -> 1. * Centimeter,
				PathLengthMethod -> Constant,
				Wavelength -> {
					260. Nanometer,
					260. Nanometer,
					260. Nanometer,
					260. Nanometer,
					260. Nanometer,
					260. Nanometer,
					280. Nanometer
				}
			];
			Download[analysisObjs, Analyte],
			{ObjectP[Model[Molecule, "id:L8kPEjn6vbwA"]]..},
			Variables :> {analysisObjs}
		],

		Test["Update the Composition field of AliquotSamples:",
			AnalyzeAbsorbanceQuantification[
				{
					Object[Data, AbsorbanceIntensity, "id:9RdZXv1nBRkJ"],
					Object[Data, AbsorbanceIntensity, "id:mnk9jORWqnNN"],
					Object[Data, AbsorbanceIntensity, "id:BYDOjvGXVYbE"],
					Object[Data, AbsorbanceIntensity, "id:M8n3rx0oE81E"],
					Object[Data, AbsorbanceIntensity, "id:WNa4ZjKxrNOD"],
					Object[Data, AbsorbanceIntensity, "id:54n6evLMx4lY"],
					Object[Data, AbsorbanceIntensity, "id:n0k9mG8WR034"]
				},
				ParentProtocol -> True,
				PathLength -> 1. * Centimeter,
				PathLengthMethod -> Constant,
				Wavelength -> {
					260. Nanometer,
					260. Nanometer,
					260. Nanometer,
					260. Nanometer,
					260. Nanometer,
					260. Nanometer,
					280. Nanometer
				}
			];
			Download[
				{
					Object[Data, AbsorbanceIntensity, "id:9RdZXv1nBRkJ"],
					Object[Data, AbsorbanceIntensity, "id:mnk9jORWqnNN"],
					Object[Data, AbsorbanceIntensity, "id:BYDOjvGXVYbE"],
					Object[Data, AbsorbanceIntensity, "id:M8n3rx0oE81E"],
					Object[Data, AbsorbanceIntensity, "id:WNa4ZjKxrNOD"],
					Object[Data, AbsorbanceIntensity, "id:54n6evLMx4lY"],
					Object[Data, AbsorbanceIntensity, "id:n0k9mG8WR034"]
				},
				AliquotSamples[Composition]
			],
			{
				{{{ConcentrationP, LinkP[Model[Molecule, "id:L8kPEjn6vbwA"]], _}, {Null, Null, _}}},
				{{{ConcentrationP, LinkP[Model[Molecule, "id:L8kPEjn6vbwA"]], _}, {Null, Null, _}}},
				{{{ConcentrationP, LinkP[Model[Molecule, "id:L8kPEjn6vbwA"]], _}, {Null, Null, _}}},
				{{{ConcentrationP, LinkP[Model[Molecule, "id:L8kPEjn6vbwA"]], _}, {Null, Null, _}}},
				{{{ConcentrationP, LinkP[Model[Molecule, "id:L8kPEjn6vbwA"]], _}, {Null, Null, _}}},
				{{{ConcentrationP, LinkP[Model[Molecule, "id:L8kPEjn6vbwA"]], _}, {Null, Null, _}}},
				{{{ConcentrationP, LinkP[Model[Molecule, "id:L8kPEjn6vbwA"]], _}, {Null, Null, _}}}
			}
		],

		Example[{Options, Wavelength, "Specify different wavelengths for different input data objects:"},
			AnalyzeAbsorbanceQuantification[
				{
					Object[Data, AbsorbanceIntensity, "id:9RdZXv1nBRkJ"],
					Object[Data, AbsorbanceIntensity, "id:mnk9jORWqnNN"],
					Object[Data, AbsorbanceIntensity, "id:BYDOjvGXVYbE"],
					Object[Data, AbsorbanceIntensity, "id:M8n3rx0oE81E"],
					Object[Data, AbsorbanceIntensity, "id:WNa4ZjKxrNOD"],
					Object[Data, AbsorbanceIntensity, "id:54n6evLMx4lY"],
					Object[Data, AbsorbanceIntensity, "id:n0k9mG8WR034"]
				},
				ParentProtocol -> True,
				PathLength -> 1. * Centimeter,
				PathLengthMethod -> Constant,
				Wavelength -> {
					260. Nanometer,
					260. Nanometer,
					260. Nanometer,
					260. Nanometer,
					260. Nanometer,
					260. Nanometer,
					280. Nanometer
				}
			],
			{ObjectP[Object[Analysis, AbsorbanceQuantification]]..}
		],
		Test["Specify the plate model for the plate in which the samples were diluted during the protocol:",
			stripAppendReplaceKeyHeads@AnalyzeAbsorbanceQuantification[{Object[Data, AbsorbanceSpectroscopy, "id:XnlV5jKmAVaM"], Object[Data, AbsorbanceSpectroscopy, "id:n0k9mG8zw95n"], Object[Data, AbsorbanceSpectroscopy, "id:Z1lqpMzG8qJW"]}, Upload -> False, Wavelength -> 260 Nano Meter, Output -> Result],
			{validAnalysisPacketP[Object[Analysis, AbsorbanceQuantification],
				{
				},
				ResolvedOptions -> {Wavelength -> 260 Nano Meter}
			]},
			TimeConstraint -> 600
		],


		Example[{Options, Output, "Return resolved options:"},
			AnalyzeAbsorbanceQuantification[{Object[Data, AbsorbanceSpectroscopy, "id:XnlV5jKmAVaM"], Object[Data, AbsorbanceSpectroscopy, "id:n0k9mG8zw95n"], Object[Data, AbsorbanceSpectroscopy, "id:Z1lqpMzG8qJW"]}, Output -> Options],
			_List
		],
		Example[{Messages, "NoExtinctionCoefficients", "If a data object does not have the Analyte field populated, an error is thrown:"},
			AnalyzeAbsorbanceQuantification[Object[Data, AbsorbanceSpectroscopy, "Data object with no Analyte for AnalyzeAbsorbanceQuantification unit testing"], PathLength -> 1.0 Centimeter],
			$Failed,
			Messages :> {Error::NoExtinctionCoefficients}
		],
		Example[{Options, PathLength, "The path length of light through a sample of interest, assumed to be in the vertical direction:"},
			PlotObject@AnalyzeAbsorbanceQuantification[{Object[Data,AbsorbanceSpectroscopy,"id:GmzlKjPYjElk"]},PathLength->1Centimeter,Wavelength->260 Nanometer],
			{_?ValidGraphicsQ}
		],

		Example[{Options, PathLengthMethod, "The method by which the path length from the plate reader to the sample in the read plate was determined:"},
			PlotObject@AnalyzeAbsorbanceQuantification[{Object[Data, AbsorbanceSpectroscopy, "id:XnlV5jKmAVaM"], Object[Data, AbsorbanceSpectroscopy, "id:n0k9mG8zw95n"], Object[Data, AbsorbanceSpectroscopy, "id:Z1lqpMzG8qJW"]}, PathLengthMethod -> Ultrasonic],
			{_?ValidGraphicsQ}
		],

		Example[{Options, MaxAbsorbance, "Maximum value at Wavelength to be within dynamic range. Absorbance data out side the range will be excluded:"},
			PlotObject@AnalyzeAbsorbanceQuantification[
				{
					Object[Data, AbsorbanceSpectroscopy, "id:vXl9j57qVowm"],
					Object[Data, AbsorbanceSpectroscopy, "id:9RdZXv1K4Voj"],
					Object[Data, AbsorbanceSpectroscopy, "id:M8n3rx0YwmZO"],
					Object[Data, AbsorbanceSpectroscopy, "id:n0k9mG8znXw3"],
					Object[Data, AbsorbanceSpectroscopy, "id:Z1lqpMzGnb8V"],
					Object[Data, AbsorbanceSpectroscopy, "id:pZx9jo8n1RL5"],
					Object[Data, AbsorbanceSpectroscopy, "id:XnlV5jKm68Mz"],
					Object[Data, AbsorbanceSpectroscopy, "id:O81aEBZ4Dm91"],
					Object[Data, AbsorbanceSpectroscopy, "id:o1k9jAGK0q3E"],
					Object[Data, AbsorbanceSpectroscopy, "id:L8kPEjnN5m96"],
					Object[Data, AbsorbanceSpectroscopy, "id:kEJ9mqRalpLL"],
					Object[Data, AbsorbanceSpectroscopy, "id:D8KAEvGdLp9L"],
					Object[Data, AbsorbanceSpectroscopy, "id:J8AY5jDw3OmB"],
					Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0JdVkEL"],
					Object[Data, AbsorbanceSpectroscopy, "id:7X104vnKepdw"],
					Object[Data, AbsorbanceSpectroscopy, "id:xRO9n3BvqW06"],
					Object[Data, AbsorbanceSpectroscopy, "id:mnk9jOR3EVaK"],
					Object[Data, AbsorbanceSpectroscopy, "id:WNa4ZjKR3m9E"]
				},
				MaxAbsorbance->3 AbsorbanceUnit
			],
			{_?ValidGraphicsQ..}
		],

		Example[{Options, MinAbsorbance, "Minimum value at Wavelength to be within dynamic range. Absorbance data out side the range will be excluded:"},
			PlotObject@AnalyzeAbsorbanceQuantification[
				{
					Object[Data, AbsorbanceSpectroscopy, "id:vXl9j57qVowm"],
					Object[Data, AbsorbanceSpectroscopy, "id:9RdZXv1K4Voj"],
					Object[Data, AbsorbanceSpectroscopy, "id:M8n3rx0YwmZO"],
					Object[Data, AbsorbanceSpectroscopy, "id:n0k9mG8znXw3"],
					Object[Data, AbsorbanceSpectroscopy, "id:Z1lqpMzGnb8V"],
					Object[Data, AbsorbanceSpectroscopy, "id:pZx9jo8n1RL5"],
					Object[Data, AbsorbanceSpectroscopy, "id:XnlV5jKm68Mz"],
					Object[Data, AbsorbanceSpectroscopy, "id:O81aEBZ4Dm91"],
					Object[Data, AbsorbanceSpectroscopy, "id:o1k9jAGK0q3E"],
					Object[Data, AbsorbanceSpectroscopy, "id:L8kPEjnN5m96"],
					Object[Data, AbsorbanceSpectroscopy, "id:kEJ9mqRalpLL"],
					Object[Data, AbsorbanceSpectroscopy, "id:D8KAEvGdLp9L"],
					Object[Data, AbsorbanceSpectroscopy, "id:J8AY5jDw3OmB"],
					Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0JdVkEL"],
					Object[Data, AbsorbanceSpectroscopy, "id:7X104vnKepdw"],
					Object[Data, AbsorbanceSpectroscopy, "id:xRO9n3BvqW06"],
					Object[Data, AbsorbanceSpectroscopy, "id:mnk9jOR3EVaK"],
					Object[Data, AbsorbanceSpectroscopy, "id:WNa4ZjKR3m9E"]
				},
				MinAbsorbance->0.1 AbsorbanceUnit
			],
			{_?ValidGraphicsQ..}
		],

		Example[{Options, ParentProtocol, "Whether or not this analysis has a parent protocol. If True, then it does not set the author in the upload packet. Otherwise the author is whoever running this analysis:"},
			NullQ[Download[AnalyzeAbsorbanceQuantification[{Object[Data, AbsorbanceSpectroscopy, "id:XnlV5jKmAVaM"], Object[Data, AbsorbanceSpectroscopy, "id:n0k9mG8zw95n"], Object[Data, AbsorbanceSpectroscopy, "id:Z1lqpMzG8qJW"]},ParentProtocol->True,Output->Result], Author]],
			True
		],

		Example[{Options, OutputAll, "If True, also returns any other objects that were created or modified:"},
			AnalyzeAbsorbanceQuantification[{Object[Data, AbsorbanceSpectroscopy, "id:XnlV5jKmAVaM"], Object[Data, AbsorbanceSpectroscopy, "id:n0k9mG8zw95n"], Object[Data, AbsorbanceSpectroscopy, "id:Z1lqpMzG8qJW"]},Upload->False,OutputAll->True],
			{_List..}
		],

		Example[{Options, Template, "Use the settings from a previous analysis object:"},
			PlotObject@First@AnalyzeAbsorbanceQuantification[{Object[Data, AbsorbanceSpectroscopy, "id:XnlV5jKmAVaM"], Object[Data, AbsorbanceSpectroscopy, "id:n0k9mG8zw95n"], Object[Data, AbsorbanceSpectroscopy, "id:Z1lqpMzG8qJW"]}, Template->Object[Analysis,AbsorbanceQuantification,"id:kEJ9mqRRwZ8P"]],
			_?ValidGraphicsQ
		],

		Test["Explicitly specify Wavelength option, and pull remaining options from previous absorbance quantification analysis:",
			stripAppendReplaceKeyHeads@AnalyzeAbsorbanceQuantification[{Object[Data, AbsorbanceSpectroscopy, "id:XnlV5jKmAVaM"], Object[Data, AbsorbanceSpectroscopy, "id:n0k9mG8zw95n"], Object[Data, AbsorbanceSpectroscopy, "id:Z1lqpMzG8qJW"]},Upload->False,Template->Object[Analysis,AbsorbanceQuantification,"id:kEJ9mqRRwZ8P"],Wavelength->270*Nanometer, Output -> Result],
			{validAnalysisPacketP[Object[Analysis, AbsorbanceQuantification],
				{},
				ResolvedOptions -> {Template->Object[Analysis,AbsorbanceQuantification,"id:kEJ9mqRRwZ8P"]},
				Round -> 12
			]},
			TimeConstraint -> 600
		],

		Test["Return all insert & update packets:",
			stripAppendReplaceKeyHeads@AnalyzeAbsorbanceQuantification[{Object[Data, AbsorbanceSpectroscopy, "id:XnlV5jKmAVaM"], Object[Data, AbsorbanceSpectroscopy, "id:n0k9mG8zw95n"], Object[Data, AbsorbanceSpectroscopy, "id:Z1lqpMzG8qJW"]}, Upload->False, Output -> Result, OutputAll -> True],
			{{
				{Analysis`Private`validAnalysisPacketP[Object[Analysis, AbsorbanceQuantification], {}]},
				{
					<|Object -> Object[Data,AbsorbanceSpectroscopy,_String], Concentration -> ConcentrationP, DilutedConcentration -> ConcentrationP , PathLength -> _,PathLengthMethod -> _|>,
					<|Object -> Object[Data,AbsorbanceSpectroscopy,_String], Concentration -> ConcentrationP, DilutedConcentration -> ConcentrationP , PathLength -> _,PathLengthMethod -> _|>,
					<|Object -> Object[Data,AbsorbanceSpectroscopy,_String], Concentration -> ConcentrationP, DilutedConcentration -> ConcentrationP , PathLength -> _,PathLengthMethod -> _|>,
					<|Object -> Object[Sample,_String], Replace[Composition] -> _List|>
				}
			}},
			TimeConstraint -> 600
		],

		Test["Given a packet:",
			AnalyzeAbsorbanceQuantification[Download[{Object[Data, AbsorbanceSpectroscopy, "id:XnlV5jKmAVaM"], Object[Data, AbsorbanceSpectroscopy, "id:n0k9mG8zw95n"], Object[Data, AbsorbanceSpectroscopy, "id:Z1lqpMzG8qJW"]}],Upload->False],
			{PacketP[]},
			EquivalenceFunction -> RoundMatchQ[12],
			TimeConstraint -> 600
		],
		Test["Given a link:",
			AnalyzeAbsorbanceQuantification[Link[{Object[Data, AbsorbanceSpectroscopy, "id:XnlV5jKmAVaM"], Object[Data, AbsorbanceSpectroscopy, "id:n0k9mG8zw95n"], Object[Data, AbsorbanceSpectroscopy, "id:Z1lqpMzG8qJW"]},Field],Upload->False],
			{PacketP[]},
			EquivalenceFunction -> RoundMatchQ[12],
			TimeConstraint -> 600
		],

		Test["Upload result:",
			AnalyzeAbsorbanceQuantification[{Object[Data, AbsorbanceSpectroscopy, "id:XnlV5jKmAVaM"], Object[Data, AbsorbanceSpectroscopy, "id:n0k9mG8zw95n"], Object[Data, AbsorbanceSpectroscopy, "id:Z1lqpMzG8qJW"]},Upload->True],
			{ObjectP[Object[Analysis, AbsorbanceQuantification]]},
			TimeConstraint -> 600,
			Stubs :> {Print[_] := Null}
		],

		Test["Performs quantification on non-oligomer samples:",
			AnalyzeAbsorbanceQuantification[{Object[Data, AbsorbanceSpectroscopy, "id:AEqRl9K5o8Pa"], Object[Data, AbsorbanceSpectroscopy, "id:o1k9jAGK0m7a"], Object[Data, AbsorbanceSpectroscopy, "id:zGj91a7ROKXE"]}, PathLength -> 1*Centimeter, Upload -> False],
			{PacketP[]},
			Messages:>{Warning::AllAbsOutOfRange},
			EquivalenceFunction -> RoundMatchQ[6]
		]
	},
	SymbolSetUp :> (
		Quiet[CreateDirectory[FileNameJoin[{$TemporaryDirectory, "Data", "Plate Reader"}]]];
		MapThread[
			If[Not[FileExistsQ[#2]], DownloadCloudFile[#1, #2]]&,
			{
				{
					Object[EmeraldCloudFile, "Lunatic data for AnalyzeAbsorbanceQuantification unit tests"]
				},
				{
					FileNameJoin[{$TemporaryDirectory, "Data", "Plate Reader", "data_" <> ObjectToFilePath[Object[Protocol, AbsorbanceIntensity, "Fake AbsorbanceIntensity Lunatic quantification protocol with dilution for AnalyzeAbsorbanceQuantification tests"], FastTrack -> True] <> ".csv"}]
				}
			}
		]
	),
	SetUp :> (
		$CreatedObjects = {};
		Upload[{
			<|
				Object -> Object[Sample, "id:KBL5DvwY0oad"],
				Replace[Composition] -> {
					{Quantity[100, IndependentUnit["MassPercent"]], Link[Model[Molecule, Oligomer, "id:O81aEBZnjvnN"]], Now},
					{Null, Null, Null}
				}
			|>,
			<|
				Object -> Object[Sample, "id:L8kPEjnoL8DV"],
				Replace[Composition] -> {
					{Quantity[100, IndependentUnit["VolumePercent"]], Link[Model[Molecule, "id:L8kPEjn6vbwA"]], Now},
					{Null, Null, Null}
				}
			|>,
			<|
				Object -> Object[Sample, "id:E8zoYvNJR8l7"],
				Replace[Composition] -> {
					{Quantity[100, IndependentUnit["VolumePercent"]], Link[Model[Molecule, "id:L8kPEjn6vbwA"]], Now},
					{Null, Null, Null}
				}
			|>,
			<|
				Object -> Object[Sample, "id:Y0lXejMxK0d1"],
				Replace[Composition] -> {
					{Quantity[100, IndependentUnit["VolumePercent"]], Link[Model[Molecule, "id:L8kPEjn6vbwA"]], Now},
					{Null, Null, Null}
				}
			|>,
			<|
				Object -> Object[Sample, "id:kEJ9mqR5VEPV"],
				Replace[Composition] -> {
					{Quantity[100, IndependentUnit["VolumePercent"]], Link[Model[Molecule, "id:L8kPEjn6vbwA"]], Now},
					{Null, Null, Null}
				}
			|>,
			<|
				Object -> Object[Sample, "id:P5ZnEjd6P58l"],
				Replace[Composition] -> {
					{Quantity[100, IndependentUnit["VolumePercent"]], Link[Model[Molecule, "id:L8kPEjn6vbwA"]], Now},
					{Null, Null, Null}
				}
			|>,
			<|
				Object -> Object[Sample, "id:3em6ZvLxNejz"],
				Replace[Composition] -> {
					{Quantity[100, IndependentUnit["VolumePercent"]], Link[Model[Molecule, "id:L8kPEjn6vbwA"]], Now},
					{Null, Null, Null}
				}
			|>,
			<|
				Object -> Object[Sample, "id:GmzlKjPB5mOE"],
				Replace[Composition] -> {
					{Quantity[100, IndependentUnit["VolumePercent"]], Link[Model[Molecule, "id:L8kPEjn6vbwA"]], Now},
					{Null, Null, Null}
				}
			|>,
			<|
				Object -> Object[Sample, "id:AEqRl9KV4Epp"],
				Replace[Composition] -> {
					{Quantity[100, IndependentUnit["VolumePercent"]], Link[Model[Molecule, "id:L8kPEjn6vbwA"]], Now},
					{Null, Null, Null}
				}
			|>,
			<|
				Object -> Object[Sample, "id:o1k9jAGWO1L7"],
				Replace[Composition] -> {
					{Quantity[100, IndependentUnit["VolumePercent"]], Link[Model[Molecule, "id:L8kPEjn6vbwA"]], Now},
					{Null, Null, Null}
				}
			|>,
			<|
				Object -> Object[Sample, "id:zGj91a7x3G5e"],
				Replace[Composition] -> {
					{Quantity[100, IndependentUnit["VolumePercent"]], Link[Model[Molecule, "id:L8kPEjn6vbwA"]], Now},
					{Null, Null, Null}
				}
			|>,
			<|
				Object -> Object[Sample, "id:lYq9jRxWXYop"],
				Replace[Composition] -> {
					{Quantity[100, IndependentUnit["VolumePercent"]], Link[Model[Molecule, "id:L8kPEjn6vbwA"]], Now},
					{Null, Null, Null}
				}
			|>,
			<|
				Object -> Object[Sample, "id:L8kPEjnoL8lV"],
				Replace[Composition] -> {
					{Quantity[100, IndependentUnit["VolumePercent"]], Link[Model[Molecule, "id:L8kPEjn6vbwA"]], Now},
					{Null, Null, Null}
				}|>,
			<|
				Object -> Object[Sample, "id:E8zoYvNJR8q7"],
				Replace[Composition] -> {
					{Quantity[100, IndependentUnit["VolumePercent"]], Link[Model[Molecule, "id:L8kPEjn6vbwA"]], Now},
					{Null, Null, Null}
				}
			|>
		}]
	),
	TearDown :> (EraseObject[$CreatedObjects, Force -> True])
];


(* ::Subsubsection:: *)
(*AnalyzeAbsorbanceQuantificationOptions*)


DefineTests[AnalyzeAbsorbanceQuantificationOptions, {
	Example[{Basic,"Return all options with Automatic resolved to a fixed value:"},
		AnalyzeAbsorbanceQuantificationOptions[{Object[Data, AbsorbanceSpectroscopy, "id:XnlV5jKmAVaM"], Object[Data, AbsorbanceSpectroscopy, "id:n0k9mG8zw95n"], Object[Data, AbsorbanceSpectroscopy, "id:Z1lqpMzG8qJW"]}],
		_Grid
	],
	Example[{Basic,"Given list of absorbance spectroscopy data:"},
		AnalyzeAbsorbanceQuantificationOptions[{Object[Data,AbsorbanceSpectroscopy,"id:n0k9mGz5P88p"],Object[Data,AbsorbanceSpectroscopy,"id:01G6nvkJRwGY"],Object[Data,AbsorbanceSpectroscopy,"id:R8e1PjREZpYX"],Object[Data,AbsorbanceSpectroscopy,"id:Vrbp1jG34KKz"],Object[Data,AbsorbanceSpectroscopy,"id:lYq9jRzZPx8O"]}],
		_Grid
	],

	Example[{Options,OutputFormat,"Return the options as a list:"},
		AnalyzeAbsorbanceQuantificationOptions[{Object[Data, AbsorbanceSpectroscopy, "id:XnlV5jKmAVaM"], Object[Data, AbsorbanceSpectroscopy, "id:n0k9mG8zw95n"], Object[Data, AbsorbanceSpectroscopy, "id:Z1lqpMzG8qJW"]}, OutputFormat->List],
		{
			DestinationPlateModel -> Model[Container, Plate, "id:n0k9mGzRaaBn"],
			Wavelength -> Quantity[260, "Nanometers"],
			(* In MM 13.2 the RNG method is different so now the difference between a DataDistribution and a NormalDistribution is no longer deterministic so check for quantities *)
			PathLength -> {Quantity[_, "Millimeters"], Quantity[_, "Millimeters"], Quantity[_, "Millimeters"]},
			MaxAbsorbance -> Quantity[2.3, IndependentUnit["AbsorbanceUnit"]],
			MinAbsorbance -> Quantity[0.8, IndependentUnit["AbsorbanceUnit"]],
			PathLengthMethod -> Ultrasonic,
			Template -> Null
		},
		EquivalenceFunction -> RoundMatchQ[5]
	]
}
];


(* ::Subsubsection:: *)
(*ValidAnalyzeAbsorbanceQuantificationQ*)


DefineTests[ValidAnalyzeAbsorbanceQuantificationQ, {
	Example[{Basic,"Return test results for all the gathered tests/warning:"},
		ValidAnalyzeAbsorbanceQuantificationQ[
			{
				Object[Data, AbsorbanceSpectroscopy, "id:vXl9j57qVowm"],
				Object[Data, AbsorbanceSpectroscopy, "id:9RdZXv1K4Voj"],
				Object[Data, AbsorbanceSpectroscopy, "id:M8n3rx0YwmZO"],
				Object[Data, AbsorbanceSpectroscopy, "id:n0k9mG8znXw3"],
				Object[Data, AbsorbanceSpectroscopy, "id:Z1lqpMzGnb8V"],
				Object[Data, AbsorbanceSpectroscopy, "id:pZx9jo8n1RL5"],
				Object[Data, AbsorbanceSpectroscopy, "id:XnlV5jKm68Mz"],
				Object[Data, AbsorbanceSpectroscopy, "id:O81aEBZ4Dm91"],
				Object[Data, AbsorbanceSpectroscopy, "id:o1k9jAGK0q3E"],
				Object[Data, AbsorbanceSpectroscopy, "id:L8kPEjnN5m96"],
				Object[Data, AbsorbanceSpectroscopy, "id:kEJ9mqRalpLL"],
				Object[Data, AbsorbanceSpectroscopy, "id:D8KAEvGdLp9L"],
				Object[Data, AbsorbanceSpectroscopy, "id:J8AY5jDw3OmB"],
				Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0JdVkEL"],
				Object[Data, AbsorbanceSpectroscopy, "id:7X104vnKepdw"],
				Object[Data, AbsorbanceSpectroscopy, "id:xRO9n3BvqW06"],
				Object[Data, AbsorbanceSpectroscopy, "id:mnk9jOR3EVaK"],
				Object[Data, AbsorbanceSpectroscopy, "id:WNa4ZjKR3m9E"]
			}
		],
		True
	],
	Example[{Basic,"Given list of absorbance spectroscopy data:"},
		ValidAnalyzeAbsorbanceQuantificationQ[{Object[Data,AbsorbanceSpectroscopy,"id:n0k9mGz5P88p"],Object[Data,AbsorbanceSpectroscopy,"id:01G6nvkJRwGY"],Object[Data,AbsorbanceSpectroscopy,"id:R8e1PjREZpYX"],Object[Data,AbsorbanceSpectroscopy,"id:Vrbp1jG34KKz"],Object[Data,AbsorbanceSpectroscopy,"id:lYq9jRzZPx8O"]}],
		True
	],

	Example[{Options,OutputFormat,"Specify OutputFormat to be TestSummary:"},
		ValidAnalyzeAbsorbanceQuantificationQ[
			{
				Object[Data, AbsorbanceSpectroscopy, "id:vXl9j57qVowm"],
				Object[Data, AbsorbanceSpectroscopy, "id:9RdZXv1K4Voj"],
				Object[Data, AbsorbanceSpectroscopy, "id:M8n3rx0YwmZO"],
				Object[Data, AbsorbanceSpectroscopy, "id:n0k9mG8znXw3"],
				Object[Data, AbsorbanceSpectroscopy, "id:Z1lqpMzGnb8V"],
				Object[Data, AbsorbanceSpectroscopy, "id:pZx9jo8n1RL5"],
				Object[Data, AbsorbanceSpectroscopy, "id:XnlV5jKm68Mz"],
				Object[Data, AbsorbanceSpectroscopy, "id:O81aEBZ4Dm91"],
				Object[Data, AbsorbanceSpectroscopy, "id:o1k9jAGK0q3E"],
				Object[Data, AbsorbanceSpectroscopy, "id:L8kPEjnN5m96"],
				Object[Data, AbsorbanceSpectroscopy, "id:kEJ9mqRalpLL"],
				Object[Data, AbsorbanceSpectroscopy, "id:D8KAEvGdLp9L"],
				Object[Data, AbsorbanceSpectroscopy, "id:J8AY5jDw3OmB"],
				Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0JdVkEL"],
				Object[Data, AbsorbanceSpectroscopy, "id:7X104vnKepdw"],
				Object[Data, AbsorbanceSpectroscopy, "id:xRO9n3BvqW06"],
				Object[Data, AbsorbanceSpectroscopy, "id:mnk9jOR3EVaK"],
				Object[Data, AbsorbanceSpectroscopy, "id:WNa4ZjKR3m9E"]
			},
			OutputFormat->TestSummary
		],
		_EmeraldTestSummary
	],
	Example[{Options,Verbose,"Specify Verbose to be True:"},
		ValidAnalyzeAbsorbanceQuantificationQ[
			{
				Object[Data, AbsorbanceSpectroscopy, "id:vXl9j57qVowm"],
				Object[Data, AbsorbanceSpectroscopy, "id:9RdZXv1K4Voj"],
				Object[Data, AbsorbanceSpectroscopy, "id:M8n3rx0YwmZO"],
				Object[Data, AbsorbanceSpectroscopy, "id:n0k9mG8znXw3"],
				Object[Data, AbsorbanceSpectroscopy, "id:Z1lqpMzGnb8V"],
				Object[Data, AbsorbanceSpectroscopy, "id:pZx9jo8n1RL5"],
				Object[Data, AbsorbanceSpectroscopy, "id:XnlV5jKm68Mz"],
				Object[Data, AbsorbanceSpectroscopy, "id:O81aEBZ4Dm91"],
				Object[Data, AbsorbanceSpectroscopy, "id:o1k9jAGK0q3E"],
				Object[Data, AbsorbanceSpectroscopy, "id:L8kPEjnN5m96"],
				Object[Data, AbsorbanceSpectroscopy, "id:kEJ9mqRalpLL"],
				Object[Data, AbsorbanceSpectroscopy, "id:D8KAEvGdLp9L"],
				Object[Data, AbsorbanceSpectroscopy, "id:J8AY5jDw3OmB"],
				Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0JdVkEL"],
				Object[Data, AbsorbanceSpectroscopy, "id:7X104vnKepdw"],
				Object[Data, AbsorbanceSpectroscopy, "id:xRO9n3BvqW06"],
				Object[Data, AbsorbanceSpectroscopy, "id:mnk9jOR3EVaK"],
				Object[Data, AbsorbanceSpectroscopy, "id:WNa4ZjKR3m9E"]
			},
			Verbose->True
		],
		True
	]
	
}

];


(* ::Section:: *)
(*End Test Package*)
