(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: pavanshah *)
(* :Date: 2023-02-17 *)
DefineTests[
	WatchProtocol,
	{
		Example[{Basic, "Watch a protocol stream:"},
			WatchProtocol[Object[Protocol, "id:abc"]],
			Null,
			Stubs :> {
				WatchProtocol[Object[Protocol, "id:abc"]]  = Null
			}
		],
		Example[{Basic, "Watch a stream from an instrument:"},
			WatchProtocol[Object[Instrument, "id:abc"]],
			Null,
			Stubs :> {
				WatchProtocol[Object[Instrument, "id:abc"]] = Null
			}
		],
		Example[{Basic, "Watch a stream, but start from a particular second offset:"},
            WatchProtocol[Object[Stream, "id:abc"], 100],
            Null,
            Stubs :> {
                WatchProtocol[Object[Stream, "id:abc"], 100] = Null
            }
        ],
		Example[{Additional, "Watch a stream from a stream object:"},
			WatchProtocol[Object[Stream, "id:abc"]],
			Null,
			Stubs :> {
				WatchProtocol[Object[Stream, "id:abc"]] = Null
			}
		],
		Example[{Messages, "StreamNotFound", "Returns $Failed if no stream associated with the protocol:"},
			WatchProtocol[protocol],
			$Failed,
			Messages :> {Message[WatchProtocol::StreamNotFound]},
			Variables :> {protocol},
			SetUp :> {
				protocol = Upload[<|Type -> Object[Protocol]|>]
			}
		],
		Example[{Messages, "CannotOffset", "Returns $Failed if no video associated with the stream using offset:"},
            WatchProtocol[stream, 100],
            $Failed,
            Messages :> {Message[WatchProtocol::CannotOffset]},
            Variables :> {stream},
            SetUp :> {
                stream = Upload[<|Type -> Object[Stream]|>]
            }
        ]
	}
];


(* ::Subsection:: *)
(*getStreamObjectFromIncubationProtocol*)

DefineTests[getStreamObjectFromIncubationProtocol,
	{
		Example[{Basic,"Check if correct stream can be returned:"},
			getStreamObjectFromIncubationProtocol[Object[Protocol, Incubate, "Test Incubation protocol 1 for getStreamObjectFromIncubationProtocol "<>$SessionUUID]],
			ObjectP[Object[Stream, "Test stream 1 for getStreamObjectFromIncubationProtocol "<>$SessionUUID]],
			Stubs :> {
				CurrentIterations[Object[Protocol, Incubate, "Test Incubation protocol 1 for getStreamObjectFromIncubationProtocol "<>$SessionUUID]]:={Field[CurrentIncubationParameters] -> 1}
			}
		],
		Example[{Basic,"Check if correct stream can be returned:"},
			getStreamObjectFromIncubationProtocol[Object[Protocol, Incubate, "Test Incubation protocol 1 for getStreamObjectFromIncubationProtocol "<>$SessionUUID]],
			ObjectP[Object[Stream, "Test stream 2 for getStreamObjectFromIncubationProtocol "<>$SessionUUID]],
			Stubs :> {
				CurrentIterations[Object[Protocol, Incubate, "Test Incubation protocol 1 for getStreamObjectFromIncubationProtocol "<>$SessionUUID]]:={Field[CurrentIncubationParameters] -> 2}
			}
		],
		Example[{Basic,"If we have multiple streams corresponding to one stirrer, return the last one:"},
			getStreamObjectFromIncubationProtocol[Object[Protocol, Incubate, "Test Incubation protocol 2 for getStreamObjectFromIncubationProtocol "<>$SessionUUID]],
			ObjectP[Object[Stream, "Test stream 4 for getStreamObjectFromIncubationProtocol "<>$SessionUUID]],
			Stubs :> {
				CurrentIterations[Object[Protocol, Incubate, "Test Incubation protocol 2 for getStreamObjectFromIncubationProtocol "<>$SessionUUID]]:={Field[CurrentIncubationParameters] -> 2}
			}
		],
		Example[{Messages, "StreamNotFound", "If we cannot find the stream corresponding to the target stirrer camera, throw an error:"},
			getStreamObjectFromIncubationProtocol[Object[Protocol, Incubate, "Test Incubation protocol 2 for getStreamObjectFromIncubationProtocol "<>$SessionUUID]],
			$Failed,
			Stubs :> {CurrentIterations[Object[Protocol, Incubate, "Test Incubation protocol 2 for getStreamObjectFromIncubationProtocol "<>$SessionUUID]] := {Field[CurrentIncubationParameters] -> 1}},
			Messages :> {WatchProtocol::StreamNotFound}
		]
	},
	SymbolSetUp :> {
		Module[{allObjects, existingObjects},
			allObjects = {
				Object[Protocol, Incubate, "Test Incubation protocol 1 for getStreamObjectFromIncubationProtocol "<>$SessionUUID],
				Object[Protocol, Incubate, "Test Incubation protocol 2 for getStreamObjectFromIncubationProtocol "<>$SessionUUID],
				Object[Instrument, OverheadStirrer, "Test Stirrer 1 for getStreamObjectFromIncubationProtocol "<>$SessionUUID],
				Object[Instrument, OverheadStirrer, "Test Stirrer 2 for getStreamObjectFromIncubationProtocol "<>$SessionUUID],
				Object[Part, Computer, "Test PC 1 for getStreamObjectFromIncubationProtocol "<>$SessionUUID],
				Object[Part, Computer, "Test PC 2 for getStreamObjectFromIncubationProtocol "<>$SessionUUID],
				Object[Stream, "Test stream 1 for getStreamObjectFromIncubationProtocol "<>$SessionUUID],
				Object[Stream, "Test stream 2 for getStreamObjectFromIncubationProtocol "<>$SessionUUID],
				Object[Stream, "Test stream 3 for getStreamObjectFromIncubationProtocol "<>$SessionUUID],
				Object[Stream, "Test stream 4 for getStreamObjectFromIncubationProtocol "<>$SessionUUID]
			};
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects], True];
			EraseObject[existingObjects, Force -> True, Verbose -> False]
		];
		Module[{incubationProtocol1, incubationProtocol2, stirrer1, stirrer2, pc1, pc2, stream1, stream2, stream3, stream4, linkIDs$},

			{
				incubationProtocol1,
				incubationProtocol2,
				stirrer1,
				stirrer2,
				pc1,
				pc2,
				stream1,
				stream2,
				stream3,
				stream4
			} = CreateID[{
				Object[Protocol, Incubate],
				Object[Protocol, Incubate],
				Object[Instrument, OverheadStirrer],
				Object[Instrument, OverheadStirrer],
				Object[Part, Computer],
				Object[Part, Computer],
				Object[Stream],
				Object[Stream],
				Object[Stream],
				Object[Stream]
			}];

			linkIDs$=CreateLinkID[6];

			Upload[{
				<|
					Object -> incubationProtocol1,
					Name -> "Test Incubation protocol 1 for getStreamObjectFromIncubationProtocol "<>$SessionUUID,
					Replace[CurrentIncubationParameters] -> {
						<|
							Instrument -> Link[stirrer1],
							Time -> Quantity[15.`, "Minutes"],
							MaxTime -> Null,
							Rate -> Quantity[525.`, ("Revolutions")/("Minutes")],
							InstrumentRate -> Null,
							MixUntilDissolved -> False,
							Temperature -> Quantity[25.`, "DegreesCelsius"],
							ResidualIncubation -> False,
							AnnealingTime -> Quantity[0.`, "Minutes"],
							Impeller -> Link[Object[Part, StirrerShaft, "id:4pO6dMml59b5"]],
							Horn -> Null,
							Amplitude -> Null,
							DutyCycleOnTime -> Null,
							DutyCycleOffTime -> Null,
							MaxTemperature -> Null,
							OscillationAngle -> Null,
							TemperatureProfile -> Null,
							MixRateProfile -> Null,
							PlateSeal -> Null,
							ShakerAdapter -> Null,
							StirBarRetriever -> Null,
							MethodFile -> Null,
							StirBar -> Null,
							RelativeHumidity -> Null,
							LightExposure -> Null,
							LightExposureIntensity -> Null,
							TotalLightExposure -> Null,
							Transform -> Null,
							TransformHeatShockTemperature -> Null,
							TransformHeatShockTime -> Null,
							TransformPreHeatCoolingTime -> Null,
							TransformPostHeatCoolingTime -> Null,
							BatchedSampleIndices -> Null,
							RollerRacks -> Null,
							SamplePlacements -> Null,
							SecondaryShakerAdapter -> Null,
							TertiaryShakerAdapter -> Null,
							QuaternaryShakerAdapter -> Null,
							SonicationAdapter -> Null,
							PreSonicationTime -> Null|>,
						<|Instrument -> Link[stirrer2],
							Time -> Quantity[15.`, "Minutes"],
							MaxTime -> Null,
							Rate -> Quantity[525.`, ("Revolutions")/("Minutes")],
							InstrumentRate -> Null,
							MixUntilDissolved -> False,
							Temperature -> Quantity[25.`, "DegreesCelsius"],
							ResidualIncubation -> False,
							AnnealingTime -> Quantity[0.`, "Minutes"],
							Impeller -> Link[Object[Part, StirrerShaft, "id:pZx9joOP87ln"]],
							Horn -> Null,
							Amplitude -> Null,
							DutyCycleOnTime -> Null,
							DutyCycleOffTime -> Null,
							MaxTemperature -> Null,
							OscillationAngle -> Null,
							TemperatureProfile -> Null,
							MixRateProfile -> Null,
							PlateSeal -> Null,
							ShakerAdapter -> Null,
							StirBarRetriever -> Null,
							MethodFile -> Null,
							StirBar -> Null,
							RelativeHumidity -> Null,
							LightExposure -> Null,
							LightExposureIntensity -> Null,
							TotalLightExposure -> Null,
							Transform -> Null,
							TransformHeatShockTemperature -> Null,
							TransformHeatShockTime -> Null,
							TransformPreHeatCoolingTime -> Null,
							TransformPostHeatCoolingTime -> Null,
							BatchedSampleIndices -> Null,
							RollerRacks -> Null,
							SamplePlacements -> Null,
							SecondaryShakerAdapter -> Null,
							TertiaryShakerAdapter -> Null,
							QuaternaryShakerAdapter -> Null,
							SonicationAdapter -> Null,
							PreSonicationTime -> Null
						|>},
					Replace[Streams] -> {Link[stream1, Protocol,linkIDs$[[1]]], Link[stream2, Protocol, linkIDs$[[2]]]}
				|>,
				<|
					Object -> incubationProtocol2,
					Name -> "Test Incubation protocol 2 for getStreamObjectFromIncubationProtocol "<>$SessionUUID,
					Replace[CurrentIncubationParameters] -> {
						<|
							Instrument -> Link[stirrer1],
							Time -> Quantity[15.`, "Minutes"],
							MaxTime -> Null,
							Rate -> Quantity[525.`, ("Revolutions")/("Minutes")],
							InstrumentRate -> Null,
							MixUntilDissolved -> False,
							Temperature -> Quantity[25.`, "DegreesCelsius"],
							ResidualIncubation -> False,
							AnnealingTime -> Quantity[0.`, "Minutes"],
							Impeller -> Link[Object[Part, StirrerShaft, "id:4pO6dMml59b5"]],
							Horn -> Null,
							Amplitude -> Null,
							DutyCycleOnTime -> Null,
							DutyCycleOffTime -> Null,
							MaxTemperature -> Null,
							OscillationAngle -> Null,
							TemperatureProfile -> Null,
							MixRateProfile -> Null,
							PlateSeal -> Null,
							ShakerAdapter -> Null,
							StirBarRetriever -> Null,
							MethodFile -> Null,
							StirBar -> Null,
							RelativeHumidity -> Null,
							LightExposure -> Null,
							LightExposureIntensity -> Null,
							TotalLightExposure -> Null,
							Transform -> Null,
							TransformHeatShockTemperature -> Null,
							TransformHeatShockTime -> Null,
							TransformPreHeatCoolingTime -> Null,
							TransformPostHeatCoolingTime -> Null,
							BatchedSampleIndices -> Null,
							RollerRacks -> Null,
							SamplePlacements -> Null,
							SecondaryShakerAdapter -> Null,
							TertiaryShakerAdapter -> Null,
							QuaternaryShakerAdapter -> Null,
							SonicationAdapter -> Null,
							PreSonicationTime -> Null|>,
						<|Instrument -> Link[stirrer2],
							Time -> Quantity[15.`, "Minutes"], MaxTime -> Null,
							Rate -> Quantity[525.`, ("Revolutions")/("Minutes")],
							InstrumentRate -> Null, MixUntilDissolved -> False,
							Temperature -> Quantity[25.`, "DegreesCelsius"],
							ResidualIncubation -> False,
							AnnealingTime -> Quantity[0.`, "Minutes"],
							Impeller -> Link[Object[Part, StirrerShaft, "id:pZx9joOP87ln"]],
							Horn -> Null, Amplitude -> Null, DutyCycleOnTime -> Null,
							DutyCycleOffTime -> Null, MaxTemperature -> Null,
							OscillationAngle -> Null, TemperatureProfile -> Null,
							MixRateProfile -> Null, PlateSeal -> Null, ShakerAdapter -> Null,
							StirBarRetriever -> Null, MethodFile -> Null, StirBar -> Null,
							RelativeHumidity -> Null, LightExposure -> Null,
							LightExposureIntensity -> Null, TotalLightExposure -> Null,
							Transform -> Null, TransformHeatShockTemperature -> Null,
							TransformHeatShockTime -> Null, TransformPreHeatCoolingTime -> Null,
							TransformPostHeatCoolingTime -> Null,
							BatchedSampleIndices -> Null,
							RollerRacks -> Null,
							SamplePlacements -> Null,
							SecondaryShakerAdapter -> Null,
							TertiaryShakerAdapter -> Null,
							QuaternaryShakerAdapter -> Null,
							SonicationAdapter -> Null,
							PreSonicationTime -> Null
						|>},
					Replace[Streams] -> {Link[stream3, Protocol,linkIDs$[[3]]], Link[stream4, Protocol, linkIDs$[[4]]]}
				|>,
				<|
					Object -> stirrer1,
					VideoCaptureComputer -> Link[pc1, Instruments,linkIDs$[[5]]],
					Name -> "Test Stirrer 1 for getStreamObjectFromIncubationProtocol "<>$SessionUUID
				|>,
				<|
					Object -> stirrer2,
					VideoCaptureComputer-> Link[pc2, Instruments, linkIDs$[[6]]],
					Name -> "Test Stirrer 2 for getStreamObjectFromIncubationProtocol "<>$SessionUUID
				|>,
				<|
					Object -> pc1,
					Replace[Instruments] -> {Link[stirrer1, VideoCaptureComputer, linkIDs$[[5]]]},
					Name -> "Test PC 1 for getStreamObjectFromIncubationProtocol "<>$SessionUUID
				|>,
				<|
					Object -> pc2,
					Replace[Instruments] -> {Link[stirrer2, VideoCaptureComputer, linkIDs$[[6]]]},
					Name -> "Test PC 2 for getStreamObjectFromIncubationProtocol "<>$SessionUUID
				|>,
				<|
					Object -> stream1,
					VideoCaptureComputer -> Link[pc1],
					Protocol -> Link[incubationProtocol1, Streams, linkIDs$[[1]]],
					Name -> "Test stream 1 for getStreamObjectFromIncubationProtocol "<>$SessionUUID
				|>,
				<|
					Object -> stream2,
				  VideoCaptureComputer -> Link[pc2],
					Protocol -> Link[incubationProtocol1, Streams, linkIDs$[[2]]],
					Name -> "Test stream 2 for getStreamObjectFromIncubationProtocol "<>$SessionUUID
				|>,
				<|
					Object -> stream3,
					VideoCaptureComputer -> Link[pc2],
					Protocol -> Link[incubationProtocol2, Streams, linkIDs$[[3]]],
					Name -> "Test stream 3 for getStreamObjectFromIncubationProtocol "<>$SessionUUID
				|>,
				<|
					Object -> stream4,
					VideoCaptureComputer -> Link[pc2],
					Protocol -> Link[incubationProtocol2, Streams, linkIDs$[[4]]],
					Name -> "Test stream 4 for getStreamObjectFromIncubationProtocol "<>$SessionUUID
				|>
			}];

		]
	},
	SymbolTearDown :> {
		Module[{allObjects, existingObjects},
			allObjects = {
				allObjects = {
					Object[Protocol, Incubate, "Test Incubation protocol 1 for getStreamObjectFromIncubationProtocol "<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubation protocol 2 for getStreamObjectFromIncubationProtocol "<>$SessionUUID],
					Object[Instrument, OverheadStirrer, "Test Stirrer 1 for getStreamObjectFromIncubationProtocol "<>$SessionUUID],
					Object[Instrument, OverheadStirrer, "Test Stirrer 2 for getStreamObjectFromIncubationProtocol "<>$SessionUUID],
					Object[Part, Computer, "Test PC 1 for getStreamObjectFromIncubationProtocol "<>$SessionUUID],
					Object[Part, Computer, "Test PC 2 for getStreamObjectFromIncubationProtocol "<>$SessionUUID],
					Object[Stream, "Test stream 1 for getStreamObjectFromIncubationProtocol "<>$SessionUUID],
					Object[Stream, "Test stream 2 for getStreamObjectFromIncubationProtocol "<>$SessionUUID],
					Object[Stream, "Test stream 3 for getStreamObjectFromIncubationProtocol "<>$SessionUUID],
					Object[Stream, "Test stream 4 for getStreamObjectFromIncubationProtocol "<>$SessionUUID]

				};
			};
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects], True];
			EraseObject[existingObjects, Force -> True, Verbose -> False]
		]
	},
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		$EmailEnabled = False,
		$PublicPath = $TemporaryDirectory
	}
]

(* ::Subsection:: *)
(*getStreamObjectFromProtocol*)

DefineTests[getStreamObjectFromProtocol,
	{
		Example[{Basic,"Check if we enter the current branch when given incubation protocol:"},
			getStreamObjectFromProtocol[Object[Protocol, Incubate, "Test Incubation protocol for getStreamObjectFromProtocol "<>$SessionUUID]],
			ObjectP[Object[Stream, "Test stream 1 for getStreamObjectFromProtocol "<>$SessionUUID]],
			Stubs :> {
				CurrentIterations[Object[Protocol, Incubate, "Test Incubation protocol for getStreamObjectFromProtocol "<>$SessionUUID]]:={Field[CurrentIncubationParameters] -> 1}
			}
		],
		Example[{Basic,"Check if we enter the current branch when given protocol is not incubation protocol:"},
			getStreamObjectFromProtocol[Object[Protocol, AdjustpH, "Test AdjustpH protocol for getStreamObjectFromProtocol "<>$SessionUUID]],
			ObjectP[Object[Stream, "Test stream 4 for getStreamObjectFromProtocol "<>$SessionUUID]]
		],

		Example[{Messages, "StreamNotFound", "If we cannot find the stream throw an error:"},
			getStreamObjectFromProtocol[Object[Protocol, AdjustpH, "Test AdjustpH protocol 2 for getStreamObjectFromProtocol "<>$SessionUUID]],
			$Failed,
			Messages :> {WatchProtocol::StreamNotFound}
		]
	},
	SymbolSetUp :> {
		Module[{allObjects, existingObjects},
			allObjects = {
				Object[Protocol, Incubate, "Test Incubation protocol for getStreamObjectFromProtocol "<>$SessionUUID],
				Object[Protocol, AdjustpH, "Test AdjustpH protocol for getStreamObjectFromProtocol "<>$SessionUUID],
				Object[Protocol, AdjustpH, "Test AdjustpH protocol 2 for getStreamObjectFromProtocol "<>$SessionUUID],
				Object[Instrument, OverheadStirrer, "Test Stirrer 1 for getStreamObjectFromProtocol "<>$SessionUUID],
				Object[Instrument, OverheadStirrer, "Test Stirrer 2 for getStreamObjectFromProtocol "<>$SessionUUID],
				Object[Part, Computer, "Test PC 1 for getStreamObjectFromProtocol "<>$SessionUUID],
				Object[Part, Computer, "Test PC 2 for getStreamObjectFromProtocol "<>$SessionUUID],
				Object[Stream, "Test stream 1 for getStreamObjectFromProtocol "<>$SessionUUID],
				Object[Stream, "Test stream 2 for getStreamObjectFromProtocol "<>$SessionUUID],
				Object[Stream, "Test stream 3 for getStreamObjectFromProtocol "<>$SessionUUID],
				Object[Stream, "Test stream 4 for getStreamObjectFromProtocol "<>$SessionUUID]
			};
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects], True];
			EraseObject[existingObjects, Force -> True, Verbose -> False]
		];
		Module[{incubationProtocol1, adjustpHProtocol1, adjustpHProtocol2, stirrer1, stirrer2, pc1, pc2, stream1, stream2, stream3, stream4, linkIDs$},

			{
				incubationProtocol1,
				adjustpHProtocol1,
				adjustpHProtocol2,
				stirrer1,
				stirrer2,
				pc1,
				pc2,
				stream1,
				stream2,
				stream3,
				stream4
			} = CreateID[{
				Object[Protocol, Incubate],
				Object[Protocol, AdjustpH],
				Object[Protocol, AdjustpH],
				Object[Instrument, OverheadStirrer],
				Object[Instrument, OverheadStirrer],
				Object[Part, Computer],
				Object[Part, Computer],
				Object[Stream],
				Object[Stream],
				Object[Stream],
				Object[Stream]
			}];

			linkIDs$=CreateLinkID[6];

			Upload[{
				<|
					Object -> incubationProtocol1,
					Name -> "Test Incubation protocol for getStreamObjectFromProtocol "<>$SessionUUID,
					Replace[CurrentIncubationParameters] -> {
						<|
							Instrument -> Link[stirrer1],
							Time -> Quantity[15.`, "Minutes"],
							MaxTime -> Null,
							Rate -> Quantity[525.`, ("Revolutions")/("Minutes")],
							InstrumentRate -> Null,
							MixUntilDissolved -> False,
							Temperature -> Quantity[25.`, "DegreesCelsius"],
							ResidualIncubation -> False,
							AnnealingTime -> Quantity[0.`, "Minutes"],
							Impeller -> Link[Object[Part, StirrerShaft, "id:4pO6dMml59b5"]],
							Horn -> Null,
							Amplitude -> Null,
							DutyCycleOnTime -> Null,
							DutyCycleOffTime -> Null,
							MaxTemperature -> Null,
							OscillationAngle -> Null,
							TemperatureProfile -> Null,
							MixRateProfile -> Null,
							PlateSeal -> Null,
							ShakerAdapter -> Null,
							StirBarRetriever -> Null,
							MethodFile -> Null,
							StirBar -> Null,
							RelativeHumidity -> Null,
							LightExposure -> Null,
							LightExposureIntensity -> Null,
							TotalLightExposure -> Null,
							Transform -> Null,
							TransformHeatShockTemperature -> Null,
							TransformHeatShockTime -> Null,
							TransformPreHeatCoolingTime -> Null,
							TransformPostHeatCoolingTime -> Null,
							BatchedSampleIndices -> Null,
							RollerRacks -> Null,
							SamplePlacements -> Null,
							SecondaryShakerAdapter -> Null,
							TertiaryShakerAdapter -> Null,
							QuaternaryShakerAdapter -> Null,
							SonicationAdapter -> Null,
							PreSonicationTime -> Null|>,
						<|Instrument -> Link[stirrer2],
							Time -> Quantity[15.`, "Minutes"],
							MaxTime -> Null,
							Rate -> Quantity[525.`, ("Revolutions")/("Minutes")],
							InstrumentRate -> Null,
							MixUntilDissolved -> False,
							Temperature -> Quantity[25.`, "DegreesCelsius"],
							ResidualIncubation -> False,
							AnnealingTime -> Quantity[0.`, "Minutes"],
							Impeller -> Link[Object[Part, StirrerShaft, "id:pZx9joOP87ln"]],
							Horn -> Null,
							Amplitude -> Null,
							DutyCycleOnTime -> Null,
							DutyCycleOffTime -> Null,
							MaxTemperature -> Null,
							OscillationAngle -> Null,
							TemperatureProfile -> Null,
							MixRateProfile -> Null,
							PlateSeal -> Null,
							ShakerAdapter -> Null,
							StirBarRetriever -> Null,
							MethodFile -> Null,
							StirBar -> Null,
							RelativeHumidity -> Null,
							LightExposure -> Null,
							LightExposureIntensity -> Null,
							TotalLightExposure -> Null,
							Transform -> Null,
							TransformHeatShockTemperature -> Null,
							TransformHeatShockTime -> Null,
							TransformPreHeatCoolingTime -> Null,
							TransformPostHeatCoolingTime -> Null,
							BatchedSampleIndices -> Null,
							RollerRacks -> Null,
							SamplePlacements -> Null,
							SecondaryShakerAdapter -> Null,
							TertiaryShakerAdapter -> Null,
							QuaternaryShakerAdapter -> Null,
							SonicationAdapter -> Null,
							PreSonicationTime -> Null
						|>},
					Replace[Streams] -> {Link[stream1, Protocol,linkIDs$[[1]]], Link[stream2, Protocol, linkIDs$[[2]]]}
				|>,
				<|
					Object -> stirrer1,
					VideoCaptureComputer -> Link[pc1, Instruments,linkIDs$[[5]]],
					Name -> "Test Stirrer 1 for getStreamObjectFromProtocol "<>$SessionUUID
				|>,
				<|
					Object -> stirrer2,
					VideoCaptureComputer-> Link[pc2, Instruments, linkIDs$[[6]]],
					Name -> "Test Stirrer 2 for getStreamObjectFromProtocol "<>$SessionUUID
				|>,
				<|
					Object -> pc1,
					Replace[Instruments] -> {Link[stirrer1, VideoCaptureComputer, linkIDs$[[5]]]},
					Name -> "Test PC 1 for getStreamObjectFromProtocol "<>$SessionUUID
				|>,
				<|
					Object -> pc2,
					Replace[Instruments] -> {Link[stirrer2, VideoCaptureComputer, linkIDs$[[6]]]},
					Name -> "Test PC 2 for getStreamObjectFromProtocol "<>$SessionUUID
				|>,
				<|
					Object -> stream1,
					VideoCaptureComputer -> Link[pc1],
					Protocol -> Link[incubationProtocol1, Streams, linkIDs$[[1]]],
					Name -> "Test stream 1 for getStreamObjectFromProtocol "<>$SessionUUID
				|>,
				<|
					Object -> stream2,
					VideoCaptureComputer -> Link[pc2],
					Protocol -> Link[incubationProtocol1, Streams, linkIDs$[[2]]],
					Name -> "Test stream 2 for getStreamObjectFromProtocol "<>$SessionUUID
				|>,

				<|
					Object -> adjustpHProtocol1,
					Name -> "Test AdjustpH protocol for getStreamObjectFromProtocol "<>$SessionUUID,
					Replace[Streams] -> {Link[stream3, Protocol,linkIDs$[[3]]], Link[stream4, Protocol, linkIDs$[[4]]]}
				|>,
				<|
					Object -> stream3,
					VideoCaptureComputer -> Link[pc1],
					Protocol -> Link[adjustpHProtocol1, Streams, linkIDs$[[3]]],
					Name -> "Test stream 3 for getStreamObjectFromProtocol "<>$SessionUUID
				|>,
				<|
					Object -> stream4,
					VideoCaptureComputer -> Link[pc2],
					Protocol -> Link[adjustpHProtocol1, Streams, linkIDs$[[4]]],
					Name -> "Test stream 4 for getStreamObjectFromProtocol "<>$SessionUUID
				|>,

				<|
					Object -> adjustpHProtocol2,
					Name -> "Test AdjustpH protocol 2 for getStreamObjectFromProtocol "<>$SessionUUID,
					Replace[Streams] -> {}
				|>
			}];

		]
	},
	SymbolTearDown :> {
		Module[{allObjects, existingObjects},
			allObjects = {
				allObjects = {
					Object[Protocol, Incubate, "Test Incubation protocol for getStreamObjectFromProtocol "<>$SessionUUID],
					Object[Protocol, AdjustpH, "Test AdjustpH protocol for getStreamObjectFromProtocol "<>$SessionUUID],
					Object[Protocol, AdjustpH, "Test AdjustpH protocol 2 for getStreamObjectFromProtocol "<>$SessionUUID],
					Object[Instrument, OverheadStirrer, "Test Stirrer 1 for getStreamObjectFromProtocol "<>$SessionUUID],
					Object[Instrument, OverheadStirrer, "Test Stirrer 2 for getStreamObjectFromProtocol "<>$SessionUUID],
					Object[Part, Computer, "Test PC 1 for getStreamObjectFromProtocol "<>$SessionUUID],
					Object[Part, Computer, "Test PC 2 for getStreamObjectFromProtocol "<>$SessionUUID],
					Object[Stream, "Test stream 1 for getStreamObjectFromProtocol "<>$SessionUUID],
					Object[Stream, "Test stream 2 for getStreamObjectFromProtocol "<>$SessionUUID],
					Object[Stream, "Test stream 3 for getStreamObjectFromProtocol "<>$SessionUUID],
					Object[Stream, "Test stream 4 for getStreamObjectFromProtocol "<>$SessionUUID]

				};
			};
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects], True];
			EraseObject[existingObjects, Force -> True, Verbose -> False]
		]
	},
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		$EmailEnabled = False,
		$PublicPath = $TemporaryDirectory
	}
]