(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

(* ::Subsection::Closed:: *)
(*UploadSampleProperties*)

DefineTests[UploadSampleProperties,
	{
		Example[{Basic,"Update sample property fields with new, known, values:"},
			(
				UploadSampleProperties[
					Object[Sample,"UploadSampleProperties test sample 1"],
					Volume -> 100 Microliter,
					Concentration -> 100 Micromolar
				];
				Download[
					Object[Sample,"UploadSampleProperties test sample 1"],
					{Volume,VolumeLog,Concentration,ConcentrationLog}
				]
			),
			{
				_?((# == 100 Microliter)&),
				{{_DateObject,_?((# == 100 Microliter)&),LinkP[],ComputedVolume}},
				_?((# == 100 Micromolar)&),
				{{_DateObject,_?((# == 100 Micromolar)&),LinkP[]}}
			}
		],
		Example[{Basic,"Setting an option value to None indicates that the property field should be cleared to Null:"},
			Module[{populatedValue,clearedValue},

				UploadSampleProperties[
					Object[Sample,"UploadSampleProperties test sample 1"],
					Volume -> 100 Microliter
				];

				populatedValue = Download[Object[Sample,"UploadSampleProperties test sample 1"],Volume];

				UploadSampleProperties[
					Object[Sample,"UploadSampleProperties test sample 1"],
					Volume -> None
				];

				clearedValue = Download[Object[Sample,"UploadSampleProperties test sample 1"],Volume];

				{populatedValue,clearedValue}
			],
			{100 Microliter, Null},
			EquivalenceFunction :> Equal
		],
		Example[{Additional,"A list of samples can be set simultaneously:"},
			(
				UploadSampleProperties[
					{
						Object[Sample,"UploadSampleProperties test sample 1"],
						Object[Item,Tips,"UploadSampleProperties test sample 2"]
					},
					Volume -> {100 Microliter,Null},
					Count -> {Null, 100}
				];

				Download[
					{
						Object[Sample,"UploadSampleProperties test sample 1"],
						Object[Item,Tips,"UploadSampleProperties test sample 2"]
					},
					{Volume,Count}
				]
			),
			{
				{_?((#==100 Microliter)&), Null},
				{Null, 100}
			}
		],
		Example[{Options,Density,"Set the density of a sample:"},
			(
				UploadSampleProperties[
					Object[Sample,"UploadSampleProperties test sample 1"],
					Density -> 1 Gram/Milliliter
				];
				Download[Object[Sample,"UploadSampleProperties test sample 1"],Density]
			),
			1 Gram/Milliliter,
			EquivalenceFunction :> Equal
		],
		Example[{Options,pH,"Set the pH of a sample:"},
			(
				UploadSampleProperties[
					Object[Sample,"UploadSampleProperties test sample 1"],
					pH -> 3
				];
				Download[Object[Sample,"UploadSampleProperties test sample 1"],pH]
			),
			3,
			EquivalenceFunction :> Equal
		],
		Example[{Options,Concentration,"Set the Concentration of a sample:"},
			(
				UploadSampleProperties[
					Object[Sample,"UploadSampleProperties test sample 1"],
					Concentration -> 10 Nanomolar
				];
				Download[Object[Sample,"UploadSampleProperties test sample 1"],Concentration]
			),
			10 Nanomolar,
			EquivalenceFunction :> Equal
		],
		Example[{Options,MassConcentration,"Set the MassConcentration of a sample:"},
			(
				UploadSampleProperties[
					Object[Sample,"UploadSampleProperties test sample 1"],
					MassConcentration -> 1 Gram/Liter
				];
				Download[Object[Sample,"UploadSampleProperties test sample 1"],MassConcentration]
			),
			1 Gram/Liter,
			EquivalenceFunction :> Equal
		],
		Example[{Options,TotalProteinConcentration,"Set the TotalProteinConcentration of a sample:"},
			(
				UploadSampleProperties[
					Object[Sample,"UploadSampleProperties test sample 1"],
					TotalProteinConcentration -> 5*Milligram/Milliliter
				];
				Download[Object[Sample,"UploadSampleProperties test sample 1"],TotalProteinConcentration]
			),
			5*Milligram/Milliliter,
			EquivalenceFunction :> Equal
		],
		Example[{Options,Mass,"Set the Mass of a sample:"},
			(
				UploadSampleProperties[
					Object[Sample,"UploadSampleProperties test sample 1"],
					Mass -> 1 Gram
				];
				Download[Object[Sample,"UploadSampleProperties test sample 1"],Mass]
			),
			1 Gram,
			EquivalenceFunction :> Equal
		],
		Example[{Options,SurfaceTension,"Set the SurfaceTension of a sample:"},
			(
				UploadSampleProperties[
					Object[Sample,"UploadSampleProperties test sample 1"],
					SurfaceTension -> 72.8 Milli Newton/Meter
				];
				Download[Object[Sample,"UploadSampleProperties test sample 1"],SurfaceTension]
			),
			72.8 Milli Newton/Meter,
			EquivalenceFunction :> Equal
		],
		Example[{Options,Conductivity,"Set the Conductivity of a sample:"},
			(
				UploadSampleProperties[
					Object[Sample, "UploadSampleProperties test sample 1"],
					Conductivity -> NormalDistribution[3, 2] (Micro Siemens)/Centimeter
				];
				Download[Object[Sample,"UploadSampleProperties test sample 1"],Conductivity]
			),
			QuantityDistribution[NormalDistribution[3, 2], "Centimeters"^(-1) "Microsiemens"],
			EquivalenceFunction :> Equal
		],
		Example[{Options,Volume,"Set the Volume of a sample:"},
			(
				UploadSampleProperties[
					Object[Sample,"UploadSampleProperties test sample 1"],
					Volume -> 400 Microliter
				];
				Download[Object[Sample,"UploadSampleProperties test sample 1"],Volume]
			),
			400 Microliter,
			EquivalenceFunction :> Equal
		],
		Example[{Options,Count,"Set the Count of a sample:"},
			(
				UploadSampleProperties[
					Object[Item,Tips,"UploadSampleProperties test sample 2"],
					Count -> 100
				];
				Download[Object[Item,Tips,"UploadSampleProperties test sample 2"],Count]
			),
			100,
			EquivalenceFunction :> Equal
		],
		Example[{Options,Upload,"Indicate if the changes should be uploaded:"},
			UploadSampleProperties[
				Object[Sample,"UploadSampleProperties test sample 1"],
				Volume -> 400 Microliter,
				Upload -> False
			],
			{PacketP[]}
		],
		Example[{Options,Date,"Specify the date that should be used as a log timestamp:"},
			(
				UploadSampleProperties[
					Object[Sample,"UploadSampleProperties test sample 1"],
					Volume -> 400 Microliter,
					Date -> DateObject["January 1, 2019"]
				];
				Download[Object[Sample,"UploadSampleProperties test sample 1"],VolumeLog]
			),
			{{_?(MatchQ[AbsoluteTime[#],EqualP[AbsoluteTime[DateObject["January 1, 2019"]]]]&),_?((#==400 Microliter)&),LinkP[],ComputedVolume}}
		],
		Example[{Messages,"InvalidOptionLength","Error is thrown if option value's length does not match the length of input samples:"},
			UploadSampleProperties[
				{Object[Sample,"UploadSampleProperties test sample 1"]},
				Volume -> {400 Microliter, 800 Microliter}
			],
			$Failed,
			Messages :> {Error::InputLengthMismatch}
		],
		Example[{Messages,"UploadSimulation","Error is thrown when Upload is specified as True and Simulation option is not Null:"},
			UploadSampleProperties[
				{Object[Sample,"UploadSampleProperties test sample 1"]},
				Volume -> 400 Microliter,
				Upload -> True,
				Simulation -> Simulation[]
			],
			$Failed,
			Messages :> {UploadSampleProperties::CannotUploadSimulation}
		]
	},
	SetUp :> (
		Upload[{
			Association[
				Object -> Object[Sample,"UploadSampleProperties test sample 1"],
				Replace[Composition] -> {
					{99 VolumePercent, Link[Model[Molecule, "Water"]],Now},
					{1 Molar, Link[Model[Molecule, "Sodium Chloride"]],Now}
				},
				Density -> Null,
				Replace[DensityLog] -> {},
				pH -> Null,
				Replace[pHLog] -> {},
				Concentration -> Null,
				Replace[ConcentrationLog] -> {},
				MassConcentration -> Null,
				Replace[MassConcentrationLog] -> {},
				Mass -> Null,
				Replace[MassLog] -> {},
				Volume -> Null,
				Replace[VolumeLog] -> {},
				Count -> Null,
				Replace[CountLog] -> {},
				TotalProteinConcentration->Null,
				Replace[TotalProteinConcentrationLog]->{}
			],
			Association[
				Object -> Object[Item,Tips,"UploadSampleProperties test sample 2"],
				Density -> Null,
				Replace[DensityLog] -> {},
				pH -> Null,
				Replace[pHLog] -> {},
				Concentration -> Null,
				Replace[ConcentrationLog] -> {},
				MassConcentration -> Null,
				Replace[MassConcentrationLog] -> {},
				Mass -> Null,
				Replace[MassLog] -> {},
				Volume -> Null,
				Replace[VolumeLog] -> {},
				Count -> Null,
				Replace[CountLog] -> {}
			]
		}]
	),
	SymbolSetUp :> (
		$CreatedObjects = {};
		Upload[{
			If[!DatabaseMemberQ[Object[Sample,"UploadSampleProperties test sample 1"]],
				Association[
					Type -> Object[Sample],
					Name -> "UploadSampleProperties test sample 1",
					DeveloperObject -> True
				],
				Nothing
			],
			If[!DatabaseMemberQ[Object[Item,Tips,"UploadSampleProperties test sample 2"]],
				Association[
					Type -> Object[Item,Tips],
					Name -> "UploadSampleProperties test sample 2",
					DeveloperObject -> True
				],
				Nothing
			]
		}]
	),
	SymbolTearDown :> (EraseObject[
		PickList[
			$CreatedObjects,
			DatabaseMemberQ[$CreatedObjects],
			True
		],
		Force -> True
	])
];