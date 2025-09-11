(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotCapillaryGelElectrophoresisSDS*)


DefineTests[PlotCapillaryGelElectrophoresisSDS,
	{
		Example[
			{Basic,"Plots capillary gel electrophoresis when given an CapillaryGelElectrophoresisSDS data object:"},
			PlotCapillaryGelElectrophoresisSDS[Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"]],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Basic,"If peak-picking has already been done on input data, set PrimaryData to RelativeMigrationData to plot peaks relative to an internal standard:"},
			PlotCapillaryGelElectrophoresisSDS[Object[Data,CapillaryGelElectrophoresisSDS,"id:E8zoYvNMJpOX"], PrimaryData->RelativeMigrationData],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Test[
			"Given a packet:",
			PlotCapillaryGelElectrophoresisSDS[Download[Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"]]],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Basic,"Plots capillary gel electrophoresis when given an CapillaryGelElectrophoresisSDS data link:"},
			PlotCapillaryGelElectrophoresisSDS[Link[Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"],Protocol]],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Basic,"Plots capillary gel electrophoresis when given a CapillaryGelElectrophoresisSDS protocol object:"},
			PlotCapillaryGelElectrophoresisSDS[Object[Protocol, CapillaryGelElectrophoresisSDS, "CapillaryGelElectrophoresisSDS Protocol for PlotCapillaryGelElectrophoresisSDS Test "<>$SessionUUID]],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Basic,"Plots capillary gel electrophoresis when given a list of XY coordinates representing the spectra:"},
			PlotCapillaryGelElectrophoresisSDS[Download[Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"],CurrentData]],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Basic,"Plots multiple sets of data on the same graph:"},
			PlotCapillaryGelElectrophoresisSDS[{Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"],Object[Data,CapillaryGelElectrophoresisSDS,"id:M8n3rx0Rl3l5"]}],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,TargetUnits,"Plot the x-axis in units of Minutes:"},
			PlotCapillaryGelElectrophoresisSDS[Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"],TargetUnits->{Minute,MilliAbsorbanceUnit}],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,Map,"Generate a separate plot for each data object given:"},
			PlotCapillaryGelElectrophoresisSDS[{Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"],Object[Data,CapillaryGelElectrophoresisSDS,"id:M8n3rx0Rl3l5"]},Map->True],
			{ValidGraphicsP[],ValidGraphicsP[]},
			TimeConstraint->120
		],
		Example[
			{Options,Legend,"Provide a custom legend for the data:"},
			PlotCapillaryGelElectrophoresisSDS[{Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"],Object[Data,CapillaryGelElectrophoresisSDS,"id:M8n3rx0Rl3l5"]},Legend->{"IgG Standard","Broad Range Standard"}],
			_?Core`Private`ValidLegendedQ,
			TimeConstraint->120
		],
		Example[
			{Options,Units,"Specify relevant units:"},
			PlotCapillaryGelElectrophoresisSDS[Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"],Units->{ProcessedUVAbsorbanceData->{Second,AbsorbanceUnit}}],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,PrimaryData,"Plots the current-voltage plot for the relevant data:"},
			PlotCapillaryGelElectrophoresisSDS[Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"],PrimaryData->CurrentData],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,SecondaryData,"Plots the current-voltage plot for the relevant data:"},
			PlotCapillaryGelElectrophoresisSDS[Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"],SecondaryData->VoltageData],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,PlotTheme,"Indicate a general theme which should be used to set the styling for many plot options:"},
			PlotCapillaryGelElectrophoresisSDS[Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"],PlotTheme->"Marketing"],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,Zoomable,"To improve performance indicate that the plot should not allow interactive zooming:"},
			PlotCapillaryGelElectrophoresisSDS[Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"],Zoomable->False],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,ImageSize,"Specify the dimensions of the plot:"},
			PlotCapillaryGelElectrophoresisSDS[Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"],ImageSize->Medium],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,PlotLabel,"Provide a title for the plot:"},
			PlotCapillaryGelElectrophoresisSDS[Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"],PlotLabel->"cIEF System Suitability Test"],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,FrameLabel,"Specify custom x and y-axis labels:"},
			PlotCapillaryGelElectrophoresisSDS[Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"],SecondaryData->{},
				FrameLabel->{"Position in Capillary","FL Signal",None,None}],
			ValidGraphicsP[],
			TimeConstraint->120
		],

		Example[
			{Options,LegendPlacement,"Indicate that the legend should be placed to the right of the plot:"},
			PlotCapillaryGelElectrophoresisSDS[
				{Object[Data,CapillaryGelElectrophoresisSDS,"id:M8n3rx0Rl3l5"],Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"]},
				LegendPlacement->Right
			],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,Boxes,"Indicate that colors in the legend should be displayed using colored squares instead of lines:"},
			PlotCapillaryGelElectrophoresisSDS[
				{Object[Data,CapillaryGelElectrophoresisSDS,"id:M8n3rx0Rl3l5"],Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"]},
				Boxes->True
			],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[{Messages,"RelativeMigrationDataUnavailable","Error shows if RelativeMigrationData is requested for primary data but it is not yet available. Peak-picking analysis (specifying a parent peak) must first be done on the input data:"},
			PlotCapillaryGelElectrophoresisSDS[Object[Data, CapillaryGelElectrophoresisSDS,"id:WNa4ZjKj01mq"], PrimaryData->RelativeMigrationData],
			$Failed,
			Messages:>{Warning::RelativeMigrationDataUnavailable}
		],
		Test["RelativeMigrationData error does not prevent plot from occuring if it can be resolved from at least one input:",
			PlotCapillaryGelElectrophoresisSDS[
				{Object[Data, CapillaryGelElectrophoresisSDS, "id:E8zoYvNMJpOX"],Object[Data, CapillaryGelElectrophoresisSDS, "id:WNa4ZjKj01mq"]},
				PrimaryData->RelativeMigrationData
			],
			ValidGraphicsP[],
			Messages:>{Warning::RelativeMigrationDataUnavailable}
		],
		Test[
			"Plots many sets of data on the same graph:",
			PlotCapillaryGelElectrophoresisSDS[{Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"],Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"]}],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Test[
			"Accepts EmeraldListLinePlot options:",
			PlotCapillaryGelElectrophoresisSDS[{Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"],Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"]},PlotStyle->ColorFade[{Red,Blue},Length[{Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"],Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"]}]],FillingStyle->Core`Private`fillingFade[{Red,Blue},Length[{Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"],Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"]}]]],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		(* Output tests *)
		Test[
			"Setting Output to Result returns the plot:",
			PlotCapillaryGelElectrophoresisSDS[Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"],Output->Result],
			ValidGraphicsP[],
			TimeConstraint->120
		],

		Test[
			"Setting Output to Preview returns the plot:",
			PlotCapillaryGelElectrophoresisSDS[Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"],Output->Preview],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Test[
			"Setting Output to Options returns the resolved options:",
			PlotCapillaryGelElectrophoresisSDS[Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"],Output->Options],
			ops_/;MatchQ[ops,OptionsPattern[PlotCapillaryGelElectrophoresisSDS]],
			TimeConstraint->120
		],
		Test[
			"Setting Output to Tests returns a list of tests:",
			PlotCapillaryGelElectrophoresisSDS[Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"],Output->Tests],
			{(_EmeraldTest|_Example)...},
			TimeConstraint->120
		],
		Test[
			"Setting Output to {Result,Options} returns the plot along with all resolved options for data object input:",
			PlotCapillaryGelElectrophoresisSDS[Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"],Output->{Result,Options}],
			output_List/;MatchQ[First@output,ValidGraphicsP[]]&&MatchQ[Last@output,OptionsPattern[PlotCapillaryGelElectrophoresisSDS]]
		],
		Test[
			"Setting Output to {Result,Options} returns the plot along with all resolved options for raw spectrum input:",
			PlotCapillaryGelElectrophoresisSDS[Download[Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"],ProcessedUVAbsorbanceData],Output->{Result,Options}],
			output_List/;MatchQ[First@output,ValidGraphicsP[]]&&MatchQ[Last@output,OptionsPattern[PlotCapillaryGelElectrophoresisSDS]],
			TimeConstraint->120
		],
		Test[
			"Setting Output to Options returns all of the defined options:",
			Sort@Keys@PlotCapillaryGelElectrophoresisSDS[Object[Data,CapillaryGelElectrophoresisSDS,"id:jLq9jXvol9Gx"],Output->Options],
			Sort@Keys@SafeOptions@PlotCapillaryGelElectrophoresisSDS,
			TimeConstraint->120
		],
		Test["Peaks are automatically resolved when available:",
			Lookup[
				PlotCapillaryGelElectrophoresisSDS[
					Object[Data, CapillaryGelElectrophoresisSDS, "id:E8zoYvNMJpOX"],
					Output -> Options
				],
				Peaks
			],
			{PacketP[Object[Analysis,Peaks]]}
		]
	},

	SymbolSetUp :> (
		Module[{allObjects},
			allObjects={
				Object[Data, CapillaryGelElectrophoresisSDS, "CapillaryGelElectrophoresisSDS Data for PlotCapillaryGelElectrophoresisSDS test " <> $SessionUUID],
				Object[Protocol, CapillaryGelElectrophoresisSDS, "CapillaryGelElectrophoresisSDS Protocol for PlotCapillaryGelElectrophoresisSDS Test "<>$SessionUUID]
			};

			EraseObject[
				PickList[allObjects, DatabaseMemberQ[allObjects]],
				Force -> True,
				Verbose -> False
			]
		];

		$CreatedObjects={};

		Module[{data1, protocol1},
			{data1, protocol1} = CreateID[{Object[Data, CapillaryGelElectrophoresisSDS], Object[Protocol, CapillaryGelElectrophoresisSDS]}];

			Upload[
				<|
					Name -> "CapillaryGelElectrophoresisSDS Data for PlotCapillaryGelElectrophoresisSDS test " <> $SessionUUID,
					Object -> data1,
					Type -> Object[Data, CapillaryGelElectrophoresisSDS],
					ProcessedUVAbsorbanceData -> QuantityArray[{#, RandomReal[20]} & /@ Range[0.5, 2100], {Second, AbsorbanceUnit}],
					CurrentData -> QuantityArray[{#, RandomReal[{25, 30}]} & /@ Range[0.5, 2100], {Second, Milliampere}]
				|>
			];

			Upload[
				<|
					Name -> "CapillaryGelElectrophoresisSDS Protocol for PlotCapillaryGelElectrophoresisSDS Test "<>$SessionUUID,
					Object -> protocol1,
					Type -> Object[Protocol, CapillaryGelElectrophoresisSDS],
					Replace[Data] -> {Link[data1, Protocol]}
				|>
			];
		]
	),
	SymbolTearDown:>Module[{objsToErase},
		objsToErase=Flatten[{
			$CreatedObjects,
			Object[Data, CapillaryGelElectrophoresisSDS, "CapillaryGelElectrophoresisSDS Data for PlotCapillaryGelElectrophoresisSDS test " <> $SessionUUID],
			Object[Protocol, CapillaryGelElectrophoresisSDS, "CapillaryGelElectrophoresisSDS Protocol for PlotCapillaryGelElectrophoresisSDS Test "<>$SessionUUID]
		}];

		EraseObject[
			PickList[objsToErase,DatabaseMemberQ[objsToErase]],
			Force->True,
			Verbose->False
		];
	]
];
