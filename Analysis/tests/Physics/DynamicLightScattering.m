(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineTestsWithCompanions[
	AnalyzeDynamicLightScattering, 
	{
		(* ---- Basic ---- *)

		Example[{Basic, "Analyze dynamic light scattering data to create an Analysis Object:"},
			AnalyzeDynamicLightScattering[Object[Data,DynamicLightScattering,"id:E8zoYvNpPJ9b"]],
			ObjectP[Object[Analysis, DynamicLightScattering]],
			Messages :> {Warning::CurvesOutsideRangeRemoved}
		],

		Example[{Basic, "Calculate the diffusion interaction parameter:"},
			AnalyzeDynamicLightScattering[Object[Data,DynamicLightScattering,"id:E8zoYvNpPJ9b"]][DiffusionInteractionParameterStatistics][[1]],
			Quantity[-37.63710452999915`, ("Milliliters")/("Grams")],
			EquivalenceFunction->RoundMatchQ[8],
			Messages :> {Warning::CurvesOutsideRangeRemoved}
		],

		Example[{Basic, "Calculate the second virial coefficient:"},
			AnalyzeDynamicLightScattering[Object[Data,DynamicLightScattering,"id:E8zoYvNpPJ9b"]][SecondVirialCoefficientStatistics][[1]],
			Quantity[0.00003831439643747803`, ("Milliliters" "Moles")/("Grams")^2],
			EquivalenceFunction->RoundMatchQ[8],
			Messages :> {Warning::CurvesOutsideRangeRemoved}
		],

		(* ---- Additional ---- *)
		Example[{Additional, "Analyze melting curve data to create an Analysis Object:"},
			AnalyzeDynamicLightScattering[Object[Data, MeltingCurve, "id:dORYzZRLxE0w"]],
			ObjectP[Object[Analysis, DynamicLightScattering]]
		],

		Example[{Additional, "Analyze all data within a DynamicLightScattering Protocol:"},
			AnalyzeDynamicLightScattering[Object[Protocol, DynamicLightScattering, "id:9RdZXv14RVlJ"]],
			ListableP[ObjectP[Object[Analysis, DynamicLightScattering]]]
		],

		Example[{Additional, "For AssayType G22, calculate the Kirkwood-Buff Integral:"},
			AnalyzeDynamicLightScattering[Object[Data,DynamicLightScattering,"id:P5ZnEjd39MWR"]][KirkwoodBuffIntegralStatistics][KirkwoodBuffIntegral],
			Quantity[-8.379493867227442`, ("Milliliters")/("Grams")],
			EquivalenceFunction->RoundMatchQ[8]
		],

		Example[{Additional, "For AssayType G22, calculate the Z-average diameter using the cumulants method:"},
			AnalyzeDynamicLightScattering[Object[Data,DynamicLightScattering,"id:P5ZnEjd39MWR"], Method->Cumulants][ZAverageDiameters],
			{
				Quantity[19.774, "Nanometers"], Quantity[19.2177, "Nanometers"],
 				Quantity[19.8704, "Nanometers"], Quantity[18.382, "Nanometers"],
				Quantity[18.0341, "Nanometers"], Quantity[17.9959, "Nanometers"],
				Quantity[16.8762, "Nanometers"], Quantity[16.4984, "Nanometers"],
				Quantity[16.7226, "Nanometers"], Quantity[16.604, "Nanometers"],
				Quantity[15.3817, "Nanometers"], Quantity[14.833, "Nanometers"],
				Quantity[15.3539, "Nanometers"], Quantity[13.8899, "Nanometers"],
				Quantity[13.6912, "Nanometers"]
			},
			EquivalenceFunction->RoundMatchQ[3]
		],

		Example[{Additional, "For AssayType G22, create analysis objects of all data in the protocol:"},
			AnalyzeDynamicLightScattering[Object[Data,DynamicLightScattering,"id:P5ZnEjd39MWR"]],
			ListableP[ObjectP[Object[Analysis, DynamicLightScattering]]]
		],

		Example[{Additional, "For AssayType IsothermalStability, calculate the DiffusionCoefficients:"},
			AnalyzeDynamicLightScattering[Object[Data,DynamicLightScattering,"DLSTestData"<>$SessionUUID]][DiffusionCoefficients],
			{
				Quantity[3.978*10^-11, ("Meters")^2/("Seconds")],
				Quantity[4.106*10^-11, ("Meters")^2/("Seconds")],
				Quantity[4.051*10^-11, ("Meters")^2/("Seconds")],
				Quantity[4.095*10^-11, ("Meters")^2/("Seconds")],
				Quantity[4.071*10^-11, ("Meters")^2/("Seconds")]
			},
			EquivalenceFunction->RoundMatchQ[3]
		],

		Example[{Additional, "For AssayType IsothermalStability, calculate the ZAverageDiameters using the cumulants method:"},
			AnalyzeDynamicLightScattering[Object[Data,DynamicLightScattering,"DLSTestData"<>$SessionUUID], Method-> Cumulants][ZAverageDiameters],
			{
				Quantity[13.761, "Nanometers"],
				Quantity[13.4492, "Nanometers"],
				Quantity[13.4778, "Nanometers"],
				Quantity[13.2703, "Nanometers"],
				Quantity[13.7026, "Nanometers"]
			},
			EquivalenceFunction->RoundMatchQ[3]
		],

		Example[{Additional, "For AssayType IsothermalStability, create analysis objects of all data in the protocol:"},
			AnalyzeDynamicLightScattering[Object[Protocol,DynamicLightScattering,"DLSTestProtocol"<>$SessionUUID]],
			ListableP[ObjectP[Object[Analysis, DynamicLightScattering]]]
		],

		Example[{Additional, "For AssayType B22kD, calculate the PolyDispersityIndices using the cumulants method:"},
			AnalyzeDynamicLightScattering[Object[Data,DynamicLightScattering,"id:01G6nvGd3Zx4"], Method->Cumulants][PolyDispersityIndices],
			{0.21903, 0.210216, 0.209499, 0.206219, 0.203307, 0.17543, 0.125452, 0.154261, 0.0760994, 0.0644201, 0.0751246, 0.0646637, 0.399915},
			EquivalenceFunction->RoundMatchQ[3],
			Messages :> {Warning::CurvesOutsideRangeRemoved}
		],

		Example[{Additional, "For AssayType ThermalShift, calculate the ZAverageDiameters using the cumulants method:"},
			AnalyzeDynamicLightScattering[Object[Data,MeltingCurve,"id:dORYzZRLxE0w"], Method->Cumulants][ZAverageDiameters],
			{Quantity[9.05202, "Nanometers"], Quantity[56.9774, "Nanometers"]},
			EquivalenceFunction->RoundMatchQ[3]
		],

		Example[{Additional, "For AssayType SizingPolydispersity, calculate the zAverageDiameters using the cumulants method:"},
			AnalyzeDynamicLightScattering[Object[Data,DynamicLightScattering,"id:eGakldJRERVe"], Method->Cumulants][ZAverageDiameters],
			{Quantity[13.8888, "Nanometers"]},
			EquivalenceFunction->RoundMatchQ[3]
		],

		Example[{Additional, "For AssayType SizingPolydispersity, calculate the zAverageDiameters:"},
			AnalyzeDynamicLightScattering[Object[Data,DynamicLightScattering,"id:eGakldJRERVe"]][ZAverageDiameters],
			{Quantity[13.7, "Nanometers"]},
			EquivalenceFunction->RoundMatchQ[3]
		],

		(* ---- Options ---- *)

		(* Method *)
		Example[{Options, Method, "Calculate the diffusion interaction parameter using the Cumulants method:"},
			AnalyzeDynamicLightScattering[
				Object[Data,DynamicLightScattering,"id:E8zoYvNpPJ9b"],
				Method -> Cumulants
			][DiffusionInteractionParameterStatistics][[1]],
			Quantity[-42.02601155015144`, ("Milliliters")/("Grams")],
			EquivalenceFunction->RoundMatchQ[8],
			Messages :> {Warning::CurvesOutsideRangeRemoved}
		],

		(* PolynomialDegree *)
		Example[{Options, PolynomialDegree, "Calculate the diffusion interaction parameter using the Cumulants method with a PolynomialDegree of 2:"},
			AnalyzeDynamicLightScattering[
				Object[Data,DynamicLightScattering,"id:E8zoYvNpPJ9b"],
				Method -> Cumulants,
				PolynomialDegree->2
			][DiffusionInteractionParameterStatistics][[1]],
			Quantity[-38.55273183605962`, ("Milliliters")/("Grams")],
			EquivalenceFunction->RoundMatchQ[8],
			Messages :> {Warning::CurvesOutsideRangeRemoved}
		],

		(* ConvergenceTimeThreshold *)
		Example[{Options, ConvergenceTimeThreshold, "Exclude correlation curves that do not drop below ConvergenceCorrelationThreshold, before the ConvergenceTimeThreshold (Correlation Curves tab):"},
			AnalyzeDynamicLightScattering[
				Object[Data,DynamicLightScattering,"id:E8zoYvNpPJ9b"],
				Output->Preview,
				ConvergenceTimeThreshold -> 1000 Microsecond
			],
			_TabView,
			Messages :> {Warning::CurvesOutsideRangeRemoved}
		],

		(* ConvergenceCorrelationThreshold *)
		Example[{Options, ConvergenceCorrelationThreshold, "Exclude correlation curves that do not drop below ConvergenceCorrelationThreshold, before the ConvergenceTimeThreshold (Correlation Curves tab):"},
			AnalyzeDynamicLightScattering[
				Object[Data,DynamicLightScattering,"id:E8zoYvNpPJ9b"],
				Output->Preview,
				ConvergenceCorrelationThreshold -> 0.0001
			],
			_TabView,
			Messages :> {Warning::CurvesOutsideRangeRemoved}
		],


		(* InitialTimeThreshold *)
		Example[{Options, InitialTimeThreshold, "Exclude correlation curves that, on average, are above the InitialCorrelationMaximumThreshold or InitialCorrelationMinimumThreshold, before the InitialTimeThreshold (Correlation Curves tab):"},
			AnalyzeDynamicLightScattering[
				Object[Data,DynamicLightScattering,"id:E8zoYvNpPJ9b"],
				Output->Preview,
				InitialTimeThreshold -> 50 Microsecond
			],
			_TabView,
			Messages :> {Warning::CurvesOutsideRangeRemoved}
		],

		(* InitialCorrelationMinimumThreshold *)
		Example[{Options, InitialCorrelationMinimumThreshold, "Exclude correlation curves that, on average, are below the InitialCorrelationMinimumThreshold, before the InitialTimeThreshold (Correlation Curves tab):"},
			AnalyzeDynamicLightScattering[
				Object[Data,DynamicLightScattering,"id:E8zoYvNpPJ9b"],
				Output->Preview,
				InitialCorrelationMinimumThreshold -> 0.9
			],
			_TabView,
			Messages :> {Warning::CurvesOutsideRangeRemoved}
		],

		(* InitialCorrelationMaximumThreshold *)
		Example[{Options, InitialCorrelationMaximumThreshold, "Exclude correlation curves that, on average, are above the InitialCorrelationMaximumThreshold, before the InitialTimeThreshold (Correlation Curves tab):"},
			AnalyzeDynamicLightScattering[
				Object[Data,DynamicLightScattering,"id:E8zoYvNpPJ9b"],
				Output->Preview,
				InitialCorrelationMaximumThreshold -> 1.1
			],
			_TabView,
			Messages :> {Warning::CurvesOutsideRangeRemoved}
		],

		(* CorrelationMinimumValue *)
		Example[{Options, CorrelationMinimumValue, "Include only correlation curve data above the CorrelationMinimumValue for particle size estimation:"},
			AnalyzeDynamicLightScattering[
				Object[Data,DynamicLightScattering,"id:E8zoYvNpPJ9b"],
				Method->Cumulants,
				CorrelationMinimumValue -> 0.1
			][ZAverageDiameters],
			{Quantity[19.270760183071506`, "Nanometers"], Quantity[12.545285603685896`, "Nanometers"],  Quantity[2777.051691486452`, "Nanometers"],
 			Quantity[14.077948198834537`, "Nanometers"], Quantity[14.38893513703012`, "Nanometers"]},
			EquivalenceFunction->RoundMatchQ[8],
			Messages :> {Warning::NonSpecificationOption, Warning::CurvesOutsideRangeRemoved}
		],

		(* CorrelationMinimumMethod *)
		Example[{Options, CorrelationMinimumMethod, "If the CorrelationMinimumMethod is Relative it scales the CorrelationMinimumValue to the initial correlation curve value, otherwise if CorrelationMinimumMethod is Absolute, the CorrelationMinimumValue is also the same number for all correlation curves:"},
			AnalyzeDynamicLightScattering[
				Object[Data,DynamicLightScattering,"id:E8zoYvNpPJ9b"],
				Method->Cumulants,
				CorrelationMinimumValue -> 0.1,
				CorrelationMinimumMethod -> Relative
			][ZAverageDiameters],
			{Quantity[20.126279496962844`, "Nanometers"],  Quantity[12.571252758907512`, "Nanometers"], Quantity[2777.051691486452`, "Nanometers"],
 			Quantity[14.077948198834537`, "Nanometers"], Quantity[14.36298646397109`, "Nanometers"]},
			EquivalenceFunction->RoundMatchQ[8],
			Messages :> {Warning::NonSpecificationOption, Warning::CurvesOutsideRangeRemoved}
		],

		(* OpticalConstant *)
		Example[{Options, OpticalConstant, "Specify the optical constnat used in the calculation of the second virial coefficient:"},
			AnalyzeDynamicLightScattering[
				Object[Data,DynamicLightScattering,"id:E8zoYvNpPJ9b"],
				OpticalConstant-> 2.0*10^-7 Centimeter^2*Mole/Gram^2
			][SecondVirialCoefficientStatistics][[1]],
			Quantity[0.00009720191673569794`, ("Milliliters" "Moles")/("Grams")^2],
			EquivalenceFunction->RoundMatchQ[8],
			Messages :> {Warning::CurvesOutsideRangeRemoved}
		],

		(* RefractiveIndexConcentrationDerivative *)
		Example[{Options, RefractiveIndexConcentrationDerivative, "Specify the RefractiveIndexConcentrationDerivative used in the calculation of the optical constant. The optical constant is ued in the calculation of the second virial coefficient:"},
			AnalyzeDynamicLightScattering[
				Object[Data,DynamicLightScattering,"id:E8zoYvNpPJ9b"],
				RefractiveIndexConcentrationDerivative -> 0.2 * Centimeter^3/Gram
			][SecondVirialCoefficientStatistics][[1]],
			Quantity[0.000044779426077403095`, ("Milliliters" "Moles")/("Grams")^2],
			EquivalenceFunction->RoundMatchQ[8],
			Messages :> {Warning::CurvesOutsideRangeRemoved}
		],

		(* CalibrationStandardIntensity *)
		Example[{Options, CalibrationStandardIntensity, "Specify the CalibrationStandardIntensity of toluene from the experimental set up used to calculate the second virial coefficient:"},
			AnalyzeDynamicLightScattering[
				Object[Data,DynamicLightScattering,"id:E8zoYvNpPJ9b"],
				CalibrationStandardIntensity -> 100000
			][SecondVirialCoefficientStatistics][[1]],
			Quantity[0.000013401073434989297`, ("Milliliters" "Moles")/("Grams")^2],
			EquivalenceFunction->RoundMatchQ[8],
			Messages :> {Warning::CurvesOutsideRangeRemoved}
		],

		(* Output *)
		Example[{Options, Output, "Set Output to Options to return the function options:"},
			AnalyzeDynamicLightScattering[
				Object[Data,DynamicLightScattering,"id:E8zoYvNpPJ9b"],
				Output -> Options
			],
			_List,
			Messages :> {Warning::CurvesOutsideRangeRemoved}
		],


		(* Upload *)
		Example[{Options, Upload, "Set Upload to False to return a packet:"},
			AnalyzeDynamicLightScattering[
				Object[Data,DynamicLightScattering,"id:E8zoYvNpPJ9b"],
				Upload->False
			],
			_Association,
			Messages :> {Warning::CurvesOutsideRangeRemoved}
		],


		(* ---- Messages ---- *)

		(* OverSpecifiedOpticalConstant *)
		Example[{Messages, "OverSpecifiedOpticalConstant", "The OpticalConstant and RefractiveIndexConcentrationDerivative cannot both be specified:"},
			AnalyzeDynamicLightScattering[
				Object[Data,DynamicLightScattering,"id:E8zoYvNpPJ9b"],
				OpticalConstant-> 2.0*10^-7 Centimeter^2*Mole/Gram^2,
				RefractiveIndexConcentrationDerivative -> 0.2 * Centimeter^3/Gram
			],
			$Failed,
			Messages :> {Error::OverSpecifiedOpticalConstant}
		],

		(* NonSpecificationOption *)
		Example[{Messages, "NonSpecificationOption", "If the CorrelationMinimumValue exceeds 0.05, a warning is thrown about being outside of ISO documentation protocol:"},
			AnalyzeDynamicLightScattering[
				Object[Data,DynamicLightScattering,"id:E8zoYvNpPJ9b"],
				Method->Cumulants,
				CorrelationMinimumValue -> 0.1,
				CorrelationMinimumMethod -> Relative
			][ZAverageDiameters],
			{Quantity[20.126279496962844`, "Nanometers"],  Quantity[12.571252758907512`, "Nanometers"], Quantity[2777.051691486452`, "Nanometers"],
 			Quantity[14.077948198834537`, "Nanometers"], Quantity[14.36298646397109`, "Nanometers"]},
			EquivalenceFunction->RoundMatchQ[8],
			Messages :> {Warning::NonSpecificationOption, Warning::CurvesOutsideRangeRemoved}
		],

		(* BadInstrumentData *)
		Example[{Messages, "BadInstrumentData", "Non-numeric data from the instrument was detected:"},
			AnalyzeDynamicLightScattering[
				Object[Data,DynamicLightScattering,"id:WNa4ZjKE04Lz"]
			],
			ObjectP[Object[Analysis, DynamicLightScattering]],
			Messages :> {Warning::BadInstrumentData, Warning::CurvesOutsideRangeRemoved}
		],

		(* UnsupportedProtocol *)
		Example[{Messages, "UnsupportedProtocol", "Only MeltingCurve data from the ThermalShift protocol can be used in AnalyzeDynamicLightScattering:"},
			AnalyzeDynamicLightScattering[
				Object[Data, MeltingCurve, "id:Y0lXejlzYjrV"]
			],
			$Failed,
			Messages :> {Error::UnsupportedProtocol}
		],

		(* CurvesOutsideRange *)
		Example[{Messages, "CurvesOutsideRange", "For MeltingCurve data, a warning is issued if the correlation curves are outside of specification:"},
			AnalyzeDynamicLightScattering[
				Object[Data, MeltingCurve, "id:J8AY5jAqmrRx"]
			],
			ObjectP[Object[Analysis, DynamicLightScattering]],
			Messages :> {Warning::CurvesOutsideRange}
		],

		(* CurvesOutsideRangeRemoved *)
		Example[{Messages, "CurvesOutsideRangeRemoved", "A warning of removed data is issued if the correlation curves are outside of the initial correlation minimum and maximum:"},
			AnalyzeDynamicLightScattering[
				Object[Data,DynamicLightScattering,"id:WNa4ZjKE04Lz"]
			],
			ObjectP[Object[Analysis, DynamicLightScattering]],
			Messages :> {Warning::CurvesOutsideRangeRemoved, Warning::BadInstrumentData}
		],

		(* MinExceedsMax *)
		Example[{Messages, "MinExceedsMax", "An error is thrown if the minimum correlation threshold exceeds the maximum value:"},
			AnalyzeDynamicLightScattering[
				Object[Data,DynamicLightScattering,"id:WNa4ZjKE04Lz"],
				InitialCorrelationMinimumThreshold -> 1.1,
				InitialCorrelationMaximumThreshold -> 1.05
			],
			$Failed,
			Messages :> {Error::MinExceedsMax}
		],

		(* UseCumulantsMethod *)
		Example[{Messages, "UseCumulantsMethod", "An error is thrown if the instrument is DLSPlateReader and the method is Instrument:"},
			AnalyzeDynamicLightScattering[sizingPolydispersityOnDynaProPacket, Upload->False, Method->Instrument],
			$Failed,
			Messages :> {Error::UseCumulantsMethod}
		],

		(* UnknownSolventViscosity*)
		Example[{Messages, "UseCumulantsMethod", "A warning is shown if the solvent is not water or toluene:"},
			AnalyzeDynamicLightScattering[sizingPolydispersityOnDynaProPacket, Upload->False][AverageViscosity],
			Quantity[0.837149`, "Centipoise"],
			EquivalenceFunction->RoundMatchQ[3],
			Messages :> {Warning::UnknownSolventViscosity},
			Stubs:>{
				Analysis`Private`viscosityCalculation[solvent_, temp_]:=Module[{},
					Message[Warning::UnknownSolventViscosity, "some solvent"];
					0.8371
				]
			}
		],

		(* ---- Test ---- *)
		(* Use mock packet for unit test on DLSPlateReader*)

		Test["mock packet: assay type SizingPolydispersity from Uncle",
			AnalyzeDynamicLightScattering[sizingPolydispersityOnUnclePacket, Upload->False],
			ObjectP[Object[Analysis, DynamicLightScattering]]
		],

		Test["mock packet: assay type IsothermalStability from Uncle",
			AnalyzeDynamicLightScattering[isothermoStabilityOnUnclePacket, Upload->False],
			ObjectP[Object[Analysis, DynamicLightScattering]]
		],

		Test["mock packet: assay type ColloidalStability from Uncle",
			AnalyzeDynamicLightScattering[colloidalStabilityOnUnclePacket, Upload->False],
			ObjectP[Object[Analysis, DynamicLightScattering]]
		],

		Test["mock packet: assay type SizingPolydispersity from Dynapro",
			AnalyzeDynamicLightScattering[sizingPolydispersityOnDynaProPacket, Upload->False],
			ObjectP[Object[Analysis, DynamicLightScattering]]
		],

		Test["mock packet: assay type IsothermalStability from Dynapro",
			AnalyzeDynamicLightScattering[isothermoStabilityOnDynaProPacket, Upload->False],
			ObjectP[Object[Analysis, DynamicLightScattering]]
		],

		Test["mock packet: assay type ColloidalStability from Dynapro",
			AnalyzeDynamicLightScattering[colloidalStabilityOnDynaProPacket, Upload->False],
			ObjectP[Object[Analysis, DynamicLightScattering]]
		]
	},

	Variables :> {
		sizingPolydispersityOnUnclePacket,
		isothermoStabilityOnUnclePacket,
		colloidalStabilityOnUnclePacket,
		sizingPolydispersityOnDynaProPacket,
		isothermoStabilityOnDynaProPacket,
		colloidalStabilityOnDynaProPacket
	},
	SymbolSetUp:>{

		$CreatedObjects={};

		Module[{
			dynaproInstrument, uncleInstrument, sizingCorrelationCurve, sizingRawDataFiles, sizingQualification,
			sizingMolecularWeight, sizingProtocol, sizingProtocolData, isoRawDataFiles, isoQuantification, isoProtocol,
			isoProtocolData, isoZAverageDiameters, colloidCorrelationCurves, colloidRawDataFiles, colloidProtocol,
			colloidProtocolData, colloidZaverageDiameters, isoCorrelationCurvesData, isoDiffusionCoefficient,
			colloidalDiffusionCoefficient, colloidalPolydispersityIndices,colloidalApparentMW, myDLSDataObject,
			myDLSProtocolObject, myTestProtocolDLS, myTestDataDLS, testObjList, existsFilter
		},

		(*create variables that was used to generate packet*)
		dynaproInstrument = Link[Object[Instrument, DLSPlateReader, "id:M8n3rxnpZE38"], "9RdZXvRMeJ1l"];

		(*define variables that are used to generate packet*)
		uncleInstrument = Link[Object[Instrument, MultimodeSpectrophotometer, "id:P5ZnEjd9bjM4"], "9RdZXvRMeJ1l"];

		sizingCorrelationCurve = QuantityArray[StructuredArray`StructuredData[{168, 2}, {{{0.479999982871959, 0.960232377052307}, {0.959999965743918, 0.944636702537537}, {1.4400000054592998, 0.93296891450882}, {1.9199999314878398, 0.921108067035675}, {2.3999998575163803, 0.911336660385132}, {2.88000001091859, 0.899402916431427}, {3.35999993694713, 0.889045596122742}, {3.83999986297567, 0.881926238536835}, {4.31999978900421, 0.866143465042114}, {4.79999971503275, 0.858120083808899}, {5.2799996410612895, 0.851563692092896}, {5.7600000218371905, 0.842952489852905}, {6.23999994786573, 0.829468488693237}, {6.71999987389427, 0.821380496025085}, {7.19999979992281, 0.808730840682983}, {7.679999725951349, 0.799214601516724}, {8.63999957800843, 0.783719599246979}, {9.59999943006551, 0.764287710189819}, {10.5599992821226, 0.747681677341461}, {11.519999134179699, 0.730618953704834}, {12.4799989862368, 0.713009297847748}, {13.4399988382938, 0.697763323783875}, {14.3999986903509, 0.681705355644226}, {15.359999451902699, 0.664852499961853}, {17.2799991560169, 0.635624527931213}, {19.199998860131, 0.607757568359375}, {21.1199985642452, 0.581204175949097}, {23.0399982683593, 0.556010365486145}, {24.9599979724735, 0.530282974243164}, {26.8799976765877, 0.505466520786285}, {28.7999973807018, 0.485355943441391}, {30.719998903805397, 0.464081227779388}, {34.5599983120337, 0.425098419189453}, {38.399997720262, 0.389180660247803}, {42.2399971284904, 0.354055553674698}, {46.0799965367187, 0.324621140956879}, {49.919995944947, 0.297513663768768}, {53.7599953531753, 0.272294282913208}, {57.5999947614037, 0.249013841152191}, {61.439997807610794, 0.227552443742752}, {69.1199966240674, 0.191439658403397}, {76.7999954405241, 0.16037192940712}, {84.4799942569807, 0.134852737188339}, {92.1599930734374, 0.113979905843735}, {99.839991889894, 0.0961365401744843}, {107.51999070635101, 0.0819314420223236}, {115.199989522807, 0.0684182345867157}, {122.879995615222, 0.0577201545238495}, {138.239993248135, 0.0417507588863373}, {153.599990881048, 0.029977411031723}, {168.959988513961, 0.0216262936592102}, {184.319986146875, 0.0159597098827362}, {199.679983779788, 0.011819452047348}, {215.03998141270102, 0.00869303941726685}, {230.399979045615, 0.00686362385749817}, {245.759991230443, 0.00499343872070313}, {276.47998649627, 0.00215442478656769}, {307.199981762096, 0.001079261302948}, {337.919977027923, 0.00158745050430298}, {368.639972293749, 0.0020013153553009}, {399.359967559576, 0.000984981656074524}, {430.079962825403, 0.00083594024181366}, {460.799958091229, 0.000123411417007446}, {491.519982460886, 0.000692233443260193}, {552.959972992539, 0.00121363997459412}, {614.399963524193, 0.00115865468978882}, {675.839954055846, 0.000464126467704773}, {737.279944587499, -0.000195890665054321}, {798.719935119152, -0.000257566571235657}, {860.159925650805, -0.00255636870861053}, {921.599916182458, -0.000549331307411194}, {983.039964921772, 0.000394567847251892}, {1105.91994598508, 0.00179180502891541}, {1228.79992704839, 0.00116576254367828}, {1351.6799081116899, 0.00250586867332458}, {1474.559889175, -0.000385493040084839}, {1597.4398702383, 0.000767976045608521}, {1720.31985130161, -0.000514298677444458}, {1843.19983236492, -0.000617250800132751}, {1966.0799298435402, 0.00021679699420929}, {2211.83989197016, -0.000725433230400085}, {2457.59985409677, -0.00136207044124603}, {2703.3598162233798, -0.00079132616519928}, {2949.11977835, -0.000753998756408691}, {3194.87974047661, -0.000408962368965149}, {3440.63970260322, -0.000998646020889282}, {3686.39966472983, -0.000521257519721985}, {3932.15985968709, -0.000184044241905212}, {4423.67978394032, 0.00107008218765259}, {4915.19970819354, -0.0000317543745040894}, {5406.71963244677, -0.000483974814414978}, {5898.23955669999, 0.000635847449302673}, {6389.75948095322, 0.00108203291893005}, {6881.27940520644, -0.000624373555183411}, {7372.79932945967, -0.000679537653923035}, {7864.31971937418, -0.000509455800056458}, {8847.35956788063, -0.000169843435287476}, {9830.39941638708, -0.0000609606504440308}, {10813.4392648935, -0.000124320387840271}, {11796.4791134, -0.00121381878852844}, {12779.5189619064, -0.000606387853622437}, {13762.5588104129, -0.0000756382942199707}, {14745.5986589193, -0.000241264700889587}, {15728.639438748402, 0.000648051500320435}, {17694.719135761297, -0.000627726316452026}, {19660.7988327742, -0.00010313093662262}, {21626.8785297871, -0.00068056583404541}, {23592.9582268, 0.000953972339630127}, {25559.037923812903, 0.000815123319625854}, {27525.1176208258, 0.000126883387565613}, {29491.1973178387, 0.000585064291954041}, {31457.278877496698, -0.00113582611083984}, {35389.4382715225, 0.000328749418258667}, {39321.597665548295, -0.000483021140098572}, {43253.7570595741, 0.000245660543441772}, {47185.9164535999, -0.000301957130432129}, {51118.075847625696, 0.0000176429748535156}, {55050.2352416515, 0.000312328338623047}, {58982.3946356773, 0.000494524836540222}, {62914.557754993395, -0.0000734031200408936}, {70778.876543045, 0.0000997483730316162}, {78643.19533109659, 0.0000248551368713379}, {86507.5141191483, 0.000452101230621338}, {94371.8329071999, -0.000277772545814514}, {102236.15169525101, 0.0000196695327758789}, {110100.470483303, 0.0000600069761276245}, {117964.789271355, 0.000314608216285706}, {125829.115509987, -0.0000756829977035522}, {141557.75308609, 0.0000252872705459595}, {157286.390662193, 0.000185444951057434}, {173015.028238297, 0.000276058912277222}, {188743.6658144, 0.0000268369913101196}, {204472.30339050302, 0.0000648051500320435}, {220200.940966606, 0.0000249743461608887}, {235929.578542709, 0.0000849068164825439}, {251658.231019974, -0.000101730227470398}, {283115.50617218, 0.000023379921913147}, {314572.781324387, -7.88271427154541*^-6}, {346030.056476593, 4.58955764770508*^-6}, {377487.331628799, -0.000104576349258423}, {408944.60678100603, -0.0000163465738296509}, {440401.881933212, -0.0000303834676742554}, {471859.157085419, -0.0000160932540893555}, {503316.462039948, 0.0000186413526535034}, {566231.01234436, -5.99026679992676*^-6}, {629145.562648773, -0.000205665826797485}, {692060.112953186, -8.82148742675781*^-6}, {754974.663257599, 0.0000304877758026123}, {817889.2135620121, -9.5069408416748*^-6}, {880803.763866425, 0.0000176280736923218}, {943718.3141708369, -6.95884227752686*^-6}, {1.0066329240798999*^6, 2.81631946563721*^-6}, {1.13246202468872*^6, -0.0000945627689361572}, {1.2582911252975499*^6, -0.000094190239906311}, {1.38412022590637*^6, 0.000010564923286438}, {1.5099493265152*^6, 0.000024646520614624}, {1.6357784271240202*^6, 0.0000481605529785156}, {1.76160752773285*^6, -0.0000296980142593384}, {1.88743662834167*^6, -0.0000806301832199097}, {2.01326584815979*^6, -0.000101819634437561}, {2.26492404937744*^6, 0.0000207275152206421}, {2.51658225059509*^6, 9.98377799987793*^-7}, {2.76824045181274*^6, 3.41236591339111*^-6}, {3.0198986530304*^6, -1.9073486328125*^-6}, {3.27155685424805*^6, -0.00011618435382843}, {3.5232150554657*^6, 0.0000375509262084961}, {3.77487325668335*^6, 0.000176012516021729}, {4.02653169631958*^6, 0.000046461820602417}}, {"Microseconds", IndependentUnit["ArbitraryUnits"]}, {{1}, {2}}}]];

		sizingRawDataFiles = {Lookup[ Association[ FileName -> "_y0l_xej_ma_no_z_e.uni-2020-09-25T08-21-42", FileType -> "xlsx", CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard5/fd0becd89ef8f1cc9ae39cae1c3d7fe3.xlsx", "aXRlGnRxExz9CE6XZVBendNbIBmw5RKvA0P9"], Object -> Object[EmeraldCloudFile, "id:M8n3rxnlNljG"], ID -> "id:M8n3rxnlNljG", Type -> Object[EmeraldCloudFile]], Object], Lookup[Association[FileName -> "_y0l_xej_ma_no_z_e.uni-2020-09-25T08-21-54", FileType -> "xlsx", CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard1/b9a0bfa6979331dc63b1052d04fcd7fa.xlsx", "KBL5DvLZjZbGf8NPGjwLZoxEsmz1oNaqKWdZ"], Object -> Object[EmeraldCloudFile, "id:WNa4ZjavXvpq"], ID -> "id:WNa4ZjavXvpq", Type -> Object[EmeraldCloudFile]], Object], Lookup[Association[FileName -> "_y0l_xej_ma_no_z_e.uni-2020-09-25T08-22-02", FileType -> "xlsx", CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard15/ffa8453964851230fdd919bbe89bd12c.xlsx", "BYDOjvDN3NkKiwNel3kbmZ9pc4npOJX917NY"], Object -> Object[EmeraldCloudFile, "id:54n6evnEqEVP"], ID -> "id:54n6evnEqEVP", Type -> Object[EmeraldCloudFile]], Object], Lookup[Association[FileName -> "_y0l_xej_ma_no_z_e.uni-2020-09-25T08-22-10", FileType -> "xlsx", CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard3/59dc544dced6cc7a72c95a5cfe773026.xlsx", "R8e1Pjekdk0rIjnN5OZKxaEoFoKkPqa5LpRe"], Object -> Object[EmeraldCloudFile, "id:n0k9mGkAjAr1"], ID -> "id:n0k9mGkAjAr1", Type -> Object[EmeraldCloudFile]], Object]};

		sizingQualification = {{DateObject[{2023, 3, 2, 7, 15, 26.4091584}, "Instant", "Gregorian", -8.], {}, {}}};

		sizingMolecularWeight = QuantityArray[StructuredArray`StructuredData[{168, 2}, {{{0.479999982871959, 0.960232377052307}, {0.959999965743918, 0.944636702537537}, {1.4400000054592998, 0.93296891450882}, {1.9199999314878398, 0.921108067035675}, {2.3999998575163803, 0.911336660385132}, {2.88000001091859, 0.899402916431427}, {3.35999993694713, 0.889045596122742}, {3.83999986297567, 0.881926238536835}, {4.31999978900421, 0.866143465042114}, {4.79999971503275, 0.858120083808899}, {5.2799996410612895, 0.851563692092896}, {5.7600000218371905, 0.842952489852905}, {6.23999994786573, 0.829468488693237}, {6.71999987389427, 0.821380496025085}, {7.19999979992281, 0.808730840682983}, {7.679999725951349, 0.799214601516724}, {8.63999957800843, 0.783719599246979}, {9.59999943006551, 0.764287710189819}, {10.5599992821226, 0.747681677341461}, {11.519999134179699, 0.730618953704834}, {12.4799989862368, 0.713009297847748}, {13.4399988382938, 0.697763323783875}, {14.3999986903509, 0.681705355644226}, {15.359999451902699, 0.664852499961853}, {17.2799991560169, 0.635624527931213}, {19.199998860131, 0.607757568359375}, {21.1199985642452, 0.581204175949097}, {23.0399982683593, 0.556010365486145}, {24.9599979724735, 0.530282974243164}, {26.8799976765877, 0.505466520786285}, {28.7999973807018, 0.485355943441391}, {30.719998903805397, 0.464081227779388}, {34.5599983120337, 0.425098419189453}, {38.399997720262, 0.389180660247803}, {42.2399971284904, 0.354055553674698}, {46.0799965367187, 0.324621140956879}, {49.919995944947, 0.297513663768768}, {53.7599953531753, 0.272294282913208}, {57.5999947614037, 0.249013841152191}, {61.439997807610794, 0.227552443742752}, {69.1199966240674, 0.191439658403397}, {76.7999954405241, 0.16037192940712}, {84.4799942569807, 0.134852737188339}, {92.1599930734374, 0.113979905843735}, {99.839991889894, 0.0961365401744843}, {107.51999070635101, 0.0819314420223236}, {115.199989522807, 0.0684182345867157}, {122.879995615222, 0.0577201545238495}, {138.239993248135, 0.0417507588863373}, {153.599990881048, 0.029977411031723}, {168.959988513961, 0.0216262936592102}, {184.319986146875, 0.0159597098827362}, {199.679983779788, 0.011819452047348}, {215.03998141270102, 0.00869303941726685}, {230.399979045615, 0.00686362385749817}, {245.759991230443, 0.00499343872070313}, {276.47998649627, 0.00215442478656769}, {307.199981762096, 0.001079261302948}, {337.919977027923, 0.00158745050430298}, {368.639972293749, 0.0020013153553009}, {399.359967559576, 0.000984981656074524}, {430.079962825403, 0.00083594024181366}, {460.799958091229, 0.000123411417007446}, {491.519982460886, 0.000692233443260193}, {552.959972992539, 0.00121363997459412}, {614.399963524193, 0.00115865468978882}, {675.839954055846, 0.000464126467704773}, {737.279944587499, -0.000195890665054321}, {798.719935119152, -0.000257566571235657}, {860.159925650805, -0.00255636870861053}, {921.599916182458, -0.000549331307411194}, {983.039964921772, 0.000394567847251892}, {1105.91994598508, 0.00179180502891541}, {1228.79992704839, 0.00116576254367828}, {1351.6799081116899, 0.00250586867332458}, {1474.559889175, -0.000385493040084839}, {1597.4398702383, 0.000767976045608521}, {1720.31985130161, -0.000514298677444458}, {1843.19983236492, -0.000617250800132751}, {1966.0799298435402, 0.00021679699420929}, {2211.83989197016, -0.000725433230400085}, {2457.59985409677, -0.00136207044124603}, {2703.3598162233798, -0.00079132616519928}, {2949.11977835, -0.000753998756408691}, {3194.87974047661, -0.000408962368965149}, {3440.63970260322, -0.000998646020889282}, {3686.39966472983, -0.000521257519721985}, {3932.15985968709, -0.000184044241905212}, {4423.67978394032, 0.00107008218765259}, {4915.19970819354, -0.0000317543745040894}, {5406.71963244677, -0.000483974814414978}, {5898.23955669999, 0.000635847449302673}, {6389.75948095322, 0.00108203291893005}, {6881.27940520644, -0.000624373555183411}, {7372.79932945967, -0.000679537653923035}, {7864.31971937418, -0.000509455800056458}, {8847.35956788063, -0.000169843435287476}, {9830.39941638708, -0.0000609606504440308}, {10813.4392648935, -0.000124320387840271}, {11796.4791134, -0.00121381878852844}, {12779.5189619064, -0.000606387853622437}, {13762.5588104129, -0.0000756382942199707}, {14745.5986589193, -0.000241264700889587}, {15728.639438748402, 0.000648051500320435}, {17694.719135761297, -0.000627726316452026}, {19660.7988327742, -0.00010313093662262}, {21626.8785297871, -0.00068056583404541}, {23592.9582268, 0.000953972339630127}, {25559.037923812903, 0.000815123319625854}, {27525.1176208258, 0.000126883387565613}, {29491.1973178387, 0.000585064291954041}, {31457.278877496698, -0.00113582611083984}, {35389.4382715225, 0.000328749418258667}, {39321.597665548295, -0.000483021140098572}, {43253.7570595741, 0.000245660543441772}, {47185.9164535999, -0.000301957130432129}, {51118.075847625696, 0.0000176429748535156}, {55050.2352416515, 0.000312328338623047}, {58982.3946356773, 0.000494524836540222}, {62914.557754993395, -0.0000734031200408936}, {70778.876543045, 0.0000997483730316162}, {78643.19533109659, 0.0000248551368713379}, {86507.5141191483, 0.000452101230621338}, {94371.8329071999, -0.000277772545814514}, {102236.15169525101, 0.0000196695327758789}, {110100.470483303, 0.0000600069761276245}, {117964.789271355, 0.000314608216285706}, {125829.115509987, -0.0000756829977035522}, {141557.75308609, 0.0000252872705459595}, {157286.390662193, 0.000185444951057434}, {173015.028238297, 0.000276058912277222}, {188743.6658144, 0.0000268369913101196}, {204472.30339050302, 0.0000648051500320435}, {220200.940966606, 0.0000249743461608887}, {235929.578542709, 0.0000849068164825439}, {251658.231019974, -0.000101730227470398}, {283115.50617218, 0.000023379921913147}, {314572.781324387, -7.88271427154541*^-6}, {346030.056476593, 4.58955764770508*^-6}, {377487.331628799, -0.000104576349258423}, {408944.60678100603, -0.0000163465738296509}, {440401.881933212, -0.0000303834676742554}, {471859.157085419, -0.0000160932540893555}, {503316.462039948, 0.0000186413526535034}, {566231.01234436, -5.99026679992676*^-6}, {629145.562648773, -0.000205665826797485}, {692060.112953186, -8.82148742675781*^-6}, {754974.663257599, 0.0000304877758026123}, {817889.2135620121, -9.5069408416748*^-6}, {880803.763866425, 0.0000176280736923218}, {943718.3141708369, -6.95884227752686*^-6}, {1.0066329240798999*^6, 2.81631946563721*^-6}, {1.13246202468872*^6, -0.0000945627689361572}, {1.2582911252975499*^6, -0.000094190239906311}, {1.38412022590637*^6, 0.000010564923286438}, {1.5099493265152*^6, 0.000024646520614624}, {1.6357784271240202*^6, 0.0000481605529785156}, {1.76160752773285*^6, -0.0000296980142593384}, {1.88743662834167*^6, -0.0000806301832199097}, {2.01326584815979*^6, -0.000101819634437561}, {2.26492404937744*^6, 0.0000207275152206421}, {2.51658225059509*^6, 9.98377799987793*^-7}, {2.76824045181274*^6, 3.41236591339111*^-6}, {3.0198986530304*^6, -1.9073486328125*^-6}, {3.27155685424805*^6, -0.00011618435382843}, {3.5232150554657*^6, 0.0000375509262084961}, {3.77487325668335*^6, 0.000176012516021729}, {4.02653169631958*^6, 0.000046461820602417}}, {"Microseconds", IndependentUnit["ArbitraryUnits"]}, {{1}, {2}}}]];

		sizingProtocol = Link[Object[Protocol, DynamicLightScattering, "id:Y0lXejMaNoZE"], Data, "xRO9n3R81ABx"];

		sizingProtocolData = {Link[Object[Data, DynamicLightScattering, "id:dORYzZJqxq4R"], Protocol, "zGj91aG8dzRe"], Link[Object[Data, DynamicLightScattering, "id:eGakldJRERVe"], Protocol, "lYq9jRYN31zp"], Link[Object[Data, DynamicLightScattering, "id:pZx9jo81L1E0"], Protocol, "L8kPEj8JDVNV"]};

		isoRawDataFiles = {Lookup[ Association[ FileName -> "qdkmxzq_za8_y_v - Copy.uni-2020-09-23T11-28-40", FileType -> "xlsx", CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard12/64bd6f023a00ca6f16a3d3d4d845f594.xlsx", "L8kPEjkdJXp1IqRVbpk6Lkzkc3mKJx0GP3ab"], Object -> Object[EmeraldCloudFile, "id:n0k9mGkANo6w"], ID -> "id:n0k9mGkANo6w", Type -> Object[EmeraldCloudFile]], Object], Lookup[Association[FileName -> "qdkmxzq_za8_y_v - Copy.uni-2020-09-23T11-28-50", FileType -> "xlsx", CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard4/fa904f01c7da589adfadd99af282279d.xlsx", "bq9LA09xNZ8Ec4z6qjr9BrbJt0ALxd6Na0NP"], Object -> Object[EmeraldCloudFile, "id:01G6nvG7Bb5A"], ID -> "id:01G6nvG7Bb5A", Type -> Object[EmeraldCloudFile]], Object], Lookup[Association[FileName -> "qdkmxzq_za8_y_v - Copy.uni-2022-10-20T15-32-04", FileType -> "xlsx", CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard14/333375991a238575cd8a34bd441529d5.xlsx", "BYDOjvDNBm8jHwNel3k8VkrNf4npOJXZ84Zm"], Object -> Object[EmeraldCloudFile, "id:1ZA60vArB7R0"], ID -> "id:1ZA60vArB7R0", Type -> Object[EmeraldCloudFile]], Object], Lookup[Association[ FileName -> "qdkmxzq_za8_y_v.uni-2020-09-23T11-23-35", FileType -> "xlsx", CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard5/8cf3c1fb273580490e845696f3155253.xlsx", "1ZA60vArB7R3tAJzvp3E93G1i80dzqMR38R9"], Object -> Object[EmeraldCloudFile, "id:Z1lqpMl6W3Y9"], ID -> "id:Z1lqpMl6W3Y9", Type -> Object[EmeraldCloudFile]], Object]};

		isoQuantification = {{DateObject[{2023, 3, 2, 7, 15, 26.4091584}, "Instant", "Gregorian", -8.], {}, {}}};

		isoProtocol = Link[Object[Protocol, DynamicLightScattering, "id:qdkmxzqZa8YV"], Data, "rea9jleeqozr"];

		isoProtocolData = {Link[ Object[Data, DynamicLightScattering, "id:8qZ1VW0p9Ezn"], Protocol, "WNa4ZjNNwrvq"], Link[Object[Data, DynamicLightScattering, "id:rea9jlRdKvZ3"], Protocol, "54n6ev44kxEP"]};

		isoZAverageDiameters = {{Quantity[0., "Seconds"], Quantity[13.83, "Nanometers"]}, {Quantity[594., "Seconds"], Quantity[13.42, "Nanometers"]}, {Quantity[1188., "Seconds"], Quantity[13.46, "Nanometers"]}, {Quantity[1782., "Seconds"], Quantity[13.42, "Nanometers"]}, {Quantity[2376., "Seconds"], Quantity[13.45, "Nanometers"]}};

		colloidCorrelationCurves = {{Quantity[40, "Milligrams"/"Milliliters"], QuantityArray[ StructuredArray`StructuredData[{168, 2}, {{{0.479999982871959, 0.963100910186768}, {0.959999965743918, 0.951836705207825}, {1.4400000054592998, 0.942638516426086}, {1.9199999314878398, 0.936285555362701}, {2.3999998575163803, 0.931471467018127}, {2.88000001091859, 0.920330345630646}, {3.35999993694713, 0.912995755672455}, {3.83999986297567, 0.905288457870483}, {4.31999978900421, 0.898420095443726}, {4.79999971503275, 0.893474936485291}, {5.2799996410612895, 0.885867059230804}, {5.7600000218371905, 0.88141405582428}, {6.23999994786573, 0.874028563499451}, {6.71999987389427, 0.864694237709045}, {7.19999979992281, 0.864110827445984}, {7.679999725951349, 0.853988766670227}, {8.63999957800843, 0.841945290565491}, {9.59999943006551, 0.829830586910248}, {10.5599992821226, 0.817085742950439}, {11.519999134179699, 0.804142117500305}, {12.4799989862368, 0.795350909233093}, {13.4399988382938, 0.780210852622986}, {14.3999986903509, 0.770900309085846}, {15.359999451902699, 0.759790182113647}, {17.2799991560169, 0.736562490463257}, {19.199998860131, 0.716739773750305}, {21.1199985642452, 0.696211934089661}, {23.0399982683593, 0.675446510314941}, {24.9599979724735, 0.656844973564148}, {26.8799976765877, 0.636932909488678}, {28.7999973807018, 0.619855880737305}, {30.719998903805397, 0.601773262023926}, {34.5599983120337, 0.567803859710693}, {38.399997720262, 0.536000072956085}, {42.2399971284904, 0.50601589679718}, {46.0799965367187, 0.477233231067657}, {49.919995944947, 0.452067881822586}, {53.7599953531753, 0.425931334495544}, {57.5999947614037, 0.403969287872314}, {61.439997807610794, 0.3809914290905}, {69.1199966240674, 0.341407150030136}, {76.7999954405241, 0.305964320898056}, {84.4799942569807, 0.273738414049149}, {92.1599930734374, 0.244567453861237}, {99.839991889894, 0.220338344573975}, {107.51999070635101, 0.197853714227676}, {115.199989522807, 0.178232789039612}, {122.879995615222, 0.159926682710648}, {138.239993248135, 0.130369663238525}, {153.599990881048, 0.106137812137604}, {168.959988513961, 0.08610799908638}, {184.319986146875, 0.0700816810131073}, {199.679983779788, 0.056920975446701}, {215.03998141270102, 0.046970397233963}, {230.399979045615, 0.0382155776023865}, {245.759991230443, 0.0315134525299072}, {276.47998649627, 0.0213657319545746}, {307.199981762096, 0.0141003131866455}, {337.919977027923, 0.00866052508354187}, {368.639972293749, 0.00613310933113098}, {399.359967559576, 0.00478638708591461}, {430.079962825403, 0.00324130058288574}, {460.799958091229, 0.00158493220806122}, {491.519982460886, 0.00049397349357605}, {552.959972992539, 0.00098070502281189}, {614.399963524193, 0.00128589570522308}, {675.839954055846, 0.000481411814689636}, {737.279944587499, -0.000813782215118408}, {798.719935119152, 0.000262439250946045}, {860.159925650805, 0.00147159397602081}, {921.599916182458, 0.000823706388473511}, {983.039964921772, 0.000771656632423401}, {1105.91994598508, 0.000749915838241577}, {1228.79992704839, -0.00261735916137695}, {1351.6799081116899, -0.00225904583930969}, {1474.559889175, -0.00159937143325806}, {1597.4398702383, -0.00164681673049927}, {1720.31985130161, 0.000188946723937988}, {1843.19983236492, 0.000664800405502319}, {1966.0799298435402, 0.00210897624492645}, {2211.83989197016, 0.00110365450382233}, {2457.59985409677, 0.000248104333877563}, {2703.3598162233798, 0.0000216811895370483}, {2949.11977835, -0.0000893771648406982}, {3194.87974047661, 0.000550806522369385}, {3440.63970260322, 0.00129440426826477}, {3686.39966472983, 0.000415459275245667}, {3932.15985968709, -0.00077897310256958}, {4423.67978394032, -0.00075097382068634}, {4915.19970819354, 0.000272303819656372}, {5406.71963244677, -7.9423189163208*^-6}, {5898.23955669999, 0.00205636024475098}, {6389.75948095322, -0.00152206420898438}, {6881.27940520644, 0.000944003462791443}, {7372.79932945967, 0.000738620758056641}, {7864.31971937418, -0.000629782676696777}, {8847.35956788063, 0.000454887747764587}, {9830.39941638708, 0.000338703393936157}, {10813.4392648935, 0.000431269407272339}, {11796.4791134, -0.0017264187335968}, {12779.5189619064, -0.000519394874572754}, {13762.5588104129, -0.000757902860641479}, {14745.5986589193, 0.000131860375404358}, {15728.639438748402, -0.00033271312713623}, {17694.719135761297, -0.00082281231880188}, {19660.7988327742, -0.000563398003578186}, {21626.8785297871, -0.000580936670303345}, {23592.9582268, 0.000253111124038696}, {25559.037923812903, -0.000924274325370789}, {27525.1176208258, 0.00055287778377533}, {29491.1973178387, -0.000759556889533997}, {31457.278877496698, -0.000192537903785706}, {35389.4382715225, 0.00060446560382843}, {39321.597665548295, 0.000800594687461853}, {43253.7570595741, 0.00113356113433838}, {47185.9164535999, 0.000261366367340088}, {51118.075847625696, -0.00018194317817688}, {55050.2352416515, -0.000411048531532288}, {58982.3946356773, -0.000204429030418396}, {62914.557754993395, -0.000137165188789368}, {70778.876543045, -0.000264212489128113}, {78643.19533109659, 0.000186264514923096}, {86507.5141191483, 0.000614672899246216}, {94371.8329071999, -0.000118792057037354}, {102236.15169525101, -0.000155985355377197}, {110100.470483303, -0.000123143196105957}, {117964.789271355, -0.000342085957527161}, {125829.115509987, -0.00022868812084198}, {141557.75308609, 0.0000773966312408447}, {157286.390662193, -0.000419124960899353}, {173015.028238297, -0.000531807541847229}, {188743.6658144, 0.000193387269973755}, {204472.30339050302, -0.0000757277011871338}, {220200.940966606, -0.000333771109580994}, {235929.578542709, 0.000218182802200317}, {251658.231019974, -0.000228941440582275}, {283115.50617218, -0.0000200718641281128}, {314572.781324387, -0.000093117356300354}, {346030.056476593, 0.0000900179147720337}, {377487.331628799, -0.000505581498146057}, {408944.60678100603, 0.000259920954704285}, {440401.881933212, -0.00014960765838623}, {471859.157085419, -0.000274837017059326}, {503316.462039948, 0.000454679131507874}, {566231.01234436, 0.00030931830406189}, {629145.562648773, -2.17556953430176*^-6}, {692060.112953186, 0.0000345706939697266}, {754974.663257599, -0.000175803899765015}, {817889.2135620121, 0.000030219554901123}, {880803.763866425, -0.000159427523612976}, {943718.3141708369, 0.0000218600034713745}, {1.0066329240798999*^6, -0.0000597387552261353}, {1.13246202468872*^6, 0.0000872761011123657}, {1.2582911252975499*^6, 0.00012342631816864}, {1.38412022590637*^6, 0.0000781267881393433}, {1.5099493265152*^6, -0.000118017196655273}, {1.6357784271240202*^6, -0.0000940710306167603}, {1.76160752773285*^6, -0.000168696045875549}, {1.88743662834167*^6, -0.0000310838222503662}, {2.01326584815979*^6, -0.0000219047069549561}, {2.26492404937744*^6, -0.000051841139793396}, {2.51658225059509*^6, 0.0000547319650650024}, {2.76824045181274*^6, 0.0000567436218261719}, {3.0198986530304*^6, -0.0000628381967544556}, {3.27155685424805*^6, 0.0000297129154205322}, {3.5232150554657*^6, 0.0000619888305664063}, {3.77487325668335*^6, -7.22706317901611*^-6}, {4.02653169631958*^6, -0.0000208020210266113}}, {"Microseconds", IndependentUnit["ArbitraryUnits"]}, {{1}, {2}}}]]}, {Quantity[40, "Milligrams"/"Milliliters"], QuantityArray[ StructuredArray`StructuredData[{168, 2}, {{{0.479999982871959, 0.947371125221252}, {0.959999965743918, 0.939217031002045}, {1.4400000054592998, 0.928144931793213}, {1.9199999314878398, 0.92357325553894}, {2.3999998575163803, 0.914972245693207}, {2.88000001091859, 0.90663868188858}, {3.35999993694713, 0.901160955429077}, {3.83999986297567, 0.892441034317017}, {4.31999978900421, 0.886864364147186}, {4.79999971503275, 0.87989354133606}, {5.2799996410612895, 0.872908234596252}, {5.7600000218371905, 0.865312099456787}, {6.23999994786573, 0.861128509044647}, {6.71999987389427, 0.851901412010193}, {7.19999979992281, 0.848189890384674}, {7.679999725951349, 0.840288758277893}, {8.63999957800843, 0.827868938446045}, {9.59999943006551, 0.814969778060913}, {10.5599992821226, 0.802493989467621}, {11.519999134179699, 0.791665434837341}, {12.4799989862368, 0.780176162719727}, {13.4399988382938, 0.768361926078796}, {14.3999986903509, 0.756942987442017}, {15.359999451902699, 0.74600225687027}, {17.2799991560169, 0.723362803459167}, {19.199998860131, 0.70126336812973}, {21.1199985642452, 0.680156707763672}, {23.0399982683593, 0.662378907203674}, {24.9599979724735, 0.642264604568481}, {26.8799976765877, 0.623124599456787}, {28.7999973807018, 0.605774879455566}, {30.719998903805397, 0.588261842727661}, {34.5599983120337, 0.553319096565247}, {38.399997720262, 0.522172451019287}, {42.2399971284904, 0.491067051887512}, {46.0799965367187, 0.463811427354813}, {49.919995944947, 0.43809762597084}, {53.7599953531753, 0.412926286458969}, {57.5999947614037, 0.389580994844437}, {61.439997807610794, 0.367813229560852}, {69.1199966240674, 0.328588038682938}, {76.7999954405241, 0.293229460716248}, {84.4799942569807, 0.261333703994751}, {92.1599930734374, 0.234465181827545}, {99.839991889894, 0.210074931383133}, {107.51999070635101, 0.188259243965149}, {115.199989522807, 0.169294595718384}, {122.879995615222, 0.152066498994827}, {138.239993248135, 0.12267079949379}, {153.599990881048, 0.0989828705787659}, {168.959988513961, 0.0805419087409973}, {184.319986146875, 0.0656617879867554}, {199.679983779788, 0.0535310804843903}, {215.03998141270102, 0.0430970788002014}, {230.399979045615, 0.0346781313419342}, {245.759991230443, 0.0285727381706238}, {276.47998649627, 0.0186904072761536}, {307.199981762096, 0.0121974050998688}, {337.919977027923, 0.00821653008460999}, {368.639972293749, 0.00537621974945068}, {399.359967559576, 0.00371333956718445}, {430.079962825403, 0.00290666520595551}, {460.799958091229, 0.00167922675609589}, {491.519982460886, 0.00116676092147827}, {552.959972992539, 0.00116671621799469}, {614.399963524193, 0.00068683922290802}, {675.839954055846, -0.000134557485580444}, {737.279944587499, -0.000563696026802063}, {798.719935119152, 0.0000901222229003906}, {860.159925650805, 0.00276806950569153}, {921.599916182458, 0.00257891416549683}, {983.039964921772, 0.000965043902397156}, {1105.91994598508, 2.17556953430176*^-6}, {1228.79992704839, 0.0002555251121521}, {1351.6799081116899, 0.00104844570159912}, {1474.559889175, 0.00180116295814514}, {1597.4398702383, 0.00178749859333038}, {1720.31985130161, 0.00180597603321075}, {1843.19983236492, 0.000135287642478943}, {1966.0799298435402, -0.000260293483734131}, {2211.83989197016, 0.000488206744194031}, {2457.59985409677, -0.000331014394760132}, {2703.3598162233798, -0.00139841437339783}, {2949.11977835, -0.00259707868099213}, {3194.87974047661, -0.000336870551109314}, {3440.63970260322, 0.00026404857635498}, {3686.39966472983, 0.00120353698730469}, {3932.15985968709, 0.00143402814865112}, {4423.67978394032, -0.000505983829498291}, {4915.19970819354, -0.000457391142845154}, {5406.71963244677, 0.000712484121322632}, {5898.23955669999, 0.00145044922828674}, {6389.75948095322, -0.000227928161621094}, {6881.27940520644, 0.000186607241630554}, {7372.79932945967, -0.000239297747612}, {7864.31971937418, 0.000691503286361694}, {8847.35956788063, 0.000185251235961914}, {9830.39941638708, 0.00163577497005463}, {10813.4392648935, 0.00182703137397766}, {11796.4791134, -0.000819310545921326}, {12779.5189619064, -0.000372201204299927}, {13762.5588104129, -0.000261038541793823}, {14745.5986589193, -0.000793322920799255}, {15728.639438748402, 9.49203968048096*^-6}, {17694.719135761297, -0.0007762610912323}, {19660.7988327742, 0.0000816881656646729}, {21626.8785297871, -0.000171899795532227}, {23592.9582268, -0.000377103686332703}, {25559.037923812903, -0.000899538397789001}, {27525.1176208258, 0.000342577695846558}, {29491.1973178387, 0.00130093097686768}, {31457.278877496698, 0.000419080257415771}, {35389.4382715225, -0.000256374478340149}, {39321.597665548295, 0.0000720024108886719}, {43253.7570595741, -3.24845314025879*^-6}, {47185.9164535999, -0.000177904963493347}, {51118.075847625696, 0.000322058796882629}, {55050.2352416515, -0.00106650590896606}, {58982.3946356773, 0.000360548496246338}, {62914.557754993395, -0.000103026628494263}, {70778.876543045, -0.00026153028011322}, {78643.19533109659, -0.000303089618682861}, {86507.5141191483, -0.0000575035810470581}, {94371.8329071999, -0.0000455677509307861}, {102236.15169525101, -0.000495791435241699}, {110100.470483303, -0.00011579692363739}, {117964.789271355, -0.000270739197731018}, {125829.115509987, 0.000648349523544312}, {141557.75308609, 0.0000807195901870728}, {157286.390662193, -0.000116810202598572}, {173015.028238297, 0.00011153519153595}, {188743.6658144, 0.000115543603897095}, {204472.30339050302, -0.0000441968441009521}, {220200.940966606, -0.000134736299514771}, {235929.578542709, 0.000379100441932678}, {251658.231019974, -0.0000583678483963013}, {283115.50617218, 0.0000977516174316406}, {314572.781324387, -0.000167444348335266}, {346030.056476593, 0.00035540759563446}, {377487.331628799, -0.000106960535049438}, {408944.60678100603, -0.000180274248123169}, {440401.881933212, -0.000138208270072937}, {471859.157085419, -0.000149279832839966}, {503316.462039948, -0.0000686496496200562}, {566231.01234436, 0.000256717205047607}, {629145.562648773, -0.0000381767749786377}, {692060.112953186, 0.0000890493392944336}, {754974.663257599, 0.000124990940093994}, {817889.2135620121, -0.000165760517120361}, {880803.763866425, -0.000214919447898865}, {943718.3141708369, 0.0000917613506317139}, {1.0066329240798999*^6, -0.000222116708755493}, {1.13246202468872*^6, -0.000100985169410706}, {1.2582911252975499*^6, 0.00012795627117157}, {1.38412022590637*^6, -0.0000503510236740112}, {1.5099493265152*^6, -0.000219419598579407}, {1.6357784271240202*^6, 8.34465026855469*^-7}, {1.76160752773285*^6, -0.000151738524436951}, {1.88743662834167*^6, 0.00015750527381897}, {2.01326584815979*^6, 0.0000369548797607422}, {2.26492404937744*^6, -0.0000417083501815796}, {2.51658225059509*^6, -0.000100120902061462}, {2.76824045181274*^6, -0.0000152438879013062}, {3.0198986530304*^6, 0.0000558644533157349}, {3.27155685424805*^6, 0.000296503305435181}, {3.5232150554657*^6, 0.000105500221252441}, {3.77487325668335*^6, -0.0000648647546768188}, {4.02653169631958*^6, 0.00016351044178009}}, {"Microseconds", IndependentUnit["ArbitraryUnits"]}, {{1}, {2}}}]]}, {Quantity[40, "Milligrams"/"Milliliters"], QuantityArray[ StructuredArray`StructuredData[{168, 2}, {{{0.479999982871959, 0.958914756774902}, {0.959999965743918, 0.948470771312714}, {1.4400000054592998, 0.942159652709961}, {1.9199999314878398, 0.931657373905182}, {2.3999998575163803, 0.926395773887634}, {2.88000001091859, 0.917478084564209}, {3.35999993694713, 0.913235664367676}, {3.83999986297567, 0.906264424324036}, {4.31999978900421, 0.896962463855743}, {4.79999971503275, 0.891204595565796}, {5.2799996410612895, 0.881703615188599}, {5.7600000218371905, 0.87724632024765}, {6.23999994786573, 0.873311996459961}, {6.71999987389427, 0.86435455083847}, {7.19999979992281, 0.854415059089661}, {7.679999725951349, 0.85063362121582}, {8.63999957800843, 0.83830726146698}, {9.59999943006551, 0.825547158718109}, {10.5599992821226, 0.813019156455994}, {11.519999134179699, 0.799136638641357}, {12.4799989862368, 0.787067174911499}, {13.4399988382938, 0.774838268756866}, {14.3999986903509, 0.766200125217438}, {15.359999451902699, 0.753667652606964}, {17.2799991560169, 0.733052611351013}, {19.199998860131, 0.710151314735413}, {21.1199985642452, 0.689700841903687}, {23.0399982683593, 0.66963928937912}, {24.9599979724735, 0.650478780269623}, {26.8799976765877, 0.631016075611115}, {28.7999973807018, 0.612514495849609}, {30.719998903805397, 0.593886375427246}, {34.5599983120337, 0.560858368873596}, {38.399997720262, 0.528411448001862}, {42.2399971284904, 0.499213933944702}, {46.0799965367187, 0.47064545750618}, {49.919995944947, 0.443468034267426}, {53.7599953531753, 0.418410301208496}, {57.5999947614037, 0.395444363355637}, {61.439997807610794, 0.373508393764496}, {69.1199966240674, 0.333182960748672}, {76.7999954405241, 0.297505170106888}, {84.4799942569807, 0.265561401844025}, {92.1599930734374, 0.237623363733292}, {99.839991889894, 0.213710337877274}, {107.51999070635101, 0.191069960594177}, {115.199989522807, 0.170600235462189}, {122.879995615222, 0.152742326259613}, {138.239993248135, 0.122507482767105}, {153.599990881048, 0.0983765423297882}, {168.959988513961, 0.0788931548595428}, {184.319986146875, 0.0633503496646881}, {199.679983779788, 0.0503148138523102}, {215.03998141270102, 0.0404556393623352}, {230.399979045615, 0.0318098664283752}, {245.759991230443, 0.0258912146091461}, {276.47998649627, 0.0175683200359344}, {307.199981762096, 0.012095034122467}, {337.919977027923, 0.00823453068733215}, {368.639972293749, 0.00531259179115295}, {399.359967559576, 0.00207996368408203}, {430.079962825403, 0.00103165209293365}, {460.799958091229, 0.00207558274269104}, {491.519982460886, 0.00244572758674622}, {552.959972992539, 0.000879302620887756}, {614.399963524193, 0.00142081081867218}, {675.839954055846, 0.00194050371646881}, {737.279944587499, 0.0000495612621307373}, {798.719935119152, 0.00028209388256073}, {860.159925650805, 0.000911146402359009}, {921.599916182458, 0.00151129066944122}, {983.039964921772, 0.000441208481788635}, {1105.91994598508, 0.00141863524913788}, {1228.79992704839, 0.000270694494247437}, {1351.6799081116899, -0.0013560950756073}, {1474.559889175, -0.000784531235694885}, {1597.4398702383, -0.0000460892915725708}, {1720.31985130161, -0.000920027494430542}, {1843.19983236492, -0.000209793448448181}, {1966.0799298435402, -0.00412729382514954}, {2211.83989197016, -0.00233994424343109}, {2457.59985409677, 0.0027228444814682}, {2703.3598162233798, 0.00133351981639862}, {2949.11977835, -0.000141650438308716}, {3194.87974047661, -0.000823333859443665}, {3440.63970260322, 0.0012160986661911}, {3686.39966472983, -0.000246867537498474}, {3932.15985968709, -0.000048220157623291}, {4423.67978394032, -0.000825420022010803}, {4915.19970819354, -0.000171273946762085}, {5406.71963244677, 0.000145509839057922}, {5898.23955669999, 0.000238180160522461}, {6389.75948095322, -0.000783056020736694}, {6881.27940520644, 0.00214140117168427}, {7372.79932945967, 0.00112025439739227}, {7864.31971937418, -0.0000799447298049927}, {8847.35956788063, -0.00126606225967407}, {9830.39941638708, 0.00299414992332458}, {10813.4392648935, 0.000097230076789856}, {11796.4791134, 0.000152230262756348}, {12779.5189619064, -0.000457733869552612}, {13762.5588104129, -0.000152021646499634}, {14745.5986589193, 0.00147959589958191}, {15728.639438748402, -0.000626951456069946}, {17694.719135761297, 7.45058059692383*^-8}, {19660.7988327742, 0.000969424843788147}, {21626.8785297871, 0.000426799058914185}, {23592.9582268, -0.000123664736747742}, {25559.037923812903, 0.000114679336547852}, {27525.1176208258, -0.000175699591636658}, {29491.1973178387, -0.000264331698417664}, {31457.278877496698, 0.000614166259765625}, {35389.4382715225, 0.000834554433822632}, {39321.597665548295, -0.000381141901016235}, {43253.7570595741, -0.000121623277664185}, {47185.9164535999, 0.000217020511627197}, {51118.075847625696, -0.000283166766166687}, {55050.2352416515, -0.0000498741865158081}, {58982.3946356773, 0.000403955578804016}, {62914.557754993395, 0.0000993460416793823}, {70778.876543045, 0.0000348687171936035}, {78643.19533109659, 9.34302806854248*^-6}, {86507.5141191483, 0.000593841075897217}, {94371.8329071999, -0.000484049320220947}, {102236.15169525101, 0.000255286693572998}, {110100.470483303, 0.000323504209518433}, {117964.789271355, 0.000415980815887451}, {125829.115509987, 0.000451415777206421}, {141557.75308609, 0.000270605087280273}, {157286.390662193, -0.000236198306083679}, {173015.028238297, 0.00011521577835083}, {188743.6658144, -0.0000376701354980469}, {204472.30339050302, 1.63912773132324*^-7}, {220200.940966606, 0.00032593309879303}, {235929.578542709, -0.000216841697692871}, {251658.231019974, -0.00032101571559906}, {283115.50617218, -0.0000266879796981812}, {314572.781324387, -0.000011831521987915}, {346030.056476593, -0.0000126361846923828}, {377487.331628799, -0.0000726133584976196}, {408944.60678100603, -0.000130340456962585}, {440401.881933212, -0.0000299811363220215}, {471859.157085419, -0.000293850898742676}, {503316.462039948, -0.000213354825973511}, {566231.01234436, -0.0000904053449630737}, {629145.562648773, -0.000339552760124207}, {692060.112953186, -0.0000195950269699097}, {754974.663257599, 0.0000858902931213379}, {817889.2135620121, -0.0000700801610946655}, {880803.763866425, 0.0000393092632293701}, {943718.3141708369, 0.0000105351209640503}, {1.0066329240798999*^6, -0.0000357329845428467}, {1.13246202468872*^6, -0.0000886917114257813}, {1.2582911252975499*^6, 0.0000411570072174072}, {1.38412022590637*^6, 0.00010836124420166}, {1.5099493265152*^6, 0.000116199254989624}, {1.6357784271240202*^6, 0.000168055295944214}, {1.76160752773285*^6, -0.000118017196655273}, {1.88743662834167*^6, 0.0000250786542892456}, {2.01326584815979*^6, -0.000127330422401428}, {2.26492404937744*^6, -0.000076591968536377}, {2.51658225059509*^6, -0.0000694841146469116}, {2.76824045181274*^6, 0.000146612524986267}, {3.0198986530304*^6, 0.0000796616077423096}, {3.27155685424805*^6, 0.0000709295272827148}, {3.5232150554657*^6, 5.0663948059082*^-6}, {3.77487325668335*^6, 0.0000626146793365479}, {4.02653169631958*^6, -0.000162750482559204}}, {"Microseconds", IndependentUnit["ArbitraryUnits"]}, {{1}, {2}}}]]}, {Quantity[32., "Milligrams"/"Milliliters"], QuantityArray[ StructuredArray`StructuredData[{168, 2}, {{{0.479999982871959, 0.95259565114975}, {0.959999965743918, 0.943989157676697}, {1.4400000054592998, 0.932796835899353}, {1.9199999314878398, 0.926677465438843}, {2.3999998575163803, 0.916922926902771}, {2.88000001091859, 0.911017894744873}, {3.35999993694713, 0.904476344585419}, {3.83999986297567, 0.896003782749176}, {4.31999978900421, 0.887879252433777}, {4.79999971503275, 0.881930947303772}, {5.2799996410612895, 0.876232266426086}, {5.7600000218371905, 0.868283152580261}, {6.23999994786573, 0.862771689891815}, {6.71999987389427, 0.853693187236786}, {7.19999979992281, 0.84713351726532}, {7.679999725951349, 0.84125280380249}, {8.63999957800843, 0.828350961208344}, {9.59999943006551, 0.815098941326141}, {10.5599992821226, 0.800407409667969}, {11.519999134179699, 0.78870016336441}, {12.4799989862368, 0.77774715423584}, {13.4399988382938, 0.764442205429077}, {14.3999986903509, 0.753266930580139}, {15.359999451902699, 0.74065774679184}, {17.2799991560169, 0.717939376831055}, {19.199998860131, 0.694446742534637}, {21.1199985642452, 0.672496438026428}, {23.0399982683593, 0.651398420333862}, {24.9599979724735, 0.631280303001404}, {26.8799976765877, 0.611724257469177}, {28.7999973807018, 0.592803478240967}, {30.719998903805397, 0.573672771453857}, {34.5599983120337, 0.540289640426636}, {38.399997720262, 0.507833361625671}, {42.2399971284904, 0.476784974336624}, {46.0799965367187, 0.448988825082779}, {49.919995944947, 0.422135204076767}, {53.7599953531753, 0.396867841482162}, {57.5999947614037, 0.372658342123032}, {61.439997807610794, 0.350979894399643}, {69.1199966240674, 0.311578333377838}, {76.7999954405241, 0.275897622108459}, {84.4799942569807, 0.244635045528412}, {92.1599930734374, 0.217919081449509}, {99.839991889894, 0.193074226379395}, {107.51999070635101, 0.172617346048355}, {115.199989522807, 0.154505610466003}, {122.879995615222, 0.137937217950821}, {138.239993248135, 0.111140429973602}, {153.599990881048, 0.0890829861164093}, {168.959988513961, 0.0715492367744446}, {184.319986146875, 0.0573898255825043}, {199.679983779788, 0.0461378395557404}, {215.03998141270102, 0.038314163684845}, {230.399979045615, 0.0310396552085876}, {245.759991230443, 0.0249546766281128}, {276.47998649627, 0.0173799395561218}, {307.199981762096, 0.0124786198139191}, {337.919977027923, 0.0101871192455292}, {368.639972293749, 0.00811973214149475}, {399.359967559576, 0.00527837872505188}, {430.079962825403, 0.00405359268188477}, {460.799958091229, 0.00220732390880585}, {491.519982460886, 0.00202687084674835}, {552.959972992539, 0.00173425674438477}, {614.399963524193, 0.00120586156845093}, {675.839954055846, 0.0000814050436019897}, {737.279944587499, -0.000756010413169861}, {798.719935119152, -0.000476166605949402}, {860.159925650805, 0.0000713169574737549}, {921.599916182458, 0.00110392272472382}, {983.039964921772, -0.0000271648168563843}, {1105.91994598508, -0.00218115746974945}, {1228.79992704839, -0.0033181756734848}, {1351.6799081116899, 0.000467061996459961}, {1474.559889175, 0.00207686424255371}, {1597.4398702383, -0.000713884830474854}, {1720.31985130161, -0.00115785002708435}, {1843.19983236492, 0.00172534584999084}, {1966.0799298435402, 0.000717520713806152}, {2211.83989197016, -0.000364139676094055}, {2457.59985409677, -0.000906050205230713}, {2703.3598162233798, 0.00149925053119659}, {2949.11977835, 0.00247257947921753}, {3194.87974047661, 0.001163050532341}, {3440.63970260322, -0.000546157360076904}, {3686.39966472983, 0.00174525380134583}, {3932.15985968709, 0.00023496150970459}, {4423.67978394032, -0.00103788077831268}, {4915.19970819354, -0.000945195555686951}, {5406.71963244677, -0.00165726244449615}, {5898.23955669999, -0.00140611827373505}, {6389.75948095322, 0.00023224949836731}, {6881.27940520644, 0.0000590980052947998}, {7372.79932945967, -0.000653386116027832}, {7864.31971937418, 0.00174203515052795}, {8847.35956788063, 0.000307679176330566}, {9830.39941638708, 0.000680685043334961}, {10813.4392648935, 0.0017072856426239}, {11796.4791134, -0.00137625634670258}, {12779.5189619064, 0.00129705667495728}, {13762.5588104129, 0.000775545835494995}, {14745.5986589193, 0.00132367014884949}, {15728.639438748402, -0.0011085718870163}, {17694.719135761297, 0.0000582635402679443}, {19660.7988327742, -0.000646904110908508}, {21626.8785297871, 0.000898838043212891}, {23592.9582268, -0.000461310148239136}, {25559.037923812903, 0.00122375786304474}, {27525.1176208258, -0.000115841627120972}, {29491.1973178387, 0.000120729207992554}, {31457.278877496698, 0.000741839408874512}, {35389.4382715225, 0.000546321272850037}, {39321.597665548295, 0.000558525323867798}, {43253.7570595741, -0.000270262360572815}, {47185.9164535999, -0.000911340117454529}, {51118.075847625696, -0.0000881850719451904}, {55050.2352416515, -0.000356167554855347}, {58982.3946356773, -0.000677764415740967}, {62914.557754993395, -0.0000342577695846558}, {70778.876543045, -0.000382691621780396}, {78643.19533109659, 0.000786334276199341}, {86507.5141191483, 0.000133544206619263}, {94371.8329071999, 0.000222831964492798}, {102236.15169525101, -0.000238671898841858}, {110100.470483303, -0.0000578463077545166}, {117964.789271355, -0.000153765082359314}, {125829.115509987, 0.000261798501014709}, {141557.75308609, -0.000382751226425171}, {157286.390662193, 5.08129596710205*^-6}, {173015.028238297, 0.0000640451908111572}, {188743.6658144, 0.000125810503959656}, {204472.30339050302, -0.00015084445476532}, {220200.940966606, -0.0000164210796356201}, {235929.578542709, -0.000171676278114319}, {251658.231019974, 0.0000828355550765991}, {283115.50617218, -0.000212311744689941}, {314572.781324387, -0.000165671110153198}, {346030.056476593, -0.0000293254852294922}, {377487.331628799, 0.000290960073471069}, {408944.60678100603, 0.000320553779602051}, {440401.881933212, -0.000114843249320984}, {471859.157085419, 0.000109940767288208}, {503316.462039948, 0.00028112530708313}, {566231.01234436, -0.0000647604465484619}, {629145.562648773, 0.000101983547210693}, {692060.112953186, 0.0000492483377456665}, {754974.663257599, -0.000136375427246094}, {817889.2135620121, -0.0000480860471725464}, {880803.763866425, -0.000203341245651245}, {943718.3141708369, -0.0000437647104263306}, {1.0066329240798999*^6, 0.0000170618295669556}, {1.13246202468872*^6, 0.000172927975654602}, {1.2582911252975499*^6, -0.0000617504119873047}, {1.38412022590637*^6, -0.000295624136924744}, {1.5099493265152*^6, 0.0000447481870651245}, {1.6357784271240202*^6, 1.96695327758789*^-6}, {1.76160752773285*^6, 0.0000270456075668335}, {1.88743662834167*^6, 0.0000651031732559204}, {2.01326584815979*^6, 8.50856304168701*^-6}, {2.26492404937744*^6, -0.000044599175453186}, {2.51658225059509*^6, -0.0000116527080535889}, {2.76824045181274*^6, -0.000036776065826416}, {3.0198986530304*^6, -0.000117093324661255}, {3.27155685424805*^6, -0.0000614672899246216}, {3.5232150554657*^6, 0.0000265985727310181}, {3.77487325668335*^6, -0.000206857919692993}, {4.02653169631958*^6, 0.0000423341989517212}}, {"Microseconds", IndependentUnit["ArbitraryUnits"]}, {{1}, {2}}}]]}, {Quantity[32., "Milligrams"/"Milliliters"], QuantityArray[ StructuredArray`StructuredData[{168, 2}, {{{0.479999982871959, 0.966826200485229}, {0.959999965743918, 0.951424300670624}, {1.4400000054592998, 0.943103015422821}, {1.9199999314878398, 0.93659245967865}, {2.3999998575163803, 0.931294679641724}, {2.88000001091859, 0.918598651885986}, {3.35999993694713, 0.915360271930695}, {3.83999986297567, 0.90584397315979}, {4.31999978900421, 0.898181974887848}, {4.79999971503275, 0.888411641120911}, {5.2799996410612895, 0.883264720439911}, {5.7600000218371905, 0.87588632106781}, {6.23999994786573, 0.868786334991455}, {6.71999987389427, 0.863884747028351}, {7.19999979992281, 0.855121076107025}, {7.679999725951349, 0.849421381950378}, {8.63999957800843, 0.837109982967377}, {9.59999943006551, 0.822322607040405}, {10.5599992821226, 0.80841863155365}, {11.519999134179699, 0.79449474811554}, {12.4799989862368, 0.784878492355347}, {13.4399988382938, 0.771651387214661}, {14.3999986903509, 0.757923007011414}, {15.359999451902699, 0.745689511299133}, {17.2799991560169, 0.721379041671753}, {19.199998860131, 0.698354601860046}, {21.1199985642452, 0.676474094390869}, {23.0399982683593, 0.655860066413879}, {24.9599979724735, 0.636727571487427}, {26.8799976765877, 0.616554260253906}, {28.7999973807018, 0.598483860492706}, {30.719998903805397, 0.579484581947327}, {34.5599983120337, 0.542940497398376}, {38.399997720262, 0.510784506797791}, {42.2399971284904, 0.479205429553986}, {46.0799965367187, 0.451484352350235}, {49.919995944947, 0.424329817295074}, {53.7599953531753, 0.399337977170944}, {57.5999947614037, 0.375730991363525}, {61.439997807610794, 0.354202032089233}, {69.1199966240674, 0.312754273414612}, {76.7999954405241, 0.278291463851929}, {84.4799942569807, 0.247307568788528}, {92.1599930734374, 0.219175219535828}, {99.839991889894, 0.194871485233307}, {107.51999070635101, 0.171930730342865}, {115.199989522807, 0.153098672628403}, {122.879995615222, 0.135064989328384}, {138.239993248135, 0.108773618936539}, {153.599990881048, 0.0866560041904449}, {168.959988513961, 0.069383829832077}, {184.319986146875, 0.0548671782016754}, {199.679983779788, 0.0442905128002167}, {215.03998141270102, 0.0346444249153137}, {230.399979045615, 0.0283809304237366}, {245.759991230443, 0.022125631570816}, {276.47998649627, 0.0135833323001862}, {307.199981762096, 0.00793963670730591}, {337.919977027923, 0.00318855047225952}, {368.639972293749, 0.00109337270259857}, {399.359967559576, -0.000335976481437683}, {430.079962825403, -0.000907197594642639}, {460.799958091229, -0.00205443799495697}, {491.519982460886, -0.00224214792251587}, {552.959972992539, -0.0022461861371994}, {614.399963524193, -0.00217680633068085}, {675.839954055846, -0.0015476793050766}, {737.279944587499, -0.00152306258678436}, {798.719935119152, -0.000255793333053589}, {860.159925650805, 6.72042369842529*^-6}, {921.599916182458, 0.00112845003604889}, {983.039964921772, 0.00179779529571533}, {1105.91994598508, 0.00289653241634369}, {1228.79992704839, -0.000111281871795654}, {1351.6799081116899, 0.00212699174880981}, {1474.559889175, 0.00446882843971252}, {1597.4398702383, -0.000103786587715149}, {1720.31985130161, -0.00155845284461975}, {1843.19983236492, -0.000862151384353638}, {1966.0799298435402, -0.0025208592414856}, {2211.83989197016, 0.00109031796455383}, {2457.59985409677, 0.00155384838581085}, {2703.3598162233798, -0.000589191913604736}, {2949.11977835, -0.000628173351287842}, {3194.87974047661, -0.000713810324668884}, {3440.63970260322, -0.00290289521217346}, {3686.39966472983, -0.00329665839672089}, {3932.15985968709, -0.00290119647979736}, {4423.67978394032, -0.000280424952507019}, {4915.19970819354, 0.000606566667556763}, {5406.71963244677, 0.00135669112205505}, {5898.23955669999, 0.000352844595909119}, {6389.75948095322, -0.000181987881660461}, {6881.27940520644, -0.00104808807373047}, {7372.79932945967, -0.0000813752412796021}, {7864.31971937418, -0.00120562314987183}, {8847.35956788063, 0.000477790832519531}, {9830.39941638708, 0.0000832229852676392}, {10813.4392648935, -0.00164474546909332}, {11796.4791134, -0.0000513941049575806}, {12779.5189619064, 0.000550270080566406}, {13762.5588104129, 0.00126746296882629}, {14745.5986589193, 0.000737115740776062}, {15728.639438748402, -0.000568240880966187}, {17694.719135761297, -0.000726193189620972}, {19660.7988327742, -0.000173822045326233}, {21626.8785297871, -0.000461041927337646}, {23592.9582268, -0.00034797191619873}, {25559.037923812903, 3.94880771636963*^-6}, {27525.1176208258, -0.000372663140296936}, {29491.1973178387, 0.00164049863815308}, {31457.278877496698, -0.000932171940803528}, {35389.4382715225, 0.000103086233139038}, {39321.597665548295, 0.000608488917350769}, {43253.7570595741, 0.000343382358551025}, {47185.9164535999, -0.000157967209815979}, {51118.075847625696, 0.0000375956296920776}, {55050.2352416515, 0.000948250293731689}, {58982.3946356773, 0.000599503517150879}, {62914.557754993395, -0.000488772988319397}, {70778.876543045, 0.0000484436750411987}, {78643.19533109659, -0.000243335962295532}, {86507.5141191483, -0.000201821327209473}, {94371.8329071999, 0.0000737607479095459}, {102236.15169525101, 0.000395908951759338}, {110100.470483303, 0.0000479221343994141}, {117964.789271355, 0.000156670808792114}, {125829.115509987, 0.0000831037759780884}, {141557.75308609, -0.000279739499092102}, {157286.390662193, -0.000145837664604187}, {173015.028238297, -0.00036776065826416}, {188743.6658144, -0.0000273287296295166}, {204472.30339050302, -0.000181004405021667}, {220200.940966606, -0.0000725984573364258}, {235929.578542709, -0.000237777829170227}, {251658.231019974, -0.000460967421531677}, {283115.50617218, -0.00024530291557312}, {314572.781324387, 0.000189334154129028}, {346030.056476593, -0.000163331627845764}, {377487.331628799, 0.0000359117984771729}, {408944.60678100603, -0.0000202655792236328}, {440401.881933212, 0.000125154852867126}, {471859.157085419, 0.0000224411487579346}, {503316.462039948, -0.000126644968986511}, {566231.01234436, -0.0000632107257843018}, {629145.562648773, 5.21540641784668*^-6}, {692060.112953186, -0.0000558942556381226}, {754974.663257599, 0.000211179256439209}, {817889.2135620121, 0.0000375062227249146}, {880803.763866425, 0.000066220760345459}, {943718.3141708369, 0.0000476688146591187}, {1.0066329240798999*^6, -0.0000309646129608154}, {1.13246202468872*^6, -0.0000218451023101807}, {1.2582911252975499*^6, -0.000180050730705261}, {1.38412022590637*^6, -0.0000222325325012207}, {1.5099493265152*^6, 0.0000401437282562256}, {1.6357784271240202*^6, -0.0000666826963424683}, {1.76160752773285*^6, 6.72042369842529*^-6}, {1.88743662834167*^6, 0.0000508129596710205}, {2.01326584815979*^6, 3.76999378204346*^-6}, {2.26492404937744*^6, 0.0000222921371459961}, {2.51658225059509*^6, -2.39908695220947*^-6}, {2.76824045181274*^6, -0.0000947713851928711}, {3.0198986530304*^6, 0.00006885826587677}, {3.27155685424805*^6, -0.000130355358123779}, {3.5232150554657*^6, 0.000093802809715271}, {3.77487325668335*^6, 0.0000127702951431274}, {4.02653169631958*^6, -0.0000664591789245605}}, {"Microseconds", IndependentUnit["ArbitraryUnits"]}, {{1}, {2}}}]]}, {Quantity[32., "Milligrams"/"Milliliters"], QuantityArray[ StructuredArray`StructuredData[{168, 2}, {{{0.479999982871959, 0.962513208389282}, {0.959999965743918, 0.952265441417694}, {1.4400000054592998, 0.941246032714844}, {1.9199999314878398, 0.934486031532288}, {2.3999998575163803, 0.924028396606445}, {2.88000001091859, 0.920782446861267}, {3.35999993694713, 0.911919891834259}, {3.83999986297567, 0.904342412948608}, {4.31999978900421, 0.89889919757843}, {4.79999971503275, 0.890579581260681}, {5.2799996410612895, 0.882250905036926}, {5.7600000218371905, 0.872868359088898}, {6.23999994786573, 0.868367969989777}, {6.71999987389427, 0.861554145812988}, {7.19999979992281, 0.854475498199463}, {7.679999725951349, 0.846840023994446}, {8.63999957800843, 0.834541082382202}, {9.59999943006551, 0.819400429725647}, {10.5599992821226, 0.806307077407837}, {11.519999134179699, 0.795322299003601}, {12.4799989862368, 0.783113420009613}, {13.4399988382938, 0.768461942672729}, {14.3999986903509, 0.757020473480225}, {15.359999451902699, 0.744821071624756}, {17.2799991560169, 0.721613526344299}, {19.199998860131, 0.697659969329834}, {21.1199985642452, 0.676778852939606}, {23.0399982683593, 0.656408548355103}, {24.9599979724735, 0.635361075401306}, {26.8799976765877, 0.613838315010071}, {28.7999973807018, 0.595425367355347}, {30.719998903805397, 0.57828563451767}, {34.5599983120337, 0.543543934822083}, {38.399997720262, 0.510819137096405}, {42.2399971284904, 0.479826480150223}, {46.0799965367187, 0.450327694416046}, {49.919995944947, 0.424268454313278}, {53.7599953531753, 0.398813307285309}, {57.5999947614037, 0.37473601102829}, {61.439997807610794, 0.353001654148102}, {69.1199966240674, 0.312195479869843}, {76.7999954405241, 0.276213824748993}, {84.4799942569807, 0.244955122470856}, {92.1599930734374, 0.217481106519699}, {99.839991889894, 0.193024754524231}, {107.51999070635101, 0.171198725700378}, {115.199989522807, 0.152095258235931}, {122.879995615222, 0.135466247797012}, {138.239993248135, 0.107715427875519}, {153.599990881048, 0.085505872964859}, {168.959988513961, 0.0685508847236633}, {184.319986146875, 0.055332362651825}, {199.679983779788, 0.0441324710845947}, {215.03998141270102, 0.0350958704948425}, {230.399979045615, 0.0289879143238068}, {245.759991230443, 0.0227795243263245}, {276.47998649627, 0.0139152705669403}, {307.199981762096, 0.00899809598922729}, {337.919977027923, 0.00528159737586975}, {368.639972293749, 0.0028865784406662}, {399.359967559576, 0.00113843381404877}, {430.079962825403, -0.0000799000263214111}, {460.799958091229, -0.00101764500141144}, {491.519982460886, -0.000670865178108215}, {552.959972992539, 4.23192977905273*^-6}, {614.399963524193, 0.000279158353805542}, {675.839954055846, -0.000582724809646606}, {737.279944587499, -0.000303849577903748}, {798.719935119152, 0.000672966241836548}, {860.159925650805, 0.000929266214370728}, {921.599916182458, 0.000315397977828979}, {983.039964921772, -0.000601902604103088}, {1105.91994598508, -0.000332891941070557}, {1228.79992704839, -0.000546455383300781}, {1351.6799081116899, 0.000100448727607727}, {1474.559889175, -0.000391155481338501}, {1597.4398702383, -0.00028739869594574}, {1720.31985130161, -0.000768378376960754}, {1843.19983236492, -0.00140756368637085}, {1966.0799298435402, 0.000230759382247925}, {2211.83989197016, 0.000812843441963196}, {2457.59985409677, 0.000612124800682068}, {2703.3598162233798, -0.00129905343055725}, {2949.11977835, 0.00115227699279785}, {3194.87974047661, -0.00170363485813141}, {3440.63970260322, -0.00137527287006378}, {3686.39966472983, 0.000216826796531677}, {3932.15985968709, -0.00122615694999695}, {4423.67978394032, -0.000388815999031067}, {4915.19970819354, -0.00183337926864624}, {5406.71963244677, -0.00125910341739655}, {5898.23955669999, -0.0014149397611618}, {6389.75948095322, 0.00213748216629028}, {6881.27940520644, 0.00290840864181519}, {7372.79932945967, 0.000210359692573547}, {7864.31971937418, -0.000670135021209717}, {8847.35956788063, 0.00116586685180664}, {9830.39941638708, 0.000210344791412354}, {10813.4392648935, -0.0010417103767395}, {11796.4791134, -0.000723540782928467}, {12779.5189619064, -0.0000170320272445679}, {13762.5588104129, 0.000326871871948242}, {14745.5986589193, -0.000187978148460388}, {15728.639438748402, 0.00023534893989563}, {17694.719135761297, 6.10947608947754*^-7}, {19660.7988327742, -0.000193133950233459}, {21626.8785297871, 0.00110657513141632}, {23592.9582268, -0.00113324820995331}, {25559.037923812903, -0.000593855977058411}, {27525.1176208258, -0.000109001994132996}, {29491.1973178387, 0.000565782189369202}, {31457.278877496698, 0.0000955015420913696}, {35389.4382715225, -0.000876724720001221}, {39321.597665548295, -0.000165939331054688}, {43253.7570595741, -0.000662103295326233}, {47185.9164535999, -0.0000278055667877197}, {51118.075847625696, -0.000405430793762207}, {55050.2352416515, -0.000271275639533997}, {58982.3946356773, -0.000190377235412598}, {62914.557754993395, -0.000871509313583374}, {70778.876543045, 0.000296995043754578}, {78643.19533109659, 0.0000952482223510742}, {86507.5141191483, 2.05636024475098*^-6}, {94371.8329071999, -0.000027775764465332}, {102236.15169525101, -0.000503599643707275}, {110100.470483303, -0.000174865126609802}, {117964.789271355, 0.0000996142625808716}, {125829.115509987, 0.000401005148887634}, {141557.75308609, 0.000120297074317932}, {157286.390662193, 0.0000337511301040649}, {173015.028238297, -0.000132590532302856}, {188743.6658144, -0.00003834068775177}, {204472.30339050302, -0.0000945031642913818}, {220200.940966606, 0.0001983642578125}, {235929.578542709, -0.000287353992462158}, {251658.231019974, 0.000198632478713989}, {283115.50617218, -0.0000684410333633423}, {314572.781324387, -0.000132620334625244}, {346030.056476593, 0.000060543417930603}, {377487.331628799, -0.0000827163457870483}, {408944.60678100603, -0.00010719895362854}, {440401.881933212, 0.000174880027770996}, {471859.157085419, 0.000107109546661377}, {503316.462039948, -0.0000781714916229248}, {566231.01234436, 0.0000546723604202271}, {629145.562648773, -0.000152558088302612}, {692060.112953186, 0.0000158995389938354}, {754974.663257599, -0.0000208616256713867}, {817889.2135620121, 0.000250130891799927}, {880803.763866425, -0.000123545527458191}, {943718.3141708369, 0.0000102967023849487}, {1.0066329240798999*^6, 0.000098004937171936}, {1.13246202468872*^6, -0.0000445544719696045}, {1.2582911252975499*^6, -0.0000623166561126709}, {1.38412022590637*^6, 0.0000297874212265015}, {1.5099493265152*^6, -0.0000593066215515137}, {1.6357784271240202*^6, 0.0000485777854919434}, {1.76160752773285*^6, 0.0000692605972290039}, {1.88743662834167*^6, -0.0000375658273696899}, {2.01326584815979*^6, -0.0000406950712203979}, {2.26492404937744*^6, 0.0000348538160324097}, {2.51658225059509*^6, -0.0000523179769515991}, {2.76824045181274*^6, -0.0000222176313400269}, {3.0198986530304*^6, -0.0000709891319274902}, {3.27155685424805*^6, 0.00005340576171875}, {3.5232150554657*^6, -0.0000906139612197876}, {3.77487325668335*^6, 2.90572643280029*^-6}, {4.02653169631958*^6, -0.0000700056552886963}}, {"Microseconds", IndependentUnit["ArbitraryUnits"]}, {{1}, {2}}}]]}, {Quantity[24., "Milligrams"/"Milliliters"], QuantityArray[ StructuredArray`StructuredData[{168, 2}, {{{0.479999982871959, 0.968514919281006}, {0.959999965743918, 0.953913331031799}, {1.4400000054592998, 0.944635629653931}, {1.9199999314878398, 0.938026487827301}, {2.3999998575163803, 0.926885843276978}, {2.88000001091859, 0.91902494430542}, {3.35999993694713, 0.912815570831299}, {3.83999986297567, 0.903424620628357}, {4.31999978900421, 0.893398642539978}, {4.79999971503275, 0.890375316143036}, {5.2799996410612895, 0.881069183349609}, {5.7600000218371905, 0.872166156768799}, {6.23999994786573, 0.863422095775604}, {6.71999987389427, 0.859393537044525}, {7.19999979992281, 0.851564824581146}, {7.679999725951349, 0.840499103069305}, {8.63999957800843, 0.828187704086304}, {9.59999943006551, 0.814087271690369}, {10.5599992821226, 0.799590051174164}, {11.519999134179699, 0.789315938949585}, {12.4799989862368, 0.775270104408264}, {13.4399988382938, 0.760460793972015}, {14.3999986903509, 0.748793840408325}, {15.359999451902699, 0.737712740898132}, {17.2799991560169, 0.710196077823639}, {19.199998860131, 0.687438368797302}, {21.1199985642452, 0.664812564849854}, {23.0399982683593, 0.642294049263}, {24.9599979724735, 0.622197985649109}, {26.8799976765877, 0.601928532123566}, {28.7999973807018, 0.581939458847046}, {30.719998903805397, 0.563005208969116}, {34.5599983120337, 0.526700139045715}, {38.399997720262, 0.491415798664093}, {42.2399971284904, 0.461826473474503}, {46.0799965367187, 0.4322549700737}, {49.919995944947, 0.403685480356216}, {53.7599953531753, 0.377147912979126}, {57.5999947614037, 0.353273719549179}, {61.439997807610794, 0.332247525453568}, {69.1199966240674, 0.291191846132278}, {76.7999954405241, 0.256585717201233}, {84.4799942569807, 0.225879669189453}, {92.1599930734374, 0.198395550251007}, {99.839991889894, 0.174558788537979}, {107.51999070635101, 0.154314488172531}, {115.199989522807, 0.135992676019669}, {122.879995615222, 0.120206654071808}, {138.239993248135, 0.0934578478336334}, {153.599990881048, 0.073912650346756}, {168.959988513961, 0.0569536685943604}, {184.319986146875, 0.0449091792106628}, {199.679983779788, 0.0349618494510651}, {215.03998141270102, 0.0271615982055664}, {230.399979045615, 0.0208498537540436}, {245.759991230443, 0.0153959393501282}, {276.47998649627, 0.00787925720214844}, {307.199981762096, 0.003551185131073}, {337.919977027923, 0.00069408118724823}, {368.639972293749, -0.0000876337289810181}, {399.359967559576, -0.0000193864107131958}, {430.079962825403, -0.000389322638511658}, {460.799958091229, -0.000425994396209717}, {491.519982460886, -0.00121040642261505}, {552.959972992539, -0.00134502351284027}, {614.399963524193, -0.000414460897445679}, {675.839954055846, 0.00162307918071747}, {737.279944587499, 0.00153614580631256}, {798.719935119152, 0.00154007971286774}, {860.159925650805, -0.000437036156654358}, {921.599916182458, 0.000283956527709961}, {983.039964921772, 0.000714018940925598}, {1105.91994598508, 0.000238463282585144}, {1228.79992704839, 0.00117906928062439}, {1351.6799081116899, -0.00172396004199982}, {1474.559889175, -0.00220373272895813}, {1597.4398702383, -0.0005970299243927}, {1720.31985130161, -0.00178414583206177}, {1843.19983236492, -0.00108431279659271}, {1966.0799298435402, 0.00150147080421448}, {2211.83989197016, 0.00277411937713623}, {2457.59985409677, 0.00164757668972015}, {2703.3598162233798, 0.000744163990020752}, {2949.11977835, 0.000277400016784668}, {3194.87974047661, 0.0010702908039093}, {3440.63970260322, -0.000307530164718628}, {3686.39966472983, -0.00114706158638}, {3932.15985968709, 0.000153094530105591}, {4423.67978394032, -0.000787615776062012}, {4915.19970819354, -0.000265687704086304}, {5406.71963244677, -0.000480368733406067}, {5898.23955669999, -0.000691115856170654}, {6389.75948095322, 0.00211995840072632}, {6881.27940520644, 0.000348880887031555}, {7372.79932945967, 0.00115184485912323}, {7864.31971937418, -0.00056082010269165}, {8847.35956788063, 0.00118009746074677}, {9830.39941638708, 0.00119130313396454}, {10813.4392648935, -0.000603511929512024}, {11796.4791134, -0.000461012125015259}, {12779.5189619064, 0.0000764578580856323}, {13762.5588104129, -0.000434666872024536}, {14745.5986589193, -0.000230088829994202}, {15728.639438748402, -0.000450938940048218}, {17694.719135761297, -0.000783428549766541}, {19660.7988327742, -0.000255733728408813}, {21626.8785297871, 0.000314921140670776}, {23592.9582268, -0.000402212142944336}, {25559.037923812903, 0.000149339437484741}, {27525.1176208258, 0.000272750854492188}, {29491.1973178387, 0.000502496957778931}, {31457.278877496698, 0.0006522536277771}, {35389.4382715225, -0.000250622630119324}, {39321.597665548295, -0.000720128417015076}, {43253.7570595741, -0.000403985381126404}, {47185.9164535999, -0.000215664505958557}, {51118.075847625696, -0.00027097761631012}, {55050.2352416515, -0.000297114253044128}, {58982.3946356773, -0.000210016965866089}, {62914.557754993395, -0.00042840838432312}, {70778.876543045, -0.0000286400318145752}, {78643.19533109659, 0.000053897500038147}, {86507.5141191483, -0.000128120183944702}, {94371.8329071999, -0.000434830784797668}, {102236.15169525101, 0.0000834167003631592}, {110100.470483303, -0.000568851828575134}, {117964.789271355, 0.000453352928161621}, {125829.115509987, -0.0000247061252593994}, {141557.75308609, 0.0000195205211639404}, {157286.390662193, -0.00012737512588501}, {173015.028238297, 0.0000435411930084229}, {188743.6658144, 0.000502407550811768}, {204472.30339050302, -0.000203415751457214}, {220200.940966606, -0.000304058194160461}, {235929.578542709, 6.31809234619141*^-6}, {251658.231019974, 0.000127866864204407}, {283115.50617218, -0.0000775903463363647}, {314572.781324387, 5.81145286560059*^-7}, {346030.056476593, 0.0000428110361099243}, {377487.331628799, -0.0000771582126617432}, {408944.60678100603, -0.000214099884033203}, {440401.881933212, -0.000194862484931946}, {471859.157085419, 0.000219061970710754}, {503316.462039948, 7.39097595214844*^-6}, {566231.01234436, 0.0000441074371337891}, {629145.562648773, 0.0000398159027099609}, {692060.112953186, -0.0000135451555252075}, {754974.663257599, 0.000274658203125}, {817889.2135620121, -0.0000359863042831421}, {880803.763866425, -0.0000960379838943481}, {943718.3141708369, 6.89923763275146*^-6}, {1.0066329240798999*^6, 0.0000758171081542969}, {1.13246202468872*^6, -0.000107884407043457}, {1.2582911252975499*^6, 0.000160247087478638}, {1.38412022590637*^6, 0.0000389665365219116}, {1.5099493265152*^6, 0.000121772289276123}, {1.6357784271240202*^6, -0.00036543607711792}, {1.76160752773285*^6, 2.32458114624023*^-6}, {1.88743662834167*^6, -0.0000420659780502319}, {2.01326584815979*^6, -0.000065341591835022}, {2.26492404937744*^6, -0.0000457465648651123}, {2.51658225059509*^6, -0.000026404857635498}, {2.76824045181274*^6, -3.44216823577881*^-6}, {3.0198986530304*^6, -0.000111520290374756}, {3.27155685424805*^6, 0.0000128895044326782}, {3.5232150554657*^6, 0.0000546872615814209}, {3.77487325668335*^6, -0.000203356146812439}, {4.02653169631958*^6, 0.000145658850669861}}, {"Microseconds", IndependentUnit["ArbitraryUnits"]}, {{1}, {2}}}]]}, {Quantity[24., "Milligrams"/"Milliliters"], QuantityArray[ StructuredArray`StructuredData[{168, 2}, {{{0.479999982871959, 0.950624585151672}, {0.959999965743918, 0.943064272403717}, {1.4400000054592998, 0.929249048233032}, {1.9199999314878398, 0.921515882015228}, {2.3999998575163803, 0.910164594650269}, {2.88000001091859, 0.905607581138611}, {3.35999993694713, 0.897368192672729}, {3.83999986297567, 0.8875772356987}, {4.31999978900421, 0.881236553192139}, {4.79999971503275, 0.876010477542877}, {5.2799996410612895, 0.867285132408142}, {5.7600000218371905, 0.859541952610016}, {6.23999994786573, 0.848509967327118}, {6.71999987389427, 0.843183636665344}, {7.19999979992281, 0.836652159690857}, {7.679999725951349, 0.82635772228241}, {8.63999957800843, 0.813511431217194}, {9.59999943006551, 0.799100935459137}, {10.5599992821226, 0.783139586448669}, {11.519999134179699, 0.771970748901367}, {12.4799989862368, 0.759040415287018}, {13.4399988382938, 0.745323717594147}, {14.3999986903509, 0.73135769367218}, {15.359999451902699, 0.719520330429077}, {17.2799991560169, 0.694269597530365}, {19.199998860131, 0.670324325561523}, {21.1199985642452, 0.647212862968445}, {23.0399982683593, 0.625432312488556}, {24.9599979724735, 0.604659497737885}, {26.8799976765877, 0.582622766494751}, {28.7999973807018, 0.562823712825775}, {30.719998903805397, 0.543612360954285}, {34.5599983120337, 0.507917404174805}, {38.399997720262, 0.47383788228035}, {42.2399971284904, 0.442605018615723}, {46.0799965367187, 0.413471966981888}, {49.919995944947, 0.387697011232376}, {53.7599953531753, 0.360990911722183}, {57.5999947614037, 0.338562220335007}, {61.439997807610794, 0.315650522708893}, {69.1199966240674, 0.276930510997772}, {76.7999954405241, 0.242046892642975}, {84.4799942569807, 0.211724460124969}, {92.1599930734374, 0.18496111035347}, {99.839991889894, 0.162880748510361}, {107.51999070635101, 0.143523573875427}, {115.199989522807, 0.125821083784103}, {122.879995615222, 0.110522031784058}, {138.239993248135, 0.0850087106227875}, {153.599990881048, 0.065360963344574}, {168.959988513961, 0.0508391559123993}, {184.319986146875, 0.040021538734436}, {199.679983779788, 0.0306867063045502}, {215.03998141270102, 0.0232576131820679}, {230.399979045615, 0.0176295638084412}, {245.759991230443, 0.0144456326961517}, {276.47998649627, 0.0083673894405365}, {307.199981762096, 0.0043337345123291}, {337.919977027923, 0.00297999382019043}, {368.639972293749, 0.00184893608093262}, {399.359967559576, 0.00110834836959839}, {430.079962825403, -0.000142917037010193}, {460.799958091229, -0.000885829329490662}, {491.519982460886, 0.000106453895568848}, {552.959972992539, 0.00150942802429199}, {614.399963524193, 0.00174933671951294}, {675.839954055846, 0.00368162989616394}, {737.279944587499, 0.00407302379608154}, {798.719935119152, 0.00322714447975159}, {860.159925650805, 0.00350469350814819}, {921.599916182458, 0.00282901525497437}, {983.039964921772, 0.00116643309593201}, {1105.91994598508, -0.000059083104133606}, {1228.79992704839, -0.0017293244600296}, {1351.6799081116899, -0.00108416378498077}, {1474.559889175, -0.00127598643302917}, {1597.4398702383, -0.000950992107391357}, {1720.31985130161, -0.00201280415058136}, {1843.19983236492, -0.000112414360046387}, {1966.0799298435402, 0.000874176621437073}, {2211.83989197016, 0.00148437917232513}, {2457.59985409677, 0.000766843557357788}, {2703.3598162233798, -0.00165300071239471}, {2949.11977835, -0.000985622406005859}, {3194.87974047661, 0.0009327232837677}, {3440.63970260322, 0.000953450798988342}, {3686.39966472983, -0.000530138611793518}, {3932.15985968709, -0.000249087810516357}, {4423.67978394032, 0.000631064176559448}, {4915.19970819354, -0.00148902833461761}, {5406.71963244677, -0.00201897323131561}, {5898.23955669999, -0.00110211968421936}, {6389.75948095322, -0.00223147869110107}, {6881.27940520644, -0.00138895213603973}, {7372.79932945967, 0.0000872910022735596}, {7864.31971937418, 0.00165018439292908}, {8847.35956788063, 0.000263184309005737}, {9830.39941638708, 0.000948116183280945}, {10813.4392648935, -0.000206798315048218}, {11796.4791134, 0.000227585434913635}, {12779.5189619064, 0.000970438122749329}, {13762.5588104129, 0.000137969851493835}, {14745.5986589193, 0.00135110318660736}, {15728.639438748402, 0.00059211254119873}, {17694.719135761297, 0.000252768397331238}, {19660.7988327742, -0.000770345330238342}, {21626.8785297871, -0.000160783529281616}, {23592.9582268, -0.000406354665756226}, {25559.037923812903, -0.000149235129356384}, {27525.1176208258, 0.000953808426856995}, {29491.1973178387, 0.0000864863395690918}, {31457.278877496698, 0.000324025750160217}, {35389.4382715225, 0.0000463426113128662}, {39321.597665548295, -0.000250950455665588}, {43253.7570595741, -0.000599369406700134}, {47185.9164535999, -0.000246226787567139}, {51118.075847625696, 0.000311300158500671}, {55050.2352416515, -0.000552818179130554}, {58982.3946356773, -0.000297099351882935}, {62914.557754993395, -0.000285014510154724}, {70778.876543045, -0.000150293111801147}, {78643.19533109659, -0.00074160099029541}, {86507.5141191483, 0.0000636577606201172}, {94371.8329071999, -0.000191241502761841}, {102236.15169525101, -0.000289872288703918}, {110100.470483303, -0.0000276863574981689}, {117964.789271355, -0.000307813286781311}, {125829.115509987, 0.0000893175601959229}, {141557.75308609, -0.0000400841236114502}, {157286.390662193, 0.0000370889902114868}, {173015.028238297, 0.00024046003818512}, {188743.6658144, -0.0000390708446502686}, {204472.30339050302, -0.000389724969863892}, {220200.940966606, -0.0000478029251098633}, {235929.578542709, 0.000105872750282288}, {251658.231019974, 0.000405058264732361}, {283115.50617218, -0.0000343471765518188}, {314572.781324387, -0.000433102250099182}, {346030.056476593, 0.0000992715358734131}, {377487.331628799, -0.00011076033115387}, {408944.60678100603, -0.000157788395881653}, {440401.881933212, -0.000178709626197815}, {471859.157085419, 0.000134557485580444}, {503316.462039948, 0.0000140517950057983}, {566231.01234436, -0.000169768929481506}, {629145.562648773, -0.0000317543745040894}, {692060.112953186, 0.0000162422657012939}, {754974.663257599, -0.0000278502702713013}, {817889.2135620121, 0.0000454485416412354}, {880803.763866425, -0.0000285804271697998}, {943718.3141708369, -0.0000768303871154785}, {1.0066329240798999*^6, -0.000110208988189697}, {1.13246202468872*^6, -6.10947608947754*^-6}, {1.2582911252975499*^6, 0.0000824481248855591}, {1.38412022590637*^6, 0.000125467777252197}, {1.5099493265152*^6, 0.00010189414024353}, {1.6357784271240202*^6, 0.0000597685575485229}, {1.76160752773285*^6, -0.0000440478324890137}, {1.88743662834167*^6, -0.000186249613761902}, {2.01326584815979*^6, 0.0000796616077423096}, {2.26492404937744*^6, -0.0000398308038711548}, {2.51658225059509*^6, -0.0000269412994384766}, {2.76824045181274*^6, 0.0000741928815841675}, {3.0198986530304*^6, 0.000127732753753662}, {3.27155685424805*^6, -0.0000888407230377197}, {3.5232150554657*^6, -0.0000869929790496826}, {3.77487325668335*^6, 0.0000363439321517944}, {4.02653169631958*^6, -0.000022590160369873}}, {"Microseconds", IndependentUnit["ArbitraryUnits"]}, {{1}, {2}}}]]}, {Quantity[24., "Milligrams"/"Milliliters"], QuantityArray[ StructuredArray`StructuredData[{168, 2}, {{{0.479999982871959, 0.948392152786255}, {0.959999965743918, 0.938796997070313}, {1.4400000054592998, 0.927454948425293}, {1.9199999314878398, 0.920168459415436}, {2.3999998575163803, 0.91251015663147}, {2.88000001091859, 0.904966115951538}, {3.35999993694713, 0.896956920623779}, {3.83999986297567, 0.886734247207642}, {4.31999978900421, 0.879809737205505}, {4.79999971503275, 0.872004508972168}, {5.2799996410612895, 0.864566802978516}, {5.7600000218371905, 0.857293844223022}, {6.23999994786573, 0.847829461097717}, {6.71999987389427, 0.83967250585556}, {7.19999979992281, 0.832096576690674}, {7.679999725951349, 0.827809453010559}, {8.63999957800843, 0.812645673751831}, {9.59999943006551, 0.797452449798584}, {10.5599992821226, 0.783574998378754}, {11.519999134179699, 0.768800258636475}, {12.4799989862368, 0.755956292152405}, {13.4399988382938, 0.743290781974792}, {14.3999986903509, 0.731091380119324}, {15.359999451902699, 0.716816663742065}, {17.2799991560169, 0.693334341049194}, {19.199998860131, 0.669234752655029}, {21.1199985642452, 0.645291447639465}, {23.0399982683593, 0.623784184455872}, {24.9599979724735, 0.601026296615601}, {26.8799976765877, 0.581203281879425}, {28.7999973807018, 0.560814261436462}, {30.719998903805397, 0.541301429271698}, {34.5599983120337, 0.505632638931274}, {38.399997720262, 0.471343100070953}, {42.2399971284904, 0.438998103141785}, {46.0799965367187, 0.409905165433884}, {49.919995944947, 0.382773518562317}, {53.7599953531753, 0.357241004705429}, {57.5999947614037, 0.333718627691269}, {61.439997807610794, 0.311227679252625}, {69.1199966240674, 0.272135138511658}, {76.7999954405241, 0.237193435430527}, {84.4799942569807, 0.207418918609619}, {92.1599930734374, 0.181386917829514}, {99.839991889894, 0.158643007278442}, {107.51999070635101, 0.138729184865952}, {115.199989522807, 0.122448593378067}, {122.879995615222, 0.107605040073395}, {138.239993248135, 0.0829969346523285}, {153.599990881048, 0.0645731687545776}, {168.959988513961, 0.050856351852417}, {184.319986146875, 0.0393973886966705}, {199.679983779788, 0.0306376218795776}, {215.03998141270102, 0.0246253609657288}, {230.399979045615, 0.0198341310024261}, {245.759991230443, 0.0151402056217194}, {276.47998649627, 0.0098835825920105}, {307.199981762096, 0.00741279125213623}, {337.919977027923, 0.00618827342987061}, {368.639972293749, 0.00449320673942566}, {399.359967559576, 0.00338718295097351}, {430.079962825403, 0.00371566414833069}, {460.799958091229, 0.00267224013805389}, {491.519982460886, 0.00186711549758911}, {552.959972992539, 0.00287660956382751}, {614.399963524193, 0.00238022208213806}, {675.839954055846, 0.00236189365386963}, {737.279944587499, 0.0017453134059906}, {798.719935119152, -0.000619888305664063}, {860.159925650805, -0.00118161737918854}, {921.599916182458, -0.000119075179100037}, {983.039964921772, -0.000972345471382141}, {1105.91994598508, 0.0012843906879425}, {1228.79992704839, 0.00134724378585815}, {1351.6799081116899, -0.00219810009002686}, {1474.559889175, -0.000829681754112244}, {1597.4398702383, 0.00117802619934082}, {1720.31985130161, 0.0022883415222168}, {1843.19983236492, 0.00234737992286682}, {1966.0799298435402, 0.00102177262306213}, {2211.83989197016, 0.0000935643911361694}, {2457.59985409677, 0.000758334994316101}, {2703.3598162233798, -0.00141727924346924}, {2949.11977835, -0.00205685198307037}, {3194.87974047661, 0.000337138772010803}, {3440.63970260322, -0.0000218302011489868}, {3686.39966472983, 0.00169382989406586}, {3932.15985968709, 0.00212471187114716}, {4423.67978394032, 0.00123819708824158}, {4915.19970819354, -0.00232626497745514}, {5406.71963244677, -0.000167980790138245}, {5898.23955669999, 0.000593423843383789}, {6389.75948095322, -0.00048433244228363}, {6881.27940520644, 0.000105723738670349}, {7372.79932945967, 0.000151306390762329}, {7864.31971937418, 0.000231221318244934}, {8847.35956788063, 0.000961914658546448}, {9830.39941638708, 0.00121104717254639}, {10813.4392648935, 0.00014108419418335}, {11796.4791134, -0.000838324427604675}, {12779.5189619064, 0.000258341431617737}, {13762.5588104129, 0.000538662075996399}, {14745.5986589193, 0.00130419433116913}, {15728.639438748402, -0.000268802046775818}, {17694.719135761297, -0.000522762537002563}, {19660.7988327742, 0.000722095370292664}, {21626.8785297871, -0.000730127096176147}, {23592.9582268, -0.000122368335723877}, {25559.037923812903, -0.000337153673171997}, {27525.1176208258, 0.000389039516448975}, {29491.1973178387, -0.0000975728034973145}, {31457.278877496698, -0.000332310795783997}, {35389.4382715225, 0.000114873051643372}, {39321.597665548295, 0.000513762235641479}, {43253.7570595741, 0.000121921300888062}, {47185.9164535999, 0.000213995575904846}, {51118.075847625696, 0.0000158399343490601}, {55050.2352416515, -0.000196129083633423}, {58982.3946356773, 0.000166475772857666}, {62914.557754993395, -0.000221297144889832}, {70778.876543045, -0.000187724828720093}, {78643.19533109659, 0.000112548470497131}, {86507.5141191483, -0.000170052051544189}, {94371.8329071999, -0.0000357776880264282}, {102236.15169525101, 0.0000101774930953979}, {110100.470483303, -0.000134140253067017}, {117964.789271355, -0.000342443585395813}, {125829.115509987, 0.0001353919506073}, {141557.75308609, 0.000223368406295776}, {157286.390662193, 0.000504732131958008}, {173015.028238297, -0.0000564157962799072}, {188743.6658144, 0.000180244445800781}, {204472.30339050302, -0.000211238861083984}, {220200.940966606, 5.31971454620361*^-6}, {235929.578542709, -0.000242650508880615}, {251658.231019974, -0.000238776206970215}, {283115.50617218, -0.000185474753379822}, {314572.781324387, -0.000211730599403381}, {346030.056476593, -0.000105321407318115}, {377487.331628799, 0.0000458806753158569}, {408944.60678100603, 0.000323623418807983}, {440401.881933212, -9.70065593719482*^-6}, {471859.157085419, -0.000035017728805542}, {503316.462039948, -0.0000177472829818726}, {566231.01234436, 0.0000559836626052856}, {629145.562648773, -0.000249519944190979}, {692060.112953186, -0.0000832229852676392}, {754974.663257599, 0.000127404928207397}, {817889.2135620121, 0.0000346153974533081}, {880803.763866425, -0.0000531822443008423}, {943718.3141708369, 0.0000956505537033081}, {1.0066329240798999*^6, 0.0000250488519668579}, {1.13246202468872*^6, -0.0000829696655273438}, {1.2582911252975499*^6, 0.000076979398727417}, {1.38412022590637*^6, -0.0000357776880264282}, {1.5099493265152*^6, -0.0000617951154708862}, {1.6357784271240202*^6, -3.63588333129883*^-6}, {1.76160752773285*^6, -0.0000377744436264038}, {1.88743662834167*^6, -0.000203043222427368}, {2.01326584815979*^6, 0.0000275373458862305}, {2.26492404937744*^6, 0.0000226348638534546}, {2.51658225059509*^6, 0.0000869631767272949}, {2.76824045181274*^6, -0.0000217407941818237}, {3.0198986530304*^6, 0.0000424683094024658}, {3.27155685424805*^6, 0.0000371336936950684}, {3.5232150554657*^6, 0.0000151395797729492}, {3.77487325668335*^6, -0.000144749879837036}, {4.02653169631958*^6, -0.00014929473400116}}, {"Microseconds", IndependentUnit["ArbitraryUnits"]}, {{1}, {2}}}]]}, {Quantity[16., "Milligrams"/"Milliliters"], QuantityArray[ StructuredArray`StructuredData[{168, 2}, {{{0.479999982871959, 0.950853049755096}, {0.959999965743918, 0.939268112182617}, {1.4400000054592998, 0.930166006088257}, {1.9199999314878398, 0.921881675720215}, {2.3999998575163803, 0.915893852710724}, {2.88000001091859, 0.90571916103363}, {3.35999993694713, 0.898388922214508}, {3.83999986297567, 0.890719652175903}, {4.31999978900421, 0.881315588951111}, {4.79999971503275, 0.874767780303955}, {5.2799996410612895, 0.865782678127289}, {5.7600000218371905, 0.859007894992828}, {6.23999994786573, 0.85280179977417}, {6.71999987389427, 0.84288877248764}, {7.19999979992281, 0.836126089096069}, {7.679999725951349, 0.829563736915588}, {8.63999957800843, 0.816071748733521}, {9.59999943006551, 0.801200807094574}, {10.5599992821226, 0.786086320877075}, {11.519999134179699, 0.772086203098297}, {12.4799989862368, 0.760146796703339}, {13.4399988382938, 0.744802594184875}, {14.3999986903509, 0.735504746437073}, {15.359999451902699, 0.722346901893616}, {17.2799991560169, 0.696994185447693}, {19.199998860131, 0.673503518104553}, {21.1199985642452, 0.650017142295837}, {23.0399982683593, 0.627739787101746}, {24.9599979724735, 0.60721629858017}, {26.8799976765877, 0.586374878883362}, {28.7999973807018, 0.566249489784241}, {30.719998903805397, 0.548047542572021}, {34.5599983120337, 0.511184990406036}, {38.399997720262, 0.47864431142807}, {42.2399971284904, 0.447209417819977}, {46.0799965367187, 0.417876690626144}, {49.919995944947, 0.391142070293427}, {53.7599953531753, 0.365589082241058}, {57.5999947614037, 0.34237813949585}, {61.439997807610794, 0.320647269487381}, {69.1199966240674, 0.282347798347473}, {76.7999954405241, 0.249337166547775}, {84.4799942569807, 0.219369262456894}, {92.1599930734374, 0.194329440593719}, {99.839991889894, 0.17223533987999}, {107.51999070635101, 0.15323194861412}, {115.199989522807, 0.135376244783401}, {122.879995615222, 0.120449811220169}, {138.239993248135, 0.0950094759464264}, {153.599990881048, 0.0754689574241638}, {168.959988513961, 0.0611554384231567}, {184.319986146875, 0.0497083067893982}, {199.679983779788, 0.0409538745880127}, {215.03998141270102, 0.0333939492702484}, {230.399979045615, 0.0270350873470306}, {245.759991230443, 0.023148238658905}, {276.47998649627, 0.0156121551990509}, {307.199981762096, 0.0100809931755066}, {337.919977027923, 0.00610420107841492}, {368.639972293749, 0.00408881902694702}, {399.359967559576, 0.00267034769058228}, {430.079962825403, 0.00265663862228394}, {460.799958091229, 0.00352054834365845}, {491.519982460886, 0.00368481874465942}, {552.959972992539, 0.0024724006652832}, {614.399963524193, 0.0022253692150116}, {675.839954055846, 0.000827565789222717}, {737.279944587499, 0.000416815280914307}, {798.719935119152, -0.000615164637565613}, {860.159925650805, 0.00294685363769531}, {921.599916182458, 0.00456717610359192}, {983.039964921772, 0.00455272197723389}, {1105.91994598508, 0.000861093401908875}, {1228.79992704839, -0.000445380806922913}, {1351.6799081116899, -0.00140714645385742}, {1474.559889175, -0.00118716061115265}, {1597.4398702383, -0.000572681427001953}, {1720.31985130161, -0.0001516193151474}, {1843.19983236492, 0.00116264820098877}, {1966.0799298435402, -0.0000977516174316406}, {2211.83989197016, 0.000845879316329956}, {2457.59985409677, -0.00139184296131134}, {2703.3598162233798, 0.00172504782676697}, {2949.11977835, 0.00296229124069214}, {3194.87974047661, 0.00451868772506714}, {3440.63970260322, 0.00163309276103973}, {3686.39966472983, 0.000122785568237305}, {3932.15985968709, -0.00133922696113586}, {4423.67978394032, 0.000777900218963623}, {4915.19970819354, 0.000444963574409485}, {5406.71963244677, 0.00105953216552734}, {5898.23955669999, -0.00111252069473267}, {6389.75948095322, -0.0010116845369339}, {6881.27940520644, 0.00077192485332489}, {7372.79932945967, 0.000816851854324341}, {7864.31971937418, 0.00132499635219574}, {8847.35956788063, -7.39097595214844*^-6}, {9830.39941638708, 0.000013306736946106}, {10813.4392648935, 0.000796690583229065}, {11796.4791134, -0.000970959663391113}, {12779.5189619064, -0.000594541430473328}, {13762.5588104129, -0.00102463364601135}, {14745.5986589193, -0.000969454646110535}, {15728.639438748402, 0.000904113054275513}, {17694.719135761297, 0.000154837965965271}, {19660.7988327742, 0.00120419263839722}, {21626.8785297871, 0.000684097409248352}, {23592.9582268, 0.000383004546165466}, {25559.037923812903, 0.000595375895500183}, {27525.1176208258, 0.000576585531234741}, {29491.1973178387, -0.000521183013916016}, {31457.278877496698, -8.77678394317627*^-6}, {35389.4382715225, -0.000222831964492798}, {39321.597665548295, 0.00022965669631958}, {43253.7570595741, -0.000290796160697937}, {47185.9164535999, 0.0000298619270324707}, {51118.075847625696, 0.000433459877967834}, {55050.2352416515, 0.000723719596862793}, {58982.3946356773, 0.000618442893028259}, {62914.557754993395, 0.000126123428344727}, {70778.876543045, -0.000161916017532349}, {78643.19533109659, 0.000241100788116455}, {86507.5141191483, 0.000291869044303894}, {94371.8329071999, 0.000238820910453796}, {102236.15169525101, -0.0000153034925460815}, {110100.470483303, 0.0000214427709579468}, {117964.789271355, -0.000306516885757446}, {125829.115509987, 0.000163614749908447}, {141557.75308609, 0.0000263005495071411}, {157286.390662193, 0.00048595666885376}, {173015.028238297, 0.000243872404098511}, {188743.6658144, -0.000156030058860779}, {204472.30339050302, 0.000581830739974976}, {220200.940966606, -0.0000436604022979736}, {235929.578542709, 0.000453531742095947}, {251658.231019974, 0.0000173896551132202}, {283115.50617218, -0.000103205442428589}, {314572.781324387, 0.000194475054740906}, {346030.056476593, -0.000264883041381836}, {377487.331628799, 0.000500679016113281}, {408944.60678100603, 0.000132948160171509}, {440401.881933212, 0.0000472962856292725}, {471859.157085419, 0.000236451625823975}, {503316.462039948, -0.0003662109375}, {566231.01234436, 0.000237807631492615}, {629145.562648773, 0.0000393539667129517}, {692060.112953186, 0.0000951439142227173}, {754974.663257599, -3.65078449249268*^-6}, {817889.2135620121, -0.000460252165794373}, {880803.763866425, -0.000175118446350098}, {943718.3141708369, -0.000255554914474487}, {1.0066329240798999*^6, -0.000396981835365295}, {1.13246202468872*^6, -0.000206664204597473}, {1.2582911252975499*^6, -0.000166803598403931}, {1.38412022590637*^6, -0.000191211700439453}, {1.5099493265152*^6, -0.000151157379150391}, {1.6357784271240202*^6, -0.0000838488340377808}, {1.76160752773285*^6, 0.0000880211591720581}, {1.88743662834167*^6, 0.000111401081085205}, {2.01326584815979*^6, 0.0000975579023361206}, {2.26492404937744*^6, 0.000261127948760986}, {2.51658225059509*^6, 0.000213056802749634}, {2.76824045181274*^6, 0.0000594556331634521}, {3.0198986530304*^6, 0.0000610053539276123}, {3.27155685424805*^6, -0.00020889937877655}, {3.5232150554657*^6, 0.000122800469398499}, {3.77487325668335*^6, -0.000306591391563416}, {4.02653169631958*^6, 0.0000558942556381226}}, {"Microseconds", IndependentUnit["ArbitraryUnits"]}, {{1}, {2}}}]]}, {Quantity[16., "Milligrams"/"Milliliters"], QuantityArray[ StructuredArray`StructuredData[{168, 2}, {{{0.479999982871959, 0.956849336624146}, {0.959999965743918, 0.949244499206543}, {1.4400000054592998, 0.935654938220978}, {1.9199999314878398, 0.92704302072525}, {2.3999998575163803, 0.917282044887543}, {2.88000001091859, 0.908410608768463}, {3.35999993694713, 0.899922132492065}, {3.83999986297567, 0.892325639724731}, {4.31999978900421, 0.883568525314331}, {4.79999971503275, 0.875146746635437}, {5.2799996410612895, 0.867829561233521}, {5.7600000218371905, 0.859422922134399}, {6.23999994786573, 0.848959505558014}, {6.71999987389427, 0.843896389007568}, {7.19999979992281, 0.837296485900879}, {7.679999725951349, 0.82827365398407}, {8.63999957800843, 0.811355710029602}, {9.59999943006551, 0.793655276298523}, {10.5599992821226, 0.782122135162354}, {11.519999134179699, 0.768074929714203}, {12.4799989862368, 0.752645134925842}, {13.4399988382938, 0.737093031406403}, {14.3999986903509, 0.722545385360718}, {15.359999451902699, 0.709826946258545}, {17.2799991560169, 0.683157682418823}, {19.199998860131, 0.659659743309021}, {21.1199985642452, 0.634617269039154}, {23.0399982683593, 0.609876394271851}, {24.9599979724735, 0.586737036705017}, {26.8799976765877, 0.566200137138367}, {28.7999973807018, 0.545217454433441}, {30.719998903805397, 0.524665951728821}, {34.5599983120337, 0.488249093294144}, {38.399997720262, 0.453426480293274}, {42.2399971284904, 0.420748084783554}, {46.0799965367187, 0.392147690057755}, {49.919995944947, 0.364087104797363}, {53.7599953531753, 0.338567733764648}, {57.5999947614037, 0.314316898584366}, {61.439997807610794, 0.290943890810013}, {69.1199966240674, 0.253152698278427}, {76.7999954405241, 0.218965142965317}, {84.4799942569807, 0.190545618534088}, {92.1599930734374, 0.1656314432621}, {99.839991889894, 0.143600285053253}, {107.51999070635101, 0.12549501657486}, {115.199989522807, 0.109143078327179}, {122.879995615222, 0.0961723923683167}, {138.239993248135, 0.0745047032833099}, {153.599990881048, 0.057176798582077}, {168.959988513961, 0.0444508492946625}, {184.319986146875, 0.0345251262187958}, {199.679983779788, 0.0263491570949554}, {215.03998141270102, 0.0212303400039673}, {230.399979045615, 0.0166666209697723}, {245.759991230443, 0.0132938921451569}, {276.47998649627, 0.00671398639678955}, {307.199981762096, 0.00318850576877594}, {337.919977027923, 0.00181321799755096}, {368.639972293749, 0.000480726361274719}, {399.359967559576, -0.000223264098167419}, {430.079962825403, -0.000269487500190735}, {460.799958091229, -0.000137090682983398}, {491.519982460886, 0.000583231449127197}, {552.959972992539, 0.00128999352455139}, {614.399963524193, 0.00187331438064575}, {675.839954055846, 0.00164239108562469}, {737.279944587499, 0.00175760686397552}, {798.719935119152, 0.00264260172843933}, {860.159925650805, 0.00141343474388123}, {921.599916182458, 0.000375837087631226}, {983.039964921772, -0.000534906983375549}, {1105.91994598508, -0.00106707215309143}, {1228.79992704839, -0.00075337290763855}, {1351.6799081116899, 0.00139978528022766}, {1474.559889175, -0.000443503260612488}, {1597.4398702383, -0.00153228640556335}, {1720.31985130161, -0.000241175293922424}, {1843.19983236492, -0.0000569969415664673}, {1966.0799298435402, -0.000469490885734558}, {2211.83989197016, 0.0021674782037735}, {2457.59985409677, 0.000825628638267517}, {2703.3598162233798, 0.000972837209701538}, {2949.11977835, 0.000273600220680237}, {3194.87974047661, -0.000174596905708313}, {3440.63970260322, -0.00119826197624207}, {3686.39966472983, 0.00114619731903076}, {3932.15985968709, -0.000987499952316284}, {4423.67978394032, -0.000266969203948975}, {4915.19970819354, -0.00223027169704437}, {5406.71963244677, -0.00134190917015076}, {5898.23955669999, 0.000106349587440491}, {6389.75948095322, 0.001638263463974}, {6881.27940520644, -0.00072246789932251}, {7372.79932945967, -0.00173549354076385}, {7864.31971937418, 0.000719815492630005}, {8847.35956788063, 0.000936314463615417}, {9830.39941638708, 0.0000534802675247192}, {10813.4392648935, 0.00117972493171692}, {11796.4791134, -0.000299781560897827}, {12779.5189619064, -0.0000589042901992798}, {13762.5588104129, 0.000503718852996826}, {14745.5986589193, -0.000544950366020203}, {15728.639438748402, -0.00172528624534607}, {17694.719135761297, 0.000737696886062622}, {19660.7988327742, -0.000146806240081787}, {21626.8785297871, -0.00102883577346802}, {23592.9582268, 0.000466302037239075}, {25559.037923812903, -0.0000473558902740479}, {27525.1176208258, -0.000421971082687378}, {29491.1973178387, -0.0000785738229751587}, {31457.278877496698, -0.000470533967018127}, {35389.4382715225, 0.000246092677116394}, {39321.597665548295, 0.000505611300468445}, {43253.7570595741, -0.000534966588020325}, {47185.9164535999, -0.000480532646179199}, {51118.075847625696, -0.000191912055015564}, {55050.2352416515, -0.000275015830993652}, {58982.3946356773, 0.000297397375106812}, {62914.557754993395, 0.000372380018234253}, {70778.876543045, -0.000373989343643188}, {78643.19533109659, 0.0000190436840057373}, {86507.5141191483, -0.000306680798530579}, {94371.8329071999, 0.00015529990196228}, {102236.15169525101, 0.00015665590763092}, {110100.470483303, 0.000158011913299561}, {117964.789271355, -0.0000752061605453491}, {125829.115509987, -0.000177845358848572}, {141557.75308609, 0.000132203102111816}, {157286.390662193, 0.0000326037406921387}, {173015.028238297, -0.0000878870487213135}, {188743.6658144, -0.000367805361747742}, {204472.30339050302, -0.000397607684135437}, {220200.940966606, -0.000449046492576599}, {235929.578542709, -0.0000525712966918945}, {251658.231019974, 0.000453829765319824}, {283115.50617218, 0.000230520963668823}, {314572.781324387, 0.000130996108055115}, {346030.056476593, -0.0000367313623428345}, {377487.331628799, 0.000150203704833984}, {408944.60678100603, 0.00020211935043335}, {440401.881933212, 0.0000928938388824463}, {471859.157085419, -0.0000669211149215698}, {503316.462039948, -0.000477328896522522}, {566231.01234436, 0.0000375658273696899}, {629145.562648773, 0.0000552088022232056}, {692060.112953186, 0.0000817775726318359}, {754974.663257599, -0.0000111013650894165}, {817889.2135620121, 0.000080406665802002}, {880803.763866425, -0.000102654099464417}, {943718.3141708369, 0.000149756669998169}, {1.0066329240798999*^6, -0.000125497579574585}, {1.13246202468872*^6, -0.0000432580709457397}, {1.2582911252975499*^6, -3.63588333129883*^-6}, {1.38412022590637*^6, -0.0000724047422409058}, {1.5099493265152*^6, 0.0000437796115875244}, {1.6357784271240202*^6, -8.44895839691162*^-6}, {1.76160752773285*^6, 0.0000388771295547485}, {1.88743662834167*^6, -0.0000139474868774414}, {2.01326584815979*^6, -0.0000517368316650391}, {2.26492404937744*^6, 0.0000330060720443726}, {2.51658225059509*^6, 0.0000126659870147705}, {2.76824045181274*^6, 0.0000325590372085571}, {3.0198986530304*^6, 0.0000534355640411377}, {3.27155685424805*^6, -0.0000565052032470703}, {3.5232150554657*^6, 0.000101000070571899}, {3.77487325668335*^6, -0.000075802206993103}, {4.02653169631958*^6, -0.0000562816858291626}}, {"Microseconds", IndependentUnit["ArbitraryUnits"]}, {{1}, {2}}}]]}, {Quantity[16., "Milligrams"/"Milliliters"], QuantityArray[ StructuredArray`StructuredData[{168, 2}, {{{0.479999982871959, 0.961469292640686}, {0.959999965743918, 0.950380980968475}, {1.4400000054592998, 0.936965584754944}, {1.9199999314878398, 0.928893446922302}, {2.3999998575163803, 0.919070839881897}, {2.88000001091859, 0.907342612743378}, {3.35999993694713, 0.901294767856598}, {3.83999986297567, 0.89306104183197}, {4.31999978900421, 0.884418845176697}, {4.79999971503275, 0.877725064754486}, {5.2799996410612895, 0.866932451725006}, {5.7600000218371905, 0.856417655944824}, {6.23999994786573, 0.851726174354553}, {6.71999987389427, 0.845594763755798}, {7.19999979992281, 0.836100101470947}, {7.679999725951349, 0.828639268875122}, {8.63999957800843, 0.812671065330505}, {9.59999943006551, 0.796301484107971}, {10.5599992821226, 0.779466032981873}, {11.519999134179699, 0.763992786407471}, {12.4799989862368, 0.750810146331787}, {13.4399988382938, 0.736463189125061}, {14.3999986903509, 0.721670866012573}, {15.359999451902699, 0.708865642547607}, {17.2799991560169, 0.679464280605316}, {19.199998860131, 0.654139161109924}, {21.1199985642452, 0.629870176315308}, {23.0399982683593, 0.605180323123932}, {24.9599979724735, 0.582718014717102}, {26.8799976765877, 0.562093019485474}, {28.7999973807018, 0.540446877479553}, {30.719998903805397, 0.518848776817322}, {34.5599983120337, 0.481847077608109}, {38.399997720262, 0.446243911981583}, {42.2399971284904, 0.412552714347839}, {46.0799965367187, 0.383354961872101}, {49.919995944947, 0.355409681797028}, {53.7599953531753, 0.329929739236832}, {57.5999947614037, 0.305576294660568}, {61.439997807610794, 0.283306002616882}, {69.1199966240674, 0.243740886449814}, {76.7999954405241, 0.209985613822937}, {84.4799942569807, 0.181259244680405}, {92.1599930734374, 0.157007247209549}, {99.839991889894, 0.136118948459625}, {107.51999070635101, 0.117997705936432}, {115.199989522807, 0.102282762527466}, {122.879995615222, 0.0879314839839935}, {138.239993248135, 0.0659632384777069}, {153.599990881048, 0.0496081113815308}, {168.959988513961, 0.0383592844009399}, {184.319986146875, 0.0290390253067017}, {199.679983779788, 0.0209922790527344}, {215.03998141270102, 0.015360414981842}, {230.399979045615, 0.0118644535541534}, {245.759991230443, 0.00743398070335388}, {276.47998649627, 0.00435462594032288}, {307.199981762096, 0.00281405448913574}, {337.919977027923, -0.000724777579307556}, {368.639972293749, -0.00163190066814423}, {399.359967559576, -0.000843435525894165}, {430.079962825403, -0.000692784786224365}, {460.799958091229, -0.000266477465629578}, {491.519982460886, 0.000628069043159485}, {552.959972992539, 0.00187425315380096}, {614.399963524193, 0.00127078592777252}, {675.839954055846, 0.00131218135356903}, {737.279944587499, 0.00139552354812622}, {798.719935119152, 0.00184343755245209}, {860.159925650805, 0.00201985239982605}, {921.599916182458, 0.00149460136890411}, {983.039964921772, 0.00261075794696808}, {1105.91994598508, 0.000961974263191223}, {1228.79992704839, 0.000483617186546326}, {1351.6799081116899, 0.000920385122299194}, {1474.559889175, -0.000349193811416626}, {1597.4398702383, 0.000634744763374329}, {1720.31985130161, -0.000387877225875854}, {1843.19983236492, -0.00116638839244843}, {1966.0799298435402, -0.00403647124767303}, {2211.83989197016, -0.000346079468727112}, {2457.59985409677, -0.00380928814411163}, {2703.3598162233798, -0.00132529437541962}, {2949.11977835, 0.00153408944606781}, {3194.87974047661, 0.000080108642578125}, {3440.63970260322, -0.0000385493040084839}, {3686.39966472983, 0.000663444399833679}, {3932.15985968709, -0.000349134206771851}, {4423.67978394032, 0.000174462795257568}, {4915.19970819354, -0.00063854455947876}, {5406.71963244677, 0.00019681453704834}, {5898.23955669999, 0.00129181146621704}, {6389.75948095322, 0.000682592391967773}, {6881.27940520644, -0.000993683934211731}, {7372.79932945967, -0.000762075185775757}, {7864.31971937418, -0.000831112265586853}, {8847.35956788063, -0.000289097428321838}, {9830.39941638708, -0.000265613198280334}, {10813.4392648935, 0.000602245330810547}, {11796.4791134, 0.000961080193519592}, {12779.5189619064, 0.000781714916229248}, {13762.5588104129, -0.000540211796760559}, {14745.5986589193, 0.000258460640907288}, {15728.639438748402, -0.000359177589416504}, {17694.719135761297, -0.000124886631965637}, {19660.7988327742, -0.000182896852493286}, {21626.8785297871, 0.000752478837966919}, {23592.9582268, 0.00110456347465515}, {25559.037923812903, 0.000373303890228271}, {27525.1176208258, 0.000348955392837524}, {29491.1973178387, -0.000324070453643799}, {31457.278877496698, -0.000413775444030762}, {35389.4382715225, -0.0000983774662017822}, {39321.597665548295, 0.000300794839859009}, {43253.7570595741, 0.0000894069671630859}, {47185.9164535999, 0.0000696182250976563}, {51118.075847625696, 0.000442594289779663}, {55050.2352416515, -0.000548452138900757}, {58982.3946356773, -0.000411659479141235}, {62914.557754993395, -0.000302836298942566}, {70778.876543045, 0.000185325741767883}, {78643.19533109659, -0.0000867545604705811}, {86507.5141191483, 0.00023353099822998}, {94371.8329071999, -0.000266566872596741}, {102236.15169525101, 0.000118687748908997}, {110100.470483303, -0.0000611990690231323}, {117964.789271355, -0.0000212043523788452}, {125829.115509987, 0.0000410079956054688}, {141557.75308609, 0.000120282173156738}, {157286.390662193, 0.0000807791948318481}, {173015.028238297, 0.0000668615102767944}, {188743.6658144, 0.000171646475791931}, {204472.30339050302, 0.000011637806892395}, {220200.940966606, -8.2850456237793*^-6}, {235929.578542709, -0.0000746697187423706}, {251658.231019974, 0.0000489950180053711}, {283115.50617218, -0.0000365376472473145}, {314572.781324387, 0.0000978857278823853}, {346030.056476593, 0.000183656811714172}, {377487.331628799, -0.0000731498003005981}, {408944.60678100603, -0.000116348266601563}, {440401.881933212, 0.0000837445259094238}, {471859.157085419, -0.0000909715890884399}, {503316.462039948, -0.000108972191810608}, {566231.01234436, -0.000145420432090759}, {629145.562648773, -0.000115841627120972}, {692060.112953186, -0.000101581215858459}, {754974.663257599, -0.000208720564842224}, {817889.2135620121, 0.0000927597284317017}, {880803.763866425, -0.000322192907333374}, {943718.3141708369, -0.0000535547733306885}, {1.0066329240798999*^6, -0.0000710934400558472}, {1.13246202468872*^6, 0.0000434368848800659}, {1.2582911252975499*^6, 0.0000324100255966187}, {1.38412022590637*^6, 0.000035211443901062}, {1.5099493265152*^6, 0.0000354647636413574}, {1.6357784271240202*^6, -0.0000561922788619995}, {1.76160752773285*^6, -0.000143498182296753}, {1.88743662834167*^6, -0.0000478774309158325}, {2.01326584815979*^6, -0.0000450313091278076}, {2.26492404937744*^6, 0.0000292211771011353}, {2.51658225059509*^6, 0.0000580102205276489}, {2.76824045181274*^6, -0.0000652968883514404}, {3.0198986530304*^6, -0.0000840574502944946}, {3.27155685424805*^6, 0.0000445544719696045}, {3.5232150554657*^6, 3.05473804473877*^-6}, {3.77487325668335*^6, 0.000358819961547852}, {4.02653169631958*^6, -0.0000329464673995972}}, {"Microseconds", IndependentUnit["ArbitraryUnits"]}, {{1}, {2}}}]]}, {Quantity[8., "Milligrams"/"Milliliters"], QuantityArray[ StructuredArray`StructuredData[{168, 2}, {{{0.479999982871959, 0.971859335899353}, {0.959999965743918, 0.963433623313904}, {1.4400000054592998, 0.947962045669556}, {1.9199999314878398, 0.935236632823944}, {2.3999998575163803, 0.923912584781647}, {2.88000001091859, 0.912299156188965}, {3.35999993694713, 0.906320810317993}, {3.83999986297567, 0.901432454586029}, {4.31999978900421, 0.891325891017914}, {4.79999971503275, 0.879885315895081}, {5.2799996410612895, 0.880151867866516}, {5.7600000218371905, 0.864127099514008}, {6.23999994786573, 0.854770302772522}, {6.71999987389427, 0.847834944725037}, {7.19999979992281, 0.836483478546143}, {7.679999725951349, 0.829279541969299}, {8.63999957800843, 0.815731346607208}, {9.59999943006551, 0.798863768577576}, {10.5599992821226, 0.784361720085144}, {11.519999134179699, 0.767624378204346}, {12.4799989862368, 0.755857706069946}, {13.4399988382938, 0.738914310932159}, {14.3999986903509, 0.7244633436203}, {15.359999451902699, 0.709417998790741}, {17.2799991560169, 0.680280864238739}, {19.199998860131, 0.655278325080872}, {21.1199985642452, 0.627147197723389}, {23.0399982683593, 0.603913426399231}, {24.9599979724735, 0.58361804485321}, {26.8799976765877, 0.559178173542023}, {28.7999973807018, 0.540141224861145}, {30.719998903805397, 0.518923163414001}, {34.5599983120337, 0.479780286550522}, {38.399997720262, 0.442569047212601}, {42.2399971284904, 0.411028802394867}, {46.0799965367187, 0.381969094276428}, {49.919995944947, 0.35382154583931}, {53.7599953531753, 0.327890515327454}, {57.5999947614037, 0.304626941680908}, {61.439997807610794, 0.281936466693878}, {69.1199966240674, 0.243089348077774}, {76.7999954405241, 0.210537731647491}, {84.4799942569807, 0.182085961103439}, {92.1599930734374, 0.158201336860657}, {99.839991889894, 0.13609391450882}, {107.51999070635101, 0.11768302321434}, {115.199989522807, 0.102626174688339}, {122.879995615222, 0.0893617868423462}, {138.239993248135, 0.0675200223922729}, {153.599990881048, 0.0517863631248474}, {168.959988513961, 0.0397141575813293}, {184.319986146875, 0.0314880609512329}, {199.679983779788, 0.0250376164913177}, {215.03998141270102, 0.0214023292064667}, {230.399979045615, 0.017523854970932}, {245.759991230443, 0.0143651962280273}, {276.47998649627, 0.00875476002693176}, {307.199981762096, 0.00595137476921082}, {337.919977027923, 0.0036952793598175}, {368.639972293749, 0.00195051729679108}, {399.359967559576, 0.00187785923480988}, {430.079962825403, 0.00128833949565887}, {460.799958091229, 0.00181497633457184}, {491.519982460886, 0.000968188047409058}, {552.959972992539, 0.0000192075967788696}, {614.399963524193, -0.00109091401100159}, {675.839954055846, 0.000843703746795654}, {737.279944587499, 0.000824317336082458}, {798.719935119152, 0.00127536058425903}, {860.159925650805, 0.000763341784477234}, {921.599916182458, 0.00199410319328308}, {983.039964921772, -0.000160336494445801}, {1105.91994598508, 0.00161592662334442}, {1228.79992704839, -0.00106821954250336}, {1351.6799081116899, -0.0000451058149337769}, {1474.559889175, 0.00171470642089844}, {1597.4398702383, 0.000445947051048279}, {1720.31985130161, 0.00201244652271271}, {1843.19983236492, 0.00122128427028656}, {1966.0799298435402, -0.000732094049453735}, {2211.83989197016, -0.000768676400184631}, {2457.59985409677, 0.000995919108390808}, {2703.3598162233798, -0.00181184709072113}, {2949.11977835, -0.000933781266212463}, {3194.87974047661, 0.000774413347244263}, {3440.63970260322, 0.000919491052627563}, {3686.39966472983, 0.00232574343681335}, {3932.15985968709, 0.000186100602149963}, {4423.67978394032, 0.0000189840793609619}, {4915.19970819354, 0.000879108905792236}, {5406.71963244677, -0.000756755471229553}, {5898.23955669999, -0.000301048159599304}, {6389.75948095322, -0.000501647591590881}, {6881.27940520644, 0.000724658370018005}, {7372.79932945967, -0.000501200556755066}, {7864.31971937418, 0.000727877020835876}, {8847.35956788063, -0.000167027115821838}, {9830.39941638708, 0.00115418434143066}, {10813.4392648935, 0.000181645154953003}, {11796.4791134, -0.000162422657012939}, {12779.5189619064, 0.00101202726364136}, {13762.5588104129, 0.000289455056190491}, {14745.5986589193, 0.000559061765670776}, {15728.639438748402, -0.00107012689113617}, {17694.719135761297, -0.000920876860618591}, {19660.7988327742, -0.000421985983848572}, {21626.8785297871, 0.000667095184326172}, {23592.9582268, -0.000641345977783203}, {25559.037923812903, 0.000502288341522217}, {27525.1176208258, -0.000281646847724915}, {29491.1973178387, 0.000684678554534912}, {31457.278877496698, 0.000746771693229675}, {35389.4382715225, 0.000654488801956177}, {39321.597665548295, -0.000274315476417542}, {43253.7570595741, 0.00101974606513977}, {47185.9164535999, -0.000199273228645325}, {51118.075847625696, 0.000717639923095703}, {55050.2352416515, -0.000363722443580627}, {58982.3946356773, 0.000614941120147705}, {62914.557754993395, -0.000517651438713074}, {70778.876543045, -0.000145748257637024}, {78643.19533109659, -0.000127404928207397}, {86507.5141191483, 0.000101014971733093}, {94371.8329071999, 0.000103235244750977}, {102236.15169525101, 0.000217974185943604}, {110100.470483303, -0.000427663326263428}, {117964.789271355, -0.000214189291000366}, {125829.115509987, -0.000138357281684875}, {141557.75308609, 0.000406667590141296}, {157286.390662193, 0.000201582908630371}, {173015.028238297, 0.0000691860914230347}, {188743.6658144, 0.000235006213188171}, {204472.30339050302, 0.0000112801790237427}, {220200.940966606, -0.0000330656766891479}, {235929.578542709, 0.000119805335998535}, {251658.231019974, -0.0000229179859161377}, {283115.50617218, -0.000109255313873291}, {314572.781324387, 0.0000449419021606445}, {346030.056476593, 0.000456482172012329}, {377487.331628799, 0.0000649988651275635}, {408944.60678100603, -0.000211283564567566}, {440401.881933212, 0.000146135687828064}, {471859.157085419, 0.000132501125335693}, {503316.462039948, 0.000229895114898682}, {566231.01234436, 0.000037848949432373}, {629145.562648773, 0.0000931322574615479}, {692060.112953186, 0.000047147274017334}, {754974.663257599, 0.0000859051942825317}, {817889.2135620121, 0.000122189521789551}, {880803.763866425, -0.00017876923084259}, {943718.3141708369, -0.0000319182872772217}, {1.0066329240798999*^6, -0.000104546546936035}, {1.13246202468872*^6, -0.0000434815883636475}, {1.2582911252975499*^6, 0.000063285231590271}, {1.38412022590637*^6, 0.000023961067199707}, {1.5099493265152*^6, 0.000066801905632019}, {1.6357784271240202*^6, 0.0000389367341995239}, {1.76160752773285*^6, 0.0000852048397064209}, {1.88743662834167*^6, -0.000156283378601074}, {2.01326584815979*^6, 0.00014197826385498}, {2.26492404937744*^6, 0.0000261813402175903}, {2.51658225059509*^6, -0.000137627124786377}, {2.76824045181274*^6, -0.0000132918357849121}, {3.0198986530304*^6, -0.0000799000263214111}, {3.27155685424805*^6, 0.0000206232070922852}, {3.5232150554657*^6, -0.0000676512718200684}, {3.77487325668335*^6, 0.0000203996896743774}, {4.02653169631958*^6, 0.000109657645225525}}, {"Microseconds", IndependentUnit["ArbitraryUnits"]}, {{1}, {2}}}]]}, {Quantity[8., "Milligrams"/"Milliliters"], QuantityArray[ StructuredArray`StructuredData[{168, 2}, {{{0.479999982871959, 0.9612637758255}, {0.959999965743918, 0.947810649871826}, {1.4400000054592998, 0.936070144176483}, {1.9199999314878398, 0.925892949104309}, {2.3999998575163803, 0.918821573257446}, {2.88000001091859, 0.905084252357483}, {3.35999993694713, 0.897740602493286}, {3.83999986297567, 0.88686192035675}, {4.31999978900421, 0.877349734306335}, {4.79999971503275, 0.872014403343201}, {5.2799996410612895, 0.860237002372742}, {5.7600000218371905, 0.844976425170898}, {6.23999994786573, 0.841492891311646}, {6.71999987389427, 0.833018839359283}, {7.19999979992281, 0.824440836906433}, {7.679999725951349, 0.814581394195557}, {8.63999957800843, 0.800369143486023}, {9.59999943006551, 0.783852577209473}, {10.5599992821226, 0.764877259731293}, {11.519999134179699, 0.749407291412354}, {12.4799989862368, 0.731134951114655}, {13.4399988382938, 0.718945384025574}, {14.3999986903509, 0.704500317573547}, {15.359999451902699, 0.688922882080078}, {17.2799991560169, 0.661846280097961}, {19.199998860131, 0.63260680437088}, {21.1199985642452, 0.610090494155884}, {23.0399982683593, 0.584369003772736}, {24.9599979724735, 0.560758352279663}, {26.8799976765877, 0.535340070724487}, {28.7999973807018, 0.51465779542923}, {30.719998903805397, 0.496175736188889}, {34.5599983120337, 0.454811155796051}, {38.399997720262, 0.421407729387283}, {42.2399971284904, 0.3880415558815}, {46.0799965367187, 0.358517825603485}, {49.919995944947, 0.331413328647614}, {53.7599953531753, 0.304898828268051}, {57.5999947614037, 0.283257097005844}, {61.439997807610794, 0.259619295597076}, {69.1199966240674, 0.222895711660385}, {76.7999954405241, 0.191634476184845}, {84.4799942569807, 0.164151847362518}, {92.1599930734374, 0.142758846282959}, {99.839991889894, 0.1224225461483}, {107.51999070635101, 0.105050683021545}, {115.199989522807, 0.0915846228599548}, {122.879995615222, 0.0786494612693787}, {138.239993248135, 0.0591372549533844}, {153.599990881048, 0.0436643660068512}, {168.959988513961, 0.0316579937934875}, {184.319986146875, 0.0241795480251312}, {199.679983779788, 0.0188369154930115}, {215.03998141270102, 0.0132710039615631}, {230.399979045615, 0.0108469724655151}, {245.759991230443, 0.00780531764030457}, {276.47998649627, 0.00497749447822571}, {307.199981762096, 0.00465327501296997}, {337.919977027923, 0.00320330262184143}, {368.639972293749, 0.00226801633834839}, {399.359967559576, 0.00232592225074768}, {430.079962825403, 0.00112350285053253}, {460.799958091229, 0.000637799501419067}, {491.519982460886, 0.000494092702865601}, {552.959972992539, 0.000925347208976746}, {614.399963524193, 0.000530228018760681}, {675.839954055846, 0.0025191605091095}, {737.279944587499, 0.00289008021354675}, {798.719935119152, 0.00292742252349854}, {860.159925650805, 0.00224637985229492}, {921.599916182458, 0.00073164701461792}, {983.039964921772, 0.00141474604606628}, {1105.91994598508, -0.00126585364341736}, {1228.79992704839, 0.000770583748817444}, {1351.6799081116899, 0.000909104943275452}, {1474.559889175, 0.000894546508789063}, {1597.4398702383, -0.000178873538970947}, {1720.31985130161, -0.00193087756633759}, {1843.19983236492, -0.00191208720207214}, {1966.0799298435402, -0.00205180048942566}, {2211.83989197016, -0.000143811106681824}, {2457.59985409677, -0.0000577718019485474}, {2703.3598162233798, 0.000773206353187561}, {2949.11977835, -0.0012647956609726}, {3194.87974047661, 0.00100746750831604}, {3440.63970260322, 0.00015576183795929}, {3686.39966472983, -0.000929579138755798}, {3932.15985968709, -0.00116576254367828}, {4423.67978394032, 0.00129008293151855}, {4915.19970819354, -7.88271427154541*^-6}, {5406.71963244677, -0.00121180713176727}, {5898.23955669999, -0.0000272542238235474}, {6389.75948095322, -0.0000515729188919067}, {6881.27940520644, 0.0000532716512680054}, {7372.79932945967, 0.00108902156352997}, {7864.31971937418, 0.00223267078399658}, {8847.35956788063, 0.000197052955627441}, {9830.39941638708, 0.000128179788589478}, {10813.4392648935, -0.000424668192863464}, {11796.4791134, 0.000193923711776733}, {12779.5189619064, -0.000842288136482239}, {13762.5588104129, 0.00148427486419678}, {14745.5986589193, 0.0000276416540145874}, {15728.639438748402, -0.000255078077316284}, {17694.719135761297, 0.000352770090103149}, {19660.7988327742, 0.000650361180305481}, {21626.8785297871, 0.000691324472427368}, {23592.9582268, 0.000153005123138428}, {25559.037923812903, -0.000251516699790955}, {27525.1176208258, 0.000431656837463379}, {29491.1973178387, 0.0000373423099517822}, {31457.278877496698, 0.000487208366394043}, {35389.4382715225, -0.000638514757156372}, {39321.597665548295, 9.71555709838867*^-6}, {43253.7570595741, -0.000259518623352051}, {47185.9164535999, -0.000169098377227783}, {51118.075847625696, 0.0000457465648651123}, {55050.2352416515, -0.000796690583229065}, {58982.3946356773, 0.000683009624481201}, {62914.557754993395, -0.0000236034393310547}, {70778.876543045, 0.000402912497520447}, {78643.19533109659, 0.000260248780250549}, {86507.5141191483, 0.000217124819755554}, {94371.8329071999, -0.000120311975479126}, {102236.15169525101, 0.000183448195457458}, {110100.470483303, 0.0000431537628173828}, {117964.789271355, -0.000200048089027405}, {125829.115509987, 0.000375345349311829}, {141557.75308609, 0.0000486820936203003}, {157286.390662193, -0.0000531673431396484}, {173015.028238297, 0.000493258237838745}, {188743.6658144, 0.0000153332948684692}, {204472.30339050302, 0.000207751989364624}, {220200.940966606, 0.0000257939100265503}, {235929.578542709, -0.000110343098640442}, {251658.231019974, 0.000184923410415649}, {283115.50617218, 0.000399798154830933}, {314572.781324387, -0.0000338852405548096}, {346030.056476593, 0.000151202082633972}, {377487.331628799, 8.44895839691162*^-6}, {408944.60678100603, 0.000291436910629272}, {440401.881933212, 0.000311821699142456}, {471859.157085419, 0.000161468982696533}, {503316.462039948, 0.0000157356262207031}, {566231.01234436, 0.000176712870597839}, {629145.562648773, 0.000251665711402893}, {692060.112953186, -0.0000725388526916504}, {754974.663257599, 0.0000891834497451782}, {817889.2135620121, 0.0000251829624176025}, {880803.763866425, 0.000142291188240051}, {943718.3141708369, 0.0000803768634796143}, {1.0066329240798999*^6, 0.000124275684356689}, {1.13246202468872*^6, 0.0000806599855422974}, {1.2582911252975499*^6, 2.23517417907715*^-6}, {1.38412022590637*^6, 0.0000512748956680298}, {1.5099493265152*^6, 0.00011909008026123}, {1.6357784271240202*^6, 0.0000151544809341431}, {1.76160752773285*^6, -0.000123798847198486}, {1.88743662834167*^6, -0.000087440013885498}, {2.01326584815979*^6, -0.0000104755163192749}, {2.26492404937744*^6, 0.0000548958778381348}, {2.51658225059509*^6, -0.0000250637531280518}, {2.76824045181274*^6, -0.000086173415184021}, {3.0198986530304*^6, -0.0000785738229751587}, {3.27155685424805*^6, -0.000115931034088135}, {3.5232150554657*^6, 0.000104933977127075}, {3.77487325668335*^6, 0.0000310242176055908}, {4.02653169631958*^6, -0.000208988785743713}}, {"Microseconds", IndependentUnit["ArbitraryUnits"]}, {{1}, {2}}}]]}, {Quantity[8., "Milligrams"/"Milliliters"], QuantityArray[ StructuredArray`StructuredData[{168, 2}, {{{0.479999982871959, 0.920494019985199}, {0.959999965743918, 0.908521473407745}, {1.4400000054592998, 0.898568034172058}, {1.9199999314878398, 0.88580733537674}, {2.3999998575163803, 0.876975297927856}, {2.88000001091859, 0.867556929588318}, {3.35999993694713, 0.857933223247528}, {3.83999986297567, 0.851624727249146}, {4.31999978900421, 0.84083092212677}, {4.79999971503275, 0.830270767211914}, {5.2799996410612895, 0.82043993473053}, {5.7600000218371905, 0.815010190010071}, {6.23999994786573, 0.807471752166748}, {6.71999987389427, 0.794929146766663}, {7.19999979992281, 0.784909129142761}, {7.679999725951349, 0.780136466026306}, {8.63999957800843, 0.761734366416931}, {9.59999943006551, 0.745776534080505}, {10.5599992821226, 0.730651617050171}, {11.519999134179699, 0.713495850563049}, {12.4799989862368, 0.699464917182922}, {13.4399988382938, 0.685283184051514}, {14.3999986903509, 0.670467853546143}, {15.359999451902699, 0.656666576862335}, {17.2799991560169, 0.628736197948456}, {19.199998860131, 0.603482842445374}, {21.1199985642452, 0.578781306743622}, {23.0399982683593, 0.554596304893494}, {24.9599979724735, 0.531440615653992}, {26.8799976765877, 0.511080026626587}, {28.7999973807018, 0.489028751850128}, {30.719998903805397, 0.469908773899078}, {34.5599983120337, 0.431933045387268}, {38.399997720262, 0.397599697113037}, {42.2399971284904, 0.366117775440216}, {46.0799965367187, 0.337988525629044}, {49.919995944947, 0.311454683542252}, {53.7599953531753, 0.287191033363342}, {57.5999947614037, 0.264481335878372}, {61.439997807610794, 0.243467837572098}, {69.1199966240674, 0.208618193864822}, {76.7999954405241, 0.178069680929184}, {84.4799942569807, 0.152123928070068}, {92.1599930734374, 0.130204826593399}, {99.839991889894, 0.111562609672546}, {107.51999070635101, 0.0953716337680817}, {115.199989522807, 0.0819168388843536}, {122.879995615222, 0.0700129866600037}, {138.239993248135, 0.05288165807724}, {153.599990881048, 0.0388581156730652}, {168.959988513961, 0.0289963483810425}, {184.319986146875, 0.0216496586799622}, {199.679983779788, 0.0161262452602386}, {215.03998141270102, 0.0118488371372223}, {230.399979045615, 0.00955185294151306}, {245.759991230443, 0.00818464159965515}, {276.47998649627, 0.00547882914543152}, {307.199981762096, 0.0027671754360199}, {337.919977027923, 0.000835031270980835}, {368.639972293749, -0.000643223524093628}, {399.359967559576, -0.000446140766143799}, {430.079962825403, -0.000870347023010254}, {460.799958091229, -0.0010463148355484}, {491.519982460886, -0.00135418772697449}, {552.959972992539, -0.000525474548339844}, {614.399963524193, -0.00231605768203735}, {675.839954055846, -0.000139698386192322}, {737.279944587499, -0.000471487641334534}, {798.719935119152, -0.000403031706809998}, {860.159925650805, -0.000201255083084106}, {921.599916182458, -0.00141255557537079}, {983.039964921772, -0.00126227736473083}, {1105.91994598508, -0.000189512968063354}, {1228.79992704839, -0.000610187649726868}, {1351.6799081116899, 0.00037732720375061}, {1474.559889175, 0.000166922807693481}, {1597.4398702383, 0.000406622886657715}, {1720.31985130161, -0.00162006914615631}, {1843.19983236492, -0.00136074423789978}, {1966.0799298435402, 0.00115972757339478}, {2211.83989197016, -0.00124818086624146}, {2457.59985409677, -0.000476956367492676}, {2703.3598162233798, -0.0012907087802887}, {2949.11977835, 0.00157290697097778}, {3194.87974047661, -0.0000957995653152466}, {3440.63970260322, 0.000762492418289185}, {3686.39966472983, 0.000820815563201904}, {3932.15985968709, 0.000808030366897583}, {4423.67978394032, -0.0000309199094772339}, {4915.19970819354, -0.000800713896751404}, {5406.71963244677, 0.000471770763397217}, {5898.23955669999, 0.000290632247924805}, {6389.75948095322, -0.000578612089157104}, {6881.27940520644, 0.000210210680961609}, {7372.79932945967, 0.000882148742675781}, {7864.31971937418, 0.000716343522071838}, {8847.35956788063, 0.0000849366188049316}, {9830.39941638708, 0.0000357478857040405}, {10813.4392648935, -0.000231727957725525}, {11796.4791134, -0.00098024308681488}, {12779.5189619064, -0.000763028860092163}, {13762.5588104129, -0.000660717487335205}, {14745.5986589193, 0.000163495540618896}, {15728.639438748402, -0.000147908926010132}, {17694.719135761297, -0.000496253371238708}, {19660.7988327742, 0.000226631760597229}, {21626.8785297871, 0.000451967120170593}, {23592.9582268, -0.000156760215759277}, {25559.037923812903, 0.0000968575477600098}, {27525.1176208258, -0.000209242105484009}, {29491.1973178387, -0.0000418275594711304}, {31457.278877496698, -0.000122800469398499}, {35389.4382715225, 0.000156611204147339}, {39321.597665548295, -0.000160962343215942}, {43253.7570595741, -0.000230088829994202}, {47185.9164535999, -0.000212252140045166}, {51118.075847625696, 0.0000301450490951538}, {55050.2352416515, -0.000278696417808533}, {58982.3946356773, 0.0000569969415664673}, {62914.557754993395, -0.0000643730163574219}, {70778.876543045, 0.000115334987640381}, {78643.19533109659, -0.0000565499067306519}, {86507.5141191483, 0.00016060471534729}, {94371.8329071999, -0.000245139002799988}, {102236.15169525101, -0.000234320759773254}, {110100.470483303, 0.0000830888748168945}, {117964.789271355, 0.0003461092710495}, {125829.115509987, 0.000172674655914307}, {141557.75308609, -0.0000632256269454956}, {157286.390662193, 0.000256136059761047}, {173015.028238297, -0.000212147831916809}, {188743.6658144, 0.0000481009483337402}, {204472.30339050302, -0.0000834465026855469}, {220200.940966606, -0.000250726938247681}, {235929.578542709, -0.000060155987739563}, {251658.231019974, 0.000116497278213501}, {283115.50617218, 2.44379043579102*^-6}, {314572.781324387, 0.000136151909828186}, {346030.056476593, -0.000153064727783203}, {377487.331628799, 0.0000406056642532349}, {408944.60678100603, 0.0000334829092025757}, {440401.881933212, -0.0000634938478469849}, {471859.157085419, -0.0000294744968414307}, {503316.462039948, -0.0000915974378585815}, {566231.01234436, -0.0000486522912979126}, {629145.562648773, -0.0000781118869781494}, {692060.112953186, -0.000126481056213379}, {754974.663257599, -0.000160098075866699}, {817889.2135620121, -0.0000625252723693848}, {880803.763866425, 0.0000946670770645142}, {943718.3141708369, -0.000150784850120544}, {1.0066329240798999*^6, 0.0000820457935333252}, {1.13246202468872*^6, 0.0000570714473724365}, {1.2582911252975499*^6, -0.0000369250774383545}, {1.38412022590637*^6, 6.33299350738525*^-6}, {1.5099493265152*^6, 0.0000577270984649658}, {1.6357784271240202*^6, -0.0000476241111755371}, {1.76160752773285*^6, -0.000013887882232666}, {1.88743662834167*^6, 0.000178694725036621}, {2.01326584815979*^6, 0.0000747591257095337}, {2.26492404937744*^6, -0.0000954270362854004}, {2.51658225059509*^6, -0.0000619441270828247}, {2.76824045181274*^6, -5.27501106262207*^-6}, {3.0198986530304*^6, 0.000058978796005249}, {3.27155685424805*^6, -1.9371509552002*^-7}, {3.5232150554657*^6, -0.000085785984992981}, {3.77487325668335*^6, 3.72529029846191*^-7}, {4.02653169631958*^6, -0.0000160783529281616}}, {"Microseconds", IndependentUnit["ArbitraryUnits"]}, {{1}, {2}}}]]}, {Quantity[0, "Milligrams"/"Milliliters"], QuantityArray[ StructuredArray`StructuredData[{168, 2}, {{{0.479999982871959, 0.0236041396856308}, {0.959999965743918, 0.00930386781692505}, {1.4400000054592998, -0.00742107629776001}, {1.9199999314878398, 0.00967361032962799}, {2.3999998575163803, 0.00676380097866058}, {2.88000001091859, 0.0038972944021225}, {3.35999993694713, -0.0150738805532455}, {3.83999986297567, -0.0152075737714767}, {4.31999978900421, 0.0017935037612915}, {4.79999971503275, 0.020721510052681}, {5.2799996410612895, 0.0111311376094818}, {5.7600000218371905, 0.0124770402908325}, {6.23999994786573, -0.000943362712860107}, {6.71999987389427, 0.000882536172866821}, {7.19999979992281, 0.00098264217376709}, {7.679999725951349, 0.0436160564422607}, {8.63999957800843, 0.0259893834590912}, {9.59999943006551, 0.00880283117294312}, {10.5599992821226, 0.00770767033100128}, {11.519999134179699, -0.00888285040855408}, {12.4799989862368, 0.00203704833984375}, {13.4399988382938, -0.00131677091121674}, {14.3999986903509, 0.00784562528133392}, {15.359999451902699, -0.0057891309261322}, {17.2799991560169, 0.00705362856388092}, {19.199998860131, 0.00208823382854462}, {21.1199985642452, -0.0028826892375946}, {23.0399982683593, 0.0149926990270615}, {24.9599979724735, 0.0085090845823288}, {26.8799976765877, -0.00387701392173767}, {28.7999973807018, -0.00610154867172241}, {30.719998903805397, 0.00630494952201843}, {34.5599983120337, -0.013465479016304}, {38.399997720262, 0.00442464649677277}, {42.2399971284904, 0.00261116027832031}, {46.0799965367187, -0.00790348649024963}, {49.919995944947, 0.00132773816585541}, {53.7599953531753, 0.00251629948616028}, {57.5999947614037, -0.0118376314640045}, {61.439997807610794, 0.00520573556423187}, {69.1199966240674, -0.00438511371612549}, {76.7999954405241, 0.00833845138549805}, {84.4799942569807, 0.00882577896118164}, {92.1599930734374, -0.00411567091941833}, {99.839991889894, -0.00279831886291504}, {107.51999070635101, 0.00123129785060883}, {115.199989522807, 0.00828295946121216}, {122.879995615222, -0.00448702275753021}, {138.239993248135, 0.000871792435646057}, {153.599990881048, 0.000700652599334717}, {168.959988513961, -0.00106094777584076}, {184.319986146875, -0.00111222267150879}, {199.679983779788, 0.0040857344865799}, {215.03998141270102, -0.00175036489963531}, {230.399979045615, 0.00461933016777039}, {245.759991230443, 0.00168988108634949}, {276.47998649627, 0.00474521517753601}, {307.199981762096, 0.00142043828964233}, {337.919977027923, 0.00257635116577148}, {368.639972293749, -0.00029522180557251}, {399.359967559576, 0.00203855335712433}, {430.079962825403, -0.00319646298885345}, {460.799958091229, 0.00140906870365143}, {491.519982460886, -0.001055046916008}, {552.959972992539, 0.000387266278266907}, {614.399963524193, -0.00210918486118317}, {675.839954055846, 0.00137138366699219}, {737.279944587499, 0.0010884553194046}, {798.719935119152, -0.00173060595989227}, {860.159925650805, 0.00407956540584564}, {921.599916182458, -0.00162547826766968}, {983.039964921772, -0.000995472073554993}, {1105.91994598508, 0.000144883990287781}, {1228.79992704839, 0.0000388622283935547}, {1351.6799081116899, -0.000269472599029541}, {1474.559889175, -0.000855699181556702}, {1597.4398702383, -0.00106458365917206}, {1720.31985130161, -0.000776499509811401}, {1843.19983236492, -0.000734448432922363}, {1966.0799298435402, 0.00168982148170471}, {2211.83989197016, 0.000219464302062988}, {2457.59985409677, 0.000636681914329529}, {2703.3598162233798, -0.00101816654205322}, {2949.11977835, -0.000336617231369019}, {3194.87974047661, 0.00141817331314087}, {3440.63970260322, 0.000319898128509521}, {3686.39966472983, -0.000351577997207642}, {3932.15985968709, -0.000949069857597351}, {4423.67978394032, 0.000601515173912048}, {4915.19970819354, 0.0000975131988525391}, {5406.71963244677, 0.00072169303894043}, {5898.23955669999, -0.000351443886756897}, {6389.75948095322, -0.000122800469398499}, {6881.27940520644, 0.000991880893707275}, {7372.79932945967, 0.000259831547737122}, {7864.31971937418, -0.00125563144683838}, {8847.35956788063, -0.0000385046005249023}, {9830.39941638708, 0.000752568244934082}, {10813.4392648935, 0.000320732593536377}, {11796.4791134, 0.0000324398279190063}, {12779.5189619064, 0.000293061137199402}, {13762.5588104129, 0.000264540314674377}, {14745.5986589193, -0.0000586509704589844}, {15728.639438748402, 0.0000258386135101318}, {17694.719135761297, 0.000441581010818481}, {19660.7988327742, 0.0000885277986526489}, {21626.8785297871, 0.0000821948051452637}, {23592.9582268, 0.000428542494773865}, {25559.037923812903, 0.000419408082962036}, {27525.1176208258, 0.000468850135803223}, {29491.1973178387, -0.0000104606151580811}, {31457.278877496698, -0.000465735793113708}, {35389.4382715225, 0.0000546574592590332}, {39321.597665548295, 8.79168510437012*^-6}, {43253.7570595741, 0.00011618435382843}, {47185.9164535999, 0.0000763386487960815}, {51118.075847625696, 0.000139385461807251}, {55050.2352416515, 0.000211700797080994}, {58982.3946356773, -0.000154450535774231}, {62914.557754993395, 0.00030180811882019}, {70778.876543045, 0.0000103265047073364}, {78643.19533109659, 0.000105291604995728}, {86507.5141191483, 0.000316858291625977}, {94371.8329071999, 0.0000252127647399902}, {102236.15169525101, -0.000064551830291748}, {110100.470483303, 0.0000860542058944702}, {117964.789271355, -0.0000633001327514648}, {125829.115509987, 0.000369638204574585}, {141557.75308609, 0.000230073928833008}, {157286.390662193, 0.000297009944915771}, {173015.028238297, 0.000167056918144226}, {188743.6658144, 0.0000275373458862305}, {204472.30339050302, 0.0000599324703216553}, {220200.940966606, 0.000264942646026611}, {235929.578542709, 0.000134497880935669}, {251658.231019974, 0.000195920467376709}, {283115.50617218, -0.0000151544809341431}, {314572.781324387, 0.000137895345687866}, {346030.056476593, 0.000134065747261047}, {377487.331628799, 0.0000874102115631104}, {408944.60678100603, 0.0000160783529281616}, {440401.881933212, 0.000174015760421753}, {471859.157085419, 0.00011172890663147}, {503316.462039948, 0.000064462423324585}, {566231.01234436, 0.000024944543838501}, {629145.562648773, 0.0001564621925354}, {692060.112953186, 7.25686550140381*^-6}, {754974.663257599, -2.23517417907715*^-6}, {817889.2135620121, 0.0000605583190917969}, {880803.763866425, -9.89437103271484*^-6}, {943718.3141708369, 1.69873237609863*^-6}, {1.0066329240798999*^6, 0.0000311881303787231}, {1.13246202468872*^6, -7.89761543273926*^-6}, {1.2582911252975499*^6, 0.0000640153884887695}, {1.38412022590637*^6, -0.0000290274620056152}, {1.5099493265152*^6, -0.0000544339418411255}, {1.6357784271240202*^6, 8.82148742675781*^-6}, {1.76160752773285*^6, -9.40263271331787*^-6}, {1.88743662834167*^6, 0.00012989342212677}, {2.01326584815979*^6, -0.0000312924385070801}, {2.26492404937744*^6, 0.0000494867563247681}, {2.51658225059509*^6, -0.000017121434211731}, {2.76824045181274*^6, -0.0000372380018234253}, {3.0198986530304*^6, -0.0000523775815963745}, {3.27155685424805*^6, 0.0000569671392440796}, {3.5232150554657*^6, 0.0000438988208770752}, {3.77487325668335*^6, -0.000034525990486145}, {4.02653169631958*^6, -0.0000217854976654053}}, {"Microseconds", IndependentUnit["ArbitraryUnits"]}, {{1}, {2}}}]]}};

		colloidRawDataFiles = {Lookup[ Association[ FileName -> "_xnl_v5j_k6_mn7z - Copy.uni-2020-09-25T11-21-08", FileType -> "xlsx", CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard15/4fef172087b65d743307b1011e6f97d6.xlsx", "Z1lqpMl64OdVuqK8Pj7jRXJ7F5L7lp4mzwYW"], Object -> Object[EmeraldCloudFile, "id:54n6evnE7qzY"], ID -> "id:54n6evnE7qzY", Type -> Object[EmeraldCloudFile]], Object], Lookup[Association[FileName -> "_xnl_v5j_k6_mn7z - Copy.uni-2020-09-25T11-21-20", FileType -> "xlsx", CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard10/36fe8af2c8f01b5ba9b699afd8e19e59.xlsx", "E8zoYvzkmw3LI6EZXw3wdpBrCANn3vRWbro3"], Object -> Object[EmeraldCloudFile, "id:n0k9mGkAJjq4"], ID -> "id:n0k9mGkAJjq4", Type -> Object[EmeraldCloudFile]], Object], Lookup[Association[ FileName -> "_xnl_v5j_k6_mn7z.uni-2020-09-25T11-14-10", FileType -> "xlsx", CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard13/6a477bef8d2a2a66491c5e82a3ad7973.xlsx", "8qZ1VWZM7GjjHXEmJvwvA8oxsWbNaeOndlGW"], Object -> Object[EmeraldCloudFile, "id:01G6nvG7Wedd"], ID -> "id:01G6nvG7Wedd", Type -> Object[EmeraldCloudFile]], Object], Lookup[Association[ FileName -> "_xnl_v5j_k6_mn7z.uni-2020-09-25T11-14-39", FileType -> "xlsx", CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard1/8e464b4c92f11237f3f9a787290ab506.xlsx", "vXl9j5lYmepvuK9PekxkO6ZBC5qxvR9PjAXO"], Object -> Object[EmeraldCloudFile, "id:1ZA60vArWpJM"], ID -> "id:1ZA60vArWpJM", Type -> Object[EmeraldCloudFile]], Object]};

		colloidProtocol = Link[Object[Protocol, DynamicLightScattering, "id:XnlV5jK6Mn7z"], Data, "R8e1Pj8JDroK"];

		colloidProtocolData = {Link[ Object[Data, DynamicLightScattering, "id:P5ZnEjd39MWR"], Protocol, "eGakldGN18pe"]};

		colloidZaverageDiameters = {{Quantity[40, "Milligrams"/"Milliliters"], Quantity[19.76, "Nanometers"]}, {Quantity[40, "Milligrams"/"Milliliters"], Quantity[19.38, "Nanometers"]}, {Quantity[40, "Milligrams"/"Milliliters"], Quantity[19.34, "Nanometers"]}, {Quantity[32., "Milligrams"/"Milliliters"], Quantity[18.47, "Nanometers"]}, {Quantity[32., "Milligrams"/"Milliliters"], Quantity[18.04, "Nanometers"]}, {Quantity[32., "Milligrams"/"Milliliters"], Quantity[18.19, "Nanometers"]}, {Quantity[24., "Milligrams"/"Milliliters"], Quantity[17.05, "Nanometers"]}, {Quantity[24., "Milligrams"/"Milliliters"], Quantity[16.55, "Nanometers"]}, {Quantity[24., "Milligrams"/"Milliliters"], Quantity[16.68, "Nanometers"]}, {Quantity[16., "Milligrams"/"Milliliters"], Quantity[16.76, "Nanometers"]}, {Quantity[16., "Milligrams"/"Milliliters"], Quantity[15.47, "Nanometers"]}, {Quantity[16., "Milligrams"/"Milliliters"], Quantity[15.14, "Nanometers"]}, {Quantity[8., "Milligrams"/"Milliliters"], Quantity[14.82, "Nanometers"]}, {Quantity[8., "Milligrams"/"Milliliters"], Quantity[13.85, "Nanometers"]}, {Quantity[8., "Milligrams"/"Milliliters"], Quantity[13.66, "Nanometers"]}, {Quantity[0, "Milligrams"/"Milliliters"], Quantity[6.99, "Nanometers"]}};

		isoCorrelationCurvesData = {QuantityArray[ StructuredArray`StructuredData[{167, 2}, {{{9.59999965743918*^-7, 0.931388735771179}, {1.4400000054593*^-6, 0.923573553562164}, {1.91999993148784*^-6, 0.90945303440094}, {2.39999985751638*^-6, 0.89384400844574}, {2.88000001091859*^-6, 0.884498596191406}, {3.35999993694713*^-6, 0.872532248497009}, {3.83999986297567*^-6, 0.861618220806122}, {4.31999978900421*^-6, 0.850242972373962}, {4.79999971503275*^-6, 0.839010715484619}, {5.27999964106129*^-6, 0.827587485313416}, {5.76000002183719*^-6, 0.818952798843384}, {6.23999994786573*^-6, 0.809958934783936}, {6.71999987389427*^-6, 0.798640489578247}, {7.19999979992281*^-6, 0.789798140525818}, {7.67999972595135*^-6, 0.781314730644226}, {8.63999957800843*^-6, 0.762359321117401}, {9.59999943006551*^-6, 0.742951154708862}, {0.0000105599992821226, 0.72311794757843}, {0.0000115199991341797, 0.707543015480042}, {0.0000124799989862368, 0.688711643218994}, {0.0000134399988382938, 0.672142148017883}, {0.0000143999986903509, 0.654680132865906}, {0.0000153599994519027, 0.64000403881073}, {0.0000172799991560169, 0.610291242599487}, {0.000019199998860131, 0.579645752906799}, {0.0000211199985642452, 0.552627801895142}, {0.0000230399982683593, 0.527569890022278}, {0.0000249599979724735, 0.502775907516479}, {0.0000268799976765877, 0.476659864187241}, {0.0000287999973807018, 0.454938799142838}, {0.0000307199989038054, 0.433997750282288}, {0.0000345599983120337, 0.393579095602036}, {0.000038399997720262, 0.356704443693161}, {0.0000422399971284904, 0.32512041926384}, {0.0000460799965367187, 0.295797526836395}, {0.000049919995944947, 0.268973052501678}, {0.0000537599953531753, 0.243782609701157}, {0.0000575999947614037, 0.222487360239029}, {0.0000614399978076108, 0.201873689889908}, {0.0000691199966240674, 0.167835593223572}, {0.0000767999954405241, 0.139592409133911}, {0.0000844799942569807, 0.116386085748672}, {0.0000921599930734374, 0.0965680778026581}, {0.000099839991889894, 0.0801920592784882}, {0.000107519990706351, 0.066668301820755}, {0.000115199989522807, 0.0557710528373718}, {0.000122879995615222, 0.0469519793987274}, {0.000138239993248135, 0.0341377854347229}, {0.000153599990881048, 0.0259662270545959}, {0.000168959988513961, 0.0191333293914795}, {0.000184319986146875, 0.0150167644023895}, {0.000199679983779788, 0.0111905634403229}, {0.000215039981412701, 0.00851860642433167}, {0.000230399979045615, 0.00600007176399231}, {0.000245759991230443, 0.00413382053375244}, {0.00027647998649627, 0.00280508399009705}, {0.000307199981762096, 0.00193449854850769}, {0.000337919977027923, 0.000348553061485291}, {0.000368639972293749, -0.00175662338733673}, {0.000399359967559576, -0.0033707320690155}, {0.000430079962825403, -0.00300264358520508}, {0.000460799958091229, -0.00173018872737885}, {0.000491519982460886, -0.000512853264808655}, {0.000552959972992539, 0.0000579655170440674}, {0.000614399963524193, 0.000650674104690552}, {0.000675839954055846, -0.0000301003456115723}, {0.000737279944587499, -0.000990048050880432}, {0.000798719935119152, -0.00144165754318237}, {0.000860159925650805, -0.0000634044408798218}, {0.000921599916182458, 0.000976935029029846}, {0.000983039964921772, 0.000525236129760742}, {0.00110591994598508, 0.00110851228237152}, {0.00122879992704839, -0.000384882092475891}, {0.00135167990811169, -0.000205904245376587}, {0.001474559889175, -0.000130102038383484}, {0.0015974398702383, -0.0011238157749176}, {0.00172031985130161, -0.00223056972026825}, {0.00184319983236492, -0.00300818681716919}, {0.00196607992984354, -0.000759243965148926}, {0.00221183989197016, 0.000278323888778687}, {0.00245759985409677, -0.000732168555259705}, {0.00270335981622338, -0.000153854489326477}, {0.00294911977835, 0.000275149941444397}, {0.00319487974047661, 0.00066511332988739}, {0.00344063970260322, 0.000273913145065308}, {0.00368639966472983, 0.000618904829025269}, {0.00393215985968709, -0.0000477135181427002}, {0.00442367978394032, 0.000583872199058533}, {0.00491519970819354, -0.0000947117805480957}, {0.00540671963244677, 0.000252082943916321}, {0.00589823955669999, 0.000339791178703308}, {0.00638975948095322, 0.000476047396659851}, {0.00688127940520644, -0.000795260071754456}, {0.00737279932945967, 0.000266164541244507}, {0.00786431971937418, -0.00023999810218811}, {0.00884735956788063, 0.000512778759002686}, {0.00983039941638708, -0.000473380088806152}, {0.0108134392648935, 0.000230804085731506}, {0.0117964791134, -0.00035075843334198}, {0.0127795189619064, -0.000516295433044434}, {0.0137625588104129, 0.000674471259117126}, {0.0147455986589193, 0.000647664070129395}, {0.0157286394387484, -0.000271901488304138}, {0.0176947191357613, -0.000392526388168335}, {0.0196607988327742, -0.000413358211517334}, {0.0216268785297871, 0.000783741474151611}, {0.0235929582268, -0.0000458955764770508}, {0.0255590379238129, -0.00027930736541748}, {0.0275251176208258, -0.0000641345977783203}, {0.0294911973178387, 0.00077114999294281}, {0.0314572788774967, 0.0000914633274078369}, {0.0353894382715225, -0.000153630971908569}, {0.0393215976655483, -0.000039517879486084}, {0.0432537570595741, -0.000238969922065735}, {0.0471859164535999, 0.00015103816986084}, {0.0511180758476257, 0.000245332717895508}, {0.0550502352416515, -0.0000127106904983521}, {0.0589823946356773, 0.000133901834487915}, {0.0629145577549934, 0.000535964965820313}, {0.070778876543045, 0.0000616312026977539}, {0.0786431953310966, 0.0000877231359481812}, {0.0865075141191483, 0.0000762790441513062}, {0.0943718329071999, 0.000372782349586487}, {0.102236151695251, -0.00016079843044281}, {0.110100470483303, -0.0000660866498947144}, {0.117964789271355, -0.000152692198753357}, {0.125829115509987, 0.000147536396980286}, {0.14155775308609, 0.000111043453216553}, {0.157286390662193, -0.000144720077514648}, {0.173015028238297, -0.000164806842803955}, {0.1887436658144, 0.0000132918357849121}, {0.204472303390503, 0.0000642538070678711}, {0.220200940966606, 0.000175029039382935}, {0.235929578542709, 0.0000254958868026733}, {0.251658231019974, -0.000166863203048706}, {0.28311550617218, -0.000356823205947876}, {0.314572781324387, 0.000117272138595581}, {0.346030056476593, -0.0000369846820831299}, {0.377487331628799, -0.0000839382410049438}, {0.408944606781006, -0.000096544623374939}, {0.440401881933212, -0.0000699013471603394}, {0.471859157085419, 0.000129073858261108}, {0.503316462039948, -0.0000829100608825684}, {0.56623101234436, -0.0000652670860290527}, {0.629145562648773, 0.0000790506601333618}, {0.692060112953186, -0.0000784248113632202}, {0.754974663257599, -0.0000676959753036499}, {0.817889213562012, -0.0000150054693222046}, {0.880803763866425, -0.0000197440385818481}, {0.943718314170837, 0.000163346529006958}, {1.0066329240799, -0.0001048743724823}, {1.13246202468872, 0.0000851452350616455}, {1.25829112529755, -0.0000386983156204224}, {1.38412022590637, 0.000066608190536499}, {1.5099493265152, -0.0000702738761901855}, {1.63577842712402, -0.0000795871019363403}, {1.76160752773285, -0.0000378787517547607}, {1.88743662834167, 0.0000273734331130981}, {2.01326584815979, 0.0000241994857788086}, {2.26492404937744, -0.0000268071889877319}, {2.51658225059509, 0.0000395774841308594}, {2.76824045181274, -0.0000603795051574707}, {3.0198986530304, 0.000037848949432373}, {3.27155685424805, 0.0000282973051071167}, {3.5232150554657, 5.76674938201904*^-6}, {3.77487325668335, 0.0000337213277816772}, {4.02653169631958, 0.0000438094139099121}}, {"Seconds", IndependentUnit["ArbitraryUnits"]}, {{1}, {2}}}]], QuantityArray[StructuredArray`StructuredData[{167, 2}, {{{9.59999965743918*^-7, 0.935422003269196}, {1.4400000054593*^-6, 0.923949480056763}, {1.91999993148784*^-6, 0.912831544876099}, {2.39999985751638*^-6, 0.897453308105469}, {2.88000001091859*^-6, 0.886930406093597}, {3.35999993694713*^-6, 0.880356073379517}, {3.83999986297567*^-6, 0.868727445602417}, {4.31999978900421*^-6, 0.855857253074646}, {4.79999971503275*^-6, 0.844621241092682}, {5.27999964106129*^-6, 0.835177183151245}, {5.76000002183719*^-6, 0.824960112571716}, {6.23999994786573*^-6, 0.815291881561279}, {6.71999987389427*^-6, 0.804163992404938}, {7.19999979992281*^-6, 0.794397115707397}, {7.67999972595135*^-6, 0.784331798553467}, {8.63999957800843*^-6, 0.765124797821045}, {9.59999943006551*^-6, 0.744362950325012}, {0.0000105599992821226, 0.728747129440308}, {0.0000115199991341797, 0.710041046142578}, {0.0000124799989862368, 0.692408919334412}, {0.0000134399988382938, 0.6763516664505}, {0.0000143999986903509, 0.659357905387878}, {0.0000153599994519027, 0.642781257629395}, {0.0000172799991560169, 0.611983835697174}, {0.000019199998860131, 0.581684589385986}, {0.0000211199985642452, 0.553354740142822}, {0.0000230399982683593, 0.52699887752533}, {0.0000249599979724735, 0.500799238681793}, {0.0000268799976765877, 0.47693994641304}, {0.0000287999973807018, 0.4540855884552}, {0.0000307199989038054, 0.433281242847443}, {0.0000345599983120337, 0.392959266901016}, {0.000038399997720262, 0.355992138385773}, {0.0000422399971284904, 0.323427975177765}, {0.0000460799965367187, 0.294081300497055}, {0.000049919995944947, 0.267641127109528}, {0.0000537599953531753, 0.243131101131439}, {0.0000575999947614037, 0.22065070271492}, {0.0000614399978076108, 0.200572818517685}, {0.0000691199966240674, 0.165514439344406}, {0.0000767999954405241, 0.138296961784363}, {0.0000844799942569807, 0.115142673254013}, {0.0000921599930734374, 0.0966555774211884}, {0.000099839991889894, 0.0807349681854248}, {0.000107519990706351, 0.0677318871021271}, {0.000115199989522807, 0.0563293695449829}, {0.000122879995615222, 0.0467411875724792}, {0.000138239993248135, 0.0340576171875}, {0.000153599990881048, 0.0247701108455658}, {0.000168959988513961, 0.0182806551456451}, {0.000184319986146875, 0.0125307440757751}, {0.000199679983779788, 0.00931432843208313}, {0.000215039981412701, 0.00710737705230713}, {0.000230399979045615, 0.00525090098381042}, {0.000245759991230443, 0.00408235192298889}, {0.00027647998649627, 0.0018317699432373}, {0.000307199981762096, -0.00111797451972961}, {0.000337919977027923, -0.00156927108764648}, {0.000368639972293749, -0.000865176320075989}, {0.000399359967559576, -0.000239044427871704}, {0.000430079962825403, -0.000674828886985779}, {0.000460799958091229, -0.000720053911209106}, {0.000491519982460886, -0.000155806541442871}, {0.000552959972992539, -0.000271528959274292}, {0.000614399963524193, 0.00032217800617218}, {0.000675839954055846, -0.000226199626922607}, {0.000737279944587499, -0.000623837113380432}, {0.000798719935119152, -0.000475645065307617}, {0.000860159925650805, -0.000428661704063416}, {0.000921599916182458, -4.69386577606201*^-6}, {0.000983039964921772, -0.00197023153305054}, {0.00110591994598508, -0.00118088722229004}, {0.00122879992704839, -0.00165529549121857}, {0.00135167990811169, 0.000660493969917297}, {0.001474559889175, -0.00080929696559906}, {0.0015974398702383, -0.00127196311950684}, {0.00172031985130161, 0.0000413358211517334}, {0.00184319983236492, 0.000302165746688843}, {0.00196607992984354, 0.000425711274147034}, {0.00221183989197016, -0.000371992588043213}, {0.00245759985409677, -0.00034940242767334}, {0.00270335981622338, 0.00078427791595459}, {0.00294911977835, -0.000821352005004883}, {0.00319487974047661, -0.000708132982254028}, {0.00344063970260322, 0.000163793563842773}, {0.00368639966472983, 0.000500157475471497}, {0.00393215985968709, -0.000410884618759155}, {0.00442367978394032, -0.000875070691108704}, {0.00491519970819354, -0.000352561473846436}, {0.00540671963244677, -0.000246718525886536}, {0.00589823955669999, -0.00014922022819519}, {0.00638975948095322, -0.000812053680419922}, {0.00688127940520644, 0.000934094190597534}, {0.00737279932945967, -0.000117972493171692}, {0.00786431971937418, -0.000912636518478394}, {0.00884735956788063, 0.000100776553153992}, {0.00983039941638708, -0.000188305974006653}, {0.0108134392648935, 0.000867977738380432}, {0.0117964791134, 0.00018860399723053}, {0.0127795189619064, 0.0000331848859786987}, {0.0137625588104129, -0.000220641493797302}, {0.0147455986589193, 0.000877469778060913}, {0.0157286394387484, 0.000239104032516479}, {0.0176947191357613, 0.000215679407119751}, {0.0196607988327742, 0.000522494316101074}, {0.0216268785297871, -0.000159546732902527}, {0.0235929582268, 0.00107726454734802}, {0.0255590379238129, 0.000839918851852417}, {0.0275251176208258, -0.000581115484237671}, {0.0294911973178387, -0.000518262386322021}, {0.0314572788774967, -0.000102519989013672}, {0.0353894382715225, -0.000297784805297852}, {0.0393215976655483, -0.0000668615102767944}, {0.0432537570595741, -0.000267192721366882}, {0.0471859164535999, -0.000100091099739075}, {0.0511180758476257, -0.000172629952430725}, {0.0550502352416515, -0.000346720218658447}, {0.0589823946356773, 0.000513046979904175}, {0.0629145577549934, -0.000553920865058899}, {0.070778876543045, -0.000209137797355652}, {0.0786431953310966, 0.000203132629394531}, {0.0865075141191483, -0.000397965312004089}, {0.0943718329071999, 0.000369325280189514}, {0.102236151695251, -0.000302761793136597}, {0.110100470483303, 0.000112235546112061}, {0.117964789271355, -0.000466614961624146}, {0.125829115509987, -0.000269234180450439}, {0.14155775308609, -0.000257819890975952}, {0.157286390662193, 0.000101909041404724}, {0.173015028238297, 0.000129953026771545}, {0.1887436658144, 0.0000489354133605957}, {0.204472303390503, 0.0000926703214645386}, {0.220200940966606, -0.0000317990779876709}, {0.235929578542709, 0.000150635838508606}, {0.251658231019974, 0.0000593513250350952}, {0.28311550617218, 0.000162720680236816}, {0.314572781324387, 5.379319190979*^-6}, {0.346030056476593, -0.0000459104776382446}, {0.377487331628799, 0.0000368803739547729}, {0.408944606781006, 4.93228435516357*^-6}, {0.440401881933212, -0.000115096569061279}, {0.471859157085419, 0.000061333179473877}, {0.503316462039948, -0.0000889748334884644}, {0.56623101234436, 0.0000283867120742798}, {0.629145562648773, -0.0000345855951309204}, {0.692060112953186, -0.0000254064798355103}, {0.754974663257599, 0.0000135600566864014}, {0.817889213562012, -0.0000811368227005005}, {0.880803763866425, -0.0000663399696350098}, {0.943718314170837, 0.000126108527183533}, {1.0066329240799, -0.0000798851251602173}, {1.13246202468872, 5.00679016113281*^-6}, {1.25829112529755, 0.0000102818012237549}, {1.38412022590637, -0.000129058957099915}, {1.5099493265152, 8.65757465362549*^-6}, {1.63577842712402, -0.0000106692314147949}, {1.76160752773285, -0.0000465661287307739}, {1.88743662834167, 0.0000179409980773926}, {2.01326584815979, -0.000210747122764587}, {2.26492404937744, -0.000027090311050415}, {2.51658225059509, 0.0000291317701339722}, {2.76824045181274, 0.0000620782375335693}, {3.0198986530304, -0.0000625699758529663}, {3.27155685424805, -0.0000884532928466797}, {3.5232150554657, 0.0000346153974533081}, {3.77487325668335, 0.0000263303518295288}, {4.02653169631958, 0.0000412464141845703}}, {"Seconds", IndependentUnit["ArbitraryUnits"]}, {{1}, {2}}}]], QuantityArray[StructuredArray`StructuredData[{167, 2}, {{{9.59999965743918*^-7, 0.938516139984131}, {1.4400000054593*^-6, 0.925134420394897}, {1.91999993148784*^-6, 0.910788655281067}, {2.39999985751638*^-6, 0.901083469390869}, {2.88000001091859*^-6, 0.889120936393738}, {3.35999993694713*^-6, 0.879334807395935}, {3.83999986297567*^-6, 0.86749529838562}, {4.31999978900421*^-6, 0.855719387531281}, {4.79999971503275*^-6, 0.845801830291748}, {5.27999964106129*^-6, 0.836490392684937}, {5.76000002183719*^-6, 0.826598286628723}, {6.23999994786573*^-6, 0.812942802906036}, {6.71999987389427*^-6, 0.806196987628937}, {7.19999979992281*^-6, 0.795762062072754}, {7.67999972595135*^-6, 0.785014271736145}, {8.63999957800843*^-6, 0.764319896697998}, {9.59999943006551*^-6, 0.748905181884766}, {0.0000105599992821226, 0.728536009788513}, {0.0000115199991341797, 0.713140249252319}, {0.0000124799989862368, 0.692272663116455}, {0.0000134399988382938, 0.676580190658569}, {0.0000143999986903509, 0.66067761182785}, {0.0000153599994519027, 0.642931818962097}, {0.0000172799991560169, 0.61270272731781}, {0.000019199998860131, 0.584197998046875}, {0.0000211199985642452, 0.556398153305054}, {0.0000230399982683593, 0.528916835784912}, {0.0000249599979724735, 0.504184365272522}, {0.0000268799976765877, 0.47982582449913}, {0.0000287999973807018, 0.457299292087555}, {0.0000307199989038054, 0.435313940048218}, {0.0000345599983120337, 0.395873039960861}, {0.000038399997720262, 0.359571129083633}, {0.0000422399971284904, 0.32656866312027}, {0.0000460799965367187, 0.296649932861328}, {0.000049919995944947, 0.268304973840714}, {0.0000537599953531753, 0.2437464594841}, {0.0000575999947614037, 0.220865219831467}, {0.0000614399978076108, 0.200857371091843}, {0.0000691199966240674, 0.1667200922966}, {0.0000767999954405241, 0.137992739677429}, {0.0000844799942569807, 0.113849401473999}, {0.0000921599930734374, 0.0948211550712585}, {0.000099839991889894, 0.0789753794670105}, {0.000107519990706351, 0.0658400058746338}, {0.000115199989522807, 0.0548237860202789}, {0.000122879995615222, 0.0463317036628723}, {0.000138239993248135, 0.0331570208072662}, {0.000153599990881048, 0.0234626233577728}, {0.000168959988513961, 0.0172070860862732}, {0.000184319986146875, 0.0113196671009064}, {0.000199679983779788, 0.00779062509536743}, {0.000215039981412701, 0.00439217686653137}, {0.000230399979045615, 0.00261940062046051}, {0.000245759991230443, 0.001813605427742}, {0.00027647998649627, 0.000105679035186768}, {0.000307199981762096, -0.000973045825958252}, {0.000337919977027923, -0.0000123381614685059}, {0.000368639972293749, 0.000129088759422302}, {0.000399359967559576, 0.00021827220916748}, {0.000430079962825403, -0.00166212022304535}, {0.000460799958091229, -0.00204627215862274}, {0.000491519982460886, -0.000927925109863281}, {0.000552959972992539, -0.000674203038215637}, {0.000614399963524193, -0.00116840004920959}, {0.000675839954055846, 0.000186607241630554}, {0.000737279944587499, 0.000597298145294189}, {0.000798719935119152, 0.00056140124797821}, {0.000860159925650805, 0.00204938650131226}, {0.000921599916182458, 0.00189010798931122}, {0.000983039964921772, 0.00165165960788727}, {0.00110591994598508, 0.00371247529983521}, {0.00122879992704839, 0.00167256593704224}, {0.00135167990811169, 0.000268027186393738}, {0.001474559889175, -0.00199609994888306}, {0.0015974398702383, -0.001691535115242}, {0.00172031985130161, -0.000840157270431519}, {0.00184319983236492, 0.00203660130500793}, {0.00196607992984354, 0.00151205062866211}, {0.00221183989197016, -0.000128567218780518}, {0.00245759985409677, -0.000738486647605896}, {0.00270335981622338, -0.000317409634590149}, {0.00294911977835, 0.0000544488430023193}, {0.00319487974047661, 0.00162029266357422}, {0.00344063970260322, 0.000184327363967896}, {0.00368639966472983, 0.000610172748565674}, {0.00393215985968709, -0.000839933753013611}, {0.00442367978394032, -0.0013614147901535}, {0.00491519970819354, -0.000613987445831299}, {0.00540671963244677, 0.00049474835395813}, {0.00589823955669999, 0.00106310844421387}, {0.00638975948095322, -0.00104901194572449}, {0.00688127940520644, -0.000562340021133423}, {0.00737279932945967, -0.00059199333190918}, {0.00786431971937418, 0.000668138265609741}, {0.00884735956788063, -0.00010383129119873}, {0.00983039941638708, -0.000624552369117737}, {0.0108134392648935, -0.000942006707191467}, {0.0117964791134, -0.00068490207195282}, {0.0127795189619064, -0.000728294253349304}, {0.0137625588104129, 0.00064966082572937}, {0.0147455986589193, 0.000468477606773376}, {0.0157286394387484, -0.000432908535003662}, {0.0176947191357613, 0.000506222248077393}, {0.0196607988327742, 0.000904291868209839}, {0.0216268785297871, -0.000183209776878357}, {0.0235929582268, 0.000418320298194885}, {0.0255590379238129, 0.000809192657470703}, {0.0275251176208258, -0.000631034374237061}, {0.0294911973178387, 0.000673249363899231}, {0.0314572788774967, -0.000265032052993774}, {0.0353894382715225, -0.000380963087081909}, {0.0393215976655483, -0.000143229961395264}, {0.0432537570595741, 0.000152677297592163}, {0.0471859164535999, -0.0000268518924713135}, {0.0511180758476257, -0.000459492206573486}, {0.0550502352416515, -0.0000625699758529663}, {0.0589823946356773, 0.000279903411865234}, {0.0629145577549934, 0.000317513942718506}, {0.070778876543045, 0.0000713467597961426}, {0.0786431953310966, 0.0000738203525543213}, {0.0865075141191483, -0.0000808537006378174}, {0.0943718329071999, 0.000417962670326233}, {0.102236151695251, -0.000108838081359863}, {0.110100470483303, -0.0000661760568618774}, {0.117964789271355, -0.000243797898292542}, {0.125829115509987, 0.0000323653221130371}, {0.14155775308609, 0.0000385493040084839}, {0.157286390662193, -0.0000187307596206665}, {0.173015028238297, 0.000289395451545715}, {0.1887436658144, 0.000249519944190979}, {0.204472303390503, 0.000219985842704773}, {0.220200940966606, -0.000157430768013}, {0.235929578542709, 0.0000431239604949951}, {0.251658231019974, 0.000187739729881287}, {0.28311550617218, -0.000140443444252014}, {0.314572781324387, 0.0000271350145339966}, {0.346030056476593, 0.000198692083358765}, {0.377487331628799, 0.0000394880771636963}, {0.408944606781006, -0.000212147831916809}, {0.440401881933212, -0.0000881552696228027}, {0.471859157085419, -0.0000148415565490723}, {0.503316462039948, -0.000130847096443176}, {0.56623101234436, 0.0000869333744049072}, {0.629145562648773, -0.000151023268699646}, {0.692060112953186, 0.0000232160091400146}, {0.754974663257599, 0.000115111470222473}, {0.817889213562012, -0.0000665187835693359}, {0.880803763866425, 0.0000228434801101685}, {0.943718314170837, -0.000035211443901062}, {1.0066329240799, -0.0000875294208526611}, {1.13246202468872, -0.0000375509262084961}, {1.25829112529755, -0.000131741166114807}, {1.38412022590637, -0.0000571757555007935}, {1.5099493265152, -0.0000245273113250732}, {1.63577842712402, -0.0000624656677246094}, {1.76160752773285, -0.0000431686639785767}, {1.88743662834167, -0.0000707358121871948}, {2.01326584815979, -0.0000493526458740234}, {2.26492404937744, 0.0000586211681365967}, {2.51658225059509, 4.4703483581543*^-6}, {2.76824045181274, -0.0000713765621185303}, {3.0198986530304, -7.76350498199463*^-6}, {3.27155685424805, 0.0000271499156951904}, {3.5232150554657, -0.0000140070915222168}, {3.77487325668335, -0.0000968575477600098}, {4.02653169631958, 0.000140964984893799}}, {"Seconds", IndependentUnit["ArbitraryUnits"]}, {{1}, {2}}}]], QuantityArray[StructuredArray`StructuredData[{169, 2}, {{{9.59999965743918*^-7, 0.931967973709106}, {1.4400000054593*^-6, 0.917745232582092}, {1.91999993148784*^-6, 0.906011700630188}, {2.39999985751638*^-6, 0.894229531288147}, {2.88000001091859*^-6, 0.884944081306458}, {3.35999993694713*^-6, 0.87378454208374}, {3.83999986297567*^-6, 0.863392353057861}, {4.31999978900421*^-6, 0.852535009384155}, {4.79999971503275*^-6, 0.840465903282166}, {5.27999964106129*^-6, 0.830764532089233}, {5.76000002183719*^-6, 0.817638158798218}, {6.23999994786573*^-6, 0.808859944343567}, {6.71999987389427*^-6, 0.799604415893555}, {7.19999979992281*^-6, 0.788437962532043}, {7.67999972595135*^-6, 0.780597925186157}, {8.63999957800843*^-6, 0.760871410369873}, {9.59999943006551*^-6, 0.741307616233826}, {0.0000105599992821226, 0.722451448440552}, {0.0000115199991341797, 0.706193923950195}, {0.0000124799989862368, 0.687937140464783}, {0.0000134399988382938, 0.671664714813232}, {0.0000143999986903509, 0.654752135276794}, {0.0000153599994519027, 0.638802170753479}, {0.0000172799991560169, 0.606809139251709}, {0.000019199998860131, 0.577598571777344}, {0.0000211199985642452, 0.549280881881714}, {0.0000230399982683593, 0.522085011005402}, {0.0000249599979724735, 0.49766618013382}, {0.0000268799976765877, 0.473897844552994}, {0.0000287999973807018, 0.450857639312744}, {0.0000307199989038054, 0.428731590509415}, {0.0000345599983120337, 0.388491243124008}, {0.000038399997720262, 0.350900202989578}, {0.0000422399971284904, 0.319517314434052}, {0.0000460799965367187, 0.289851248264313}, {0.000049919995944947, 0.26257136464119}, {0.0000537599953531753, 0.237019509077072}, {0.0000575999947614037, 0.216149508953094}, {0.0000614399978076108, 0.195392549037933}, {0.0000691199966240674, 0.162770301103592}, {0.0000767999954405241, 0.134426027536392}, {0.0000844799942569807, 0.111328631639481}, {0.0000921599930734374, 0.0921371877193451}, {0.000099839991889894, 0.0762020945549011}, {0.000107519990706351, 0.0630223751068115}, {0.000115199989522807, 0.053194522857666}, {0.000122879995615222, 0.0438688993453979}, {0.000138239993248135, 0.0311204493045807}, {0.000153599990881048, 0.022867739200592}, {0.000168959988513961, 0.0170402526855469}, {0.000184319986146875, 0.0127385258674622}, {0.000199679983779788, 0.00962388515472412}, {0.000215039981412701, 0.00731605291366577}, {0.000230399979045615, 0.00574412941932678}, {0.000245759991230443, 0.00357721745967865}, {0.00027647998649627, 0.00126937031745911}, {0.000307199981762096, -0.00103798508644104}, {0.000337919977027923, -0.00103583931922913}, {0.000368639972293749, 0.0000251978635787964}, {0.000399359967559576, -0.00048549473285675}, {0.000430079962825403, 0.00154677033424377}, {0.000460799958091229, 0.00281175971031189}, {0.000491519982460886, 0.00233741104602814}, {0.000552959972992539, 0.000268757343292236}, {0.000614399963524193, -0.000874534249305725}, {0.000675839954055846, -0.00146426260471344}, {0.000737279944587499, -0.000760212540626526}, {0.000798719935119152, -0.00147764384746552}, {0.000860159925650805, -0.00268863141536713}, {0.000921599916182458, -0.00140856206417084}, {0.000983039964921772, -0.000265732407569885}, {0.00110591994598508, 0.00056767463684082}, {0.00122879992704839, -0.000212520360946655}, {0.00135167990811169, 0.000705495476722717}, {0.001474559889175, 0.000320062041282654}, {0.0015974398702383, -0.000743329524993896}, {0.00172031985130161, -0.000642836093902588}, {0.00184319983236492, -0.000493720173835754}, {0.00196607992984354, -0.00124745070934296}, {0.00221183989197016, 0.000195026397705078}, {0.00245759985409677, -0.000707104802131653}, {0.00270335981622338, 0.000427395105361938}, {0.00294911977835, 0.000170528888702393}, {0.00319487974047661, -0.000456780195236206}, {0.00344063970260322, -0.0000748038291931152}, {0.00368639966472983, -0.00027938187122345}, {0.00393215985968709, 0.00191783905029297}, {0.00442367978394032, -0.001005619764328}, {0.00491519970819354, 0.00121435523033142}, {0.00540671963244677, 0.000173196196556091}, {0.00589823955669999, 0.000416070222854614}, {0.00638975948095322, 0.00071994960308075}, {0.00688127940520644, 0.000261962413787842}, {0.00737279932945967, -0.0000134855508804321}, {0.00786431971937418, -0.000720083713531494}, {0.00884735956788063, -0.000113368034362793}, {0.00983039941638708, 0.00014793872833252}, {0.0108134392648935, 0.000696346163749695}, {0.0117964791134, 0.000823646783828735}, {0.0127795189619064, 0.000773116946220398}, {0.0137625588104129, 0.0000804513692855835}, {0.0147455986589193, -0.000555962324142456}, {0.0157286394387484, 0.000373616814613342}, {0.0176947191357613, 0.000791937112808228}, {0.0196607988327742, -0.000165805220603943}, {0.0216268785297871, -0.000349506735801697}, {0.0235929582268, -0.000478357076644897}, {0.0255590379238129, 0.000120982527732849}, {0.0275251176208258, -0.000458747148513794}, {0.0294911973178387, 0.000862032175064087}, {0.0314572788774967, -0.000468388199806213}, {0.0353894382715225, -0.0000339746475219727}, {0.0393215976655483, 0.000138983130455017}, {0.0432537570595741, 0.000126510858535767}, {0.0471859164535999, -0.000136032700538635}, {0.0511180758476257, 0.00013694167137146}, {0.0550502352416515, 0.000161007046699524}, {0.0589823946356773, 0.00014282763004303}, {0.0629145577549934, -0.0000961571931838989}, {0.070778876543045, -0.00011676549911499}, {0.0786431953310966, -0.000234261155128479}, {0.0865075141191483, 0.0000375658273696899}, {0.0943718329071999, -0.00034661591053009}, {0.102236151695251, 0.0000337958335876465}, {0.110100470483303, -0.000203236937522888}, {0.117964789271355, -0.000226885080337524}, {0.125829115509987, 0.000132083892822266}, {0.14155775308609, -0.000103309750556946}, {0.157286390662193, -0.000117763876914978}, {0.173015028238297, -0.000152215361595154}, {0.1887436658144, -0.0000356435775756836}, {0.204472303390503, 0.0000627785921096802}, {0.220200940966606, 0.000113680958747864}, {0.235929578542709, -0.0000457316637039185}, {0.251658231019974, 0.0000638365745544434}, {0.28311550617218, -0.000253066420555115}, {0.314572781324387, -0.000219434499740601}, {0.346030056476593, 0.000137478113174438}, {0.377487331628799, 0.000126466155052185}, {0.408944606781006, -0.0000549852848052979}, {0.440401881933212, 0.0000167787075042725}, {0.471859157085419, -0.0000770241022109985}, {0.503316462039948, -0.0000710338354110718}, {0.56623101234436, 0.0000683367252349854}, {0.629145562648773, -0.000105619430541992}, {0.692060112953186, 0.0000274330377578735}, {0.754974663257599, -0.0000402927398681641}, {0.817889213562012, -3.68058681488037*^-6}, {0.880803763866425, -0.0000192821025848389}, {0.943718314170837, 0.0000306218862533569}, {1.0066329240799, 0.000066027045249939}, {1.13246202468872, -0.0000520944595336914}, {1.25829112529755, -0.0000110864639282227}, {1.38412022590637, -0.0000277161598205566}, {1.5099493265152, 0.0000165551900863647}, {1.63577842712402, 8.73208045959473*^-6}, {1.76160752773285, -0.0000633150339126587}, {1.88743662834167, 0.0000202059745788574}, {2.01326584815979, 0.0000942647457122803}, {2.26492404937744, 0.0000132322311401367}, {2.51658225059509, 0.0000193864107131958}, {2.76824045181274, -0.0000499188899993896}, {3.0198986530304, 0.0000386536121368408}, {3.27155685424805, 0.0000428557395935059}, {3.5232150554657, -0.00005379319190979}, {3.77487325668335, 0.000038832426071167}, {4.02653169631958, 7.30156898498535*^-6}, {4.52984809875488, 2.05636024475098*^-6}, {5.03316450119019, 0.}}, {"Seconds", IndependentUnit["ArbitraryUnits"]}, {{1}, {2}}}]], QuantityArray[StructuredArray`StructuredData[{168, 2}, {{{4.79999982871959*^-7, 0.955573499202728}, {9.59999965743918*^-7, 0.941595792770386}, {1.4400000054593*^-6, 0.930142402648926}, {1.91999993148784*^-6, 0.916195273399353}, {2.39999985751638*^-6, 0.906150698661804}, {2.88000001091859*^-6, 0.893369436264038}, {3.35999993694713*^-6, 0.884044408798218}, {3.83999986297567*^-6, 0.873092770576477}, {4.31999978900421*^-6, 0.862703323364258}, {4.79999971503275*^-6, 0.853194355964661}, {5.27999964106129*^-6, 0.841407656669617}, {5.76000002183719*^-6, 0.83030104637146}, {6.23999994786573*^-6, 0.824163794517517}, {6.71999987389427*^-6, 0.813102424144745}, {7.19999979992281*^-6, 0.802953124046326}, {7.67999972595135*^-6, 0.792424321174622}, {8.63999957800843*^-6, 0.772857546806335}, {9.59999943006551*^-6, 0.755874395370483}, {0.0000105599992821226, 0.737792432308197}, {0.0000115199991341797, 0.71963232755661}, {0.0000124799989862368, 0.702508747577667}, {0.0000134399988382938, 0.685965895652771}, {0.0000143999986903509, 0.668132185935974}, {0.0000153599994519027, 0.656050682067871}, {0.0000172799991560169, 0.622112452983856}, {0.000019199998860131, 0.593455195426941}, {0.0000211199985642452, 0.567057490348816}, {0.0000230399982683593, 0.539716958999634}, {0.0000249599979724735, 0.514513611793518}, {0.0000268799976765877, 0.492309510707855}, {0.0000287999973807018, 0.468235731124878}, {0.0000307199989038054, 0.446837246417999}, {0.0000345599983120337, 0.407261252403259}, {0.000038399997720262, 0.371238350868225}, {0.0000422399971284904, 0.338288098573685}, {0.0000460799965367187, 0.308460205793381}, {0.000049919995944947, 0.281487137079239}, {0.0000537599953531753, 0.257163345813751}, {0.0000575999947614037, 0.234364658594131}, {0.0000614399978076108, 0.216485321521759}, {0.0000691199966240674, 0.18073582649231}, {0.0000767999954405241, 0.15184074640274}, {0.0000844799942569807, 0.128176659345627}, {0.0000921599930734374, 0.107145041227341}, {0.000099839991889894, 0.0912713408470154}, {0.000107519990706351, 0.0769213736057281}, {0.000115199989522807, 0.0649614036083221}, {0.000122879995615222, 0.055259644985199}, {0.000138239993248135, 0.0401174426078796}, {0.000153599990881048, 0.0299861133098602}, {0.000168959988513961, 0.023116797208786}, {0.000184319986146875, 0.0177512764930725}, {0.000199679983779788, 0.0144039392471313}, {0.000215039981412701, 0.0105823278427124}, {0.000230399979045615, 0.00859534740447998}, {0.000245759991230443, 0.00687110424041748}, {0.00027647998649627, 0.00385597348213196}, {0.000307199981762096, 0.00335432589054108}, {0.000337919977027923, 0.00309543311595917}, {0.000368639972293749, 0.000597655773162842}, {0.000399359967559576, 0.000653728842735291}, {0.000430079962825403, 0.000268951058387756}, {0.000460799958091229, -0.000810801982879639}, {0.000491519982460886, 0.000746950507164001}, {0.000552959972992539, 0.0013657808303833}, {0.000614399963524193, 0.0012536346912384}, {0.000675839954055846, 0.00227530300617218}, {0.000737279944587499, 0.00220230221748352}, {0.000798719935119152, 0.0030541718006134}, {0.000860159925650805, 0.00265753269195557}, {0.000921599916182458, -0.00177627801895142}, {0.000983039964921772, -0.00284834206104279}, {0.00110591994598508, -0.00226259231567383}, {0.00122879992704839, -0.000020444393157959}, {0.00135167990811169, 0.000678285956382751}, {0.001474559889175, 0.000405415892601013}, {0.0015974398702383, 0.000593870878219604}, {0.00172031985130161, -0.000349178910255432}, {0.00184319983236492, 0.00178250670433044}, {0.00196607992984354, 0.00196649134159088}, {0.00221183989197016, 0.000415608286857605}, {0.00245759985409677, 0.000643074512481689}, {0.00270335981622338, 0.000437766313552856}, {0.00294911977835, -0.000737994909286499}, {0.00319487974047661, -0.000787913799285889}, {0.00344063970260322, 0.0000586956739425659}, {0.00368639966472983, 0.00065244734287262}, {0.00393215985968709, -0.00105932354927063}, {0.00442367978394032, -0.000082746148109436}, {0.00491519970819354, 0.000458255410194397}, {0.00540671963244677, 0.000521928071975708}, {0.00589823955669999, 0.000712871551513672}, {0.00638975948095322, -0.000666335225105286}, {0.00688127940520644, 0.000326752662658691}, {0.00737279932945967, 0.0000566393136978149}, {0.00786431971937418, 0.000333234667778015}, {0.00884735956788063, 0.000535190105438232}, {0.00983039941638708, 0.0011909008026123}, {0.0108134392648935, -0.00097300112247467}, {0.0117964791134, 0.000810831785202026}, {0.0127795189619064, -0.0000855326652526855}, {0.0137625588104129, 0.000325977802276611}, {0.0147455986589193, 0.000331774353981018}, {0.0157286394387484, -0.0000454187393188477}, {0.0176947191357613, 0.000366061925888062}, {0.0196607988327742, 0.000320553779602051}, {0.0216268785297871, -0.000573635101318359}, {0.0235929582268, -0.000341907143592834}, {0.0255590379238129, 0.000190421938896179}, {0.0275251176208258, -0.0002736896276474}, {0.0294911973178387, 0.000243306159973145}, {0.0314572788774967, -0.000113964080810547}, {0.0353894382715225, 0.0000411719083786011}, {0.0393215976655483, 0.00019228458404541}, {0.0432537570595741, 0.000621408224105835}, {0.0471859164535999, -0.000131368637084961}, {0.0511180758476257, 0.0000313818454742432}, {0.0550502352416515, -0.000202864408493042}, {0.0589823946356773, 0.000144794583320618}, {0.0629145577549934, -0.0000843703746795654}, {0.070778876543045, -0.000205278396606445}, {0.0786431953310966, 0.0000582784414291382}, {0.0865075141191483, -0.0000758618116378784}, {0.0943718329071999, 0.0000451356172561646}, {0.102236151695251, -0.000332847237586975}, {0.110100470483303, -0.00019267201423645}, {0.117964789271355, 0.0000834763050079346}, {0.125829115509987, -0.000105217099189758}, {0.14155775308609, 0.000209137797355652}, {0.157286390662193, 0.000144749879837036}, {0.173015028238297, 0.000398069620132446}, {0.1887436658144, 0.0000949352979660034}, {0.204472303390503, -0.0000754743814468384}, {0.220200940966606, -0.000133946537971497}, {0.235929578542709, 0.000168770551681519}, {0.251658231019974, 0.00015847384929657}, {0.28311550617218, -0.000125229358673096}, {0.314572781324387, 0.000474601984024048}, {0.346030056476593, 0.000137001276016235}, {0.377487331628799, 0.0000234395265579224}, {0.408944606781006, 0.000291049480438232}, {0.440401881933212, -0.0000454932451248169}, {0.471859157085419, -0.0000502616167068481}, {0.503316462039948, -0.000123828649520874}, {0.56623101234436, 9.5367431640625*^-6}, {0.629145562648773, -0.000180661678314209}, {0.692060112953186, 0.0000274032354354858}, {0.754974663257599, 0.000131279230117798}, {0.817889213562012, -0.0000246018171310425}, {0.880803763866425, -0.0000264495611190796}, {0.943718314170837, -0.0000558644533157349}, {1.0066329240799, 2.30967998504639*^-6}, {1.13246202468872, 0.0000309348106384277}, {1.25829112529755, -0.000072479248046875}, {1.38412022590637, 0.0000183433294296265}, {1.5099493265152, 0.000105887651443481}, {1.63577842712402, -0.0000766217708587646}, {1.76160752773285, -3.12924385070801*^-6}, {1.88743662834167, 4.73856925964355*^-6}, {2.01326584815979, 0.0000239759683609009}, {2.26492404937744, -3.27825546264648*^-6}, {2.51658225059509, 0.0000474154949188232}, {2.76824045181274, 0.000055849552154541}, {3.0198986530304, -0.0000689923763275146}, {3.27155685424805, -0.0000619888305664063}, {3.5232150554657, -0.0000162422657012939}, {3.77487325668335, 0.000200778245925903}, {4.02653169631958, 0.0000444650650024414}}, {"Seconds", IndependentUnit["ArbitraryUnits"]}, {{1}, {2}}}]]};

		isoDiffusionCoefficient = {Quantity[3.978*^-11, "Meters"^2/"Seconds"], Quantity[4.106*^-11, "Meters"^2/"Seconds"], Quantity[4.051*^-11, "Meters"^2/"Seconds"], Quantity[4.095*^-11, "Meters"^2/"Seconds"], Quantity[4.0709999999999994*^-11, "Meters"^2/"Seconds"]};

		colloidalDiffusionCoefficient = {Quantity[2.4129999999999995*^-11, "Meters"^2/"Seconds"], Quantity[2.4660000000000002*^-11, "Meters"^2/"Seconds"], Quantity[2.4489999999999998*^-11, "Meters"^2/"Seconds"], Quantity[2.617*^-11, "Meters"^2/"Seconds"], Quantity[2.623*^-11, "Meters"^2/"Seconds"], Quantity[2.6219999999999998*^-11, "Meters"^2/"Seconds"], Quantity[2.7799999999999997*^-11, "Meters"^2/"Seconds"], Quantity[2.873*^-11, "Meters"^2/"Seconds"], Quantity[2.8969999999999995*^-11, "Meters"^2/"Seconds"], Quantity[2.882*^-11, "Meters"^2/"Seconds"], Quantity[3.116*^-11, "Meters"^2/"Seconds"], Quantity[3.168*^-11, "Meters"^2/"Seconds"], Quantity[3.2629999999999995*^-11, "Meters"^2/"Seconds"], Quantity[3.448*^-11, "Meters"^2/"Seconds"], Quantity[3.499*^-11, "Meters"^2/"Seconds"]};

		colloidalPolydispersityIndices = {0.335, 0.303, 0.367, 0.184, 0.4, 0.312, 0.358, 0.308, 0.11, 0.239, 0.188, 0.184, 0.174, 0.298, 0.277};

		colloidalApparentMW = {Quantity[ 551356.2448759567, ("Grams"*"Milliliters")/ ("Centimeters"^3*"Moles")], Quantity[761862.7927882338, ("Grams"*"Milliliters")/("Centimeters"^3*"Moles")], Quantity[596990.4931927487, ("Grams"*"Milliliters")/("Centimeters"^3*"Moles")], Quantity[878363.3510626218, ("Grams"*"Milliliters")/("Centimeters"^3*"Moles")], Quantity[708991.8936606813, ("Grams"*"Milliliters")/("Centimeters"^3*"Moles")], Quantity[679212.1783241499, ("Grams"*"Milliliters")/("Centimeters"^3*"Moles")], Quantity[816498.8818634338, ("Grams"*"Milliliters")/("Centimeters"^3*"Moles")], Quantity[527048.6485395188, ("Grams"*"Milliliters")/("Centimeters"^3*"Moles")], Quantity[677801.9057548176, ("Grams"*"Milliliters")/("Centimeters"^3*"Moles")], Quantity[828693.5561297018, ("Grams"*"Milliliters")/("Centimeters"^3*"Moles")], Quantity[694131.0253074237, ("Grams"*"Milliliters")/("Centimeters"^3*"Moles")], Quantity[586503.2249698718, ("Grams"*"Milliliters")/("Centimeters"^3*"Moles")], Quantity[481219.1391636801, ("Grams"*"Milliliters")/("Centimeters"^3*"Moles")], Quantity[515851.0187882789, ("Grams"*"Milliliters")/("Centimeters"^3*"Moles")], Quantity[425001.1724237034, ("Grams"*"Milliliters")/("Centimeters"^3*"Moles")]};

		(*mock packet for SizingPolydispersity on Uncle*)
		sizingPolydispersityOnUnclePacket =
			<|
				Type -> Object[Data, DynamicLightScattering],
				Instrument -> uncleInstrument,
				Protocol[Instrument][DynamicLightScatteringWavelengths] -> {660 Nanometer},
				CorrelationCurves -> {},
				CorrelationCurve -> sizingCorrelationCurve,
				Temperature -> 28 Celsius,
				Protocol[CalibrationStandardIntensity] -> 300000.,
				RawDataFiles -> sizingRawDataFiles,
				Protocol[AssayType] -> SizingPolydispersity,
				Protocol[Instrument][RecentQualifications] -> sizingQualification,
				Analyte->{},
				Analyte[MolecularWeight] -> sizingMolecularWeight,
				Protocol -> sizingProtocol,
				Protocol[Data] -> sizingProtocolData,
				ZAverageDiameter -> 13.7*Nanometer,
				ZAverageDiameters -> {},
				EstimatedMolecularWeight -> {}
			|>;

		(*mock packet for IsothermoStability on Uncle*)
		isothermoStabilityOnUnclePacket =
      		<|
				Type -> Object[Data, DynamicLightScattering],
				Instrument -> uncleInstrument,
				Protocol[Instrument][DynamicLightScatteringWavelengths] -> {660 Nanometer},
				CorrelationCurves -> {},
				CorrelationCurve -> {},
				Temperature -> 25 Celsius,
				Protocol[CalibrationStandardIntensity] -> 300000.,
				RawDataFiles -> isoRawDataFiles,
				Protocol[AssayType] -> IsothermalStability,
				Protocol[Instrument][RecentQualifications] -> isoQuantification,
				Analyte->{},
				Analyte[MolecularWeight] -> {},
				Protocol -> isoProtocol,
				Protocol[Data] -> isoProtocolData,
				ZAverageDiameter -> {},
				ZAverageDiameters -> isoZAverageDiameters,
				EstimatedMolecularWeight -> {}
			|>;

		(*mock packet for ColloidalStability on Uncle*)
		colloidalStabilityOnUnclePacket =
      		<|
				Type -> Object[Data, DynamicLightScattering],
				Instrument -> uncleInstrument,
				Protocol[Instrument][DynamicLightScatteringWavelengths] -> {660 Nanometer},
				CorrelationCurves -> colloidCorrelationCurves,
				CorrelationCurve -> {},
				Temperature -> 25 Celsius,
				Protocol -> colloidProtocol,
				RawDataFiles -> colloidRawDataFiles,
				Protocol[AssayType] -> ColloidalStability,
				Protocol[Instrument][RecentQualifications] -> isoQuantification,
				Analyte->Link[Model[Molecule, Protein, Antibody, "id:aXRlGn6vp6Rk"]],
				ZAverageDiameter -> {},
				ZAverageDiameters -> colloidZaverageDiameters,
				EstimatedMolecularWeight -> {}
			|>;

		(*mock packet for SizingPolydispersity on DynaPro*)
		sizingPolydispersityOnDynaProPacket =
      		<|
				Type -> Object[Data, DynamicLightScattering],
				Object->Object[Data,DynamicLightScattering,"sizing example "<>$SessionUUID],
				Instrument -> dynaproInstrument,
				Protocol[Instrument][DynamicLightScatteringWavelengths] -> {660 Nanometer},
				CorrelationCurves -> {},
				CorrelationCurve -> sizingCorrelationCurve,
				Temperature -> 28 Celsius,
				Protocol[CalibrationStandardIntensity] -> 300000.,
				Protocol[AssayType] -> SizingPolydispersity,
				Protocol[Instrument][RecentQualifications] -> sizingQualification,
				Analyte->{},
				Analyte[MolecularWeight] -> sizingMolecularWeight,
				Protocol -> sizingProtocol,
				ZAverageDiameter -> 13.7 Nanometer,
				ZAverageDiameters -> {},
				ZAverageDiffusionCoefficient -> Quantity[3.829`*^-11, ("Meters")^2/("Seconds")],
				PolydispersityIndex -> 0.03703680713410594`,
				PolydispersityIndices -> {},
				SolventRefractiveIndex -> 1.3334,
				EstimatedMolecularWeight -> {}
			|>;

		(*mock packet for IsothermalStability on DynaPro*)
		isothermoStabilityOnDynaProPacket =
      		<|
				Type -> Object[Data, DynamicLightScattering],
				Object->Object[Data,DynamicLightScattering,"isothermal example "<>$SessionUUID],
				Instrument -> dynaproInstrument,
				Protocol[Instrument][DynamicLightScatteringWavelengths] -> {660 Nanometer},
				CorrelationCurves -> isoCorrelationCurvesData,
				CorrelationCurve -> {},
				Temperature -> 25 Celsius,
				Protocol[CalibrationStandardIntensity] -> 300000.,
				Protocol[AssayType] -> IsothermalStability,
				Protocol[Instrument][RecentQualifications] -> isoQuantification,
				Analyte->{},
				Protocol -> isoProtocol,
				Protocol[Data] -> isoProtocolData,
				ZAverageDiameter -> {},
				ZAverageDiameters -> isoZAverageDiameters,
				ZAverageDiffusionCoefficient -> isoDiffusionCoefficient,
				PolydispersityIndex -> {},
				PolydispersityIndices -> {0.16`, 0.062`, 0.17`, 0.123`, 0.17`},
				SolventRefractiveIndex -> 1.3334,
				EstimatedMolecularWeight -> {}
			|>;

		(*mock packet for ColloidalStability on DynaPro*)
		colloidalStabilityOnDynaProPacket =
      		<|
				Type -> Object[Data, DynamicLightScattering],
				Object->Object[Data,DynamicLightScattering,"colloidal example"<>$SessionUUID],
				Instrument -> dynaproInstrument,
				Protocol[Instrument][DynamicLightScatteringWavelengths] -> {660 Nanometer},
				CorrelationCurves -> colloidCorrelationCurves,
				CorrelationCurve -> {},
				Temperature -> 25 Celsius,
				Protocol[CalibrationStandardIntensity] -> 300000.,
				RawDataFiles -> {}, Protocol[AssayType] -> ColloidalStability,
				Protocol[Instrument][RecentQualifications] -> isoQuantification,
				Analyte->Link[Model[Molecule, Protein, Antibody, "id:aXRlGn6vp6Rk"], "qdkmxzdNAeLa"],
				Analyte[MolecularWeight] -> {},
				Protocol -> colloidProtocol,
				Protocol[Data] -> colloidProtocolData,
				ZAverageDiameter -> {},
				ZAverageDiameters -> colloidZaverageDiameters,
				ZAverageDiffusionCoefficient -> colloidalDiffusionCoefficient,
				PolydispersityIndex -> {},
				PolydispersityIndices -> colloidalPolydispersityIndices,
				SolventRefractiveIndex -> 1.3334,
				EstimatedMolecularWeight -> colloidalApparentMW
			|>;
		
			(* old test objects *)
			testObjList={
				Object[Protocol,DynamicLightScattering,"DLSTestProtocol"<>$SessionUUID],
				Object[Data,DynamicLightScattering,"DLSTestData"<>$SessionUUID]
			};
			
			(* Erase any objects that we failed to erase in the last unit test teardown *)
			existsFilter=DatabaseMemberQ[testObjList];
			EraseObject[PickList[testObjList,existsFilter],Force->True,Verbose->False];
			
			myDLSProtocolObject = CreateID[Object[Protocol, DynamicLightScattering]];
			myDLSDataObject = CreateID[Object[Data, DynamicLightScattering]];
			
			myTestProtocolDLS = <|
				Object -> myDLSProtocolObject,
				Name ->"DLSTestProtocol"<>$SessionUUID,
				CalibrationStandardIntensity -> 300000,
				AssayType->IsothermalStability,
				Instrument -> Link[Object[Instrument,MultimodeSpectrophotometer,"id:P5ZnEjd9bjM4"]]
			|>;
			
			myTestDataDLS = <|
				Object -> myDLSDataObject,
				Name ->"DLSTestData"<>$SessionUUID,
				Temperature -> 298 Kelvin,
				Instrument -> Link[Object[Instrument, MultimodeSpectrophotometer, "id:P5ZnEjd9bjM4"]],
				Replace[RawDataFiles] -> Link/@{Object[EmeraldCloudFile, "id:n0k9mGkANo6w"], Object[EmeraldCloudFile, "id:01G6nvG7Bb5A"], Object[EmeraldCloudFile, "id:1ZA60vArB7R0"], Object[EmeraldCloudFile, "id:Z1lqpMl6W3Y9"]},
				Protocol -> Link[myDLSProtocolObject, Data],
				Replace[ZAverageDiameters] -> {{Quantity[0.`,"Seconds"],Quantity[13.83`,"Nanometers"]},{Quantity[124.`,"Seconds"],Quantity[13.42`,"Nanometers"]},{Quantity[248.`,"Seconds"],Quantity[13.46`,"Nanometers"]},{Quantity[372.`,"Seconds"],Quantity[13.42`,"Nanometers"]},{Quantity[496.`,"Seconds"],Quantity[13.45`,"Nanometers"]}},
				Replace[CorrelationCurves] -> List[List[Quantity[0.`, "Seconds"],
					QuantityArray[
						StructuredArray`StructuredData[List[168, 2],
							List[List[List[0.479999982871959`, 0.955573499202728`],
								List[0.959999965743918`, 0.941595792770386`],
								List[1.4400000054592998`, 0.930142402648926`],
								List[1.9199999314878398`, 0.916195273399353`],
								List[2.3999998575163803`, 0.906150698661804`],
								List[2.88000001091859`, 0.893369436264038`],
								List[3.35999993694713`, 0.884044408798218`],
								List[3.83999986297567`, 0.873092770576477`],
								List[4.31999978900421`, 0.862703323364258`],
								List[4.79999971503275`, 0.853194355964661`],
								List[5.2799996410612895`, 0.841407656669617`],
								List[5.7600000218371905`, 0.83030104637146`],
								List[6.23999994786573`, 0.824163794517517`],
								List[6.71999987389427`, 0.813102424144745`],
								List[7.19999979992281`, 0.802953124046326`],
								List[7.679999725951349`, 0.792424321174622`],
								List[8.63999957800843`, 0.772857546806335`],
								List[9.59999943006551`, 0.755874395370483`],
								List[10.5599992821226`, 0.737792432308197`],
								List[11.519999134179699`, 0.71963232755661`],
								List[12.4799989862368`, 0.702508747577667`],
								List[13.4399988382938`, 0.685965895652771`],
								List[14.3999986903509`, 0.668132185935974`],
								List[15.359999451902699`, 0.656050682067871`],
								List[17.2799991560169`, 0.622112452983856`],
								List[19.199998860131`, 0.593455195426941`],
								List[21.1199985642452`, 0.567057490348816`],
								List[23.0399982683593`, 0.539716958999634`],
								List[24.9599979724735`, 0.514513611793518`],
								List[26.8799976765877`, 0.492309510707855`],
								List[28.7999973807018`, 0.468235731124878`],
								List[30.719998903805397`, 0.446837246417999`],
								List[34.5599983120337`, 0.407261252403259`],
								List[38.399997720262`, 0.371238350868225`],
								List[42.2399971284904`, 0.338288098573685`],
								List[46.0799965367187`, 0.308460205793381`],
								List[49.919995944947`, 0.281487137079239`],
								List[53.7599953531753`, 0.257163345813751`],
								List[57.5999947614037`, 0.234364658594131`],
								List[61.439997807610794`, 0.216485321521759`],
								List[69.1199966240674`, 0.18073582649231`],
								List[76.7999954405241`, 0.15184074640274`],
								List[84.4799942569807`, 0.128176659345627`],
								List[92.1599930734374`, 0.107145041227341`],
								List[99.839991889894`, 0.0912713408470154`],
								List[107.51999070635101`, 0.0769213736057281`],
								List[115.199989522807`, 0.0649614036083221`],
								List[122.879995615222`, 0.055259644985199`],
								List[138.239993248135`, 0.0401174426078796`],
								List[153.599990881048`, 0.0299861133098602`],
								List[168.959988513961`, 0.023116797208786`],
								List[184.319986146875`, 0.0177512764930725`],
								List[199.679983779788`, 0.0144039392471313`],
								List[215.03998141270102`, 0.0105823278427124`],
								List[230.399979045615`, 0.00859534740447998`],
								List[245.759991230443`, 0.00687110424041748`],
								List[276.47998649627`, 0.00385597348213196`],
								List[307.199981762096`, 0.00335432589054108`],
								List[337.919977027923`, 0.00309543311595917`],
								List[368.639972293749`, 0.000597655773162842`],
								List[399.359967559576`, 0.000653728842735291`],
								List[430.079962825403`, 0.000268951058387756`],
								List[460.799958091229`, -0.000810801982879639`],
								List[491.519982460886`, 0.000746950507164001`],
								List[552.959972992539`, 0.0013657808303833`],
								List[614.399963524193`, 0.0012536346912384`],
								List[675.839954055846`, 0.00227530300617218`],
								List[737.279944587499`, 0.00220230221748352`],
								List[798.719935119152`, 0.0030541718006134`],
								List[860.159925650805`, 0.00265753269195557`],
								List[921.599916182458`, -0.00177627801895142`],
								List[983.039964921772`, -0.00284834206104279`],
								List[1105.91994598508`, -0.00226259231567383`],
								List[1228.79992704839`, -0.000020444393157959`],
								List[1351.6799081116899`, 0.000678285956382751`],
								List[1474.559889175`, 0.000405415892601013`],
								List[1597.4398702383`, 0.000593870878219604`],
								List[1720.31985130161`, -0.000349178910255432`],
								List[1843.19983236492`, 0.00178250670433044`],
								List[1966.0799298435402`, 0.00196649134159088`],
								List[2211.83989197016`, 0.000415608286857605`],
								List[2457.59985409677`, 0.000643074512481689`],
								List[2703.3598162233798`, 0.000437766313552856`],
								List[2949.11977835`, -0.000737994909286499`],
								List[3194.87974047661`, -0.000787913799285889`],
								List[3440.63970260322`, 0.0000586956739425659`],
								List[3686.39966472983`, 0.00065244734287262`],
								List[3932.15985968709`, -0.00105932354927063`],
								List[4423.67978394032`, -0.000082746148109436`],
								List[4915.19970819354`, 0.000458255410194397`],
								List[5406.71963244677`, 0.000521928071975708`],
								List[5898.23955669999`, 0.000712871551513672`],
								List[6389.75948095322`, -0.000666335225105286`],
								List[6881.27940520644`, 0.000326752662658691`],
								List[7372.79932945967`, 0.0000566393136978149`],
								List[7864.31971937418`, 0.000333234667778015`],
								List[8847.35956788063`, 0.000535190105438232`],
								List[9830.39941638708`, 0.0011909008026123`],
								List[10813.4392648935`, -0.00097300112247467`],
								List[11796.4791134`, 0.000810831785202026`],
								List[12779.5189619064`, -0.0000855326652526855`],
								List[13762.5588104129`, 0.000325977802276611`],
								List[14745.5986589193`, 0.000331774353981018`],
								List[15728.639438748402`, -0.0000454187393188477`],
								List[17694.719135761297`, 0.000366061925888062`],
								List[19660.7988327742`, 0.000320553779602051`],
								List[21626.8785297871`, -0.000573635101318359`],
								List[23592.9582268`, -0.000341907143592834`],
								List[25559.037923812903`, 0.000190421938896179`],
								List[27525.1176208258`, -0.0002736896276474`],
								List[29491.1973178387`, 0.000243306159973145`],
								List[31457.278877496698`, -0.000113964080810547`],
								List[35389.4382715225`, 0.0000411719083786011`],
								List[39321.597665548295`, 0.00019228458404541`],
								List[43253.7570595741`, 0.000621408224105835`],
								List[47185.9164535999`, -0.000131368637084961`],
								List[51118.075847625696`, 0.0000313818454742432`],
								List[55050.2352416515`, -0.000202864408493042`],
								List[58982.3946356773`, 0.000144794583320618`],
								List[62914.557754993395`, -0.0000843703746795654`],
								List[70778.876543045`, -0.000205278396606445`],
								List[78643.19533109659`, 0.0000582784414291382`],
								List[86507.5141191483`, -0.0000758618116378784`],
								List[94371.8329071999`, 0.0000451356172561646`],
								List[102236.15169525101`, -0.000332847237586975`],
								List[110100.470483303`, -0.00019267201423645`],
								List[117964.789271355`, 0.0000834763050079346`],
								List[125829.115509987`, -0.000105217099189758`],
								List[141557.75308609`, 0.000209137797355652`],
								List[157286.390662193`, 0.000144749879837036`],
								List[173015.028238297`, 0.000398069620132446`],
								List[188743.6658144`, 0.0000949352979660034`],
								List[204472.30339050302`, -0.0000754743814468384`],
								List[220200.940966606`, -0.000133946537971497`],
								List[235929.578542709`, 0.000168770551681519`],
								List[251658.231019974`, 0.00015847384929657`],
								List[283115.50617218`, -0.000125229358673096`],
								List[314572.781324387`, 0.000474601984024048`],
								List[346030.056476593`, 0.000137001276016235`],
								List[377487.331628799`, 0.0000234395265579224`],
								List[408944.60678100603`, 0.000291049480438232`],
								List[440401.881933212`, -0.0000454932451248169`],
								List[471859.157085419`, -0.0000502616167068481`],
								List[503316.462039948`, -0.000123828649520874`],
								List[566231.01234436`, 9.5367431640625`*^-6],
								List[629145.562648773`, -0.000180661678314209`],
								List[692060.112953186`, 0.0000274032354354858`],
								List[754974.663257599`, 0.000131279230117798`],
								List[817889.2135620121`, -0.0000246018171310425`],
								List[880803.763866425`, -0.0000264495611190796`],
								List[943718.3141708369`, -0.0000558644533157349`],
								List[1.0066329240798999`*^6, 2.30967998504639`*^-6],
								List[1.13246202468872`*^6, 0.0000309348106384277`],
								List[1.2582911252975499`*^6, -0.000072479248046875`],
								List[1.38412022590637`*^6, 0.0000183433294296265`],
								List[1.5099493265152`*^6, 0.000105887651443481`],
								List[1.6357784271240202`*^6, -0.0000766217708587646`],
								List[1.76160752773285`*^6, -3.12924385070801`*^-6],
								List[1.88743662834167`*^6, 4.73856925964355`*^-6],
								List[2.01326584815979`*^6, 0.0000239759683609009`],
								List[2.26492404937744`*^6, -3.27825546264648`*^-6],
								List[2.51658225059509`*^6, 0.0000474154949188232`],
								List[2.76824045181274`*^6, 0.000055849552154541`],
								List[3.0198986530304`*^6, -0.0000689923763275146`],
								List[3.27155685424805`*^6, -0.0000619888305664063`],
								List[3.5232150554657`*^6, -0.0000162422657012939`],
								List[3.77487325668335`*^6, 0.000200778245925903`],
								List[4.02653169631958`*^6, 0.0000444650650024414`]],
								List["Microseconds", IndependentUnit["ArbitraryUnits"]],
								List[List[1], List[2]]]]]], List[Quantity[124.`, "Seconds"],
					QuantityArray[
						StructuredArray`StructuredData[List[169, 2],
							List[List[List[0.959999965743918`, 0.931967973709106`],
								List[1.4400000054592998`, 0.917745232582092`],
								List[1.9199999314878398`, 0.906011700630188`],
								List[2.3999998575163803`, 0.894229531288147`],
								List[2.88000001091859`, 0.884944081306458`],
								List[3.35999993694713`, 0.87378454208374`],
								List[3.83999986297567`, 0.863392353057861`],
								List[4.31999978900421`, 0.852535009384155`],
								List[4.79999971503275`, 0.840465903282166`],
								List[5.2799996410612895`, 0.830764532089233`],
								List[5.7600000218371905`, 0.817638158798218`],
								List[6.23999994786573`, 0.808859944343567`],
								List[6.71999987389427`, 0.799604415893555`],
								List[7.19999979992281`, 0.788437962532043`],
								List[7.679999725951349`, 0.780597925186157`],
								List[8.63999957800843`, 0.760871410369873`],
								List[9.59999943006551`, 0.741307616233826`],
								List[10.5599992821226`, 0.722451448440552`],
								List[11.519999134179699`, 0.706193923950195`],
								List[12.4799989862368`, 0.687937140464783`],
								List[13.4399988382938`, 0.671664714813232`],
								List[14.3999986903509`, 0.654752135276794`],
								List[15.359999451902699`, 0.638802170753479`],
								List[17.2799991560169`, 0.606809139251709`],
								List[19.199998860131`, 0.577598571777344`],
								List[21.1199985642452`, 0.549280881881714`],
								List[23.0399982683593`, 0.522085011005402`],
								List[24.9599979724735`, 0.49766618013382`],
								List[26.8799976765877`, 0.473897844552994`],
								List[28.7999973807018`, 0.450857639312744`],
								List[30.719998903805397`, 0.428731590509415`],
								List[34.5599983120337`, 0.388491243124008`],
								List[38.399997720262`, 0.350900202989578`],
								List[42.2399971284904`, 0.319517314434052`],
								List[46.0799965367187`, 0.289851248264313`],
								List[49.919995944947`, 0.26257136464119`],
								List[53.7599953531753`, 0.237019509077072`],
								List[57.5999947614037`, 0.216149508953094`],
								List[61.439997807610794`, 0.195392549037933`],
								List[69.1199966240674`, 0.162770301103592`],
								List[76.7999954405241`, 0.134426027536392`],
								List[84.4799942569807`, 0.111328631639481`],
								List[92.1599930734374`, 0.0921371877193451`],
								List[99.839991889894`, 0.0762020945549011`],
								List[107.51999070635101`, 0.0630223751068115`],
								List[115.199989522807`, 0.053194522857666`],
								List[122.879995615222`, 0.0438688993453979`],
								List[138.239993248135`, 0.0311204493045807`],
								List[153.599990881048`, 0.022867739200592`],
								List[168.959988513961`, 0.0170402526855469`],
								List[184.319986146875`, 0.0127385258674622`],
								List[199.679983779788`, 0.00962388515472412`],
								List[215.03998141270102`, 0.00731605291366577`],
								List[230.399979045615`, 0.00574412941932678`],
								List[245.759991230443`, 0.00357721745967865`],
								List[276.47998649627`, 0.00126937031745911`],
								List[307.199981762096`, -0.00103798508644104`],
								List[337.919977027923`, -0.00103583931922913`],
								List[368.639972293749`, 0.0000251978635787964`],
								List[399.359967559576`, -0.00048549473285675`],
								List[430.079962825403`, 0.00154677033424377`],
								List[460.799958091229`, 0.00281175971031189`],
								List[491.519982460886`, 0.00233741104602814`],
								List[552.959972992539`, 0.000268757343292236`],
								List[614.399963524193`, -0.000874534249305725`],
								List[675.839954055846`, -0.00146426260471344`],
								List[737.279944587499`, -0.000760212540626526`],
								List[798.719935119152`, -0.00147764384746552`],
								List[860.159925650805`, -0.00268863141536713`],
								List[921.599916182458`, -0.00140856206417084`],
								List[983.039964921772`, -0.000265732407569885`],
								List[1105.91994598508`, 0.00056767463684082`],
								List[1228.79992704839`, -0.000212520360946655`],
								List[1351.6799081116899`, 0.000705495476722717`],
								List[1474.559889175`, 0.000320062041282654`],
								List[1597.4398702383`, -0.000743329524993896`],
								List[1720.31985130161`, -0.000642836093902588`],
								List[1843.19983236492`, -0.000493720173835754`],
								List[1966.0799298435402`, -0.00124745070934296`],
								List[2211.83989197016`, 0.000195026397705078`],
								List[2457.59985409677`, -0.000707104802131653`],
								List[2703.3598162233798`, 0.000427395105361938`],
								List[2949.11977835`, 0.000170528888702393`],
								List[3194.87974047661`, -0.000456780195236206`],
								List[3440.63970260322`, -0.0000748038291931152`],
								List[3686.39966472983`, -0.00027938187122345`],
								List[3932.15985968709`, 0.00191783905029297`],
								List[4423.67978394032`, -0.001005619764328`],
								List[4915.19970819354`, 0.00121435523033142`],
								List[5406.71963244677`, 0.000173196196556091`],
								List[5898.23955669999`, 0.000416070222854614`],
								List[6389.75948095322`, 0.00071994960308075`],
								List[6881.27940520644`, 0.000261962413787842`],
								List[7372.79932945967`, -0.0000134855508804321`],
								List[7864.31971937418`, -0.000720083713531494`],
								List[8847.35956788063`, -0.000113368034362793`],
								List[9830.39941638708`, 0.00014793872833252`],
								List[10813.4392648935`, 0.000696346163749695`],
								List[11796.4791134`, 0.000823646783828735`],
								List[12779.5189619064`, 0.000773116946220398`],
								List[13762.5588104129`, 0.0000804513692855835`],
								List[14745.5986589193`, -0.000555962324142456`],
								List[15728.639438748402`, 0.000373616814613342`],
								List[17694.719135761297`, 0.000791937112808228`],
								List[19660.7988327742`, -0.000165805220603943`],
								List[21626.8785297871`, -0.000349506735801697`],
								List[23592.9582268`, -0.000478357076644897`],
								List[25559.037923812903`, 0.000120982527732849`],
								List[27525.1176208258`, -0.000458747148513794`],
								List[29491.1973178387`, 0.000862032175064087`],
								List[31457.278877496698`, -0.000468388199806213`],
								List[35389.4382715225`, -0.0000339746475219727`],
								List[39321.597665548295`, 0.000138983130455017`],
								List[43253.7570595741`, 0.000126510858535767`],
								List[47185.9164535999`, -0.000136032700538635`],
								List[51118.075847625696`, 0.00013694167137146`],
								List[55050.2352416515`, 0.000161007046699524`],
								List[58982.3946356773`, 0.00014282763004303`],
								List[62914.557754993395`, -0.0000961571931838989`],
								List[70778.876543045`, -0.00011676549911499`],
								List[78643.19533109659`, -0.000234261155128479`],
								List[86507.5141191483`, 0.0000375658273696899`],
								List[94371.8329071999`, -0.00034661591053009`],
								List[102236.15169525101`, 0.0000337958335876465`],
								List[110100.470483303`, -0.000203236937522888`],
								List[117964.789271355`, -0.000226885080337524`],
								List[125829.115509987`, 0.000132083892822266`],
								List[141557.75308609`, -0.000103309750556946`],
								List[157286.390662193`, -0.000117763876914978`],
								List[173015.028238297`, -0.000152215361595154`],
								List[188743.6658144`, -0.0000356435775756836`],
								List[204472.30339050302`, 0.0000627785921096802`],
								List[220200.940966606`, 0.000113680958747864`],
								List[235929.578542709`, -0.0000457316637039185`],
								List[251658.231019974`, 0.0000638365745544434`],
								List[283115.50617218`, -0.000253066420555115`],
								List[314572.781324387`, -0.000219434499740601`],
								List[346030.056476593`, 0.000137478113174438`],
								List[377487.331628799`, 0.000126466155052185`],
								List[408944.60678100603`, -0.0000549852848052979`],
								List[440401.881933212`, 0.0000167787075042725`],
								List[471859.157085419`, -0.0000770241022109985`],
								List[503316.462039948`, -0.0000710338354110718`],
								List[566231.01234436`, 0.0000683367252349854`],
								List[629145.562648773`, -0.000105619430541992`],
								List[692060.112953186`, 0.0000274330377578735`],
								List[754974.663257599`, -0.0000402927398681641`],
								List[817889.2135620121`, -3.68058681488037`*^-6],
								List[880803.763866425`, -0.0000192821025848389`],
								List[943718.3141708369`, 0.0000306218862533569`],
								List[1.0066329240798999`*^6, 0.000066027045249939`],
								List[1.13246202468872`*^6, -0.0000520944595336914`],
								List[1.2582911252975499`*^6, -0.0000110864639282227`],
								List[1.38412022590637`*^6, -0.0000277161598205566`],
								List[1.5099493265152`*^6, 0.0000165551900863647`],
								List[1.6357784271240202`*^6, 8.73208045959473`*^-6],
								List[1.76160752773285`*^6, -0.0000633150339126587`],
								List[1.88743662834167`*^6, 0.0000202059745788574`],
								List[2.01326584815979`*^6, 0.0000942647457122803`],
								List[2.26492404937744`*^6, 0.0000132322311401367`],
								List[2.51658225059509`*^6, 0.0000193864107131958`],
								List[2.76824045181274`*^6, -0.0000499188899993896`],
								List[3.0198986530304`*^6, 0.0000386536121368408`],
								List[3.27155685424805`*^6, 0.0000428557395935059`],
								List[3.5232150554657`*^6, -0.00005379319190979`],
								List[3.77487325668335`*^6, 0.000038832426071167`],
								List[4.02653169631958`*^6, 7.30156898498535`*^-6],
								List[4.52984809875488`*^6, 2.05636024475098`*^-6],
								List[5.03316450119019`*^6, 0.`]],
								List["Microseconds", IndependentUnit["ArbitraryUnits"]],
								List[List[1], List[2]]]]]], List[Quantity[248.`, "Seconds"],
					QuantityArray[
						StructuredArray`StructuredData[List[167, 2],
							List[List[List[0.959999965743918`, 0.938516139984131`],
								List[1.4400000054592998`, 0.925134420394897`],
								List[1.9199999314878398`, 0.910788655281067`],
								List[2.3999998575163803`, 0.901083469390869`],
								List[2.88000001091859`, 0.889120936393738`],
								List[3.35999993694713`, 0.879334807395935`],
								List[3.83999986297567`, 0.86749529838562`],
								List[4.31999978900421`, 0.855719387531281`],
								List[4.79999971503275`, 0.845801830291748`],
								List[5.2799996410612895`, 0.836490392684937`],
								List[5.7600000218371905`, 0.826598286628723`],
								List[6.23999994786573`, 0.812942802906036`],
								List[6.71999987389427`, 0.806196987628937`],
								List[7.19999979992281`, 0.795762062072754`],
								List[7.679999725951349`, 0.785014271736145`],
								List[8.63999957800843`, 0.764319896697998`],
								List[9.59999943006551`, 0.748905181884766`],
								List[10.5599992821226`, 0.728536009788513`],
								List[11.519999134179699`, 0.713140249252319`],
								List[12.4799989862368`, 0.692272663116455`],
								List[13.4399988382938`, 0.676580190658569`],
								List[14.3999986903509`, 0.66067761182785`],
								List[15.359999451902699`, 0.642931818962097`],
								List[17.2799991560169`, 0.61270272731781`],
								List[19.199998860131`, 0.584197998046875`],
								List[21.1199985642452`, 0.556398153305054`],
								List[23.0399982683593`, 0.528916835784912`],
								List[24.9599979724735`, 0.504184365272522`],
								List[26.8799976765877`, 0.47982582449913`],
								List[28.7999973807018`, 0.457299292087555`],
								List[30.719998903805397`, 0.435313940048218`],
								List[34.5599983120337`, 0.395873039960861`],
								List[38.399997720262`, 0.359571129083633`],
								List[42.2399971284904`, 0.32656866312027`],
								List[46.0799965367187`, 0.296649932861328`],
								List[49.919995944947`, 0.268304973840714`],
								List[53.7599953531753`, 0.2437464594841`],
								List[57.5999947614037`, 0.220865219831467`],
								List[61.439997807610794`, 0.200857371091843`],
								List[69.1199966240674`, 0.1667200922966`],
								List[76.7999954405241`, 0.137992739677429`],
								List[84.4799942569807`, 0.113849401473999`],
								List[92.1599930734374`, 0.0948211550712585`],
								List[99.839991889894`, 0.0789753794670105`],
								List[107.51999070635101`, 0.0658400058746338`],
								List[115.199989522807`, 0.0548237860202789`],
								List[122.879995615222`, 0.0463317036628723`],
								List[138.239993248135`, 0.0331570208072662`],
								List[153.599990881048`, 0.0234626233577728`],
								List[168.959988513961`, 0.0172070860862732`],
								List[184.319986146875`, 0.0113196671009064`],
								List[199.679983779788`, 0.00779062509536743`],
								List[215.03998141270102`, 0.00439217686653137`],
								List[230.399979045615`, 0.00261940062046051`],
								List[245.759991230443`, 0.001813605427742`],
								List[276.47998649627`, 0.000105679035186768`],
								List[307.199981762096`, -0.000973045825958252`],
								List[337.919977027923`, -0.0000123381614685059`],
								List[368.639972293749`, 0.000129088759422302`],
								List[399.359967559576`, 0.00021827220916748`],
								List[430.079962825403`, -0.00166212022304535`],
								List[460.799958091229`, -0.00204627215862274`],
								List[491.519982460886`, -0.000927925109863281`],
								List[552.959972992539`, -0.000674203038215637`],
								List[614.399963524193`, -0.00116840004920959`],
								List[675.839954055846`, 0.000186607241630554`],
								List[737.279944587499`, 0.000597298145294189`],
								List[798.719935119152`, 0.00056140124797821`],
								List[860.159925650805`, 0.00204938650131226`],
								List[921.599916182458`, 0.00189010798931122`],
								List[983.039964921772`, 0.00165165960788727`],
								List[1105.91994598508`, 0.00371247529983521`],
								List[1228.79992704839`, 0.00167256593704224`],
								List[1351.6799081116899`, 0.000268027186393738`],
								List[1474.559889175`, -0.00199609994888306`],
								List[1597.4398702383`, -0.001691535115242`],
								List[1720.31985130161`, -0.000840157270431519`],
								List[1843.19983236492`, 0.00203660130500793`],
								List[1966.0799298435402`, 0.00151205062866211`],
								List[2211.83989197016`, -0.000128567218780518`],
								List[2457.59985409677`, -0.000738486647605896`],
								List[2703.3598162233798`, -0.000317409634590149`],
								List[2949.11977835`, 0.0000544488430023193`],
								List[3194.87974047661`, 0.00162029266357422`],
								List[3440.63970260322`, 0.000184327363967896`],
								List[3686.39966472983`, 0.000610172748565674`],
								List[3932.15985968709`, -0.000839933753013611`],
								List[4423.67978394032`, -0.0013614147901535`],
								List[4915.19970819354`, -0.000613987445831299`],
								List[5406.71963244677`, 0.00049474835395813`],
								List[5898.23955669999`, 0.00106310844421387`],
								List[6389.75948095322`, -0.00104901194572449`],
								List[6881.27940520644`, -0.000562340021133423`],
								List[7372.79932945967`, -0.00059199333190918`],
								List[7864.31971937418`, 0.000668138265609741`],
								List[8847.35956788063`, -0.00010383129119873`],
								List[9830.39941638708`, -0.000624552369117737`],
								List[10813.4392648935`, -0.000942006707191467`],
								List[11796.4791134`, -0.00068490207195282`],
								List[12779.5189619064`, -0.000728294253349304`],
								List[13762.5588104129`, 0.00064966082572937`],
								List[14745.5986589193`, 0.000468477606773376`],
								List[15728.639438748402`, -0.000432908535003662`],
								List[17694.719135761297`, 0.000506222248077393`],
								List[19660.7988327742`, 0.000904291868209839`],
								List[21626.8785297871`, -0.000183209776878357`],
								List[23592.9582268`, 0.000418320298194885`],
								List[25559.037923812903`, 0.000809192657470703`],
								List[27525.1176208258`, -0.000631034374237061`],
								List[29491.1973178387`, 0.000673249363899231`],
								List[31457.278877496698`, -0.000265032052993774`],
								List[35389.4382715225`, -0.000380963087081909`],
								List[39321.597665548295`, -0.000143229961395264`],
								List[43253.7570595741`, 0.000152677297592163`],
								List[47185.9164535999`, -0.0000268518924713135`],
								List[51118.075847625696`, -0.000459492206573486`],
								List[55050.2352416515`, -0.0000625699758529663`],
								List[58982.3946356773`, 0.000279903411865234`],
								List[62914.557754993395`, 0.000317513942718506`],
								List[70778.876543045`, 0.0000713467597961426`],
								List[78643.19533109659`, 0.0000738203525543213`],
								List[86507.5141191483`, -0.0000808537006378174`],
								List[94371.8329071999`, 0.000417962670326233`],
								List[102236.15169525101`, -0.000108838081359863`],
								List[110100.470483303`, -0.0000661760568618774`],
								List[117964.789271355`, -0.000243797898292542`],
								List[125829.115509987`, 0.0000323653221130371`],
								List[141557.75308609`, 0.0000385493040084839`],
								List[157286.390662193`, -0.0000187307596206665`],
								List[173015.028238297`, 0.000289395451545715`],
								List[188743.6658144`, 0.000249519944190979`],
								List[204472.30339050302`, 0.000219985842704773`],
								List[220200.940966606`, -0.000157430768013`],
								List[235929.578542709`, 0.0000431239604949951`],
								List[251658.231019974`, 0.000187739729881287`],
								List[283115.50617218`, -0.000140443444252014`],
								List[314572.781324387`, 0.0000271350145339966`],
								List[346030.056476593`, 0.000198692083358765`],
								List[377487.331628799`, 0.0000394880771636963`],
								List[408944.60678100603`, -0.000212147831916809`],
								List[440401.881933212`, -0.0000881552696228027`],
								List[471859.157085419`, -0.0000148415565490723`],
								List[503316.462039948`, -0.000130847096443176`],
								List[566231.01234436`, 0.0000869333744049072`],
								List[629145.562648773`, -0.000151023268699646`],
								List[692060.112953186`, 0.0000232160091400146`],
								List[754974.663257599`, 0.000115111470222473`],
								List[817889.2135620121`, -0.0000665187835693359`],
								List[880803.763866425`, 0.0000228434801101685`],
								List[943718.3141708369`, -0.000035211443901062`],
								List[1.0066329240798999`*^6, -0.0000875294208526611`],
								List[1.13246202468872`*^6, -0.0000375509262084961`],
								List[1.2582911252975499`*^6, -0.000131741166114807`],
								List[1.38412022590637`*^6, -0.0000571757555007935`],
								List[1.5099493265152`*^6, -0.0000245273113250732`],
								List[1.6357784271240202`*^6, -0.0000624656677246094`],
								List[1.76160752773285`*^6, -0.0000431686639785767`],
								List[1.88743662834167`*^6, -0.0000707358121871948`],
								List[2.01326584815979`*^6, -0.0000493526458740234`],
								List[2.26492404937744`*^6, 0.0000586211681365967`],
								List[2.51658225059509`*^6, 4.4703483581543`*^-6],
								List[2.76824045181274`*^6, -0.0000713765621185303`],
								List[3.0198986530304`*^6, -7.76350498199463`*^-6],
								List[3.27155685424805`*^6, 0.0000271499156951904`],
								List[3.5232150554657`*^6, -0.0000140070915222168`],
								List[3.77487325668335`*^6, -0.0000968575477600098`],
								List[4.02653169631958`*^6, 0.000140964984893799`]],
								List["Microseconds", IndependentUnit["ArbitraryUnits"]],
								List[List[1], List[2]]]]]], List[Quantity[372.`, "Seconds"],
					QuantityArray[
						StructuredArray`StructuredData[List[167, 2],
							List[List[List[0.959999965743918`, 0.935422003269196`],
								List[1.4400000054592998`, 0.923949480056763`],
								List[1.9199999314878398`, 0.912831544876099`],
								List[2.3999998575163803`, 0.897453308105469`],
								List[2.88000001091859`, 0.886930406093597`],
								List[3.35999993694713`, 0.880356073379517`],
								List[3.83999986297567`, 0.868727445602417`],
								List[4.31999978900421`, 0.855857253074646`],
								List[4.79999971503275`, 0.844621241092682`],
								List[5.2799996410612895`, 0.835177183151245`],
								List[5.7600000218371905`, 0.824960112571716`],
								List[6.23999994786573`, 0.815291881561279`],
								List[6.71999987389427`, 0.804163992404938`],
								List[7.19999979992281`, 0.794397115707397`],
								List[7.679999725951349`, 0.784331798553467`],
								List[8.63999957800843`, 0.765124797821045`],
								List[9.59999943006551`, 0.744362950325012`],
								List[10.5599992821226`, 0.728747129440308`],
								List[11.519999134179699`, 0.710041046142578`],
								List[12.4799989862368`, 0.692408919334412`],
								List[13.4399988382938`, 0.6763516664505`],
								List[14.3999986903509`, 0.659357905387878`],
								List[15.359999451902699`, 0.642781257629395`],
								List[17.2799991560169`, 0.611983835697174`],
								List[19.199998860131`, 0.581684589385986`],
								List[21.1199985642452`, 0.553354740142822`],
								List[23.0399982683593`, 0.52699887752533`],
								List[24.9599979724735`, 0.500799238681793`],
								List[26.8799976765877`, 0.47693994641304`],
								List[28.7999973807018`, 0.4540855884552`],
								List[30.719998903805397`, 0.433281242847443`],
								List[34.5599983120337`, 0.392959266901016`],
								List[38.399997720262`, 0.355992138385773`],
								List[42.2399971284904`, 0.323427975177765`],
								List[46.0799965367187`, 0.294081300497055`],
								List[49.919995944947`, 0.267641127109528`],
								List[53.7599953531753`, 0.243131101131439`],
								List[57.5999947614037`, 0.22065070271492`],
								List[61.439997807610794`, 0.200572818517685`],
								List[69.1199966240674`, 0.165514439344406`],
								List[76.7999954405241`, 0.138296961784363`],
								List[84.4799942569807`, 0.115142673254013`],
								List[92.1599930734374`, 0.0966555774211884`],
								List[99.839991889894`, 0.0807349681854248`],
								List[107.51999070635101`, 0.0677318871021271`],
								List[115.199989522807`, 0.0563293695449829`],
								List[122.879995615222`, 0.0467411875724792`],
								List[138.239993248135`, 0.0340576171875`],
								List[153.599990881048`, 0.0247701108455658`],
								List[168.959988513961`, 0.0182806551456451`],
								List[184.319986146875`, 0.0125307440757751`],
								List[199.679983779788`, 0.00931432843208313`],
								List[215.03998141270102`, 0.00710737705230713`],
								List[230.399979045615`, 0.00525090098381042`],
								List[245.759991230443`, 0.00408235192298889`],
								List[276.47998649627`, 0.0018317699432373`],
								List[307.199981762096`, -0.00111797451972961`],
								List[337.919977027923`, -0.00156927108764648`],
								List[368.639972293749`, -0.000865176320075989`],
								List[399.359967559576`, -0.000239044427871704`],
								List[430.079962825403`, -0.000674828886985779`],
								List[460.799958091229`, -0.000720053911209106`],
								List[491.519982460886`, -0.000155806541442871`],
								List[552.959972992539`, -0.000271528959274292`],
								List[614.399963524193`, 0.00032217800617218`],
								List[675.839954055846`, -0.000226199626922607`],
								List[737.279944587499`, -0.000623837113380432`],
								List[798.719935119152`, -0.000475645065307617`],
								List[860.159925650805`, -0.000428661704063416`],
								List[921.599916182458`, -4.69386577606201`*^-6],
								List[983.039964921772`, -0.00197023153305054`],
								List[1105.91994598508`, -0.00118088722229004`],
								List[1228.79992704839`, -0.00165529549121857`],
								List[1351.6799081116899`, 0.000660493969917297`],
								List[1474.559889175`, -0.00080929696559906`],
								List[1597.4398702383`, -0.00127196311950684`],
								List[1720.31985130161`, 0.0000413358211517334`],
								List[1843.19983236492`, 0.000302165746688843`],
								List[1966.0799298435402`, 0.000425711274147034`],
								List[2211.83989197016`, -0.000371992588043213`],
								List[2457.59985409677`, -0.00034940242767334`],
								List[2703.3598162233798`, 0.00078427791595459`],
								List[2949.11977835`, -0.000821352005004883`],
								List[3194.87974047661`, -0.000708132982254028`],
								List[3440.63970260322`, 0.000163793563842773`],
								List[3686.39966472983`, 0.000500157475471497`],
								List[3932.15985968709`, -0.000410884618759155`],
								List[4423.67978394032`, -0.000875070691108704`],
								List[4915.19970819354`, -0.000352561473846436`],
								List[5406.71963244677`, -0.000246718525886536`],
								List[5898.23955669999`, -0.00014922022819519`],
								List[6389.75948095322`, -0.000812053680419922`],
								List[6881.27940520644`, 0.000934094190597534`],
								List[7372.79932945967`, -0.000117972493171692`],
								List[7864.31971937418`, -0.000912636518478394`],
								List[8847.35956788063`, 0.000100776553153992`],
								List[9830.39941638708`, -0.000188305974006653`],
								List[10813.4392648935`, 0.000867977738380432`],
								List[11796.4791134`, 0.00018860399723053`],
								List[12779.5189619064`, 0.0000331848859786987`],
								List[13762.5588104129`, -0.000220641493797302`],
								List[14745.5986589193`, 0.000877469778060913`],
								List[15728.639438748402`, 0.000239104032516479`],
								List[17694.719135761297`, 0.000215679407119751`],
								List[19660.7988327742`, 0.000522494316101074`],
								List[21626.8785297871`, -0.000159546732902527`],
								List[23592.9582268`, 0.00107726454734802`],
								List[25559.037923812903`, 0.000839918851852417`],
								List[27525.1176208258`, -0.000581115484237671`],
								List[29491.1973178387`, -0.000518262386322021`],
								List[31457.278877496698`, -0.000102519989013672`],
								List[35389.4382715225`, -0.000297784805297852`],
								List[39321.597665548295`, -0.0000668615102767944`],
								List[43253.7570595741`, -0.000267192721366882`],
								List[47185.9164535999`, -0.000100091099739075`],
								List[51118.075847625696`, -0.000172629952430725`],
								List[55050.2352416515`, -0.000346720218658447`],
								List[58982.3946356773`, 0.000513046979904175`],
								List[62914.557754993395`, -0.000553920865058899`],
								List[70778.876543045`, -0.000209137797355652`],
								List[78643.19533109659`, 0.000203132629394531`],
								List[86507.5141191483`, -0.000397965312004089`],
								List[94371.8329071999`, 0.000369325280189514`],
								List[102236.15169525101`, -0.000302761793136597`],
								List[110100.470483303`, 0.000112235546112061`],
								List[117964.789271355`, -0.000466614961624146`],
								List[125829.115509987`, -0.000269234180450439`],
								List[141557.75308609`, -0.000257819890975952`],
								List[157286.390662193`, 0.000101909041404724`],
								List[173015.028238297`, 0.000129953026771545`],
								List[188743.6658144`, 0.0000489354133605957`],
								List[204472.30339050302`, 0.0000926703214645386`],
								List[220200.940966606`, -0.0000317990779876709`],
								List[235929.578542709`, 0.000150635838508606`],
								List[251658.231019974`, 0.0000593513250350952`],
								List[283115.50617218`, 0.000162720680236816`],
								List[314572.781324387`, 5.379319190979`*^-6],
								List[346030.056476593`, -0.0000459104776382446`],
								List[377487.331628799`, 0.0000368803739547729`],
								List[408944.60678100603`, 4.93228435516357`*^-6],
								List[440401.881933212`, -0.000115096569061279`],
								List[471859.157085419`, 0.000061333179473877`],
								List[503316.462039948`, -0.0000889748334884644`],
								List[566231.01234436`, 0.0000283867120742798`],
								List[629145.562648773`, -0.0000345855951309204`],
								List[692060.112953186`, -0.0000254064798355103`],
								List[754974.663257599`, 0.0000135600566864014`],
								List[817889.2135620121`, -0.0000811368227005005`],
								List[880803.763866425`, -0.0000663399696350098`],
								List[943718.3141708369`, 0.000126108527183533`],
								List[1.0066329240798999`*^6, -0.0000798851251602173`],
								List[1.13246202468872`*^6, 5.00679016113281`*^-6],
								List[1.2582911252975499`*^6, 0.0000102818012237549`],
								List[1.38412022590637`*^6, -0.000129058957099915`],
								List[1.5099493265152`*^6, 8.65757465362549`*^-6],
								List[1.6357784271240202`*^6, -0.0000106692314147949`],
								List[1.76160752773285`*^6, -0.0000465661287307739`],
								List[1.88743662834167`*^6, 0.0000179409980773926`],
								List[2.01326584815979`*^6, -0.000210747122764587`],
								List[2.26492404937744`*^6, -0.000027090311050415`],
								List[2.51658225059509`*^6, 0.0000291317701339722`],
								List[2.76824045181274`*^6, 0.0000620782375335693`],
								List[3.0198986530304`*^6, -0.0000625699758529663`],
								List[3.27155685424805`*^6, -0.0000884532928466797`],
								List[3.5232150554657`*^6, 0.0000346153974533081`],
								List[3.77487325668335`*^6, 0.0000263303518295288`],
								List[4.02653169631958`*^6, 0.0000412464141845703`]],
								List["Microseconds", IndependentUnit["ArbitraryUnits"]],
								List[List[1], List[2]]]]]], List[Quantity[496.`, "Seconds"],
					QuantityArray[
						StructuredArray`StructuredData[List[167, 2],
							List[List[List[0.959999965743918`, 0.931388735771179`],
								List[1.4400000054592998`, 0.923573553562164`],
								List[1.9199999314878398`, 0.90945303440094`],
								List[2.3999998575163803`, 0.89384400844574`],
								List[2.88000001091859`, 0.884498596191406`],
								List[3.35999993694713`, 0.872532248497009`],
								List[3.83999986297567`, 0.861618220806122`],
								List[4.31999978900421`, 0.850242972373962`],
								List[4.79999971503275`, 0.839010715484619`],
								List[5.2799996410612895`, 0.827587485313416`],
								List[5.7600000218371905`, 0.818952798843384`],
								List[6.23999994786573`, 0.809958934783936`],
								List[6.71999987389427`, 0.798640489578247`],
								List[7.19999979992281`, 0.789798140525818`],
								List[7.679999725951349`, 0.781314730644226`],
								List[8.63999957800843`, 0.762359321117401`],
								List[9.59999943006551`, 0.742951154708862`],
								List[10.5599992821226`, 0.72311794757843`],
								List[11.519999134179699`, 0.707543015480042`],
								List[12.4799989862368`, 0.688711643218994`],
								List[13.4399988382938`, 0.672142148017883`],
								List[14.3999986903509`, 0.654680132865906`],
								List[15.359999451902699`, 0.64000403881073`],
								List[17.2799991560169`, 0.610291242599487`],
								List[19.199998860131`, 0.579645752906799`],
								List[21.1199985642452`, 0.552627801895142`],
								List[23.0399982683593`, 0.527569890022278`],
								List[24.9599979724735`, 0.502775907516479`],
								List[26.8799976765877`, 0.476659864187241`],
								List[28.7999973807018`, 0.454938799142838`],
								List[30.719998903805397`, 0.433997750282288`],
								List[34.5599983120337`, 0.393579095602036`],
								List[38.399997720262`, 0.356704443693161`],
								List[42.2399971284904`, 0.32512041926384`],
								List[46.0799965367187`, 0.295797526836395`],
								List[49.919995944947`, 0.268973052501678`],
								List[53.7599953531753`, 0.243782609701157`],
								List[57.5999947614037`, 0.222487360239029`],
								List[61.439997807610794`, 0.201873689889908`],
								List[69.1199966240674`, 0.167835593223572`],
								List[76.7999954405241`, 0.139592409133911`],
								List[84.4799942569807`, 0.116386085748672`],
								List[92.1599930734374`, 0.0965680778026581`],
								List[99.839991889894`, 0.0801920592784882`],
								List[107.51999070635101`, 0.066668301820755`],
								List[115.199989522807`, 0.0557710528373718`],
								List[122.879995615222`, 0.0469519793987274`],
								List[138.239993248135`, 0.0341377854347229`],
								List[153.599990881048`, 0.0259662270545959`],
								List[168.959988513961`, 0.0191333293914795`],
								List[184.319986146875`, 0.0150167644023895`],
								List[199.679983779788`, 0.0111905634403229`],
								List[215.03998141270102`, 0.00851860642433167`],
								List[230.399979045615`, 0.00600007176399231`],
								List[245.759991230443`, 0.00413382053375244`],
								List[276.47998649627`, 0.00280508399009705`],
								List[307.199981762096`, 0.00193449854850769`],
								List[337.919977027923`, 0.000348553061485291`],
								List[368.639972293749`, -0.00175662338733673`],
								List[399.359967559576`, -0.0033707320690155`],
								List[430.079962825403`, -0.00300264358520508`],
								List[460.799958091229`, -0.00173018872737885`],
								List[491.519982460886`, -0.000512853264808655`],
								List[552.959972992539`, 0.0000579655170440674`],
								List[614.399963524193`, 0.000650674104690552`],
								List[675.839954055846`, -0.0000301003456115723`],
								List[737.279944587499`, -0.000990048050880432`],
								List[798.719935119152`, -0.00144165754318237`],
								List[860.159925650805`, -0.0000634044408798218`],
								List[921.599916182458`, 0.000976935029029846`],
								List[983.039964921772`, 0.000525236129760742`],
								List[1105.91994598508`, 0.00110851228237152`],
								List[1228.79992704839`, -0.000384882092475891`],
								List[1351.6799081116899`, -0.000205904245376587`],
								List[1474.559889175`, -0.000130102038383484`],
								List[1597.4398702383`, -0.0011238157749176`],
								List[1720.31985130161`, -0.00223056972026825`],
								List[1843.19983236492`, -0.00300818681716919`],
								List[1966.0799298435402`, -0.000759243965148926`],
								List[2211.83989197016`, 0.000278323888778687`],
								List[2457.59985409677`, -0.000732168555259705`],
								List[2703.3598162233798`, -0.000153854489326477`],
								List[2949.11977835`, 0.000275149941444397`],
								List[3194.87974047661`, 0.00066511332988739`],
								List[3440.63970260322`, 0.000273913145065308`],
								List[3686.39966472983`, 0.000618904829025269`],
								List[3932.15985968709`, -0.0000477135181427002`],
								List[4423.67978394032`, 0.000583872199058533`],
								List[4915.19970819354`, -0.0000947117805480957`],
								List[5406.71963244677`, 0.000252082943916321`],
								List[5898.23955669999`, 0.000339791178703308`],
								List[6389.75948095322`, 0.000476047396659851`],
								List[6881.27940520644`, -0.000795260071754456`],
								List[7372.79932945967`, 0.000266164541244507`],
								List[7864.31971937418`, -0.00023999810218811`],
								List[8847.35956788063`, 0.000512778759002686`],
								List[9830.39941638708`, -0.000473380088806152`],
								List[10813.4392648935`, 0.000230804085731506`],
								List[11796.4791134`, -0.00035075843334198`],
								List[12779.5189619064`, -0.000516295433044434`],
								List[13762.5588104129`, 0.000674471259117126`],
								List[14745.5986589193`, 0.000647664070129395`],
								List[15728.639438748402`, -0.000271901488304138`],
								List[17694.719135761297`, -0.000392526388168335`],
								List[19660.7988327742`, -0.000413358211517334`],
								List[21626.8785297871`, 0.000783741474151611`],
								List[23592.9582268`, -0.0000458955764770508`],
								List[25559.037923812903`, -0.00027930736541748`],
								List[27525.1176208258`, -0.0000641345977783203`],
								List[29491.1973178387`, 0.00077114999294281`],
								List[31457.278877496698`, 0.0000914633274078369`],
								List[35389.4382715225`, -0.000153630971908569`],
								List[39321.597665548295`, -0.000039517879486084`],
								List[43253.7570595741`, -0.000238969922065735`],
								List[47185.9164535999`, 0.00015103816986084`],
								List[51118.075847625696`, 0.000245332717895508`],
								List[55050.2352416515`, -0.0000127106904983521`],
								List[58982.3946356773`, 0.000133901834487915`],
								List[62914.557754993395`, 0.000535964965820313`],
								List[70778.876543045`, 0.0000616312026977539`],
								List[78643.19533109659`, 0.0000877231359481812`],
								List[86507.5141191483`, 0.0000762790441513062`],
								List[94371.8329071999`, 0.000372782349586487`],
								List[102236.15169525101`, -0.00016079843044281`],
								List[110100.470483303`, -0.0000660866498947144`],
								List[117964.789271355`, -0.000152692198753357`],
								List[125829.115509987`, 0.000147536396980286`],
								List[141557.75308609`, 0.000111043453216553`],
								List[157286.390662193`, -0.000144720077514648`],
								List[173015.028238297`, -0.000164806842803955`],
								List[188743.6658144`, 0.0000132918357849121`],
								List[204472.30339050302`, 0.0000642538070678711`],
								List[220200.940966606`, 0.000175029039382935`],
								List[235929.578542709`, 0.0000254958868026733`],
								List[251658.231019974`, -0.000166863203048706`],
								List[283115.50617218`, -0.000356823205947876`],
								List[314572.781324387`, 0.000117272138595581`],
								List[346030.056476593`, -0.0000369846820831299`],
								List[377487.331628799`, -0.0000839382410049438`],
								List[408944.60678100603`, -0.000096544623374939`],
								List[440401.881933212`, -0.0000699013471603394`],
								List[471859.157085419`, 0.000129073858261108`],
								List[503316.462039948`, -0.0000829100608825684`],
								List[566231.01234436`, -0.0000652670860290527`],
								List[629145.562648773`, 0.0000790506601333618`],
								List[692060.112953186`, -0.0000784248113632202`],
								List[754974.663257599`, -0.0000676959753036499`],
								List[817889.2135620121`, -0.0000150054693222046`],
								List[880803.763866425`, -0.0000197440385818481`],
								List[943718.3141708369`, 0.000163346529006958`],
								List[1.0066329240798999`*^6, -0.0001048743724823`],
								List[1.13246202468872`*^6, 0.0000851452350616455`],
								List[1.2582911252975499`*^6, -0.0000386983156204224`],
								List[1.38412022590637`*^6, 0.000066608190536499`],
								List[1.5099493265152`*^6, -0.0000702738761901855`],
								List[1.6357784271240202`*^6, -0.0000795871019363403`],
								List[1.76160752773285`*^6, -0.0000378787517547607`],
								List[1.88743662834167`*^6, 0.0000273734331130981`],
								List[2.01326584815979`*^6, 0.0000241994857788086`],
								List[2.26492404937744`*^6, -0.0000268071889877319`],
								List[2.51658225059509`*^6, 0.0000395774841308594`],
								List[2.76824045181274`*^6, -0.0000603795051574707`],
								List[3.0198986530304`*^6, 0.000037848949432373`],
								List[3.27155685424805`*^6, 0.0000282973051071167`],
								List[3.5232150554657`*^6, 5.76674938201904`*^-6],
								List[3.77487325668335`*^6, 0.0000337213277816772`],
								List[4.02653169631958`*^6, 0.0000438094139099121`]],
								List["Microseconds", IndependentUnit["ArbitraryUnits"]],
								List[List[1], List[2]]]]]]]
			|>;
			
			Upload[myTestProtocolDLS];
			Upload[myTestDataDLS];
		]
	},

	SymbolTearDown:>{
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	}

];
