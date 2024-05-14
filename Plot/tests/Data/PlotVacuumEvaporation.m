(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotVacuumEvaporation*)


DefineTests[PlotVacuumEvaporation,
	{
		Example[
			{Basic,"Plot pressure and temperature data from a vacuum evaporation run:"},
			PlotVacuumEvaporation[Object[Data, VacuumEvaporation, "id:1"]],
			_?ValidGraphicsQ
		],
		Example[
			{Options,Output,"Specify the output option:"},
			options=PlotVacuumEvaporation[Object[Data, VacuumEvaporation, "id:1"],Output->Options];
			Lookup[options,Output],
			Options,
			Variables:>{options}
		],
		Example[
			{Basic,"Plot pressure and temperature data arrays:"},
			PlotVacuumEvaporation[
				QuantityArray[{{Now,10 Milli Bar},{Now + 1 Day,15 Milli Bar},{Now + 2 Day, 20 Milli Bar}}],
				QuantityArray[{{Now,20 Celsius},{Now + 1 Day,20 Celsius},{Now + 2 Day, 20 Celsius}}]
			],
			_?ValidGraphicsQ
		],
		Test["Given a link:",
			PlotVacuumEvaporation[Link[Object[Data, VacuumEvaporation, "id:1"],Reference]],
			_?ValidGraphicsQ
		],
		Test["Given a packet:",
			PlotVacuumEvaporation[Download[Object[Data, VacuumEvaporation, "id:1"]]],
			_?ValidGraphicsQ
		],
		Test["Given output option as Result, returns a plot:",
			PlotVacuumEvaporation[Download[Object[Data, VacuumEvaporation, "id:1"]],Output->Result],
			_?ValidGraphicsQ
		],
		Test["Given output option as Preview, returns a plot:",
			PlotVacuumEvaporation[Download[Object[Data, VacuumEvaporation, "id:1"]],Output->Preview],
			_?ValidGraphicsQ
		],
		Test["Given output option as Options, returns a list of resolved options:",
			PlotVacuumEvaporation[Download[Object[Data, VacuumEvaporation, "id:1"]],Output->Options],
			KeyValuePattern[{}]
		],
		Test["Given output option as Tests, returns {}:",
			PlotVacuumEvaporation[Download[Object[Data, VacuumEvaporation, "id:1"]],Output->Tests],
			{}
		]

	},
	Stubs:>{
		Download[Object[Data, VacuumEvaporation, "id:1"]] = Association[
			Type -> Object[Data,VacuumEvaporation],
			Pressure -> QuantityArray[{{Now,10 Milli Bar},{Now + 1 Day,15 Milli Bar},{Now + 2 Day, 20 Milli Bar}}],
			Temperature -> QuantityArray[{{Now,20 Celsius},{Now + 1 Day,20 Celsius},{Now + 2 Day, 20 Celsius}}]
		],
		Download[Link[Object[Data, VacuumEvaporation, "id:1"],Reference]] = Association[
			Type -> Object[Data,VacuumEvaporation],
			Pressure -> QuantityArray[{{Now,10 Milli Bar},{Now + 1 Day,15 Milli Bar},{Now + 2 Day, 20 Milli Bar}}],
			Temperature -> QuantityArray[{{Now,20 Celsius},{Now + 1 Day,20 Celsius},{Now + 2 Day, 20 Celsius}}]
		]
	}
];
