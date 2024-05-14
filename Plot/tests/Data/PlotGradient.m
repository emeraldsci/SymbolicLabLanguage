(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotGradient*)


DefineTests[PlotGradient,
	{
		Example[{Basic, "Plot a simple binary gradient mixture of Buffer A and B:"},
			PlotGradient[Object[Method,Gradient,"id:P5ZnEj4ldYBR"]],
			_?ValidGraphicsQ
		],
		Example[{Basic, "Plot a more complicated gradient:"},
			PlotGradient[Object[Method,Gradient,"id:xRO9n3voxEa5"]],
			_?ValidGraphicsQ
		],
		Example[{Basic, "Pass ListLinePlot options:"},
			PlotGradient[Object[Method,Gradient,"id:xRO9n3voxEa5"],PlotLabel->"Wild and Crazy Gradient"],
			_?ValidGraphicsQ
		],
		Example[{Basic, "PlotGradient is listable:"},
			PlotGradient[{Object[Method,Gradient,"id:P5ZnEj4ldYBR"],Object[Method,Gradient,"id:xRO9n3voxEa5"]}],
			{_?ValidGraphicsQ..}
		],
		Example[{Options,Buffers,"Plot only data for BufferB:"},
			PlotGradient[Object[Method, Gradient, "id:N80DNj1pbezl"],Buffers->BufferB],
			_?ValidGraphicsQ
		],
		Example[{Options,Buffers,"Plot only data for BufferB and BufferC:"},
			PlotGradient[Object[Method, Gradient, "id:N80DNj1pbezl"],Buffers->{BufferB,BufferC}],
			_?ValidGraphicsQ
		],
		Example[{Options,Buffers,"Plot data for all buffers:"},
			PlotGradient[Object[Method, Gradient, "id:N80DNj1pbezl"],Buffers->All],
			_?ValidGraphicsQ
		],
		Example[{Options,Legend,"Include a custom legend:"},
			PlotGradient[Object[Method,Gradient,"id:P5ZnEj4ldYBR"],Legend->{"Acetonitrile","Water"}],
			_?ValidGraphicsQ
		],
		Example[{Options,PlotRange,"Look at a subset of the full range:"},
			PlotGradient[Object[Method,Gradient,"id:xRO9n3voxEa5"],PlotRange -> {Automatic,{50 Percent,80 Percent}}],
			_?ValidGraphicsQ
		],
		Test["Listable overload accepts mixtures of packets and object references:",
			PlotGradient[{Object[Method,Gradient,"id:P5ZnEj4ldYBR"],Download[Object[Method,Gradient,"id:xRO9n3voxEa5"]]}],
			{_?ValidGraphicsQ..}
		]
	}
];
