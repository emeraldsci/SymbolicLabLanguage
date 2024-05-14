(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*PlotShared: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*Option Resolution*)


(* ::Subsubsection::Closed:: *)
(*FindPlotRange*)


DefineTests[
	FindPlotRange,
	{
		Example[{Basic, "Calculate Full plot range:"},
			FindPlotRange[Full, Table[{x, Sin[x] + 5}, {x, -4, 2, .05}]],
			{{0.`,2.`},{-0.1499945941047334`,6.149778358294091`}}
		],
		Example[{Basic, "Calculate Automatic plot range for X coordinates:"},
			FindPlotRange[{Automatic, Full}, Table[{x, Sin[x] + 5}, {x, -4, 2, .05}]],
			{{-4.`,2.`},{-0.1499945941047334`,6.149778358294091`}}
		],
		Example[{Basic, "Calculate Automatic plot range:"},
			FindPlotRange[Automatic, Table[{x, Sin[x] + 5}, {x, -4, 2, .05}],ScaleX->1.5],
			{{-7.`,5.`},{3.9502270476011754`,6.049772952398825`}}
		],
		Example[{Additional, "Automatic plot range shows all the data:"},
			ListPlot[sinCurveData, PlotRange->FindPlotRange[Automatic, sinCurveData]],
			_?ValidGraphicsQ
		],
		Example[{Additional, "Automatic is the same as All if there are no other constraints:"},
			ListPlot[sinCurveData, PlotRange->FindPlotRange[All, sinCurveData]],
			_?ValidGraphicsQ
		],
		Example[{Additional, "To see all the data and the x-Axis use PlotRange\[Rule]{All, Full}:"},
			ListPlot[sinCurveData, PlotRange->FindPlotRange[{All, Full}, sinCurveData]],
			_?ValidGraphicsQ
		],
		Example[{Additional, "Automatic will be constrained by other values:"},
			ListPlot[sinCurveData, PlotRange->FindPlotRange[{Automatic, {4,5}}, sinCurveData]],
			_?ValidGraphicsQ
		],
		Example[{Additional, "Calculate Automatic plot range for X coordinates:"},
			FindPlotRange[{Automatic, Full}, Table[{x, Sin[x] + 5}, {x, -4, 2, .05}]],
			{{-4.`,2.`},{-0.1499945941047334`,6.149778358294091`}}
		],
		Example[{Additional, "If only one one coordinate is set to Automatic it will be constrained by the other values:"},
			FindPlotRange[{{Automatic,4},{2,3}}, {{1,1}, {2,2}, {3,3}, {4,4}, {5,5}, {6,6}}],
			{{2,4},{1.975`,3.025`}}
		],
		Example[{Additional, "Can be used on DateCoordinateP:"},
			FindPlotRange[Automatic, {{{2013,3,22,11,58,34.9424048`9.295927687037397},10},{{2013,3,23,11,58,34.9434049`9.295940116968822},9},{{2013,3,24,11,58,34.944405`9.295952546544516},7},{{2013,3,25,11,58,34.945405`9.295964974521706},0},{{2013,3,26,11,58,34.9464051`9.295977403385985},10},{{2013,3,27,11,58,34.9474051`9.29598983065188},3},{{2013,3,28,11,58,34.9484052`9.296002258804856},5},{{2013,3,29,11,58,34.9494052`9.296014685359552},5},{{2013,3,30,11,58,34.9504053`9.296027112801294},10},{{2013,3,31,11,58,34.9514054`9.296039539887433},3}}],
			{{{2013,3,22,11,58,34.942`},{2013,3,31,11,58,34.951`}},{-0.2499999999999991`,10.25`}},
			EquivalenceFunction->RoundMatchQ[5]
		],
		Example[{Options, ScaleX, "Scale the X axis by a factor of 2:"},
			FindPlotRange[{Automatic, {1,3}}, {{1,1}, {2,2}, {3,3}, {4,4}, {5,5}, {6,6}}, ScaleX -> 2],
			{{-1,5},{0.9500000000000002`,3.05`}}
		],
		Example[{Options, ScaleY, "Scale the Y axis by a factor of 2:"},
			FindPlotRange[{Automatic, {1,3}}, {{1,1}, {2,2}, {3,3}, {4,4}, {5,5}, {6,6}}, ScaleY -> 2],
			{{1,3},{-1,5}}
		],
		Test["Calculate Automatic plot range for X coordinates:",
			FindPlotRange[{Automatic, {1,3}}, {{1,1}, {2,2}, {3,3}, {4,4}, {5,5}, {6,6}}], {{1,3},
			{0.9500000000000002`,3.05`}}
		],
		Test["Calculate Automatic plot range for Y coordinates:",
			FindPlotRange[{{1,3}, Automatic}, {{1,1}, {2,2}, {3,3}, {4,4}, {5,5}, {6,6}}],
			{{1,3},{0.9500000000000002`,3.05`}}
		],
		Test["Calculate Automatic plot range for X coordinates:",
			FindPlotRange[Automatic, {{1.1, 1}, {2,2}, {3,3}, {4,4}, {5,5}}],
			{{1.1`,5.`},{0.9000000000000004`,5.1`}}
		],
		Test["Calculate Full plot range:",
			FindPlotRange[ Full, {{1,1}, {2,2}, {3,3}, {4,4}, {5,5}, {6,6}}],
			{{0,6}, {-0.14999999999999947`,6.1499999999999995`}}
		],
		Test["Calculate Full plot range for Y coordinates:",
			FindPlotRange[{{1,2}, Full}, {{1,1}, {2,2}, {3,3}, {4,4}, {5,5}, {6,6}}],
			{{1,2},{-0.14999999999999947`,6.1499999999999995`}}
		],
		Test["Calculate Full plot range for X coordinates:",
			FindPlotRange[{{1,5},{3,Automatic}}, {{1,1}, {2,2}, {3,3}, {4,4}, {5,5}, {6,6}},  ScaleX->1.1, ScaleY->1.3],
			{{0.5999999999999996`,5.4`},{2.4`,5.6`}}
		],
		Test["Calculate Automatic plot range for all coordinates except one:",
			FindPlotRange[{Automatic, {Automatic, 5}}, {{1,1}, {2,2}, {3,3}, {4,4}, {5,5}, {6,6}}],
			{{1,5},{0.9000000000000004`,5.1`}}
		],
		Test["Calculate Full plot range for X coordinates and Automatic for one other coordinate:",
			FindPlotRange[{Full, {Automatic, 5}}, {{1,1}, {2,2}, {3,3}, {4,4}, {5,5}, {6,6}}],
			{{0,6},{0.9000000000000004`,5.1`}}
		],
		Test["Calculate Automatic Full range:",
			FindPlotRange[Full, {3,4,5,6,7}],{{0,5},{-0.17499999999999938`,7.174999999999999`}}
		],
		Test["Calculate range for DateCoordinateP:",
			FindPlotRange[{Automatic, {1,3}}, {{{2013,3,22,11,58,34.9424048`9.295927687037397},10},{{2013,3,23,11,58,34.9434049`9.295940116968822},9},{{2013,3,24,11,58,34.944405`9.295952546544516},7},{{2013,3,25,11,58,34.945405`9.295964974521706},0},{{2013,3,26,11,58,34.9464051`9.295977403385985},10},{{2013,3,27,11,58,34.9474051`9.29598983065188},3},{{2013,3,28,11,58,34.9484052`9.296002258804856},5},{{2013,3,29,11,58,34.9494052`9.296014685359552},5},{{2013,3,30,11,58,34.9504053`9.296027112801294},10},{{2013,3,31,11,58,34.9514054`9.296039539887433},3}}],
			 {{{2013,3,27,11,58,34.947`},{2013,3,31,11,58,34.951`}},{0.9500000000000002`,3.05`}},
			EquivalenceFunction->RoundMatchQ[5]
		],
		Test["Calculate range for DateCoordinateP:",
			FindPlotRange[{{{2013,3,21,12,2,28.6507722`9.20971124442166},{2013,3,26,12,2,56.7013766`9.506168439271109}}, Full}, {{{2013,3,22,11,58,34.9424048`9.295927687037397},10},{{2013,3,23,11,58,34.9434049`9.295940116968822},9},{{2013,3,24,11,58,34.944405`9.295952546544516},7},{{2013,3,25,11,58,34.945405`9.295964974521706},0},{{2013,3,26,11,58,34.9464051`9.295977403385985},10},{{2013,3,27,11,58,34.9474051`9.29598983065188},3},{{2013,3,28,11,58,34.9484052`9.296002258804856},5},{{2013,3,29,11,58,34.9494052`9.296014685359552},5},{{2013,3,30,11,58,34.9504053`9.296027112801294},10},{{2013,3,31,11,58,34.9514054`9.296039539887433},3}}],
			{{{2013,3,21,12,2,28.651`},{2013,3,26,12,2,56.701`}},{-0.2499999999999991`,10.25`}},
			EquivalenceFunction->RoundMatchQ[5]
		],
		Test["Calculate range for DateCoordinateP:",
			FindPlotRange[{{{2013,3,21,12,2,28.6507722`9.20971124442166},{2013,3,26,12,2,56.7013766`9.506168439271109}},{3,Automatic}}, {{{2013,3,22,11,58,34.9424048`9.295927687037397},10},{{2013,3,23,11,58,34.9434049`9.295940116968822},9},{{2013,3,24,11,58,34.944405`9.295952546544516},7},{{2013,3,25,11,58,34.945405`9.295964974521706},0},{{2013,3,26,11,58,34.9464051`9.295977403385985},10},{{2013,3,27,11,58,34.9474051`9.29598983065188},3},{{2013,3,28,11,58,34.9484052`9.296002258804856},5},{{2013,3,29,11,58,34.9494052`9.296014685359552},5},{{2013,3,30,11,58,34.9504053`9.296027112801294},10},{{2013,3,31,11,58,34.9514054`9.296039539887433},3}},  ScaleX->1.1, ScaleY->1.3],
			{{{2013,3,22,0,2,31.455999999998312`},{2013,3,26,0,2,53.89600000000064`}},{0.8999999999999995`,12.100000000000001`}},
			EquivalenceFunction->RoundMatchQ[5]
		],
		Test["Calculate range for DateCoordinateP:",
			FindPlotRange[{{{2013,3,21,12,2,28.6507722`9.20971124442166},{2013,3,26,12,2,56.7013766`9.506168439271109}}, Automatic}, {{{2013,3,22,11,58,34.9424048`9.295927687037397},10},{{2013,3,23,11,58,34.9434049`9.295940116968822},9},{{2013,3,24,11,58,34.944405`9.295952546544516},7},{{2013,3,25,11,58,34.945405`9.295964974521706},0},{{2013,3,26,11,58,34.9464051`9.295977403385985},10},{{2013,3,27,11,58,34.9474051`9.29598983065188},3},{{2013,3,28,11,58,34.9484052`9.296002258804856},5},{{2013,3,29,11,58,34.9494052`9.296014685359552},5},{{2013,3,30,11,58,34.9504053`9.296027112801294},10},{{2013,3,31,11,58,34.9514054`9.296039539887433},3}}],
			{{{2013,3,21,12,2,28.651`},{2013,3,26,12,2,56.701`}},{-0.2499999999999991`,10.25`}},
			EquivalenceFunction->RoundMatchQ[5]
		],
		Test["Calculate range for DateCoordinateP:",
			FindPlotRange[{{Automatic,{2013,3,26,12,2,56.7013766`9.506168439271109}},{2,3}}, {{{2013,3,22,11,58,34.9424048`9.295927687037397},10},{{2013,3,23,11,58,34.9434049`9.295940116968822},9},{{2013,3,24,11,58,34.944405`9.295952546544516},7},{{2013,3,25,11,58,34.945405`9.295964974521706},0},{{2013,3,26,11,58,34.9464051`9.295977403385985},10},{{2013,3,27,11,58,34.9474051`9.29598983065188},3},{{2013,3,28,11,58,34.9484052`9.296002258804856},5},{{2013,3,29,11,58,34.9494052`9.296014685359552},5},{{2013,3,30,11,58,34.9504053`9.296027112801294},10},{{2013,3,31,11,58,34.9514054`9.296039539887433},3}}],
			{{{2013,3,27,11,58,34.947`},{2013,3,31,11,58,34.951`}},{1.975`,3.025`}},
			EquivalenceFunction->RoundMatchQ[5]
		],
		Test["Calculate range for DateCoordinateP:",
			FindPlotRange[{Automatic, {Automatic, 5}}, {{{2013,3,22,11,58,34.9424048`9.295927687037397},10},{{2013,3,23,11,58,34.9434049`9.295940116968822},9},{{2013,3,24,11,58,34.944405`9.295952546544516},7},{{2013,3,25,11,58,34.945405`9.295964974521706},0},{{2013,3,26,11,58,34.9464051`9.295977403385985},10},{{2013,3,27,11,58,34.9474051`9.29598983065188},3},{{2013,3,28,11,58,34.9484052`9.296002258804856},5},{{2013,3,29,11,58,34.9494052`9.296014685359552},5},{{2013,3,30,11,58,34.9504053`9.296027112801294},10},{{2013,3,31,11,58,34.9514054`9.296039539887433},3}}],
			{{{2013,3,25,11,58,34.945`},{2013,3,31,11,58,34.951`}},{-0.12499999999999956`,5.125`}},
			EquivalenceFunction->RoundMatchQ[5]
		],
		Test["Calculate range for DateCoordinateP:",
			FindPlotRange[{Full, {Automatic, 5}}, {{{2013,3,22,11,58,34.9424048`9.295927687037397},10},{{2013,3,23,11,58,34.9434049`9.295940116968822},9},{{2013,3,24,11,58,34.944405`9.295952546544516},7},{{2013,3,25,11,58,34.945405`9.295964974521706},0},{{2013,3,26,11,58,34.9464051`9.295977403385985},10},{{2013,3,27,11,58,34.9474051`9.29598983065188},3},{{2013,3,28,11,58,34.9484052`9.296002258804856},5},{{2013,3,29,11,58,34.9494052`9.296014685359552},5},{{2013,3,30,11,58,34.9504053`9.296027112801294},10},{{2013,3,31,11,58,34.9514054`9.296039539887433},3}}],
			{{{2013,3,22,11,58,34.942`},{2013,3,31,11,58,34.951`}},{-0.12499999999999956`,5.125`}},
			EquivalenceFunction->RoundMatchQ[5]
		],
		Test["Calculate range for DateCoordinateP:",
			FindPlotRange[ Full, {{{2013,3,22,11,58,34.9424048`9.295927687037397},10},{{2013,3,23,11,58,34.9434049`9.295940116968822},9},{{2013,3,24,11,58,34.944405`9.295952546544516},7},{{2013,3,25,11,58,34.945405`9.295964974521706},0},{{2013,3,26,11,58,34.9464051`9.295977403385985},10},{{2013,3,27,11,58,34.9474051`9.29598983065188},3},{{2013,3,28,11,58,34.9484052`9.296002258804856},5},{{2013,3,29,11,58,34.9494052`9.296014685359552},5},{{2013,3,30,11,58,34.9504053`9.296027112801294},10},{{2013,3,31,11,58,34.9514054`9.296039539887433},3}}],
			{{{2013,3,22,11,58,34.942`},{2013,3,31,11,58,34.951`}},{-0.2499999999999991`,10.25`}},
			EquivalenceFunction->RoundMatchQ[5]
		],
		Test["Calculate range for DateCoordinateP:",
			FindPlotRange[{{{2011,11,10,17,1,0.`},DateObject[{2012,11,20},TimeObject[{17,1,0.`}]]},{0,20}},{{DateObject[{2012,11,9},TimeObject[{17,1,0.`}]],6},{DateObject[{2012,11,10},TimeObject[{17,1,0.`}]],8},{DateObject[{2012,11,11},TimeObject[{17,1,0.`}]],5},{DateObject[{2012,11,12},TimeObject[{17,1,0.`}]],10},{DateObject[{2012,11,13},TimeObject[{17,1,0.`}]],2},{DateObject[{2012,11,14},TimeObject[{17,1,0.`}]],2},{DateObject[{2012,11,15},TimeObject[{17,1,0.`}]],7},{DateObject[{2012,11,16},TimeObject[{17,1,0.`}]],5},{DateObject[{2012,11,17},TimeObject[{17,1,0.`}]],7},{DateObject[{2012,11,18},TimeObject[{17,1,0.`}]],4},{DateObject[{2012,11,19},TimeObject[{17,1,0.`}]],9},{DateObject[{2012,11,20},TimeObject[{17,1,0.`}]],7}}],
			{{{2011,11,10,17,1,EqualP[0]},{2012,11,20,17,1,EqualP[0]}},{-0.4999999999999982`,20.5`}},
			EquivalenceFunction->RoundMatchQ[5]
		]
	},
	Variables:>{sinCurveData},
	SetUp:>(sinCurveData=Table[{x, Sin[x] + 5}, {x, -4, 2, .05}])
];


(* ::Subsection:: *)
(*Plot Specific Convert Functions*)



(* ::Subsection::Closed:: *)
(*AutomaticYRange*)


DefineTests[AutomaticYRange,{
	Example[{Basic,"Generates a Y axis range for integers:"},
		AutomaticYRange[integerData,10],
		{_?NumericQ,_?NumericQ}
	],
	Example[{Basic,"Generates a Y axis range for identical Y axis value:"},
		AutomaticYRange[identicalNumeric,20],
		{_?NumericQ,_?NumericQ}
	],
	Example[{Basic,"Generates a Y axis range for data with units:"},
		AutomaticYRange[celsiusData,10],
		{_?NumericQ,_?NumericQ}
	]
	},
	Variables:>{celsiusData,integerData},
	SetUp:>(
		integerData={
			{DateObject[{2017, 8, 17, 7, 41, 12}, "Instant", "Gregorian", -7.`], 25184},
			{DateObject[{2017, 8, 17, 7, 42, 13}, "Instant", "Gregorian", -7.`], 25183},
			{DateObject[{2017, 8, 17, 7, 43, 13}, "Instant", "Gregorian", -7.`], 25179},
			{DateObject[{2017, 8, 17, 7, 44, 13}, "Instant", "Gregorian", -7.`], 25186},
			{DateObject[{2017, 8, 17, 7, 45, 13}, "Instant","Gregorian", -7.`], 25180},
			{DateObject[{2017, 8, 17, 7, 46, 13}, "Instant",  "Gregorian", -7.`], 25183},
			{DateObject[{2017, 8, 17, 7, 47, 13}, "Instant",  "Gregorian", -7.`], 25180},
			{DateObject[{2017, 8, 17, 7, 48, 13}, "Instant", "Gregorian", -7.`], 25186},
			{DateObject[{2017, 8, 17, 7, 49, 13}, "Instant", "Gregorian", -7.`], 25184},
			{DateObject[{2017, 8, 17, 7, 50, 13}, "Instant", "Gregorian", -7.`], 25179},
			{DateObject[{2017, 8, 17, 7, 51, 13}, "Instant", "Gregorian", -7.`], 25221},
			{DateObject[{2017, 8, 17, 7, 52, 13}, "Instant", "Gregorian", -7.`], 25216},
			{DateObject[{2017, 8, 17, 7, 53, 13}, "Instant","Gregorian", -7.`], 25222},
			{DateObject[{2017, 8, 17, 7, 54, 13}, "Instant", "Gregorian", -7.`], 25221},
			{DateObject[{2017, 8, 17, 7, 55, 13}, "Instant", "Gregorian", -7.`], 25180}
		};
		celsiusData={
			{DateObject[{2017, 8, 17, 7, 41, 12}, "Instant", "Gregorian", -7.], Quantity[25.184, "DegreesCelsius"]},
			{DateObject[{2017, 8, 17, 7, 42, 13},"Instant", "Gregorian", -7.],  Quantity[25.183,"DegreesCelsius"]},
			{DateObject[{2017, 8, 17, 7, 43, 13}, "Instant", "Gregorian", -7.], Quantity[25.179, "DegreesCelsius"]},
			{DateObject[{2017, 8, 17, 7, 44, 13}, "Instant", "Gregorian", -7.],Quantity[25.186,"DegreesCelsius"]},
			{DateObject[{2017, 8, 17, 7, 45, 13},"Instant", "Gregorian", -7.],Quantity[25.18,"DegreesCelsius"]},
			{DateObject[{2017, 8, 17, 7, 46, 13}, "Instant", "Gregorian", -7.], Quantity[25.183,"DegreesCelsius"]},
			{DateObject[{2017, 8, 17, 7, 47, 13},"Instant", "Gregorian", -7.], Quantity[25.18,"DegreesCelsius"]},
			{DateObject[{2017, 8, 17, 7, 48, 13},"Instant", "Gregorian", -7.],Quantity[25.186, "DegreesCelsius"]},
			{DateObject[{2017, 8, 17, 7, 49, 13}, "Instant", "Gregorian", -7.], Quantity[25.184, "DegreesCelsius"]},
			{DateObject[{2017, 8, 17, 7, 50, 13},  "Instant", "Gregorian", -7.], Quantity[25.179, "DegreesCelsius"]},
			{DateObject[{2017, 8, 17, 7, 51, 13}, "Instant", "Gregorian", -7.],Quantity[25.221, "DegreesCelsius"]},
			{DateObject[{2017, 8, 17, 7, 52, 13}, "Instant", "Gregorian", -7.], Quantity[25.216, "DegreesCelsius"]},
			{DateObject[{2017, 8, 17, 7, 53, 13}, "Instant", "Gregorian", -7.],  Quantity[25.222, "DegreesCelsius"]},
			{DateObject[{2017, 8, 17, 7, 54, 13}, "Instant", "Gregorian", -7.],Quantity[25.221, "DegreesCelsius"]},
			{DateObject[{2017, 8, 17, 7, 55, 13}, "Instant", "Gregorian", -7.], Quantity[25.18, "DegreesCelsius"]}
		};
		identicalNumeric={
			{DateObject[{2017, 8, 17, 7, 41, 12}, "Instant", "Gregorian", -7.`], 25184},
			{DateObject[{2017, 8, 17, 7, 42, 13}, "Instant",   "Gregorian", -7.`], 25184},
			{DateObject[{2017, 8, 17, 7, 43, 13}, "Instant", "Gregorian", -7.`], 25184}
		}
	)
];



(* ::Subsection::Closed:: *)
(*epilogs*)


(* ::Subsubsection:: *)
(*molecularWeightEpilog*)


DefineTests[molecularWeightEpilog,{
	Example[{Basic,"Generates graphical tick marks to be placed in a plot epilog:"},
		Graphics@molecularWeightEpilog[{(1000 Gram)/Mole},PlotRange->{{0,5000},{0,100}}],
		ValidGraphicsP[]
	],
	Example[{Basic,"Raw numbers can be provided as input as well as molecular weights:"},
		molecularWeightEpilog[{500},PlotRange->{{0,5000},{0,100}}],
		{{Thickness[Large], Opacity[0.5], RGBColor[0.75, 0., 0.25], Line[{{500, 0}, {500, 50.}}],
			Text[Style["500", Background -> Directive[GrayLevel[1], Opacity[0.75]], Bold, 12, FontFamily -> "Arial"],
				{500, 53.}]}}
	],
	Example[{Options,PlotRange,"The PlotRange option must be provided so the function cna format the ticks:"},
		Graphics@molecularWeightEpilog[{500,600,700},PlotRange->{{0,5000},{0,100}}],
		ValidGraphicsP[]
	],
	Example[{Options,Display,"The Display option is used to determine if the Molecular weight will be displayed:"},
		Graphics@molecularWeightEpilog[{500},PlotRange->{{0,5000},{0,100}},Display->{ExpectedMolecularWeight}],
		ValidGraphicsP[]
	],
	Example[{Options,TickColor,"The TickColor option is used to set the color of the molecular weight demarkings on the plot:"},
		Graphics@molecularWeightEpilog[{500},PlotRange->{{0,5000},{0,100}},TickColor->Blue],
		ValidGraphicsP[]
	],
	Example[{Options,Axes,"The TargetUnits option is ignored:"},
		Graphics[molecularWeightEpilog[{500},PlotRange->{{0,5000},{0,100}},TargetUnits->{Gram/Mole,ArbitraryUnit}]],
		ValidGraphicsP[]
	],
	Example[{Options,LabelStyle,"The LabelStyle option sets the style of the text label for the molecular weight:"},
		Graphics[molecularWeightEpilog[{500},PlotRange->{{0,5000},{0,100}},LabelStyle->{Bold,Blue,12}]],
		ValidGraphicsP[]
	],
	Example[{Options,TickSize,"The TickSize option sets the size of graphical tick (as a fraction of the total plot size):"},
		Graphics[molecularWeightEpilog[{500},PlotRange->{{0,5000},{0,100}},TickSize->1]],
		ValidGraphicsP[]
	],
	Example[{Options,Truncations,"The Truncations option will provide a number of smaller follow up ticks corisponding to the molecular weight of truncations of the provided sequence:"},
		Graphics[molecularWeightEpilog[{500},PlotRange->{{0,5000},{0,100}},Truncations->3]],
		ValidGraphicsP[]
	]

}];


(* ::Subsection::Closed:: *)
(*Sequence, Strand, Structure*)


(* ::Subsubsection::Closed:: *)
(*MotifForm*)


DefineTests[MotifForm,{
	Example[
		{Basic,"View a Structure in motif form:"},
		MotifForm[Structure[{Strand[DNA[20,"A"],DNA[20,"B"],DNA[20,"C"]]},{}]],
		_Interpretation
	],
	Example[
		{Basic,"View a Structure in motif form:"},
		MotifForm[Structure[{Strand[DNA[20,"A"],DNA[20,"B"],DNA[20,"C"]],Strand[DNA[20,"D'"],DNA[20,"C'"],DNA[20,"B'"]]},{Bond[{1,2},{2,3}],Bond[{1,3},{2,2}]}]],
		_Interpretation
	],
	Example[
		{Basic,"View a Structure in motif form:"},
		MotifForm[Structure[{Strand[DNA[20,"A"],DNA[20,"B"],DNA[20,"C"]],Strand[DNA[20,"D'"],DNA[20,"C'"],DNA[20,"B'"]]},{Bond[{1,2,1;;20},{2,3,1;;20}],Bond[{1,3},{2,2}]}]],
		_Interpretation
	],
	Example[
		{Basic,"View a Structure in motif form:"},
		MotifForm[Structure[{Strand[DNA[20,"A"],DNA["ATCGATCGAT","B"],DNA[20,"C"]],Strand[DNA[20,"D'"],DNA[20,"C'"],DNA["ATCGATCGAT","B'"]]},{Bond[{1,2,1;;10},{2,3,1;;10}],Bond[{1,3},{2,2}]}]],
		_Interpretation
	],
	Example[{Basic,"Digs into arbitrary expressions to find strands and structures:"},
		MotifForm[{ToStructure[StrandJoin[Strand[DNA[15,"T"]],Strand[DNA[25,"D"]]]],{StrandJoin[Strand[Modification["Dabcyl"]],ReverseComplementSequence[Strand[DNA[25,"D"]]],ReverseComplementSequence[Strand[DNA[15,"T"]]]],StrandJoin[Strand[DNA[25,"D"]],Strand[Modification["Fluorescein"]]]}}],
		{_Interpretation,{_Interpretation, _Interpretation}}
	],

	Test["A strand:",
		MotifForm[StrandJoin[Strand[DNA[15,"T"]],Strand[DNA[25,"D"]]]],
		_Interpretation
	],
	Test["Strand with single motif:",
		MotifForm[Strand[DNA[20]]],
		_Interpretation
	],
	Test["Strand with single labeled motif:",
		MotifForm[Strand[DNA[20,"A"]]],
		_Interpretation
	],
	Test["Structure with mixed bond formats:",
		MotifForm[Structure[{Strand[DNA[20,"A"],DNA[10,"B"],DNA[20,"C"]],Strand[DNA[20,"D'"],DNA[20,"C'"],DNA[10,"B'"]]},{Bond[{1,2,1;;10},{2,3,1;;10}],Bond[{1,3},{2,2}]}]],
		_Interpretation
	]

}];

(* ::Subsubsection::Closed:: *)
(*MotifFormP*)

DefineTests["MotifFormP",{
	Example[{Basic,"Matches the output of MotifForm when the input is a Strand:"},
		MatchQ[
			MotifForm[Strand[DNA["ATCG","X"],RNA["AUUU","Y"],Modification["Fluorescein"]]],
			MotifFormP
		],
		True
	],
	Example[{Basic,"Matches the output of MotifForm when the input is a Structure:"},
		MatchQ[
			MotifForm[Structure[{Strand[DNA[15,"A"],DNA["ATATAGCATAG","B"],DNA[15,"C"],Modification["Fluorescein"]],Strand[DNA[15,"C"],RNA["AUAUAGCAUAG","D"],DNA[15,"A'"],RNA[7,"E"]]},{Bond[{1,1},{2,3}],Bond[{1,3},{2,1}]}]],
			MotifFormP
		],
		True
	],
	Example[{Basic,"Doesn't match the output of MotifForm when the input is an arbitrary expression with Strands and Structures:"},
		MatchQ[
			MotifForm[{ToStructure[StrandJoin[Strand[DNA[15,"T"]],Strand[DNA[25,"D"]]]],{StrandJoin[Strand[Modification["Dabcyl"]],ReverseComplementSequence[Strand[DNA[25,"D"]]],ReverseComplementSequence[Strand[DNA[15,"T"]]]],StrandJoin[Strand[DNA[25,"D"]],Strand[Modification["Fluorescein"]]]}}],
			MotifFormP
		],
		False
	],
	Example[{Basic,"Matches each element of the nested listed output of MotifForm when the input is an arbitrary expression with Strands and Structures:"},
		MatchQ[
			MotifForm[{ToStructure[StrandJoin[Strand[DNA[15,"T"]],Strand[DNA[25,"D"]]]],{StrandJoin[Strand[Modification["Dabcyl"]],ReverseComplementSequence[Strand[DNA[25,"D"]]],ReverseComplementSequence[Strand[DNA[15,"T"]]]],StrandJoin[Strand[DNA[25,"D"]],Strand[Modification["Fluorescein"]]]}}],
			{MotifFormP,{MotifFormP,MotifFormP}}
		],
		True
	],
	Example[{Basic,"Matches the output of MotifForm when the input is a String representing a strand of DNA:"},
		MatchQ[
			MotifForm["ATGCGTAGGC"],
			MotifFormP
		],
		True
	]
}];


(* ::Subsubsection::Closed:: *)
(*StructureForm*)


DefineTests[StructureForm,
{
		Example[{Basic,"View a sequence in structure form:"},
			StructureForm["GCCCATCCTGATCGAGCT"],
			_Interpretation],
		Example[{Basic,"View a Strand in structure form:"},
			StructureForm[Strand[Modification["Fluorescein"],DNA["GCCCATCCTGATCGAGCT"],Modification["Bhqtwo"]]],
			_Interpretation
		],
		Example[
			{Basic,"View a Structure in structure form:"},
			StructureForm[Structure[{Strand[DNA["ACGT"]]},{}]],
			_Interpretation
		],
		Example[{Basic,"Digs into arbitrary expressions to find strands and structures:"},
			StructureForm[{ToStructure[StrandJoin[Strand[DNA[15,"T"]],Strand[DNA[25,"D"]]]],{StrandJoin[Strand[Modification["Dabcyl"]],ReverseComplementSequence[Strand[DNA[25,"D"]]],ReverseComplementSequence[Strand[DNA[15,"T"]]]],StrandJoin[Strand[DNA[25,"D"]],Strand[Modification["Fluorescein"]]]}}],
			{_Interpretation,{_Interpretation, _Interpretation}}
		],
		Test[
			"Another structure:",
			StructureForm[Structure[{Strand[DNA["ACGT","X"]]},{}]],
			_Interpretation
		],
		Example[
			{Additional,"View a Structure in structure form:"},
			StructureForm[Structure[{Strand[DNA["ACGTACGTACGT","X"],DNA["ACTGATCGTA","Y"]]},{Bond[{1,1,1;;4},{1,1,5;;8}]}]],
			_Interpretation
		],
		Example[
			{Additional,"View a Structure in structure form:"},
			StructureForm[Structure[{Strand[DNA["ATCAACATGCAG","B"]],Strand[DNA["ATCGATCGTCAG","E"]]},{Bond[{1,1,1;;5},{2,1,2;;6}]}]],
			_Interpretation
		],
		Example[
			{Additional,"View a Structure in structure form:"},
			StructureForm[Structure[{Strand[Modification["Dabcyl",""],DNA["ATCAACATGCAG","B"]],Strand[DNA["ATCGATCGTCAG","E"]]},{Bond[{1,2,1;;5},{2,1,2;;6}]}]],
			_Interpretation
		],
		Example[
			{Additional,"View a Structure in structure form:"},
			StructureForm[Structure[{Strand[Modification["Dabcyl",""],DNA["AGGACTGATGTG","A"],DNA["ATCAACATGCAG","B"]],Strand[RNA["UUUUUU","D"],DNA["ATCGATCGTCAG","E"],RNA["UGUGUGUGUG","F"]]},{Bond[{1,3,4;;8},{2,2,2;;6}]}]],
			_Interpretation
		],
		Example[
			{Additional,"View a Structure in structure form:"},
			StructureForm[Strand[Modification["Dabcyl",""],DNA["AGGGTGAAACTCTAAGCCGT","A"],DNA["ATCCAATGCGACAG","B"]]],
			_Interpretation
		],
		Example[
			{Additional,"View a Structure in structure form:"},
			StructureForm[Structure[{Strand[DNA[20,"A"],DNA[20,"B"]],Strand[DNA[20,"D'"],DNA[20,"B'"]]},{Bond[{1,2},{2,2}]}]],
			_Interpretation
		],
		Example[
			{Additional,"View a Structure in structure form:"},
			StructureForm[Structure[{Strand[DNA[20,"A"],DNA[20,"B"]],Strand[DNA[20,"D'"],DNA[20,"B'"]]},{Bond[{1,2,1;;10},{2,2,1;;10}]}]],
			_Interpretation
		],
		Example[
			{Additional,"View a Structure in structure form:"},
			StructureForm[Structure[{Strand[Modification["Fluorescein"],DNA["GCCCATCCTGATCGAGCT"],Modification["Bhqtwo"]],Strand[DNA["CCTCGCCGCTCACGCTGAACTTGTGGCCATTCACATCGCCATTCAGCTCGATCAGGATGGGCACGATGCCGGTGAACAGCTCGGCGCCCTTGCTCACCAT"]],Strand[DNA["TGGTGAGCAAGGGCGCCG"]]},{Bond[{2,1,82;;99},{3,1,1;;18}],Bond[{1,2,1;;18},{2,1,45;;62}]}]],
			_Interpretation
		],
		Example[
			{Additional,"Single base:"},
			StructureForm[Structure[{Strand[DNA["A"]]},{}]],
			_Interpretation
		],


	Test["A strand:",
		StructureForm[StrandJoin[Strand[DNA[15,"T"]],Strand[DNA[25,"D"]]]],
		_Interpretation
	],
	Test["Strand with single motif:",
		StructureForm[Strand[DNA[20]]],
		_Interpretation
	],
	Test["Strand with single labeled motif:",
		StructureForm[Strand[DNA[20,"A"]]],
		_Interpretation
	],
	Test["Strutcure with mixed bond formats:",
		StructureForm[Structure[{Strand[DNA[20,"A"],DNA[10,"B"],DNA[20,"C"]],Strand[DNA[20,"D'"],DNA[20,"C'"],DNA[10,"B'"]]},{Bond[{1,2,1;;10},{2,3,1;;10}],Bond[{1,3},{2,2}]}]],
		_Interpretation
	],
	Test["List of structure with StrandMotifBase bond format:",
		StructureForm[{Structure[{Strand[DNA["AGCGAGTCAGCCAAC", "G'"], DNA["ACCACAGTCTCACACTTTCAGGTCA", "W'"], Modification["Dabcyl"]], Strand[Modification["Fluorescein"], DNA["TGACCTGAAAGTGTGAGACTGTGGT", "W"], DNA["CGGTAGGTACGCTAG", "H"]]}, {Bond[{1, 16 ;; 40}, {2, 2 ;; 26}]}]}],
		{_Interpretation}
  ]
}];


(* ::Section:: *)
(*End Test Package*)
