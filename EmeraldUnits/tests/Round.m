(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*SafeRound*)

DefineTests[SafeRound, {

	Example[{Basic, "Round a real into an integer:"},
		SafeRound[1.1, 1],
		1
	],

	Example[{Basic, "Round one quantity into a quantity of different units:"},
		SafeRound[1000Millitorr, .0001Atmosphere],
		Quantity[988, "Millitorr"]
	],

	Example[{Basic, "Round the values in a list by a single precision:"},
		SafeRound[{1.111, 2.222, 3.333}, {0.001, 0.01, 0.1}],
		{1.111, 2.22, 3.3}
	],

	Test["Ceiling on a value:",
		Ceiling[
			SafeRound[0.013005`, 0.0001],
			0.001
		],
		0.013
	],

	Test["Appropriately handle a symbol with a unitless precision:",
		SafeRound[Automatic, 0.1],
		Automatic
	],

	Test["Appropriately handle a symbol with a quantity precision:",
		SafeRound[Automatic, 0.1Microliter],
		Automatic
	],

	Test["Round a single value when provided a listed, but single, precision:",
		SafeRound[0.88888, {0.1}],
		0.9
	],

	Test["Nested lists of Quantities and Unitless values Round accordingly:",
		SafeRound[{{55.003` * Microliter, 5}, {55.88 * Microliter, 5.1234567}}, {10^-1 Microliter, 1 / 10}],
		{{55 * Microliter, 5}, {55.9 * Microliter, 5.1}}
	],

	Test["Nested lists of Quantities and Unitless values Round accordingly 2:",
		SafeRound[{{55.003` * Microliter, 5}, {55.88 * Microliter, 5.1234567}, {55.88 * Microliter, 5.1234567}}, {10^-1 Microliter, 1 / 10}],
		{{55 * Microliter, 5}, {55.9 * Microliter, 5.1}, {55.9 * Microliter, 5.1}}
	],

	Test["Round a list of values, each by a single given precision:",
		SafeRound[{10, 0.013005`, 3.8765432}, 0.0001],
		{10, 0.013, 3.8765}
	],

	Test["Round a list of values, each by a different precision:",
		SafeRound[{10, 0.013005`, 3.8765432}, {100, 0.0001, .001}],
		{0, 0.013, 3.877}
	],

	Test["Round a listed list of values:",
		SafeRound[{{10, 0.013005`}, {100, 3.8765432}}, {100, 0.001}],
		{{0, 0.013`}, {100, 3.877`}}
	],

	Test["Round a listed listed list of values:",
		SafeRound[{{{10, 0.013005`}, {100, 3.8765432}}}, {100, 0.001}],
		{{{0, 0.013`}, {100, 3.877`}}}
	],

	Test["Round a Span:",
		ToExpression["SafeRound[Span[100.0010,100.0059],0.001]"],
		Span[100.001, 100.006]
	],

	Test["Round a singleton span wrapped in a list:",
		SafeRound[
			{Quantity[250.1, "Nanometers"];;Quantity[400, "Nanometers"]},
			Quantity[1, "Nanometers"]
		],
		{Quantity[250, "Nanometers"];;Quantity[400, "Nanometers"]}
	],

	Test["Round a that was provided with shorthand notation:",
		SafeRound[100.0010;;100.0059, 0.001],
		Span[100.001, 100.006]
	],

	Test["Round a value shapes by their corresponding precisions:",
		SafeRound[{{{10, 0.013005`}, {100, 3.8765432}}, 551, Span[100.0010, 100.0059], {1.888, 2.888, 3.888}}, {{100, .001}, 50, 0.001, 0.1}],
		{{{0, 0.013`}, {100, 3.877`}}, 550, Span[100.001, 100.006], {1.9, 2.9, 3.9}}
	],

	Test["Round seconds to a minute value:",
		SafeRound[175Second, 1 Minute],
		180 Second
	],

	Test["Round seconds to a specific, unitless precision:",
		SafeRound[175.6854 * Second, 0.01],
		175.69` * Second
	],

	Test["Round a listed quantity to a unitless precision:",
		SafeRound[{175.6854 * Second}, 0.01],
		{175.69` * Second}
	],

	Test["Round a list of quantities to a unitless precision:",
		SafeRound[{175.6854 * Second, 200 * Minute, 17.8889Hour}, 0.01],
		{175.69 * Second, 200 * Minute, 17.89`Hour}
	],

	Test["Round seconds to the nearest increment of equivalent minutes when rounding by something other than 1:",
		SafeRound[175Second, 2 Minute],
		120 * Second
	],

	Test["Round a quantity appropriately and strip off crazy precision:",
		SafeRound[Quantity[0.0002601072001703752`, "Liters"], 10^-1 * Microliter],
		Quantity[0.0002601`, "Liters"]
	],

	Test["Round lists of quantities in a variety of shapes:",
		SafeRound[
			{
				{
					{0Second, 100Celsius, 1Atmosphere},
					{0.1Second, 95.75Celsius, 100 * Millibar}
				},
				{100Hour, 1Hour, .1Hour, 0.01Hour},
				Span[9.777Milligram, 11.687777777Gram],
				72.222 Fahrenheit
			},
			{
				{1Second, 1Celsius, 0.1Millitorr},
				1Hour,
				0.1Milligram,
				1 Celsius
			},
			AvoidZero -> False
		],
		{
			{
				{0Second, 100Celsius, 1 * Atmosphere},
				{0Second, 96Celsius, 100.00004230263157` * Millibar}
			},
			{100Hour, 1Hour, 0Hour, 0Hour},
			Span[9.8Milligram, 11.6878Gram],
			71.6` Fahrenheit
		}
	],

	Test["Round lists of quantities and unitless values in a variety of shapes:",
		SafeRound[
			{
				{
					{0Second, 100Celsius, 1Atmosphere}
				},
				{
					{0, 100, 760000},
					{0.1, 95.75, 75006.2}
				},

				Automatic,
				Automatic,

				{Automatic, 1.1234 * Microliter, 1 * Microliter},

				{100Hour, 1Hour, .1Hour, 0.01Hour},
				{100, 1, .1, 0.01},

				Span[9.777Milligram, 11.687Gram],
				Span[9.777, 11687.`],

				70Fahrenheit,
				70
			},
			{
				{1Second, 1Celsius, 0.1Millitorr},
				{1, 1, 0.1},

				0.1Microliter,
				0.1,

				0.1Microliter,

				1Hour,
				1,
				0.1Milligram,
				0.1,
				0.1Celsius,
				(5 / 9)
			},
			AvoidZero -> False
		],
		{
			{
				{
					Quantity[0, "Seconds"],
					Quantity[100, "DegreesCelsius"],
					Quantity[1, "Atmospheres"]
				}
			},
			{
				{
					0,
					100,
					760000
				},
				{
					0,
					96,
					75006.2
				}
			},
			Automatic,
			Automatic,
			{
				Automatic,
				Quantity[1.1, "Microliters"],
				Quantity[1, "Microliters"]
			},
			{
				Quantity[100, "Hours"],
				Quantity[1, "Hours"],
				Quantity[0, "Hours"],
				Quantity[0, "Hours"]
			},
			{100, 1, 0, 0},
			Quantity[9.8, "Milligrams"] ;; Quantity[11.687, "Grams"],
			9.8 ;; 11687.,
			Quantity[69.98, "DegreesFahrenheit"],
			70
		}
	],

	Test["Works quickly on really large numbers:",
		SafeRound[
			88888888888888888888888888888887777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777 * 10^50,
			333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000.5 * 10^49
		],
		8.888`*^174,
		TimeConstraint -> 0.5
	],

	Test["Precision doesn't choke when given integers of the same magnitude:",
		SafeRound[
			{7, 7},
			{2, 9}
		],
		{8, 9}
	],

	Test["Doesn't choke when given an empty list instead of numbers or symbols:",
		SafeRound[{}, {1Second}, RoundAmbiguous -> Up, Round -> Null, AvoidZero -> True],
		{}
	]
}];
