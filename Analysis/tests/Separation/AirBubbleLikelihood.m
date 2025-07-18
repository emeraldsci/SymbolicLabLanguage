(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Fractions: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*AnalyzeAirBubbleLikelihood*)


(* ::Subsubsection::Closed:: *)
(*AnalyzeAirBubbleLikelihood*)


DefineTests[
	AnalyzeAirBubbleLikelihood,
	If[TrueQ[$VersionNumber >= 13.2],
		(* AnalyzeAirBubbleLikelihood only works on MM 13.2 or higher *)
		{
			Example[
				{Basic, "Predicts the air bubble likelihood for one data object input:"},
				AnalyzeAirBubbleLikelihood[Object[Data, Chromatography, "AnalyzeAirBubbleLikelihood Test Data 1 " <> $SessionUUID]];
				Download[Object[Data, Chromatography, "AnalyzeAirBubbleLikelihood Test Data 1 " <> $SessionUUID],AirBubbleLikelihood],
				PercentP
			],
			Example[
				{Additional, "Predicts the air bubble likelihood for data object inputs:"},
				AnalyzeAirBubbleLikelihood[{Object[Data, Chromatography, "AnalyzeAirBubbleLikelihood Test Data 2 " <> $SessionUUID], Object[Data, ChromatographyMassSpectra, "AnalyzeAirBubbleLikelihood Test Data 3 " <> $SessionUUID]}];
				Download[{Object[Data, Chromatography, "AnalyzeAirBubbleLikelihood Test Data 2 " <> $SessionUUID], Object[Data, ChromatographyMassSpectra, "AnalyzeAirBubbleLikelihood Test Data 3 " <> $SessionUUID]},AirBubbleLikelihood],
				{PercentP,PercentP}
			],
			Example[
				{Additional, "Accepts input as pressure chromatograms:"},
				AnalyzeAirBubbleLikelihood[
					Download[
						{Object[Data, Chromatography, "AnalyzeAirBubbleLikelihood Test Data 2 " <> $SessionUUID], Object[Data, ChromatographyMassSpectra, "AnalyzeAirBubbleLikelihood Test Data 3 " <> $SessionUUID]},
						Pressure
					]
				],
				{PercentP,PercentP}
			],
			Example[
				{Additional, "Accepts input of pressure chromatograms with Nulls:"},
				AnalyzeAirBubbleLikelihood[
					{
						Download[
							Object[Data, Chromatography, "AnalyzeAirBubbleLikelihood Test Data 2 " <> $SessionUUID],
							Pressure
						],
						Null,
						Null,
						Download[
							Object[Data, ChromatographyMassSpectra, "AnalyzeAirBubbleLikelihood Test Data 3 " <> $SessionUUID],
							Pressure
						],
						Null
					}
				],
				{PercentP,Null,Null,PercentP,Null}
			],
			Example[
				{Additional, "Accepts input as pressure traces:"},
				AnalyzeAirBubbleLikelihood[
					Table[RandomReal[]*PSI, 1000]
				],
				PercentP
			],
			Example[
				{Options, Upload, "Returns packet when Upload->False:"},
				AnalyzeAirBubbleLikelihood[Object[Data, ChromatographyMassSpectra, "AnalyzeAirBubbleLikelihood Test Data 4 " <> $SessionUUID],Upload->False],
				<|Object->Download[Object[Data, ChromatographyMassSpectra, "AnalyzeAirBubbleLikelihood Test Data 4 " <> $SessionUUID],Object],AirBubbleLikelihood->PercentP|>
			],
			Example[
				{Options, Cache, "Returns packet when Upload->False:"},
				AnalyzeAirBubbleLikelihood[
					Object[Data, ChromatographyMassSpectra, "AnalyzeAirBubbleLikelihood Test Data 4 " <> $SessionUUID],
					Cache->{
						<|Object->Download[Object[Data, ChromatographyMassSpectra, "AnalyzeAirBubbleLikelihood Test Data 4 " <> $SessionUUID],Object],Pressure->Download[Object[Data, Chromatography, "AnalyzeAirBubbleLikelihood Test Data 1 " <> $SessionUUID],Pressure]|>
					}
				],
				ObjectP[Download[Object[Data, ChromatographyMassSpectra, "AnalyzeAirBubbleLikelihood Test Data 4 " <> $SessionUUID],Object]]
			],
			Example[
				{Messages, "NoPressureData", "Throw warning if there is no pressure trace for the single input data object:"},
				AnalyzeAirBubbleLikelihood[
					Object[Data, Chromatography, "AnalyzeAirBubbleLikelihood Test Data 5 " <> $SessionUUID]
				];
				Download[Object[Data, Chromatography, "AnalyzeAirBubbleLikelihood Test Data 5 " <> $SessionUUID],AirBubbleLikelihood],
				Null,
				Messages:>{
					Warning::NoPressureData
				}
			],
			Example[
				{Messages, "NoPressureData", "Throw warning if there are no pressure trace(s) for some of the input data objects and return the list of updated objects only:"},
				AnalyzeAirBubbleLikelihood[
					{
						Object[Data, ChromatographyMassSpectra, "AnalyzeAirBubbleLikelihood Test Data 4 " <> $SessionUUID],
						Object[Data, Chromatography, "AnalyzeAirBubbleLikelihood Test Data 5 " <> $SessionUUID]
					}
				],
				Download[
					{
						Object[Data, ChromatographyMassSpectra, "AnalyzeAirBubbleLikelihood Test Data 4 " <> $SessionUUID],
						Object[Data, Chromatography, "AnalyzeAirBubbleLikelihood Test Data 5 " <> $SessionUUID]
					},
					Object
				],
				Messages:>{
					Warning::NoPressureData
				}
			]
		},
		{
			Example[
				{Basic, "Predicts the air bubble likelihood for one data object input:"},
				AnalyzeAirBubbleLikelihood[Object[Data, Chromatography, "AnalyzeAirBubbleLikelihood Test Data 1 " <> $SessionUUID]];
				Download[Object[Data, Chromatography, "AnalyzeAirBubbleLikelihood Test Data 1 " <> $SessionUUID],AirBubbleLikelihood],
				Null
			]
		}
	],
	SymbolSetUp :> {
		ClearDownload[];
		Module[
			(*be sure that at least one model is non deprecated*)
			{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Data, Chromatography, "AnalyzeAirBubbleLikelihood Test Data 1 " <> $SessionUUID],
					Object[Data, Chromatography, "AnalyzeAirBubbleLikelihood Test Data 2 " <> $SessionUUID],
					Object[Data, ChromatographyMassSpectra, "AnalyzeAirBubbleLikelihood Test Data 3 " <> $SessionUUID],
					Object[Data, ChromatographyMassSpectra, "AnalyzeAirBubbleLikelihood Test Data 4 " <> $SessionUUID],
					Object[Data, Chromatography, "AnalyzeAirBubbleLikelihood Test Data 5 " <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];
		];

		Module[{referenceData, pressureData},

			(* Get the reference data *)
			referenceData = ToExpression@ImportCloudFile[
				EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "6c606ee1ab6a02bcd9f47c3bcaa9b427.txt", "BYDOjvGzeoRzuwNel3PD7Zqnc4npOB4A4Yqm"]
			];

			pressureData = Map[
				QuantityArray[RandomChoice[referenceData,#],{Minute,PSI}]&,
				{50,500,1000,3000}
			];

			Upload[
				MapThread[
					<|
						Type->#1,
						Name->#2,
						Replace[Pressure]->#3
					|>&,
					{
						{Object[Data, Chromatography], Object[Data, Chromatography], Object[Data, ChromatographyMassSpectra], Object[Data, ChromatographyMassSpectra]},
						{
							"AnalyzeAirBubbleLikelihood Test Data 1 " <> $SessionUUID,
							"AnalyzeAirBubbleLikelihood Test Data 2 " <> $SessionUUID,
							"AnalyzeAirBubbleLikelihood Test Data 3 " <> $SessionUUID,
							"AnalyzeAirBubbleLikelihood Test Data 4 " <> $SessionUUID
						},
						pressureData
					}
				]
			];

			Upload[
				<|
					Type->Object[Data, Chromatography],
					Name->"AnalyzeAirBubbleLikelihood Test Data 5 " <> $SessionUUID
				|>
			]
		];
	},
	SymbolTearDown :> {
		Module[
			(*be sure that at least one model is non deprecated*)
			{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Data, Chromatography, "AnalyzeAirBubbleLikelihood Test Data 1 " <> $SessionUUID],
					Object[Data, Chromatography, "AnalyzeAirBubbleLikelihood Test Data 2 " <> $SessionUUID],
					Object[Data, ChromatographyMassSpectra, "AnalyzeAirBubbleLikelihood Test Data 3 " <> $SessionUUID],
					Object[Data, ChromatographyMassSpectra, "AnalyzeAirBubbleLikelihood Test Data 4 " <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];
		];
	}
];


(* ::Section:: *)
(*End Test Package*)
