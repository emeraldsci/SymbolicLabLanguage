(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotVolume*)


DefineTests[PlotVolume,
	{
		Example[
			{Basic,"Plot a histogram of distances:"},
			PlotVolume[blank0],
			ValidGraphicsP[],
			TimeConstraint->500
		],
		Test[
			"Given a packet:",
			PlotVolume[Download[blank0]],
			ValidGraphicsP[],
			TimeConstraint->500
		],
		Example[
			{Basic,"Plot volume data in links:"},
			PlotVolume[links0],
			ValidGraphicsP[],
			TimeConstraint->500
		],
		Example[
			{Basic,"Compare distances across datasets using a BoxWhiskerChart:"},
			PlotVolume[Download/@allBlanks],
			ValidGraphicsP[],
			TimeConstraint->500
		],

	(*
			ADDITIONAL
		*)
		Example[{Additional,"Input Type","List of info packets:"},
			PlotVolume[Download[blank0]],
			ValidGraphicsP[]
		],
		Example[{Additional,"Input Type","Grouped lists of info packets:"},
			PlotVolume[Download/@allBlanks],
			ValidGraphicsP[],
			TimeConstraint->500
		],
		Example[{Additional,"Input Type","List of distance values:"},
			PlotVolume[RandomVariate[NormalDistribution[50,5],1000]*Centimeter],
			ValidGraphicsP[]
		],
		Example[{Additional,"Input Type","Grouped lists of distance values:"},
			PlotVolume[Map[RandomVariate[NormalDistribution[#,5],1000]&,{40,50,60}]*Centimeter],
			ValidGraphicsP[]
		],
		Example[{Additional,"Input Type","List of volumes:"},
			PlotVolume[RandomVariate[NormalDistribution[50,5],1000]*Microliter],
			ValidGraphicsP[]
		],
		Example[{Additional,"Input Type","Grouped lists of volumes:"},
			PlotVolume[Map[RandomVariate[NormalDistribution[#,5],1000]&,{40,50,60}]*Microliter],
			ValidGraphicsP[],
			TimeConstraint -> 1000 Second
		],
		Example[{Additional,"Quantity Arrays","QuantityArray of volumes:"},
			PlotVolume[QuantityArray[RandomVariate[NormalDistribution[50, 5], 1000],Microliter]],
			ValidGraphicsP[]
		],
		Example[{Additional,"Quantity Arrays","A list of volume quantity arrays:"},
			PlotVolume[{QuantityArray[RandomVariate[NormalDistribution[50, 5], 1000],Microliter],QuantityArray[RandomVariate[NormalDistribution[40, 8], 1000],Microliter]}],
			ValidGraphicsP[]
		],
		Example[{Additional,"Quantity Arrays","Given a QuantityArray containing a single group of volume data sets:"},
			PlotVolume[QuantityArray[{RandomVariate[NormalDistribution[50,5],1000],RandomVariate[NormalDistribution[40, 8],1000]},Microliter]],
			ValidGraphicsP[]
		],


	(*
			OPTIONS
		*)
		Example[
			{Options,TargetUnits,"Change the axis units for a box whisker chart:"},
			PlotVolume[{Object[Data, Volume, "id:Z1lqpMGje9rz"],Object[Data, Volume, "id:dORYzZn0oWdR"],Object[Data, Volume, "id:eGakld01zPee"]},
				PlotType->BoxWhiskerChart ,TargetUnits->Centimeter],
			ValidGraphicsP[],
			TimeConstraint->500
		],
		Example[{Options,TargetUnits,"Specify units for a Histogram:"},
			PlotVolume[RandomVariate[NormalDistribution[50,5],1000]*Microliter,TargetUnits->Milliliter],
			ValidGraphicsP[]
		],
		Example[{Options,TargetUnits,"Specify units for a BoxWhiskerChart:"},
			PlotVolume[Map[RandomVariate[NormalDistribution[#,5],1000]&,{40,50,60}]*Microliter,TargetUnits->Milliliter],
			ValidGraphicsP[],
			TimeConstraint->180
		],

		Example[
			{Options,Buffer,"Specify the Buffer used in the experiment:"},
			PlotVolume[{Object[Data, Volume, "id:Z1lqpMGje9rz"],Object[Data, Volume, "id:dORYzZn0oWdR"],Object[Data, Volume, "id:eGakld01zPee"]},
				Buffer->UVBuffer],
			ValidGraphicsP[],
			TimeConstraint->120
		],

		Example[
			{Options,RamanSpectra,"Specify the RamanSpectra span used in the experiment:"},
			PlotVolume[{Object[Data, Volume, "id:Z1lqpMGje9rz"],Object[Data, Volume, "id:dORYzZn0oWdR"],Object[Data, Volume, "id:eGakld01zPee"]},
				RamanSpectra->700 Nano Meter ;; 800 Nano Meter],
			ValidGraphicsP[],
			TimeConstraint->120
		],

		Example[
			{Options,PlotType,"Provide the data as a box whisker chart:"},
			PlotVolume[{Object[Data, Volume, "id:Z1lqpMGje9rz"],Object[Data, Volume, "id:dORYzZn0oWdR"],Object[Data, Volume, "id:eGakld01zPee"]},
				PlotType->BoxWhiskerChart],
			ValidGraphicsP[],
			TimeConstraint->120
		],

		Example[
			{Options,Legend,"Provide a box-whisker legend for the data. Multiple datasets must be provided for the legend to appear:"},
			PlotVolume[
				{
					{Object[Data, Volume, "id:Z1lqpMGje9rz"],Object[Data, Volume, "id:dORYzZn0oWdR"],Object[Data, Volume, "id:eGakld01zPee"]},
					{Object[Data, Volume, "id:dORYzZn0oWdR"],Object[Data, Volume, "id:dORYzZn0oWdR"], Object[Data, Volume, "id:dORYzZn0oWdR"],Object[Data, Volume, "id:dORYzZn0oWdR"], Object[Data, Volume,"id:eGakld01zPee"]}
				},
				Legend->{"Set A","Set B"}
			],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,Legend,"Provide a histogram legend for the data. Multiple datasets must be provided for the legend to appear:"},
			PlotVolume[
				{
					{Object[Data, Volume, "id:Z1lqpMGje9rz"],Object[Data, Volume, "id:dORYzZn0oWdR"],Object[Data, Volume, "id:eGakld01zPee"]},
					{Object[Data, Volume, "id:dORYzZn0oWdR"],Object[Data, Volume, "id:dORYzZn0oWdR"], Object[Data, Volume, "id:dORYzZn0oWdR"],Object[Data, Volume, "id:dORYzZn0oWdR"], Object[Data, Volume,"id:eGakld01zPee"]}
				},
				PlotType->Histogram,
				Legend->{"Set A","Set B"}
			],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,BoxWhiskerType,"Use BoxWhiskerChart options to show additional information, here a mean confidence interval diamond:"},
			PlotVolume[{Object[Data, Volume, "id:Z1lqpMGje9rz"],Object[Data, Volume, "id:dORYzZn0oWdR"],Object[Data, Volume, "id:eGakld01zPee"]},
				PlotType->BoxWhiskerChart ,
				BoxWhiskerType -> "Diamond"],
			ValidGraphicsP[],
			TimeConstraint->120
		],

		Example[
			{Options,ChartLabels,"Provide a plot title:"},
			PlotVolume[{Object[Data, Volume, "id:Z1lqpMGje9rz"],Object[Data, Volume, "id:dORYzZn0oWdR"],Object[Data, Volume, "id:eGakld01zPee"]},
				PlotLabel->"Volume Checks"],
			ValidGraphicsP[],
			TimeConstraint->120
		],

		Example[
			{Options,AutoBlank,"Substract the bakground:"},
			PlotVolume[{Object[Data, Volume, "id:Z1lqpMGje9rz"],Object[Data, Volume, "id:dORYzZn0oWdR"],Object[Data, Volume, "id:eGakld01zPee"]},
				AutoBlank->True],
			ValidGraphicsP[],
			TimeConstraint->120
		],

		Example[
			{Options,Display,"Show calculated volumes instead of raw distance readings:"},
			PlotVolume[{Object[Data, Volume, "id:3em6Zv9NPzmz"],Object[Data, Volume, "id:8qZ1VWNmJw4b"]},
				Display->Volume],
			ValidGraphicsP[],
			TimeConstraint->120
		],

	(*
			Messages
		*)
		Example[
			{Messages,"ConflictBoxWhisker","The BoxWhiskerType should not be specified for Histogram plot:"},
			PlotVolume[{Object[Data, Volume, "id:3em6Zv9NPzmz"],Object[Data, Volume, "id:8qZ1VWNmJw4b"]},
				PlotType->Histogram,
				BoxWhiskerType -> "Diamond"],
			ValidGraphicsP[],
			Messages:>{Warning::ConflictBoxWhisker},
			TimeConstraint->120
		],

	(*
			TESTS
		*)
		Test[
			"Create a histogram from a list of data:",
			PlotVolume[Download[blank0,LiquidLevel]],
			ValidGraphicsP[],
			TimeConstraint->500
		],
		Test[
			"Plot multiple sets of data as overlapping histograms:",
			PlotVolume[(Download/@allBlanks),PlotType->Histogram],
			ValidGraphicsP[],
			TimeConstraint->500
		]
	},
	Variables:>{blank0,blank1,blank2,blank3,blank4,blank5,allBlanks,links0},
	SetUp:>(
		blank0={Object[Data, Volume, "id:E8zoYveRMXjb"],Object[Data, Volume, "id:kEJ9mqaVBW4L"],Object[Data, Volume, "id:3em6Zv9NPz4M"],Object[Data, Volume, "id:aXRlGnZmBPoX"],Object[Data, Volume, "id:J8AY5jwzMEkB"],Object[Data, Volume, "id:rea9jl1oBGz3"],Object[Data, Volume, "id:KBL5DvYlMkrv"],Object[Data, Volume, "id:7X104vK9wDYw"],Object[Data, Volume, "id:vXl9j5qE1k8m"],Object[Data, Volume, "id:9RdZXvKB58Dj"],Object[Data, Volume, "id:BYDOjv1VMZlk"],Object[Data, Volume, "id:WNa4ZjRrB1oE"],Object[Data, Volume, "id:n0k9mGzRBe13"],Object[Data, Volume, "id:1ZA60vwjYOX8"],Object[Data, Volume, "id:dORYzZn0B8V5"],Object[Data, Volume, "id:pZx9jonGBXz5"],Object[Data, Volume, "id:Vrbp1jG8MnDo"],Object[Data, Volume, "id:qdkmxz0ABRo0"],Object[Data, Volume, "id:n0k9mGzRBeAk"],Object[Data, Volume, "id:Z1lqpMGjBV65"],Object[Data, Volume, "id:eGakld01Bb4n"],Object[Data, Volume, "id:4pO6dMWv3Lk8"],Object[Data, Volume, "id:XnlV5jmbBdzM"],Object[Data, Volume, "id:R8e1PjRDMvka"],Object[Data, Volume, "id:GmzlKjY5MGkm"],Object[Data, Volume, "id:o1k9jAKOB4JN"],Object[Data, Volume, "id:lYq9jRzXB0Al"],Object[Data, Volume, "id:E8zoYveRMXkv"],Object[Data, Volume, "id:kEJ9mqaVBW3B"],Object[Data, Volume, "id:D8KAEvdqM4xb"],Object[Data, Volume, "id:wqW9BP4YZ3kw"],Object[Data, Volume, "id:8qZ1VWNmJwMR"],Object[Data, Volume, "id:bq9LA0dBMDxb"],Object[Data, Volume, "id:jLq9jXY45BlE"],Object[Data, Volume, "id:N80DNjlYMJro"],Object[Data, Volume, "id:xRO9n3vkdavY"],Object[Data, Volume, "id:9RdZXvKB58K6"],Object[Data, Volume, "id:BYDOjv1VMZ1l"],Object[Data, Volume, "id:WNa4ZjRrB1RR"],Object[Data, Volume, "id:01G6nvkKEqkD"],Object[Data, Volume, "id:Z1lqpMGjBVG5"],Object[Data, Volume, "id:eGakld01Bb0n"],Object[Data, Volume, "id:4pO6dMWv3LW8"],Object[Data, Volume, "id:XnlV5jmbBdmM"],Object[Data, Volume, "id:R8e1PjRDMvRa"],Object[Data, Volume, "id:GmzlKjY5MGYm"],Object[Data, Volume, "id:o1k9jAKOB4KN"],Object[Data, Volume, "id:lYq9jRzXB0zl"],Object[Data, Volume, "id:E8zoYveRMXev"],Object[Data, Volume, "id:P5ZnEj4PMK4R"],Object[Data, Volume, "id:D8KAEvdqM4db"],Object[Data, Volume, "id:wqW9BP4YZ34w"],Object[Data, Volume, "id:8qZ1VWNmJwNR"],Object[Data, Volume, "id:bq9LA0dBMDdb"],Object[Data, Volume, "id:jLq9jXY45BYE"],Object[Data, Volume, "id:N80DNjlYMJlo"],Object[Data, Volume, "id:xRO9n3vkdaBY"]};
		links0=Link[#,Protocol]&/@{Object[Data, Volume, "id:E8zoYveRMXjb"],Object[Data, Volume, "id:kEJ9mqaVBW4L"],Object[Data, Volume, "id:3em6Zv9NPz4M"],Object[Data, Volume, "id:aXRlGnZmBPoX"],Object[Data, Volume, "id:J8AY5jwzMEkB"],Object[Data, Volume, "id:rea9jl1oBGz3"],Object[Data, Volume, "id:KBL5DvYlMkrv"],Object[Data, Volume, "id:7X104vK9wDYw"],Object[Data, Volume, "id:vXl9j5qE1k8m"],Object[Data, Volume, "id:9RdZXvKB58Dj"],Object[Data, Volume, "id:BYDOjv1VMZlk"],Object[Data, Volume, "id:WNa4ZjRrB1oE"],Object[Data, Volume, "id:n0k9mGzRBe13"],Object[Data, Volume, "id:1ZA60vwjYOX8"],Object[Data, Volume, "id:dORYzZn0B8V5"],Object[Data, Volume, "id:pZx9jonGBXz5"],Object[Data, Volume, "id:Vrbp1jG8MnDo"],Object[Data, Volume, "id:qdkmxz0ABRo0"],Object[Data, Volume, "id:n0k9mGzRBeAk"],Object[Data, Volume, "id:Z1lqpMGjBV65"],Object[Data, Volume, "id:eGakld01Bb4n"],Object[Data, Volume, "id:4pO6dMWv3Lk8"],Object[Data, Volume, "id:XnlV5jmbBdzM"],Object[Data, Volume, "id:R8e1PjRDMvka"],Object[Data, Volume, "id:GmzlKjY5MGkm"],Object[Data, Volume, "id:o1k9jAKOB4JN"],Object[Data, Volume, "id:lYq9jRzXB0Al"],Object[Data, Volume, "id:E8zoYveRMXkv"],Object[Data, Volume, "id:kEJ9mqaVBW3B"],Object[Data, Volume, "id:D8KAEvdqM4xb"],Object[Data, Volume, "id:wqW9BP4YZ3kw"],Object[Data, Volume, "id:8qZ1VWNmJwMR"],Object[Data, Volume, "id:bq9LA0dBMDxb"],Object[Data, Volume, "id:jLq9jXY45BlE"],Object[Data, Volume, "id:N80DNjlYMJro"],Object[Data, Volume, "id:xRO9n3vkdavY"],Object[Data, Volume, "id:9RdZXvKB58K6"],Object[Data, Volume, "id:BYDOjv1VMZ1l"],Object[Data, Volume, "id:WNa4ZjRrB1RR"],Object[Data, Volume, "id:01G6nvkKEqkD"],Object[Data, Volume, "id:Z1lqpMGjBVG5"],Object[Data, Volume, "id:eGakld01Bb0n"],Object[Data, Volume, "id:4pO6dMWv3LW8"],Object[Data, Volume, "id:XnlV5jmbBdmM"],Object[Data, Volume, "id:R8e1PjRDMvRa"],Object[Data, Volume, "id:GmzlKjY5MGYm"],Object[Data, Volume, "id:o1k9jAKOB4KN"],Object[Data, Volume, "id:lYq9jRzXB0zl"],Object[Data, Volume, "id:E8zoYveRMXev"],Object[Data, Volume, "id:P5ZnEj4PMK4R"],Object[Data, Volume, "id:D8KAEvdqM4db"],Object[Data, Volume, "id:wqW9BP4YZ34w"],Object[Data, Volume, "id:8qZ1VWNmJwNR"],Object[Data, Volume, "id:bq9LA0dBMDdb"],Object[Data, Volume, "id:jLq9jXY45BYE"],Object[Data, Volume, "id:N80DNjlYMJlo"],Object[Data, Volume, "id:xRO9n3vkdaBY"]};
		blank1={Object[Data, Volume, "id:3em6Zv9NPzmz"],Object[Data, Volume, "id:aXRlGnZmBP09"],Object[Data, Volume, "id:J8AY5jwzMEGx"],Object[Data, Volume, "id:bq9LA0dBMD1d"],Object[Data, Volume, "id:jLq9jXY45BOq"],Object[Data, Volume, "id:N80DNjlYMJvk"],Object[Data, Volume, "id:xRO9n3vkdaEx"],Object[Data, Volume, "id:9RdZXvKB58Nl"],Object[Data, Volume, "id:BYDOjv1VMZRr"],Object[Data, Volume, "id:WNa4ZjRrB1MZ"],Object[Data, Volume, "id:n0k9mGzRBeOn"],Object[Data, Volume, "id:1ZA60vwjYOza"],Object[Data, Volume, "id:dORYzZn0B8dw"],Object[Data, Volume, "id:4pO6dMWv3LmM"],Object[Data, Volume, "id:XnlV5jmbBdNB"],Object[Data, Volume, "id:R8e1PjRDMvB7"],Object[Data, Volume, "id:01G6nvkKEqDr"],Object[Data, Volume, "id:Z1lqpMGjBVrO"],Object[Data, Volume, "id:eGakld01Bbex"],Object[Data, Volume, "id:4pO6dMWv3Lmz"],Object[Data, Volume, "id:XnlV5jmbBdNb"],Object[Data, Volume, "id:R8e1PjRDMvBv"],Object[Data, Volume, "id:GmzlKjY5MGR4"],Object[Data, Volume, "id:zGj91aR3prAE"],Object[Data, Volume, "id:L8kPEjNLM3AN"],Object[Data, Volume, "id:Y0lXejGKBpOl"],Object[Data, Volume, "id:P5ZnEj4PMKrr"],Object[Data, Volume, "id:D8KAEvdqM45R"],Object[Data, Volume, "id:wqW9BP4YZ3VJ"],Object[Data, Volume, "id:8qZ1VWNmJwzA"],Object[Data, Volume, "id:bq9LA0dBMDaA"],Object[Data, Volume, "id:jLq9jXY45BAz"],Object[Data, Volume, "id:N80DNjlYMJkW"],Object[Data, Volume, "id:6V0npvK6aPAG"],Object[Data, Volume, "id:mnk9jO3qBZGO"],Object[Data, Volume, "id:M8n3rxYEMavM"],Object[Data, Volume, "id:54n6evKxDYW7"],Object[Data, Volume, "id:01G6nvkKEqPr"],Object[Data, Volume, "id:Z1lqpMGjBVvO"],Object[Data, Volume, "id:eGakld01BbDx"],Object[Data, Volume, "id:4pO6dMWv3Ljz"],Object[Data, Volume, "id:XnlV5jmbBdOb"],Object[Data, Volume, "id:R8e1PjRDMvYv"],Object[Data, Volume, "id:AEqRl954M0ea"],Object[Data, Volume, "id:zGj91aR3pr4E"],Object[Data, Volume, "id:L8kPEjNLM3eN"],Object[Data, Volume, "id:Y0lXejGKBp4l"],Object[Data, Volume, "id:P5ZnEj4PMKXr"],Object[Data, Volume, "id:D8KAEvdqM4VR"],Object[Data, Volume, "id:wqW9BP4YZ3dJ"],Object[Data, Volume, "id:8qZ1VWNmJwrA"],Object[Data, Volume, "id:bq9LA0dBMDOA"],Object[Data, Volume, "id:jLq9jXY45Brz"],Object[Data, Volume, "id:vXl9j5qE1kZN"],Object[Data, Volume, "id:6V0npvK6aP9G"],Object[Data, Volume, "id:mnk9jO3qBZYO"],Object[Data, Volume, "id:M8n3rxYEMapM"]};
		blank2={Object[Data, Volume, "id:8qZ1VWNmJw4b"],Object[Data, Volume, "id:bq9LA0dBMDkr"],Object[Data, Volume, "id:jLq9jXY45Be6"],Object[Data, Volume, "id:N80DNjlYMJmE"],Object[Data, Volume, "id:xRO9n3vkdaWZ"],Object[Data, Volume, "id:9RdZXvKB58VJ"],Object[Data, Volume, "id:BYDOjv1VMZdE"],Object[Data, Volume, "id:54n6evKxDYdY"],Object[Data, Volume, "id:01G6nvkKEqRd"],Object[Data, Volume, "id:Z1lqpMGjBVR0"],Object[Data, Volume, "id:eGakld01Bbv4"],Object[Data, Volume, "id:4pO6dMWv3Ll5"],Object[Data, Volume, "id:XnlV5jmbBdXN"],Object[Data, Volume, "id:R8e1PjRDMvZn"],Object[Data, Volume, "id:01G6nvkKEqRm"],Object[Data, Volume, "id:Z1lqpMGjBVRL"],Object[Data, Volume, "id:eGakld01BbvE"],Object[Data, Volume, "id:Vrbp1jG8Mn4W"],Object[Data, Volume, "id:qdkmxz0ABRap"],Object[Data, Volume, "id:O81aEB4kMrn3"],Object[Data, Volume, "id:AEqRl954M06R"],Object[Data, Volume, "id:zGj91aR3pr0J"],Object[Data, Volume, "id:L8kPEjNLM364"],Object[Data, Volume, "id:Y0lXejGKBpqE"],Object[Data, Volume, "id:P5ZnEj4PMK0k"],Object[Data, Volume, "id:D8KAEvdqM463"],Object[Data, Volume, "id:wqW9BP4YZ3JG"],Object[Data, Volume, "id:rea9jl1oBGPo"],Object[Data, Volume, "id:KBL5DvYlMk6k"],Object[Data, Volume, "id:7X104vK9wDrk"],Object[Data, Volume, "id:vXl9j5qE1kBJ"],Object[Data, Volume, "id:6V0npvK6aPME"],Object[Data, Volume, "id:mnk9jO3qBZbR"],Object[Data, Volume, "id:M8n3rxYEMaBP"],Object[Data, Volume, "id:54n6evKxDYNG"],Object[Data, Volume, "id:01G6nvkKEq8m"],Object[Data, Volume, "id:Z1lqpMGjBVLL"],Object[Data, Volume, "id:pZx9jonGBXbj"],Object[Data, Volume, "id:Vrbp1jG8Mn9W"],Object[Data, Volume, "id:qdkmxz0ABRKp"],Object[Data, Volume, "id:O81aEB4kMrb3"],Object[Data, Volume, "id:AEqRl954M08R"],Object[Data, Volume, "id:zGj91aR3prKJ"],Object[Data, Volume, "id:L8kPEjNLM3b4"],Object[Data, Volume, "id:Y0lXejGKBpLE"],Object[Data, Volume, "id:P5ZnEj4PMKbk"],Object[Data, Volume, "id:D8KAEvdqM4w3"],Object[Data, Volume, "id:J8AY5jwzMEb9"],Object[Data, Volume, "id:rea9jl1oBGKo"],Object[Data, Volume, "id:KBL5DvYlMkxk"],Object[Data, Volume, "id:7X104vK9wDGk"],Object[Data, Volume, "id:vXl9j5qE1kwJ"],Object[Data, Volume, "id:6V0npvK6aPOE"],Object[Data, Volume, "id:mnk9jO3qBZvR"],Object[Data, Volume, "id:M8n3rxYEMaZP"],Object[Data, Volume, "id:54n6evKxDYRG"],Object[Data, Volume, "id:01G6nvkKEqpm"]};
		blank3={Object[Data, Volume, "id:rea9jl1oBGj5"],Object[Data, Volume, "id:vXl9j5qE1kjB"],Object[Data, Volume, "id:6V0npvK6aPpZ"],Object[Data, Volume, "id:mnk9jO3qBZj7"],Object[Data, Volume, "id:M8n3rxYEMar8"],Object[Data, Volume, "id:54n6evKxDYeB"],Object[Data, Volume, "id:01G6nvkKEqn4"],Object[Data, Volume, "id:Z1lqpMGjBVpM"],Object[Data, Volume, "id:eGakld01BblB"],Object[Data, Volume, "id:4pO6dMWv3Ld7"],Object[Data, Volume, "id:XnlV5jmbBd5Z"],Object[Data, Volume, "id:n0k9mGzRBemr"],Object[Data, Volume, "id:1ZA60vwjYO0E"],Object[Data, Volume, "id:dORYzZn0B8zG"],Object[Data, Volume, "id:pZx9jonGBXj4"],Object[Data, Volume, "id:Vrbp1jG8MnPq"],Object[Data, Volume, "id:qdkmxz0ABRD3"],Object[Data, Volume, "id:O81aEB4kMrwp"],Object[Data, Volume, "id:AEqRl954M035"],Object[Data, Volume, "id:zGj91aR3prDj"],Object[Data, Volume, "id:L8kPEjNLM3aA"],Object[Data, Volume, "id:kEJ9mqaVBWKp"],Object[Data, Volume, "id:3em6Zv9NPzM8"],Object[Data, Volume, "id:aXRlGnZmBPMv"],Object[Data, Volume, "id:J8AY5jwzMEaa"],Object[Data, Volume, "id:rea9jl1oBGDe"],Object[Data, Volume, "id:KBL5DvYlMkaJ"],Object[Data, Volume, "id:7X104vK9wD5A"],Object[Data, Volume, "id:vXl9j5qE1kD5"],Object[Data, Volume, "id:6V0npvK6aP3a"],Object[Data, Volume, "id:mnk9jO3qBZ7w"],Object[Data, Volume, "id:WNa4ZjRrB168"],Object[Data, Volume, "id:n0k9mGzRBeDr"],Object[Data, Volume, "id:1ZA60vwjYO3E"],Object[Data, Volume, "id:dORYzZn0B8WG"],Object[Data, Volume, "id:pZx9jonGBXD4"],Object[Data, Volume, "id:Vrbp1jG8MnWq"],Object[Data, Volume, "id:qdkmxz0ABRZ3"],Object[Data, Volume, "id:O81aEB4kMrDp"],Object[Data, Volume, "id:AEqRl954M0o5"],Object[Data, Volume, "id:zGj91aR3prOj"],Object[Data, Volume, "id:E8zoYveRMXE5"],Object[Data, Volume, "id:kEJ9mqaVBWlp"],Object[Data, Volume, "id:3em6Zv9NPz08"],Object[Data, Volume, "id:aXRlGnZmBP4v"],Object[Data, Volume, "id:J8AY5jwzME3a"],Object[Data, Volume, "id:rea9jl1oBGde"],Object[Data, Volume, "id:KBL5DvYlMkKJ"],Object[Data, Volume, "id:7X104vK9wDeA"],Object[Data, Volume, "id:vXl9j5qE1kV5"],Object[Data, Volume, "id:6V0npvK6aPda"],Object[Data, Volume, "id:BYDOjv1VMZz8"],Object[Data, Volume, "id:WNa4ZjRrB138"],Object[Data, Volume, "id:n0k9mGzRBenr"],Object[Data, Volume, "id:1ZA60vwjYO9E"],Object[Data, Volume, "id:dORYzZn0B8qG"],Object[Data, Volume, "id:pZx9jonGBX14"]};
		blank4={Object[Data, Volume, "id:N80DNjlYMJWq"],Object[Data, Volume, "id:xRO9n3vkdaG7"],Object[Data, Volume, "id:9RdZXvKB58ax"],Object[Data, Volume, "id:BYDOjv1VMZB9"],Object[Data, Volume, "id:WNa4ZjRrB1Jq"],Object[Data, Volume, "id:dORYzZn0B8NR"],Object[Data, Volume, "id:pZx9jonGBXv0"],Object[Data, Volume, "id:Vrbp1jG8MnNx"],Object[Data, Volume, "id:qdkmxz0ABRNa"],Object[Data, Volume, "id:n0k9mGzRBeNw"],Object[Data, Volume, "id:1ZA60vwjYOB0"],Object[Data, Volume, "id:dORYzZn0B8Nq"],Object[Data, Volume, "id:pZx9jonGBXve"],Object[Data, Volume, "id:Vrbp1jG8MnNw"],Object[Data, Volume, "id:qdkmxz0ABRNm"],Object[Data, Volume, "id:GmzlKjY5MGJM"],Object[Data, Volume, "id:o1k9jAKOB4N8"],Object[Data, Volume, "id:lYq9jRzXB0N3"],Object[Data, Volume, "id:E8zoYveRMXBw"],Object[Data, Volume, "id:kEJ9mqaVBWNe"],Object[Data, Volume, "id:3em6Zv9NPzBo"],Object[Data, Volume, "id:aXRlGnZmBPWm"],Object[Data, Volume, "id:J8AY5jwzMEBE"],Object[Data, Volume, "id:rea9jl1oBGqx"],Object[Data, Volume, "id:KBL5DvYlMkEN"],Object[Data, Volume, "id:N80DNjlYMJPl"],Object[Data, Volume, "id:xRO9n3vkdazO"],Object[Data, Volume, "id:9RdZXvKB5809"],Object[Data, Volume, "id:BYDOjv1VMZqX"],Object[Data, Volume, "id:WNa4ZjRrB1wV"],Object[Data, Volume, "id:n0k9mGzRBepw"],Object[Data, Volume, "id:1ZA60vwjYOl0"],Object[Data, Volume, "id:dORYzZn0B8wq"],Object[Data, Volume, "id:pZx9jonGBXVe"],Object[Data, Volume, "id:Vrbp1jG8Mnww"],Object[Data, Volume, "id:R8e1PjRDMvwj"],Object[Data, Volume, "id:GmzlKjY5MGoM"],Object[Data, Volume, "id:o1k9jAKOB458"],Object[Data, Volume, "id:lYq9jRzXB0d3"],Object[Data, Volume, "id:E8zoYveRMXGw"],Object[Data, Volume, "id:kEJ9mqaVBWZe"],Object[Data, Volume, "id:3em6Zv9NPzEo"],Object[Data, Volume, "id:aXRlGnZmBPwm"],Object[Data, Volume, "id:J8AY5jwzMELE"],Object[Data, Volume, "id:rea9jl1oBG3x"],Object[Data, Volume, "id:jLq9jXY45Box"],Object[Data, Volume, "id:N80DNjlYMJOl"],Object[Data, Volume, "id:xRO9n3vkdarO"],Object[Data, Volume, "id:9RdZXvKB58z9"],Object[Data, Volume, "id:BYDOjv1VMZnX"],Object[Data, Volume, "id:WNa4ZjRrB1kV"],Object[Data, Volume, "id:n0k9mGzRBeEw"],Object[Data, Volume, "id:1ZA60vwjYOV0"],Object[Data, Volume, "id:dORYzZn0B8Xq"],Object[Data, Volume, "id:pZx9jonGBXke"],Object[Data, Volume, "id:XnlV5jmbBdPP"],Object[Data, Volume, "id:R8e1PjRDMvzj"]};
		blank5={Object[Data, Volume, "id:mnk9jO3qBZOm"],Object[Data, Volume, "id:M8n3rxYEMaxR"],Object[Data, Volume, "id:54n6evKxDYvv"],Object[Data, Volume, "id:01G6nvkKEqvE"],Object[Data, Volume, "id:Z1lqpMGjBVM4"],Object[Data, Volume, "id:eGakld01Bbdz"],Object[Data, Volume, "id:4pO6dMWv3LMX"],Object[Data, Volume, "id:XnlV5jmbBdj3"],Object[Data, Volume, "id:R8e1PjRDMvj4"],Object[Data, Volume, "id:qdkmxz0ABRL0"],Object[Data, Volume, "id:O81aEB4kMrO1"],Object[Data, Volume, "id:AEqRl954M0bd"],Object[Data, Volume, "id:zGj91aR3prJx"],Object[Data, Volume, "id:L8kPEjNLM3X6"],Object[Data, Volume, "id:Y0lXejGKBpPo"],Object[Data, Volume, "id:P5ZnEj4PMKGE"],Object[Data, Volume, "id:D8KAEvdqM40L"],Object[Data, Volume, "id:wqW9BP4YZ3DO"],Object[Data, Volume, "id:8qZ1VWNmJwbn"],Object[Data, Volume, "id:KBL5DvYlMkVv"],Object[Data, Volume, "id:7X104vK9wDWw"],Object[Data, Volume, "id:vXl9j5qE1k3m"],Object[Data, Volume, "id:6V0npvK6aPb1"],Object[Data, Volume, "id:mnk9jO3qBZAK"],Object[Data, Volume, "id:M8n3rxYEMaqO"],Object[Data, Volume, "id:54n6evKxDYbl"],Object[Data, Volume, "id:01G6nvkKEqbK"],Object[Data, Volume, "id:Z1lqpMGjBV3V"],Object[Data, Volume, "id:eGakld01BbBo"],Object[Data, Volume, "id:Vrbp1jG8MnMo"],Object[Data, Volume, "id:qdkmxz0ABRB0"],Object[Data, Volume, "id:O81aEB4kMrM1"],Object[Data, Volume, "id:AEqRl954M0Md"],Object[Data, Volume, "id:zGj91aR3prpx"],Object[Data, Volume, "id:L8kPEjNLM3M6"],Object[Data, Volume, "id:Y0lXejGKBpBo"],Object[Data, Volume, "id:P5ZnEj4PMKME"],Object[Data, Volume, "id:D8KAEvdqM4ML"],Object[Data, Volume, "id:wqW9BP4YZ3ZO"],Object[Data, Volume, "id:rea9jl1oBGB3"],Object[Data, Volume, "id:KBL5DvYlMkMv"],Object[Data, Volume, "id:7X104vK9wDww"],Object[Data, Volume, "id:vXl9j5qE1k1m"],Object[Data, Volume, "id:6V0npvK6aPa1"],Object[Data, Volume, "id:mnk9jO3qBZBK"],Object[Data, Volume, "id:M8n3rxYEMaMO"],Object[Data, Volume, "id:54n6evKxDYDl"],Object[Data, Volume, "id:01G6nvkKEqEK"],Object[Data, Volume, "id:Z1lqpMGjBVBV"],Object[Data, Volume, "id:pZx9jonGBXM5"],Object[Data, Volume, "id:Vrbp1jG8Mnlo"],Object[Data, Volume, "id:qdkmxz0ABRM0"],Object[Data, Volume, "id:n0k9mGzRBeMk"],Object[Data, Volume, "id:1ZA60vwjYOqP"],Object[Data, Volume, "id:dORYzZn0B8MA"],Object[Data, Volume, "id:pZx9jonGBXMP"],Object[Data, Volume, "id:Vrbp1jG8MnlO"]};
		allBlanks={blank0,blank1,blank2,blank3,blank4,blank5};
	)
];
