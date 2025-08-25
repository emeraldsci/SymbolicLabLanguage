(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*Quantity System Compatibility*)


(* ::Subsubsection::Closed:: *)
(*quantitySystemCompatibility*)
Authors[quantitySystemCompatibility]:={"brad"};


DefineTests[quantitySystemCompatibility, {
	Test["Symbols Convert to Quantity",
		Meter,
		Quantity[1, "Meters"]
	],
	Test["Can multiply symbols by numbers",
		2.5 * Meter,
		Quantity[2.5, "Meters"]
	],
	Test["Can combine symbols",
		2.5 * Meter / Second,
		Quantity[2.5, "Meters" / "Seconds"]
	],
	Test["Can use symbols in quantity",
		Quantity[2.5, Meter],
		Quantity[2.5, "Meters"]
	],
	Test["Can use mixed symbols in quantity",
		Quantity[2.5, Meter / Second],
		Quantity[2.5, "Meters" / "Seconds"]
	],
	Test["Metric prefixes preserved",
		2.5 * Kilo * Meter,
		Quantity[2.5, "Kilometers"]
	],
	Test["Metric prefixes allowed in Quantity",
		Quantity[2.5, Kilo * Meter],
		Quantity[2.5, "Kilometers"]
	],
	Test["UnitConvert handles unit symbols",
		UnitConvert[2 * Hour, Minute],
		Quantity[120, "Minutes"]
	],
	Test["UnitConvert handles unit symbols with prefixes",
		UnitConvert[5 Liter, Micro Liter],
		Quantity[5000000, "Microliters"]
	],

	Test["Prefix merging: ",
		Kilo * Meter,
		Quantity[1, "Kilometers"]
	],
	Test["Prefix merging two units: ",
		Kilo * Meter * Gram,
		Quantity[1, "Grams" * "Kilometers"]
	],
	Test["Same dimension conflicting prefixes: ",
		Nanometer * Meter * Gram,
		Quantity[1 / 1000000000, "Grams" * "Meters"^2]
	],
	Test["Prefix merging when prefix already there: ",
		Kilo * Nanometer,
		Quantity[1, "Kilo" * "Nanometers"]
	],
	Test["Prefix merging when prefix already there: ",
		Kilo * Nanometer * Gram,
		Quantity[1, "Kilograms" * "Nanometers"]
	],
	Test["USD not merged:",
		Kilo * USD * Gram,
		Quantity[1, "Kilograms" * "USDollars"]
	],
	Test["USD over something works:",
		Kilo * USD / Gram,
		Quantity[1, "USDollars" / "Milligrams"]
	],
	Test["Comparing compound temperatures with mixed units:",
		{
			Quantity[61, "DegreesCelsius"/"Minutes"]  > Quantity[1, "DegreesCelsius"/"Seconds"],
			Quantity[59, "DegreesCelsius"/"Minutes"]  > Quantity[1, "DegreesCelsius"/"Seconds"],
			Quantity[60, "DegreesCelsius"/"Minutes"]  == Quantity[1, "DegreesCelsius"/"Seconds"]
		},
		{True,False,True }	
	],
	
	Test["Solve with an answer of 0 will return the units:",
		Solve[100 Nanomolar Aliquot == 200 Microliter*0. Nanomolar, Aliquot],
		{{Aliquot -> Quantity[0., ("Meters")^3]}}
	]

}];


(* ::Subsubsection::Closed:: *)
(*temperatureQuantityComparisons*)
Authors[temperatureQuantityComparisons]:={"brad"};

DefineTests[temperatureQuantityComparisons, {

	Test["",
		1Celsius > 5Fahrenheit,
		True
	],
	Test["",
		1Celsius < 5Fahrenheit,
		False
	],
	Test["",
		10 Celsius > 100 * Kelvin,
		True
	],
	Test["",
		MatchQ[33Fahrenheit, RangeP[0Celsius, 2Celsius]],
		True
	],
	Test["Also works for \"Celsius\":",
		Quantity[10, "Celsius"] > 100 * Kelvin,
		True
	],
	Test["These should not be equal:",
		Equal[Quantity[5, "DegreesCelsius"], Quantity[5, "Kelvins"]],
		False
	]

}];


(* ::Subsubsection::Closed:: *)
(*quantityArrayCompatibility*)
Authors[quantityArrayCompatibility]:={"brad"};


DefineTests[quantityArrayCompatibility, {

	Test["",
		SameQ[QuantityArray[{1, 2, 3, 4, 5}, Meter], QuantityArray[{1, 2, 3, 4, 5}, "Meters"]],
		True
	],

	Test["",
		SameQ[QuantityArray[{{1, 1}, {2, 4}, {3, 9}}, {Second, Meter}], QuantityArray[{{1, 1}, {2, 4}, {3, 9}}, {"Seconds", "Meters"}]],
		True
	]

}];


(* ::Subsubsection::Closed:: *)
(*cellUnitCompatibility*)
Authors[cellUnitCompatibility]:={"axu", "dirk.schild"};


DefineTests[cellUnitCompatibility, {
	Test["Can use EmeraldCell to convert to Quantity:",
		EmeraldCell,
		Quantity[1, IndependentUnit["Cells"]]
	],
	Test["Can multiply symbols by numbers:",
		2.5 * Cell,
		Quantity[2.5, IndependentUnit["Cells"]]
	],
	Test["Can combine symbols:",
		2.5 * Second / Cell,
		Quantity[2.5, "Seconds" / IndependentUnit["Cells"]]
	],
	Test["Can use symbols in quantity:",
		Quantity[2.5, EmeraldCell],
		Quantity[2.5, IndependentUnit["Cells"]]
	],
	Test["Can use mixed symbols in quantity:",
		Quantity[2.5, Cell / Second],
		Quantity[2.5, IndependentUnit["Cells"] / "Seconds"]
	],
	Test["Can be displayed as Quantity after stripping with Units:",
		Units[2.5 * Cell],
		Quantity[1, IndependentUnit["Cells"]]
	]
}];


(* ::Subsection::Closed:: *)
(*Unit Manipulation*)


(* ::Subsubsection::Closed:: *)
(*Unitless*)


DefineTests[
	Unitless,
	{
		Example[{Basic, "The function is used to strip Units off of items and return only their numeric values:"},
			Unitless[25 Meter],
			25
		],
		Example[{Basic, "A conversion unit can be provided such that the item si converted before returning a numeric value:"},
			Unitless[2 Minute, Second],
			120
		],
		Example[{Basic, "String units off a QuantityArray:"},
			Unitless[QuantityArray[{{1, 1}, {2, 4}, {3, 9}}, {Second, Meter}]],
			{{1, 1}, {2, 4}, {3, 9}}
		],
		Example[{Additional, "If Unitless is provided with items that are already numeric, they are left untouched:"},
			{Unitless[15], Unitless[0], Unitless[2.314]},
			{15, 0, 2.314}
		],
		Example[{Attributes, Listable, "The function can strip the Units from a list of items as well:"},
			Unitless[{1 Meter, 2 Meter, 3 Meter}],
			{1, 2, 3}
		],
		Example[{Attributes, Listable, "A common conversion unit can be provided to a list of items to make Unitless:"},
			Unitless[{2 Minute, 600 Second, 1 / 2 Hour}, Minute],
			{2, 10, 30}
		],
		Example[{Attributes, Listable, "A paired list of Units can also be converted in this way:"},
			Unitless[{
				{60 Second, 9000 Meter},
				{120 Second, 36000 Meter},
				{180 Second, 810000 Meter},
				{240 Second, 144000 Meter},
				{300 Second, 225000 Meter}
			}, {Minute, Kilo Meter}],
			{{1, 9}, {2, 36}, {3, 810}, {4, 144}, {5, 225}}
		],
		Example[{Issues, "Incompatible", "If the conversion is not recognized as CompatibleUnitQ, then Unitless will throw an error:"},
			Unitless[20Second, Meter],
			$Failed,
			Messages :> Quantity::compat
		],
		Test["Testing numeric representations:",
			Unitless[Sqrt[5] Meter, Meter],
			Sqrt[5]
		],
		Test["Testing fractional numeric representations:",
			Unitless[2 / Second],
			2
		],
		Test["Testing complex numeric representations:",
			Unitless[3Meter^4],
			3
		],
		Test["Testing conversion of 1 unit:",
			Unitless[Meter],
			1
		],
		Example[{Additional, "Remove all Units from expression:"},
			Unitless[{A -> Meter, B -> 3Second, h[72Gigahertz]}],
			{A -> 1, B -> 3, h[72]}
		],
		Test["Remove all Units from expression:",
			Unitless[{A -> Meter, B -> 2Kilometer}, Centimeter],
			{A -> 100, B -> 200000}
		],
		Test["Incompatible untis in expression:",
			Unitless[{A -> Meter, B -> 2Second}, Centimeter],
			{A -> 100, B -> $Failed},
			Messages :> {Quantity::compat}
		],
		Example[{Issues, "Physical Constants", "Physical constants are represented behind the scences as 1*PhysicalConstant, where PhysicalConstant is the unit:"},
			InputForm[Quantity["MolarGasConstant"]],
			InputForm[Quantity[1, "MolarGasConstant"]]
		],
		Example[{Issues, "Physical Constants", "Asking for their numeric value will return 1:"},
			Unitless[Quantity["MolarGasConstant"]],
			1
		],
		Example[{Issues, "Physical Constants", "They can be converted to any compatible unit:"},
			N@Convert[Quantity["MolarGasConstant"], Joule / (Kelvin * Mole)],
			Quantity[8.31446261815324, ("Joules") / ("Kelvins" "Moles")],
			EquivalenceFunction -> RoundMatchQ[6]
		],
		Example[{Issues, "Physical Constants", "To get a physical constant's numeric value in some other unit, you must first convert to the desired units:"},
			N@Unitless[Quantity["MolarGasConstant"], Joule / (Kelvin * Mole)],
			8.31446261815324,
			EquivalenceFunction -> RoundMatchQ[6]
		],


		(* QUANITTY ARRAY TESTS *)
		Test["Strip units from QA:",
			Unitless[QuantityArray[{1, 2, 3, 4, 5}, "Meters"]],
			{1, 2, 3, 4, 5}
		],
		Test["Strip units from QA and convert:",
			Unitless[QuantityArray[{1, 2, 3, 4, 5}, "Meters"], "Centimeters"],
			{100, 200, 300, 400, 500}
		],
		Test["Strip units from QA and convert given symbol unit:",
			Unitless[QuantityArray[{{1, 1}, {2, 4}, {3, 9}}, Meter], Millimeter],
			{{1000, 1000}, {2000, 4000}, {3000, 9000}}
		],
		Test["Strip units from QA and convert for 2D data:",
			Unitless[QuantityArray[{{1, 1}, {2, 4}, {3, 9}}, {Minute, Meter}], {Second, Centimeter}],
			{{60, 100}, {120, 400}, {180, 900}}
		],

		Example[{Additional, "Strip the untis off of a quantity distribution:"},
			Unitless[QuantityDistribution[NormalDistribution[3, 2], "Meters"]],
			NormalDistribution[3, 2]
		],
		Example[{Additional, "Convert and then strip the untis off of a quantity distribution:"},
			Unitless[QuantityDistribution[NormalDistribution[3, 2], "Meters"], Centimeter],
			NormalDistribution[300, 200]
		],
		Example[{Additional, "Strip the units off of a multi-variate quantity distribution:"},
			Unitless[QuantityDistribution[ MultinormalDistribution[{-1, 1}, {{5, 1}, {1, 3}}], {"Grams", "Hours"}]],
			MultinormalDistribution[{-1, 1}, {{5, 1}, {1, 3}}]
		],
		Example[{Additional, "Convert and then strip the units off of a multi-variate quantity distribution:"},
			Unitless[QuantityDistribution[ MultinormalDistribution[{-1, 1}, {{5, 1}, {1, 3}}], {"Grams", "Hours"}], {Milligram, Minute}],
			MultinormalDistribution[{-1000, 60}, {{5000000, 60000}, {60000, 10800}}]
		],
		Example[{Additional, "Strip the units off of a data distribution:"},
			Unitless[EmpiricalDistribution[{1, 2, 3} * Meter]],
			DataDistribution["Empirical", {{1 / 3, 1 / 3, 1 / 3}, {1, 2, 3}, False}, 1, 3]
		],
		Example[{Additional, "Convert and then strip the units off of a data distribution:"},
			Unitless[EmpiricalDistribution[{1, 2, 3} * Meter], Centimeter],
			DataDistribution["Empirical", {{1 / 3, 1 / 3, 1 / 3}, {100, 200, 300}, False}, 1, 3]
		],
		Example[{Additional, "Given QuantityFunction, return its pure function:"},
			Unitless[QuantityFunction[2#1 + 3#2^2&, {Second, Meter}, Gram]],
			2#1 + 3#2^2&
		],
		Example[{Additional, "Given QuantityFunction and conversion:"},
			Unitless[
				QuantityFunction[2#1 + 3#2^2&, {Second, Meter}, Gram],
				{Minute, Millimeter},
				Kilogram
			][x, y],
			(120 * x + (3 * y^2) / 1000000) / 1000
		]

	}
];


(* ::Subsubsection::Closed:: *)
(*Units*)


DefineTests[
	Units,
	{
		Example[{Basic, "Extracts the unit from a value:"},
			Units[2 Second],
			Second
		],
		Example[{Basic, "Works with compound Units:"},
			Units[30 Meter Kilo Gram / Second],
			Meter Kilo Gram / Second
		],
		Example[{Additional, "Numeric values have dimensionless Units:"},
			Units[2.5],
			1
		],
		Example[{Additional, "Works with non-numeric quantities:"},
			Units[Quantity["string", "Meters"]],
			Meter
		],
		Test["Units of a unit is the unit:",
			Units[Second],
			Second
		],
		Example[{Additional, "Maps over list of quantities:"},
			Units[{2 Second, 3 (Kilo Meter) / Hour, 5 Lumen / Meter}],
			{Second, (Kilo Meter) / Hour, Lumen / Meter}
		],
		Example[{Issues, "Physical Constants", "Physical constants are represented behind the scences as 1*PhysicalConstant, where PhysicalConstant is the unit:"},
			InputForm[Quantity["MolarGasConstant"]],
			InputForm[Quantity[1, "MolarGasConstant"]]
		],
		Example[{Issues, "Physical Constants", "Asking for their units will return the constant itself, as that is the unit:"},
			Units[Quantity["MolarGasConstant"]],
			Quantity[1, "MolarGasConstant"]
		],
		Example[{Issues, "Physical Constants", "They can be converted to any compatible unit:"},
			N@Convert[Quantity["MolarGasConstant"], Joule / (Kelvin * Mole)],
			Quantity[8.31446261815324, ("Joules") / ("Kelvins" "Moles")],
			EquivalenceFunction -> RoundMatchQ[6]
		],
		Example[{Issues, "Physical Constants", "To get a physical constant's units in some other unit (such as base SI units), you must first convert to the desired units:"},
			Units[Convert[Quantity["MolarGasConstant"], Joule / (Kelvin * Mole)]],
			Joule / (Kelvin * Mole)
		],


		(* QA tests *)
		Example[{Basic, "Find units of a QuantityArray:"},
			Units[QuantityArray[{1, 2, 3}, "Meters"]],
			{Meter, Meter, Meter}
		],
		Test["Units from Nx2 array:",
			Units[QuantityArray[{{1, 1}, {2, 4}, {3, 9}}, {"Minutes", "Meters"}]],
			{{Minute, Meter}, {Minute, Meter}, {Minute, Meter}}
		],
		Test["Units from Nx3 array:",
			Units[QuantityArray[{{1, 1, 1}, {2, 4, 5}, {3, 9, 12}}, {"Minutes", "Meters", "Grams"}]],
			{{Minute, Meter, Gram}, {Minute, Meter, Gram}, {Minute, Meter, Gram}}
		],
		Test["Units from NxMx2 array:",
			Units[QuantityArray[{{{1, 1}, {2, 4}, {3, 9}}, {{1, 1}, {2, 4}, {3, 9}}}, {"Minutes", "Meters"}]],
			{{{Minute, Meter}, {Minute, Meter}, {Minute, Meter}}, {{Minute, Meter}, {Minute, Meter}, {Minute, Meter}}}
		],


		(*
		QA w/ level spec
	*)

		Test["Test 1:",
			Units[QuantityArray[{{{1, 2}, {2, 3}}, {{1, 2}, {2, 3}}}, Meter], {3}],
			Meter
		],
		Test["Test 2:",
			Units[QuantityArray[{{{1, 2}, {2, 3}}, {{1, 2}, {2, 3}}}, Meter], {2}],
			{Meter, Meter}
		],
		Test["Test 3:",
			Units[QuantityArray[{{{1, 2}, {2, 3}}, {{1, 2}, {2, 3}}}, Meter], {1}],
			{{Meter, Meter}, {Meter, Meter}}
		],
		Example[{Additional, "Level zero returns unit array whose size matches the data array:"},
			Units[QuantityArray[{{{1, 2}, {2, 3}}, {{1, 2}, {2, 3}}}, Meter], {0}],
			{{{Meter, Meter}, {Meter, Meter}}, {{Meter, Meter}, {Meter, Meter}}}
		],
		Example[{Messages, "InvalidLevel", "Cannot specify a level that is deeper than the dimensions of the array:"},
			Units[QuantityArray[{{{1, 2}, {2, 3}}, {{1, 2}, {2, 3}}}, Meter], {4}],
			$Failed,
			Messages :> {Units::InvalidLevel}
		],
		Example[{Messages, "InconsistentUnits", "Cannot return units at level 2 because units at level 1 are not all the same:"},
			Units[QuantityArray[{{1, 2}, {2, 3}}, {Second, Meter}], {2}],
			$Failed,
			Messages :> {Units::InconsistentUnits}
		],


		Example[{Additional, "Automatic level resolution will increase the level if units are not consistent at usual default value:"},
			Units[QuantityArray[{{1, 2, 3}, {4, 5, 6}}, {{Meter, Second, Gram}, {Mole, Meter / Second, Year}}], Automatic],
			{{Meter, Second, Gram}, {Mole, Meter / Second, Year}}
		],
		Test["Automatic resolution goes up one level from usual default:",
			Units[QuantityArray[{{{1, 2, 3}, {4, 5, 6}}, {{1, 2, 3}, {4, 5, 6}}}, {{Meter, Second, Gram}, {Mole, Meter / Second, Year}}], Automatic],
			{{Meter, Second, Gram}, {Mole, Meter / Second, Year}}
		],
		Test["Automatic resolution kicks up a level when units are not identical at default level, even if they are compatible:",
			Units[QuantityArray[{{1, 2, 3}, {4, 5, 6}}, {{Meter, Second, Gram}, {Kilometer, Minute, Kilogram}}], Automatic],
			{{Meter, Second, Gram}, {Kilometer, Minute, Kilogram}}
		],

		Example[{Additional, "Extract the untis from a quantity distribution:"},
			Units[QuantityDistribution[NormalDistribution[3, 2], "Meters"]],
			Meter
		],
		Example[{Additional, "Extract the units from a multi-variate quantity distribution:"},
			Units[QuantityDistribution[ MultinormalDistribution[{-1, 1}, {{5, 1}, {1, 3}}], {"Grams", "Hours"}]],
			{Gram, Hour}
		]



	}
];


(* ::Subsubsection::Closed:: *)
(*UnitBase*)


DefineTests[
	UnitBase,
	{
		Example[{Basic, "Returns the base unit of any item:"},
			UnitBase[4 Liter],
			Liter
		],
		Example[{Basic, "Handles metric prefixes:"},
			UnitBase[7 Milli Meter],
			Meter
		],
		Example[{Basic, "Convert dimension to base unit:"},
			UnitBase["Distance"],
			Meter
		],
		Example[{Basic, "Convert dimension to all possible Units:"},
			UnitBase["Distance", All],
			{_Quantity, __Quantity}
		],
		Example[{Additional, "Numeric values return 1:"},
			UnitBase[3.5],
			1
		],
		Example[{Attributes, Listable, "The function is listable:"},
			UnitBase[{4 Mega Watt, 50 Giga Ampere, 12 Milli Molar}],
			{Watt, Ampere, Molar}
		],
		Test["Handles microns:",
			UnitBase[Micron],
			Quantity[1, "Meters"]
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*UnitFlatten*)


DefineTests[
	UnitFlatten,
	{
		Example[{Basic, "Turns a unit expression with metric prefix into its base form:"},
			UnitFlatten[8 Kilo Meter],
			8000 * Meter
		],
		Example[{Basic, "Handles compound Units:"},
			UnitFlatten[2.5 * (Kilo * Meter) / (Milli * Second)],
			2.5`*^6 Meter / Second
		],
		Test["Time does not always convert to Second:",
			UnitFlatten[2.5 * Hour],
			2.5 * Hour
		],
		Example[{Additional, "Numeric values return 1:"},
			UnitFlatten[3.5],
			3.5
		],
		Example[{Attributes, Listable, "The function is listable:"},
			UnitFlatten[{12. Micro Gram, 15. Nano Meter, 24. Kilo Watt}],
			{(0.000012` Gram), 1.5`*^-8 Meter, 2.4`*^4 Watt}
		],
		Test["Does not expand Molar into Moles/Meter^3:",
			UnitFlatten[Quantity[2.5, "Molar"]],
			Quantity[2.5, "Molar"]
		],
		Test["Does not convert PSI to Pascals:",
			UnitFlatten[Quantity[1000, "PoundsForce"/"Inches"^2]],
			Quantity[1000, ("PoundsForce") / ("Inches")^2]
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*UnitDimension*)


DefineTests[
	UnitDimension,
	{
		Example[{Basic, "Given a unit, will return a string describing what that unit measures:"},
			UnitDimension[Meter],
			"Distance"
		],
		Example[{Basic, "Works on quantitites with Units as well:"},
			UnitDimension[6.3 Nano Meter],
			"Distance"
		],
		Example[{Basic, "Works with any explictly listed Units in UnitDimension's source code:"},
			UnitDimension[23 Nucleotide],
			"Strand Length"
		],
		Example[{Issues, "Demensions are hard coded into the function, so not all known Units have a provided description and must be added:"},
			UnitDimension[3.5 Kelvin / Hour],
			"Unknown quantity"
		],
		Example[{Attributes, Listable, "The function is listable across many quantities or Units:"},
			UnitDimension[{1.2 Meter, 24 Celsius, 42Hour}],
			{"Distance", "Temperature", "Time"}
		],
		Test["Function remains unevaluated for symbolic input:",
			UnitDimension[Taco],
			_UnitDimension
		],
		Example[{Basic, "String unit input:"},
			UnitDimension["Meters" / "Seconds"],
			"Velocity"
		],
		Test["Percent is Percent:",
			UnitDimension[5 * Percent],
			"Percent"
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*CanonicalUnit*)


DefineTests[CanonicalUnit, {

	Example[{Basic, "Canonical unit of distance is meters:"},
		CanonicalUnit[3.5Nanometer],
		Meter
	],
	Example[{Basic, "Meters is returned for any distance quantity:"},
		CanonicalUnit[7.2 * Mile],
		Meter
	],
	Example[{Basic, "Given Distance as dimension, the canonical unit is also meters:"},
		CanonicalUnit["Distance"],
		Meter
	],

	Example[{Additional, "Compound units get broken down into their canonical pieces for each dimension:"},
		CanonicalUnit[Millimolar / Hour],
		Mole / (Meter^3 * Second)
	],

	Example[{Additional, "Some canonical units have prefixes:"},
		CanonicalUnit[Gram],
		Kilogram
	],

	Example[{Additional, "Unknown dimensions return $Failed:"},
		CanonicalUnit["Silliness:"],
		$Failed
	],

	Example[{Attributes, Listable, "Given mixed list of values:"},
		CanonicalUnit[{Year, Nanoampere, "Area", 2.5}],
		{Second, Ampere, Meter^2, 1}
	]

}];



(* ::Subsection::Closed:: *)
(*General Unit Patterns*)


(* ::Subsubsection::Closed:: *)
(*stringUnitP*)


DefineTests["stringUnitP", {
	Test["Matches string:",
		MatchQ["Meters", stringUnitP],
		True
	],
	Test["Matches products of strings:",
		MatchQ["Meters" * "Seconds", stringUnitP],
		True
	],
	Test["Matches strings with exponents:",
		MatchQ["Meters"^2, stringUnitP],
		True
	],
	Test["Matches strings with negative exponents:",
		MatchQ[1 / "Meters", stringUnitP],
		True
	],
	Test["Matches products of strings with and without exponents:",
		MatchQ["Meters" * "Seconds"^2 / "Liters" / "Moles"^3, stringUnitP],
		True
	],
	Test["Does not check if strings are actual Units:",
		MatchQ["SomethingThatIsNotAUnit", stringUnitP],
		True
	]

}];


(* ::Subsubsection::Closed:: *)
(*UnitsP*)


DefineTests[UnitsP, {
	Example[{Basic, "Pattern that matches and quantity with Units or numeric value:"},
		UnitsP[],
		_
	],
	Test["Pattern that matches any quantity or numeric:",
		MatchQ[#, UnitsP[]]& /@ {3, 3.5, 3Percent, 3Kilo * Meter},
		{True, True, True, True}
	],
	Example[{Basic, "Pattern that matches anything whose unit dimensions match the dimensions of the given value:"},
		MatchQ[3.5 * Mile, UnitsP[Meter]],
		True
	],
	Example[{Basic, "Pattern that matches anything whose unit dimensions match the dimensions of the given unit:"},
		MatchQ[3.5 * Mile, UnitsP["Meters"]],
		True
	],
	Example[{Basic, "Pattern that matches any quantity with specified dimensions:"},
		MatchQ[3.5 * Mile, UnitsP["Distance"]],
		True
	],
	Example[{Additional, "String unit input:"},
		MatchQ[3.5 * Mile / Hour, UnitsP["Meters" / "Seconds"]],
		True
	]
}];


(* ::Subsubsection::Closed:: *)
(*UnitsQ*)


DefineTests[
	UnitsQ,
	{
		Example[{Basic, "Returns true if the given item has Units known to the EmeraldUnits.m pacakge:"},
			UnitsQ[12 Gram / Liter],
			True
		],
		Example[{Basic, "Metric prefixes work:"},
			UnitsQ[67 Milli Liter],
			True
		],
		Example[{Attributes, Listable, "The function is listable:"},
			UnitsQ[{12 Milli Meter, 45 Kilo Second, 17.4 Molar}],
			{True, True, True}
		],
		Example[{Overloads, "Can also test if the item's UnitBase matches a given base unit:"},
			UnitsQ[Meter, 39 Kilo Meter],
			True
		],
		Test["Does not accept gibberish:",
			UnitsQ["taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*QuantityArrayP*)


DefineTests[QuantityArrayP, {

	Example[{Basic, "Matches any QuantityArray:"},
		MatchQ[QuantityArray[{1, 2, 3}, "Meters"], QuantityArrayP[]],
		True
	],
	Example[{Basic, "Matches QuantityArray whose units are compatible with Inch:"},
		MatchQ[QuantityArray[{1, 2, 3}, "Meters"], QuantityArrayP[{Inch..}]],
		True
	],
	Example[{Basic, "Pattern argument can be _Quantity or String:"},
		MatchQ[QuantityArray[{1, 2, 3}, "Meters"], QuantityArrayP[{"Inches"..}]],
		True
	],
	Example[{Basic, "Does not match because units are incompatible:"},
		MatchQ[QuantityArray[{1, 2, 3}, "Meters"], QuantityArrayP[{Second..}]],
		False
	],
	Example[{Additional, "Matches 2D QuantityArray:"},
		MatchQ[QuantityArray[{{1, 1}, {2, 4}, {3, 9}}, {"Seconds", "Meters"}], QuantityArrayP[]],
		True
	],
	Example[{Additional, "Pattern for 2D QuantityArray of {Time,Distance}:"},
		MatchQ[QuantityArray[{{1, 1}, {2, 4}, {3, 9}}, {"Seconds", "Meters"}], QuantityArrayP[{{Hour, Mile}..}]],
		True
	],
	Example[{Additional, "Does not match because units are incompatible 2D array:"},
		MatchQ[QuantityArray[{{1, 1}, {2, 4}, {3, 9}}, {"Seconds", "Meters"}], QuantityArrayP[{{Gram, Mile}..}]],
		False
	],

	Test["Flat list of magnitudes:",
		With[{qa=QuantityArray[{1, 2, 3}, "Meters"]},
			{
				MatchQ[qa, QuantityArrayP[]],
				MatchQ[qa, QuantityArrayP[{"Meters"..}]],
				MatchQ[qa, QuantityArrayP[{Meter..}]],
				MatchQ[qa, QuantityArrayP[{{"Meters"}..}]],
				MatchQ[qa, QuantityArrayP[{{Meter}..}]]
			}],
		{True, True, True, False, False}
	],
	Test["Nx1 array of magnitudes:",
		With[{qa=QuantityArray[{{1}, {2}, {3}}, {"Meters"}]},
			{
				MatchQ[qa, QuantityArrayP[]],
				MatchQ[qa, QuantityArrayP[{{"Meters"}..}]],
				MatchQ[qa, QuantityArrayP[{{Meter}..}]],
				MatchQ[qa, QuantityArrayP[{"Meters"..}]],
				MatchQ[qa, QuantityArrayP[{Meter..}]]
			}],
		{True, True, True, False, False}
	],
	Test["Nx2 array of magnitudes:",
		With[{qa=QuantityArray[{{1, 1}, {2, 4}, {3, 9}}, {"Seconds", "Meters"}]},
			{
				MatchQ[qa, QuantityArrayP[]],
				MatchQ[qa, QuantityArrayP[{{"Seconds", "Meters"}..}]],
				MatchQ[qa, QuantityArrayP[{{Second, Meter}..}]],
				MatchQ[qa, QuantityArrayP[{{"Seconds", Meter}..}]],
				MatchQ[qa, QuantityArrayP[{{Second, "Meters"}..}]],
				MatchQ[qa, QuantityArrayP[{"Meters"..}]],
				MatchQ[qa, QuantityArrayP[{{"Meters"}..}]],
				MatchQ[qa, QuantityArrayP[{{"Meters", "Meters"}..}]]
			}],
		{True, True, True, True, True, False, False, False}
	],
	Test["Nx2 array of magnitudes with single unit:",
		With[{qa=QuantityArray[{{1, 1}, {2, 4}, {3, 9}}, "Meters"]},
			{
				MatchQ[qa, QuantityArrayP[]],
				MatchQ[qa, QuantityArrayP[{{"Meters", "Meters"}..}]],
				MatchQ[qa, QuantityArrayP[{{Meter, Meter}..}]],
				MatchQ[qa, QuantityArrayP[{{"Meters", Meter}..}]],
				MatchQ[qa, QuantityArrayP[{{Meter, "Meters"}..}]],
				MatchQ[qa, QuantityArrayP[{"Meters"..}]],
				MatchQ[qa, QuantityArrayP[{{"Meters"}..}]]
			}],
		{True, True, True, True, True, False, False}
	]

}];


(* ::Subsubsection::Closed:: *)
(*QuantityArrayQ*)


DefineTests[QuantityArrayQ, {

	Example[{Basic, "Match single unit in list:"},
		QuantityArrayQ[QuantityArray[Range[5], Meter], {Meter..}],
		True
	],
	Example[{Additional, "Match single unit in list with different unit:"},
		QuantityArrayQ[QuantityArray[Range[5], Inch], {Meter..}],
		True
	],
	Example[{Additional, "Match Nx1 array:"},
		QuantityArrayQ[QuantityArray[RandomReal[1, {10, 1}], {Meter}], {{Meter}..}],
		True
	],
	Example[{Basic, "Match Nx2 array:"},
		QuantityArrayQ[QuantityArray[RandomReal[1, {10, 2}], {Second, Meter}], {{Second, Meter}..}],
		True
	],
	Example[{Additional, "Match Nx3 array:"},
		QuantityArrayQ[
			QuantityArray[RandomReal[1, {10, 3}], {Second, Meter, Gram}],
			{{Second, Meter, Gram}..}
		],
		True
	],
	Example[{Basic, "Match Nx3 array with different units:"},
		QuantityArrayQ[
			QuantityArray[RandomReal[1, {10, 3}], {Second, Meter, Gram}],
			{{Minute, Inch, Kilogram}..}
		],
		True
	],
	Example[{Additional, "Match NxMx3 array:"},
		QuantityArrayQ[
			QuantityArray[RandomReal[1, {10, 5, 3}], {Second, Meter, Gram}],
			{{{Minute, Inch, Kilogram}..}..}
		],
		True
	],


	Example[{Basic, "Does not match single unit without list:"},
		QuantityArrayQ[QuantityArray[Range[5], Meter], Meter],
		False
	],
	Example[{Additional, "Invalid unit pattern:"},
		QuantityArrayQ[QuantityArray[Range[5], Meter], Null],
		False
	],
	Example[{Additional, "Pattern dimensions don't match innermost size:"},
		QuantityArrayQ[
			QuantityArray[RandomReal[1, {10, 2}], {Second, Meter}],
			{{Second, Meter, Gram}..}
		],
		False
	],
	Example[{Additional, "Pattern dimensions don't match outer size:"},
		QuantityArrayQ[
			QuantityArray[RandomReal[1, {10, 2}], {Second, Meter}],
			{{{Second, Meter}..}..}
		],
		False
	],

	Example[{Additional, "Use QuantityArray as unit spec.  Dimensions must match, and units must be compatible:"},
		QuantityArrayQ[
			QuantityArray[RandomReal[1, {10, 2}], {Second, Meter}],
			QuantityArray[RandomReal[1, {10, 2}], {Hour, Mile}]
		],
		True
	],
	Example[{Additional, "None is allowed as dimensionless unit:"},
		QuantityArrayQ[QuantityArray[{{1., 1.}, {2., 3.}, {3., 6.}, {4., 10.}}, {"Seconds", "DimensionlessUnit"}], {{Second, None}..}],
		True
	],
	Test["Case where UnitBlock collapses:",
		QuantityArrayQ[QuantityArray[{{1., 1., 1.}, {2., 3., 4.}, {3., 6., 9.}, {4., 10., 16}}, {Second, Second, Second}], {{"Seconds", "Seconds", "Seconds"}..}],
		True
	],
	Test["Deep array with non-uniform units:",
		QuantityArrayQ[
			QuantityArray[{{{{Second, Meter}, {Second, Inch}, {Second, Meter}}, {{Second, Meter}, {Second, Meter}, {Second, Meter}}, {{Second, Meter}, {Second, Meter}, {Second, Meter}}}, {{{Second, Meter}, {Second, Inch}, {Second, Meter}}, {{Second, Meter}, {Second, Meter}, {Second, Meter}}, {{Second, Meter}, {Second, Meter}, {Second, Meter}}}, {{{Second, Meter}, {Second, Inch}, {Second, Meter}}, {{Second, Meter}, {Second, Meter}, {Second, Meter}}, {{Second, Meter}, {Second, Meter}, {Second, Meter}}}, {{{Second, Meter}, {Second, Inch}, {Second, Meter}}, {{Second, Meter}, {Second, Meter}, {Second, Meter}}, {{Second, Meter}, {Second, Meter}, {Minute, Meter}}}}],
			{{{{Second, Meter}..}..}..}
		],
		True
	]


}];


(* ::Subsubsection::Closed:: *)
(*QuantityVectorQ*)


DefineTests[QuantityVectorQ, {

	Example[{Basic, "A quantity vector with any units:"},
		QuantityVectorQ[QuantityArray[{1, 2, 3, 4}, Meter]],
		True
	],
	Example[{Basic, "Specify the units:"},
		QuantityVectorQ[QuantityArray[{1, 2, 3, 4}, Meter], Kilometer],
		True
	],
	Example[{Basic, "Returns False if units are not compatible:"},
		QuantityVectorQ[QuantityArray[{1, 2, 3, 4}, Meter], Second],
		False
	],
	Example[{Basic, "Returns False for higher-dimensional QAs:"},
		QuantityVectorQ[QuantityArray[{{1., 1.}, {2., 3.}, {3., 6.}, {4., 10.}}, {Second, Meter}]],
		False
	],
	Example[{Additional, "Returns False for non-QA inputs:"},
		QuantityVectorQ[{1, 2, 3}],
		False
	],
	Example[{Additional, "Remains unevaluated if second argument is not a valid unit specification:"},
		QuantityVectorQ[QuantityArray[{1, 2, 3, 4}, Meter], Horse],
		_QuantityVectorQ
	]

}];


(* ::Subsubsection::Closed:: *)
(*QuantityMatrixQ*)


DefineTests[QuantityMatrixQ, {

	Example[{Basic, "A quantity matrix with any units:"},
		QuantityMatrixQ[QuantityArray[{{1., 1., 1.}, {2., 3., 4.}, {3., 6., 9.}, {4., 10., 16}}, {Second, Meter, Gram}]],
		True
	],
	Example[{Basic, "Specify the units:"},
		QuantityMatrixQ[QuantityArray[{{1., 1.}, {2., 3.}, {3., 6.}, {4., 10.}}, {Second, Meter}], {Hour, Kilometer}],
		True
	],
	Example[{Basic, "Returns False if units are not compatible:"},
		QuantityMatrixQ[QuantityArray[{{1., 1.}, {2., 3.}, {3., 6.}, {4., 10.}}, {Second, Meter}], {Gram, Liter}],
		False
	],
	Example[{Basic, "Returns False for other-dimensional QAs:"},
		QuantityMatrixQ[QuantityArray[{1, 2, 3, 4}, Meter]],
		False
	],
	Example[{Additional, "Returns False for non-QA inputs:"},
		QuantityMatrixQ[{1, 2, 3}],
		False
	],
	Example[{Additional, "Remains unevaluated if second argument is not a valid unit specification:"},
		QuantityMatrixQ[QuantityArray[{{1., 1., 1.}, {2., 3., 4.}, {3., 6., 9.}, {4., 10., 16}}, {Second, Meter, Gram}], Horse],
		_QuantityMatrixQ
	],
	Example[{Additional, "Unit specification can contain unit strings:"},
		QuantityMatrixQ[QuantityArray[{{1., 1., 1.}, {2., 3., 4.}, {3., 6., 9.}, {4., 10., 16}}, {Second, Meter, Gram}], {"Seconds", "Meters", "Grams"}],
		True
	],
	Test["Case where UnitBlock collapses:",
		QuantityMatrixQ[QuantityArray[{{1., 1., 1.}, {2., 3., 4.}, {3., 6., 9.}, {4., 10., 16}}, {Second, Second, Second}], {"Seconds", "Seconds", "Seconds"}],
		True
	],

	Test["Singleton, singleton, true:", QuantityMatrixQ[QuantityArray[{{Second, Second}, {Second, Second}}], Second], True],
	Test["Singleton, singleton, false:", QuantityMatrixQ[QuantityArray[{{Second, Second}, {Second, Second}}], Meter], False],
	Test["Singleton, vector, true:", QuantityMatrixQ[QuantityArray[{{Second, Minute}, {Second, Minute}}], Second], True],
	Test["Singleton, vector, false:", QuantityMatrixQ[QuantityArray[{{Second, Minute}, {Second, Minute}}], Meter], False],
	Test["Singleton, matrix, true:", QuantityMatrixQ[QuantityArray[{{Second, Minute}, {Hour, Year}}], Second], True],
	Test["Singleton, matrix, false:", QuantityMatrixQ[QuantityArray[{{Second, Minute}, {Hour, Year}}], Meter], False],

	Test["Vector, singleton, true:", QuantityMatrixQ[QuantityArray[{{Second, Second}, {Second, Second}}], {Second, Minute}], True],
	Test["Vector, singleton, false:", QuantityMatrixQ[QuantityArray[{{Second, Second}, {Second, Second}}], {Meter, Minute}], False],
	Test["Vector, vector, true:", QuantityMatrixQ[QuantityArray[{{Second, Minute}, {Second, Minute}}], {Hour, Year}], True],
	Test["Vector, vector, false:", QuantityMatrixQ[QuantityArray[{{Second, Minute}, {Second, Minute}}], {Meter, Year}], False],
	Test["Vector, matrix, true:", QuantityMatrixQ[QuantityArray[{{Second, Minute}, {Hour, Year}}], {Day, Year}], True],
	Test["Vector, matrix, false:", QuantityMatrixQ[QuantityArray[{{Second, Minute}, {Hour, Year}}], {Meter, Year}], False]

}];


(* ::Subsubsection::Closed:: *)
(*QuantityMatrixP*)


DefineTests[QuantityMatrixP, {

	Example[{Basic, "A quantity matrix with any units:"},
		MatchQ[QuantityArray[{{1., 1., 1.}, {2., 3., 4.}, {3., 6., 9.}, {4., 10., 16}}, {Second, Meter, Gram}], QuantityMatrixP[]],
		True
	],
	Example[{Basic, "Specify the units:"},
		MatchQ[QuantityArray[{{1., 1.}, {2., 3.}, {3., 6.}, {4., 10.}}, {Second, Meter}], QuantityMatrixP[{Hour, Kilometer}]],
		True
	],
	Example[{Basic, "Returns False if units are not compatible:"},
		MatchQ[QuantityArray[{{1., 1.}, {2., 3.}, {3., 6.}, {4., 10.}}, {Second, Meter}], QuantityMatrixP[{Gram, Liter}]],
		False
	],
	Example[{Basic, "Returns False for other-dimensional QAs:"},
		MatchQ[QuantityArray[{1, 2, 3, 4}, Meter], QuantityMatrixP[]],
		False
	],
	Example[{Additional, "Returns False for non-QA inputs:"},
		MatchQ[{1, 2, 3}, QuantityMatrixP[]],
		False
	],
	Example[{Additional, "Remains unevaluated if second argument is not a valid unit specification:"},
		QuantityMatrixP[QuantityArray[{{1., 1., 1.}, {2., 3., 4.}, {3., 6., 9.}, {4., 10., 16}}, {Second, Meter, Gram}], Horse],
		_QuantityMatrixP
	],
	Example[{Additional, "Unit specification can contain unit strings:"},
		MatchQ[QuantityArray[{{1., 1., 1.}, {2., 3., 4.}, {3., 6., 9.}, {4., 10., 16}}, {Second, Meter, Gram}], QuantityMatrixP[{"Seconds", "Meters", "Grams"}]],
		True
	],
	Test["Case where UnitBlock collapses:",
		MatchQ[QuantityArray[{{1., 1., 1.}, {2., 3., 4.}, {3., 6., 9.}, {4., 10., 16}}, {Second, Second, Second}], QuantityMatrixP[{"Seconds", "Seconds", "Seconds"}]],
		True
	]


}];


(* ::Subsubsection::Closed:: *)
(*QuantityCoordinatesQ*)


DefineTests[QuantityCoordinatesQ, {

	Example[{Basic, "Quantity coordinates may be a raw List of coordinates with homgenous units:"},
		QuantityCoordinatesQ[{{1 Second, 1 Meter}, {2 Second, 2 Meter}, {3 Second, 1 Meter}}],
		True
	],

	Test["Quantity coordinates cannot be inhomogenous in units:",
		QuantityCoordinatesQ[{{1 Second, 1 Meter}, {2 Second, 2 Coulomb}, {3 Second, 1 Meter}}],
		False
	],

	Example[{Basic, "A quantity matrix with any units:"},
		QuantityCoordinatesQ[QuantityArray[{{1., 1.}, {2., 3.}, {3., 6.}, {4., 10.}}, {Second, Meter}]],
		True
	],
	Example[{Basic, "Specify the units:"},
		QuantityCoordinatesQ[QuantityArray[{{1., 1.}, {2., 3.}, {3., 6.}, {4., 10.}}, {Second, Meter}], {Hour, Kilometer}],
		True
	],
	Example[{Basic, "Returns False if units are not compatible:"},
		QuantityCoordinatesQ[QuantityArray[{{1., 1.}, {2., 3.}, {3., 6.}, {4., 10.}}, {Second, Meter}], {Gram, Liter}],
		False
	],
	Example[{Basic, "Returns False if dimensions are not Nx2:"},
		QuantityCoordinatesQ[QuantityArray[{{1., 1., 1.}, {2., 3., 4.}, {3., 6., 9.}, {4., 10., 16}}, {Second, Meter, Gram}]],
		False
	],
	Example[{Additional, "Returns False for non-QA inputs:"},
		QuantityCoordinatesQ[{1, 2, 3}],
		False
	],
	Example[{Additional, "Remains unevaluated if second argument is not a valid unit specification:"},
		QuantityCoordinatesQ[QuantityArray[{{1., 1.}, {2., 3.}, {3., 6.}, {4., 10.}}, {Second, Meter}], Horse],
		_QuantityCoordinatesQ
	],
	Example[{Basic, "None is allowed as dimensionless unit:"},
		QuantityCoordinatesQ[QuantityArray[{{1., 1.}, {2., 3.}, {3., 6.}, {4., 10.}}, {"Seconds", "DimensionlessUnit"}], {Second, None}],
		True
	],
	Example[{Additional, "Unit specification can contain unit strings:"},
		QuantityCoordinatesQ[QuantityArray[{{1., 1.}, {2., 3.}, {3., 6.}, {4., 10.}}, {Second, Meter}], {"Seconds", "Meters"}],
		True
	]


}];



(* ::Subsubsection::Closed:: *)
(*QuantityCoordinatesP*)


DefineTests[QuantityCoordinatesP, {

	Example[{Basic, "A quantity matrix with any units:"},
		MatchQ[QuantityArray[{{1., 1.}, {2., 3.}, {3., 6.}, {4., 10.}}, {Second, Meter}], QuantityCoordinatesP[]],
		True
	],
	Example[{Basic, "Specify the units:"},
		MatchQ[QuantityArray[{{1., 1.}, {2., 3.}, {3., 6.}, {4., 10.}}, {Second, Meter}], QuantityCoordinatesP[{Hour, Kilometer}]],
		True
	],
	Example[{Basic, "Returns False if units are not compatible:"},
		MatchQ[QuantityArray[{{1., 1.}, {2., 3.}, {3., 6.}, {4., 10.}}, {Second, Meter}], QuantityCoordinatesP[{Gram, Liter}]],
		False
	],
	Example[{Basic, "Returns False if dimensions are not Nx2:"},
		MatchQ[QuantityArray[{{1., 1., 1.}, {2., 3., 4.}, {3., 6., 9.}, {4., 10., 16}}, {Second, Meter, Gram}], QuantityCoordinatesP[]],
		False
	],
	Example[{Additional, "Returns False for non-QA inputs:"},
		MatchQ[{1, 2, 3}, QuantityCoordinatesP[]],
		False
	],
	Example[{Basic, "Unit specification can contain unit strings:"},
		MatchQ[QuantityArray[{{1., 1.}, {2., 3.}, {3., 6.}, {4., 10.}}, {Second, Meter}], QuantityCoordinatesP[{"Seconds", "Meters"}]],
		True
	]


}];



(* ::Subsubsection::Closed:: *)
(*compatibleQuantityArrayQ*)


DefineTests[compatibleQuantityArrayQ, {

	Example[{Additional, "Matches QuantityArray whose units are compatible with Inch:"},
		compatibleQuantityArrayQ[QuantityArray[{1, 2, 3}, "Meters"], Inch],
		True
	],
	Example[{Additional, "Pattern argument can be _Quantity or String:"},
		compatibleQuantityArrayQ[QuantityArray[{1, 2, 3}, "Meters"], "Inches"],
		True
	],
	Example[{Additional, "Does not match because units are incompatible:"},
		compatibleQuantityArrayQ[QuantityArray[{1, 2, 3}, "Meters"], Second],
		False
	],
	Example[{Additional, "Pattern for 2D QuantityArray of {Time,Distance}:"},
		compatibleQuantityArrayQ[
			QuantityArray[{{1, 1}, {2, 4}, {3, 9}}, {"Seconds", "Meters"}],
			{Hour, Mile}
		],
		True
	],
	Example[{Additional, "Does not match because units are incompatible 2D array:"},
		compatibleQuantityArrayQ[
			QuantityArray[{{1, 1}, {2, 4}, {3, 9}}, {"Seconds", "Meters"}],
			{Gram, Mile}
		],
		False
	],

	Test["Flat list of magnitudes:",
		With[{qa=QuantityArray[{1, 2, 3}, "Meters"]},
			{
				compatibleQuantityArrayQ[qa, "Meters"],
				compatibleQuantityArrayQ[qa, Meter],
				compatibleQuantityArrayQ[qa, {"Meters"}],
				compatibleQuantityArrayQ[qa, {Meter}]
			}],
		{True, True, False, False}
	],
	Test["Nx1 array of magnitudes:",
		With[{qa=QuantityArray[{{1}, {2}, {3}}, {"Meters"}]},
			{
				compatibleQuantityArrayQ[qa, {"Meters"}],
				compatibleQuantityArrayQ[qa, {Meter}],
				compatibleQuantityArrayQ[qa, "Meters"],
				compatibleQuantityArrayQ[qa, Meter]
			}],
		{True, True, True, True}
	],
	Test["Nx2 array of magnitudes:",
		With[{qa=QuantityArray[{{1, 1}, {2, 4}, {3, 9}}, {"Seconds", "Meters"}]},
			{
				compatibleQuantityArrayQ[qa, {"Seconds", "Meters"}],
				compatibleQuantityArrayQ[qa, {Second, Meter}],
				compatibleQuantityArrayQ[qa, {"Seconds", Meter}],
				compatibleQuantityArrayQ[qa, {Second, "Meters"}],
				compatibleQuantityArrayQ[qa, "Meters"],
				compatibleQuantityArrayQ[qa, {"Meters"}],
				compatibleQuantityArrayQ[qa, {"Meters", "Meters"}]
			}],
		{True, True, True, True, False, False, False}
	],
	Test["Nx2 array of magnitudes with single unit:",
		With[{qa=QuantityArray[{{1, 1}, {2, 4}, {3, 9}}, "Meters"]},
			{
				compatibleQuantityArrayQ[qa, {"Meters", "Meters"}],
				compatibleQuantityArrayQ[qa, {Meter, Meter}],
				compatibleQuantityArrayQ[qa, {"Meters", Meter}],
				compatibleQuantityArrayQ[qa, {Meter, "Meters"}],
				compatibleQuantityArrayQ[qa, "Meters"],
				compatibleQuantityArrayQ[qa, {"Meters"}]
			}],
		{True, True, True, True, True, False}
	]


}];


(* ::Subsubsection::Closed:: *)
(*unitsArrayPatternQ*)


DefineTests[unitsArrayPatternQ, {

	Test["Does not match single unit without list:",
		unitsArrayPatternQ[Meter],
		False
	],
	Test["Match single unit in list:",
		unitsArrayPatternQ[{Meter..}],
		True
	],
	Test["Match 2D array pattern",
		unitsArrayPatternQ[{{Meter, Second}..}],
		True
	],
	Test["Match 3D array pattern",
		unitsArrayPatternQ[{{{Meter, Second}..}..}],
		True
	],
	Test["Invalid unit pattern:",
		unitsArrayPatternQ[{{Meter, "String"}..}],
		False
	]

}];


(* ::Subsubsection::Closed:: *)
(*PositiveQuantityQ*)


DefineTests[PositiveQuantityQ,
	{
		Example[{Basic, "Return True for an input with units and a positive magnitude:"},
			PositiveQuantityQ[1 Millimeter],
			True
		],
		Example[{Basic, "Return False for a dimension-less input with a positive magnitude:"},
			PositiveQuantityQ[393],
			False
		],
		Example[{Basic, "Return False for a unit-ed input with a negative magnitude:"},
			PositiveQuantityQ[-4000 Volt],
			False
		],
		Example[{Additional, "Percentages are considered unit-ed:"},
			PositiveQuantityQ[90 Percent],
			True
		],
		Example[{Additional, "A directly-provided quantity will be assessed for its magnitude, even if it has a negative magnitude in another unit:"},
			PositiveQuantityQ[12 Fahrenheit],
			True
		],
		Example[{Additional, "A quantity, when converted, will have its magnitude assessed after the conversion:"},
			PositiveQuantityQ[Convert[12 Fahrenheit, Celsius]],
			False
		],
		Example[{Additional, "Quantities with zero magnitude return False:"},
			PositiveQuantityQ[0 Newton],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			PositiveQuantityQ[{10 Second, -10 Pascal, 14}],
			{True, False, False}
		]
	}
];


(* ::Subsection::Closed:: *)
(*Unit Type Patterns*)


(* ::Subsubsection::Closed:: *)
(*AbsorbanceQ*)


DefineTests[
	AbsorbanceQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of Absorbance Untis:"},
			AbsorbanceQ[42 AbsorbanceUnit],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			AbsorbanceQ[23 Milli AbsorbanceUnit],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			AbsorbanceQ[23 Nano Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			AbsorbanceQ[{42 AbsorbanceUnit, 32 AbsorbanceUnit, 1.33 AbsorbanceUnit}],
			{True, True, True}
		],
		Test["Does not accept giberish:",
			AbsorbanceQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*AbsorbanceAreaQ*)


DefineTests[
	AbsorbanceAreaQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of Absorbance times untis of time:"},
			AbsorbanceAreaQ[2.3 Milli AbsorbanceUnit Minute],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			AbsorbanceAreaQ[2.3  AbsorbanceUnit Micro Minute],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			AbsorbanceAreaQ[2.3  AbsorbanceUnit Liter Micro Minute],
			False
		],
		Test["Does not accept giberish:",
			AbsorbanceAreaQ["Taco"],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			AbsorbanceAreaQ[{2.3 Milli AbsorbanceUnit Minute, 2.3  AbsorbanceUnit Micro Minute, 2.3  AbsorbanceUnit Liter Micro Minute}],
			{True, True, False}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*AbsorbanceDistanceQ*)


DefineTests[
	AbsorbanceDistanceQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of Absorbance times untis of distance:"},
			AbsorbanceDistanceQ[5 AbsorbanceUnit Nano Meter],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			AbsorbanceDistanceQ[23 Milli AbsorbanceUnit Nano Meter],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			AbsorbanceDistanceQ[23 Milli Meter Nano Meter],
			False
		],
		Test["Does not accept giberish:",
			AbsorbanceDistanceQ["Taco"],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			AbsorbanceDistanceQ[{5 AbsorbanceUnit Nano Meter, 23 Milli AbsorbanceUnit Nano Meter, 23 Milli Meter Nano Meter}],
			{True, True, False}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*AbsorbancePerDistanceQ*)


DefineTests[
	AbsorbancePerDistanceQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of Absorbance per untis of distance:"},
			AbsorbancePerDistanceQ[AbsorbanceUnit / (Nano Meter)],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			AbsorbancePerDistanceQ[23 (Milli AbsorbanceUnit) / (Nano Meter)],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			AbsorbancePerDistanceQ[23(Milli Meter) / (Nano Meter)],
			False
		],
		Test["Does not accept giberish:",
			AbsorbancePerDistanceQ["Taco"],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			AbsorbancePerDistanceQ[{AbsorbanceUnit / (Nano Meter), 23 (Milli AbsorbanceUnit) / (Nano Meter), 23(Milli Meter) / (Nano Meter)}],
			{True, True, False}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*AbsorbanceRateQ*)


DefineTests[
	AbsorbanceRateQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of Absorbance per untis of time:"},
			AbsorbanceRateQ[AbsorbanceUnit / (3 Hour)],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			AbsorbanceRateQ[(2.34 Milli AbsorbanceUnit) / Second],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			AbsorbanceRateQ[(3 Milli Liter) / (3 Hour)],
			False
		],
		Test["Does not accept giberish:",
			AbsorbanceRateQ["Taco"],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			AbsorbanceRateQ[{AbsorbanceUnit / (3 Hour), (2.34 Milli AbsorbanceUnit) / Second, (3 Milli Liter) / (3 Hour)}],
			{True, True, False}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*AccelerationQ*)


DefineTests[
	AccelerationQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of distance per time-squared:"},
			AccelerationQ[3.5 * Meter / Second^2],
			True
		],
		Example[{Basic, "Allows acceleration in terms of g:"},
			AccelerationQ[3 * GravitationalAcceleration],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			AccelerationQ[3.5 * Kilometer / Second^2],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			AccelerationQ[3.5 Meter / Second],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			AccelerationQ[{3.5 * Meter / Second^2, 3 * GravitationalAcceleration, 3.5 Meter / Second}],
			{True, True, False}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*AngularVelocityQ*)


DefineTests[
	AngularVelocityQ,
	{
		Example[{Basic, "AngularVelocityQ test if a value is in Units of revolutions per time:"},
			AngularVelocityQ[10 Revolution / Second],
			True
		],
		Example[{Basic, "The function recognizes any unit of time:"},
			AngularVelocityQ[5.5 Revolution / Millennium],
			True
		],
		Example[{Basic, "The function can recognize metric prefixes:"},
			AngularVelocityQ[6.5 Revolution / (Micro Second)],
			True
		],
		Example[{Basic, "Values which are not in revolutions per time will return false:"},
			AngularVelocityQ[5.5 Year / Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			AngularVelocityQ[{6.5 Revolution / Second, 22.2 Revolution / Hour, 34 Newton}],
			{True, True, False}
		],
		Test["Nonsense input returns false:",
			AngularVelocityQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*AmountQ*)


DefineTests[
	AmountQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of Moles:"},
			AmountQ[3.4 Mole],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			AmountQ[23 Nano Mole],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			AmountQ[23 Nano Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			AmountQ[{42 Milli Mole, 32 Nano Mole, 1.33 Mole}],
			{True, True, True}
		],
		Test["Does not accept giberish:",
			AmountQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ArbitraryUnitQ*)


DefineTests[
	ArbitraryUnitQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of ArbitraryUnit:"},
			ArbitraryUnitQ[3.4 ArbitraryUnit],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			ArbitraryUnitQ[23 Nano ArbitraryUnit],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			ArbitraryUnitQ[23 Nano Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			ArbitraryUnitQ[{42 Milli ArbitraryUnit, 32 Nano ArbitraryUnit, 1.33 ArbitraryUnit}],
			{True, True, True}
		],
		Test["Does not accept giberish:",
			ArbitraryUnitQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*AreaQ*)


DefineTests[
	AreaQ,
	{
		Example[{Basic, "AreaQ test if a value is in Units of squared distances:"},
			AreaQ[6.5 Meter^2],
			True
		],
		Example[{Basic, "The function recognizes both metric and imperial Units:"},
			AreaQ[23 Inch Inch],
			True
		],
		Example[{Basic, "The function can recognize metric prefixes:"},
			AreaQ[6.5 (Kilo Meter)^2],
			True
		],
		Example[{Basic, "Values which are not in Units of Area will return false:"},
			AreaQ[5.5 Year / Meter],
			False
		],
		Example[{Issues, "Mixed distance Units do not confuse AreaQ:"},
			AreaQ[125 Meter Inch],
			True
		],
		Example[{Attributes, Listable, "The function is listable:"},
			AreaQ[{24 (Kilo Meter)^2, 22 Inch^2, 34 Newton}],
			{True, True, False}
		],
		Test["Nonsense input returns false:",
			AreaQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*BasePairQ*)


DefineTests[
	BasePairQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of BasePair:"},
			BasePairQ[3.4 BasePair],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			BasePairQ[23 Nano BasePair],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			BasePairQ[23 Nano Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			BasePairQ[{42 Milli BasePair, 32 Nano BasePair, 1.33 BasePair}],
			{True, True, True}
		],
		Test["Does not accept giberish:",
			BasePairQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ByteQ*)


DefineTests[
	ByteQ,
	{
		Example[{Basic, "Returns True on Bytes:"},
			ByteQ[2 Mega Quantity[1, "Bytes"]],
			True
		],
		Example[{Basic, "Returns True on Mega Bytes:"},
			ByteQ[2 Mega Quantity[1, "Bytes"]],
			True
		],
		Example[{Basic, "Returns False if the unites are not Bytes:"},
			ByteQ[2 Mega],
			False
		],
		Example[{Attributes, Listable, "Can take in a list:"},
			ByteQ[{2 Mega, 1 Quantity[1, "Bytes"]}],
			{False, True}
		]

	}
];



(* ::Subsubsection::Closed:: *)
(*CFUQ*)


DefineTests[
	CFUQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of CFU:"},
			CFUQ[3.4 CFU],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			CFUQ[23 Nano CFU],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			CFUQ[23 Nano Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			CFUQ[{42 Milli CFU, 32 Nano CFU, 1.33 CFU}],
			{True, True, True}
		],
		Test["Does not accept giberish:",
			CFUQ["Taco"],
			False
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*ColonyCountQ*)


DefineTests[
	ColonyCountQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of Colony:"},
			ColonyCountQ[3.4 Colony],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			ColonyCountQ[23 Micro Colony],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			ColonyCountQ[23 Nano Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			ColonyCountQ[{42 Milli Colony, 32 Nano Colony, 1.33 Colony}],
			{True, True, True}
		],
		Test["Does not accept giberish:",
			ColonyCountQ["Taco"],
			False
		]
	}
];
(* ::Subsubsection::Closed:: *)
(*ConcentrationQ*)


DefineTests[
	ConcentrationQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of BasePair:"},
			ConcentrationQ[3.4 Molar],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			ConcentrationQ[23 Nano Molar],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			ConcentrationQ[23 Nano Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			ConcentrationQ[{42 Milli Molar, 32 Nano Molar, 1.33 Molar}],
			{True, True, True}
		],
		Test["Does not accept giberish:",
			ConcentrationQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ConductanceQ*)


DefineTests[
	ConductanceQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of Conductance:"},
			ConductanceQ[(Kilo Siemens) / (Micro Meter)],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			ConductanceQ[Siemens / Meter],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			ConductanceQ[23 Meter],
			False
		],
		Example[{Attributes, Listable, "Can take in a list:"},
			ConductanceQ[{23 Meter, (Kilo Siemens) / (Micro Meter)}],
			{False, True}
		],
		Test["Does not accept giberish:",
			ConductanceQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ConductanceAreaQ*)


DefineTests[
	ConductanceAreaQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of Conductance:"},
			ConductanceAreaQ[(Millisiemen Minute) / Centimeter],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			ConductanceAreaQ[(Milli Siemens Second) / Meter],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			ConductanceAreaQ[23 Meter],
			False
		],
		Example[{Attributes, Listable, "Can take in a list:"},
			ConductanceAreaQ[{23 Meter, (Millisiemen Minute) / Centimeter}],
			{False, True}
		],
		Test["Does not accept giberish:",
			ConductanceAreaQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ConductancePerTimeQ*)


DefineTests[
	ConductancePerTimeQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of Conductance per Units of time:"},
			ConductancePerTimeQ[(Milli Siemens) / ((Centi Meter) Minute)],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			ConductancePerTimeQ[(Milli Siemens) / ((Centi Meter) Hour)],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			ConductancePerTimeQ[23 Meter],
			False
		],
		Example[{Attributes, Listable, "Can take in a list:"},
			ConductancePerTimeQ[{23 Meter, (Milli Siemens) / ((Centi Meter) Minute)}],
			{False, True}
		],
		Test["Does not accept giberish:",
			ConductancePerTimeQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ChemicalShiftQ*)


DefineTests[
	ChemicalShiftQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of Chemical Shift (Parts Per Million):"},
			ChemicalShiftQ[23 PPM],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			ChemicalShiftQ[2.3 Kilo PPM],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			ChemicalShiftQ[23 Meter],
			False
		],
		Example[{Attributes, Listable, "Can take in a list:"},
			ChemicalShiftQ[{23 Meter, 23 PPM}],
			{False, True}
		],
		Test["Does not accept giberish:",
			ChemicalShiftQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ChemicalShiftStrengthQ*)


DefineTests[
	ChemicalShiftStrengthQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of Chemical Shift (Parts Per Million) times Arbitrary Units:"},
			ChemicalShiftStrengthQ[23 PPM ArbitraryUnit],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			ChemicalShiftStrengthQ[2.3 (Kilo PPM) (Milli ArbitraryUnit)],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			ChemicalShiftStrengthQ[23 Meter],
			False
		],
		Example[{Attributes, Listable, "Can take in a list:"},
			ChemicalShiftStrengthQ[{23 Meter, 23 PPM ArbitraryUnit}],
			{False, True}
		],
		Test["Does not accept giberish:",
			ChemicalShiftStrengthQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*CurrencyQ*)


DefineTests[
	CurrencyQ,
	{
		Example[{Basic, "Returns True on currency:"},
			CurrencyQ[22 USD],
			True
		],
		Example[{Basic, "Handles metric prefixes:"},
			CurrencyQ[2.4Mega USD],
			True
		],
		Example[{Basic, "Returns False on anything except currency:"},
			CurrencyQ["Fish"],
			False
		],
		Example[{Attributes, Listable, "Can take in a list:"},
			CurrencyQ[{"Fish", 22 USD}],
			{False, True}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*CurrentQ*)


DefineTests[
	CurrentQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of Ampere:"},
			CurrentQ[3.4 Ampere],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			CurrentQ[23 Nano Ampere],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			CurrentQ[23 Nano Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			CurrentQ[{42 Milli Ampere, 32 Nano Ampere, 1.33 Ampere}],
			{True, True, True}
		],
		Test["Does not accept giberish:",
			CurrentQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*CycleQ*)


DefineTests[
	CycleQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of Cycle:"},
			CycleQ[3.4 Cycle],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			CycleQ[23 Nano Cycle],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			CycleQ[23 Nano Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			CycleQ[{42 Milli Cycle, 32 Nano Cycle, 1.33 Cycle}],
			{True, True, True}
		],
		Test["Does not accept giberish:",
			CycleQ["Taco"],
			False
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*DistanceQ*)


DefineTests[
	DistanceQ,
	{

		Example[{Basic, "Returns true if the quantity is in Units of distance:"},
			DistanceQ[12 Meter],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			DistanceQ[23 Micro Meter],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			DistanceQ[1234 Molar],
			False
		],
		Test["Does not accept gibberish:",
			DistanceQ["Taco"],
			False
		],
		Example[{Attributes, Listable, "This function is listable:"},
			DistanceQ[{23 Foot, 5 Milli Meter, 2 Liter, .5 Kilo Meter}],
			{True, True, False, True}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*DensityQ*)


DefineTests[
	DensityQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of mass per volume:"},
			DensityQ[234 Gram / Liter],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			DensityQ[45 (Micro Gram) / (Milli Liter)],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			DensityQ[1234 Molar],
			False
		],
		Test["Does not accept gibberish:",
			DensityQ["Taco"],
			False
		],
		Example[{Attributes, Listable, "This function is listable:"},
			DensityQ[{23 Gram / Liter, 5 Milli Gram / Liter, 5 Foot}],
			{True, True, False}
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*EnergyQ*)


DefineTests[
	EnergyQ,
	{
		Example[{Basic, "EnergyQ test if a value is in Units of molar energy:"},
			EnergyQ[23 (Kilo Joule) / Mole],
			True
		],
		Example[{Basic, "The function recognizes metric and imperial Units:"},
			EnergyQ[34.2 (Kilo Calorie) / Mole],
			True
		],
		Example[{Basic, "The function can recognize metric prefixes:"},
			EnergyQ[6.5 (Kilo Calorie) / (Micro Mole)],
			True
		],
		Example[{Basic, "Values which are not in Units of energy will return false:"},
			EnergyQ[5.5 Year / Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			EnergyQ[{5 Joule / Mole, 12.3 Joule / Mole, 34 Newton}],
			{True, True, False}
		],
		Test["Nonsense input returns false:",
			EnergyQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*EntropyQ*)


DefineTests[
	EntropyQ,
	{
		Example[{Basic, "EntropyQ test if a value is in Units of molar energy:"},
			EntropyQ[23 (Kilo Joule) / (Mole Kelvin)],
			True
		],
		Example[{Basic, "The function recognizes metric and imperial Units:"},
			EntropyQ[34.2 Calorie / (Mole Kelvin)],
			True
		],
		Example[{Basic, "The function can recognize metric prefixes:"},
			EntropyQ[6.5 (Mega Joule) / (Mole Fahrenheit)],
			True
		],
		Example[{Basic, "Values which are not in Units of pixels per distance will return false:"},
			EntropyQ[5.5 Year / Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			EntropyQ[{5 Calorie / (Mole Kelvin), 12.3 Calorie / (Mole Kelvin), 34 Newton}],
			{True, True, False}
		],
		Test["Nonsense input returns false:",
			EntropyQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ExtinctionCoefficientQ*)


DefineTests[
	ExtinctionCoefficientQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of volume / (distance * amount):"},
			ExtinctionCoefficientQ[234 Liter / (Centi Meter Mole)],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			ExtinctionCoefficientQ[45 Milli Liter / (Milli Meter * Micro Mole)],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			ExtinctionCoefficientQ[1234 Molar],
			False
		],
		Test["Does not accept gibberish:",
			ExtinctionCoefficientQ["Taco"],
			False
		],
		Example[{Attributes, Listable, "This function is listable:"},
			ExtinctionCoefficientQ[{23 Liter / (Centi Meter Mole), 2 Liter, 34 Liter / (Centi Meter Mole)}],
			{True, False, True}
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*FirstOrderRateQ*)


DefineTests[
	FirstOrderRateQ,
	{
		Example[{Basic, "FirstOrderRateQ tests if a value is in Units of first order kinetic rates constants:"},
			FirstOrderRateQ[0.1 / Hour],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			FirstOrderRateQ[12.2 (Milli Second)^-1],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			FirstOrderRateQ[12.2 Molar],
			False
		],
		Test["Does not accept giberish:",
			FirstOrderRateQ["Taco"],
			False
		],
		Example[{Attributes, Listable, "This function is listable:"},
			FirstOrderRateQ[{2 / Minute, 3 (Second)^-1, 4 Meter}],
			{True, True, False}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*FlowRateQ*)


DefineTests[
	FlowRateQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of volume per Units of time:"},
			FlowRateQ[ (Milli Liter) / Month],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			FlowRateQ[ (Micro Liter) / Second],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			FlowRateQ[Meter / Year],
			False
		],
		Test["Does not accept giberish:",
			FlowRateQ["Taco"],
			False
		],
		Example[{Attributes, Listable, "This function is listable:"},
			FlowRateQ[{2 Liter / Hour, 5 Milli Meter, 4 Milli Liter / Second}],
			{True, False, True}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*FluorescenceQ*)


DefineTests[
	FluorescenceQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of fluorescence:"},
			FluorescenceQ[13RFU],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			FluorescenceQ[1.12312 Micro RFU],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			FluorescenceQ[1.12312 Mile],
			False
		],
		Test["Does not accept giberish:",
			FluorescenceQ["Taco"],
			False
		],
		Example[{Attributes, Listable, "This function is listable:"},
			FluorescenceQ[{2 RFU, 5 Milli Meter, 4 Milli RFU}],
			{True, False, True}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*FluorescenceAreaQ*)


DefineTests[
	FluorescenceAreaQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of fluorescence times distance:"},
			FluorescenceAreaQ[25RFU Meter],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			FluorescenceAreaQ[2.255Milli RFU ( Nano Meter)],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			FluorescenceAreaQ[1.12312 Mile],
			False
		],
		Test["Does not accept giberish:",
			FluorescenceAreaQ["Taco"],
			False
		],
		Example[{Attributes, Listable, "This function is listable:"},
			FluorescenceAreaQ[{2 RFU Meter, 5 Milli Meter, 4 Milli RFU Meter}],
			{True, False, True}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*FluorescencePerAreaQ*)


DefineTests[
	FluorescencePerAreaQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of fluorescence per distance:"},
			FluorescencePerAreaQ[25RFU / Meter],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			FluorescencePerAreaQ[2.255Milli RFU / ( Nano Meter)],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			FluorescencePerAreaQ[1.12312 Mile],
			False
		],
		Test["Does not accept giberish:",
			FluorescencePerAreaQ["Taco"],
			False
		],
		Example[{Attributes, Listable, "This function is listable:"},
			FluorescencePerAreaQ[{2 RFU / Meter, 5 Milli Meter, 4 Milli RFU / Meter}],
			{True, False, True}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*FluorescenceTimeQ*)


DefineTests[
	FluorescenceTimeQ,
	{
		Example[{Basic, "Returns True on RFU Time:"},
			FluorescenceTimeQ[25RFU Second],
			True
		],
		Example[{Basic, "Returns True on RFU Time:"},
			FluorescenceTimeQ[2.255Milli RFU Nano Second],
			True
		],
		Example[{Basic, "Returns False on anything else:"},
			FluorescenceTimeQ["Fish"],
			False
		],
		Example[{Attributes, Listable, "Can take in a list:"},
			FluorescenceTimeQ[{2.255Milli RFU Nano Second, "Fish"}],
			{True, False}
		]

	}
];


(* ::Subsubsection::Closed:: *)
(*FrequencyQ*)


DefineTests[
	FrequencyQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of Frequency:"},
			FrequencyQ[ 25 Hertz],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			FrequencyQ[24.1 Mega Hertz],
			True
		],
		Example[{Basic, "Returns true if the quantity is in Units of per time:"},
			FrequencyQ[ 256 / Year],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			FrequencyQ[Meter / Year],
			False
		],
		Example[{Attributes, Listable, "The function can handle a list of potential frequencies:"},
			FrequencyQ[{24.1 Mega Hertz, Meter / Year, 256 / Year}],
			{True, False, True}
		],
		Test["Does not accept giberish:",
			FrequencyQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*FormazinTurbidityUnitQ*)


DefineTests[
	FormazinTurbidityUnitQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of FormazinTurbidityUnit:"},
			FormazinTurbidityUnitQ[3.4 FormazinTurbidityUnit],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			FormazinTurbidityUnitQ[23 Nano FormazinTurbidityUnit],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			FormazinTurbidityUnitQ[23 Nano Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			FormazinTurbidityUnitQ[{42 Milli FormazinTurbidityUnit, 32 Nano FormazinTurbidityUnit, 1.33 FormazinTurbidityUnit}],
			{True, True, True}
		],
		Test["Does not accept giberish:",
			FormazinTurbidityUnitQ["Taco"],
			False
		]
	}
];
(* ::Subsubsection::Closed:: *)
(*InverseMolecularWeightQ*)


DefineTests[
	InverseMolecularWeightQ,
	{
		Example[{Basic, "Returns true if the item has Units of inverse molecular weight:"},
			InverseMolecularWeightQ[134 Mole / Gram],
			True
		],
		Example[{Basic, "Returns false if the item has Units of inverse molecular weight:"},
			InverseMolecularWeightQ[134 Gram / Mole],
			False
		],
		Example[{Basic, "Handles metric forms:"},
			InverseMolecularWeightQ[254 (Nano Mole) / Gram],
			True
		],
		Example[{Attributes, Listable, "The function can handle a list of potential inverse molecular weights:"},
			InverseMolecularWeightQ[{23 Mole / Gram, 10 Dalton, "taco"}],
			{True, False, False}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ISOQ*)


DefineTests[
	ISOQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of ISO:"},
			ISOQ[13 ISO],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			ISOQ[1.12312 Micro ISO],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			ISOQ[1.12312 Mile],
			False
		],
		Test["Does not accept giberish:",
			ISOQ["Taco"],
			False
		],
		Example[{Attributes, Listable, "This function is listable:"},
			ISOQ[{2 ISO, 5 Milli Meter, 4 Milli ISO}],
			{True, False, True}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*RRTQ*)


DefineTests[
	RRTQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of ISO:"},
			RRTQ[13 RRT],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			RRTQ[1.12312 Micro RRT],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			RRTQ[1.12312 Mile],
			False
		],
		Test["Does not accept giberish:",
			RRTQ["Taco"],
			False
		],
		Example[{Attributes, Listable, "This function is listable:"},
			RRTQ[{2 RRT, 5 Milli Meter, 4 Milli RRT}],
			{True, False, True}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*LuminescenceQ*)


DefineTests[
	LuminescenceQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of luminescence:"},
			LuminescenceQ[13 Lumen],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			LuminescenceQ[1.12312 Micro Lumen],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			LuminescenceQ[1.12312 Mile],
			False
		],
		Test["Does not accept giberish:",
			LuminescenceQ["Taco"],
			False
		],
		Example[{Attributes, Listable, "This function is listable:"},
			LuminescenceQ[{2 Lumen, 5 Milli Meter, 4 Milli Lumen}],
			{True, False, True}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*LuminescencePerMolecularWeightQ*)


DefineTests[
	LuminescencePerMolecularWeightQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of luminescence per atomic mass unit:"},
			LuminescencePerMolecularWeightQ[13 Lumen / (Gram / Mole)],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			LuminescencePerMolecularWeightQ[1.12312 Micro Lumen / (Kilo Dalton)],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			LuminescencePerMolecularWeightQ[1.12312 Mile],
			False
		],
		Test["Does not accept giberish:",
			LuminescencePerMolecularWeightQ["Taco"],
			False
		],
		Example[{Attributes, Listable, "This function is listable:"},
			LuminescencePerMolecularWeightQ[{2 Lumen / Dalton, 5 Milli Meter, 4 Milli Lumen / (Kilo Gram / Mole)}],
			{True, False, True}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*MassQ*)


DefineTests[
	MassQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of mass:"},
			MassQ[234 Gram],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			MassQ[5.6 Kilo Gram],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			LuminescenceQ[1.12312 Mile],
			False
		],
		Test["Does not accept giberish:",
			MassQ["Taco"],
			False
		],
		Example[{Attributes, Listable, "This function is listable:"},
			MassQ[{12 Micro Gram, 2 Meter, 34 Kilo Gram}],
			{True, False, True}
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*MassPercentQ*)


DefineTests[
	MassPercentQ,
	{
		Example[{Basic, "MassPercentQ test if a value is in Units of MassPercent:"},
			MassPercentQ[23 MassPercent],
			True
		],
		Example[{Basic, "The function can recognize metric prefixes:"},
			MassPercentQ[6.5 Milli MassPercent],
			True
		],
		Example[{Basic, "Values which are not in Units of MassPercent will return false:"},
			MassPercentQ[5.5 Year / Meter],
			False
		],
		Example[{Basic, "The function only checks the unit but not value:"},
			MassPercentQ[{-1 MassPercent,0 MassPercent,1 MassPercent}],
			{True,True,True}
		],
		Example[{Attributes, Listable, "The function is listable:"},
			MassPercentQ[{1 MassPercent,2 MassConcentration,3.4 VolumePercent, 56 Newton}],
			{True,False,False,False}
		],
		Test["Nonsense input returns false:",
			MassPercentQ["Taco"],
			False
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*MassConcentrationQ*)


DefineTests[
	MassConcentrationQ,
	{
		Example[
			{Basic, "Tests if a single item with mass concentration Units:"},
			MassConcentrationQ[1.45 Gram / Liter],
			True
		],
		Example[
			{Basic, "Can handle mass concentration Units with the volume is in the form of cubic distance:"},
			MassConcentrationQ[1.45 Gram / (Meter^3)],
			True
		],
		Example[
			{Additional, "Metric prefixes are accetable to the test as well:"},
			MassConcentrationQ[1.234 Micro Gram / Liter],
			True
		],
		Example[
			{Additional, "Compound metrix prefixes are also acceptable:"},
			MassConcentrationQ[1.234 Mega Nano Gram / Liter],
			True
		],
		Example[
			{Additional, "Can handle single item with value of 1 * mass concentration Units:"},
			MassConcentrationQ[Micro Gram / Liter],
			True
		],
		Example[
			{Additional, "Will not accept raw values in absense of Units:"},
			MassConcentrationQ[3.45],
			False
		],
		Example[
			{Additional, "Units other than mass concentration will return false:"},
			MassConcentrationQ[2.34 Liter],
			False
		],
		Example[
			{Attributes, Listable, "The function can handle a list of items with mass concentration Units:"},
			MassConcentrationQ[{1.234 Micro Gram / Liter, 1.45 Gram / Liter}],
			{True, True}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*MassExtinctionCoefficientQ*)


DefineTests[
	MassExtinctionCoefficientQ,
	{
		Example[
			{Basic, "Checks to see if item is in Units of mass extinction coefficient:"},
			MassExtinctionCoefficientQ[(59600 Liter) / (Centi Meter Gram)],
			True
		],
		Example[
			{Additional, "Returns False if the Units do not math mass extinction coefficient:"},
			MassExtinctionCoefficientQ[(59600 Liter)],
			False
		],
		Example[
			{Additional, "Can handle metric prefixes:"},
			MassExtinctionCoefficientQ[(59600 Milli Liter) / (Centi Meter Gram)],
			True
		],
		Example[{Additional, "Can handle single item with value of 1 * mass extinction coefficient Units:"},
			MassExtinctionCoefficientQ[(Liter) / (Centi Meter Gram)],
			True
		],
		Example[
			{Attributes, Listable, "The function is listable and chan check a list of potential mass extinction coefficients:"},
			MassExtinctionCoefficientQ[{(59600 Liter) / (Centi Meter Gram), (2 Liter) / (Centi Meter Gram)}],
			{True, True}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*MolecularWeightLuminescenceAreaQ*)


DefineTests[
	MolecularWeightLuminescenceAreaQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of molecular weight * luminsescence:"},
			MolecularWeightLuminescenceAreaQ[54.3 Gram / Mole Lumen],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			MolecularWeightLuminescenceAreaQ[89(Kilo Dalton)(Micro Lumen)],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			MolecularWeightLuminescenceAreaQ[1.12312 Mile],
			False
		],
		Test["Does not accept giberish:",
			MolecularWeightLuminescenceAreaQ["Taco"],
			False
		],
		Example[{Attributes, Listable, "This function is listable:"},
			MolecularWeightLuminescenceAreaQ[{12 (Micro Gram / Mole) Lumen, 2 Meter, 34 Dalton Lumen}],
			{True, False, True}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*MolecularWeightQ*)


DefineTests[
	MolecularWeightQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of molecular weight:"},
			MolecularWeightQ[54.3 Gram / Mole],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			MolecularWeightQ[89 Kilo Dalton],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			MolecularWeightQ[1.12312 Mile],
			False
		],
		Test["Does not accept giberish:",
			MolecularWeightQ["Taco"],
			False
		],
		Example[{Attributes, Listable, "This function is listable:"},
			MolecularWeightQ[{12 Micro Gram / Mole, 2 Meter, 34 Dalton}],
			{True, False, True}
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*NephelometricTurbidityUnitQ*)


DefineTests[
	NephelometricTurbidityUnitQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of NephelometricTurbidityUnit:"},
			NephelometricTurbidityUnitQ[3.4 NephelometricTurbidityUnit],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			NephelometricTurbidityUnitQ[23 Nano NephelometricTurbidityUnit],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			NephelometricTurbidityUnitQ[23 Nano Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			NephelometricTurbidityUnitQ[{42 Milli NephelometricTurbidityUnit, 32 Nano NephelometricTurbidityUnit, 1.33 NephelometricTurbidityUnit}],
			{True, True, True}
		],
		Test["Does not accept giberish:",
			NephelometricTurbidityUnitQ["Taco"],
			False
		]
	}
];
(* ::Subsubsection::Closed:: *)
(*NucleotideQ*)


DefineTests[
	NucleotideQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of nucleotide:"},
			NucleotideQ[331 Nucleotide],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			NucleotideQ[3.1Kilo  Nucleotide],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			NucleotideQ[1.12312 Mile],
			False
		],
		Test["Does not accept giberish:",
			NucleotideQ["Taco"],
			False
		],
		Example[{Attributes, Listable, "This function is listable:"},
			NucleotideQ[{12 Nucleotide, 2 Meter, 34 Mega Nucleotide}],
			{True, False, True}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*OD600Q*)


DefineTests[
	OD600Q,
	{
		Example[{Basic, "Returns true if the quantity is in Units of OD600:"},
			OD600Q[331 OD600],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			OD600Q[3.1Kilo  OD600],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			OD600Q[1.12312 Mile],
			False
		],
		Test["Does not accept giberish:",
			OD600Q["Taco"],
			False
		],
		Example[{Attributes, Listable, "This function is listable:"},
			OD600Q[{12 OD600, 2 Meter, 34 Mega OD600}],
			{True, False, True}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*PercentQ*)


DefineTests[
	PercentQ,
	{
		Example[{Basic, "PercentQ test if a value is in Units of Percent:"},
			PercentQ[23 Percent],
			True
		],
		Example[{Basic, "The function can recognize metric prefixes:"},
			PercentQ[6.5 Milli Percent],
			True
		],
		Example[{Basic, "Values which are not in Units of Percent will return false:"},
			PercentQ[5.5 Year / Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			PercentQ[{5 Percent, 12.3 Percent, 34 Newton}],
			{True, True, False}
		],
		Test["Nonsense input returns false:",
			PercentQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*PercentRateQ*)


DefineTests[
	PercentRateQ,
	{
		Example[{Basic, "PercentRateQ test if a value is in Units of percent per time:"},
			PercentRateQ[6.5 Percent / Second],
			True
		],
		Example[{Basic, "The function recognizes any Units of time:"},
			PercentRateQ[23 Percent / Millennium],
			True
		],
		Example[{Basic, "The function can recognize metric prefixes:"},
			PercentRateQ[6.5 Percent / (Micro Second)],
			True
		],
		Example[{Basic, "Values which are not in Units of percent per time will return false:"},
			PercentRateQ[5.5 Year / Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			PercentRateQ[{6.5 Percent / Second, 22.2 Percent / Second, 34 Newton}],
			{True, True, False}
		],
		Test["Nonsense input returns false:",
			PercentRateQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*PerMolarQ*)


DefineTests[
	PerMolarQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of per Molar:"},
			PerMolarQ[3.4 / Molar],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			PerMolarQ[23 / (Nano Molar)],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			PerMolarQ[23 / (Nano Meter)],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			PerMolarQ[{42 / (Milli Molar), 32 / (Nano Molar), 1.33 / (Molar)}],
			{True, True, True}
		],
		Test["Does not accept giberish:",
			PerMolarQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*PixelQ*)


DefineTests[
	PixelQ,
	{
		Example[{Basic, "PixelQ test if a value is in Units of Pixels:"},
			PixelQ[23 Pixel],
			True
		],
		Example[{Basic, "The function can recognize metric prefixes:"},
			PixelQ[13.3 Kilo Pixel],
			True
		],
		Example[{Basic, "Values which are not in Units of Pixels will return false:"},
			PixelQ[5.5 Year / Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			PixelQ[{6.5 Pixel, 22.2 Pixel, 34 Newton}],
			{True, True, False}
		],
		Test["Nonsense input returns false:",
			PixelQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*PixelAreaQ*)


DefineTests[
	PixelAreaQ,
	{
		Example[{Basic, "PixelAreaQ test if a value is in Units of pixels squared:"},
			PixelAreaQ[23 Pixel Pixel],
			True
		],
		Example[{Basic, "The function can recognize metric prefixes:"},
			PixelAreaQ[6.5 Kilo Pixel^2],
			True
		],
		Example[{Basic, "Values which are not in Units of pixels squared will return false:"},
			PixelAreaQ[5.5 Year / Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			PixelAreaQ[{5 Pixel Pixel, 12.3 Pixel Pixel, 34 Newton}],
			{True, True, False}
		],
		Test["Nonsense input returns false:",
			PixelAreaQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*PixelsPerDistanceQ*)


DefineTests[
	PixelsPerDistanceQ,
	{
		Example[{Basic, "PixelsPerDistanceQ test if a value is in Units of pixels per distance:"},
			PixelsPerDistanceQ[23 Pixel / Meter],
			True
		],
		Example[{Basic, "The function recognizes metric and imperial Units:"},
			PixelsPerDistanceQ[34.2 Pixel / Inch],
			True
		],
		Example[{Basic, "The function can recognize metric prefixes:"},
			PixelsPerDistanceQ[6.5 Pixel / (Milli Meter)],
			True
		],
		Example[{Basic, "Values which are not in Units of pixels per distance will return false:"},
			PixelsPerDistanceQ[5.5 Year / Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			PixelsPerDistanceQ[{5 Pixel / Meter, 12.3 Pixel / Meter, 34 Newton}],
			{True, True, False}
		],
		Test["Nonsense input returns false:",
			PixelsPerDistanceQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*PowerQ*)


DefineTests[
	PowerQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of Watt:"},
			PowerQ[3.4 Watt],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			PowerQ[23 Nano Watt],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			PowerQ[23 Nano Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			PowerQ[{42 Milli Watt, 32 Nano Watt, 1.33 Watt}],
			{True, True, True}
		],
		Test["Does not accept giberish:",
			PowerQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*PressureQ*)


DefineTests[
	PressureQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of pressure:"},
			PressureQ[3.4 PSI],
			True
		],
		Example[{Basic, "Works with any unit of pressure:"},
			PressureQ[3.4 Pascal],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			PressureQ[23 Milli Torr],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			PressureQ[23 Nano Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			PressureQ[{42  PSI, 32 Nano Bar, 1.33 Torr}],
			{True, True, True}
		],
		Test["Does not accept giberish:",
			PressureQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*RelativeNephelometricUnitQ*)


DefineTests[
	RelativeNephelometricUnitQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of RelativeNephelometricUnit:"},
			RelativeNephelometricUnitQ[3.4 RelativeNephelometricUnit],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			RelativeNephelometricUnitQ[23 Nano RelativeNephelometricUnit],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			RelativeNephelometricUnitQ[23 Nano Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			RelativeNephelometricUnitQ[{42 Milli RelativeNephelometricUnit, 32 Nano RelativeNephelometricUnit, 1.33 RelativeNephelometricUnit}],
			{True, True, True}
		],
		Test["Does not accept giberish:",
			RelativeNephelometricUnitQ["Taco"],
			False
		]
	}
];
(* ::Subsubsection::Closed:: *)
(*ResistivityQ*)


DefineTests[
	ResistivityQ,
	{
		Example[{Basic, "ResistivityQ test if a value is in Units of resistance per distance:"},
			ResistivityQ[10 (Mega Ohm) * (Centi Meter)],
			True
		],
		Example[{Basic, "The function recognizes metric and imperial Units:"},
			ResistivityQ[34.2 Ohm * Inch],
			True
		],
		Example[{Basic, "The function can recognize metric prefixes:"},
			ResistivityQ[6.5 (Kilo Ohm) * (Milli Meter)],
			True
		],
		Example[{Basic, "Values which are not in Units of resistance times distance will return false:"},
			ResistivityQ[5.5 Year * Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			ResistivityQ[{6.5 (Mega Ohm) * (Centi Meter), 22.2 (Mega Ohm) * (Centi Meter), 34 Newton}],
			{True, True, False}
		],
		Test["Nonsense input returns false:",
			ResistivityQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*RPMQ*)


DefineTests[
	RPMQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of RPM:"},
			RPMQ[3.4 RPM],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			RPMQ[23 Nano RPM],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			RPMQ[23 Nano Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			RPMQ[{42 Milli RPM, 32 Nano RPM, 1.33 RPM}],
			{True, True, True}
		],
		Test["Does not accept giberish:",
			RPMQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*SecondOrderRateQ*)


DefineTests[
	SecondOrderRateQ,
	{
		Example[{Basic, "SecondOrderRateQ tests if a value is in Units of second order kinetic rates constants:"},
			SecondOrderRateQ[5 * 10^5 Molar^-1 Second^-1],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			SecondOrderRateQ[9.2 * 10^3 (Micro Molar)^-1 Hour^-1],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			SecondOrderRateQ[Liter^-1],
			False
		],
		Test["Does not accept giberish:",
			SecondOrderRateQ["Taco"],
			False
		],
		Example[{Attributes, Listable, "This function is listable:"},
			SecondOrderRateQ[{2 / (Molar Minute), 3 (Second Milli Molar)^-1, 4 Meter}],
			{True, True, False}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*StrengthPerChemicalShiftQ*)


DefineTests[
	StrengthPerChemicalShiftQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of AU/PPM:"},
			StrengthPerChemicalShiftQ[3.4 ArbitraryUnit / PPM],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			StrengthPerChemicalShiftQ[23 (Nano ArbitraryUnit) / (Mega PPM)],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			StrengthPerChemicalShiftQ[23 Nano Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			StrengthPerChemicalShiftQ[{42 (Milli ArbitraryUnit) / PPM, 32 (Mega ArbitraryUnit) / (Pico PPM), 1.33 ArbitraryUnit / PPM}],
			{True, True, True}
		],
		Test["Does not accept giberish:",
			StrengthPerChemicalShiftQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*StrengthPerMolecularWeightQ*)


DefineTests[
	StrengthPerMolecularWeightQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of AU/MolecularWeight:"},
			StrengthPerMolecularWeightQ[3.4 ArbitraryUnit / Dalton],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			StrengthPerMolecularWeightQ[23 (Nano ArbitraryUnit) / (Mega (Gram / Mole))],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			StrengthPerMolecularWeightQ[23 Nano Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			StrengthPerMolecularWeightQ[{42 (Milli ArbitraryUnit) / (Gram / Mole), 32 (Mega ArbitraryUnit) / (Pico Dalton), 1.33 ArbitraryUnit / Dalton}],
			{True, True, True}
		],
		Test["Does not accept giberish:",
			StrengthPerMolecularWeightQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*TimeQ*)


DefineTests[
	TimeQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of time:"},
			TimeQ[3.4 Second],
			True
		],
		Example[{Basic, "Works with any Units of time:"},
			TimeQ[3.4 Year],
			True
		],
		Example[{Basic, "Another unit of time:"},
			TimeQ[3.4 Minute],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			TimeQ[23 Milli Day],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			TimeQ[23 Nano Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			TimeQ[{42 Hour, 32 Nano Second, 1.33 Minute}],
			{True, True, True}
		],
		Test["Does not accept giberish:",
			TimeQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*TimeOfFlightAreaQ*)


DefineTests[
	TimeOfFlightAreaQ,
	{
		Example[{Basic, "Returns true if the item has Units of time of flight spectra area:"},
			TimeOfFlightAreaQ[25 ArbitraryUnit Second],
			True
		],
		Example[{Basic, "Returns false if the item has Units of time of flight spectra area:"},
			TimeOfFlightAreaQ[2.255 ArbitraryUnit Meter],
			False
		],
		Example[{Basic, "Handles metric forms:"},
			TimeOfFlightAreaQ[25 ArbitraryUnit Nano Second],
			True
		],
		Example[{Attributes, Listable, "Can handle a list of inputs:"},
			TimeOfFlightAreaQ[{25. ArbitraryUnit Nano Second, 25 ArbitraryUnit Meter, "taco"}],
			{True, False, False}
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*TemperatureQ*)


DefineTests[
	TemperatureQ,
	{
		Example[{Basic, "TemperatureQ tests if a value is in Units of temperature:"},
			TemperatureQ[23 Celsius],
			True
		],
		Example[{Basic, "Works regardless of unit:"},
			TemperatureQ[233 Kelvin],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			TemperatureQ[12.2 Molar],
			False
		],
		Test["Does not accept giberish:",
			TemperatureQ["Taco"],
			False
		],
		Example[{Attributes, Listable, "This function is listable:"},
			TemperatureQ[{2 Celsius, 70 Fahrenheit, 300 Kelvin, 3 Foot}],
			{True, True, True, False}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*TemperatureRampRateQ*)


DefineTests[
	TemperatureRampRateQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of Temperature/Time:"},
			TemperatureRampRateQ[3.4 Kelvin / Hour],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			TemperatureRampRateQ[23 (Nano Kelvin) / (Mega Second)],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			TemperatureRampRateQ[23 Nano Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			TemperatureRampRateQ[{42 (Milli Kelvin) / Day, 32 (Celsius) / (Pico Second), 1.33 Fahrenheit / Year}],
			{True, True, True}
		],
		Test["Does not accept giberish:",
			TemperatureRampRateQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*SpeedQ*)


DefineTests[
	SpeedQ,
	{
		Example[{Basic, "SpeedQ test if a value is in Units of distance per time:"},
			SpeedQ[10 Meter / Second],
			True
		],
		Example[{Basic, "The function recognizes metric and imperial Units:"},
			SpeedQ[34.2 Foot / Second],
			True
		],
		Example[{Basic, "The function can recognize metric prefixes:"},
			SpeedQ[6.5 (Milli Meter) / Second],
			True
		],
		Example[{Basic, "Values which are not in Units of distance per time will return false:"},
			SpeedQ[5.5 Year / Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			SpeedQ[{6.5 Meter / Second, 22.2 Foot / Minute, 34 Newton}],
			{True, True, False}
		],
		Test["Nonsense input returns false:",
			SpeedQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ViscosityQ*)


DefineTests[
	ViscosityQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of viscosity:"},
			ViscosityQ[3.4 Pascal Second],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			ViscosityQ[23 (Nano Gram) / (Meter Second)],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			ViscosityQ[23 Nano Kelvin],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			ViscosityQ[{42 PSI Year, 32 (Micro Gram) / (Hour Inch), 1.33 Pascal Hour}],
			{True, True, True}
		],
		Test["Does not accept giberish:",
			ViscosityQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*VoltageQ*)


DefineTests[
	VoltageQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of Volts:"},
			VoltageQ[3.4 Volt],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			VoltageQ[23 Nano Volt],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			VoltageQ[23 Nano Kelvin],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			VoltageQ[{42 Milli Volt, 32 Kilo Volt, 1.33 Volt}],
			{True, True, True}
		],
		Test["Does not accept giberish:",
			VoltageQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*VolumeQ*)


DefineTests[
	VolumeQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of volume:"},
			VolumeQ[3.4 Liter],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			VolumeQ[23 Nano Liter],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			VolumeQ[23 Nano Kelvin],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			VolumeQ[{42 Milli Liter, 32 Gallon, 1.33 Liter}],
			{True, True, True}
		],
		Test["Does not accept giberish:",
			VolumeQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*VolumePercentQ*)


DefineTests[
	VolumePercentQ,
	{
		Example[{Basic, "VolumePercentQ test if a value is in Units of VolumePercent:"},
			VolumePercentQ[23 VolumePercent],
			True
		],
		Example[{Basic, "The function can recognize metric prefixes:"},
			VolumePercentQ[6.5 Milli VolumePercent],
			True
		],
		Example[{Basic, "Values which are not in Units of Percent will return false:"},
			VolumePercentQ[5.5 Year / Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			VolumePercentQ[{5 VolumePercent, 12.3 VolumePercent, 34 Newton}],
			{True, True, False}
		],
		Test["Nonsense input returns false:",
			VolumePercentQ["Taco"],
			False
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*DimensionlessQ*)


DefineTests[
	DimensionlessQ,
	{
		Example[{Basic, "DimensionlessQ test if a value has no unit:"},
			DimensionlessQ[1],
			True
		],
		Example[{Basic, "Values have a dimensions will return False:"},
			DimensionlessQ[1 Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			DimensionlessQ[{1 Meter, 1}],
			{False, True}
		],
		Test["Nonsense input returns false:",
			DimensionlessQ["Taco"],
			False
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*DimensionlessQ*)


DefineTests[
	NoUnitQ,
	{
		Example[{Basic, "NoUnitQ test if a value has no unit:"},
			NoUnitQ[1],
			True
		],
		Example[{Basic, "Values have a dimensions will return False:"},
			NoUnitQ[1 Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			NoUnitQ[{1 Meter, 1}],
			{False, True}
		],
		Test["Nonsense input returns false:",
			NoUnitQ["Taco"],
			False
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*MolecularWeightStrengthQ*)


DefineTests[
	MolecularWeightStrengthQ,
	{
		Example[{Basic, "Returns true if the quantity is in Units of AU MolecularWeight:"},
			MolecularWeightStrengthQ[3.4 ArbitraryUnit Dalton],
			True
		],
		Example[{Basic, "Works regardless of metric prefixes:"},
			MolecularWeightStrengthQ[23 Nano ArbitraryUnit Dalton],
			True
		],
		Example[{Basic, "Will reject things that are not in the correct Units:"},
			MolecularWeightStrengthQ[23 Nano Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			MolecularWeightStrengthQ[{42 Milli ArbitraryUnit Dalton, 32 Nano ArbitraryUnit (Gram / Mole), 1.33 ArbitraryUnit Dalton}],
			{True, True, True}
		],
		Test["Does not accept giberish:",
			MolecularWeightStrengthQ["Taco"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*WeightVolumePercentQ*)


DefineTests[
	WeightVolumePercentQ,
	{
		Example[{Basic, "WeightVolumePercentQ test if a value is in Units of WeightVolumePercent:"},
			WeightVolumePercentQ[23 WeightVolumePercent],
			True
		],
		Example[{Basic, "The function can recognize metric prefixes:"},
			WeightVolumePercentQ[6.5 Milli WeightVolumePercent],
			True
		],
		Example[{Basic, "Values which are not in Units of Percent will return false:"},
			WeightVolumePercentQ[5.5 Year / Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			WeightVolumePercentQ[{5 WeightVolumePercent, 12.3 WeightVolumePercent, 34 Newton}],
			{True, True, False}
		],
		Test["Nonsense input returns false:",
			WeightVolumePercentQ["Taco"],
			False
		]
	}
];


(* ::Subsection::Closed:: *)
(*Unit Comparisons*)


(* ::Subsubsection::Closed:: *)
(*EqualP*)


DefineTests[EqualP, {
	Example[{Basic, "Test if two values are equal:"},
		MatchQ[3, EqualP[3]],
		True
	],
	Example[{Basic, "Units can be different:"},
		MatchQ[2Foot, EqualP[24Inch]],
		True
	],
	Example[{Basic, "Does not match if values are not equal:"},
		MatchQ[2, EqualP[3]],
		False
	],
	Example[{Basic, "Does not match if quantities are unequal:"},
		MatchQ[3Foot, EqualP[11Inch]],
		False
	]

}];



(* ::Subsubsection::Closed:: *)
(*GreaterP*)


DefineTests[GreaterP, {
	Example[{Basic, "Returns a pattern that matches any quantity greater than given quantity:"},
		MatchQ[4Meter, GreaterP[3Meter]],
		True
	],
	Example[{Basic, "Additionally specify an increment:"},
		MatchQ[4Meter, GreaterP[3Meter, Meter]],
		True
	],
	Example[{Basic, "Returns a pattern that matches any DateObject greater than the given DateObject:"},
		MatchQ[DateObject["July 2018"], GreaterP[DateObject["June 2018"]]],
		True
	],
	Example[{Basic, "Additionally specify an increment:"},
		MatchQ[DateObject["July 2018 1:00:00"], GreaterP[DateObject["June 2018"], 1 Hour]],
		True
	],
	Example[{Basic, "Additionally specify an increment:"},
		MatchQ[DateObject["July 2018 1:00:01"], GreaterP[DateObject["June 2018"], 1 Hour]],
		False
	],
	Example[{Additional, "Comparing distributions compares their means:"},
		MatchQ[NormalDistribution[6, 2], GreaterP[EmpiricalDistribution[{2, 3, 4}]]],
		True
	],
	Example[{Additional, "Distributions can be compared to reals and quantities as well:"},
		MatchQ[NormalDistribution[3Meter, 2Meter], GreaterP[3Inch]],
		True
	],
	Example[{Additional, "Also accepts numeric values:"},
		MatchQ[4, GreaterP[3]],
		True
	],
	Example[{Additional, "Specify an increment in numeric case:"},
		MatchQ[4, GreaterP[3, 1]],
		True
	],
	Example[{Additional, "Pattern does not match if given quantity is less than or equal to test quantity:"},
		MatchQ[2Meter, GreaterP[3Meter]],
		False
	],
	Example[{Additional, "Can handle different Units, provided they are compatibile:"},
		MatchQ[2Mile, GreaterP[3Meter]],
		True
	],
	Example[{Additional, "Pattern does not match if Units are incompatible:"},
		MatchQ[4Second, GreaterP[3Meter]],
		False
	],
	Example[{Additional, "Equality case does not match:"},
		MatchQ[123, GreaterP[123]],
		False
	],
	Example[{Additional, "Numeric values and quantities are incompatible:"},
		MatchQ[123, GreaterP[3Meter]],
		False
	],
	Example[{Additional, "Numeric values and quantities are incompatible:"},
		MatchQ[4Meter, GreaterP[3]],
		False
	],
	Example[{Additional, "Non-matching numeric case:"},
		MatchQ[2, GreaterP[3]],
		False
	],
	Example[{Additional, "Function does not evaluate on other inputs:"},
		GreaterP["string"],
		_GreaterP
	],
	Example[{Issues, "Due to machine precision rounding errors, values are rounded to within 10^-12 of the increment value when compared:"},
		MatchQ[1.50000000000000000001, GreaterP[1.2, .1]],
		True
	],
	Example[{Issues, "Any difference larger than that amount will trigger a failure:"},
		MatchQ[1.500000000001, GreaterP[1.2, .1]],
		False
	],

	Test["Does not match:",
		MatchQ[4Meter, GreaterP[3Meter, 0.3Meter]],
		False
	],
	Test["Does not match:",
		MatchQ[4, GreaterP[3, 0.3]],
		False
	],
	Test["Does not match:",
		MatchQ[4Meter, GreaterP[3Meter, 1]],
		False
	],
	Test["Machine precision rounding errors do not affect result:",
		MatchQ[1.5, GreaterP[1.1, .1]],
		True
	],
	Test["No message from nonsense units:",
		MatchQ["dog", GreaterP[Meter]],
		False
	],

	Test["Mixture of numeric and quantity passes as expected:",
		MatchQ[5, GreaterP[2 * Unit, 1 * Unit]],
		True
	],
	Test["Mixture of numeric and quantity fails as expected:",
		MatchQ[1, GreaterP[2 * Unit, 1 * Unit]],
		False
	],
	Test["Mixture of numeric and quantity again fails as expected:",
		MatchQ[1, GreaterP[2 * Unit, 2 * Unit]],
		False
	],
	Test["Mixture of quantity and numeric passes as expected:",
		MatchQ[5 * Unit, GreaterP[2, 1]],
		True
	],
	Test["Mixture of quantity and numeric again fails as expected:",
		MatchQ[1 * Unit, GreaterP[2, 2]],
		False
	],

	Test["Mixture of numeric and quantity passes as expected integer:",
		MatchQ[6, GreaterP[2 * Unit, 2 * Unit]],
		True
	],
	Test["Mixture of numeric and quantity fails as expected integer:",
		MatchQ[1, GreaterP[2 * Unit, 2 * Unit]],
		False
	],
	Test["Mixture of numeric and quantity again fails as expected integer:",
		MatchQ[5, GreaterP[2 * Unit, 2 * Unit]],
		False
	],
	Test["Mixture of quantity and numeric passes as expected integer:",
		MatchQ[6 * Unit, GreaterP[2, 2]],
		True
	],
	Test["Mixture of quantity and numeric fails as expected integer:",
		MatchQ[1 * Unit, GreaterP[2, 2]],
		False
	],
	Test["Mixture of quantity and numeric again fails as expected integer:",
		MatchQ[5 * Unit, GreaterP[2, 2]],
		False
	],

	Test["Mixture of numeric and quantity passes as expected numeric:",
		MatchQ[6, GreaterP[2 * Unit, 2. * Unit]],
		True
	],
	Test["Mixture of numeric and quantity fails as expected numeric:",
		MatchQ[1, GreaterP[2 * Unit, 2. * Unit]],
		False
	],
	Test["Mixture of numeric and quantity again fails as expected numeric:",
		MatchQ[5, GreaterP[2 * Unit, 2. * Unit]],
		False
	],
	Test["Mixture of quantity and numeric passes as expected numeric:",
		MatchQ[6 * Unit, GreaterP[2, 2.]],
		True
	],
	Test["Mixture of quantity and numeric fails as expected numeric:",
		MatchQ[1 * Unit, GreaterP[2, 2.]],
		False
	],
	Test["Mixture of quantity and numeric again fails as expected numeric:",
		MatchQ[5 * Unit, GreaterP[2, 2.]],
		False
	]

}];


(* ::Subsubsection::Closed:: *)
(*GreaterEqualP*)


DefineTests[GreaterEqualP, {
	Example[{Basic, "Returns a pattern that matches any quantity greater than or equal to test quantity:"},
		MatchQ[4Meter, GreaterEqualP[3Meter]],
		True
	],
	Example[{Basic, "Returns a pattern that matches any DateObject greater than the given DateObject:"},
		MatchQ[DateObject["June 2018"], GreaterEqualP[DateObject["June 2018"]]],
		True
	],
	Example[{Basic, "Returns a pattern that matches any DateObject greater than the given DateObject:"},
		MatchQ[DateObject["July 2018"], GreaterEqualP[DateObject["June 2018"]]],
		True
	],
	Example[{Basic, "Additionally specify an increment:"},
		MatchQ[DateObject["June 2018"], GreaterEqualP[DateObject["June 2018"], 1 Hour]],
		True
	],
	Example[{Additional, "Comparing distributions compares their means:"},
		MatchQ[NormalDistribution[6, 2], GreaterEqualP[EmpiricalDistribution[{2, 3, 4}]]],
		True
	],
	Example[{Additional, "Distributions can be compared to reals and quantities as well:"},
		MatchQ[NormalDistribution[3Meter, 2Meter], GreaterEqualP[3Inch]],
		True
	],
	Example[{Additional, "Additionaly specify an increment:"},
		MatchQ[4Meter, GreaterEqualP[3Meter, Meter]],
		True
	],
	Example[{Additional, "Specify an increment in numeric case:"},
		MatchQ[4, GreaterEqualP[3, 1]],
		True
	],
	Example[{Additional, "Also accepts numeric values:"},
		MatchQ[4, GreaterEqualP[3]],
		True
	],
	Example[{Additional, "Pattern does not match if given quantity is less than test quantity:"},
		MatchQ[2Meter, GreaterEqualP[3Meter]],
		False
	],
	Example[{Additional, "Can handle different Units, provided they are compatibile:"},
		MatchQ[2Mile, GreaterEqualP[3Meter]],
		True
	],
	Example[{Additional, "Pattern does not match if Units are incompatible:"},
		MatchQ[4Second, GreaterEqualP[3Meter]],
		False
	],
	Example[{Additional, "Equality case matches:"},
		MatchQ[123, GreaterEqualP[123]],
		True
	],
	Example[{Additional, "Numeric values and quantities are incompatible:"},
		MatchQ[123, GreaterEqualP[3Meter]],
		False
	],
	Example[{Additional, "Numeric values and quantities are incompatible:"},
		MatchQ[4Meter, GreaterEqualP[3]],
		False
	],
	Example[{Additional, "Non-matching numeric case:"},
		MatchQ[2, GreaterEqualP[3]],
		False
	],
	Example[{Additional, "Function does not evaluate on other inputs:"},
		GreaterEqualP["string"],
		_GreaterEqualP
	],
	Example[{Issues, "Due to machine precision rounding errors, values are rounded to within 10^-12 of the increment value when compared:"},
		MatchQ[1.50000000000000000001, GreaterEqualP[1.2, .1]],
		True
	],
	Example[{Issues, "Any difference larger than that amount will trigger a failure:"},
		MatchQ[1.500000000001, GreaterEqualP[1.2, .1]],
		False
	],

	Test["Does not match:",
		MatchQ[4Meter, GreaterEqualP[3Meter, 0.3Meter]],
		False
	],
	Test["Does not match:",
		MatchQ[4, GreaterEqualP[3, 0.3]],
		False
	],
	Test["Does not match:",
		MatchQ[4Meter, GreaterEqualP[3Meter, 1]],
		False
	],
	Test["Machine precision rounding errors do not affect result:",
		MatchQ[1.5, GreaterEqualP[1.1, .1]],
		True
	]
}];


(* ::Subsubsection::Closed:: *)
(*LessP*)


DefineTests[LessP, {
	Example[{Basic, "Returns a pattern that matches any quantity less than test quantity:"},
		MatchQ[2Meter, LessP[3Meter]],
		True
	],
	Example[{Basic, "Also accepts numeric values:"},
		MatchQ[2, LessP[3]],
		True
	],
	Example[{Basic, "Additionaly specify an increment:"},
		MatchQ[2Meter, LessP[3Meter, Meter]],
		True
	],
	Example[{Basic, "Returns a pattern that matches any DateObject greater than the given DateObject:"},
		MatchQ[DateObject["March 2018"], LessP[DateObject["June 2018"]]],
		True
	],
	Example[{Additional, "Comparing distributions compares their means:"},
		MatchQ[EmpiricalDistribution[{2, 3, 4}], LessP[NormalDistribution[6, 2]]],
		True
	],
	Example[{Additional, "Distributions can be compared to reals and quantities as well:"},
		MatchQ[3Inch, LessP[NormalDistribution[3Meter, 2Meter]]],
		True
	],
	Example[{Additional, "Specify an increment in numeric case:"},
		MatchQ[2, LessP[3, 1]],
		True
	],
	Example[{Additional, "Pattern does not match if given quantity is greater than or equal to test quantity:"},
		MatchQ[4Meter, LessP[3Meter]],
		False
	],
	Example[{Additional, "Can handle different Units, provided they are compatibile:"},
		MatchQ[5Inch, LessP[3Meter]],
		True
	],
	Example[{Additional, "Pattern does not match if Units are incompatible:"},
		MatchQ[2Second, LessP[3Meter]],
		False
	],
	Example[{Additional, "Equality case does not match:"},
		MatchQ[123, LessP[123]],
		False
	],
	Example[{Additional, "Numeric values and quantities are incompatible:"},
		MatchQ[123, LessP[3Meter]],
		False
	],
	Example[{Additional, "Numeric values and quantities are incompatible:"},
		MatchQ[4Meter, LessP[3]],
		False
	],
	Example[{Additional, "Non-matching numeric case:"},
		MatchQ[4, LessP[3]],
		False
	],
	Example[{Additional, "Function does not evaluate on other inputs:"},
		LessP["string"],
		_LessP
	],

	Example[{Issues, "Due to machine precision rounding errors, values are rounded to within 10^-12 of the increment value when compared:"},
		MatchQ[1.50000000000000000001, LessP[2.2, .1]],
		True
	],
	Example[{Issues, "Any difference larger than that amount will trigger a failure:"},
		MatchQ[1.500000000001, LessP[2.2, .1]],
		False
	],

	Test["Does not match:",
		MatchQ[2Meter, LessP[3Meter, 0.3Meter]],
		False
	],
	Test["Does not match:",
		MatchQ[2, LessP[3, 0.3]],
		False
	],
	Test["Does not match:",
		MatchQ[2Meter, LessP[3Meter, 1]],
		False
	],
	Test["Machine precision rounding errors do not affect result:",
		MatchQ[1.5, LessP[2.1, .1]],
		True
	]
}];


(* ::Subsubsection::Closed:: *)
(*LessEqualP*)


DefineTests[LessEqualP, {
	Example[{Basic, "Returns a pattern that matches any quantity less than or equal to test quantity:"},
		MatchQ[2Meter, LessEqualP[3Meter]],
		True
	],
	Example[{Basic, "Also accepts numeric values:"},
		MatchQ[2, LessEqualP[3]],
		True
	],
	Example[{Basic, "Additionaly specify an increment:"},
		MatchQ[2Meter, LessEqualP[3Meter, Meter]],
		True
	],
	Example[{Basic, "Returns a pattern that matches any DateObject greater than the given DateObject:"},
		MatchQ[DateObject["March 2018"], LessEqualP[DateObject["June 2018"]]],
		True
	],
	Example[{Additional, "Comparing distributions compares their means:"},
		MatchQ[EmpiricalDistribution[{2, 3, 4}], LessEqualP[NormalDistribution[6, 2]]],
		True
	],
	Example[{Additional, "Distributions can be compared to reals and quantities as well:"},
		MatchQ[3Inch, LessEqualP[NormalDistribution[3Meter, 2Meter]]],
		True
	],
	Example[{Additional, "Specify an increment in numeric case:"},
		MatchQ[2, LessEqualP[3, 1]],
		True
	],
	Example[{Additional, "Pattern does not match if given quantity is greater than test quantity:"},
		MatchQ[4Meter, LessEqualP[3Meter]],
		False
	],
	Example[{Additional, "Can handle different Units, provided they are compatibile:"},
		MatchQ[5Inch, LessEqualP[3Meter]],
		True
	],
	Example[{Additional, "Pattern does not match if Units are incompatible:"},
		MatchQ[2Second, LessEqualP[3Meter]],
		False
	],
	Example[{Additional, "Equality case matches:"},
		MatchQ[123, LessEqualP[123]],
		True
	],
	Example[{Additional, "Numeric values and quantities are incompatible:"},
		MatchQ[123, LessEqualP[3Meter]],
		False
	],
	Example[{Additional, "Numeric values and quantities are incompatible:"},
		MatchQ[4Meter, LessEqualP[3]],
		False
	],
	Example[{Additional, "Non-matching numeric case:"},
		MatchQ[4, LessEqualP[3]],
		False
	],
	Example[{Additional, "Function does not evaluate on other inputs:"},
		LessEqualP["string"],
		_LessEqualP
	],
	Example[{Issues, "Due to machine precision rounding errors, values are rounded to within 10^-12 of the increment value when compared:"},
		MatchQ[1.50000000000000000001, LessEqualP[2.2, .1]],
		True
	],
	Example[{Issues, "Any difference larger than that amount will trigger a failure:"},
		MatchQ[1.500000000001, LessEqualP[2.2, .1]],
		False
	],


	Test["Does not match:",
		MatchQ[2Meter, LessEqualP[3Meter, 0.3Meter]],
		False
	],
	Test["Does not match:",
		MatchQ[2, LessEqualP[3, 0.3]],
		False
	],
	Test["Does not match:",
		MatchQ[2Meter, LessEqualP[3Meter, 1]],
		False
	],
	Test["Machine precision rounding errors do not affect result:",
		MatchQ[1.5, LessEqualP[2.1, .1]],
		True
	]
}];


(* ::Subsubsection::Closed:: *)
(*EqualQ*)


DefineTests[EqualQ, {
	Example[{Basic, "Test if two values are equal:"},
		EqualQ[3, 3],
		True
	],
	Example[{Basic, "Units can be different:"},
		EqualQ[2Foot, 24Inch],
		True
	],
	Example[{Basic, "Compare dimensionless units with pure numbers:"},
		EqualQ[0.95, 95 Percent],
		True
	],
	Example[{Basic, "Returns False if values are not equal:"},
		EqualQ[2, 3],
		False
	],
	Example[{Basic, "Returns False if quantities are unequal:"},
		EqualQ[2Foot, 11Inch],
		False
	],
	Example[{Basic, "Check if a distribution's Mean is equal to a value:"},
		EqualQ[NormalDistribution[3, 2], 3],
		True
	]

}];



(* ::Subsubsection::Closed:: *)
(*GreaterQ*)


DefineTests[GreaterQ, {
	Example[{Basic, "Matches any quantity greater than given quantity:"},
		GreaterQ[4Meter, 3Meter],
		True
	],
	Example[{Basic, "Additionally specify an increment:"},
		GreaterQ[4Meter, 3Meter, Meter],
		True
	],
	Example[{Basic, "Matches any DateObject greater than the given DateObject:"},
		GreaterQ[DateObject["July 2018"], DateObject["June 2018"]],
		True
	],
	Example[{Basic, "Compare dimensionless units with pure numbers:"},
		GreaterQ[2 Dozen, 20],
		True
	],
	Test["Compare dimensionless units with pure numbers:",
		GreaterQ[20, 2 Dozen],
		False
	],
	Example[{Basic, "Additionally specify an increment:"},
		GreaterQ[DateObject["July 2018 1:00:00"], DateObject["June 2018"], 1 Hour],
		True
	],
	Example[{Basic, "Additionally specify an increment:"},
		GreaterQ[DateObject["July 2018 1:00:01"], DateObject["June 2018"], 1 Hour],
		False
	],
	Example[{Additional, "Comparing distributions compares their means:"},
		GreaterQ[NormalDistribution[6, 2], EmpiricalDistribution[{2, 3, 4}]],
		True
	],
	Example[{Additional, "Distributions can be compared to reals and quantities as well:"},
		GreaterQ[NormalDistribution[3Meter, 2Meter], 3Inch],
		True
	],
	Example[{Additional, "Also accepts numeric values:"},
		GreaterQ[4, 3],
		True
	],
	Example[{Additional, "Specify an increment in numeric case:"},
		GreaterQ[4, 3, 1],
		True
	],
	Example[{Additional, "Does not match if given quantity is less than or equal to test quantity:"},
		GreaterQ[2Meter, 3Meter],
		False
	],
	Example[{Additional, "Can handle different Units, provided they are compatibile:"},
		GreaterQ[2Mile, 3Meter],
		True
	],
	Example[{Additional, "Does not match if Units are incompatible:"},
		GreaterQ[4Second, 3Meter],
		False
	],
	Example[{Additional, "Equality case does not match:"},
		GreaterQ[123, 123],
		False
	],
	Example[{Additional, "Numeric values and quantities are incompatible:"},
		GreaterQ[123, 3Meter],
		False
	],
	Example[{Additional, "Numeric values and quantities are incompatible:"},
		GreaterQ[4Meter, 3],
		False
	],
	Example[{Additional, "Non-matching numeric case:"},
		GreaterQ[2, 3],
		False
	],
	Example[{Additional, "Function does not evaluate on other inputs:"},
		GreaterQ[3, "string"],
		_GreaterQ
	],
	Example[{Issues, "Due to machine precision rounding errors, values are rounded to within 10^-12 of the increment value when compared:"},
		GreaterQ[1.50000000000000000001, 1.2, .1],
		True
	],
	Example[{Issues, "Any difference larger than that amount will trigger a failure:"},
		GreaterQ[1.500000000001, 1.2, .1],
		False
	],

	Test["Distribution vs Distribution, True:",
		GreaterQ[NormalDistribution[3, 2], NormalDistribution[2, 1]],
		True
	],
	Test["Distribution vs Distribution, False:",
		GreaterQ[NormalDistribution[3, 2], NormalDistribution[5, 1]],
		False
	],
	Test["Distribution vs real, True:",
		GreaterQ[NormalDistribution[3, 2], 2],
		True
	],
	Test["Distribution vs Real, False:",
		GreaterQ[NormalDistribution[3, 2], 5],
		False
	],
	Test["Real vs Distribution, True:",
		GreaterQ[3, NormalDistribution[2, 1]],
		True
	],
	Test["Real vs Distribution, False:",
		GreaterQ[3, NormalDistribution[5, 1]],
		False
	],
	Test["QD vs QD, True:",
		GreaterQ[NormalDistribution[3Meter, 2Meter], NormalDistribution[2Meter, 1Meter]],
		True
	],
	Test["QD vs QD, False:",
		GreaterQ[NormalDistribution[3Meter, 2Meter], NormalDistribution[5Meter, 1Meter]],
		False
	],
	Test["QD vs Q, True:",
		GreaterQ[NormalDistribution[3Meter, 2Meter], 2Meter],
		True
	],
	Test["QD vs Q, False:",
		GreaterQ[NormalDistribution[3Meter, 2Meter], 5Meter],
		False
	],
	Test["Q vs QD, True:",
		GreaterQ[3Meter, NormalDistribution[2Meter, 1Meter]],
		True
	],
	Test["Q vs QD, False:",
		GreaterQ[3Meter, NormalDistribution[5Meter, 1Meter]],
		False
	],
	Test["QD unit mismatch:",
		GreaterQ[NormalDistribution[3Meter, 2Meter], 5Gram],
		False
	]

}];


(* ::Subsubsection::Closed:: *)
(*GreaterEqualQ*)


DefineTests[GreaterEqualQ, {
	Example[{Basic, "Matches any quantity greater than or equal to test quantity:"},
		GreaterEqualQ[4Meter, 3Meter],
		True
	],
	Example[{Basic, "Matches any DateObject greater than the given DateObject:"},
		GreaterEqualQ[DateObject["June 2018"], DateObject["June 2018"]],
		True
	],
	Example[{Basic, "Matches any DateObject greater than the given DateObject:"},
		GreaterEqualQ[DateObject["July 2018"], DateObject["June 2018"]],
		True
	],
	Example[{Basic, "Additionally specify an increment:"},
		GreaterEqualQ[DateObject["June 2018"], DateObject["June 2018"], 1 Hour],
		True
	],
	Example[{Additional, "Comparing distributions compares their means:"},
		GreaterEqualQ[NormalDistribution[6, 2], EmpiricalDistribution[{2, 3, 4}]],
		True
	],
	Example[{Additional, "Distributions can be compared to reals and quantities as well:"},
		GreaterEqualQ[NormalDistribution[3Meter, 2Meter], 3Inch],
		True
	],
	Example[{Additional, "Additionaly specify an increment:"},
		GreaterEqualQ[4Meter, 3Meter, Meter],
		True
	],
	Example[{Additional, "Specify an increment in numeric case:"},
		GreaterEqualQ[4, 3, 1],
		True
	],
	Example[{Additional, "Also accepts numeric values:"},
		GreaterEqualQ[4, 3],
		True
	],
	Example[{Additional, "Does not match if given quantity is less than test quantity:"},
		GreaterEqualQ[2Meter, 3Meter],
		False
	],
	Example[{Additional, "Can handle different Units, provided they are compatibile:"},
		GreaterEqualQ[2Mile, 3Meter],
		True
	],
	Example[{Additional, "Does not match if Units are incompatible:"},
		GreaterEqualQ[4Second, 3Meter],
		False
	],
	Example[{Additional, "Equality case matches:"},
		GreaterEqualQ[123, 123],
		True
	],
	Example[{Additional, "Numeric values and quantities are incompatible:"},
		GreaterEqualQ[123, 3Meter],
		False
	],
	Example[{Additional, "Numeric values and quantities are incompatible:"},
		GreaterEqualQ[4Meter, 3],
		False
	],
	Example[{Additional, "Non-matching numeric case:"},
		GreaterEqualQ[2, 3],
		False
	],
	Example[{Additional, "Function does not evaluate on other inputs:"},
		GreaterEqualQ[3, "string"],
		_GreaterEqualQ
	],
	Example[{Issues, "Due to machine precision rounding errors, values are rounded to within 10^-12 of the increment value when compared:"},
		GreaterEqualQ[1.50000000000000000001, 1.2, .1],
		True
	],
	Example[{Issues, "Any difference larger than that amount will trigger a failure:"},
		GreaterEqualQ[1.500000000001, 1.2, .1],
		False
	]
}];


(* ::Subsubsection::Closed:: *)
(*LessQ*)


DefineTests[LessQ, {
	Example[{Basic, "Matches any quantity less than test quantity:"},
		LessQ[2Meter, 3Meter],
		True
	],
	Example[{Basic, "Also accepts numeric values:"},
		LessQ[2, 3],
		True
	],
	Example[{Basic, "Additionaly specify an increment:"},
		LessQ[2Meter, 3Meter, Meter],
		True
	],
	Example[{Basic, "Matches any DateObject greater than the given DateObject:"},
		LessQ[DateObject["March 2018"], DateObject["June 2018"]],
		True
	],
	Example[{Basic, "Compare dimensionless units with pure numbers:"},
		LessQ[2 Dozen, 20],
		False
	],
	Test["Compare dimensionless units with pure numbers:",
		LessQ[20, 2 Dozen],
		True
	],
	Example[{Additional, "Comparing distributions compares their means:"},
		LessQ[EmpiricalDistribution[{2, 3, 4}], NormalDistribution[6, 2]],
		True
	],
	Example[{Additional, "Distributions can be compared to reals and quantities as well:"},
		LessQ[3Inch, NormalDistribution[3Meter, 2Meter]],
		True
	],
	Example[{Additional, "Specify an increment in numeric case:"},
		LessQ[2, 3, 1],
		True
	],
	Example[{Additional, "Does not match if given quantity is greater than or equal to test quantity:"},
		LessQ[4Meter, 3Meter],
		False
	],
	Example[{Additional, "Can handle different Units, provided they are compatibile:"},
		LessQ[5Inch, 3Meter],
		True
	],
	Example[{Additional, "Does not match if Units are incompatible:"},
		LessQ[25Second, 3Meter],
		False
	],
	Example[{Additional, "Equality case does not match:"},
		LessQ[123, 123],
		False
	],
	Example[{Additional, "Numeric values and quantities are incompatible:"},
		LessQ[123, 3Meter],
		False
	],
	Example[{Additional, "Numeric values and quantities are incompatible:"},
		LessQ[4Meter, 3],
		False
	],
	Example[{Additional, "Non-matching numeric case:"},
		LessQ[4, 3],
		False
	],
	Example[{Additional, "Function does not evaluate on other inputs:"},
		LessQ[3, "string"],
		_LessQ
	],
	Example[{Issues, "Due to machine precision rounding errors, values are rounded to within 10^-12 of the increment value when compared:"},
		LessQ[1.50000000000000000001, 2.2, .1],
		True
	],
	Example[{Issues, "Any difference larger than that amount will trigger a failure:"},
		LessQ[1.500000000001, 2.2, .1],
		False
	]
}];


(* ::Subsubsection::Closed:: *)
(*LessEqualQ*)


DefineTests[LessEqualQ, {
	Example[{Basic, "Matches any quantity less than or equal to test quantity:"},
		LessEqualQ[2Meter, 3Meter],
		True
	],
	Example[{Basic, "Also accepts numeric values:"},
		LessEqualQ[2, 3],
		True
	],
	Example[{Basic, "Additionaly specify an increment:"},
		LessEqualQ[2Meter, 3Meter, Meter],
		True
	],
	Example[{Basic, "Matches any DateObject greater than the given DateObject:"},
		LessEqualQ[DateObject["March 2018"], DateObject["June 2018"]],
		True
	],
	Example[{Additional, "Comparing distributions compares their means:"},
		LessEqualQ[EmpiricalDistribution[{2, 3, 4}], NormalDistribution[6, 2]],
		True
	],
	Example[{Additional, "Distributions can be compared to reals and quantities as well:"},
		LessEqualQ[3Inch, NormalDistribution[3Meter, 2Meter]],
		True
	],

	Example[{Additional, "Specify an increment in numeric case:"},
		LessEqualQ[2, 3, 1],
		True
	],
	Example[{Additional, "Does not match if given quantity is greater than test quantity:"},
		LessEqualQ[4Meter, 3Meter],
		False
	],
	Example[{Additional, "Can handle different Units, provided they are compatibile:"},
		LessEqualQ[5Inch, 3Meter],
		True
	],
	Example[{Additional, "Does not match if Units are incompatible:"},
		LessEqualQ[25Second, 3Meter],
		False
	],
	Example[{Additional, "Equality case matches:"},
		LessEqualQ[123, 123],
		True
	],
	Example[{Additional, "Numeric values and quantities are incompatible:"},
		LessEqualQ[123, 3Meter],
		False
	],
	Example[{Additional, "Numeric values and quantities are incompatible:"},
		LessEqualQ[4Meter, 3],
		False
	],
	Example[{Additional, "Non-matching numeric case:"},
		LessEqualQ[4, 3],
		False
	],
	Example[{Additional, "Function does not evaluate on other inputs:"},
		LessEqualQ[3, "string"],
		_LessEqualQ
	],
	Example[{Issues, "Due to machine precision rounding errors, values are rounded to within 10^-12 of the increment value when compared:"},
		LessEqualQ[1.50000000000000000001, 2.2, .1],
		True
	],
	Example[{Issues, "Any difference larger than that amount will trigger a failure:"},
		LessEqualQ[1.500000000001, 2.2, .1],
		False
	]
}];


(* ::Subsubsection::Closed:: *)
(*RangeP*)


DefineTests[RangeP, {
	Example[{Basic, "Returns a pattern that matches any quantity between the given lower and upper bounds:"},
		MatchQ[3Meter, RangeP[2Meter, 5Meter]],
		True
	],
	Example[{Basic, "Also accepts numeric values:"},
		MatchQ[3, RangeP[2, 5]],
		True
	],
	Example[{Basic, "Also accepts DateObjects:"},
		MatchQ[DateObject["August 10 2018"],
			GreaterP[DateObject["July 2018"]]],
		True
	],
	Example[{Basic, "Additionaly specify an increment:"},
		MatchQ[2Meter, RangeP[Meter, 3Meter, Meter]],
		True
	],
	Example[{Basic, "Match match any value that's a multiple of the increment:"},
		MatchQ[2000Meter, RangeP[10Meter]],
		True
	],
	Example[{Additional, "Specify an increment in numeric case:"},
		MatchQ[2, RangeP[1, 3, 1]],
		True
	],
	Example[{Additional, "Specify an increment in DateObject case:"},
		MatchQ[DateObject["August 10 2018"], RangeP[DateObject["July 2018"], DateObject["December 2018"], 1 Day]],
		True
	],
	Example[{Additional, "Specify an increment in DateObject case:"},
		MatchQ[DateObject["August 10 2018 1:00:00"], RangeP[DateObject["July 2018"], DateObject["December 2018"], 1 Day]],
		False
	],
	Example[{Additional, "Pattern does not match if given quantity is outside specified range:"},
		MatchQ[4Meter, RangeP[6Meter, 10Meter]],
		False
	],
	Example[{Additional, "Can handle different Units, provided they are compatibile:"},
		MatchQ[2Meter, RangeP[5Inch, 1Mile]],
		True
	],
	Example[{Additional, "Pattern does not match if Units are incompatible:"},
		MatchQ[2Second, RangeP[1Meter, 5Meter]],
		False
	],
	Example[{Additional, "Pattern does not match if Units are incompatible:"},
		MatchQ[2Meter, RangeP[1Second, 5Meter]],
		False
	],
	Example[{Additional, "Equality case matches:"},
		MatchQ[123, RangeP[123, 123]],
		True
	],
	Example[{Additional, "Numeric values and quantities are incompatible:"},
		MatchQ[123, RangeP[1Meter, 500Meter]],
		False
	],
	Example[{Additional, "Does not evaluate if range ends are incompatible:"},
		RangeP[2, 5Meter],
		_RangeP
	],
	Example[{Additional, "Numeric values and quantities are incompatible:"},
		MatchQ[4Meter, RangeP[1, 5]],
		False
	],
	Example[{Additional, "Non-matching numeric case:"},
		MatchQ[4, RangeP[5, 10]],
		False
	],
	Example[{Additional, "Infinite bounds match any compatible value:"},
		MatchQ[37000Meter, RangeP[-Infinity * Inch, Infinity * Kilometer]],
		True
	],
	Example[{Additional, "Infinite bounds don't match incompatible units:"},
		MatchQ[37000Second, RangeP[-Infinity * Inch, Infinity * Kilometer]],
		False
	],
	Example[{Additional, "Function does not evaluate on other inputs:"},
		RangeP["string", 24],
		_RangeP
	],
	Example[{Issues, "Due to machine precision rounding errors, values are rounded to within 10^-12 of the increment value when compared:"},
		MatchQ[1.50000000000000000001, RangeP[1, 2, .1]],
		True
	],
	Example[{Issues, "Any difference larger than that amount will trigger a failure:"},
		MatchQ[1.500000000001, RangeP[1, 2, .1]],
		False
	],
	Test["DateObject RangeP does not match:",
		MatchQ[DateObject["January 10 2018"], GreaterP[DateObject["July 2018"]]],
		False
	],
	Test["Does not match:",
		MatchQ[2Meter, RangeP[Meter, 3 Meter, 0.3Meter]],
		False
	],
	Test["Does not match:",
		MatchQ[2, RangeP[1, 3, 0.3]],
		False
	],
	Test["Does not match:",
		MatchQ[2Meter, RangeP[Meter, 3Meter, 1]],
		False
	],
	Example[{Options, Inclusive, "By default, both ends of the interval are inclusive comparisons:"},
		Map[MatchQ[#, RangeP[1, 2]]&, {1, 2}],
		{True, True}
	],
	Example[{Options, Inclusive, "Make only left edge of interval inclusive:"},
		Map[MatchQ[#, RangeP[1, 2, Inclusive -> Left]]&, {1, 2}],
		{True, False}
	],
	Example[{Options, Inclusive, "Make neither end of interval inclusive:"},
		Map[MatchQ[#, RangeP[1, 2, Inclusive -> None]]&, {1, 2}],
		{False, False}
	],
	Test["Machine precision rounding errors do not affect result:",
		MatchQ[1.1 Milliliter, RangeP[0.5 Milliliter, 2 Milliliter, 1 Microliter]],
		True
	],
	Test["Doesn't match increment:",
		MatchQ[2000.5Meter, RangeP[10Meter]],
		False
	],
	Test["If the minimum and maximum have the same units, then we short circuit without calling compatibleUnitQold, so stubbing it to False doesn't matter:",
		MatchQ[20 Celsius, RangeP[-10 Celsius, 25 Celsius]],
		True,
		Stubs :> {EmeraldUnits`Private`compatibleUnitQold[___]:=False}
	],
	Test["If the minimum and maximum have different units, then we can't short circuit without calling compatibleUnitQold (and so stubbing it to False makes the MatchQ fail):",
		MatchQ[20 Celsius, RangeP[-10 Celsius, 300 Kelvin Celsius]],
		False,
		Stubs :> {EmeraldUnits`Private`compatibleUnitQold[___]:=False}
	],
	Test["Increments work with mixed units:",
		MatchQ[5 Second, RangeP[1 Second, 3 Day, 1 Second]],
		True
	],
	Test["Increments cannot be 0 unit:",
		MatchQ[5 Second, RangeP[0 Second]],
		False,
		Messages :> Message[RangeP::InvalidIncrement]
	],
	Test["Error when Increment is 0",
		RangeP[0],
		Null,
		Messages :> Message[RangeP::InvalidIncrement]
	],
	Test["Error when Increment is 0 unit",
		RangeP[0 Meter],
		Null,
		Messages :> Message[RangeP::InvalidIncrement]
	]

}];


(* ::Subsubsection::Closed:: *)
(*RangeQ*)


DefineTests[
	RangeQ,
	{
		Example[{Basic, "Tests if a provide value is withing the given range after converting to a common unit:"},
			RangeQ[1Day, {Micro Second, Year}],
			True
		],
		Example[{Basic, "Can accept spans as well as lists of ranges:"},
			RangeQ[Day, Span[Micro Second, Year]],
			True
		],
		Example[{Basic, "Works with numeric input as well:"},
			RangeQ[10, Span[1, 100]],
			True
		],
		Example[{Additional, "If Null is provided as part of the range, no bounds are placed on that end of the range:"},
			RangeQ[Millennium, Span[Day, Null]],
			True
		],
		Example[{Additional, "If null is provided on both ends of the range, no restrictions are placed on the value:"},
			RangeQ[Year, Span[Null, Null]],
			True
		],
		Example[{Options, Inclusive, "The Inclusive option can be used to control inclusive or exclusive matching on the minimum and maximum values:"},
			{RangeQ[10, Span[1, 10], Inclusive -> True], RangeQ[10, Span[1, 10], Inclusive -> False]},
			{True, False}
		],
		Example[{Attributes, Listable, "The function is listable by values:"},
			RangeQ[{Second, Day, Month, Year}, Span[10 Day, 3 Month]],
			{False, False, True, False}
		],
		Example[{Attributes, Listable, "And by ranges:"},
			RangeQ[Hour, {Span[Second, Year], Span[Hour, Day], Span[Day, Month]}],
			{True, True, False}
		],
		Example[{Attributes, Listable, "If the number of ranges match the number of values, the lists are handled pairwise:"},
			RangeQ[{Day, Month, Year}, {Span[Second, Year], Span[Hour, Day], Span[Day, Month]}],
			{True, False, False}
		],
		Example[{Messages, "NotConvertable", "If unconvertable Units are proved, the NotConvertable message is thrown:"},
			RangeQ[Hour, Span[100Volt, 1000Volt]],
			Null,
			Messages :> Message[RangeQ::NotConvertable, Quantity[1, "Hours"], Quantity[100, "Volts"], Quantity[1000, "Volts"]]
		],


		(* ------------------------- QA Tests ------------------------- *)

		Example[{Additional, "One dimensional QuantityArray matching given range:"},
			RangeQ[QuantityArray[Range[10], Meter], 0Meter;;11Meter],
			True
		],
		Example[{Additional, "QuantityArray that does not match:"},
			RangeQ[QuantityArray[Range[10], Meter], 0Meter;;3Meter],
			False
		],
		Example[{Additional, "Range units can be different:"},
			RangeQ[QuantityArray[Range[10], Meter], 0Meter;;1Mile],
			True
		],
		Example[{Additional, "Range units must be compatible:"},
			RangeQ[QuantityArray[Range[10], Meter], 0Meter;;1Second],
			$Failed,
			Messages :> {Quantity::compat}
		],
		Example[{Additional, "QA units must be compatible with range units:"},
			RangeQ[QuantityArray[Range[10], Second], 0Meter;;11Meter],
			$Failed,
			Messages :> {Quantity::compat}
		],


		Example[{Additional, "Two dimensional QuantityArray matching given range:"},
			RangeQ[QuantityArray[Partition[Range[10], 2], {Second, Meter}], {0Second;;1Minute, 0Meter;;1Mile}],
			True
		],
		Example[{Additional, "Two dimensional QuantityArray that does not match the given range:"},
			RangeQ[QuantityArray[Partition[Range[10], 2], {Second, Meter}], {0Second;;1Second, 0Meter;;1Mile}],
			False
		],
		Example[{Messages, "IncompatibleDimensions", "QuantityArray dimensions must match dimensions of range specification:"},
			RangeQ[QuantityArray[Partition[Range[10], 2], {Second, Meter}], {0Second;;1Minute}],
			$Failed,
			Messages :> {RangeQ::IncompatibleDimensions}
		],
		Example[{Additional, "QA units must be compatible with range units:"},
			RangeQ[QuantityArray[Partition[Range[10], 2], {Second, Gram}], {0Second;;1Minute, 0Meter;;1Mile}],
			$Failed,
			Messages :> {Quantity::compat}
		]
	}

];


(* ::Subsubsection::Closed:: *)
(*AllGreater*)


DefineTests[AllGreaterEqual, {

	(* arbitrary sized things compared to scalar *)
	Example[{Basic, "Check if all values in a 2-D array are greater than zero:"},
		AllGreaterEqual[RandomInteger[{1, 9}, {5, 2}], 0],
		True
	],
	Example[{Additional, "Check if all values in a 2-D array are greater than ten:"},
		AllGreaterEqual[RandomInteger[{1, 9}, {5, 2}], 10],
		False
	],

	(* 2-D array compared to list *)
	Example[{Basic, "Check if elements of inner lists are greater than corresponding elements in comparison list:"},
		AllGreaterEqual[RandomInteger[{2, 9}, {3, 2}], {0, 1}],
		True
	],

	(*  4-D array compared to list *)
	Example[{Basic, "Check if elements of bottom level lists in array are greater than corresponding elements in comparison list:"},
		AllGreaterEqual[RandomInteger[{2, 9}, {3, 4, 3, 2}], {1, 0}],
		True
	],


	Example[{Basic, "Check if every element in a QuantityArray is greater than 0 Meters:"},
		AllGreaterEqual[QuantityArray[RandomInteger[{1, 9}, {5, 2}], Meter], 0 * Meter],
		True
	],

	(* 2-D array compared to list *)
	Example[{Basic, "Check if the elements of every list in a QuantityArray are greater than the corresponding values in the comparision list:"},
		AllGreaterEqual[QuantityArray[RandomInteger[{2, 9}, {3, 2}], {Second, Meter}], {1 * Second, 0 * Meter}],
		True
	],

	(* unit conversions *)
	Example[{Additional, "Units can be different, as long as compatible:"},
		AllGreaterEqual[QuantityArray[RandomInteger[{1, 9}, {3, 2}], {Second, Meter}], {10Microsecond, 6Inch}],
		True
	],
	Example[{Additional, "Array units must be compatible with comparison units:"},
		AllGreaterEqual[QuantityArray[RandomInteger[{1, 9}, {3, 2}], {Second, Meter}], {0 * Second, 0 * Gram}],
		False
	]


}];



(* ::Subsubsection::Closed:: *)
(*AllGreater*)


DefineTests[AllGreater, {

	(* arbitrary sized things compared to scalar *)
	Example[{Basic, "Check if all values in a 2-D array are greater than zero:"},
		AllGreater[RandomInteger[{1, 9}, {5, 2}], 0],
		True
	],
	Example[{Additional, "Check if all values in a 2-D array are greater than ten:"},
		AllGreater[RandomInteger[{1, 9}, {5, 2}], 10],
		False
	],

	(* 2-D array compared to list *)
	Example[{Basic, "Check if elements of inner lists are greater than corresponding elements in comparison list:"},
		AllGreater[RandomInteger[{2, 9}, {3, 2}], {0, 1}],
		True
	],
	Test["Test 4:",
		AllGreater[RandomInteger[{1, 9}, {3, 2}], {0, 10}],
		False
	],
	Test["Test 5:",
		AllGreater[RandomInteger[{1, 9}, {3, 2}], {10, 0}],
		False
	],
	Test["Test 6:",
		AllGreater[RandomInteger[{1, 9}, {3, 2}], {10, 10}],
		False
	],
	Test["Test 7:",
		AllGreater[RandomInteger[{1, 9}, {3, 2}], {0, 0, 0}],
		False
	],

	(*  4-D array compared to list *)
	Example[{Basic, "Check if elements of bottom level lists in array are greater than corresponding elements in comparison list:"},
		AllGreater[RandomInteger[{2, 9}, {3, 4, 3, 2}], {1, 0}],
		True
	],
	Test["Test 9:",
		AllGreater[RandomInteger[{1, 9}, {3, 4, 2, 2}], {0, 10}],
		False
	],
	Test["Test 10:",
		AllGreater[RandomInteger[{1, 9}, {3, 4, 3, 2}], {10, 0}],
		False
	],
	Test["Test 11:",
		AllGreater[RandomInteger[{1, 9}, {3, 4, 2, 2}], {10, 10}],
		False
	],
	Test["Test 12:",
		AllGreater[RandomInteger[{1, 9}, {3, 4, 2, 2}], {0, 0, 0}],
		False
	],

	Example[{Basic, "Check if every element in a QuantityArray is greater than 0 Meters:"},
		AllGreater[QuantityArray[RandomInteger[{1, 9}, {5, 2}], Meter], 0 * Meter],
		True
	],
	Test["Test 14:",
		AllGreater[QuantityArray[RandomInteger[{1, 9}, {5, 2}], Meter], 10 * Meter],
		False
	],

	(* 2-D array compared to list *)
	Example[{Basic, "Check if the elements of every list in a QuantityArray are greater than the corresponding values in the comparision list:"},
		AllGreater[QuantityArray[RandomInteger[{2, 9}, {3, 2}], {Second, Meter}], {1 * Second, 0 * Meter}],
		True
	],
	Test["Test 16:",
		AllGreater[QuantityArray[RandomInteger[{1, 9}, {3, 2}], {Second, Meter}], {0 * Second, 10 * Meter}],
		False
	],
	Test["Test 17:",
		AllGreater[QuantityArray[RandomInteger[{1, 9}, {3, 2}], {Second, Meter}], {10 * Second, 0 * Meter}],
		False
	],
	Test["Test 18:",
		AllGreater[QuantityArray[RandomInteger[{1, 9}, {3, 2}], {Second, Meter}], {10 * Second, 10 * Meter}],
		False
	],
	Test["Test 19:",
		AllGreater[QuantityArray[RandomInteger[{1, 9}, {3, 2}], {Second, Meter}], {0 * Second, 0 * Meter, 0 * Gram}],
		False
	],

	(*  4-D array compared to list *)
	Test["Test 20:",
		AllGreater[QuantityArray[RandomInteger[{1, 9}, {3, 4, 3, 2}], {Second, Meter}], {0 * Second, 0 * Meter}],
		True
	],
	Test["Test 21:",
		AllGreater[QuantityArray[RandomInteger[{1, 9}, {3, 4, 3, 2}], {Second, Meter}], {0 * Second, 10 * Meter}],
		False
	],
	Test["Test 22:",
		AllGreater[QuantityArray[RandomInteger[{1, 9}, {3, 4, 3, 2}], {Second, Meter}], {10 * Second, 0 * Meter}],
		False
	],
	Test["Test 23:",
		AllGreater[QuantityArray[RandomInteger[{1, 9}, {3, 4, 3, 2}], {Second, Meter}], {10 * Second, 10 * Meter}],
		False
	],
	Test["Test 24:",
		AllGreater[QuantityArray[RandomInteger[{1, 9}, {3, 4, 3, 2}], {Second, Meter}], {0 * Second, 0 * Meter, 0 * Gram}],
		False
	],

	(* unit conversions *)
	Example[{Additional, "Units can be different, as long as compatible:"},
		AllGreater[QuantityArray[RandomInteger[{1, 9}, {3, 2}], {Second, Meter}], {10Microsecond, 6Inch}],
		True
	],
	Test["Units can be different, as long as compatible, false:",
		AllGreater[QuantityArray[RandomInteger[{1, 9}, {3, 2}], {Second, Meter}], {10Minute, 6Yard}],
		False
	],
	Example[{Additional, "Array units must be compatible with comparison units:"},
		AllGreater[QuantityArray[RandomInteger[{1, 9}, {3, 2}], {Second, Meter}], {0 * Second, 0 * Gram}],
		False
	]


}];


(* ::Subsubsection::Closed:: *)
(*AllLessEqual*)


DefineTests[AllLessEqual, {

	(* arbitrary sized things compared to scalar *)
	Example[{Basic, "Check if all values in a 2-D array are less than ten:"},
		AllLessEqual[RandomInteger[{1, 9}, {5, 2}], 10],
		True
	],
	Example[{Additional, "Check if all values in a 2-D array are less than zero:"},
		AllLessEqual[RandomInteger[{1, 9}, {5, 2}], 0],
		False
	],

	Example[{Basic, "Check if every element in a QuantityArray is less than 10 Meters:"},
		AllLessEqual[QuantityArray[RandomInteger[{1, 9}, {5, 2}], Meter], 10 * Meter],
		True
	],

	(* 2-D array compared to list *)
	Example[{Basic, "Check if the elements of every list in a QuantityArray are less than the corresponding values in the comparision list:"},
		AllLessEqual[QuantityArray[RandomInteger[{2, 9}, {3, 2}], {Second, Meter}], {10 * Second, 10 * Meter}],
		True
	],

	(* unit conversions *)
	Example[{Additional, "Units can be different, as long as compatible:"},
		AllLessEqual[QuantityArray[RandomInteger[{1, 9}, {3, 2}], {Second, Meter}], {1 Hour, 50 Foot}],
		True
	],
	Example[{Additional, "Array units must be compatible with comparison units:"},
		AllLessEqual[QuantityArray[RandomInteger[{1, 9}, {3, 2}], {Second, Meter}], {10 * Second, 6 * Gram}],
		False
	]


}];

DefineTests[AllLess, {

	(* arbitrary sized things compared to scalar *)
	Example[{Basic, "Check if all values in a 2-D array are less than ten:"},
		AllLess[RandomInteger[{1, 9}, {5, 2}], 10],
		True
	],
	Example[{Additional, "Check if all values in a 2-D array are less than zero:"},
		AllLess[RandomInteger[{1, 9}, {5, 2}], 0],
		False
	],

	Example[{Basic, "Check if every element in a QuantityArray is less than 10 Meters:"},
		AllLess[QuantityArray[RandomInteger[{1, 9}, {5, 2}], Meter], 10 * Meter],
		True
	],

	(* 2-D array compared to list *)
	Example[{Basic, "Check if the elements of every list in a QuantityArray are less than the corresponding values in the comparision list:"},
		AllLess[QuantityArray[RandomInteger[{2, 9}, {3, 2}], {Second, Meter}], {10 * Second, 10 * Meter}],
		True
	],

	(* unit conversions *)
	Example[{Additional, "Units can be different, as long as compatible:"},
		AllLess[QuantityArray[RandomInteger[{1, 9}, {3, 2}], {Second, Meter}], {1 Hour, 50 Foot}],
		True
	],
	Example[{Additional, "Array units must be compatible with comparison units:"},
		AllLess[QuantityArray[RandomInteger[{1, 9}, {3, 2}], {Second, Meter}], {10 * Second, 6 * Gram}],
		False
	]


}];


(* ::Subsection::Closed:: *)
(*Distributions*)


(* ::Subsubsection::Closed:: *)
(*DistributionQ*)


DefineTests[DistributionQ, {
	Example[{Basic, "Match a distribution:"},
		DistributionQ[NormalDistribution[3, 2]],
		True
	],
	Example[{Basic, "Match a quantity distribution:"},
		DistributionQ[QuantityDistribution[ExponentialDistribution[3], "Meters"]],
		True
	],
	Example[{Basic, "Match a quantity distribution with distance units:"},
		DistributionQ[QuantityDistribution[ExponentialDistribution[3], "Meters"], Kilometer],
		True
	],
	Example[{Additional, "Not a distribution:"},
		DistributionQ[{1, 2, 3}],
		False
	],
	Example[{Basic, "Unit spec much match units in distribution:"},
		DistributionQ[QuantityDistribution[ExponentialDistribution[3], "Meters"], Second],
		False
	],
	Example[{Basic, "Match a valid data distribution:"},
		DistributionQ[EmpiricalDistribution[{1, 2, 3}]],
		True
	],
	Example[{Additional, "Match empirical data distribution with units:"},
		DistributionQ[EmpiricalDistribution[QuantityArray[{1, 2, 3}, "Meters"]]],
		True
	],


	Example[{Additional, "Match a multi-dimensional quantity distribution:"},
		DistributionQ[QuantityDistribution[ MultinormalDistribution[{-1, 1}, {{5, 1}, {1, 3}}], {"Grams", "Hours"}]],
		True
	],
	Example[{Additional, "Match a multi-dimensional quantity distribution and unit spec:"},
		DistributionQ[QuantityDistribution[ MultinormalDistribution[{-1, 1}, {{5, 1}, {1, 3}}], {"Grams", "Hours"}], {Milligram, Second}],
		True
	],
	Example[{Additional, "Match empirical data distribution with specific units:"},
		DistributionQ[EmpiricalDistribution[QuantityArray[{1, 2, 3}, "Meters"]], "Inches"],
		True
	],
	Example[{Additional, "Does not match empirical data distribution with wrong units:"},
		DistributionQ[EmpiricalDistribution[QuantityArray[{1, 2, 3}, "Meters"]], "Seconds"],
		False
	],
	Example[{Additional, "Does not match a quantity:"},
		DistributionQ[Quantity[3, "Meters"]],
		False
	],
	Example[{Additional, "Does not match a quantity array:"},
		DistributionQ[QuantityArray[{3, 4, 5}, "Meters"]],
		False
	],
	Example[{Additional, "Does not match if units don't match unit spec:"},
		DistributionQ[QuantityDistribution[NormalDistribution[3, 2], "Inches"], Second],
		False
	],
	Example[{Additional, "Match a multi-dimensional quantity distribution and unit spec:"},
		DistributionQ[QuantityDistribution[ MultinormalDistribution[{-1, 1}, {{5, 1}, {1, 3}}], {"Grams", "Hours"}], {Year, Volt}],
		False
	],

	Test["Given compound unit expression:",
		DistributionQ[QuantityDistribution[NormalDistribution[3, 2], Meter / Second], Meter / Second],
		True
	],
	Test["Given compound unit expression:",
		DistributionQ[EmpiricalDistribution[{1, 2, 3} * Meter / Second], Meter / Second],
		True
	],
	Test["Given string unit spec:",
		DistributionQ[QuantityDistribution[NormalDistribution[3, 2], Meter / Second], "Meters" / "Seconds"],
		True
	]



}];


(* ::Subsubsection::Closed:: *)
(*DistributionP*)


DefineTests[DistributionP, {
	Example[{Basic, "Match a distribution:"},
		MatchQ[NormalDistribution[3, 2], DistributionP[]],
		True
	],
	Example[{Basic, "Match a quantity distribution:"},
		MatchQ[QuantityDistribution[ExponentialDistribution[3], "Meters"], DistributionP[]],
		True
	],
	Example[{Basic, "Match a quantity distribution with distance units:"},
		MatchQ[QuantityDistribution[ExponentialDistribution[3], "Meters"], DistributionP[Kilometer]],
		True
	],
	Example[{Basic, "Not a distribution:"},
		MatchQ[{1, 2, 3}, DistributionP[]],
		False
	],
	Example[{Basic, "Unit spec much match units in distribution:"},
		MatchQ[QuantityDistribution[ExponentialDistribution[3], "Meters"], DistributionP[Second]],
		False
	]


}];


(* ::Subsubsection::Closed:: *)
(*QuantityDistributionQ*)


DefineTests[QuantityDistributionQ, {
	Example[{Basic, "Match a valid quantity distribution:"},
		QuantityDistributionQ[QuantityDistribution[NormalDistribution[3, 2], "Meters"]],
		True
	],
	Example[{Basic, "Match a valid quantity with distance units:"},
		QuantityDistributionQ[QuantityDistribution[NormalDistribution[3, 2], "Inches"], Meter],
		True
	],
	Example[{Basic, "Match a multi-dimensional quantity distribution:"},
		QuantityDistributionQ[QuantityDistribution[ MultinormalDistribution[{-1, 1}, {{5, 1}, {1, 3}}], {"Grams", "Hours"}]],
		True
	],
	Example[{Basic, "Match a multi-dimensional quantity distribution and unit spec:"},
		QuantityDistributionQ[QuantityDistribution[ MultinormalDistribution[{-1, 1}, {{5, 1}, {1, 3}}], {"Grams", "Hours"}], {Milligram, Second}],
		True
	],
	Example[{Basic, "Does not match empirical data distribution with units:"},
		QuantityDistributionQ[EmpiricalDistribution[QuantityArray[{1, 2, 3}, "Meters"]]],
		False
	],


	Example[{Additional, "Does not match empirical data distribution with specific units:"},
		QuantityDistributionQ[EmpiricalDistribution[QuantityArray[{1, 2, 3}, "Meters"]], "Inches"],
		False
	],
	Example[{Additional, "Does not match a quantity:"},
		QuantityDistributionQ[Quantity[3, "Meters"]],
		False
	],
	Example[{Additional, "Does not match a quantity array:"},
		QuantityDistributionQ[QuantityArray[{3, 4, 5}, "Meters"]],
		False
	],
	Example[{Additional, "Does not match if units don't match unit spec:"},
		QuantityDistributionQ[QuantityDistribution[NormalDistribution[3, 2], "Inches"], Second],
		False
	],
	Example[{Additional, "Match a multi-dimensional quantity distribution and unit spec:"},
		QuantityDistributionQ[QuantityDistribution[ MultinormalDistribution[{-1, 1}, {{5, 1}, {1, 3}}], {"Grams", "Hours"}], {Year, Volt}],
		False
	]

}];



(* ::Subsubsection::Closed:: *)
(*QuantityDistributionP*)


DefineTests[QuantityDistributionP, {
	Example[{Basic, "Match a valid quantity distribution:"},
		MatchQ[QuantityDistribution[NormalDistribution[3, 2], "Meters"], QuantityDistributionP[]],
		True
	],
	Example[{Basic, "Match a valid quantity with distance units:"},
		MatchQ[QuantityDistribution[NormalDistribution[3, 2], "Inches"], QuantityDistributionP[Meter]],
		True
	],
	Example[{Basic, "Match a multi-dimensional quantity distribution:"},
		MatchQ[QuantityDistribution[ MultinormalDistribution[{-1, 1}, {{5, 1}, {1, 3}}], {"Grams", "Hours"}], QuantityDistributionP[]],
		True
	],
	Example[{Basic, "Match a multi-dimensional quantity distribution and unit spec:"},
		MatchQ[QuantityDistribution[ MultinormalDistribution[{-1, 1}, {{5, 1}, {1, 3}}], {"Grams", "Hours"}], QuantityDistributionP[{Milligram, Second}]],
		True
	],
	Example[{Basic, "Does not match a quantity:"},
		MatchQ[Quantity[3, "Meters"], QuantityDistributionP[]],
		False
	],
	Example[{Additional, "Does not match a quantity array:"},
		MatchQ[QuantityArray[{3, 4, 5}, "Meters"], QuantityDistributionP[]],
		False
	],
	Example[{Additional, "Does not match if units don't match unit spec:"},
		MatchQ[QuantityDistribution[NormalDistribution[3, 2], "Inches"], QuantityDistributionP[Second]],
		False
	],
	Example[{Additional, "Match a multi-dimensional quantity distribution and unit spec:"},
		MatchQ[QuantityDistribution[ MultinormalDistribution[{-1, 1}, {{5, 1}, {1, 3}}], {"Grams", "Hours"}], QuantityDistributionP[{Second, Volt}]],
		False
	]

}];



(* ::Subsubsection::Closed:: *)
(*EmpiricalDistributionQ*)


DefineTests[EmpiricalDistributionQ, {
	Example[{Basic, "Match a valid empirical distribution:"},
		EmpiricalDistributionQ[EmpiricalDistribution[{1, 2, 3}]],
		True
	],
	Example[{Basic, "Match empirical data distribution with specific units:"},
		EmpiricalDistributionQ[EmpiricalDistribution[QuantityArray[{1, 2, 3}, "Meters"]], "Inches"],
		True
	],
	Example[{Basic, "Match quantity distribution with specific units:"},
		EmpiricalDistributionQ[QuantityDistribution[EmpiricalDistribution[{1, 2, 3}], "Meters"], "Miles"],
		True
	],
	Example[{Basic, "Does not match empirical data distribution with wrong units:"},
		EmpiricalDistributionQ[EmpiricalDistribution[QuantityArray[{1, 2, 3}, "Meters"]], "Seconds"],
		False
	],
	Example[{Basic, "Does not match a parametric distribution:"},
		EmpiricalDistributionQ[NormalDistribution[3, 2]],
		False
	],

	Example[{Additional, "Match a multivariate data distribution with units:"},
		EmpiricalDistributionQ[EmpiricalDistribution[QuantityArray[{{1, 1}, {2, 3}, {3, 5}}, {"Seconds", "Meters"}]], {"Minutes", "Centimeters"}],
		True
	],
	Example[{Additional, "Match empirical data distribution with units:"},
		EmpiricalDistributionQ[EmpiricalDistribution[QuantityArray[{1, 2, 3}, "Meters"]]],
		True
	],
	Example[{Additional, "Does not match a quantity distribution around a normal distribution:"},
		EmpiricalDistributionQ[QuantityDistribution[NormalDistribution[3, 2], "Meters"]],
		False
	],
	Example[{Additional, "Does not match a multivariate data distribution with incompatible units:"},
		EmpiricalDistributionQ[EmpiricalDistribution[QuantityArray[{{1, 1}, {2, 3}, {3, 5}}, {"Seconds", "Meters"}]], {"Grams", "Centimeters"}],
		False
	]


}];



(* ::Subsubsection::Closed:: *)
(*EmpiricalDistributionP*)


DefineTests[EmpiricalDistributionP, {
	Example[{Basic, "Match a valid empirical distribution:"},
		MatchQ[EmpiricalDistribution[{1, 2, 3}], EmpiricalDistributionP[]],
		True
	],
	Example[{Basic, "Match empirical data distribution with specific units:"},
		MatchQ[EmpiricalDistribution[QuantityArray[{1, 2, 3}, "Meters"]], EmpiricalDistributionP["Inches"]],
		True
	],
	Example[{Basic, "Match quantity distribution with specific units:"},
		MatchQ[QuantityDistribution[EmpiricalDistribution[{1, 2, 3}], "Meters"], EmpiricalDistributionP["Miles"]],
		True
	],
	Example[{Basic, "Does not match empirical data distribution with wrong units:"},
		MatchQ[EmpiricalDistribution[QuantityArray[{1, 2, 3}, "Meters"]], EmpiricalDistributionP["Seconds"]],
		False
	],
	Example[{Basic, "Does not match a parametric distribution:"},
		MatchQ[NormalDistribution[3, 2], EmpiricalDistributionP[]],
		False
	],

	Example[{Additional, "Match a multivariate data distribution with units:"},
		MatchQ[EmpiricalDistribution[QuantityArray[{{1, 1}, {2, 3}, {3, 5}}, {"Seconds", "Meters"}]], EmpiricalDistributionP[{"Minutes", "Centimeters"}]],
		True
	],
	Example[{Additional, "Match empirical data distribution with units:"},
		MatchQ[EmpiricalDistribution[QuantityArray[{1, 2, 3}, "Meters"]], EmpiricalDistributionP[]],
		True
	],
	Example[{Additional, "Does not match a quantity distribution around a normal distribution:"},
		MatchQ[QuantityDistribution[NormalDistribution[3, 2], "Meters"], EmpiricalDistributionP[]],
		False
	],
	Example[{Additional, "Does not match a multivariate data distribution with incompatible units:"},
		MatchQ[EmpiricalDistribution[QuantityArray[{{1, 1}, {2, 3}, {3, 5}}, {"Seconds", "Meters"}]], EmpiricalDistributionP[{"Grams", "Centimeters"}]],
		False
	]
}];



(* ::Subsubsection::Closed:: *)
(*EmpiricalDistributionPoints*)


DefineTests[EmpiricalDistributionPoints, {

	Example[{Basic, "Extract the data from an empirical distribution:"},
		EmpiricalDistributionPoints[EmpiricalDistribution[{1, 2, 3, 3}]],
		{1, 2, 3, 3}
	],
	Example[{Basic, "If the distribution has units, the points come out as a QuantityArray:"},
		EmpiricalDistributionPoints[EmpiricalDistribution[{3.5, 3.5, 4, 4.2, 5} * Meter]],
		QuantityArray[Sort@{3.5, 3.5, 4, 4.2, 5}, "Meters"]
	],
	Example[{Basic, "Given a multivariate data distribution:"},
		EmpiricalDistributionPoints[EmpiricalDistribution[{{0, 4, 10}, {4, 5, 3}, {7, 2, 7}, {3, 3, 3}, {7, 2, 7}}]],
		{{0, 4, 10}, {4, 5, 3}, {7, 2, 7}, {7, 2, 7}, {3, 3, 3}}
	],

	Example[{Options, MaximumDistributionPoints, "Set the maximum number of points to return:"},
		EmpiricalDistributionPoints[
			DataDistribution["Empirical", {{.55, .25, .0000000012369}, {1, 2, 3}, False}, 1, 4, "Meters"],
			MaximumDistributionPoints -> 10
		],
		x:QuantityArrayP[]/;Length[x] == 10
	],

	Example[{Additional, "Note that the points come out sorted:"},
		EmpiricalDistributionPoints[EmpiricalDistribution[{5, 4, 3, 2, 2, 1}]],
		Sort@{5, 4, 3, 2, 2, 1}
	],
	Example[{Additional, "Empirical distributions can contain non-numeric values:"},
		EmpiricalDistributionPoints[EmpiricalDistribution[{"a", "c", "c", "b"}]],
		{"a", "b", "c", "c"}
	],
	Example[{Additional, "Given a QuantityDistribution:"},
		EmpiricalDistributionPoints[QuantityDistribution[EmpiricalDistribution[{9, 8, 7, 7, 5, 5, 5, 2}], Gram]],
		QuantityArray[Sort@{9, 8, 7, 7, 5, 5, 5, 2}, Gram]
	],
	Example[{Issues, "Some operations affect data distributions in a way that makes it impossible to recover the original point set:"},
		EmpiricalDistributionPoints[UnitConvert[UnitConvert[EmpiricalDistribution[Quantity[{5, 5, 5}, Meter]], "Centimeters"], "Meters"]],
		QuantityArray[{5}, "Meters"]
	],
	Example[{Issues, "Information may be lost if the magnitude of weights differs by several orders of magnitude:"},
		DeleteDuplicates@EmpiricalDistributionPoints[
			DataDistribution["Empirical", {{0.1, 0.00001, 0.000000001}, {1, 2, 3}, False}, 1, 10],
			MaximumDistributionPoints -> 1000000
		],
		{1, 2}
	],

	(* Issues: points cannot be returned if big probability differences exist *)

	Test["Handle distribution with non-rational weights:",
		EmpiricalDistributionPoints[DataDistribution["Empirical", {{.25, .25, .5}, {1, 2, 3}, False}, 1, 4, "Meters"]],
		QuantityArray[{1, 2, 3, 3}, "Meters"]
	]



}];


(* ::Subsubsection::Closed:: *)
(*EmpiricalDistributionJoin*)


DefineTests[EmpiricalDistributionJoin, {

	Example[{Basic, "Join together 3 empirical distributions:"},
		EmpiricalDistributionJoin[EmpiricalDistribution[{1, 2, 3, 3}], EmpiricalDistribution[{3, 4, 4, 5}], EmpiricalDistribution[{5, 6}]],
		DataDistribution["Empirical", {{1 / 10, 1 / 10, 3 / 10, 1 / 5, 1 / 5, 1 / 10}, {1, 2, 3, 4, 5, 6}, False}, 1, 10]
	],
	Example[{Basic, "The resulting empirical distribution contains all the points from the individual distributions being joined:"},
		EmpiricalDistributionPoints[EmpiricalDistributionJoin[EmpiricalDistribution[{1, 2, 3, 3}], EmpiricalDistribution[{3, 4, 4, 5}], EmpiricalDistribution[{5, 6}]]],
		{1, 2, 3, 3, 3, 4, 4, 5, 5, 6}
	],
	Example[{Basic, "Join together 3 empirical distributions with units:"},
		EmpiricalDistributionJoin[EmpiricalDistribution[{1, 2, 3, 3} * Meter], EmpiricalDistribution[{3, 4, 4, 5} * Foot], EmpiricalDistribution[{5, 6} * Centimeter]],
		DataDistribution["Empirical", {{1 / 10, 1 / 10, 1 / 10, 1 / 10, 1 / 5, 1 / 10, 1 / 10, 1 / 5}, {1 / 20, 3 / 50, 1143 / 1250, 1, 762 / 625, 381 / 250, 2, 3}, False}, 1, 10, "Meters"]
	],

	Example[{Basic, "Join together 3 quantity distribution empirical distributions:"},
		EmpiricalDistributionJoin[QuantityDistribution[EmpiricalDistribution[{1, 2, 3, 3}], Meter], QuantityDistribution[EmpiricalDistribution[{3, 4, 4, 5}], Foot], QuantityDistribution[EmpiricalDistribution[{5, 6}], Centimeter]],
		DataDistribution["Empirical", {{1 / 10, 1 / 10, 1 / 10, 1 / 10, 1 / 5, 1 / 10, 1 / 10, 1 / 5}, {1 / 20, 3 / 50, 1143 / 1250, 1, 762 / 625, 381 / 250, 2, 3}, False}, 1, 10, "Meters"]
	],
	Example[{Basic, "Resulting distribution is the same you would get if you joined the raw point sets together:"},
		SameQ[
			EmpiricalDistributionJoin[EmpiricalDistribution[{1, 2, 3, 3} * Meter], EmpiricalDistribution[{3, 4, 4, 5} * Foot], EmpiricalDistribution[{5, 6} * Centimeter]],
			Convert[EmpiricalDistribution[Join[{1, 2, 3, 3} * Meter, {3, 4, 4, 5} * Foot, {5, 6} * Centimeter]], Meter]
		],
		True
	],
	Test["Handle distribution with non-rational weights:",
		EmpiricalDistributionJoin[DataDistribution["Empirical", {{.25, .25, .5}, {1, 2, 3}, False}, 1, 4, "Meters"]],
		DataDistribution["Empirical", {{1 / 4, 1 / 4, 1 / 2}, {1, 2, 3}, False}, 1, 4, "Meters"]
	]



}];




(* ::Subsection::Closed:: *)
(*Unit Conversions*)


(* ::Subsubsection::Closed:: *)
(*Convert*)


DefineTests[
	Convert,
	{
		Example[{Basic, "The function is used to Convert quantities between Units:"},
			Convert[2 Minute, Second],
			120 Second
		],
		Example[{Basic, "Conversions can be done between Units on raw numbers:"},
			Convert[10, Minute, Second],
			600
		],
		Example[{Basic, "Unit definitions can include metric prefixes:"},
			Convert[312000000Nano Meter, Milli Meter],
			312 Meter Milli
		],
		Example[{Basic, "The function is aware of a vast array of possible unit conversions:"},
			Convert[2Inch^3, Milli Liter] // N,
			32.774128` Liter Milli
		],
		Example[{Basic, "Can specify target Units as string expression:"},
			Convert[5Meter / Second, "Kilometers" / "Hours"],
			18 * Kilometer / Hour
		],
		Example[{Additional, "The function can Convert from mixed input Units, provided they are of the same type:"},
			Convert[{600Second, 2 Minute, 1 / 2 Hour}, Minute],
			{10 Minute, 2 Minute, 30 Minute}
		],
		Example[{Additional, "Paired lists of Units can be used as inputs as well:"},
			Convert[{{0, 10}, {1, 20}, {2, 30}, {3, 50}}, {Minute, AbsorbanceUnit}, {Second, Milli AbsorbanceUnit}],
			{{0, 10000}, {60, 20000}, {120, 30000}, {180, 50000}}
		],
		Example[{Messages, "NotConvertable", "If the function is provided two Units that aren't CompatibleUnitQ, then the NotConvertable message is thrown:"},
			Convert[12 Meter, Minute],
			$Failed,
			Messages :> Quantity::compat
		],
		Example[{Additional, "Convert from numeric value to dimensionless unit:"},
			Convert[.1, Percent],
			10. * Percent
		],
		Example[{Additional, "Convert a distribution with units specified separately:"},
			Convert[NormalDistribution[3, 2], Second, Millisecond],
			NormalDistribution[3000, 2000]
		],
		Example[{Additional, "Convert a list of QuantityDistributions:"},
			Convert[{QuantityDistribution[NormalDistribution[3, 2], Second], QuantityDistribution[NormalDistribution[3, 2], Minute]}, Millisecond],
			{QuantityDistribution[NormalDistribution[3000, 2000], "Milliseconds"], QuantityDistribution[NormalDistribution[180000, 120000], "Milliseconds"]}
		],
		Example[{Additional, "Coordinates with mixture of quantities and quantity distributions:"},
			Convert[{{QuantityDistribution[NormalDistribution[3, 2], Second], 3 * Meter}, {QuantityDistribution[NormalDistribution[3, 2], Minute], 2 * Centimeter}}, {Millisecond, Millimeter}],
			{{QuantityDistribution[NormalDistribution[3000, 2000], "Milliseconds"], Quantity[3000, "Millimeters"]}, {QuantityDistribution[NormalDistribution[180000, 120000], "Milliseconds"], Quantity[20, "Millimeters"]}}
		],
		Example[{Additional, "Coordinates with mixture of quantities and unitless distributions:"},
			Convert[{{NormalDistribution[3, 2], 3 * Meter}, {NormalDistribution[3, 2], 2 * Centimeter}}, {1, Millimeter}],
			{{NormalDistribution[3, 2], Quantity[3000, "Millimeters"]}, {NormalDistribution[3, 2], Quantity[20, "Millimeters"]}}
		],

		Test["Testing simple list conversion of dimensionaless numbers:",
			Convert[{1, 2, 3, 4, 5}, Minute, Second],
			{60, 120, 180, 240, 300}
		],
		Test["Testing impossible conversion of list Units:",
			Convert[{{1, 2}, {3, 4}, {5, 6}}, {Second, Meter}, {Kelvin, Kilo Meter}],
			_,
			Messages :> Quantity::compat
		],
		Test["List conversion faster than mapping:",
			First[AbsoluteTiming[Convert[Range[10^3], Hour, Minute]]] < First[AbsoluteTiming[Convert[#, Hour, Minute]& /@ Range[10^3]]],
			True
		],
		Test["Converting is faster when Units are specified separately outside the data:",
			First[AbsoluteTiming[Convert[Range[10^3], Hour, Minute]]] < First[AbsoluteTiming[Convert[Range[10^3] * Hour, Minute]]],
			True
		],
		Test["Doubly nested list:",
			Convert[{{{2, 1}, {0, 5}, {2, 5}}, {{4, 3}, {1, 0}, {5, 4}}}, {Kilometer, Hour}, {Meter, Second}],
			{{{2000, 3600}, {0, 18000}, {2000, 18000}}, {{4000, 10800}, {1000, 0}, {5000, 14400}}}
		],


		(* QA tests *)
		Test["Convert a flat quantity array:",
			Convert[QuantityArray[{1, 2, 3, 4, 5}, "Meters"], Centimeter],
			QuantityArray[{100, 200, 300, 400, 500}, "Centimeters"]
		],
		Test["Convert Nx2 quantity array:",
			Convert[QuantityArray[{{1, 1}, {2, 4}, {3, 9}}, {"Minutes", "Meters"}], {Second, Centimeter}],
			QuantityArray[{{60, 100}, {120, 400}, {180, 900}}, {"Seconds", "Centimeters"}]
		],
		Test["Convert Nx2 quantity array:",
			Convert[QuantityArray[{{1, 1}, {2, 4}, {3, 9}}, "Minutes"], {Second, Second}],
			QuantityArray[{{60, 60}, {120, 240}, {180, 540}}, {"Seconds", "Seconds"}]
		],
		Test["Convert Nx2 quantity array:",
			Convert[QuantityArray[{{1, 1}, {2, 4}, {3, 9}}, {"Minutes", "Minutes"}], Second],
			QuantityArray[{{60, 60}, {120, 240}, {180, 540}}, {"Seconds", "Seconds"}]
		],

		Example[{Additional, "Specify single unit for everything in a QuantityArray:"},
			Normal@Convert[QuantityArray[{{{1, 1, 1}, {2, 2, 2}}, {{3, 3, 3}, {4, 4, 4}}}, Meter], Millimeter],
			{{{Quantity[1000, "Millimeters"], Quantity[1000, "Millimeters"], Quantity[1000, "Millimeters"]}, {Quantity[2000, "Millimeters"], Quantity[2000, "Millimeters"], Quantity[2000, "Millimeters"]}}, {{Quantity[3000, "Millimeters"], Quantity[3000, "Millimeters"], Quantity[3000, "Millimeters"]}, {Quantity[4000, "Millimeters"], Quantity[4000, "Millimeters"], Quantity[4000, "Millimeters"]}}}
		],
		Example[{Additional, "Specify units at bottom level list in QuantityArray:"},
			Normal@Convert[QuantityArray[{{{1, 1, 1}, {2, 2, 2}}, {{3, 3, 3}, {4, 4, 4}}}, Meter], {Millimeter, Kilometer, Centimeter}],
			{{{Quantity[1000, "Millimeters"], Quantity[1 / 1000, "Kilometers"], Quantity[100, "Centimeters"]}, {Quantity[2000, "Millimeters"], Quantity[1 / 500, "Kilometers"], Quantity[200, "Centimeters"]}}, {{Quantity[3000, "Millimeters"], Quantity[3 / 1000, "Kilometers"], Quantity[300, "Centimeters"]}, {Quantity[4000, "Millimeters"], Quantity[1 / 250, "Kilometers"], Quantity[400, "Centimeters"]}}}
		],
		Example[{Additional, "Specify units for every element in QuantityArray:"},
			Normal@Convert[QuantityArray[{{{1, 1, 1}, {2, 2, 2}}, {{3, 3, 3}, {4, 4, 4}}}, Meter], {{{Millimeter, Kilometer, Centimeter}, {Inch, Yard, Mile}}, {{Nanometer, Micrometer, Picometer}, {Megameter, Gigameter, Yoctometer}}}],
			{{{Quantity[1000, "Millimeters"], Quantity[1 / 1000, "Kilometers"], Quantity[100, "Centimeters"]}, {Quantity[10000 / 127, "Inches"], Quantity[2500 / 1143, "Yards"], Quantity[125 / 100584, "Miles"]}}, {{Quantity[3000000000, "Nanometers"], Quantity[3000000, "Micrometers"], Quantity[3000000000000, "Picometers"]}, {Quantity[1 / 250000, "Megameters"], Quantity[1 / 250000000, "Gigameters"], Quantity[4000000000000000000000000, "Yoctometers"]}}}
		],


		Test["String unit handled correctly:",
			Convert[Meter, "Centimeters"],
			100Centimeter
		],
		Test["String unit handled correctly in list case:",
			Convert[{Meter}, "Centimeters"],
			{100Centimeter}
		],

		Test["Convert Kelvin -> Celsius when units not attached:",
			Convert[300.15, Kelvin, Celsius],
			27.
		],
		Test["Convert Celsius -> Kelving when units not attached:",
			Convert[26.85, Celsius, Kelvin],
			300.
		],
		Test["Convert list of temperatures without units attached:",
			Convert[300.15 + Range[5], Kelvin, Celsius],
			{28.`, 29.`, 30.`, 31.`, 32.`}
		],
		Test["Convert list of temperatures with units attached:",
			Convert[(300.15 + Range[5])Kelvin, Celsius],
			{28.`, 29.`, 30.`, 31.`, 32.`} * Celsius
		],
		Test["Add prefix to temperature:",
			Convert[300. * Kelvin, Milli * Kelvin],
			300000. * Milli * Kelvin
		],
		Test["Add prefix to temperature when units not attached:",
			Convert[300., Kelvin, Milli * Kelvin],
			300000.
		],
		Test["List of temperatures conversion with prefix:",
			Convert[300. + Range[5], Kelvin, Milli * Kelvin],
			{301000.`, 302000.`, 303000.`, 304000.`, 305000.`}
		],

		Example[{Additional, "Convert a quantity distribution:"},
			Convert[QuantityDistribution[NormalDistribution[3, 2], "Meters"], Centimeter],
			QuantityDistribution[NormalDistribution[300, 200], "Centimeters"]
		],
		Example[{Additional, "Convert a multi-variate quantity distribution:"},
			Convert[QuantityDistribution[ MultinormalDistribution[{-1, 1}, {{5, 1}, {1, 3}}], {"Grams", "Hours"}], {Milligram, Minute}],
			QuantityDistribution[MultinormalDistribution[{-1000, 60}, {{5000000, 60000}, {60000, 10800}}], {"Milligrams", "Minutes"}]
		],
		Test["Convert a data distribution using string unit:",
			Convert[EmpiricalDistribution[Quantity[{1, 2, 3}, "Meters"]], "Centimeters"],
			EmpiricalDistribution[Quantity[{100, 200, 300}, "Centimeters"]]
		],
		Test["Convert a data distribution using quantity:",
			Convert[EmpiricalDistribution[Quantity[{1, 2, 3}, "Meters"]], Quantity[1, "Centimeters"]],
			EmpiricalDistribution[Quantity[{100, 200, 300}, "Centimeters"]]
		],
		Test["Convert a unitless data distribution:",
			Convert[EmpiricalDistribution[{1, 2, 3}], None],
			EmpiricalDistribution[{1, 2, 3}]
		],
		Test["Incompatible data distribution conversion:",
			Convert[EmpiricalDistribution[Quantity[{1, 2, 3}, "Meters"]], "Grams"],
			$Failed,
			Messages :> {Quantity::compat}
		],
		Test["Incompatible unitless data distribution conversion:",
			Convert[EmpiricalDistribution[{1, 2, 3}], "Grams"],
			$Failed,
			Messages :> {Quantity::compat}
		],

		Test["Given DataDistribution with repeated points, don't collapse sample size:",
			Convert[EmpiricalDistribution[{1, 2, 2} * Meter], Centimeter],
			DataDistribution["Empirical", {{1 / 3, 2 / 3}, {100, 200}, False}, 1, 3, "Centimeters"]
		],

		(* QuantityFunction *)
		Example[{Additional, "Convert a QuantityFunction:"},
			Convert[
				QuantityFunction[2#1 + 3#2^2&, {Second, Meter}, Gram],
				{Minute, Millimeter},
				Kilogram
			],
			QuantityFunction[
				_Function ,
				{Quantity[1, "Minutes"], Quantity[1, "Millimeters"]},
				Quantity[1, "Kilograms"]
			]
		],
		Test["Convert a QuantityFunction, check pure function:",
			Convert[
				QuantityFunction[2#1 + 3#2^2&, {Second, Meter}, Gram],
				{Minute, Millimeter},
				Kilogram
			][[1]][x, y],
			(120 * x + (3 * y^2) / 1000000) / 1000
		],
		Test["Converted function gives same answer as original function:",
			Module[{qfNew},
				qfNew=Convert[
					QuantityFunction[2#1 + 3#2^2&, {Second, Meter}, Gram],
					{Minute, Millimeter},
					Kilogram
				];
				qfNew[2.Minute, 3Millimeter]
			],
			UnitConvert[QuantityFunction[2#1 + 3#2^2&, {Second, Meter}, Gram][2.Minute, 3Millimeter], "Kilograms"]
		],
		Test["Single input unit gets redirected to list case:",
			Convert[
				QuantityFunction[2 * #^2&, Second, Gram],
				Minute,
				Kilogram
			],
			QuantityFunction[_Function , {Quantity[1, "Minutes"]}, Quantity[1, "Kilograms"]]
		],
		Test["QuantityArray convert failure returns $Failed:",
			Convert[QuantityArray[Range[3], "Minutes"], "Meters"],
			$Failed,
			Messages :> {Quantity::compat}
		]

	}
];


(* ::Subsubsection::Closed:: *)
(*UnitScale*)


DefineTests[
	UnitScale,
	{
		Example[{Basic, "Converts the input item to the nearest sensible metric such that the number is greater than 1:"},
			UnitScale[12312312 Micro Mole],
			12.312312` Mole
		],
		Example[{Basic, "Works for time Units as well:"},
			UnitScale[21312412 Second],
			8.109745814307459` Month
		],
		Example[{Additional, "Can Convert items between metric prefixes:"},
			UnitScale[12345 Nano Mole],
			12.345` Micro Mole
		],
		Example[{Attributes, Listable, "Can Convert a list of items into metric form:"},
			UnitScale[{1223 Meter, .000001 Liter, 264235 Micro Mole}],
			{1.223` Kilo Meter, 1.` Liter Micro, 264.235` Milli Mole}
		],
		Example[{Additional, "Handles compound Units:"},
			UnitScale[Quantity[.0002, "Meters" / "Nanoseconds"]],
			Quantity[200.`, ("Kilometers") / ("Seconds")]
		],
		Example[{Additional, "Numeric values are unchanged:"},
			UnitScale[25000],
			25000
		],
		Test["More compound unit cases:",
			UnitScale[Quantity[.0002, "Kilometers" / "Seconds"]],
			Alternatives[
				Quantity[200.`, ("Millimeters") / ("Seconds")],
				(* MM 12.3.1 *)
				Quantity[720.0000000000001, "Meters"/"Hours"]
			]
		],
		Test["More compound unit cases:",
			UnitScale[Quantity[.0002, "Kilometers" / "Nanoseconds"]],
			Alternatives[
				Quantity[200.`, ("Megameters") / ("Seconds")],
				(* MM 12.3.1 *)
				Quantity[667.1281903963041, "Milli"*"SpeedOfLight"]
			]
		],
		Test["Handles dimensionless values:",
			UnitScale[3Percent],
			3Percent
		],
		Test["Handles negative values correctly:",
			UnitScale[-2. * Meter],
			-2. * Meter
		],
		Test["Does not expand Molar into Moles/Meter^3:",
			UnitScale[Quantity[.025, "Molar"]],
			Quantity[25., "Millimolar"]
		],
		Test["Handles positive exponents of things with prefixes:",
			UnitScale[.0000000001 Millimeter^2],
			Quantity[100.`, Power["Nanometers", 2]]
		],
		Test["Handles negative exponents of things with prefixes:",
			UnitScale[.0000000001 Millimeter^-2],
			Quantity[100.`, Power["Kilometers", -2]]
		],
		Test["Does not flatten Hz:",
			UnitScale[.1*Hertz],
			Quantity[100., "Millihertz"]
		],
		Test["Times greater than one Second convert to elements of TimeUnits:",
			UnitScale[0.02 * Day],
			Quantity[28.8, "Minutes"]
		],
		Test["Times less than one Second convert to prefixed seconds:",
			UnitScale[0.0002 * Second],
			Quantity[200., "Microseconds"]
		],
		Test["Times with hours < 100 should still get converted to Days if > 1 in Days:",
			UnitScale[72. * Hour],
			Quantity[3., "Days"]
		],
		Test["Correctly scales IndependentUnit quantities:",
			UnitScale[3000. * AbsorbanceUnit],
			3. * Kilo * AbsorbanceUnit
		],
		Example[{Additional, "Scale a QuantityArray:"},
			UnitScale[QuantityArray[{{.0001, 2}, {.0003, 400}, {.05, 600000}}, {Second, Meter}]],
			QuantityArray[{{Quantity[0.1, "Milliseconds"], Quantity[1 / 500, "Kilometers"]}, {Quantity[0.3, "Milliseconds"], Quantity[2 / 5, "Kilometers"]}, {Quantity[50., "Milliseconds"], Quantity[600, "Kilometers"]}}]
		],
		Example[{Additional, "Take in QuantityDistribution:"},
			UnitScale[QuantityDistribution[EmpiricalDistribution[{3500, 4500, 3500}], Meter]],
			QuantityDistribution[DataDistribution["Empirical", {{2 / 3, 1 / 3}, {7 / 2, 9 / 2}, False}, 1, 2], "Kilometers"]
		],


		Example[{Options, Simplify, "Do not simplify before scaling:"},
			UnitScale[1000 * Molar * Liter, Simplify -> False],
			Quantity[1, "Kilomolar" * "Liters"]
		],

		Example[{Options, Round, "After converting the value round it to the nearest 0.01:"},
			UnitScale[10000 Second, Round->True],
			2.78` Hour
		],

		Example[{Additional, "Units with exponents can have prefixes <1 or >1000:"},
			UnitScale[1000000 Nanometer^2],
			Quantity[1, "Micrometers"^2]
		],

		Test["Time unit scaling in compound things:",
			UnitScale[0.1 * USD / Centimeter^3 / Day],
			Quantity[1.1574074074074074, "USDollars" / ("Meters"^3 * "Seconds")]
		],

		Test["Numeric values are left alone:",
			UnitScale[123456.654321],
			123456.654321
		],

		Test["Correct magnitude no scaling:",
			UnitScale[12.34Meter],
			12.34Meter
		],
		Test["Temperature over time:",
			UnitScale[.015 Celsius / Second],
			54.Celsius / Hour
		],
		Test["Minutes get scaled properly:",
			UnitScale[Quantity[654, "Minutes"]],
			Quantity[10.9, "Hours"]
		],
		Test["Days get scaled properly:",
			UnitScale[Quantity[730, "Days"]],
			Quantity[2, "Years"]
		],
		Test["Negative times are scaled in the same way as positive times:",
			UnitScale[Quantity[-18000, "Second"]],
			Quantity[-5, "Hours"]
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*UnitForm*)


DefineTests[
	UnitForm,
	{
		Example[{Basic, "Formats the input into an easy to read string:"},
			UnitForm[30 Micro Molar],
			"30 [\[Micro]M]"
		],
		Example[{Additional, "Accepts all Units, including temperatures:"},
			UnitForm[Celsius],
			"1 (\[Degree]C)"
		],
		Example[{Options, Brackets, "If Brackets is False, the output will not have parentheses:"},
			UnitForm[Milli Liter, Brackets -> False],
			"1 mL"
		],
		Example[{Basic, "Can Convert complex Units into unit form:"},
			UnitForm[2.5 * (Microohm) / (Millimeter)],
			"2.5 (mohms/m)"
		],
		Example[{Basic, "Converts to UnitScale:"},
			UnitForm[123456 * Meter],
			"123.456 (km)"
		],
		Example[{Additional, "Uses superscripts for inverse Units:"},
			UnitForm[1 / (Micro Molar)],
			"1 (\[Micro]M^(-1))"
		],
		Example[{Attributes, Listable, "Converts lists of Units into a list of strings:"},
			UnitForm[{23 Micro Meter, 5Milli Second}],
			{"23 (\[Micro]m)", "5 (mSeconds)"}
		],
		Example[{Options, Number, "Choose whether the number is shown or not:"},
			UnitForm[{23 Micro Meter, 5Milli Mole}, Number -> False],
			{" (\[Micro]m)", " (mMol.)"}
		],
		Example[{Additional, "Converts money into an easy to read format as well:"},
			UnitForm[231000 USD],
			CurrencyForm[231000 USD]
		],
		Example[{Options, Metric, "Do not Convert to UnitScale:"},
			UnitForm[123456 * Meter, Metric -> False],
			"123456 (m)"
		],
		Example[{Options, PrefixShorthand, "Set a new rule for how to handle metric prefixes:"},
			UnitForm[23 Micro Meter, PrefixShorthand -> {Micro -> "u"}],
			"23 (um)"
		],
		Example[{Options, PostfixShorthand, "Set a new rule for how to handle core Units:"},
			UnitForm[30 Second, PostfixShorthand -> {Second -> "sec."}],
			"30 (sec.)"
		],
		Example[{Options, Format, "Return a formatted string:"},
			UnitForm[3.4 * Meter^2, Format -> Formatted],
			"\!\(\*FormBox[\"3.4`\", TraditionalForm]\) (\!\(\*SuperscriptBox[\(m\), \(2\)]\))"
		],
		Example[{Options, Format, "Return a plain string:"},
			UnitForm[3.4 * Meter^2, Format -> Plain],
			"3.4 (m^2)"
		],
		Example[{Options, Round, "Round the value before converting it to a string:"},
			UnitForm[30.12311 Micro Molar, Round->True],
			"30.12 [\[Micro]M]"
		],
		Example[{Options, Round, "Rounding takes place after the value is converted to its final format:"},
			UnitForm[10000.1234 Second, Round->0.1],
			"2.8 (Hrs.)"
		],

		Test["Numeric input:",
			UnitForm[3],
			"3"
		],
		Example[{Basic, "String unit input:"},
			UnitForm["Meters" * "Seconds"^2 / "Moles"^3],
			_String
		],
		Test["Does not sort separated prefixes:",
			UnitForm[Milli * AbsorbanceUnit],
			"1 (mAU)"
		],
		Test["Does not sort separated prefixes:",
			UnitForm[Milli * Celsius],
			"0.001 (K)"
		],
		Test["Handles exponents higher than 1:",
			UnitForm[1 / Millimeter^2],
			"1 (mm^(-2))"
		],
		Test["ExtinctionCoefficient units:",
			UnitForm[Quantity[2, "Liters" / ("Centimeters" * "Moles")], Number -> False, Metric -> False],
			" (L/(cm Mol.))"
		]

	}
];


(* ::Subsubsection::Closed:: *)
(*CurrencyForm*)


DefineTests[
	CurrencyForm,
	{
		Example[
			{Basic, "Put the number into an easily read currency format:"},
			CurrencyForm[654654654.546],
			"$655M"
		],
		Example[
			{Basic, "Include the Units in the input:"},
			CurrencyForm[654654654.546 USD],
			"$655M"
		],
		Example[
			{Options, Units, "Change the Units that the output will be rounded to:"},
			CurrencyForm[654654654.546, Units -> Penny],
			"$654,654,654.55"
		],
		Test["Testing other output Units:",
			CurrencyForm[654654654.546, Units -> Grand],
			"$654,655k"
		],
		Test["Handles metric prefixes on USD:",
			CurrencyForm[300 * Kilo * USD],
			"$300k"
		],
		Example[
			{Options, Symbol, "Change the symbol to place in front of the value:"},
			CurrencyForm[654654654.546, Symbol -> "USD "],
			"USD 655M"
		],
		Example[
			{Basic, "By default, negative values are shown in parentheses:"},
			CurrencyForm[-654654654.546],
			"($655M)"
		],
		Example[
			{Options, Brackets, "Brackets->False displays negative values with a minus sign, rather than parentheses:"},
			CurrencyForm[-654654654.546, Brackets -> False],
			"-$655M"
		],
		Example[
			{Options, Shorthand, "If set to False, the output will be rounded, but not in short hand:"},
			CurrencyForm[-654654654.546, Shorthand -> False],
			"($655,000,000)"
		],
		Example[
			{Attributes, Listable, "Multiple numbers may be put into currency form at once:"},
			CurrencyForm[{654654654.546, 123331.64, 1232, 2342.12, 465.46, 4.4655}],
			{"$655M", "$123k", "$1k", "$2k", "$465", "$4.47"}
		],
		Example[
			{Options, Commas, "If set to False, the output will no longer have commas between each 3 orders of magnitude:"},
			CurrencyForm[654654654.546, Units -> Penny, Commas -> False],
			"$654654654.55"
		],
		Example[
			{Messages, "TooLarge", "If the number is larger than 1 trillion, grab that cash and run:"},
			CurrencyForm[1235231646372543543247232],
			"$$$",
			Messages :> Message[CurrencyForm::TooLarge]
		]
	}
];



(* ::Subsection::Closed:: *)
(*Arrays & Coordinates*)


(* ::Subsubsection::Closed:: *)
(*QuantityArrayCoordinatesQ*)


DefineTests[QuantityArrayCoordinatesQ, {

	Example[{Basic, "Match a quantity array of coordinates:"},
		QuantityArrayCoordinatesQ[QuantityArray[{{Millisecond, Inch}, {Second, Meter}, {Minute, Mile}}]],
		True
	],
	Example[{Basic, "Match a quantity array of coordinates where each coordinates is {time,distance}:"},
		QuantityArrayCoordinatesQ[QuantityArray[{{Millisecond, Inch}, {Second, Meter}, {Minute, Mile}}], {Second, Meter}],
		True
	],
	Example[{Basic, "Match a quantity array of coordinates along with constraints on the coordinate values:"},
		QuantityArrayCoordinatesQ[QuantityArray[{{Millisecond, Inch}, {Second, Meter}, {Minute, Mile}}], {LessP[Year], GreaterP[Millimeter]}],
		True
	],
	Example[{Basic, "Does not match if unit dimensions incompatible:"},
		QuantityArrayCoordinatesQ[QuantityArray[{{Millisecond, Inch}, {Second, Meter}, {Minute, Mile}}], {Gram, Meter}],
		False
	],
	Example[{Basic, "Does not match if magnitude comparisons fail:"},
		QuantityArrayCoordinatesQ[QuantityArray[{{Millisecond, Inch}, {Second, Meter}, {Minute, Mile}}], {GreaterP[Day], Meter}],
		False
	],

	Example[{Additional, "Mixed list of constraints:"},
		QuantityArrayCoordinatesQ[QuantityArray[{{Millisecond, Inch}, {Second, Meter}, {Minute, Mile}}], {Second, GreaterP[Millimeter]}],
		True
	],
	Example[{Basic, "Does not match list of quantity coordinates:"},
		QuantityArrayCoordinatesQ[{{Millisecond, Inch}, {Second, Meter}, {Minute, Mile}}],
		False
	],
	Example[{Additional, "Dimensionless data does not match:"},
		QuantityArrayCoordinatesQ[{{1, 2}, {2, 3}, {3, 4}}],
		False
	]

}];






(* ::Subsubsection::Closed:: *)
(*NumericListCoordinatesQ*)


DefineTests[NumericListCoordinatesQ, {

	Example[{Basic, "Match a list of numeric coordinates:"},
		NumericListCoordinatesQ[{{1, 2}, {2, 3}, {3, 4}}],
		True
	],
	Example[{Basic, "Specify constraints on the values:"},
		NumericListCoordinatesQ[{{1, 2}, {2, 3}, {3, 4}}, {LessP[10], GreaterP[0]}],
		True
	],
	Example[{Basic, "Does not match quantity coordinates:"},
		NumericListCoordinatesQ[{{Millisecond, Inch}, {Second, Meter}, {Minute, Mile}}],
		False
	],
	Example[{Basic, "Does not match quantity array coordinates:"},
		NumericListCoordinatesQ[QuantityArray[{{Millisecond, Inch}, {Second, Meter}}]],
		False
	],
	Example[{Additional, "Only matches matrix whose second dimension is 2:"},
		NumericListCoordinatesQ[{{1, 2, 3}, {2, 3, 4}}],
		False
	],
	Example[{Additional, "Constraints not satisifed:"},
		NumericListCoordinatesQ[{{1, 2}, {2, 3}, {3, 4}}, {LessP[1], GreaterP[0]}],
		False
	]


}];


(* ::Subsubsection::Closed:: *)
(*UnitCoordinatesQ*)


DefineTests[UnitCoordinatesQ, {

	Example[{Basic, "Match a list of numeric coordinates:"},
		UnitCoordinatesQ[{{1, 2}, {2, 3}, {3, 4}}],
		True
	],
	Example[{Basic, "Match a list of quantity coordinates:"},
		UnitCoordinatesQ[{{Millisecond, Inch}, {Second, Meter}, {Minute, Mile}}],
		True
	],
	Example[{Basic, "Match a quantity array of coordinates:"},
		UnitCoordinatesQ[QuantityArray[{{Millisecond, Inch}, {Second, Meter}, {Minute, Mile}}]],
		True
	],
	Example[{Basic, "Match a list of quantity coordinates where each coordinates is {time,distance}:"},
		UnitCoordinatesQ[{{Millisecond, Inch}, {Second, Meter}, {Minute, Mile}}, {Second, Meter}],
		True
	],
	Example[{Basic, "Match a list of quantity coordinates along with constraints on the coordinate values:"},
		UnitCoordinatesQ[{{Millisecond, Inch}, {Second, Meter}, {Minute, Mile}}, {LessP[Year], GreaterP[Millimeter]}],
		True
	],
	Example[{Additional, "Does not match if unit dimensions incompatible:"},
		UnitCoordinatesQ[QuantityArray[{{Millisecond, Inch}, {Second, Meter}, {Minute, Mile}}], {Gram, Meter}],
		False
	],
	Example[{Additional, "Does not match if magnitude comparisons fail:"},
		UnitCoordinatesQ[QuantityArray[{{Millisecond, Inch}, {Second, Meter}, {Minute, Mile}}], {GreaterP[Day], Meter}],
		False
	],

	Example[{Additional, "Mixed list of constraints:"},
		UnitCoordinatesQ[QuantityArray[{{Millisecond, Inch}, {Second, Meter}, {Minute, Mile}}], {Second, GreaterP[Millimeter]}],
		True
	],
	Example[{Additional, "List of date coordinates in a list:"},
		UnitCoordinatesQ[{{Now, Inch}, {Now + Hour, Meter}, {Now + Day, Mile}}],
		True
	],
	Example[{Additional, "List of date coordinates in a list with constraint:"},
		UnitCoordinatesQ[{{Now, Inch}, {Now + Hour, Meter}, {Now + Day, Mile}}, {DateObject, GreaterP[Millimeter]}],
		True
	],
	Example[{Additional, "List of date coordinates in a QA:"},
		UnitCoordinatesQ[QuantityArray[{{Now, Inch}, {Now + Hour, Meter}, {Now + Day, Mile}}]],
		True
	],
	Example[{Additional, "List of date coordinates in a QA with constraint:"},
		UnitCoordinatesQ[QuantityArray[{{Now, Inch}, {Now + Hour, Meter}, {Now + Day, Mile}}], {DateObject, GreaterP[Millimeter]}],
		True
	],
	Example[{Additional, "Does not match a list of numeric coordinates if unit spec does not match:"},
		UnitCoordinatesQ[{{1, 2}, {2, 3}, {3, 4}}, {Second, Meter}],
		False
	],
	Example[{Attributes, HoldRest, "UnitCoordinatesQ has a HoldRest attribute:"},
		UnitCoordinatesQ[{{1, 2}, {2, 3}, {3, 4}}, {Second, Meter}],
		False
	]

}];



(* ::Subsubsection::Closed:: *)
(*UnitCoordinatesP*)


DefineTests[UnitCoordinatesP,
	{
		Example[{Basic, "Match a list of numeric coordinates:"},
			MatchQ[{{1, 2}, {2, 3}, {3, 4}}, UnitCoordinatesP[]],
			True
		],
		Example[{Basic, "Match a list of quantity coordinates:"},
			MatchQ[{{Millisecond, Inch}, {Second, Meter}, {Minute, Mile}}, UnitCoordinatesP[]],
			True
		],
		Example[{Basic, "Match a quantity array of coordinates:"},
			MatchQ[QuantityArray[{{Millisecond, Inch}, {Second, Meter}, {Minute, Mile}}], UnitCoordinatesP[]],
			True
		],
		Example[{Basic, "Match a list of quantity coordinates where each coordinates is {time,distance}:"},
			MatchQ[{{Millisecond, Inch}, {Second, Meter}, {Minute, Mile}}, UnitCoordinatesP[{Second, Meter}]],
			True
		],
		Example[{Additional, "Match a list of quantity coordinates along with constraints on the coordinate values:"},
			MatchQ[{{Millisecond, Inch}, {Second, Meter}, {Minute, Mile}}, UnitCoordinatesP[{LessP[Year], GreaterP[Millimeter]}]],
			True
		],
		Example[{Additional, "Does not match if unit dimensions incompatible:"},
			MatchQ[QuantityArray[{{Millisecond, Inch}, {Second, Meter}, {Minute, Mile}}], UnitCoordinatesP[{Gram, Meter}]],
			False
		],
		Example[{Additional, "Does not match if magnitude comparisons fail:"},
			MatchQ[QuantityArray[{{Millisecond, Inch}, {Second, Meter}, {Minute, Mile}}], UnitCoordinatesP[{GreaterP[Day], Meter}]],
			False
		],
		Example[{Additional, "Mixed list of constraints:"},
			MatchQ[QuantityArray[{{Millisecond, Inch}, {Second, Meter}, {Minute, Mile}}], UnitCoordinatesP[{Second, GreaterP[Millimeter]}]],
			True
		],
		Example[{Additional, "List of date coordinates in a list:"},
			MatchQ[{{Now, Inch}, {Now + Hour, Meter}, {Now + Day, Mile}}, UnitCoordinatesP[{DateObject, GreaterP[Millimeter]}]],
			True
		],
		Example[{Additional, "List of date coordinates in a QA:"},
			MatchQ[QuantityArray[{{Now, Inch}, {Now + Hour, Meter}, {Now + Day, Mile}}], UnitCoordinatesP[{DateObject, GreaterP[Millimeter]}]],
			True
		],
		Example[{Attributes, HoldFirst, "The pattern function's argument is held:"},
			MatchQ[QuantityArray[{{Now, Inch}, {Now + Hour, Meter}, {Now + Day, Mile}}], UnitCoordinatesP[{DateObject, GreaterP[Millimeter]}]],
			True
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*QuantityArrayCoordinatesQ*)


DefineTests[QuantityArrayCoordinatesP, {

	Example[{Basic, "Match a quantity array of coordinates:"},
		MatchQ[QuantityArray[{{Millisecond, Inch}, {Second, Meter}, {Minute, Mile}}], QuantityArrayCoordinatesP[]],
		True
	],
	Example[{Basic, "Specify unit type constraints:"},
		MatchQ[QuantityArray[{{Millisecond, Inch}, {Second, Meter}, {Minute, Mile}}], QuantityArrayCoordinatesP[{Second, Meter}]],
		True
	],
	Example[{Basic, "Specify value comparison constraints:"},
		MatchQ[QuantityArray[{{Millisecond, Inch}, {Second, Meter}, {Minute, Mile}}], QuantityArrayCoordinatesP[{LessP[Day], GreaterP[Nanometer]}]],
		True
	],
	Example[{Basic, "Does not match a list of quantity coordinates:"},
		MatchQ[{{Millisecond, Inch}, {Second, Meter}, {Minute, Mile}}, QuantityArrayCoordinatesP[]],
		False
	],
	Example[{Basic, "Does not match a list of numeric coordinates:"},
		MatchQ[{{1, 2}, {2, 3}, {3, 4}}, QuantityArrayCoordinatesP[]],
		False
	],

	Example[{Basic, "Does not match if unit dimensions incompatible:"},
		MatchQ[QuantityArray[{{Millisecond, Inch}, {Second, Meter}, {Minute, Mile}}], QuantityArrayCoordinatesP[{Gram, Meter}]],
		False
	],
	Example[{Basic, "Does not match if magnitude comparisons fail:"},
		MatchQ[QuantityArray[{{Millisecond, Inch}, {Second, Meter}, {Minute, Mile}}], QuantityArrayCoordinatesP[{GreaterP[Day], Meter}]],
		False
	],

	Example[{Additional, "Mixed list of constraints:"},
		MatchQ[QuantityArray[{{Millisecond, Inch}, {Second, Meter}, {Minute, Mile}}], QuantityArrayCoordinatesP[{Second, GreaterP[Millimeter]}]],
		True
	],
	Example[{Additional, "List of date coordinates in a QA:"},
		MatchQ[QuantityArray[{{Now, Inch}, {Now + Hour, Meter}, {Now + Day, Mile}}], QuantityArrayCoordinatesP[]],
		True
	],
	Example[{Additional, "List of date coordinates in a QA with constraints:"},
		MatchQ[QuantityArray[{{Now, Inch}, {Now + Hour, Meter}, {Now + Day, Mile}}], QuantityArrayCoordinatesP[{DateObject, GreaterP[Millimeter]}]],
		True
	],
	Example[{Additional, "Match a QA whose second dimension is unitless:"},
		MatchQ[QuantityArray[{{Millisecond, 1}, {Second, 2}, {Minute, 3}}], QuantityArrayCoordinatesP[{Second, None}]],
		True
	]


}];



(* ::Subsection::Closed:: *)
(*QuantityFunction*)


(* ::Subsubsection::Closed:: *)
(*QuantityFunction*)


DefineTests[QuantityFunction, {

	Example[{Basic, "Apply a QuantityFunction to an input:"},
		QuantityFunction[#^2&, Second, Meter][3 * Second],
		9 * Meter
	],
	Example[{Basic, "Input unit can be different but must be compatible with QuantityFunction's input unit:"},
		QuantityFunction[#^2&, Second, Meter][2 * Minute],
		14400 * Meter
	],
	Example[{Basic, "Can handle functions with mutliple inputs:"},
		QuantityFunction[3 + #1 + 4 * #2 * #3&, {Second, Meter, Gram}, Liter][2Second, 3Centimeter, 4Kilogram],
		485 * Liter
	],

	Example[{Additional, "Given numeric inputs, QuantityFunction assumes they are already in the correct unit:"},
		QuantityFunction[#^2&, Second, Meter][2],
		4 * Meter
	],
	Example[{Additional, "Can give QuantityFunction functions with named variables:"},
		QuantityFunction[Function[{x, y}, 2 * x + 3 * y], {Second, Minute}, Gram][2Second, 5Hour],
		904 * Gram
	],
	Example[{Additional, "Apply a QuantityFunction to a list of quantities:"},
		QuantityFunction[#^2&, Second, Meter][{3 * Second, 4Minute, 5Hour}],
		{Quantity[9, "Meters"], Quantity[57600, "Meters"], Quantity[324000000, "Meters"]}
	],
	Example[{Additional, "Apply a QuantityFunction to a list of numbers:"},
		QuantityFunction[#^2&, Second, Meter][{3, 4, 5}],
		{Quantity[9, "Meters"], Quantity[16, "Meters"], Quantity[25, "Meters"]}
	],
	Example[{Additional, "Apply a QuantityFunction to a QuantityArray:"},
		QuantityFunction[#^2&, Second, Meter][QuantityArray[{3 * Second, 4Minute, 5Hour}]],
		{Quantity[9, "Meters"], Quantity[57600, "Meters"], Quantity[324000000, "Meters"]}
	],
	Example[{Additional, "Apply a QuantityFunction to another QuantityArray:"},
		QuantityFunction[#^2&, Second, Meter][QuantityArray[{3, 4, 5}, Minute]],
		{Quantity[32400, "Meters"], Quantity[57600, "Meters"], Quantity[90000, "Meters"]}
	],

	(*
		Messages
	*)
	Example[{Messages, "UnitMismatch", "Given input whose units do not match QuantityFunction's input unit:"},
		QuantityFunction[#^2&, Second, Meter][2 * Gram],
		$Failed,
		Messages :> {QuantityFunction::UnitMismatch}
	],
	Example[{Messages, "InputSizeMismatch", "Given wrong number of input arguments:"},
		QuantityFunction[#^2&, Second, Meter][2Minute, 3Hour],
		$Failed,
		Messages :> {QuantityFunction::InputSizeMismatch}
	]


}];



(* ::Subsubsection::Closed:: *)
(*QuantityFunctionP*)


DefineTests[QuantityFunctionP, {
	Example[{Basic, "Match a quantity function':"},
		MatchQ[QuantityFunction[#^2&, {Kilogram, Microsecond}, Meter], QuantityFunctionP[]],
		True
	],
	Example[{Basic, "Match a quantity function with single input/output specified:"},
		MatchQ[QuantityFunction[#^2&, {Microsecond}, Meter], QuantityFunctionP[{Minute}, Kilometer]],
		True
	],
	Example[{Basic, "Match a quantity function with multiple inputs and single output specified:"},
		MatchQ[QuantityFunction[#^2&, {Kilogram, Microsecond}, Meter], QuantityFunctionP[{Gram, Minute}, Kilometer]],
		True
	],
	Example[{Basic, "Not a quantity function:"},
		MatchQ[{1, 2, 3}, QuantityFunctionP[]],
		False
	],
	Example[{Basic, "Unit specifications don't match units in quantity function:"},
		MatchQ[QuantityFunction[#^2&, {Kilometer, Microsecond}, Meter], QuantityFunctionP[{Gram, Minute}, Kilometer]],
		False
	]
}];


(* ::Subsection::Closed:: *)
(*QuantityPartition*)


DefineTests[QuantityPartition,
	{
		Example[{Basic, "Split a quantity into a list of quantities below a requested maximum, including a remainder:"},
			QuantityPartition[10 Meter, 4 Meter],
			{4 Meter, 4 Meter, 2 Meter}
		],
		Example[{Basic, "Compatible but different units may be provided as the amount to split and the maximum amount:"},
			QuantityPartition[20 Liter, 6000 Milliliter],
			{6000 Milliliter, 6000 Milliliter, 6000 Milliliter, 2000 Milliliter}
		],
		Example[{Basic, "If the amount to split is below the maximum amount, the input amount will be returned in a list:"},
			QuantityPartition[2 Volt, 2000 Volt],
			{2 Volt}
		],
		Example[{Additional, "Split a mass for measurement into smaller amounts known to fit in a single weigh boat:"},
			QuantityPartition[2 Kilogram, 300 Gram],
			{300 Gram, 300 Gram, 300 Gram, 300 Gram, 300 Gram, 300 Gram, 200 Gram}
		],
		Example[{Additional, "Determine the volumes of samples that will need to be gathered to match a total amount, with a known maximum amount per sample:"},
			QuantityPartition[9 Liter, 4 Liter],
			{4 Liter, 4 Liter, 1 Liter}
		],
		Example[{Additional, "An empty list is returned if the amount to partition is below both the max and min partition thresholds:"},
			QuantityPartition[0.1 Pascal, 1 Pascal, MinPartition -> 0.2 Pascal],
			{}
		],
		Example[{Additional, "The function can split Integers without units as well:"},
			QuantityPartition[15, 4],
			{4, 4, 4, 3}
		],
		Example[{Options, MinPartition, "Specify a minimum size for any remainder partitions:"},
			QuantityPartition[50 Microliter, 12 Microliter, MinPartition -> 5 Microliter],
			{12 Microliter, 12 Microliter, 12 Microliter, 12 Microliter}
		],
		Example[{Options, MinPartition, "Specify a minimum integer for any remainder partitions:"},
			QuantityPartition[15, 6, MinPartition -> 5],
			{6, 6}
		],
		Example[{Messages, "IncompatibleUnits", "The amount to partition and max partition amount must be in compatible units:"},
			QuantityPartition[2 Kilogram, 1 Liter],
			$Failed,
			Messages :> {
				QuantityPartition::IncompatibleUnits
			}
		],
		Example[{Messages, "MinAboveMax", "The min partition option must be below the max partition amount:"},
			QuantityPartition[10 Liter, 2 Liter, MinPartition -> 4 Liter],
			$Failed,
			Messages :> {
				QuantityPartition::MinAboveMax
			}
		],
		Test["Providing an amount for MinPartition in the Integer overload causes errors:",
			QuantityPartition[15, 6, MinPartition -> 5 * Microliter],
			$Failed,
			Messages :> {
				QuantityPartition::IncompatibleUnits
			}
		],
		Test["Providing an integer for MinPartition in the Quantity overload causes errors:",
			QuantityPartition[15 * Microliter, 6 * Microliter, MinPartition -> 5],
			$Failed,
			Messages :> {
				QuantityPartition::IncompatibleUnits
			}
		],
		Test["Providing a real and an integer doesn't cause errors:",
			QuantityPartition[2, 1.1, MinPartition -> 1],
			{1.1}
		]
	}
];


(* ::Subsection::Closed:: *)
(*Blobs*)


(* ::Subsubsection::Closed:: *)
(*quantityArrayBlobs*)

Authors[quantityArrayBlobs]:={"brad"};
DefineTests[quantityArrayBlobs, {

	Test["Short list becomes a list:",
		ToBoxes[QuantityArray[{1, 2, 3}, "Meters"]],
		InterpretationBox[
			TagBox[
				TooltipBox[
					RowBox[{"{", RowBox[{TemplateBox[{"1", "\"m\"", "meter", "\"Meters\""}, "Quantity", SyntaxForm -> Mod], ",", TemplateBox[{"2", "\"m\"", "meters", "\"Meters\""}, "Quantity", SyntaxForm -> Mod], ",", TemplateBox[{"3", "\"m\"", "meters", "\"Meters\""}, "Quantity", SyntaxForm -> Mod]}], "}"}], 
					"QuantityArray"
				],
				Annotation[#1, QuantityArray, "Tooltip"] & 
			],		 
	 		QAOutput (* InterpretationBox is HoldAllComplete, so use /. to swap in the evaluated QA, whose form varies by $VersionNumber*)
		] /. QAOutput -> QuantityArray[{1, 2, 3}, "Meters"]
	],
	Test["Long list gets shrunk:",
		ToBoxes[QuantityArray[Range[40], "Meters"]][[1,1,1]], (* only checking the part that's changing from here on*)
		RowBox[{"{", RowBox[{TemplateBox[{"1", "\"m\"", "meter", "\"Meters\""},      "Quantity", SyntaxForm -> Mod], ",",     TemplateBox[{"2", "\"m\"", "meters", "\"Meters\""}, "Quantity",      SyntaxForm -> Mod], ",",     RowBox[{"\[LeftSkeleton]", "36", "\[RightSkeleton]"}], ",",     TemplateBox[{"39", "\"m\"", "meters", "\"Meters\""}, "Quantity",      SyntaxForm -> Mod], ",",     TemplateBox[{"40", "\"m\"", "meters", "\"Meters\""}, "Quantity",      SyntaxForm -> Mod]}], "}"}]
	],

	Test["Short 2-D array:",
		ToBoxes[QuantityArray[{{1, 1, 1}, {2, 2, 2}, {3, 3, 3}, {4, 4, 4}}, {"Meters", "Seconds", "Grams"}]][[1,1,1]],
		RowBox[{"{", RowBox[{RowBox[{"{", RowBox[{TemplateBox[{"1", "\"m\"", "meter", "\"Meters\""}, "Quantity", SyntaxForm -> Mod], ",", TemplateBox[{"1", "\"s\"", "second", "\"Seconds\""}, "Quantity", SyntaxForm -> Mod], ",", TemplateBox[{"1", "\"g\"", "gram", "\"Grams\""}, "Quantity", SyntaxForm -> Mod]}], "}"}], ",", RowBox[{"{", RowBox[{TemplateBox[{"2", "\"m\"", "meters", "\"Meters\""}, "Quantity", SyntaxForm -> Mod], ",", TemplateBox[{"2", "\"s\"", "seconds", "\"Seconds\""}, "Quantity", SyntaxForm -> Mod], ",", TemplateBox[{"2", "\"g\"", "grams", "\"Grams\""}, "Quantity", SyntaxForm -> Mod]}], "}"}], ",", RowBox[{"{", RowBox[{TemplateBox[{"3", "\"m\"", "meters", "\"Meters\""}, "Quantity", SyntaxForm -> Mod], ",", TemplateBox[{"3", "\"s\"", "seconds", "\"Seconds\""}, "Quantity", SyntaxForm -> Mod], ",", TemplateBox[{"3", "\"g\"", "grams", "\"Grams\""}, "Quantity", SyntaxForm -> Mod]}], "}"}], ",", RowBox[{"{", RowBox[{TemplateBox[{"4", "\"m\"", "meters", "\"Meters\""}, "Quantity", SyntaxForm -> Mod], ",", TemplateBox[{"4", "\"s\"", "seconds", "\"Seconds\""}, "Quantity", SyntaxForm -> Mod], ",", TemplateBox[{"4", "\"g\"", "grams", "\"Grams\""}, "Quantity", SyntaxForm -> Mod]}], "}"}]}], "}"}]
	],

	Test["Long 2-D array:",
		ToBoxes[QuantityArray[Table[{x, x, x}, {x, 1, 40}], {"Meters", "Seconds", "Grams"}]][[1,1,1]],
		RowBox[{"{",   RowBox[{RowBox[{"{",       RowBox[{TemplateBox[{"1", "\"m\"", "meter", "\"Meters\""},          "Quantity", SyntaxForm -> Mod], ",",         TemplateBox[{"1", "\"s\"", "second", "\"Seconds\""},          "Quantity", SyntaxForm -> Mod], ",",         TemplateBox[{"1", "\"g\"", "gram", "\"Grams\""}, "Quantity",          SyntaxForm -> Mod]}], "}"}], ",",     RowBox[{"{",       RowBox[{TemplateBox[{"2", "\"m\"", "meters", "\"Meters\""},          "Quantity", SyntaxForm -> Mod], ",",         TemplateBox[{"2", "\"s\"", "seconds", "\"Seconds\""},          "Quantity", SyntaxForm -> Mod], ",",         TemplateBox[{"2", "\"g\"", "grams", "\"Grams\""}, "Quantity",          SyntaxForm -> Mod]}], "}"}], ",",     RowBox[{"\[LeftSkeleton]", "36", "\[RightSkeleton]"}], ",",     RowBox[{"{",       RowBox[{TemplateBox[{"39", "\"m\"", "meters", "\"Meters\""},          "Quantity", SyntaxForm -> Mod], ",",         TemplateBox[{"39", "\"s\"", "seconds", "\"Seconds\""},          "Quantity", SyntaxForm -> Mod], ",",         TemplateBox[{"39", "\"g\"", "grams", "\"Grams\""}, "Quantity",          SyntaxForm -> Mod]}], "}"}], ",",     RowBox[{"{",       RowBox[{TemplateBox[{"40", "\"m\"", "meters", "\"Meters\""},          "Quantity", SyntaxForm -> Mod], ",",         TemplateBox[{"40", "\"s\"", "seconds", "\"Seconds\""},          "Quantity", SyntaxForm -> Mod], ",",         TemplateBox[{"40", "\"g\"", "grams", "\"Grams\""}, "Quantity",          SyntaxForm -> Mod]}], "}"}]}], "}"}]
	]
}];


(* ::Subsubsection::Closed:: *)
(*MatrixP*)


DefineTests[MatrixP, {

	Example[{Basic, "Pattern that matches a matrix:"},
		MatchQ[{{1, 2}, {2, 3}, {3, 4}}, MatrixP[]],
		True
	],
	Example[{Basic, "Pattern does not match something that is not an Nx2 matrix:"},
		MatchQ[{{1, 2, 3}, {2}, {3, 4}}, MatrixP[]],
		False
	],
	Example[{Basic, "Matrix elements must match specified pattern:"},
		MatchQ[{{1, 2}, {2, 3}, {3, 4}}, MatrixP[GreaterP[0, 1]]],
		True
	],
	Example[{Basic, "Will not match if matrix elements do not match specified pattern:"},
		MatchQ[{{-1, 2}, {2.5, 3}, {3, 4}}, MatrixP[GreaterP[0, 1]]],
		False
	]

}];

Authors[unitPaclets]:={"hiren.patel"};
DefineTests[unitPaclets, {
	Test["UnitTable paclet:",
		PacletInformation["UnitTable"],
		_
	],
	Test["QuantityUnits paclet:",
		PacletInformation["QuantityUnits"],
		_
	],
	Test["Lumens: ",
		{InputForm[Lumen], UnitDimensions["Lumens"]},
		_
	],
	Test["ThermochemicalCalories: ",
		{InputForm[Calorie], InputForm@Quantity["ThermochemicalCalories"], UnitDimensions["ThermochemicalCalories"]},
		_
	],
	Test["CaloriesThermochemical: ",
		{InputForm[Calorie], InputForm@Quantity["CaloriesThermochemical"], UnitDimensions["CaloriesThermochemical"]},
		_
	],
	Test["paclets read-only?:",
		{ PacletManager`Package`$pmMode, PacletManager`Package`isPMReadOnly[] },
		_
	]
}]


(* ::Subsubsection::Closed:: *)
(*PercentConfluencyQ*)


DefineTests[PercentConfluencyQ, {
	Example[{Basic, "Test if the given item is in Units of percent confluency."},
		PercentConfluencyQ[123 PercentConfluency],
		True
	],
	Example[{Basic, "Same as MatchQ[<item>,PercentConfluencyP]"},
		PercentConfluencyQ[123 PercentConfluency]==MatchQ[123 PercentConfluency, PercentConfluencyP],
		True
	],
	Example[{Basic, "Return False for other units"},
		PercentConfluencyQ[1234 Meter],
		False
	]
}];

(* ::Subsubsection::Closed:: *)
(*ParticleConcentrationQ*)


DefineTests[
	ParticleConcentrationQ,
	{
		Example[{Basic, "ParticleConcentrationQ test if a value is in Units of ParticleConcentration:"},
			ParticleConcentrationQ[5 Particle / Meter^3],
			True
		],
		Example[{Basic, "Values which are not in Units of ParticleConcentration will return false:"},
			ParticleConcentrationQ[5.5 Year / Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			ParticleConcentrationQ[{5 Particle / Meter^3, 6 Particle / Meter^3, 7Meter}],
			{True, True, False}
		],
		Test["Nonsense input returns false:",
			ParticleConcentrationQ["Taco"],
			False
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*ParticleCountQ*)


DefineTests[
	ParticleCountQ,
	{
		Example[{Basic, "ParticleCountQ test if a value is in Units of Particles:"},
			ParticleCountQ[5 Particle],
			True
		],
		Example[{Basic, "Values which are not in Units of Particles will return false:"},
			ParticleCountQ[5 Meter],
			False
		],
		Example[{Attributes, Listable, "The function is listable:"},
			ParticleCountQ[{5 Particle, 7 Particle, 8 Meter}],
			{True, True, False}
		],
		Test["Nonsense input returns false:",
			ParticleCountQ["Taco"],
			False
		]
	}
];


Authors[mm13Units]:={"hiren.patel"};
DefineTests[mm13Units,{

	Test["Celsius",Celsius,Quantity[1,"DegreesCelsius"]],
	Test["Celsius+Celsius",Celsius+Celsius,Quantity[2,"DegreesCelsius"]],
	Test["1/Celsius",1/Celsius,Quantity[1,1/"DegreesCelsius"]],
	Test["3*Celsius",3*Celsius,Quantity[3,"DegreesCelsius"]],
	Test["Celsius+Celsius",Celsius+Celsius,Quantity[2,"DegreesCelsius"]],
	Test["Celsius/Second",Celsius/Second,Quantity[1,"DegreesCelsius"/"Seconds"]],
	Test["Differences[{unit,unit}",Differences[{Quantity[1,"Meters"],Quantity[1,"Meters"]}],{Quantity[0,"Meters"]}],
	Test["Dimensionless comparisons",{50>Quantity[1,"Dozens"],50<Quantity[1,"Dozens"],Quantity[1,"Dozens"]>50,Quantity[1,"Dozens"]<50},_],
	Test["Infinity comparisons",{
		Quantity[Infinity, "Meters"]>Quantity[3, "Meters"],Quantity[Infinity, "Meters"]<Quantity[3, "Meters"],
		Quantity[3, "Meters"]>Quantity[Infinity, "Meters"],Quantity[3, "Meters"]<Quantity[Infinity, "Meters"],
		Quantity[-Infinity, "Meters"]>Quantity[3, "Meters"],Quantity[-Infinity, "Meters"]<Quantity[3, "Meters"],
		Quantity[3, "Meters"]>Quantity[-Infinity, "Meters"],Quantity[3, "Meters"]<Quantity[-Infinity, "Meters"],
		Quantity[Infinity, "Meters"/"Seconds"]>Quantity[3, "Meters"/"Seconds"],Quantity[Infinity, "Meters"/"Seconds"]<Quantity[3, "Meters"/"Seconds"],
		Quantity[3, "Meters"/"Seconds"]>Quantity[Infinity, "Meters"/"Seconds"],Quantity[3, "Meters"/"Seconds"]<Quantity[Infinity, "Meters"/"Seconds"],
		Quantity[-Infinity, "Meters"/"Seconds"]>Quantity[3, "Meters"/"Seconds"],Quantity[-Infinity, "Meters"/"Seconds"]<Quantity[3, "Meters"/"Seconds"],
		Quantity[3, "Meters"/"Seconds"]>Quantity[-Infinity, "Meters"/"Seconds"],Quantity[3, "Meters"/"Seconds"]<Quantity[-Infinity, "Meters"/"Seconds"]
	},_],
	Test["Between",{
		Between[Quantity[1.,"Meters"],{Quantity[0.,"Meters"],Quantity[5,"Meters"]}],
		Between[Quantity[1.,"Nanometers"],{Quantity[0.,"Nanometers"],Quantity[5,"Nanometers"]}]
	},_],
	Test["UnitDimensions",{
		UnitDimensions[Quantity[1,IndependentUnit["Apples"]]],
		UnitDimensions[Quantity[1,"Kilo"*IndependentUnit["Apples"]]],
		UnitDimensions[Quantity[1,IndependentUnit["Oranges"]*IndependentUnit["Apples"]]],
		UnitDimensions[Quantity[1,IndependentUnit["Apples"]]*Quantity[IndependentUnit["Apples"]]]
	},_],
	
	Test["QA", ToString[InputForm[QuantityArray[{1},"Meters"]]],_],
	Test["QA", Quantity[bradWasHere,1],_]
	
	
}];



(* ::Subsection::Closed:: *)
(*StringToQuantity*)


DefineTests[StringToQuantity,
	{
		Example[{Basic, "Convert a string denoting a quantity into a quantity object:"},
			StringToQuantity["2 Meters", Server -> False],
			EqualP[2 Meter]
		],
		Example[{Basic, "Convert a series of strings denoting quantities into quantity objects:"},
			StringToQuantity[{"2 Meters", "14 inches", "2mm", "3.2 Kelvin"}, Server -> False],
			{EqualP[2 Meter], EqualP[14 Inch], EqualP[2 Millimeter], EqualP[3.2 Kelvin]}
		],
		Example[{Basic, "Returns $Failed if a string cannot be parsed:"},
			StringToQuantity["2 Kittens", Server -> False],
			$Failed
		],
		Example[{Basic, "By default, contacts the Wolfram server to interpret quantities that can't be parsed locally if not in engine:"},
			StringToQuantity["2 Kittens"],
			EqualP[Quantity[2, "Kittens"]]
		],
		Example[{Additional, "Parses strings with abbreviated units:"},
			StringToQuantity["2m", Server -> False],
			EqualP[2 Meter]
		],
		Example[{Additional, "Quantity strings are potentially ambiguous and formatting is interpreted strictly:"},
			StringToQuantity[{"2 ms", "2 m s", "3 \[Degree]C", "3 \[Degree] C"}, Server -> False],
			{EqualP[2 Millisecond], EqualP[2 Meter Second], EqualP[3 Celsius], EqualP[3 AngularDegree Coulomb]}
		],
		Example[{Additional, "Celsius is used in preference to Centigrade:"},
			StringToQuantity["3 \[Degree]C", Server -> False],
			EqualP[3 Celsius]
		],
		Example[{Options, Server, "Prevent the function from contacting the Wolfram server if the unit can't be interpreted locally:"},
			StringToQuantity["2 Kittens", Server -> False],
			$Failed
		],
		Example[{Additional, "Server option resolves to False in engine as the Wolfram server can't be contacted when in Engine:"},
			StringToQuantity["2 Kittens"],
			$Failed,
			Stubs :> {$ECLApplication = Engine}
		],
		Test["Parses strings with a variety of spacing between magnitude and unit:",
			StringToQuantity[{"2 Meter", "2Meter"}, Server -> False],
			{EqualP[2 Meter], EqualP[2 Meter]}
		],
		Test["Parses units in plural form:",
			StringToQuantity[{"2 Meters", "2Meters"}, Server -> False],
			{EqualP[2 Meter], EqualP[2 Meter]}
		],
		Test["Parses strings without capitalization:",
			StringToQuantity[{"2 meters", "2meters"}, Server -> False],
			{EqualP[2 Meter], EqualP[2 Meter]}
		],
		Test["Parses strings with abbreviated units:",
			StringToQuantity[{"2m", "2 m"}, Server -> False],
			{EqualP[2 Meter], EqualP[2 Meter]}
		],
		Test["Parses a series of common unit abbreviations:",
			StringToQuantity[
				{
					"8 m",
					"8 s",
					"8 USD",
					"8 g",
					"8 kg",
					"8 in",
					"8 oz",
					"8 J",
					"8 Hz",
					"8 C",
					"8 \[Degree]C",
					"8 K",
					"8 \[Degree]F",
					"8 PSI",
					"8 L"
				},
				Server -> False
			],
			{
				EqualP[8 Meter],
				EqualP[8 Second],
				EqualP[8 USD],
				EqualP[8 Gram],
				EqualP[8 Kilogram],
				EqualP[8 Inch],
				EqualP[8 Ounce],
				EqualP[8 Joule],
				EqualP[8 Hertz],
				EqualP[8 Coulomb],
				EqualP[8 Celsius],
				EqualP[8 Kelvin],
				EqualP[8 Fahrenheit],
				EqualP[8 PSI],
				EqualP[8 Liter]
			}
		],
		Test["Parses a series of common compound unit abbreviations:",
			StringToQuantity[
				{
					"8 m/s",
					"8 s^-1",
					"8 USD/yr",
					"8 g/cm^3",
					"8 kg/L",
					"8 J/C",
					"8 \[Degree]C/s",
					"8 J/K",
					"8 J K^-1"
				},
				Server -> False
			],
			{
				EqualP[8 Meter / Second],
				EqualP[8 / Second],
				EqualP[8 USD / Year],
				EqualP[8 Gram / Centimeter^3],
				EqualP[8 Kilogram / Liter],
				EqualP[8 Joule / Coulomb],
				EqualP[8 Celsius / Second],
				EqualP[8 Joule / Kelvin],
				EqualP[8 Joule / Kelvin]
			}
		],
		Test["Parses a series of units with prefixes:",
			StringToQuantity[
				{
					"8 mm",
					"8 \[Mu]s",
					"8 USD",
					"8 Mg",
					"8 kg",
					"8 MJ",
					"8 nC",
					"8 mL"
				},
				Server -> False
			],
			{
				EqualP[8 Millimeter],
				EqualP[8 Microsecond],
				EqualP[8 USD],
				EqualP[8 Megagram],
				EqualP[8 Kilogram],
				EqualP[8 Megajoule],
				EqualP[8 Nano Coulomb],
				EqualP[8 Milliliter]
			}
		],
		Test["All canonical Emerald units are interpreted from ToString forms without requiring the Wolfram Server:",
			(
				(* Convert to strings *)
				emeraldUnitStrings = ToString /@ emeraldUnits;

				StringToQuantity[emeraldUnitStrings, Server -> False]
			),
			EqualP /@ emeraldUnits,
			SetUp :> {
				(* Get a list of emerald units *)
				emeraldUnits = Cases[First /@ List @@ (EmeraldUnits`Private`canonicalUnitLookup), Except[1]]
			},
			Variables :> {emeraldUnits, emeraldUnitStrings}
		],
		Test["All canonical Emerald units are interpreted from TextString forms without requiring the Wolfram Server:",
			(
				(* Convert to strings *)
				emeraldUnitStrings = TextString /@ emeraldUnits;

				StringToQuantity[emeraldUnitStrings, Server -> False]
			),
			EqualP /@ emeraldUnits,
			SetUp :> {
				(* Get a list of emerald units *)
				emeraldUnits = Cases[First /@ List @@ (EmeraldUnits`Private`canonicalUnitLookup), Except[Alternatives[1, Dozen]]]
			},
			Variables :> {emeraldUnits, emeraldUnitStrings}
		],
		Test["All prefixed canonical Emerald units are interpreted from ToString forms without requiring the Wolfram Server:",
			(
				(* Convert to strings *)
				emeraldUnitStrings = ToString /@ emeraldUnits;

				StringToQuantity[emeraldUnitStrings, Server -> False]
			),
			EqualP /@ emeraldUnits,
			SetUp :> {
				(* Get a list of emerald units *)
				emeraldUnits = Cases[First /@ List @@ (EmeraldUnits`Private`canonicalPrefixedUnitLookup), Except[1]]
			},
			Variables :> {emeraldUnits, emeraldUnitStrings}
		],
		Test["All prefixed canonical Emerald units are interpreted from TextString forms without requiring the Wolfram Server:",
			(
				(* Convert to strings *)
				emeraldUnitStrings = TextString /@ emeraldUnits;

				StringToQuantity[emeraldUnitStrings, Server -> False]
			),
			EqualP /@ emeraldUnits,
			SetUp :> {
				(* Get a list of emerald units *)
				emeraldUnits = Cases[First /@ List @@ (EmeraldUnits`Private`canonicalPrefixedUnitLookup), Except[Alternatives[1, Dozen]]]
			},
			Variables :> {emeraldUnits, emeraldUnitStrings}
		],
		Test["Custom hard-coded units are converted:",
			StringToQuantity[{"2\"", "2 \"", "3'", "3 '", "150 sqft", "150sqft", "10 Centipoises"}],
			{EqualP[2 Inch], EqualP[2 Inch], EqualP[3 Foot], EqualP[3 Foot], EqualP[150 Foot^2], EqualP[150 Foot^2], EqualP[10 Centipoise]}
		]
	}
];
