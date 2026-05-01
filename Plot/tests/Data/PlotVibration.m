(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotVibration*)


DefineTests[PlotVibration,
	{
		Example[
			{Basic,"Plot a graph of vibrations against time given a data object:"},
			PlotVibration[Object[Data, Vibration, "id:D8KAEv5N0VKb"]],
			ValidGraphicsP[],
			TimeConstraint->500
		],
		Test[
			"Plot a graph of vibrations against time given a packet:",
			PlotVibration[Download[Object[Data, Vibration, "id:zGj91aAw5eBE"]]],
			ValidGraphicsP[],
			TimeConstraint->500
		],
		Example[
			{Basic,"Plot a graph of vibrations against time from a link:"},
			PlotVibration[Link[Object[Data, Vibration, "id:GmzlKjRqEkKE"]]],
			ValidGraphicsP[],
			TimeConstraint->500
		],
		Test[
        	"Plot a graph of vibrations against time from raw data:",
             PlotVibration[Object[Data, Vibration, "id:dORYzZmVjl1w"][RawData][[All, 2]]],
             {ValidGraphicsP[] ..}
        ],
		
	(*
			OPTIONS
		*)
		Example[
		    {Options,TargetUnits,"Plot a graph of vibrations against time with specific units:"},
			PlotVibration[Object[Data, Vibration, "id:n0k9mGKAdJYn"],TargetUnits -> {Automatic, Millimeter/Second^2}],
			ValidGraphicsP[]
		],

		Example[
			{Options,ChartLabels,"Plot a graph of vibrations against time with a specific plot title:"},
			PlotVibration[Object[Data, Vibration, "id:AEqRl9dkGzlp"],
				PlotLabel->"Vibration Checks"],
			ValidGraphicsP[],
			TimeConstraint->500
		]

	}
];
