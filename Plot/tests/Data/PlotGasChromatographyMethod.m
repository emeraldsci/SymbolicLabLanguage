(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotGasChromatographyMethod*)

DefineTests[
	PlotGasChromatographyMethod,
	{
		Example[{Basic,"Plot the values of the setiings stored in a gas chromatography method:"},
			PlotGasChromatographyMethod[Object[Method,GasChromatography,"Test SeparationMethod for PlotGasChromatographyMethod"<>$SessionUUID]],
			_TableForm
		],
		Example[{Options, Legend, "Add a legend:"},
			PlotGasChromatographyMethod[Object[Method,GasChromatography,"Test SeparationMethod for PlotGasChromatographyMethod"<>$SessionUUID], Legend->{"my method"}],
			_TableForm
		],
		Example[{Options,PlotRange,"Look at a subset of the full range:"},
			PlotGasChromatographyMethod[Object[Method,GasChromatography,"Test SeparationMethod for PlotGasChromatographyMethod"<>$SessionUUID],PlotRange->{{5,10Minute},{0,500Celsius}}],
			_TableForm
		]
	},
	SymbolSetUp:>(
		(*module for deleting created objects*)
		Module[{objects, existingObjects},
			objects={
				Object[Method,GasChromatography,"Test SeparationMethod for PlotGasChromatographyMethod"<>$SessionUUID]
			};

			existingObjects = PickList[objects, DatabaseMemberQ[#]&/@objects];
			EraseObject[existingObjects, Force -> True, Verbose -> False]

		];
		(*module for creating objects*)
		Module[{methodPackets},

			methodPackets = {
				Association[
					Type -> Object[Method, GasChromatography],
					Name -> "Test SeparationMethod for PlotGasChromatographyMethod"<>$SessionUUID,
					CarrierGas -> Helium,
					Replace[ColumnDiameter] -> {Quantity[0.32, "Millimeters"]},
					Replace[ColumnFilmThickness] -> {Quantity[0.25, "Micrometers"]},
					ColumnFlowRateProfile -> ConstantFlowRate,
					Replace[ColumnLength] -> {Quantity[30., "Meters"]},
					Detector -> FlameIonizationDetector,
					DeveloperObject -> True,
					GasSaver -> True,
					GasSaverActivationTime -> Quantity[2., "Minutes"],
					GasSaverFlowRate -> Quantity[25., ("Milliliters")/("Minutes")],
					InitialColumnAverageVelocity -> Quantity[29.28, ("Centimeters")/("Seconds")],
					InitialColumnFlowRate -> Quantity[1.7, ("Milliliters")/("Minutes")],
					InitialColumnPressure -> Quantity[8.3385, ("PoundsForce")/("Inches")^2],
					InitialColumnResidenceTime -> Quantity[1.71, "Minutes"],
					InitialInletTemperature -> Quantity[275., "DegreesCelsius"],
					InitialOvenTemperature -> Quantity[50., "DegreesCelsius"],
					InitialOvenTemperatureDuration -> Quantity[3., "Minutes"],
					InletLinerVolume -> Quantity[870., "Microliters"],
					InletSeptumPurgeFlowRate -> Quantity[3., ("Milliliters")/("Minutes")],
					OvenEquilibrationTime -> Quantity[2., "Minutes"],
					Replace[OvenTemperatureProfile] -> {{Quantity[20, ("DegreesCelsius")/("Minutes")], Quantity[300., "DegreesCelsius"], Quantity[3, "Minutes"]}},
					PostRunFlowRate -> Quantity[1.7, ("Milliliters")/("Minutes")],
					SplitRatio -> 10.
				]
			};

			Upload[methodPackets];

		]

	),
	SymbolTearDown:>(
		Module[{objects, existingObjects},
			objects={
				Object[Method,GasChromatography,"Test SeparationMethod for PlotGasChromatographyMethod"]
			};

			existingObjects = PickList[objects, DatabaseMemberQ[#]&/@objects];
			EraseObject[existingObjects, Force -> True, Verbose -> False]

		]
	)
];