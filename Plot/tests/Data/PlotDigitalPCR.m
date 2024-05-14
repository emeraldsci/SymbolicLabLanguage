(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotDigitalPCR*)

DefineTests[PlotDigitalPCR,
	{
		(*-- Basic --*)
		Example[{Basic,"Given a DigitalPCR data object, creates a plot:"},
			PlotDigitalPCR[
				Object[Data,DigitalPCR,"PlotDigitalPCR test data 1"]
			],
			ValidGraphicsP[]
		],
		Example[{Basic,"Given multiple DigitalPCR data objects, creates a plot:"},
			PlotDigitalPCR[
				{
					Object[Data,DigitalPCR,"PlotDigitalPCR test data 1"],
					Object[Data,DigitalPCR,"PlotDigitalPCR test data 2"]
				}
			],
			ValidGraphicsP[]
		],
		Example[{Basic,"Given a DigitalPCR data object, creates a 2D scatter plot when PlotChannels are specified:"},
			PlotDigitalPCR[
				Object[Data,DigitalPCR,"PlotDigitalPCR test data 1"],
				PlotChannels->{517.*Nanometer,556.*Nanometer}
			],
			ValidGraphicsP[]
		],

		Example[{Additional,"Given a DigitalPCR data object, creates a 2D plot:"},
			PlotDigitalPCR[
				Object[Data,DigitalPCR,"PlotDigitalPCR test data 1"],
				PlotChannels->{517.*Nanometer,556.*Nanometer}
			],
			ValidGraphicsP[]
		],
		Example[{Additional,"Given multiple DigitalPCR data objects, creates a 2D plot:"},
			PlotDigitalPCR[
				{
					Object[Data,DigitalPCR,"PlotDigitalPCR test data 1"],
					Object[Data,DigitalPCR,"PlotDigitalPCR test data 2"]
				},
				PlotChannels->{517.*Nanometer,556.*Nanometer}
			],
			ValidGraphicsP[]
		],

		(*-- Messages --*)
		Example[{Messages,"PlotDigitalPCROptionMismatch","When plotting all ExcitationWavelengths or all EmissionWavelengths available by specifying 'All', the other option cannot be specified as a list of wavelengths:"},
			PlotDigitalPCR[
				Object[Data,DigitalPCR,"PlotDigitalPCR test data 1"],
				ExcitationWavelengths->All,
				EmissionWavelengths->{517.*Nanometer}
			],
			$Failed,
			Messages:>{
				Error::PlotDigitalPCROptionMismatch
			}
		],
		Example[{Messages,"PlotDigitalPCRDualChannel","When plotting 2D scatter plot by specifying PlotChannels, EmissionWavelengths must match the wavelengths specified in PlotChannels:"},
			PlotDigitalPCR[
				Object[Data,DigitalPCR,"PlotDigitalPCR test data 1"],
				PlotChannels->{517.*Nanometer,556.*Nanometer},
				EmissionWavelengths->{517.*Nanometer}
			],
			$Failed,
			Messages:>{
				Error::PlotDigitalPCRDualChannel
			}
		],
		Example[{Messages,"PlotDigitalPCRLengthMismatch","When specifying ExcitationWavelengths and EmissionWavelengths, the option lengths must match:"},
			PlotDigitalPCR[
				Object[Data,DigitalPCR,"PlotDigitalPCR test data 1"],
				ExcitationWavelengths->{495.*Nanometer,535.*Nanometer},
				EmissionWavelengths->{517.*Nanometer}
			],
			$Failed,
			Messages:>{
				Error::PlotDigitalPCRLengthMismatch
			}
		],
		Example[{Messages,"PlotDigitalPCRIncompatiblePlot","When PlotType is 'EmeraldListLinePlot', PlotChannels must be specified as a pair of wavelength channels for a 2D plot:"},
			PlotDigitalPCR[
				Object[Data,DigitalPCR,"PlotDigitalPCR test data 1"],
				PlotType->EmeraldListLinePlot,
				PlotChannels->SingleChannel
			],
			$Failed,
			Messages:>{
				Error::PlotDigitalPCRIncompatiblePlot
			}
		],
		Example[{Messages,"PlotDigitalPCRIncompatiblePlot","When PlotType is 'EmeraldSmoothHistogram', PlotChannels must be specified as \"Single Channel\":"},
			PlotDigitalPCR[
				Object[Data,DigitalPCR,"PlotDigitalPCR test data 1"],
				PlotType->EmeraldSmoothHistogram,
				PlotChannels->{517.*Nanometer,556.*Nanometer}
			],
			$Failed,
			Messages:>{
				Error::PlotDigitalPCRIncompatiblePlot
			}
		],

		(*-- Options --*)
		Example[{Options,PlotType,"PlotType automatically resolves to EmeraldSmoothHistogram:"},
			options=PlotDigitalPCR[
				Object[Data,DigitalPCR,"PlotDigitalPCR test data 1"],
				Output->Options
			];
			Lookup[options,PlotType],
			EmeraldSmoothHistogram,
			Variables:>{options}
		],
		Example[{Options,PlotType,"PlotType automatically resolves to EmeraldListLinePlot when PlotChannels is specified as a pair of wavelengths:"},
			options=PlotDigitalPCR[
				Object[Data,DigitalPCR,"PlotDigitalPCR test data 1"],
				PlotChannels->{517.*Nanometer,556.*Nanometer},
				Output->Options
			];
			Lookup[options,PlotType],
			EmeraldListLinePlot,
			Variables:>{options}
		],
		Example[{Options,PlotType,"PlotType can be specified:"},
			options=PlotDigitalPCR[
				Object[Data,DigitalPCR,"PlotDigitalPCR test data 1"],
				PlotType->EmeraldSmoothHistogram,
				Output->Options
			];
			Lookup[options,PlotType],
			EmeraldSmoothHistogram,
			Variables:>{options}
		],

		Example[{Options,ExcitationWavelengths,"ExcitationWavelengths automatically resolves to a list of unique wavelength channels from probes and reference probes in input data objects:"},
			options=PlotDigitalPCR[
				Object[Data,DigitalPCR,"PlotDigitalPCR test data 1"],
				Output->Options
			];
			Lookup[options,ExcitationWavelengths],
			{495.*Nanometer,535.*Nanometer,647.*Nanometer,675.*Nanometer},
			Variables:>{options}
		],
		Example[{Options,ExcitationWavelengths,"ExcitationWavelengths automatically resolves when EmissionWavelengths are specified:"},
			options=PlotDigitalPCR[
				Object[Data,DigitalPCR,"PlotDigitalPCR test data 1"],
				EmissionWavelengths->{517.*Nanometer},
				Output->Options
			];
			Lookup[options,ExcitationWavelengths],
			{495.*Nanometer},
			Variables:>{options}
		],
		Example[{Options,ExcitationWavelengths,"ExcitationWavelengths can be specified:"},
			options=PlotDigitalPCR[
				Object[Data,DigitalPCR,"PlotDigitalPCR test data 1"],
				ExcitationWavelengths->{495.*Nanometer},
				Output->Options
			];
			Lookup[options,ExcitationWavelengths],
			{495.*Nanometer},
			Variables:>{options}
		],

		Example[{Options,EmissionWavelengths,"EmissionWavelengths automatically resolves to a list of unique wavelength channels from probes and reference probes in input data objects:"},
			options=PlotDigitalPCR[
				Object[Data,DigitalPCR,"PlotDigitalPCR test data 1"],
				Output->Options
			];
			Lookup[options,EmissionWavelengths],
			{517.*Nanometer,556.*Nanometer,665.*Nanometer,694.*Nanometer},
			Variables:>{options}
		],
		Example[{Options,EmissionWavelengths,"EmissionWavelengths automatically resolves when ExcitationWavelengths are specified:"},
			options=PlotDigitalPCR[
				Object[Data,DigitalPCR,"PlotDigitalPCR test data 1"],
				ExcitationWavelengths->{495.*Nanometer},
				Output->Options
			];
			Lookup[options,EmissionWavelengths],
			{517.*Nanometer},
			Variables:>{options}
		],
		Example[{Options,EmissionWavelengths,"EmissionWavelengths can be specified:"},
			options=PlotDigitalPCR[
				Object[Data,DigitalPCR,"PlotDigitalPCR test data 1"],
				EmissionWavelengths->{517.*Nanometer},
				Output->Options
			];
			Lookup[options,EmissionWavelengths],
			{517.*Nanometer},
			Variables:>{options}
		],

		Example[{Options,PlotChannels,"PlotChannels can be specified:"},
			options=PlotDigitalPCR[
				Object[Data,DigitalPCR,"PlotDigitalPCR test data 1"],
				PlotChannels->{517.*Nanometer,665.*Nanometer},
				Output->Options
			];
			Lookup[options,PlotChannels],
			{517.*Nanometer,665.*Nanometer},
			Variables:>{options}
		],

		Example[{Options,Output,"When specified as Result, outputs a plot:"},
			PlotDigitalPCR[
				Object[Data,DigitalPCR,"PlotDigitalPCR test data 1"],
				Output->Result
			],
			ValidGraphicsP[]
		],
		Example[{Options,Output,"When specified as Options, outputs a list of resolved options:"},
			PlotDigitalPCR[
				Object[Data,DigitalPCR,"PlotDigitalPCR test data 1"],
				Output->Options
			],
			{_Rule..}
		],
		Example[{Options,Output,"When specified as Preview, outputs a plot preview:"},
			PlotDigitalPCR[
				Object[Data,DigitalPCR,"PlotDigitalPCR test data 1"],
				Output->Preview
			],
			SlideView[{Legended[ValidGraphicsP[], ___]..},___]
		],
		Example[{Options,Output,"When specified as Tests, outputs {}:"},
			PlotDigitalPCR[
				Object[Data,DigitalPCR,"PlotDigitalPCR test data 1"],
				Output->Tests
			],
			{}
		]

	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	SymbolSetUp:>(
		$CreatedObjects={};

		Module[{allObjects,existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Sample,"PlotDigitalPCR test sample 1"],
				Object[Data,DigitalPCR,"PlotDigitalPCR test data 1"],
				Object[Data,DigitalPCR,"PlotDigitalPCR test data 2"]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];

		Module[
			{
				dataExtractor,dropletExcitationWavelengths,dropletEmissionWavelengths,rawData1,rawData2
			},

			(* Create a container to store a sample *)
			Upload[<|
				Type->Object[Sample],
				Model->Link[Model[Sample,"Milli-Q water"],Objects],
				Name->"PlotDigitalPCR test sample 1"
			|>];

			(* dropletExcitationWavelengths and dropletEmissionWavelengths stay the same *)
			dropletExcitationWavelengths={495.*Nanometer,535.*Nanometer,647.*Nanometer,675.*Nanometer};
			dropletEmissionWavelengths={517.*Nanometer,556.*Nanometer,665.*Nanometer,694.*Nanometer};

			(* Function to extract data from imported file *)
			dataExtractor[myCloudFile_]:=Module[{importedRawData,firstNumberPosition,rawDataNoHeaders,transposedData},

				(* Import data from cloud file *)
				importedRawData=ImportCloudFile[myCloudFile];

				(* Get the position of the first numeric string *)
				firstNumberPosition=FirstPosition[importedRawData,_Real];

				(* Get rid of the header rows *)
				rawDataNoHeaders=Drop[importedRawData,First[firstNumberPosition]-1];

				(* Convert strings to numbers and transpose to get a list of amplitudes for each channel *)
				transposedData=Transpose@ToExpression[rawDataNoHeaders];

				(* output the first four lists that have data for the four channels *)
				QuantityArray[#,RFU]&/@Take[transposedData,4]
			];

			(* Import data from cloud files *)
			rawData1=dataExtractor[EmeraldCloudFile["AmazonS3","emeraldsci-ecl-blobstore-stage","09ab8198e41f1ecbc181a338b4dc16b6.csv"]];
			rawData2=dataExtractor[EmeraldCloudFile["AmazonS3","emeraldsci-ecl-blobstore-stage","963c60b02a39ecd081dd0cc6b8be26cf.csv"]];

			(* Generate first data object *)
			Upload[{
				<|
					Object->Object[Sample,"PlotDigitalPCR test sample 1"],
					DeveloperObject->True
				|>,
				<|
					Type->Object[Data,DigitalPCR],
					Name->"PlotDigitalPCR test data 1",
					Replace[SamplesIn]->{Link[Object[Sample,"PlotDigitalPCR test sample 1"],Data]},
					Well->"A1",
					Replace[ExcitationWavelengths]->{495.*Nanometer,535.*Nanometer},
					Replace[EmissionWavelengths]->{517.*Nanometer,556.*Nanometer},
					Replace[ReferenceExcitationWavelengths]->{647.*Nanometer,675.*Nanometer},
					Replace[ReferenceEmissionWavelengths]->{665.*Nanometer,694.*Nanometer},
					DropletAmplitudes->rawData1,
					Replace[DropletExcitationWavelengths]->dropletExcitationWavelengths,
					Replace[DropletEmissionWavelengths]->dropletEmissionWavelengths,
					DeveloperObject->True
				|>,
				<|
					Type->Object[Data,DigitalPCR],
					Name->"PlotDigitalPCR test data 2",
					Replace[SamplesIn]->{Link[Object[Sample,"PlotDigitalPCR test sample 1"],Data]},
					Well->"B1",
					Replace[ExcitationWavelengths]->{495.*Nanometer,535.*Nanometer},
					Replace[EmissionWavelengths]->{517.*Nanometer,556.*Nanometer},
					Replace[ReferenceExcitationWavelengths]->{647.*Nanometer,675.*Nanometer},
					Replace[ReferenceEmissionWavelengths]->{665.*Nanometer,694.*Nanometer},
					DropletAmplitudes->rawData2,
					Replace[DropletExcitationWavelengths]->dropletExcitationWavelengths,
					Replace[DropletEmissionWavelengths]->dropletEmissionWavelengths,
					DeveloperObject->True
				|>
			}]
		];
	),

	SymbolTearDown:>(
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	)
]