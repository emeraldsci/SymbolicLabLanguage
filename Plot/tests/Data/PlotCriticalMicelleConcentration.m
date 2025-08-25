(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotCriticalMicelleConcentration*)


DefineTests[PlotCriticalMicelleConcentration,
	{
		Example[{Messages,"CriticalMicelleConcentrationAnalysisMissing", "Given an unanalyzed Object[Data,SurfaceTension], PlotCriticalMicelleConcentration returns an plot:"},
			PlotCriticalMicelleConcentration[Object[Data, SurfaceTension,  "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests 2"<>plotCritObject]],
			ValidGraphicsP[],
			Messages:>{
				Warning::CriticalMicelleConcentrationAnalysisMissing
			}
		],
		Example[{Basic, "Given an analyzed Object[Data,SurfaceTension], PlotCriticalMicelleConcentration returns a plot:"},
			PlotCriticalMicelleConcentration[Object[Data, SurfaceTension,  "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests"<>plotCritObject]],
			ValidGraphicsP[]
		],
		Example[{Basic, "Given an Object[Protocol, MeasureSurfaceTension] with unanalyzed surface tension data objects in the Data field, PlotCriticalMicelleConcentration returns a plot of each data object in slide view format:"},
			PlotCriticalMicelleConcentration[Object[Protocol, MeasureSurfaceTension, "Test protocol object for analyzeCriticalMicelleConcentration tests"<>plotCritObject]],
			SlideView[{ValidGraphicsP[]..}],
			Messages:>{
				Warning::CriticalMicelleConcentrationAnalysisMissing
			}
		],
		Example[{Basic, "Given an Object[Analysis,CriticalMicelleConcentration], PlotCriticalMicelleConcentration returns a plot:"},
			PlotCriticalMicelleConcentration[Object[Data, SurfaceTension,  "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests"<>plotCritObject][CriticalMicelleConcentrationAnalyses]],
			ValidGraphicsP[]
		],
		Example[{Options,Legend, "Add a legend:"},
			PlotCriticalMicelleConcentration[Object[Data, SurfaceTension,  "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests"<>plotCritObject],
				Legend->{"Label1", "Label2", "Label3"}
			],
			ValidGraphicsP[]
		],
		Example[{Options,Frame, "Specify a frame:"},
			PlotCriticalMicelleConcentration[Object[Data, SurfaceTension,  "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests"<>plotCritObject],
				Frame->{True,True,True,True}
			],
			ValidGraphicsP[]
		],
		Example[{Options,LabelStyle, "Specify a label style:"},
			PlotCriticalMicelleConcentration[Object[Data, SurfaceTension,  "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests"<>plotCritObject],
				LabelStyle->{Bold, 20, FontFamily -> "Times"}
			],
			ValidGraphicsP[]
		]
	},

	Variables:>{
		plotCritObject
	},
	SymbolSetUp :> {
		$CreatedObjects = {};
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Protocol, MeasureSurfaceTension, "Test protocol object for analyzeCriticalMicelleConcentration tests"],
					Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests"],
					Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests 2"],
					Object[Analysis,CriticalMicelleConcentration,"test template"]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];

		Module[{dataPackets, protocolObjectPacket},
			plotCritObject = CreateUUID[];
			(*Make test data packets.*)
			dataPackets = {
				Association[
					Type -> Object[Data, SurfaceTension],
					Name -> "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests"<>plotCritObject,
					Replace[Diluent] -> Link[Object[Sample, "id:O81aEBZenRO3"]],
					Replace[SamplesIn] -> {Link[Object[Sample, "id:pZx9jo8wPM9p"], Data]},
					Replace[AliquotSamples] -> {Link[Object[Sample, "id:7X104vnGrXww"], Data], Link[Object[Sample, "id:O81aEBZeb8M1"], Data], Link[
						Object[Sample, "id:GmzlKjPrbmMN"], Data], Link[Object[Sample, "id:AEqRl9Km8EMd"], Data], Link[Object[Sample, "id:o1k9jAGvm1BE"], Data], Link[
						Object[Sample, "id:zGj91a7nKGpx"], Data], Link[Object[Sample, "id:lYq9jRxwvYB4"], Data], Link[Object[Sample, "id:L8kPEjn1b8M6"], Data], Link[
						Object[Sample, "id:E8zoYvNrb8Mb"], Data], Link[Object[Sample, "id:Y0lXejMoL0Bo"], Data], Link[Object[Sample, "id:kEJ9mqRxbEBL"], Data], Link[
						Object[Sample, "id:P5ZnEjdpb5ME"], Data], Link[Object[Sample, "id:3em6ZvLX8ePM"], Data], Link[Object[Sample, "id:D8KAEvGmw8ML"], Data], Link[
						Object[Sample, "id:aXRlGn6YLXBX"], Data], Link[Object[Sample, "id:wqW9BP7NKqZO"], Data], Link[Object[Sample, "id:J8AY5jDnb8MB"], Data], Link[
						Object[Sample, "id:8qZ1VW0A9qJn"], Data], Link[Object[Sample, "id:rea9jlRwKeB3"], Data], Link[Object[Sample, "id:bq9LA0JW5qML"], Data], Link[
						Object[Sample, "id:KBL5Dvw0xBMv"], Data], Link[Object[Sample, "id:jLq9jXvwbL5R"], Data], Link[Object[Sample, "id:eGakldJ65GBo"], Data]},
					Replace[DilutionFactors] -> {1., 0.860009, 0.739616, 0.636077, 0.547032, 0.470453, 0.404594,
						0.347954, 0.299244, 0.257353, 0.221326, 0.190342, 0.163696, 0.14078,
						0.121072, 0.104123, 0.0895469, 0.0770112, 0.0662303, 0.0569587,
						0.048985, 0.0421276, 0.},
					Replace[SurfaceTensions] -> {Quantity[34.8, ("Millinewtons") / ("Meters")],
						Quantity[34.6, ("Millinewtons") / ("Meters")],
						Quantity[35.1, ("Millinewtons") / ("Meters")],
						Quantity[35.1, ("Millinewtons") / ("Meters")],
						Quantity[34.9, ("Millinewtons") / ("Meters")],
						Quantity[34.5, ("Millinewtons") / ("Meters")],
						Quantity[34.3, ("Millinewtons") / ("Meters")],
						Quantity[33.9, ("Millinewtons") / ("Meters")],
						Quantity[34.4, ("Millinewtons") / ("Meters")],
						Quantity[34.9, ("Millinewtons") / ("Meters")],
						Quantity[40.7, ("Millinewtons") / ("Meters")],
						Quantity[46.3, ("Millinewtons") / ("Meters")],
						Quantity[49.3, ("Millinewtons") / ("Meters")],
						Quantity[54.1, ("Millinewtons") / ("Meters")],
						Quantity[58.3, ("Millinewtons") / ("Meters")],
						Quantity[63.3, ("Millinewtons") / ("Meters")],
						Quantity[67.2, ("Millinewtons") / ("Meters")],
						Quantity[68.9, ("Millinewtons") / ("Meters")],
						Quantity[69.9, ("Millinewtons") / ("Meters")],
						Quantity[71.1, ("Millinewtons") / ("Meters")],
						Quantity[71.4, ("Millinewtons") / ("Meters")],
						Quantity[69.4, ("Millinewtons") / ("Meters")],
						Quantity[72.6, ("Millinewtons") / ("Meters")]},
					Replace[Temperatures] ->{Quantity[27.3, "DegreesCelsius"], Quantity[27.2, "DegreesCelsius"],
						Quantity[27.2, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27., "DegreesCelsius"], Quantity[27.3, "DegreesCelsius"],
						Quantity[27.2, "DegreesCelsius"], Quantity[27.2, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27., "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"]}
				],
				Association[
					Type -> Object[Data, SurfaceTension],
					Name -> "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests 2"<>plotCritObject,
					Replace[Diluent] -> Link[Object[Sample, "id:O81aEBZenRO3"]],
					Replace[SamplesIn] -> {Link[Object[Sample, "id:pZx9jo8wPM9p"], Data]},
					Replace[AliquotSamples] -> {Link[Object[Sample, "id:7X104vnGrXww"], Data], Link[Object[Sample, "id:O81aEBZeb8M1"], Data], Link[
						Object[Sample, "id:GmzlKjPrbmMN"], Data], Link[Object[Sample, "id:AEqRl9Km8EMd"], Data], Link[Object[Sample, "id:o1k9jAGvm1BE"], Data], Link[
						Object[Sample, "id:zGj91a7nKGpx"], Data], Link[Object[Sample, "id:lYq9jRxwvYB4"], Data], Link[Object[Sample, "id:L8kPEjn1b8M6"], Data], Link[
						Object[Sample, "id:E8zoYvNrb8Mb"], Data], Link[Object[Sample, "id:Y0lXejMoL0Bo"], Data], Link[Object[Sample, "id:kEJ9mqRxbEBL"], Data], Link[
						Object[Sample, "id:P5ZnEjdpb5ME"], Data], Link[Object[Sample, "id:3em6ZvLX8ePM"], Data], Link[Object[Sample, "id:D8KAEvGmw8ML"], Data], Link[
						Object[Sample, "id:aXRlGn6YLXBX"], Data], Link[Object[Sample, "id:wqW9BP7NKqZO"], Data], Link[Object[Sample, "id:J8AY5jDnb8MB"], Data], Link[
						Object[Sample, "id:8qZ1VW0A9qJn"], Data], Link[Object[Sample, "id:rea9jlRwKeB3"], Data], Link[Object[Sample, "id:bq9LA0JW5qML"], Data], Link[
						Object[Sample, "id:KBL5Dvw0xBMv"], Data], Link[Object[Sample, "id:jLq9jXvwbL5R"], Data], Link[Object[Sample, "id:eGakldJ65GBo"], Data]},
					Replace[DilutionFactors] -> {1., 0.860009, 0.739616, 0.636077, 0.547032, 0.470453, 0.404594,
						0.347954, 0.299244, 0.257353, 0.221326, 0.190342, 0.163696, 0.14078,
						0.121072, 0.104123, 0.0895469, 0.0770112, 0.0662303, 0.0569587,
						0.048985, 0.0421276, 0.},
					Replace[SurfaceTensions] -> {Quantity[34.8, ("Millinewtons") / ("Meters")],
						Quantity[34.6, ("Millinewtons") / ("Meters")],
						Quantity[35.1, ("Millinewtons") / ("Meters")],
						Quantity[35.1, ("Millinewtons") / ("Meters")],
						Quantity[34.9, ("Millinewtons") / ("Meters")],
						Quantity[34.5, ("Millinewtons") / ("Meters")],
						Quantity[34.3, ("Millinewtons") / ("Meters")],
						Quantity[33.9, ("Millinewtons") / ("Meters")],
						Quantity[34.4, ("Millinewtons") / ("Meters")],
						Quantity[34.9, ("Millinewtons") / ("Meters")],
						Quantity[40.7, ("Millinewtons") / ("Meters")],
						Quantity[46.3, ("Millinewtons") / ("Meters")],
						Quantity[49.3, ("Millinewtons") / ("Meters")],
						Quantity[54.1, ("Millinewtons") / ("Meters")],
						Quantity[58.3, ("Millinewtons") / ("Meters")],
						Quantity[63.3, ("Millinewtons") / ("Meters")],
						Quantity[67.2, ("Millinewtons") / ("Meters")],
						Quantity[68.9, ("Millinewtons") / ("Meters")],
						Quantity[69.9, ("Millinewtons") / ("Meters")],
						Quantity[71.1, ("Millinewtons") / ("Meters")],
						Quantity[71.4, ("Millinewtons") / ("Meters")],
						Quantity[69.4, ("Millinewtons") / ("Meters")],
						Quantity[72.6, ("Millinewtons") / ("Meters")]},
					Replace[Temperatures] ->{Quantity[27.3, "DegreesCelsius"], Quantity[27.2, "DegreesCelsius"],
						Quantity[27.2, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27., "DegreesCelsius"], Quantity[27.3, "DegreesCelsius"],
						Quantity[27.2, "DegreesCelsius"], Quantity[27.2, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27., "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"]}
				]
			};

			Upload[dataPackets];

			(*Make a test protocol object*)
			protocolObjectPacket = Association[
				Type -> Object[Protocol, MeasureSurfaceTension],
				Name -> "Test protocol object for analyzeCriticalMicelleConcentration tests"<>plotCritObject,
				(*add the data*)
				Replace[Data] -> {Link[Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests"<>plotCritObject], Protocol],
					Link[Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests 2"<>plotCritObject], Protocol]},
				Replace[Calibrant] -> {Link[Object[Sample, "id:O81aEBZenRO3"]]},
				DateCompleted -> Now
			];

			Upload[protocolObjectPacket];

			AnalyzeCriticalMicelleConcentration[Object[Data, SurfaceTension,  "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests"<>plotCritObject]]
		];

	},

	SymbolTearDown:> (
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects], True], Force -> True, Verbose -> False];
	)
];
