(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*General Analysis Helpers: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*Absorbance*)


DefineTests[
	Absorbance,
	{
		Example[{Basic,"Extract the absorbance from a raw spectrum at a particular wavelength:"},
			Absorbance[spectrum,260 Nano Meter],
			Quantity[0.0694`,IndependentUnit["AbsorbanceUnit"]]
		],
		Example[{Basic,"Extract a range of absorbances by providing a minimum and maximum wavelength:"},
			Absorbance[qaSpectrum,260 Nano Meter;;280 Nano Meter],
			{Quantity[0.0694`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0689`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.068`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0669`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0656`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0654`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0642`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0633`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0634`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0626`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0616`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.061`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.06`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0599`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0591`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0587`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0579`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0577`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0572`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0576`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0567`,IndependentUnit["AbsorbanceUnit"]]}
		],
		Example[{Basic,"A link can be provided:"},
			Absorbance[Link[Object[Data, AbsorbanceSpectroscopy, "id:kEJ9mqaVOr8z"]],260 Nano Meter;;280 Nano Meter],
			{Quantity[0.0694`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0689`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.068`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0669`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0656`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0654`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0642`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0633`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0634`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0626`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0616`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.061`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.06`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0599`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0591`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0587`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0579`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0577`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0572`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0576`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0567`,IndependentUnit["AbsorbanceUnit"]]}
		],
		Example[{Basic,"A packet can be provided:"},
			Absorbance[Download[Object[Data, AbsorbanceSpectroscopy, "id:kEJ9mqaVOr8z"]],260 Nano Meter;;280 Nano Meter],
			{Quantity[0.0694`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0689`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.068`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0669`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0656`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0654`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0642`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0633`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0634`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0626`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0616`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.061`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.06`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0599`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0591`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0587`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0579`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0577`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0572`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0576`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0567`,IndependentUnit["AbsorbanceUnit"]]}
		],
		Example[{Basic,"Provide an absorbance data from which the spectrum should be taken:"},
			Absorbance[Object[Data, AbsorbanceSpectroscopy, "id:kEJ9mqaVOr8z"],260 Nano Meter;;280 Nano Meter],
			{Quantity[0.0694`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0689`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.068`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0669`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0656`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0654`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0642`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0633`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0634`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0626`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0616`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.061`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.06`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0599`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0591`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0587`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0579`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0577`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0572`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0576`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0567`,IndependentUnit["AbsorbanceUnit"]]},
			Stubs:>{
				(* abs spec data *)
				Download[Object[Data, AbsorbanceSpectroscopy, "id:kEJ9mqaVOr8z"]] = Association[{
						Type->Object[Data,AbsorbanceSpectroscopy],
						AbsorbanceSpectrum->spectrum
					}
				]
			}
		],
		Example[{Additional,"Absorbance can be determined from multiple data objects at once:"},
			Absorbance[{Object[Data, AbsorbanceSpectroscopy, "id:kEJ9mqaVOr8z"],Object[Data, AbsorbanceSpectroscopy, "id:3em6Zv9NKVrv"]},300 Nano Meter],
			{Quantity[0.05`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0704`,IndependentUnit["AbsorbanceUnit"]]},
			Stubs:>{
				(* abs spec data *)
				Download[Object[Data, AbsorbanceSpectroscopy, "id:kEJ9mqaVOr8z"]] = Association[{
					Type->Object[Data,AbsorbanceSpectroscopy],
						AbsorbanceSpectrum->spectrum
					}
				],
				Download[Object[Data, AbsorbanceSpectroscopy, "id:3em6Zv9NKVrv"]] = Association[{
					Type->Object[Data,AbsorbanceSpectroscopy],
						AbsorbanceSpectrum->(spectrum+1)
					}
				]
			}
		],
		Example[{Additional,"Provide a blank spectrum to be subtracted from the input spectrum:"},
			Absorbance[Object[Data, AbsorbanceSpectroscopy, "id:kEJ9mqaVOr8z"],260 Nano Meter,spectrum],
			Quantity[0.`,IndependentUnit["AbsorbanceUnit"]],
			Stubs:>{
				Download[Object[Data, AbsorbanceSpectroscopy, "id:kEJ9mqaVOr8z"]] = Association[{
					Type->Object[Data,AbsorbanceSpectroscopy],
						AbsorbanceSpectrum->(spectrum+1)
					}
				]
			}
		],
		Example[{Additional,"The blank can also be provided as a data object:"},
			Absorbance[Object[Data, AbsorbanceSpectroscopy, "id:kEJ9mqaVOr8z"],260 Nano Meter,Object[Data, AbsorbanceSpectroscopy, "id:3em6Zv9NKVrv"]],
			Quantity[-0.578`,IndependentUnit["AbsorbanceUnit"]],
			Stubs:>{
				Download[Object[Data, AbsorbanceSpectroscopy, "id:kEJ9mqaVOr8z"]] = Association[{
					Type->Object[Data,AbsorbanceSpectroscopy],
						AbsorbanceSpectrum->QuantityArray[MapAt[AbsorbanceUnit+#&,qaSpectrum,{;;,2}]]
					}
				],
				Download[Object[Data, AbsorbanceSpectroscopy, "id:3em6Zv9NKVrv"]] = Association[{
					Type->Object[Data,AbsorbanceSpectroscopy],
						AbsorbanceSpectrum->qaSpectrum
					}
				]
			}
		],
		Example[{Additional,"Provide a list of blank spectra to match up with a list of inputs:"},
			Absorbance[{Object[Data, AbsorbanceSpectroscopy, "id:kEJ9mqaVOr8z"],Object[Data, AbsorbanceSpectroscopy, "id:3em6Zv9NKVrv"]},280 Nano Meter,{Object[Data, AbsorbanceSpectroscopy, "id:lYq9jRzXGbOY"],Object[Data, AbsorbanceSpectroscopy, "id:E8zoYveR1wOB"]}],
			{Quantity[-0.4151`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.3366`,IndependentUnit["AbsorbanceUnit"]]},
			Stubs:>{
				Download[Object[Data, AbsorbanceSpectroscopy, "id:kEJ9mqaVOr8z"]] = Association[{
					Type->Object[Data,AbsorbanceSpectroscopy],
						AbsorbanceSpectrum->(spectrum+1)
					}
				],
				Download[Object[Data, AbsorbanceSpectroscopy, "id:3em6Zv9NKVrv"]] = Association[{
					Type->Object[Data,AbsorbanceSpectroscopy],
						AbsorbanceSpectrum->(spectrum+1)
					}
				],
				Download[Object[Data, AbsorbanceSpectroscopy, "id:lYq9jRzXGbOY"]] = Association[{
					Type->Object[Data,AbsorbanceSpectroscopy],
						AbsorbanceSpectrum->spectrum
					}
				],
				Download[Object[Data, AbsorbanceSpectroscopy, "id:E8zoYveR1wOB"]] = Association[{
					Type->Object[Data,AbsorbanceSpectroscopy],
						AbsorbanceSpectrum->spectrum
					}
				]
			}
		],
		Example[{Messages,"ListedBlankWithSingleInput","If a single spectrum is provided, the Blank option can't be a list:"},
			Absorbance[spectrum,280 Nano Meter,{spectrum,spectrum}],
			$Failed,
			Messages:>{
				Absorbance::ListedBlankWithSingleInput
			}
		],
		Example[{Messages,"WavelengthMismatch","If the minimum wavelength is larger than the maximumm, the function will fail:"},
			Absorbance[spectrum,290 Nano Meter;;280 Nano Meter],
			$Failed,
			Messages:>{
				Absorbance::WavelengthMismatch
			}
		],
		Example[{Messages,"WavelengthLowerBoundError","If the minimum wavelength is below the lowest wavelength in the spectrum, the function will fail:"},
			Absorbance[spectrum,1 Nano Meter;;500 Nano Meter],
			$Failed,
			Messages:>{
				Absorbance::WavelengthLowerBoundError
			}
		],
		Example[{Messages,"WavelengthUpperBoundError","If the maximum wavelength is above the largest wavelength in the spectrum, the function will fail:"},
			Absorbance[spectrum,250 Nano Meter;;100000 Nano Meter],
			$Failed,
			Messages:>{
				Absorbance::WavelengthUpperBoundError
			}
		],
		Example[{Messages,"InvalidBlankOption","If the maximum wavelength is above the largest wavelength in the spectrum, the function will fail:"},
			Absorbance[{Object[Data, AbsorbanceSpectroscopy, "id:20"],Object[Data, AbsorbanceSpectroscopy, "id:21"]},260 Nano Meter,{Object[Data, AbsorbanceSpectroscopy, "id:22"]}],
			$Failed,
			Messages:>{
				Absorbance::InvalidBlankOption
			}
		],
		(* removed the catch all overload to enable Absorbance UnitOperations *)
		Example[{Messages,"InvalidAbsorbance","If absorbance spectrum or wavelength is invalid, the function will not evaluate:"},
			Absorbance[{1,2,3}],
			Absorbance[{1,2,3}]
		],
		Example[{Additional,"The function is also listable over raw spectra:"},
			Absorbance[{spectrum,spectrum},260 Nano Meter],
			{Quantity[0.0694`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.0694`,IndependentUnit["AbsorbanceUnit"]]}
		]
	},
	SetUp:>{
		spectrum = {{220, 0.1695}, {221, 0.1612}, {222, 0.1489}, {223, 0.1383}, {224,
			0.1298}, {225, 0.1205}, {226, 0.114}, {227, 0.1098}, {228,
			0.1075}, {229, 0.1056}, {230, 0.1035}, {231, 0.103}, {232,
			0.1027}, {233, 0.1013}, {234, 0.1002}, {235, 0.0994}, {236,
			0.0977}, {237, 0.097}, {238, 0.0966}, {239, 0.095}, {240,
			0.0938}, {241, 0.0925}, {242, 0.092}, {243, 0.0914}, {244,
			0.0901}, {245, 0.0876}, {246, 0.0867}, {247, 0.0859}, {248,
			0.0855}, {249, 0.0839}, {250, 0.0827}, {251, 0.0817}, {252,
			0.081}, {253, 0.0794}, {254, 0.0788}, {255, 0.0766}, {256,
			0.0752}, {257, 0.0731}, {258, 0.0719}, {259, 0.0708}, {260,
			0.0694}, {261, 0.0689}, {262, 0.068}, {263, 0.0669}, {264,
			0.0656}, {265, 0.0654}, {266, 0.0642}, {267, 0.0633}, {268,
			0.0634}, {269, 0.0626}, {270, 0.0616}, {271, 0.061}, {272,
			0.06}, {273, 0.0599}, {274, 0.0591}, {275, 0.0587}, {276,
			0.0579}, {277, 0.0577}, {278, 0.0572}, {279, 0.0576}, {280,
			0.0567}, {281, 0.0555}, {282, 0.0558}, {283, 0.0556}, {284,
			0.0544}, {285, 0.0538}, {286, 0.0537}, {287, 0.0537}, {288,
			0.0534}, {289, 0.0528}, {290, 0.0524}, {291, 0.0521}, {292,
			0.0519}, {293, 0.0514}, {294, 0.0513}, {295, 0.0503}, {296,
			0.0508}, {297, 0.0507}, {298, 0.0501}, {299, 0.0505}, {300,
			0.05}, {301, 0.0486}, {302, 0.0487}, {303, 0.0489}, {304,
			0.0488}, {305, 0.0482}, {306, 0.0481}, {307, 0.0478}, {308,
			0.0472}, {309, 0.0473}, {310, 0.0471}, {311, 0.0473}, {312,
			0.0472}, {313, 0.0466}, {314, 0.0457}, {315, 0.0458}, {316,
			0.0464}, {317, 0.0461}, {318, 0.0452}, {319, 0.0459}},
		qaSpectrum = QuantityArray[{{220, 0.1695}, {221, 0.1612}, {222, 0.1489}, {223, 0.1383}, {224,
			0.1298}, {225, 0.1205}, {226, 0.114}, {227, 0.1098}, {228,
			0.1075}, {229, 0.1056}, {230, 0.1035}, {231, 0.103}, {232,
			0.1027}, {233, 0.1013}, {234, 0.1002}, {235, 0.0994}, {236,
			0.0977}, {237, 0.097}, {238, 0.0966}, {239, 0.095}, {240,
			0.0938}, {241, 0.0925}, {242, 0.092}, {243, 0.0914}, {244,
			0.0901}, {245, 0.0876}, {246, 0.0867}, {247, 0.0859}, {248,
			0.0855}, {249, 0.0839}, {250, 0.0827}, {251, 0.0817}, {252,
			0.081}, {253, 0.0794}, {254, 0.0788}, {255, 0.0766}, {256,
			0.0752}, {257, 0.0731}, {258, 0.0719}, {259, 0.0708}, {260,
			0.0694}, {261, 0.0689}, {262, 0.068}, {263, 0.0669}, {264,
			0.0656}, {265, 0.0654}, {266, 0.0642}, {267, 0.0633}, {268,
			0.0634}, {269, 0.0626}, {270, 0.0616}, {271, 0.061}, {272,
			0.06}, {273, 0.0599}, {274, 0.0591}, {275, 0.0587}, {276,
			0.0579}, {277, 0.0577}, {278, 0.0572}, {279, 0.0576}, {280,
			0.0567}, {281, 0.0555}, {282, 0.0558}, {283, 0.0556}, {284,
			0.0544}, {285, 0.0538}, {286, 0.0537}, {287, 0.0537}, {288,
			0.0534}, {289, 0.0528}, {290, 0.0524}, {291, 0.0521}, {292,
			0.0519}, {293, 0.0514}, {294, 0.0513}, {295, 0.0503}, {296,
			0.0508}, {297, 0.0507}, {298, 0.0501}, {299, 0.0505}, {300,
			0.05}, {301, 0.0486}, {302, 0.0487}, {303, 0.0489}, {304,
			0.0488}, {305, 0.0482}, {306, 0.0481}, {307, 0.0478}, {308,
			0.0472}, {309, 0.0473}, {310, 0.0471}, {311, 0.0473}, {312,
			0.0472}, {313, 0.0466}, {314, 0.0457}, {315, 0.0458}, {316,
			0.0464}, {317, 0.0461}, {318, 0.0452}, {319, 0.0459}},{Nanometer,AbsorbanceUnit}]
	}
];


(* ::Subsection::Closed:: *)
(*Concentration*)


DefineTests[
	Concentration,
	{
		Example[{Basic,"Calculate a concentration given an absorbance, path length, and extinction coefficient:"},
			Concentration[1 AbsorbanceUnit,1 Centi Meter,100000*Liter/(Centi Meter Mole)],
			Quantity[1/100000,"Molar"]
		],
		Example[{Basic,"Provide an oligomer sample to serve as the extinction coefficient; its extinction coefficient will be calculated and used:"},
			Concentration[1 AbsorbanceUnit,1 Centi Meter,Object[Sample, "id:jLq9jXY0ZXra"]],
			Quantity[1/164800,"Molar"]
		],
		Example[{Basic,"Provide a list of absorbances, path lengths, and extinction coefficients:"},
			Concentration[{1 AbsorbanceUnit,2 AbsorbanceUnit},{1 Centi Meter,1.1 Centi Meter},{(100000*Liter/(Centi Meter Mole)),(90000*Liter/(Centi Meter Mole))}],
			{Quantity[1/100000,"Molar"],Quantity[0.0000202020202020202`,"Molar"]}
		],
		Example[{Messages,"MismatchedInputLengths","The function will return if the lengths of the input lists do not match:"},
			Concentration[{1 AbsorbanceUnit,1.1 AbsorbanceUnit},{1 Centi Meter,1.5 Centi Meter},{10000*Liter/(Centi Meter Mole)}],
			$Failed,
			Messages:>{
				Concentration::MismatchedInputLengths
			}
		]
	}
];


(* ::Subsection:: *)
(*PathLength*)


DefineTests[
	PathLength,
	{
		Example[{Basic,"When provided a blank and sample distance, subtracts the sample from the blank to return path length:"},
			PathLength[50 Milli Meter,45 Milli Meter],
			Quantity[1/2,"Centimeters"]
		],
		Example[{Basic,"When provided with a volume and a volume calibration, inverts the volume calibration to return path length:"},
			PathLength[100 Micro Liter,Object[Calibration,Volume,"id:xRO9n3vo81N6"]],
			Quantity[265.4656410286745`,"Centimeters"]
		],
		Example[{Basic,"Provide empty absorbance and sample datas along with an absorbance-to-pathlength calibration to return path length:"},
			PathLength[Object[Data,AbsorbanceSpectroscopy,"id:L8kPEjN3mqBw"],Object[Data,AbsorbanceSpectroscopy,"id:E8zoYveX4Z3A"],Object[Calibration,PathLength,"id:GmzlKjY5eBrE"]],
			Quantity[0.4840034568057403`,"Centimeters"]
		],
		Example[{Basic,"Lists of empty and sample absorbances can be provided:"},
			PathLength[{Object[Data,AbsorbanceSpectroscopy,"id:L8kPEjN3mqBw"],Object[Data,AbsorbanceSpectroscopy,"id:E8zoYveX4Z3A"]},{Object[Data,AbsorbanceSpectroscopy,"id:Y0lXejGp93zv"],Object[Data,AbsorbanceSpectroscopy,"id:kEJ9mqaWpzX3"]},Object[Calibration,PathLength,"id:GmzlKjY5eBrE"]],
			{Quantity[0.49684618148779014`,"Centimeters"],Quantity[0.4835063608249637`,"Centimeters"]}
		],
		Example[{Options,MinRamanScattering,"The minimum raman scattering distance where the calibrations are being done:"},
			PathLength[{Object[Data,AbsorbanceSpectroscopy,"id:L8kPEjN3mqBw"],Object[Data,AbsorbanceSpectroscopy,"id:E8zoYveX4Z3A"]},{Object[Data,AbsorbanceSpectroscopy,"id:Y0lXejGp93zv"],Object[Data,AbsorbanceSpectroscopy,"id:kEJ9mqaWpzX3"]},Object[Calibration,PathLength,"id:GmzlKjY5eBrE"],MinRamanScattering->940 Nanometer],
			{Quantity[0.494163671074223, "Centimeters"], Quantity[0.4836137720101879, "Centimeters"]}
		],
		Example[{Options,MaxRamanScattering,"The maximum raman scattering distance where the calibrations are being done:"},
			PathLength[{Object[Data,AbsorbanceSpectroscopy,"id:L8kPEjN3mqBw"],Object[Data,AbsorbanceSpectroscopy,"id:E8zoYveX4Z3A"]},{Object[Data,AbsorbanceSpectroscopy,"id:Y0lXejGp93zv"],Object[Data,AbsorbanceSpectroscopy,"id:kEJ9mqaWpzX3"]},Object[Calibration,PathLength,"id:GmzlKjY5eBrE"],MaxRamanScattering->1000 Nanometer],
			{Quantity[0.496794441608827, "Centimeters"], Quantity[0.4835315133507049, "Centimeters"]}
		],
		Example[{Messages,"BlankSmallerThanSample","A soft message will be thrown if the provided blank is less than the sample:"},
			PathLength[1 Centi Meter,2 Centi Meter],
			Quantity[-1,"Centimeters"],
			Messages:>{
				PathLength::BlankSmallerThanSample
			}
		],
		Example[{Messages,"NonLinearPathLengthFit","If the fit function in the path length to volume calibration is non-linear, the function will fail:"},
			PathLength[100 Micro Liter,Object[Calibration, Volume, "id:10"]],
			$Failed,
			Messages:>{
				PathLength::NonLinearPathLengthFit
			},
			Stubs:>{
				(* calibration info *)
				Download[Object[Calibration, Volume, "id:10"],CalibrationFunction] := (#^2&)
			}
		],
		Example[{Messages,"MismatchedEmptyAndSampleLenghts","The function will fail if the empty and sample absorbance lists do not match in length:"},
			PathLength[{Object[Data,AbsorbanceSpectroscopy,"id:L8kPEjN3mqBw"],Object[Data,AbsorbanceSpectroscopy,"id:E8zoYveX4Z3A"]},{Object[Data,AbsorbanceSpectroscopy,"id:Y0lXejGp93zv"]},Object[Calibration,PathLength,"id:GmzlKjY5eBrE"]],
			$Failed,
			Messages:>{
				PathLength::MismatchedEmptyAndSampleLenghts
			}
		]
	}
];


(* ::Subsection:: *)
(*SequenceAlignmentTable*)


DefineTests[SequenceAlignmentTable,
	{
		Example[{Basic,"Align two string sequences and show a summary of the alignment:"},
			SequenceAlignmentTable[testSeq1,testSeq2],
			_Pane
		],
		Example[{Basic,"Align a string sequence with an explicitly typed sequence:"},
			SequenceAlignmentTable[testSeq1,DNA["AAACTAATCTAGGAT"]],
			_Pane
		],
		Example[{Basic,"Align a known sequence with the sequence linked to a DNASequencing data object:"},
			SequenceAlignmentTable[Object[Data,DNASequencing,"id:Z1lqpMz7Eq69"],pGEMSequence],
			_Pane
		],
		Example[{Basic,"Align a known sequence with the sequence linked to a DNASequencing analysis object:"},
			SequenceAlignmentTable[Object[Analysis,DNASequencing,"pGEM Analysis"],pGEMSequence],
			_Pane
		],
		Example[{Options,Method,"Set Method to NeedlemanWunsch to do a global alignment using NeedlemanWunschSimilarity[]:"},
			SequenceAlignmentTable[testSeq1, DNA["AAACTAATCTAGGAT"],Method->NeedlemanWunsch],
			_Pane
		],
		Example[{Options,Method,"Set Method to SmithWaterman to do a local alignment using SmithWatermanSimilarity[]:"},
			SequenceAlignmentTable[testSeq1, DNA["AAACTAATCTAGGAT"],Method->SmithWaterman],
			_Pane
		],
		Example[{Options,GapPenalty,"By default, the GapPenalty is zero and a global alignment is used. If one sequence is much shorter than the other, this shorter sequence can be substantially fragmented in the alignment:"},
			SequenceAlignmentTable[testSeq1, DNA["AAACTAATCTAGGAT"],GapPenalty->0],
			_Pane
		],
		Example[{Options,GapPenalty,"Increasing the GapPenalty reduces the number of discontinuous gaps in the alignment at the expense of decreasing the number of matches:"},
			SequenceAlignmentTable[testSeq1, DNA["AAACTAATCTAGGAT"],GapPenalty->5],
			_Pane
		],
		Example[{Options,PreviewLineWidth,"Set the maximum number of characters to show on each line of the graphical preview:"},
			SequenceAlignmentTable[testSeq1,testSeq2,PreviewLineWidth->25],
			_Pane
		],
		Example[{Options,PreviewLineWidth,"The default PreviewLineWidth is 60:"},
			SequenceAlignmentTable[testSeq1,testSeq2],
			_Pane
		],
		Example[{Options,OutputFormat,"OutputFormat defaults to Table which shows a summary of the alignment:"},
			SequenceAlignmentTable[testSeq1,testSeq2],
			_Pane
		],
		Example[{Options,SimilarityRules,"The default similarity rules are {{a_, a_} -> 1, {a_, b_} -> -1}, which assigns a score of 1 to matches and -1 to mismatches. SequenceAlignmentTable aligns sequences by maximizing this score:"},
			SequenceAlignmentTable[testSeq1,testSeq2,SimilarityRules->{{a_, a_} -> 1, {a_, b_} -> -1}],
			_Pane
		],
		Example[{Options,SimilarityRules,"Ruin your alignment by favoring mismatches and penalizing matches:"},
			SequenceAlignmentTable[testSeq1,testSeq2,SimilarityRules->{{a_, a_} -> -1, {a_, b_} -> 1}],
			_Pane
		],
		Example[{Options,OutputFormat,"Set OutputFormat to List to return a list of computed quantities:"},
			SequenceAlignmentTable[testSeq1,testSeq2,OutputFormat->List],
			{
				AlignedSequenceLength->56,
				Method->NeedlemanWunsch,
				GapPenalty->0,
				SequenceIdentity->15/28,
				PercentIdentity->53.6 Percent,
				GapCount->16,
				GapPercentage->28.6 Percent,
				Preview->_Column
			}
		],
		Example[{Options,OutputFormat,"The listed OutputFormat is useful when alignment results are needed in other calculations:"},
			Lookup[SequenceAlignmentTable[testSeq1,testSeq2,OutputFormat->List],PercentIdentity],
			53.6 Percent
		],
		Example[{Messages,"InvalidInputSequence","Error shows if a sequence could not be resolved from one or more inputs:"},
			SequenceAlignmentTable[testSeq1,dataPacketNoSequence],
			$Failed,
			Messages:>{Error::InvalidInputSequence}
		],
		Test["Global sequence alignment exact test:",
			SequenceAlignmentTable[testSeq1,DNA["AAACTAATCTAGGAT"],Method->NeedlemanWunsch,OutputFormat->List],
			{
				AlignedSequenceLength->45,
				Method->NeedlemanWunsch,
				GapPenalty->0,
				SequenceIdentity->13/45,
				PercentIdentity->28.9 Percent,
				GapCount->30,
				GapPercentage->66.7 Percent,
				Preview->_Column
			}
		],
		Test["Local sequence alignment exact test:",
			SequenceAlignmentTable[testSeq1,DNA["AAACTAATCTAGGAT"],Method->SmithWaterman,OutputFormat->List],
			{
				AlignedSequenceLength->50,
				Method->SmithWaterman,
				GapPenalty->0,
				SequenceIdentity->4/25,
				PercentIdentity->16. Percent,
				GapCount->40,
				GapPercentage->80. Percent,
				Preview->_Column
			}
		],
		Test["Increasing gap penalty decreases sequence identity:",
			Lookup[SequenceAlignmentTable[testSeq1,DNA["AAACCATCGAATCTAGGAT"],OutputFormat->List,GapPenalty->#],PercentIdentity]&/@Range[5],
			{35.6 Percent, 26.7 Percent, 22.2 Percent, 19.6 Percent, 13.3 Percent}
		],
		Test["Reversing the similarity rules results in zero alignment:",
			Lookup[SequenceAlignmentTable[testSeq1,testSeq2,SimilarityRules->{{a_, a_} -> -1, {a_, b_} -> 1},OutputFormat->List],PercentIdentity],
			0.0 Percent
		]
	},

	(* Define raw data for testing *)
	Variables:>{testSeq1,testSeq2,pGEMSequence,dataPacketNoSequence},
	SetUp:>(
		(* Short DNA Sequences for tests *)
		testSeq1="ATGAGTCTCTCTGATAAGGACAAGGCTGCTGTGAAAGCCCTATGG";
		testSeq2="CTGTCTCCTGCCGACAAGACCAACGTCAAGGCCGCCTGGGGTAAGAAAACT";
		(* Known sequence from DNASequencing instrument manual *)
		pGEMSequence="TGTAAAACGACGGCCAGTGAATTGTAATACGACTCACTATAGGGCGAATTCGAGCTCGGTACCCGGGGATCCTCTAGAGTCGACCTGCAGGCATGCAAGCTTGAGTATTCTATAGTGTCACCTAAATAGCTTGGCGTAATCATGGTCATAGCTGTTTCCTGTGTGAAATTGTTATCCGCTCACAATTCCACACAACATACGAGCCGGAAGCATAAAGTGTAAAGCCTGGGGTGCCTAATGAGTGAGCTAACTCACATTAATTGCGTTGCGCTCACTGCCCGCTTTCCAGTCGGGAAACCTGTCGTGCCAGCTGCATTAATGAATCGGCCAACGCGCGGGGAGAGGCGGTTTGCGTATTGGGCGCTCTTCCGCTTCCTCGCTCACTGACTCGCTGCGCTCGGTCGTTCGGCTGCGGCGAGCGGTATCAGCTCACTCAAAGGCGGTAATACGGTTATCCACAGAATCAGGGGATAACGCAGGAAAGAACATGTGAGCAAAAGGCCAGCAAAAGGCCAGGAACCGTAAAAAGGCCGCGTTGCTGGCGTTTTTCCATAGGCTCCGCCCCCCTGACGAGCATCACAAAAATCGACGCTCAAGTCAGAGGTGGCGAAACCCGACAGGACTATAAAGATACCAGGCGTTTCCCCCTGGAAGCTCCCTCGTGCGCTCTCCTGTTCCGACCCTGCCGCTTACCGGATACCTGTCCGCCTTTCTCCCTTCGGGAAGCGTGGCGCTTTCTCATAGCTCACGCTGTAGGTATCTCAGTTCGGTGTAGGTCGTTCGCTCCAAGCTGGGCTGTGTGCACGAACCCCCCGTTCAGCCCGACCGCTGCGCCTTATCCGGTAACTATCGTCTTGAGTCCAACCCGGTAAGACACGACTTATCGCCACTGGCAGCAGCCACTGGTAACAGGATTAGCAGAGCGAGGTATGTAGGCGGTGCTACAGAGTTCTTGAAGTGGTGGCCTAACTACGGCTACACTAGAAGGACAGTATTTGGTATCTGCGCTCTGCTGAAG";
		dataPacketNoSequence=<|Type->Object[Analysis,DNASequencing],SequenceAssignment->Null|>;
	)
];


(* ::Section:: *)
(*End Test Package*)
